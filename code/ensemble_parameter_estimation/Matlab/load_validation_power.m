function [t,P,N] = load_validation_power(filename)

    TBL = readtable(filename,'Sheet','Sheet1');

    % Automatically detect time and power columns.
    % It is recommended the spreadsheet headers are: 
    % t, P_i [P_1, P_2, P_3 ...] 

    t = TBL.t;

    names = TBL.Properties.VariableNames;

    P_cols = startsWith(names,'P');

    P = table2array(TBL(:,P_cols))';

    N = size(P,1);

end