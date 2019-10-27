/*******************************
      Lab 2 Assignment
      Ryan McWay
      10/28/2019
*******************************/

/*******************************
  Part 1: Spatial Resolution
*******************************/
// Region of Interest is SFO Airport and Center to SFO point
var sfo_point = ee.Geometry.Point(-122.3774, 37.6194);
Map.centerObject(sfo_point, 16);

//     Display MODIS Aqua false-color for SFO
// Surface Reflectance Image from myd09
var modis_image = ee.Image(myd09.filterDate('2017-07-01').first());
// Create MODIS RGB Bands
var modis_bands = ['sur_refl_b01', 'sur_refl_b04', 'sur_refl_b03'];
// MODIS params
var modis_vis = {bands: modis_bands, min: 0, max: 3000};
// MODIS Image Layer
Map.addLayer(modis_image, modis_vis, 'MODIS', 0);

//      Print Pixel Size in meters
// Scale from first band's projection
var modis_scale = modis_image.select('sur_refl_b01')
          .projection().nominalScale();
print('MODIS Scale ', modis_scale);

//      MSS data
// Filter by location, date and cloudiness
var mss_image = ee.Image(mss
          .filterBounds(Map.getCenter())
          .sort('CLOUD_COVER')
          .first()); // Least Cloudy
// Display MSS in color-IR composite
Map.addLayer(mss_image,
            {bands: ['B3', 'B2', 'B1'],
              min: 0,
              max: 200},
              'MSS',
              0);
// Check Pixel Scale
var mss_scale = mss_image.select('B1')
            .projection().nominalScale();
print('MSS Scale ', mss_scale);

//        Thematic Mapper
// Filter TM by location, date and cloudiness
var tm_image = ee.Image(tm
            .filterBounds(Map.getCenter())
            .filterDate('2011-05-01', '2011-10-01')
            .sort('CLOUD_COVER')
            .first());
// Display with color-IR composite
Map.addLayer(tm_image,
            {bands: ['B4', 'B3', 'B2'],
            min: 0,
            max: 0.4},
            'TM',
            0);
// Check Pixel Scale
var tm_scale = tm_image.select('B1')
            .projection().nominalScale();
print('TM scale: ', tm_scale);

//        NAIP Agricultral Data
// NAIP images for study period and region of interest
var naip_images = naip
              .filterDate('2012-01-01', '2012-12-31')
              .filterBounds(Map.getCenter());
// Mosaic ajacent images into single image
var naip_image = naip_images.mosaic();
// Display NAIP with color-IR composite
Map.addLayer(naip_image,
              {bands: ['N', 'R', 'G']},
              'NAIP',
              0);
// Check Pixel Scale (different for a mosaic)
var naip_scale = ee.Image(naip_images.first())
              .projection().nominalScale();
print('NAIP Scale:', naip_scale);

/*******************************
  Part 2: Spectral Resolution
*******************************/
// List of MODIS bands
var modis_bands = modis_image.bandNames();
print('MODIS bands: ', modis_bands);
print('Total Number of Bands: ', modis_bands.length());

// Look into spectural resolution of other sensors
var naip_bands = naip_image.bandNames();
var mss_bands = mss_image.bandNames();
print('NAIP bands: ', naip_bands);
print('MSS bands: ', mss_bands);

/*******************************
  Part 3: Temporal Resolution
*******************************/
// Filter MODIS mosaics to a year
var modis_series = myd09.filterDate('2011-01-01', '2011-12-31');
print('MODIS Series: ', modis_series);

// Filter for year's worth of TM scenes
var tm_series = tm
              .filterBounds(Map.getCenter())
              .filterDate('2011-01-01', '2011-12-31');
print('TM Series: ', tm_series);

// Returning list of capture dates and mapping function across tm_series
var getDate = function(image) {
  // Casted argument
  var time = ee.Image(image).get('system:time_start');
  // Return time as Date
  return ee.Date(time);
};
var dates = tm_series.toList(100).map(getDate);
print('TM Series Dates: ', dates);

/*******************************
  Part 4: Radiometric Resolution
*******************************/
/*
  Not covered as it is particular and only needed when observing very subtle changes
*/

/*******************************
  Part 5: Orbits and Sensor Motion
*******************************/
// Agua Image
var aqua_image = ee.Image(myd09
                .filterDate('2013-09-01')
                .first());
// Zoom Global Level
Map.setCenter(81.04, 0, 3);
// Display Senor-Zenith Angle of Aqua image
var sz_params = {bands: 'SensorZenith', min: 0, max: 70*100};
Map.addLayer(aqua_image, 
            sz_params, 
            'Agua Senor-Zenith Angle', 
            0);

// Aqua Orbit
var aqua_orbit = ee.FeatureCollection('ft:1ESvPygQ76WvVflKMN2nc14sS2wwtzqv3j2ueTqg');
Map.addLayer(aqua_orbit, {color: 'FF0000'}, 'Aqua Positions', 0);
// Compare to Landsat Obrit
var landsat_7 = ee.ImageCollection('LANDSAT/LE7')
            .filterDate('2013-09-01', '2013-09-02');
Map.addLayer(landsat_7, {bands: 'B1', palette: 'blue'}, 'Landsat 7 Scenes', 0);

/*******************************
  Part 6: Assignment
*******************************/

