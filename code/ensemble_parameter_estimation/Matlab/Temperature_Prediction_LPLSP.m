%% ------------------------------------------------------------------------
% STAGE 2 - Temperature prediction for new unseen input power dissipations
%
% Reduced order model for a thermal system of electronic circuit developed
% via Lumped Parameter Linear Superposition (LPLSP) method.
%
% This script loads previously estimated thermal parameters and predicts
% temperatures for new unseen power dissipation profiles.
%
% Input files:
%     Test.xlsx
%     parameters_rank_reduced.xlsx
%
% Output file:
%     output_rank_reduced.xlsx
%
% -------------------------------------------------------------------------

clear;
clc;

%% MAIN

% Load powers

[t,P,N] = load_validation_power("Test.xlsx");

fprintf('Detected %d input(s)\n',N);

% Load rectangular R (M×N) and K (M×N)

[R,K] = load_RK_param_rank_reduced("parameters_rank_reduced.xlsx");

M = size(R,1);

fprintf(['Loaded R, K matrices of size: %d temperature ' ...
         'output(s) x %d power input(s)\n'],M,N);

% Compute model temperatures

T_pred = compute_temperatures(P,t,R,K);

%% ------------------------------------------------------------------------
% Save output
% -------------------------------------------------------------------------

df_out = table(t,'VariableNames',{'t'});

for i = 1:M
    df_out.(sprintf('T%d',i)) = T_pred(i,:)';
end

writetable(df_out,'output_rank_reduced.xlsx');

fprintf('\nSaved output_rank_reduced.xlsx\n');

%% ------------------------------------------------------------------------
% Plot temperatures
% -------------------------------------------------------------------------

figure('Color','w');

hold on

for i = 1:M
    plot(t,T_pred(i,:), ...
        'LineWidth',1.5, ...
        'DisplayName',sprintf('T%d',i));
end

title('Predicted Temperatures');
xlabel('Time [s]');
ylabel('Temperature [^{\circ}C]');
grid on;
legend('show');

%% ========================================================================
% FUNCTIONS
% ========================================================================

function [t,P,N] = load_validation_power(filename)

    TBL = readtable(filename,'Sheet','Sheet1');

    % Automatically detect time and power columns.
    % It is recommended the spreadsheet headers are:
    %
    % t, P_i [P_1, P_2, P_3 ...] etc

    t = TBL.t;

    names = TBL.Properties.VariableNames;

    P_cols = startsWith(names,'P');

    P = table2array(TBL(:,P_cols))';

    N = size(P,1);

end

%% ------------------------------------------------------------------------

function [R,K] = load_RK_param_rank_reduced(filename)

    TBL = readtable(filename);

    paramNames = string(TBL.Parameter);
    values     = TBL.Value;

    % Collect parameter names:
    % R11, R21, ..., K11, K12 ...

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
    
        tokens = regexp(txt,...
            '^R_(\d+)_(\d+)$',...
            'tokens');
    
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
    
        tokens = regexp(txt,...
            '^R_(\d+)_(\d+)$',...
            'tokens');
    
        i = str2double(tokens{1}{1});
        j = str2double(tokens{1}{2});
    
        R(i,j) = R_vals(n);
    
    end

    % Fill K

    for n = 1:length(K_names)

        txt = char(K_names(n));
    
        tokens = regexp(txt,...
            '^K_(\d+)_(\d+)$',...
            'tokens');
    
        i = str2double(tokens{1}{1});
        j = str2double(tokens{1}{2});
    
        K(i,j) = K_vals(n);
    
    end

end

%% ------------------------------------------------------------------------
% Thermal Model - Same as the one in Parameter Estimation Stage

function T_pred = temperature_model(P,t,R_row,K_row,T0)

    % Parameters:
    %
    % P      : Input power dissipation (W)
    % t      : Time vector (s)
    % R_row  : Thermal resistance coupling coefficients between
    %          each source and monitor point
    % K_row  : Time constant coupling coefficients between
    %          each source and monitor point
    % T0     : Ambient or reference temperature
    %
    % Output:
    % Predicted temperature profile
    t = t(:)';
    
    [n_inputs,t_len] = size(P);

    T_out = zeros(1,t_len);

    % Process contribution from each power source

    for j = 1:n_inputs

        Rj = R_row(j);
        Kj = K_row(j);

        % Create a local copy because we modify the first sample.
        % The first sample is forced to zero as the initial value
        % is not interpreted as a temperature step.

        Pj = P(j,:);
        Pj(1) = 0;

        % Detect indices where the input power changes.
        % If the power is constant, the temperature curve
        % has a first order response.
        %
        % If it varies then we have a summation of several
        % first order responses.

        idx_list = find(diff(Pj) ~= 0) + 1;

        if isempty(idx_list)
            continue;
        end

        % Convert power to temperature response

        TC = Pj .* Rj;

        % Add the temperature response
        % from every detected index change

        for idx = idx_list

            delta = TC(idx) - TC(idx-1);

            t0 = t(idx-1);

            dt = t(idx:end) - t0;

            % First order response - LPLSP.
            % Applied to all future time points at
            % the same time (vectorized computation)

            T_out(idx:end) = ...
                T_out(idx:end) + ...
                delta .* ...
                (1 - exp(-Kj .* dt));

        end

    end

    T_pred = T0 + T_out;

end

%% ------------------------------------------------------------------------
% Pass the saved R, K along with new input power P
% to the model and predict temperature

function T_pred = compute_temperatures(P,t,R,K)

    M = size(R,1);

    T_pred = zeros(M,length(t));

    T0 = 20;

    for i = 1:M

        T_pred(i,:) = temperature_model( ...
            P,...
            t,...
            R(i,:),...
            K(i,:),...
            T0);

    end

end