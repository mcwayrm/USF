/*******************************
      Lab 5 Assignment
      Geographic Data Types
      Ryan McWay
      11/19/2019
*******************************/

/*******************************
  Part 1: Spectral Indicies
*******************************/
//    a) NDVI
var image = ee.Image(landsat8
            .filterBounds(point)
            .filterDate('2015-06-01', '2015-09-01')
            .sort('CLOUD_COVER')
            .first());
var true_color = {bands: ['B4', 'B3', 'B2'], min: 0, max: 0.3};
Map.addLayer(image, true_color, 'image', 0);

var ndvi = image.normalizedDifference(['B5', 'B4']);
var veg_palette = ['purple', 'blue', 'yellow', 'green'];
Map.addLayer(ndvi, {min: -1, max: 1, palette: veg_palette}, 'NDVI', 0);

//    b) EVI
var evi = image.expression(
    '2.5 * ((NIR - RED) / (NIR + 6 * RED - 7.5 * BLUE + 1))', {
      'NIR': image.select('B5'),
      'RED': image.select('B4'),
      'BLUE': image.select('B2')
});
Map.addLayer(evi, {min: -1, max: 1, palette: veg_palette}, 'EVI', 0);

//    c) NDWI
var ndwi = image.normalizedDifference(['B5', 'B6']);
var water_palette = ['red', 'yellow', 'green', 'blue'];
Map.addLayer(ndwi, {min: -0.5, max: 1, palette: water_palette}, 'NDWI', 0);

//    d) NDBI
var ndbi = image.normalizedDifference(['B6', 'B5']);
var bare_palette = water_palette.slice().reverse();
Map.addLayer(ndbi, {min: -1, max: 0.5, palette: bare_palette}, 'NDBI', 0);

//    f) BAI
var burn_image = ee.Image(landsat8
    .filterBounds(ee.Geometry.Point(-120.083, 37.850))
    .filterDate('2013-08-17', '2013-09-27')
    .sort('CLOUD_COVER')
    .first());
Map.addLayer(burn_image, true_color, 'burn_image', 0);

var bai = burn_image.expression(
    '1.0 / ((0.1 - RED)**2 + (0.06 - NIR)**2)', {
      'NIR': burn_image.select('B5'),
      'RED': burn_image.select('B4'),
});
var burn_palette = ['green', 'blue', 'yellow', 'red'];
Map.addLayer(bai, {min: 0, max: 400, palette: burn_palette}, 'BAI', 0);

//    g) NBRT
var nbrt = burn_image.expression(
  '(NIR - 0.0001 * SWIR * Temp) / (NIR + 0.0001 * SWIR * Temp)', {
    'NIR': burn_image.select('B5'),
    'SWIR': burn_image.select('B7'),
    'Temp': burn_image.select('B11')
});
Map.addLayer(nbrt, {min: 1, max: 0.9, palette: burn_palette}, 'NBRT', 0);

//    h) NDSI
var snow_image = ee.Image(landsat8
    .filterBounds(ee.Geometry.Point(-120.0421, 39.1002))
    .filterDate('2013-11-01', '2014-05-01')
    .sort('CLOUD_COVER')
    .first());
Map.addLayer(snow_image, true_color, 'snow image', 0);

var ndsi = snow_image.normalizedDifference(['B3', 'B6']);
var snow_palette = ['brown', 'green', 'blue', 'white'];
Map.addLayer(ndsi, {min: -0.5, max: 0.5, palette: snow_palette}, 'NDSI', 0);

/*******************************
  Part 2: Linear Transforms
*******************************/
//    a) TC
var coefficients = ee.Array([
  [0.3037, 0.2793, 0.4743, 0.5585, 0.5082, 0.1863],
  [-0.2848, -0.2435, -0.5436, 0.7243, 0.0840, -0.1800],
  [0.1509, 0.1973, 0.3279, 0.3406, -0.7112, -0.4572],
  [-0.8242, 0.0849, 0.4392, -0.0580, 0.2012, -0.2768],
  [-0.3280, 0.0549, 0.1075, 0.1855, -0.4357, 0.8085],
  [0.1084, -0.9022, 0.4120, 0.0573, -0.0251, 0.0238]
]);
var tc_image = ee.Image(landsat5
    .filterBounds(point)
    .filterDate('2008-06-01', '2008-09-01')
    .sort('CLOUD_COVER')
    .first());
