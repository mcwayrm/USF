var san_francisco = /* color: #d6422f */ee.Geometry.Point([-122.41665731201175, 37.77373276523463]),
    landsat = ee.ImageCollection("LANDSAT/LC08/C01/T1"),
    blue_world = {"opacity":1,"bands":["B9","B8","B7"],"min":5015,"max":15827,"gamma":1},
    toa = ee.ImageCollection("LANDSAT/LC08/C01/T1_TOA"),
    sr = ee.ImageCollection("LANDSAT/LC08/C01/T1_SR"),
    sr_params = {"opacity":1,"bands":["B5","B10","B11"],"min":11,"max":4158,"gamma":1};
    
/*******************************
  Part 1: Searching Landsat Imagery
*******************************/

var image = ee.Image(landsat
  // Filter for year 2014
  .filterDate('2014-01-01', '2014-12-31')
  // Filter for only SF
  .filterBounds(san_francisco)
  // Sort by cloud coverage
  .sort('CLOUD_COVER')
  // Casting the first image
  .first());
// Display the Image
print('A Landsat scene:', image); // Got me some of that JSON!!

/*******************************
  Part 2: Visualizing Landsat Imagery
*******************************/

// Creating the params
var true_color = {
  bands: ['B4','B3', 'B2'],
  min: 4000,
  max: 12000
};
// Adding Image 'true color' layer
Map.addLayer(image, true_color, 'True-color Image');

// Creating NIR params
var false_color = {
  bands: ['B5','B4', 'B3'],
  min: 4000,
  max: 13000
};
// Adding Image 'false color' layer
Map.addLayer(image, false_color, 'False-color Composite');

// Blue his house, with a blue little window, and a blue corvette and everything about his blue, like him, inside and outside
Map.addLayer(image, blue_world, 'Blue-world Composite');

/*******************************
  Part 3: Plot at-sensor radiance
*******************************/

// Array of select bands 
var bands = ['B1', 'B2', 'B3', 'B4', 'B5', 'B6', 'B7', 'B10', 'B11',];
// Limit image to these bands
var dn_image = image.select(bands);
// Transform to radiance
var radiance = ee.Algorithms.Landsat.calibratedRadiance(dn_image);
// Creating Radiance params
var rad_params = {bands: ['B4', 'B3', 'B2'], 
                  min: 0, 
                  max: 100};
Map.addLayer(radiance, rad_params, 'Radiance Composite');
/*
  Inspecting points of this layer shows that solar irradiance is reflected, but that thermal is not.
*/

/*******************************
  Part 4: Plot top-of-atmosphere (TOA) reflectance
*******************************/

var toa_image = ee.Image('LANDSAT/LC08/C01/T1_TOA/LC08_044034_20141012');
var toa_image_2 = ee.Image(toa
  // Filter for year 2014
  .filterDate('2014-01-01', '2014-12-31')
  // Filter for only SF
  .filterBounds(san_francisco)
  // Sort by cloud coverage
  .sort('CLOUD_COVER')
  // Casting the first image
  .first());
// Display the Image
print('A Landsat TOA scene:', toa_image_2);
// Creating TOA params
var toa_params = {
  bands: ['B4','B3', 'B2'],
  min: 0,
  max: 0.3
};
Map.addLayer(toa_image, toa_params, 'TOA');
var toa_params_2 = {
  bands: ['B4','B3', 'B2'],
  min: 0,
  max: 1
};
Map.addLayer(toa_image_2, toa_params_2, 'My TOA'); // So they are the same even after filtering

// Limiting TOA removes thermal brightness
var toa_limited = toa_image.select('B[0-9]');
Map.addLayer(toa_limited, toa_params_2, 'Limited TOA');


// Make a point in GG Park
var gg_park = ee.Geometry.Point([-122.4860, 37.7692]);
// Create Reflectance bands of B1-B7
var relective_bands = bands.slice(0,7);
// http://landsat.usgs.gov/band_designations_landsat_satellites.php
var wavelengths = [0.44, 0.48, 0.56, 0.65, 0.86, 1.61, 2.2];
// Limit TOA to reflectance bands
var reflectance_image = toa_image.select(relective_bands);
// Creating chart params
var chart_options = {
  title: 'Landsat 8 TOA spectrum for Golden Gate Park',
  hAxis: {title: 'Wavelength (mm)'},
  vAxis: {title: 'Reflectance'},
  lineWidth: 1,
  pointSize: 4
};
// Make Reflectance Chart, use 30 meter pixel
var reflectance_chart = ui.Chart.image.regions(
  reflectance_image, gg_park, null, 30, null, wavelengths)
  .setOptions(chart_options);
print(reflectance_chart);

/*******************************
  Part 5: Plot surface reflectance (SR)
*******************************/

// Surface Reflectance
var sr_image = ee.Image(sr
  // Same filter as original image
  .filterDate('2014-01-01', '2014-12-31')
  .filterBounds(san_francisco)
  .sort('CLOUD_COVER')
  .first());
// Display the Image
print('A Landsat SR scene:', sr_image);
Map.addLayer(sr_image, sr_params, 'Surface Reflectance');


/*******************************
  Part 6: Assignment
*******************************/
// Assignment is done in assignment_lab_1.js
