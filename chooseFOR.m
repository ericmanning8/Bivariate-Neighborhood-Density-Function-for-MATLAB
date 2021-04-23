function method2 = chooseFOR()

    choice = questdlg('Select between GFL12 and GFL21',...
        'Perspective',...
        'GFL12','GFL21','Cancel','Cancel');
    if (choice == "GFL12")
        method2 = 1;
    elseif (choice == "GFL21")
        method2 = 0;
    elseif (choice == "Cancel") 
        method2 = -1;
    end
    
    return;

end