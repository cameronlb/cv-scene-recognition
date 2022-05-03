function test_labels = knn_classify(train_image_feats, train_labels, test_image_feats, k, nsmethod, selectionmethod, average_method)
%     majorityvote = classify_instance(train_image_feats, train_labels, test_image_feats(420, :), 5, "euclidean", "majorityvote", "mean")
%     averageminimumdistance_mean = classify_instance(train_image_feats, train_labels, test_image_feats(69, :), 5, "euclidean", "averageminimumdistance", "mean")
%     averageminimumdistance_median = classify_instance(train_image_feats, train_labels, test_image_feats(69, :), 5, "euclidean", "averageminimumdistance", "median")
%     weightedmajorityvote_mean = classify_instance(train_image_feats, train_labels, test_image_feats(69, :), 5, "euclidean", "weightedmajorityvote", "mean")
%     weightedmajorityvote_median = classify_instance(train_image_feats, train_labels, test_image_feats(69, :), 5, "euclidean", "weightedmajorityvote", "median")
    
    test_labels = [];
    parfor i = 1:size(test_image_feats, 1)
        test_labels = vertcat(test_labels, classify_instance(train_image_feats, train_labels, test_image_feats(i, :), k, nsmethod, selectionmethod, average_method));       
    end
end

function label = classify_instance(train_image_feats, train_labels, test_image_feat, k, nsmethod, selectionmethod, average_method)
    [distances, indexes] = pdist2(train_image_feats, test_image_feat, nsmethod, "smallest", k);
    labels = categorical(train_labels(indexes));
    unique_labels = categories(labels);
    counts = countcats(labels);
%     unique_labels
%     counts
%     get_average_distances(labels, unique_labels, distances, average_method)
    
    switch(lower(selectionmethod))
        case 'majorityvote'
            label = get_biggest_label(counts, unique_labels);

        case 'averageminimumdistance'
            dists = get_average_distances(labels, unique_labels, distances, average_method);
            [~, smallest_index] = min(dists) ;
            label = unique_labels(smallest_index);

        case 'weightedmajorityvote'
            label = get_biggest_label(times(counts, subtract_by_smallest(get_average_distances(labels, unique_labels, distances, average_method))), unique_labels);
         
        otherwise
            throw(MException("knn_classify:badarg", "Value for arg 'selectionmethod' must be equal to 'majorityvote', 'averageminimumdistance' or 'weightedmajorityvote'"))
    end
end

function label = get_biggest_label(vec, unique_labels)
    [~, biggest_index] = max(vec);
    label = unique_labels(biggest_index);
end

function average_distances = get_average_distances(labels, unique_labels, distances, average_method)
    average_distances = [];
    for i = 1:size(unique_labels)
        switch lower(average_method)
            case 'mean'
                average_distances = vertcat(average_distances, mean(distances(find(labels==unique_labels(i)))));
            case 'median'
                average_distances = vertcat(average_distances, median(distances(find(labels==unique_labels(i)))));
            otherwise
                throw(MException("knn_classify:badarg", "Value for arg 'average_method' must be equal to 'mean' or 'median'"))
        end
    end   
end

function newvec = subtract_by_smallest(vec)
    newvec = abs(vec - max(vec));
end
