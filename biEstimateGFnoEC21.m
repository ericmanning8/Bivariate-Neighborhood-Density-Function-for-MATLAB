%Bivariate estimation of GF L(d) with NO edge corrections

function gfl_21 = biEstimateGFnoEC21(gfl_21, x1, y1, x2, y2, t_incr, bin, n, n2, area)
    long i;
    long j;        % Counters
    
    for(i = 1:n2)
        for(j = 1:n)
            if(((abs(x2(i)-x1(j)) < t_incr) && (abs(y2(i)-y1(j)) < t_incr)))
                if((points_in_circle(x2(i), y2(i), x1(j), y1(j), t_incr) == true))
                    gfl_21(i,bin) = gfl_21(i,bin) + 1; %update value of GF 1(d)
                end
            end
             
        end
        gfl_21(i,bin) = area * (gfl_21(i,bin)/(n-1));
    end      
    
end