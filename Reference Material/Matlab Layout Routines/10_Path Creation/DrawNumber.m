function NumPath=DrawNumber(Number)

if Number=='1'
    NumPath=[0 0.5 0.5; 1 1.5 0];
elseif Number=='2'
    NumPath=[0 0.3 0.7 1 1 0 1; 1.2 1.5 1.5 1.2 1 0 0];
elseif Number=='3'
    NumPath=[0 1 0.5 1 1 0.75 0.25 0; 1.5 1.5 1.0 0.75 0.25 0 0 0.25];
elseif Number=='4'
    NumPath=[1 0 0.75 0.75;0.6 0.6 1.5 0];
elseif Number=='5'
    NumPath=[1 0 0 0.2 0.8 1 1 0.8 0.2 0; 1.5 1.5 0.8 1 1 0.8 0.2 0 0 0.2];
elseif Number=='6'
    NumPath=[0 0.2 0.8 1 1 0.8 0.2 0 0 0.2 0.8 1;0.6 0.8 0.8 0.6 0.2 0 0 0.2 1.3 1.5 1.5 1.3];
elseif Number=='7'
    NumPath=[0 1 1 0.5; 1.5 1.5 1.2 0];
elseif Number=='8'
    NumPath=[0.8 1 1 0.8 0.2 0 0 0.2 0.8 1 1 0.8 0.2 0 0 0.2;0.75 1 1.25 1.5 1.5 1.25 1 0.75 0.75 0.5 0.25 0 0 0.25 0.5 0.75];
elseif Number=='9'
    NumPath=[0 0.2 0.8 1 1 0.8 0.2 0 0 0.2 0.8 1;0.6 0.8 0.8 0.6 0.2 0 0 0.2 1.3 1.5 1.5 1.3]; %6
    NumPath=[0.5;0.75]-(NumPath-[0.5;0.75]);
elseif Number=='0'
    NumPath=[0 0.2 0.8 1 1 0.8 0.2 0 0 0.1;1.3 1.5 1.5 1.3 0.2 0 0 0.2 1.3 1.4]; %6
end

end