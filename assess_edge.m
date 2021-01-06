function assess_edge = assess_edge(dij, dx, dy, dx2, dy2)

    d1 = min_val(dx, dy); 
    d2 = max_val(dx, dy);
    d3 = min_val(dx2, dy2); 
    d4 = max_val(dx2, dy2);

    if dij <= d1 % No correction
        assess_edge = 0;
    elseif dij > d1 && dij <= d2 && dij <= d3 && dij <= d4 % Case 1
        assess_edge = 1;
    elseif dij >= d1 && dij >= d2 && dij <= d3 && dij <= d4 % Case 2
        assess_edge = 2;
    elseif dij >= d1 && dij >= d3 && dij <= d2 && dij <= d4 % Case 2
        assess_edge = 2;
    elseif dij >= d1 && dij >= d2 && dij >= d3 && dij <= d4 % Case 3
        assess_edge = 3;
    end
end