var bands = ['B1', 'B2', 'B3', 'B4', 'B5', 'B7'];
// Make an 1-D Array per pixel 
var array_image_1D = tc_image.select(bands).toArray();
// Make an 2-D Array per pixel, 6x1.
var array_image_2D = array_image_1D.toArray(1);
// Matrix Multiplication
var components_image = ee.Image(coefficients)
  .matrixMultiply(array_image_2D)
  // Get rid of the extra dimensions.
  .arrayProject([0])
  // Get a multi-band image with TC-named bands.
  .arrayFlatten(
    [['brightness', 'greenness', 'wetness', 'fourth', 'fifth', 'sixth']]);
var viz_params = {
  bands: ['brightness', 'greenness', 'wetness'],
  min: -0.1, max: [0.5, 0.1, 0.1]
};
Map.addLayer(components_image, viz_params, 'TC components', 0);

//    b) PCA
var bands = ['B2', 'B3', 'B4', 'B5', 'B6', 'B7', 'B10', 'B11'];
var array_image = image.select(bands).toArray();
var covar = array_image.reduceRegion({
  reducer: ee.Reducer.covariance(),
  maxPixels: 1e9
});
var covar_array = ee.Array(covar.get('array'));
var eigens = covar_array.eigen();
var eigen_vectors = eigens.slice(1, 1);
var principal_components = ee.Image(eigen_vectors)
              .matrixMultiply(array_image.toArray(1));
var pc_image = principal_components
  // Throw out an an unneeded dimension, [[]] -> [].
  .arrayProject([0])
  // Make the one band array image a multi-band image, [] -> image.
  .arrayFlatten([['pc1', 'pc2', 'pc3', 'pc4', 'pc5', 'pc6', 'pc7', 'pc8']]);

Map.addLayer(pc_image.select('pc1'), pc_viz, 'PC1', 0);
Map.addLayer(pc_image.select('pc3'), {}, 'PC3', 0);
Map.addLayer(pc_image.select('pc7'), {}, 'PC7', 0);

//    c) Spectral UnMixing
var unmix_image = image.select(['B2', 'B3', 'B4', 'B5', 'B6', 'B7']);
Map.addLayer(image, {bands: ['B5', 'B4', 'B3'], max: 0.4}, 'false color', 0);

var SX_regions = ee.FeatureCollection([ee.Feature(bare, {label: 'bare'}), 
                                    ee.Feature(water, {label: 'water'}),
                                    ee.Feature(veg, {label: 'vegetation'})]);
var chart = ui.Chart.image.regions({image: unmix_image, 
                               regions: SX_regions,
                               reducer: ee.Reducer.mean(),
                               scale: 30,
                               seriesProperty: 'label',
                               xLabels: [0.48, 0.56, 0.65, 0.86, 1.61, 2.2] , 
                              //xLabels:'label'
});
print('chart: ', chart);

var bare_mean = unmix_image
              .reduceRegion(ee.Reducer.mean(), bare, 30)
              .values();
var water_mean = unmix_image
              .reduceRegion(ee.Reducer.mean(), water, 30)
              .values();
var veg_mean = unmix_image
              .reduceRegion(ee.Reducer.mean(), veg, 30)
              .values();
var endmembers = ee.Array.cat([bare_mean, veg_mean, water_mean], 1);
var array_image = unmix_image.toArray().toArray(1);

var unmixed = ee.Image(endmembers).matrixSolve(array_image);
var unmixed_image = unmixed
                    .arrayProject([0])
                    .arrayFlatten([['bare', 'veg', 'water']]);
