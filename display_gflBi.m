function display = display_gflBi(x1, y1, x2, y2, gfl_12, gfl_global12, gfl_var12, gfl_21, gfl_global21, gfl_var21, lo_gfl12, hi_gfl12, lo_gfl21, hi_gfl21, points, points2, bins, t, n_simul)
        long i;
        long j;
        long p;
        long out_col;

        % Write the local out ...
        out_sheet = "GF L(d)12";

        if (SheetExists(out_sheet) == false) %Need SheetExists function
            create_sheet(out_sheet);
        end
        
        clear_sheet(out_sheet);

        for (i = 1: points)
            for (j = 1: bins)
            
                if (i == 1)
                
                    for (p = 1: points)
                    
                        if (p == 1)
                        
                            Worksheets(out_sheet).cells(p, 1).value = "x1";
                            Worksheets(out_sheet).cells(p, 2).value = "y1";
                        end

                        Worksheets(out_sheet).cells(p + 1, 1).value = x1(p);
                        Worksheets(out_sheet).cells(p + 1, 2).value = y1(p);
                    end

                    Worksheets(out_sheet).cells(i, 4 + j).Font.Bold = true;
                    Worksheets(out_sheet).cells(i, 4 + j) = ((j - 1) * t);
                end
                Worksheets(out_sheet).cells(i + 1, 4 + j) = gfl_12(i, j);
            end
         end 

        out_sheet = "GF L(d)21";

        if (SheetExists(out_sheet) == false)
            create_sheet(out_sheet);
        end 
        clear_sheet(out_sheet);

        for (i = 1: points2)
        
            for (j = 1: bins)
            
                if (i == 1)
                
                    for (p = 1: points2)
                    
                        if (p == 1)
                       
                            Worksheets(out_sheet).cells(p, 1).value = "x2";
                            Worksheets(out_sheet).cells(p, 2).value = "y2";
                        end

                        Worksheets(out_sheet).cells(p + 1, 1).value = x2(p);
                        Worksheets(out_sheet).cells(p + 1, 2).value = y2(p);
                    end

                    Worksheets(out_sheet).cells(i, 4 + j).Font.Bold = true;
                    Worksheets(out_sheet).cells(i, 4 + j) = ((j - 1) * t);
                end
                Worksheets(out_sheet).cells(i + 1, 4 + j) = gfl_21(i, j);
            end
        end

        % now the global ...
        if (n_simul > 0)
            
            out_sheet = "Global L(d)";
            if (SheetExists(out_sheet) == false)
                create_sheet(out_sheet);
            end
            clear_sheet(out_sheet);

            Worksheets(out_sheet).cells(1, 1).value = "d";
            Worksheets(out_sheet).cells(1, 2).value = "Ave. L[d]12";
            Worksheets(out_sheet).cells(1, 3).value = "Var. L[d]12";
            Worksheets(out_sheet).cells(1, 4).value = "Low L[d]12";
            Worksheets(out_sheet).cells(1, 5).value = "High L[d]12";

            Worksheets(out_sheet).cells(1, 8).value = "d";
            Worksheets(out_sheet).cells(1, 9).value = "Ave. L[d]21";
            Worksheets(out_sheet).cells(1, 10).value = "Var. L[d]21";
            Worksheets(out_sheet).cells(1, 11).value = "Low L[d]21";
            Worksheets(out_sheet).cells(1, 12).value = "High L[d]21";

            for (i = 1: bins)
                Worksheets(out_sheet).cells(i + 1, 1).value = (i * t) - t;
                Worksheets(out_sheet).cells(i + 1, 2).value = gfl_global12(i);
                Worksheets(out_sheet).cells(i + 1, 3).value = gfl_var12(i);
                Worksheets(out_sheet).cells(i + 1, 4).value = (lo_gfl12(i));
                Worksheets(out_sheet).cells(i + 1, 5).value = (hi_gfl12(i));

                Worksheets(out_sheet).cells(i + 1, 8).value = (i * t) - t;
                Worksheets(out_sheet).cells(i + 1, 9).value = gfl_global21(i);
                Worksheets(out_sheet).cells(i + 1, 10).value = gfl_var21(i);
                Worksheets(out_sheet).cells(i + 1, 11).value = (lo_gfl21(i));
                Worksheets(out_sheet).cells(i + 1, 12).value = (hi_gfl21(i));
            end
            
        end

end