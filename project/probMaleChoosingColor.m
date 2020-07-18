function val = probMaleChoosingColor( index, preferences )

    classConditional = preferences(index ,1)/sum(preferences(:,1));
    probMale = sum(preferences(:,1))/(sum(preferences(:,1)) +sum(preferences(:,2)));
    probColor = (preferences(index ,1 ) + preferences(index ,2 ))/ ...
        (sum(preferences(:,1)) +sum(preferences(:,2)));
    val = classConditional * probMale / probColor;

end