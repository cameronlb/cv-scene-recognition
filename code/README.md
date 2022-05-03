# Running the program

The default dataset has an inconsistant naming scheme for areas. The naming scheme we use is lower case with no spaces:

```
categories = {'kitchen', 'store', 'bedroom', 'livingroom', 'house', ...
       'industrial', 'stadium', 'underwater', 'tallbuilding', 'street', ...
       'highway', 'field', 'coast', 'mountain', 'forest'};
```

# Notes on parameters

The best parameters we found from experimentation are the defaults in `coursework_starter.m`.

- `get_tiny_images_2()` has four arguments: Vector of image paths, number of vertical pixels to resize to, the resizing method (must be equal to `"distort"` or `"crop"`) and the colour space to use (must be equal to `"grayscale"` or `"rgb"`)
- `get_colour_histograms()` has three arguments: Vector of image paths, the colour space to use (must be equal to `"grayscale"` or `"rgb"`), and the number of bins to use
- `knn_classify()` has seven arguments: Matrix of training features, a corrisponding vector of labels, a matrix of test features, a value of `k` (number of nearest neighbors to consider), a distance metric to be put into `pdist2()`, a selection method (voting algorithm) which must be equal to `"majorityvote"`, `"averageminimumdistance"`, or `"weightedmajorityvote"`, finally an averaging method, which must be equal to `"mean"` or `"median"`.

# Parameter evaluation

The results from all the parameter evaluation we did is in the folder `results_csv/`
