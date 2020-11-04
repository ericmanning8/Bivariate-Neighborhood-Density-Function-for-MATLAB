%Bivariate estimation of GF L(d) with NO edge corrections (loop 2 ==> 1)

function gfl_21 = biEstimateGFyesEC21(x1, y1, x2, y2, t_incr, last_t, n, n2, bin, xmin, ymin, xmax, ymax, area)

    double i;
    double j;        % Counters.
    double k;        % k(t) at length scale t_incr
    double dx;
    double dy;
    double dx2;
    double dy2;
    double dij;        % dist to boundary buffers.
    double edge_wgt;
    double method;        % Edge correction factor.
    
    if(last_t < 0)
        last_t = 0;
    end
    
    for(i = 1:n2) %LOOP 2==>1
        for(j = 1:n)
            if(((abs(x2(i) - x1(j)) < t_incr) && (abs(y2(i) - y1(j)) < t_incr)))
                dij = EuclDistance(x2(i), y2(i), x1(j), y1(j)); %Distance between points
                
                if(dij <= t_incr && dij > last_t)
                    dx = dist_x(x2(i), xmin, xmax); %Distance to boundaries
                    dy = dist_y(y2(i), ymin, ymax);
                    dx2 = max_val(xmax - x2(i), x2(i) - xmin); 
                    dy2 = max_val(ymax - y2(i), y2(i) - ymin);
                    
                    method =  assess_edge(dij, dx, dy, dx2, dy2); %%Need assess_edge function!!
                    
                    if(method == 0)
                        edge_wgt = 1;
                    end
                    
                    if(method == 1)
                        edge_wgt = edge_corr1(min(dx, dy), dij);    %%Need edge_corr functions!!
                    end
                    
                    if(method == 2)
                        edge_wgt = edge_corr2(dx, dy, dx2, dy2, dij);
                    end
                    
                    if(method == 3)
                        edge_wgt = edge_corr3(dx, dy, dx2, dy2, dij);
                    end
                    
                    gfl_21(i, bin) = gfl_21(i, bin) + edge_wgt;     %Update value of GF l(d)
                end
                
            end
        end
        
        if(bin == 1)
            gfl_21(i, bin) = area * (gfl_21(i, bin) / (n - 1));    %final GF L value for i at bin
        else
            gfl_21(i, bin) = gfl_21(i, bin - 1) + area * (gfl_21(i, bin) / (n - 1));   %final GF L value for i at bin
        end
        
    end
end

    
    