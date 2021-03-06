function intervals = point_process2interval(streams_pp, category_list, is_event)
% This is a supportive function that re-format time series matrix to
% prepare for visualization.

[~, dim] = size(streams_pp);
intervals = cell(1, dim);
 
 for dimidx = 1:dim
     stream_one = streams_pp(:, dimidx);
     if is_event
         mask_continue = [true; stream_one(2:end, 1) ~= stream_one(1:end-1, 1)];
         indices = find(mask_continue);
         intervals_one = [indices(1:end-1, 1) (indices(2:end, 1)) stream_one(indices(1:end-1))];
     else
         indices = find(stream_one);
         intervals_one = [indices indices+0.01 stream_one(indices)];
     end

     if exist('category_list', 'var')
         intervals_one = intervals_one(ismember(intervals_one(:,3), category_list), :);
     end
     intervals{dimidx} = intervals_one;
 end
 
 if dim < 2
     intervals = intervals{1};
 end