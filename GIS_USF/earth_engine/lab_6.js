/*******************************
      Lab 6 Assignment
      Supervised Classification and Regression
      Ryan McWay
      11/26/2019
*******************************/

/*******************************
  Part 2: Regression
*******************************/
//    a) OLS
var tree = ee.Image(mod44b
          .sort('system: time_start', false)
          .first());
var percent_tree = tree.select('Percent_Tree_Cover')
          .where(tree.select('Percent_Tree_Cover').eq(200), 0);
Map.addLayer(percent_tree, {max: 100}, 'Percent Tree Cover', 0);

var l5_filtered = l5raw.filterDate('2010-01-01', '2010-12-31')
                      .filterMetadata('WRS_PATH', 'equals', 44)
                      .filterMetadata('WRS_ROW', 'equals', 34);
var landsat = ee.Algorithms.Landsat.simpleComposite({
  collection: l5_filtered,
  asFloat: true
});
Map.addLayer(landsat, {bands: ['B4', 'B3', 'B2'], max: 0.3}, 'Composite', 0);

var prediction_bands = ['B1', 'B2', 'B3', 'B4', 'B5', 'B6', 'B7'];
var training_image = ee.Image(1)
            .addBands(landsat.select(prediction_bands))
            .addBands(percent_tree);
var training = training_image.sample({
  region: l5_filtered.first().geometry(),
  scale: 30,
  numPixels: 1000
});

var training_list = ee.List(prediction_bands)
            .insert(0, 'constant')
            .add('Percent_Tree_Cover');
var regression = training.reduceColumns({
  reducer: ee.Reducer.linearRegression(8), 
  selectors: training_list
});
print('Regression: ', regression);

var coefficients = ee.Array(regression.get('coefficients'))
            .project([0])
            .toList();
var predicted_tree_cover = ee.Image(1)
            .addBands(landsat.select(prediction_bands))
            .multiply(ee.Image.constant(coefficients))
            .reduce(ee.Reducer.sum())
            .rename('predictedTreeCover');
Map.addLayer(predicted_tree_cover, {min: 0, max: 100}, 'Prediction', 0);

//    b) Non-Linear Regressions
var cart_regression = ee.Classifier.cart()
    .setOutputMode('REGRESSION')
    .train({
      features: training, 
      classProperty: 'Percent_Tree_Cover', 
      inputProperties: prediction_bands
    });
var cart_regression_image = landsat.select(prediction_bands)
    .classify(cart_regression, 'cartRegression');

Map.addLayer(cart_regression_image, {min: 0, max: 100}, 'CART Regression', 0);

/*******************************
  Part 3: Classification
*******************************/
//    a) Training Data
var training_features = bare.merge(vegetation).merge(water);

//    b) Classifier
var classifier_training = landsat.select(prediction_bands)
              .sampleRegions({
                    collection: training_features, 
                    properties: ['class'], 
                    scale: 30
              });

//    c) CART
var classifier = ee.Classifier.cart().train({
  features: classifier_training, 
  classProperty: 'class', 
  inputProperties: prediction_bands
});

//    d) Classify Image
var classified = landsat.select(prediction_bands).classify(classifier);
Export.image.toAsset(classified, {min: 0, max: 2, palette: ['red', 'green', 'blue']}, 'classified', 0);

/*******************************
  Part 4: Accuracy Assessment
*******************************/
//    a) Partition data
var training_testing = classifier_training.randomColumn();
var training_set = training_testing
              .filter(ee.Filter.lessThan('random', 0.6));
var testing_set = training_testing
              .filter(ee.Filter.greaterThanOrEquals('random', 0.6));

//    b) Train
var trained = ee.Classifier.cart().train({
  features: training_set, 
  classProperty: 'class', 
  inputProperties: prediction_bands
});

//    c) Classify
var confusion_matrix = ee.ConfusionMatrix(testing_set.classify(trained)
    .errorMatrix({
      actual: 'class', 
      predicted: 'classification'
    }));

//    d) Confusino Matrix
print('Confusion Matrix: ', confusion_matrix);
print('Overall Accuracy: ', confusion_matrix.accuracy());
print('Producers Accuracy: ', confusion_matrix.producersAccuracy());
print('Consumers Accuracy: ', confusion_matrix.consumersAccuracy());


/*******************************
  Part 5: Hyperparameter Tuning
*******************************/
// Random Forest! Add additional noise to improve result
var training_buffer = function(f) { return f.buffer(300)};
var rf_collection = training_features.map(training_buffer); 

var sample = landsat.select(prediction_bands)
                    .sampleRegions({collection: rf_collection,
                                    properties: ['class'], 
                                    scale: 30,
});

var classifier = ee.Classifier.randomForest(10).train({
  features: sample,
  classProperty: 'class',
  inputProperties: prediction_bands
});
var classified = landsat.select(prediction_bands).classify(classifier);
Map.addLayer(classified, {min: 0, max: 2, palette: ['red', 'green', 'blue']}, 'Random Forest Classified', 0);

// Hyperparamter Tuning to determine the number of trees in forest
sample = sample.randomColumn();
var train = sample.filter(ee.Filter.lt('random', 0.6));
var test = sample.filter(ee.Filter.gte('random', 0.6));
var num_trees = ee.List.sequence(5, 50, 5);
var accuracies = num_trees.map(function(t) {
  var classifier = ee.Classifier.randomForest(t)
    .train({
      features: train, 
      classProperty: 'class', 
      inputProperties: prediction_bands
    });
  return test
    .classify(classifier)
    .errorMatrix('class', 'classification')
    .accuracy();
});

print(ui.Chart.array.values({
  array: ee.Array(accuracies), 
  axis: 0,
  xLabels: num_trees
}));


/*******************************
  Part 6: Assignment
*******************************/

// Night lights image
var light_mx = DMSP.filterBounds(mexico).filterDate('2010-01-01','2011-01-01').first();
Map.addLayer(light_mx, {}, 'light', 0);

// Predictive Bands and training data
var predict_bands = ['avg_vis', 'stable_lights', 'cf_cvg', 'avg_lights_x_pct'];
var training_features_lights = cities.merge(roads).merge(nature);
var rf_collection_lights = training_features_lights;
var mx_sample = light_mx.select(predict_bands)
                    .sampleRegions({collection: rf_collection_lights,
                                    properties: ['class'], 
                                    scale: 30,
});

// Random Forest Classifier and image
var classifier_light = ee.Classifier.randomForest(10).train({
  features: mx_sample,
  classProperty: 'class',
  inputProperties: predict_bands
});
var classified_lights = light_mx.select(predict_bands).classify(classifier_light);
Map.addLayer(classified_lights, {min: 0, max: 2, palette: ['red', 'blue', 'green']}, 'Night Lights Random Forest', 0);

// Optimizing the number of trees
var light_sample = mx_sample.randomColumn();
var light_train = light_sample.filter(ee.Filter.lt('random', 0.6));
var light_test = light_sample.filter(ee.Filter.gte('random', 0.6));
var trees = ee.List.sequence(5, 50, 5);

var max_accuracy = trees.map(function(t) {
  var classifier_lights = ee.Classifier.randomForest(t)
    .train({
      features: light_train, 
      classProperty: 'class', 
      inputProperties: predict_bands
    });
  return light_test
    .classify(classifier_lights)
    .errorMatrix('class', 'classification')
    .accuracy();
});

print(ui.Chart.array.values({
  array: ee.Array(max_accuracy), 
  axis: 0,
  xLabels: trees
}));
