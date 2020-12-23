%Bivariate estimation of GF L(d) with NO edge corrections

function gfl_12 = biEstimateGFnoEC12(gfl_12, x1, y1, x2, y2, t_incr, bin, n, n2, area)
  
    for i = 1:n
        for j = 1:n2
            if(((abs(x1(i)-x2(j)) < t_incr) && (abs(y1(i)-y2(j)) < t_incr)))
                if(points_in_circle(x1(i), y1(i), x2(j), y2(j), t_incr) == true)
                    gfl_12(i,bin) = gfl_12(i,bin)+1; %update value of GF 1(d)
                end
            end 
        end
        
        gfl_12(i,bin) = area * (gfl_12(i,bin)/(n2-1));
    end
 
end
