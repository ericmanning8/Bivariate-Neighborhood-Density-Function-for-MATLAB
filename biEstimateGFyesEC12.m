%Bivariate estimation of GF L(d) with NO edge corrections (loop 1 ==> 2)

function gfl_12 = biEstimateGFyesEC12(x1, y1, x2, y2, t_incr, last_t, n, n2, bin, xmin, ymin, xmax, ymax, area)
    gfl_12 = zeros(n, bin);

    if (last_t < 0)
        last_t = 0;
    end
    
    for i = 1:n     %LOOP 1==>2
        for j = 1:n2 
            if(((abs(x1(i) - x2(j)) < t_incr) && (abs(y1(i) - y2(j)) < t_incr)))
                dij = EuclDistance(x1(i), y1(i), x2(j), y2(j)); %Distance between points
                
                if(dij <= t_incr && dij > last_t)
                    dx = dist_x(x1(i), xmin, xmax); %Distance to boundaries
                    dy = dist_y(y1(i), ymin, ymax);
                    dx2 = max_val(xmax - x1(i), x1(i) - xmin); 
                    dy2 = max_val(ymax - y1(i), y1(i) - ymin);
                    
                    method =  assess_edge(dij, dx, dy, dx2, dy2); %%Need assess_edge function!!
                    
                    if(method == 0)
                        edge_wgt = 1;
                    elseif (method == 1)
                        edge_wgt = edge_corr1(min(dx, dy), dij);    %%Need edge_corr functions 1 through 3!!
                    elseif(method == 2)
                        edge_wgt = edge_corr2(dx, dy, dx2, dy2, dij);
                    elseif(method == 3)
                        edge_wgt = edge_corr3(dx, dy, dx2, dy2, dij);
                    end
                    
                    gfl_12(i, bin) = gfl_12(i, bin) + edge_wgt;     %Update value of GF l(d)
                end
                
            end
        end
        
        if(bin == 1)
            gfl_12(i,bin) = area * (gfl_12(i,bin)/(n2-1));    %final GF L value for i at bin
        else
            gfl_12(i, bin) = gfl_12(i, bin - 1) + area * (gfl_12(i, bin) / (n2 - 1));   %final GF L value for i at bin
        end
    end
    
end

    
    