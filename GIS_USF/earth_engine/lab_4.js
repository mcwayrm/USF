/*******************************
      Lab 4 Assignment
      Geographic Data Types
      Ryan McWay
      11/12/2019
*******************************/

/*******************************
  Part 1: What's a Digital Image
*******************************/
// NAIP Image for my point (New Orleans)
var image = ee.Image(naip
            .filterBounds(point)
            .sort('system:time_start', false)
            .first());
// Print Image to Console
print('Inspect New Orleans:', image);
// Display image with default viz
Map.centerObject(point, 18);
Map.addLayer(image, {}, 'Original New Orleans', 0);
// Look at Projection of Band 0
print('Inspect Band 0 Projection: ', image.select(0).projection());

/*******************************
  Part 2: Digital Image Visualization
*******************************/
// Making Gamma Corrections to point image (Good for Lumance of image)
Map.addLayer(image.visualize({gamma: 0.5}), {}, 'gamma = 0.5', 0);
Map.addLayer(image.visualize({gamma: 0.25}), {}, 'gamma = 0.25', 0);
Map.addLayer(image.visualize({gamma: 1.5}), {}, 'gamma = 1.5', 0);

// Define a RasterSymbolizer element with '_enhance_' for a placeholder.
var histogram_sld =
  '<RasterSymbolizer>' +
    '<ContrastEnhancement><Histogram/></ContrastEnhancement>' +
    '<ChannelSelection>' +
      '<RedChannel>' +
        '<SourceChannelName>R</SourceChannelName>' +
      '</RedChannel>' +
      '<GreenChannel>' +
        '<SourceChannelName>G</SourceChannelName>' +
      '</GreenChannel>' +
      '<BlueChannel>' +
        '<SourceChannelName>B</SourceChannelName>' +
      '</BlueChannel>' +
    '</ChannelSelection>' +
  '</RasterSymbolizer>';

// Display the image with a histogram equalization stretch.
Map.addLayer(image.sldStyle(histogram_sld), {}, 'Equalized', 0);


/*******************************
  Part 3: Linear Filtering
*******************************/
// Smoothing
// Print a Uniform Kernel to see weights
print('A uniform kernel: ', ee.Kernel.square(2));

// Define square, uniform kernel
var uniform_kernel = ee.Kernel.square({
  radius: 2,
  units: 'meters',
});
// Filter image by convolve with smoothing
var smoothed = image.convolve(uniform_kernel);
Map.addLayer(smoothed, {min: 0, max: 255}, 'smoothed image', 0);

// Increased Smoothing with bigger neighborhood
var bigger_kernel = ee.Kernel.square({
  radius: 10,
  units: 'meters',
});
var more_smoothed = image.convolve(bigger_kernel);
Map.addLayer(more_smoothed, {min: 0, max: 255}, 'Even more smoothed', 0);

// Gaussian kernel to see wieghts (uses weighted average)
print('Gaussian Kernel: ', ee.Kernel.gaussian(2));

// Define square Gaussian Kernel
var gaussian_kernel = ee.Kernel.gaussian({
  radius: 2,
  units: 'meters',
});
// Convolve with Gaussian Filter
var gaussian = image.convolve(gaussian_kernel);
Map.addLayer(gaussian, {min: 0, max: 255}, 'Gaussian smoothed image', 0);

// Edge Detection
// Define Laplacian filter
var laplacian_kernel = ee.Kernel.laplacian8();
//Print Laplacian to see weights
print(laplacian_kernel);
// Convolve image by Laplacian filter
var edges = image.convolve(laplacian_kernel)
            .reproject('EPSG:26910', null, 1);
Map.addLayer(edges, {min: 0, max: 255}, 'Laplacian Filtered image', 0);

// Gradients
// Image gradient in the X and Y directions
var xy_gradient = image.select('N').gradient();
// Compute gradient magnitude
var gradient = xy_gradient.select('x').pow(2)
              .add(xy_gradient.select('y').pow(2)).sqrt()
              .reproject('EPSG:26910', null, 1);
// Compute gradient direction
var direction = xy_gradient.select('y').atan2(xy_gradient.select('x'))
                .reproject('EPSG:26910', null, 1);
// Display the Gradient Results
// Map.centerObject(point, 10);
// Map.addLayer(direction, {min: -3, max: 3, format: 'png'}, 'direction', 0);
// Map.addLayer(gradient, {min: -10, max: 50, format: 'png'}, 'gradient', 0);

