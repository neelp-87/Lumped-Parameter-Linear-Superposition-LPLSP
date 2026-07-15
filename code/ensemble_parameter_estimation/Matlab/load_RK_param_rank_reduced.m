function [R,K] = load_RK_param_rank_reduced(filename)

    TBL = readtable(filename);

    paramNames = string(TBL.Parameter);
    values     = TBL.Value;

    % Read parameter names: R11, R21, ..., K11, K12 ...

    R_mask = startsWith(paramNames,"R");
    K_mask = startsWith(paramNames,"K");

    R_names = paramNames(R_mask);
    R_vals  = values(R_mask);

    K_names = paramNames(K_mask);
    K_vals  = values(K_mask);

    % Infer matrix size

    max_i = 0;
    max_j = 0;

    for n = 1:length(R_names)

        txt = char(R_names(n));
    
        tokens = regexp(txt,'^R_(\d+)_(\d+)$','tokens');
    
        i = str2double(tokens{1}{1});
        j = str2double(tokens{1}{2});
    
        max_i = max(max_i,i);
        max_j = max(max_j,j);
    
    end

    M = max_i;
    N = max_j;

    R = zeros(M,N);
    K = zeros(M,N);

    % Fill R

    for n = 1:length(R_names)

        txt = char(R_names(n));
    
        tokens = regexp(txt,'^R_(\d+)_(\d+)$','tokens');
    
        i = str2double(tokens{1}{1});
        j = str2double(tokens{1}{2});
    
        R(i,j) = R_vals(n);
    
    end

    % Fill K

    for n = 1:length(K_names)

        txt = char(K_names(n));
    
        tokens = regexp(txt,'^K_(\d+)_(\d+)$','tokens');
    
        i = str2double(tokens{1}{1});
        j = str2double(tokens{1}{2});
    
        K(i,j) = K_vals(n);
    
    end

end