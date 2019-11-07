/*******************************
      Lab 3 Assignment
      Geographic Data Types
      Ryan McWay
      11/3/2019
*******************************/
var point = /* color: #ff0000 */ee.Geometry.MultiPoint(),
    SFN = ee.FeatureCollection("users/dsaah/USF_GEE_CLASS/LAB2_SF_neighborhoods"),
    line = /* color: #98ff00 */ee.Geometry.LineString(
        [[-122.45229222223492, 37.777555364862536],
         [-122.44864441797466, 37.77779280501006]]),
    geometry = /* color: #0b4a8b */ee.Geometry.MultiPoint(),
    ports = ee.FeatureCollection("users/ryan_mcway/port_cities"),
    VIIRS = ee.ImageCollection("NOAA/VIIRS/DNB/MONTHLY_V1/VCMSLCFG"),
    DMSP = ee.ImageCollection("NOAA/DMSP-OLS/CALIBRATED_LIGHTS_V4"),
    viirs_param = {"opacity":1,"bands":["avg_rad"],"min":1.1346594122052194,"max":50.56581116944552,"gamma":1},
    dmsp_param = {"opacity":1,"bands":["avg_vis"],"min":143.3107421875,"max":1289.7966796875,"gamma":1};

/*******************************
  Part 1: Vector Geometries
*******************************/
 
// Creating a Point
var point = ee.Geometry.Point([-122.4500465966978,37.775544038060275]);
Map.addLayer(point, {}, "Point", 0);

// Creating a Polyline
var line = ee.Geometry.LineString( [[-122.45244985597515, 37.776222454915796],
                                    [-122.44897371309185, 37.77645989934444]]);
Map.addLayer(line, {}, "Line", 0);

// Creating a Polygon
var polygon = ee.Geometry.Polygon([[-122.4530721284666, 37.77673126347192],
                                    [-122.45264297502422, 37.77496737883827],
                                    [-122.44871622102642, 37.775577959050906],
                                    [-122.44912391679668, 37.77725702863432]]);
Map.addLayer(polygon, {'color':'red'}, "Polygon", false);

/*******************************
  Part 2: Features
*******************************/
// Geometries that have associated properties
// Vector datasets catalog: https://developers.google.com/earth-engine/vector_datasets

// Adding Tiger Data
var tiger = ee.FeatureCollection('TIGER/2010/Blocks');
Map.addLayer(tiger, {'color':'black'}, "Tiger", false);

// Go and import USF.kml into fusion table
var usf_building = ee.FeatureCollection('ft:1JOHg6Prdu2-DqZSK9oa9zrUGyDVf7dIWu68cIdBI');
Map.addLayer(usf_building, {'color':'green'}, "usfBuilding", 0);

// Go and Import Shapefile (This takes a long time: 5mins)
var sf_neighborhoods = ee.FeatureCollection(SFN);
// var sfNeighborhoods = ee.FeatureCollection('users/dsaah/USF_GEE_CLASS/LAB2_SF_neighborhoods');
Map.addLayer(sf_neighborhoods, {'color':'blue'}, "sfNeighborhoods", 0);

/*******************************
  Part 3: Feature Visualization
*******************************/

// Change Look of feature with draw function
var BRP = ee.FeatureCollection(point);
Map.addLayer(BRP.draw({'color':'red', strokeWidth: 14}), {}, "BRP", 0);

// Viz just of polygon outline
var usf_building_outline = ee.Image().toByte()
                            .paint({featureCollection: usf_building.geometry(),
                                    color: "black",
                                    width: 2});

Map.addLayer(usf_building_outline, {}, "USF BUILDING OUTLINE", 0);

// Buffer Features
var buffer = ee.Feature(point).buffer(160);
Map.addLayer(buffer, {}, "buffer", 0);

/*******************************
  Part 4: Filtering Feature Collections
*******************************/

// The number of elements in the colletion
print("Number of SFN:", SFN.size());

// Filtering by Region: .filterBounds()
var sf_tiger = tiger.filterBounds(SFN);
Map.addLayer(sf_tiger, {}, "sfTiger", 0);

// filterMeadata() NAME, OPERATOR, VALUE
var housing10_75 = sf_tiger.filterMetadata({name: 'housing10',
                                          operator: 'greater_than',
                                          value: 75});
                                          
Map.addLayer(housing10_75, {'color':'Magenta'}, "housing10_75", 0);

// calculate area
var housinggt75_area = housing10_75.geometry().area();

print('housinggt75_area:', housinggt75_area);

var housing10_mean = sf_tiger.reduceColumns(
                                      {reducer: ee.Reducer.mean(), 
                                      selectors: ['housing10']
});

print('housing10_mean', housing10_mean);

/*******************************
  Part 5: Reduce Geometry
*******************************/
var srtm = ee.Image("USGS/SRTMGL1_003");

var dict = srtm.reduceRegion({
  reducer: 'mean', 
  geometry: usf_building,
  scale: 90
});

print('Mean elevation', dict);

/*******************************
  Part 6: Assignment
*******************************/
// Make a Feature Map for your project 

// 1) Describe your project
/*
  I want to look at the change in Night lights in port cities in response to cruise ship activity.
  Since night lights are a proxy for port activity, this can be seen as a measure of the correlation of cruise ship activity with economic activity/ growth in ports.
  Still need to add in the cruise ship activity data. 
*/

// 2) Make Study Area Map
// This is a global study so I wont need to limit my study area
// Adding in the port cities
print(ports);
Map.addLayer(ports, {}, 'Port Cities', 0);

// 3) Identify and Map key Datasets
// Key Datasets are DMSP and VIIRS
// Will need to combine these two datasets to get the time range I want
print(VIIRS);
Map.addLayer(VIIRS, viirs_param, 'VIIRS', 0);
print(DMSP);
Map.addLayer(DMSP, dmsp_param, 'DMSP', 0);