// Sharpening
// 'Fat' Gaussian Kernel
var fat = ee.Kernel.gaussian({
  radius: 3,
  sigma: 3,
  magnitude: -1,
  units: 'meters'
});
// 'Skinny' Gaussian Kernel
var skinny = ee.Kernel.gaussian({
  radius: 3,
  sigma: 0.5,
  units: 'meters'
});
// Difference of Gaussians (DOG) Kernel
var DOG = fat.add(skinny);
// Add DOG filter to original image (sharpen)
var sharpened = image.add(image.convolve(DOG));
Map.addLayer(sharpened, {min: 0, max: 255}, 'Edges Enchanced', 0);

/*******************************
  Part 4: Non-Linear Filtering
*******************************/
// Median
var median = image.reduceNeighborhood({
  reducer: ee.Reducer.median(),
  kernel: uniform_kernel
});
Map.addLayer(median, {min: 0, max: 255}, 'Median', 0);

// Mode
// Create two-class image
var veg = image.select('N').gt(200);
// Display Binary Results
var binary_vis = {min: 0, max: 1, palette : ['black', 'green']};
Map.addLayer(veg, binary_vis, 'Veg', 0);
// Mode in 5x5 Neighborhood
var mode = veg.reduceNeighborhood({
  reducer: ee.Reducer.mode(),
  kernel: uniform_kernel
});
Map.addLayer(mode, binary_vis, 'mode', 0);

// Morphological Processing
// i) Dilation
var max = veg.reduceNeighborhood({
  reducer: ee.Reducer.max(),
  kernel: uniform_kernel
});
Map.addLayer(max, binary_vis, 'max', 0);
// ii) Erosion
var min = veg.reduceNeighborhood({
  reducer: ee.Reducer.min(),
  kernel: uniform_kernel
});
Map.addLayer(min, binary_vis, 'min', 0);

// iii) Opening 
// erosion then dilation
var opened  = min.reduceNeighborhood({
  reducer: ee.Reducer.max(),
  kernel: uniform_kernel
});
Map.addLayer(opened, binary_vis, 'opened', 0);

// iv) Closing
// dilation then erosion
var closed2 = max.reduceNeighborhood({
  reducer: ee.Reducer.min(),
  kernel: uniform_kernel
});
Map.addLayer(closed2, binary_vis, 'closed', 0);

/*******************************
  Part 5: Texture
*******************************/
// Standard Deviation
// Make big neighborhood (7 meters)
var big_kernel = ee.Kernel.square({
  radius: 7,
  units: 'meters'
});
// SD for neighborhood
var sd = image.reduceNeighborhood({
  reducer: ee.Reducer.stdDev(),
  kernel: big_kernel
});
Map.addLayer(sd, {min: 0, max: 70}, 'SD', 0);

// Entropy
var entropy = image.entropy(big_kernel);
Map.addLayer(entropy, {min: 1, max: 5}, 'Entropy', 0);

// Gray-Level Co-Occurence Matrices
// GLCM texture measures
var glcm_texture = image.glcmTexture(7);
// Display the 'contrast'
var contrast_vis = ({
  bands: ['R_contrast', 'G_contrast', 'B_contrast'],
  min: 40,
  max: 2000
});
Map.addLayer(glcm_texture, contrast_vis, 'Contrast', 0);

// Spatial Statistics
// Create a list of weights for a 9x9 kernel.
var list = [1, 1, 1, 1, 1, 1, 1, 1, 1];
// The center of the kernel is zero.
var centerList = [1, 1, 1, 1, 0, 1, 1, 1, 1];
// Assemble a list of lists: the 9x9 kernel weights as a 2-D matrix.
var lists = [list, list, list, list, centerList, list, list, list, list];
// Create the kernel from the weights.
// Non-zero weights represent the spatial neighborhood.
var kernel = ee.Kernel.fixed(9, 9, lists, -4, -4, false);
// Use the max among bands as the input.
var maxBands = image.reduce(ee.Reducer.max());
// Convert the neighborhood into multiple bands.
var neighs = maxBands.neighborhoodToBands(kernel);
// Compute local Geary's C, a measure of spatial association.
var gearys = maxBands.subtract(neighs).pow(2).reduce(ee.Reducer.sum())
             .divide(Math.pow(9, 2));
Map.addLayer(gearys, {min: 20, max: 2500}, "Geary's C", 0);

/*******************************
  Part 6: Resampling and Reprojection
*******************************/
// Optional

/*******************************
  Part 7: Assignment
*******************************/
var ndvi = image.normalizedDifference(['N', 'R']).rename('NDVI');
var veg2 = ndvi.gt(0.2);
// Make var called veg_cleaned where image is most commonly occuring pixel in a neighborhood radius 1 meter

var my_kernel = ee.Kernel.square({
  radius: 1,
  units: 'meters',
});

var veg_cleaned = veg2.reduceNeighborhood({
  reducer: ee.Reducer.mode(),
  kernel: my_kernel
});
Map.addLayer(veg_cleaned, binary_vis, 'Veg Cleaned', 0);
