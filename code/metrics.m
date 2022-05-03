function a = metrics(k, nsmethod)
    data_path = '../data/';
    
    categories = {'kitchen', 'store', 'bedroom', 'livingroom', 'house', ...
           'industrial', 'stadium', 'underwater', 'tallbuilding', 'street', ...
           'highway', 'field', 'coast', 'mountain', 'forest'};
    
    abbr_categories = {'Kit', 'Sto', 'Bed', 'Liv', 'Hou', 'Ind', 'Sta', ...
        'Und', 'Bld', 'Str', 'HW', 'Fld', 'Cst', 'Mnt', 'For'};
    
    num_train_per_cat = 100; 
    
    fprintf('Getting paths and labels for all train and test data\n')
    [train_image_paths, test_image_paths, train_labels, test_labels] = ...
        get_image_paths(data_path, categories, num_train_per_cat);
    
    size = 5;
    crop_method = "distort";
    colour = "rgb";
    train_image_feats = get_tiny_images_2(train_image_paths, size, crop_method, colour);
    test_image_feats  = get_tiny_images_2(test_image_paths, size, crop_method, colour);
    
    fprintf("\n\nmajorityvote results...\n");
    tic
        predicted_categories = knn_classify(train_image_feats, train_labels, test_image_feats, k, nsmethod, "majorityvote", "median");
    toc
    
    create_results_webpage( train_image_paths, ...
                            test_image_paths, ...
                            train_labels, ...
                            test_labels, ...
                            categories, ...
                            abbr_categories, ...
                            predicted_categories);

    fprintf("\n\naverageminimumdistance mean results...\n");
    tic
        predicted_categories = knn_classify(train_image_feats, train_labels, test_image_feats, k, nsmethod, "averageminimumdistance", "mean");
    toc
    
    create_results_webpage( train_image_paths, ...
                            test_image_paths, ...
                            train_labels, ...
                            test_labels, ...
                            categories, ...
                            abbr_categories, ...
                            predicted_categories);

    fprintf("\n\naverageminimumdistance median results...\n");
    tic
        predicted_categories = knn_classify(train_image_feats, train_labels, test_image_feats, k, nsmethod, "averageminimumdistance", "median");
    toc
    
    create_results_webpage( train_image_paths, ...
                            test_image_paths, ...
                            train_labels, ...
                            test_labels, ...
                            categories, ...
                            abbr_categories, ...
                            predicted_categories);

    fprintf("\n\nweightedmajorityvote mean results...\n");
    tic
        predicted_categories = knn_classify(train_image_feats, train_labels, test_image_feats, k, nsmethod, "weightedmajorityvote", "mean");
    toc
    
    create_results_webpage( train_image_paths, ...
                            test_image_paths, ...
                            train_labels, ...
                            test_labels, ...
                            categories, ...
                            abbr_categories, ...
                            predicted_categories);

    fprintf("\n\nweightedmajorityvote median results...\n");
    tic
        predicted_categories = knn_classify(train_image_feats, train_labels, test_image_feats, k, nsmethod, "weightedmajorityvote", "median");
    toc
    
    create_results_webpage( train_image_paths, ...
                            test_image_paths, ...
                            train_labels, ...
                            test_labels, ...
                            categories, ...
                            abbr_categories, ...
                            predicted_categories);
end