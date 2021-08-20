function fparams  = parseElements( el )
% No input: Returns fparams elemental data from z=1-95
% If input is a number or array of numbers, input selects elements by Z
    t = readtable('elements.csv');
    
    f = table2struct(t(el,30:41));
    
    fparams.a = [f.a1, f.a2, f.a3];
    fparams.b = [f.b1, f.b2, f.b3];
    fparams.c = [f.c1, f.c2, f.c3];
    fparams.d = [f.d1, f.d2, f.d3];
    
end