Map.addLayer(unmixed_image, {}, 'Unmixed', 0);

/*******************************
  Part 3: HSV Transform
*******************************/
// Convert Landsat RGB bands to HSV
var hsv = image.select(['B4', 'B3', 'B2']).rgbToHsv();

// Convert back to RGB, swapping the image panchromatic band for the value.
var rgb = ee.Image.cat([
  hsv.select('hue'), 
  hsv.select('saturation'),
  image.select(['B8'])
]).hsvToRgb();

Map.addLayer(rgb, {max: 0.4}, 'Pan-sharpened', 0);


/*******************************
  Part 4: Assignment
*******************************/

/*
  I am using the VIRIS and DMSP but both of them seem to have everything is already corrected so I am unsure how to make an index for these. I will try with the DMSP.
  I guess I could try making an index for amount of light making it through given the average cloud coverage in area
*/
var night_time = DMSP
                .filterBounds(Mexico)
                .filterDate('2010-01-01', '2011-01-01')
                .first();
Map.addLayer(night_time, {}, 'Night Time', 0);

var cloud_free_light = night_time.expression(
    'light / clouds', {
      'light': night_time.select('stable_lights'),
      'clouds': night_time.select('cf_cvg')
    });
Map.addLayer(cloud_free_light, {min: 0, max: 1, palette: veg_palette}, 'Cloud Free Light', 0);

// 2: Calculate and map a Linear Transformation that you could use for your project.  Use the comment section to justify your choice.
/*
  Can't think of how to use the Tasseled Cap, as I would need to know what coefficents to use to make an urban index
  I am going to try to do a prinicple components with all the band options to see what plays into night lights.
*/
/************************
 * WARNING:
 * My PCA sometimes runs and other times not. I talked with David and still have no idea why this is.
 * *********************/

print("night time", night_time);

var light_bands = ['avg_vis', 'stable_lights', 'cf_cvg', 'avg_lights_x_pct'];

var light_array = night_time.select(light_bands).toArray();

var covar = light_array.reduceRegion({reducer: ee.Reducer.covariance(),
                                     maxPixels: 1e9
});

var covarArray = ee.Array(covar.get('array'));

var light_eigens = covar_array.eigen();

var eigenVectors = eigens.slice(1, 1);

var principalComponents = ee.Image(eigenVectors).matrixMultiply(light_array.toArray(1));

var pcImage = principalComponents
  // Throw out an an unneeded dimension, [[]] -> [].
  .arrayProject([0])
  // Make the one band array image a multi-band image, [] -> image.
  .arrayFlatten([['pc1', 'pc2', 'pc3', 'pc4']]);

Map.addLayer(pcImage.select('pc1'), {}, 'PC', false);

Map.addLayer(pc_image.select('pc1'), {}, 'Lights PC1', 0);
Map.addLayer(pc_image.select('pc2'), {}, 'Lights PC2', 0);
Map.addLayer(pc_image.select('pc3'), {}, 'Lights PC3', 0);
Map.addLayer(pc_image.select('pc4'), {}, 'Lights PC4', 0);


// 3: Create a Chart that summarizes the results from your selected Spectral Indices on the Y-axis and the bands of your input image on the x-axis using three unique landscape regions associated with your project.

var unmix_mex = night_time.select(['avg_vis', 'stable_lights', 'cf_cvg', 'avg_lights_x_pct']);

// Need help understanding how to apply this here.
var mex_regions = ee.FeatureCollection([ee.Feature(downtown, {label: 'downtown'}), 
                                    ee.Feature(nature, {label: 'nature'}),
                                    ee.Feature(mountian, {label: 'mountian'})]);
var index_chart = ui.Chart.image.regions({image: night_time, 
                              regions: mex_regions,
                              reducer: ee.Reducer.mean(),
                              scale: 30,
                              seriesProperty: 'label',
                              xLabels: [0.25, 0.5, 0.75, 1]
});
print('Index Chart: ', index_chart);

