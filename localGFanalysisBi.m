function analysis = localGFanalysisBi(x1, y1, x2, y2, points, points2, xmin, ymin, xmax, ymax, xmin2, ymin2, xmax2, ymax2, xcol, ycol, xcol2, ycol2, sort, label, t, max_step, interval, n_simul, limit, edge_method, newset)
        testname = "Bivariate Getis and Franklin's L";
        long i;
        long j;
        float t_incr;
        long rep;             % Counters
        float gfl_12;
        float gfl_global12;
        float gfl_var12;    % Gf L(d) list
        float gfl_21;
        float gfl_global21;
        float gfl_var21;    % Gf L(d) list

        float pctDone;

        long bins;
        bins = AsymUp(max_step / t) + 1;
        if (bins * t > (max_step + t))
            bins = bins - 1;        % Make sure don't exceed max step ....
        end 
        
        gfl_12 = float(points + 1, bins + 1);
        gfl_global12 = float(bins + 1);
        gfl_var12 = float(bins + 1);
        gfl_21 =  float(points2 + 1, bins + 1);
        gfl_global21 = float(bins + 1);
        gfl_var21 = float(bins + 1);

        checkscale(max_step, xmin, xmax, ymin, ymax);

        if (sort == true)
        
            sort_points(x1, y1, points, xcol, ycol, 1);
            sort_points(x2, y2, points2, xcol2, ycol2, 1);
        end

        if (label == true)
            Label_Points(xcol, points);
        end 

        float area; area = (xmax - xmin) * (ymax - ymin);

        i = 1; t_incr = 0;

        while i <= bins
        
            pctDone = Conversion.Int((t_incr / max_step) * 100);

            Application.StatusBar = "Calculating " + testname + " " + pctDone + "% completed.";

            if ((edge_method == 1))
                calc_gfl_bi(gfl_12, gfl_21, x1, y1, x2, y2, t_incr, i, points, points2, area);
            elseif ((edge_method == 2))
                calc_gfl_ewbi(gfl_12, gfl_21, x1, y1, x2, y2, t_incr, (t_incr - t), points, points2, i, xmin, ymin, xmax, ymax, area);
            
            i = i + 1; t_incr = t_incr + t;
            end
        end

        % Correct so that L(d) = d under CSR
        for (i = 1: points)
            for (j = 1: bins)
                gfl_12(i, j) = sqrt(gfl_12(i, j) / pi);
            end
        end

        for (i = 1: points2)
            for (j = 1: bins)
                gfl_21(i, j) = sqrt(gfl_21(i, j) / pi);
            end
        end

        % Now do the Average and CI calculations for the global statistic ...
        if ((n_simul > 0 && interval == true))
            long n; 
            n = points + points2;
            long pt_set; 
            pt_set = long(n + 1);

            ave_cols_array(gfl_12, gfl_global12, points, bins);
            var_cols_array(gfl_12, gfl_var12, points, bins);

            ave_cols_array(gfl_21, gfl_global21, points2, bins);
            var_cols_array(gfl_21, gfl_var21, points2, bins);


            float buffer_gfl12; buffer_gfl12 =  float(points + 1, bins + 1);
            float ave_buffer12; ave_buffer12 =  float(bins + 1);
            float buffer_gfl21; buffer_gfl21 =  float(points2 + 1, bins + 1);
            float ave_buffer21; ave_buffer21 =  float(bins + 1);


            float all_rep_buffer12; all_rep_buffer12 = float(bins + 1, n_simul + 1);
            float all_rep_buffer21; all_rep_buffer21 = float(bins + 1, n_simul + 1);
            Initialise2d(all_rep_buffer12, -999999999, bins, n_simul);
            Initialise2d(all_rep_buffer21, -999999999, bins, n_simul);
            float x_rnd;
            float x_rnd2;
            x_rnd = float(points + 1);
            x_rnd2 = float(points2 + 1);
            float y_rnd;
            float y_rnd2;
            y_rnd =  float(points + 1);
            y_rnd2 =  float(points2 + 1);
            float xall_rnd;
            float yall_rnd;
            xall_rnd =  float(n + 1);
            yall_rnd =  float(n + 1);


            for (rep = 1: n_simul)

                % Merge the two sets for random labelling (only once as location constant over all rep)
                if (newset == false)
                    merge_sets(xall_rnd, yall_rnd, x1, y1, x2, y2, points, n); % merge for relabelling
                end

                Initialise2d(buffer_gfl12, 0, points, bins);
                Initialise2d(buffer_gfl21, 0, points2, bins);

                pctDone = Conversion.Int((rep / n_simul) * 100);
                Application.StatusBar = "Calculating " + testname + " CIs " + pctDone + "% completed.";

                % New set each rep or just relabelling?
                if (newset == true)
                    generate_bi_csr(x_rnd, y_rnd, x_rnd2, y_rnd2, xmin, ymin, xmin2, ymin2, xmax, xmax2, ymax, ymax2, points, points2);  % gen CSR with chars of points set 2
      
 
                elseif(newset == false)
                
                    rnd_label(pt_set, n, points, points2);          % assign random labels
                    split_sets(xall_rnd, yall_rnd, pt_set, x_rnd, y_rnd, x_rnd2, y_rnd2, n); % split into two
                end

                Debug.Print("generated set");

                i = 1; pctDone = 0; t_incr = 0;

                while i <= bins
                    if ((edge_method == 1))
                        calc_gfl_bi(buffer_gfl12, buffer_gfl21, x_rnd, y_rnd, x_rnd2, y_rnd2, t_incr, i, points, points2, area);
                    elseif ((edge_method == 2))
                        calc_gfl_ewbi(buffer_gfl12, buffer_gfl21, x_rnd, y_rnd, x_rnd2, y_rnd2, t_incr, (t_incr - t), points, points2, i, xmin, ymin, xmax, ymax, area);

                    i = i + 1; t_incr = t_incr + t;
                    end
                end

                % Correct so that L(d) = d under CSR
                for (i = 1: points)
              
                    for (j = 1: bins)
                        buffer_gfl12(i, j) = sqrt(buffer_gfl12(i, j) / pi);
                    end
                end

                for (i = 1: points2)
                
                    for (j = 1: bins)
                        buffer_gfl21(i, j) = sqrt(buffer_gfl21(i, j) / pi);
                    end
                end

                % Average it here across all points and add to all_rep_buffer ...
                Initialise(ave_buffer12, 0, bins); Initialise(ave_buffer21, 0, bins);
                ave_cols_array(buffer_gfl12, ave_buffer12, points, bins);
                ave_cols_array(buffer_gfl21, ave_buffer21, points2, bins);

                i = 1;
                while (i <= bins)
                
                    all_rep_buffer12(i, rep) = ave_buffer12(i);
                    all_rep_buffer21(i, rep) = ave_buffer21(i);
                    i = i + 1; t_incr = t_incr + t;
                end
            end
            
            %NEED sort_rows_array function
            
            sort_rows_array(all_rep_buffer12, bins, n_simul);
            sort_rows_array(all_rep_buffer21, bins, n_simul);

            float low_list12; low_list12 =  float(bins + 1);
            float high_list12; high_list12 =  float(bins + 1);

            float low_list21; low_list21 =  float(bins + 1);
            float high_list21; high_list21 =  float(bins + 1);

            %NEED extract_limits function
            extract_limits(all_rep_buffer12, low_list12, high_list12, bins, n_simul, limit);
            extract_limits(all_rep_buffer21, low_list21, high_list21, bins, n_simul, limit);
        end
        
        %display???
        display_gflBI(x1, y1, x2, y2, gfl_12, gfl_global12, gfl_var12, gfl_21, gfl_global21, gfl_var21, low_list12, high_list12, low_list21, high_list21, points, points2, System.Convert.ToSingle(bins), t, n_simul);
