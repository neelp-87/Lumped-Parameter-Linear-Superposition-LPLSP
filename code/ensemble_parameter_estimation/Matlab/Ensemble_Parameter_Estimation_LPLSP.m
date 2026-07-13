%% ------------------------------------------------------------------------
% Reduced order model for a thermal system of electronic circuit developed
% via Lumped Parameter Linear Superposition (LPLSP) method.
%
% This code maps the heat generated at source (Watt) within the system to
% the temperature response (degree C) at any location within the system.
%
% It works seamlessly for a system with many sources and many monitor
% points, which may be present on the source or away from the source.
%
% SUMMARY OF THE CODE:
%
% This script identifies thermal coupling parameters between multiple
% power sources and multiple temperature sensors.
%
% Model:
%     Temperature = Sum of first-order thermal responses to input power
%     changes.
%
% Parameters estimated:
%     R : thermal resistance matrix
%     K : time constant matrix
%
% In most thermal systems R, K matrices have a structure where the
% nearby sensors behave similarly and thermal paths are correlated.
%
% To reduce parameter count we decompose:
%
%     R = A * B'
%     K = C * D'
%
% where:
%     A, C -> [n_temps x r]
%     B, D -> [n_inputs x r]
%
% Optimizer:
%     lsqnonlin()
%
% Input file:
%     Training.xlsx
%
% Output file:
%     parameters_rank_reduced.xlsx
%
% -------------------------------------------------------------------------

%% STAGE 1 - PARAMETER ESTIMATION

clear;
clc;

%% MAIN TRAINING SCRIPT FOR PARAMETER ESTIMATION

% 1. Load training data
% 2. Build power and temperature arrays
% 3. Define optimization settings
% 4. Estimate R and K matrices
% 5. Save identified parameters

TBL = readtable('Training.xlsx');

% Automatic identification of time vector, temperature columns,
% power columns. It is recommended the training file Training.xlsx
% has headers:
%
% t, T_1, T_2, T_3 ... , P_1, P_2, P_3 ...

t = TBL.t;

varNames = TBL.Properties.VariableNames;

T_cols = startsWith(varNames,'T');
P_cols = startsWith(varNames,'P');

% Stack measurements into matrices

T_meas = table2array(TBL(:,T_cols))';
P      = table2array(TBL(:,P_cols))';

n_temps  = size(T_meas,1);
n_inputs = size(P,1);

T0 = 20.0;

%% Rank selection

% r = 1  very compact model
% r = 2  moderate complexity
% r = 3  accurate

r = 3;

%% Number of parameters to be estimated (R + K)

n_params = (n_temps + n_inputs)*r*2;

fprintf('Rank %d model - %d parameters\n',r,n_params);

%% Initialize and bounds

% Initial guesses of 0.1 are used here for all values
% to construct parameter matrices.
%
% Lower bounds = 0
% Upper bounds = inf
%
% Ensures all estimates remain positive.

theta0 = 0.1*ones(n_params,1);

lb = zeros(size(theta0));
ub = inf(size(theta0));

%% OPTIMIZATION

fprintf('\nStart Optimization (Rank-Reduced Estimation)\n')

tic

objFun = @(theta) residuals_rank( ...
    theta,...
    t,...
    P,...
    T_meas,...
    T0,...
    n_temps,...
    n_inputs,...
    r);

options = optimoptions('lsqnonlin',...
    'Algorithm','trust-region-reflective',...
    'Display','iter',...
    'MaxFunctionEvaluations',30000,...
    'MaxIterations',1000,...
    'StepTolerance',1e-8,...
    'FunctionTolerance',1e-8);

% options = optimoptions('lsqnonlin',...
%     'Algorithm','trust-region-reflective',...
%     'UseParallel',true,...
%     'Display','iter');

theta_opt = lsqnonlin( ...
    objFun,...
    theta0,...
    lb,...
    ub,...
    options);

fprintf('\nOptimization complete in %.2f s\n',toc);

%% EXTRACT FINAL MATRICES

[R_est,K_est] = unpack_rank_factors( ...
    theta_opt,...
    n_temps,...
    n_inputs,...
    r);

disp('R_est:')
disp(R_est)

disp('K_est:')
disp(K_est)

%% SAVE PARAMETERS

rows = {};
values = [];

for i = 1:n_temps
    for j = 1:n_inputs
        rows{end+1,1} = sprintf('R_%d_%d',i,j);
        values(end+1,1) = R_est(i,j);
    end
end

for i = 1:n_temps
    for j = 1:n_inputs
        rows{end+1,1} = sprintf('K_%d_%d',i,j);
        values(end+1,1) = K_est(i,j);
    end
end

df_out = table(rows,values,...
    'VariableNames',{'Parameter','Value'});

writetable(df_out,'parameters_rank_reduced.xlsx');

fprintf('\nSaved parameters_rank_reduced.xlsx\n');

%% ========================================================================
% LOCAL FUNCTIONS
% ========================================================================

function T_pred = temperature_model(P,t,R_row,K_row,T0)

    % Parameters:
    %
    % P      : Input power dissipation (W)
    % t      : Time vector (s)
    % R_row  : Thermal resistance coupling coefficients
    % K_row  : Time constant coupling coefficients
    % T0     : Ambient temperature
    %
    % Output:
    % Predicted temperature profile

    
    t = t(:)';      % force row vector
    
    [n_inputs,t_len] = size(P);
    
    T_out = zeros(1,t_len);


    % Process contribution from each power source

    for j = 1:n_inputs

        Rj = R_row(j);
        Kj = K_row(j);

        % Create local copy because first sample
        % is not treated as a step.

        Pj = P(j,:);
        Pj(1) = 0;

        % Detect indices where input changes

        idx_list = find(diff(Pj) ~= 0) + 1;

        if isempty(idx_list)
            continue;
        end

        % Convert power to temperature response

        TC = Pj .* Rj;

        % Add temperature response
        % from every detected index change

        for idx = idx_list

            delta = TC(idx) - TC(idx-1);

            t_step = t(idx-1);

            dt = t(idx:end) - t_step;

            % First-order response - LPLSP

            T_out(idx:end) = T_out(idx:end) + ...
                delta .* ...
                (1 - exp(-Kj .* dt));

        end

    end

    T_pred = T0 + T_out;

end

% -------------------------------------------------------------------------

function [R,K] = unpack_rank_factors( ...
    theta,...
    n_temps,...
    n_inputs,...
    r)

    idx = 1;

    % Extract A

    A = reshape( ...
        theta(idx:idx+n_temps*r-1),...
        n_temps,r);

    idx = idx + n_temps*r;

    % Extract B

    B = reshape( ...
        theta(idx:idx+n_inputs*r-1),...
        n_inputs,r);

    idx = idx + n_inputs*r;

    % Extract C

    C = reshape( ...
        theta(idx:idx+n_temps*r-1),...
        n_temps,r);

    idx = idx + n_temps*r;

    % Extract D

    D = reshape( ...
        theta(idx:idx+n_inputs*r-1),...
        n_inputs,r);

    % Reconstruct R,K

    R = A * B';
    K = C * D';

end

% -------------------------------------------------------------------------

function err = residuals_rank( ...
    theta,...
    t,...
    P,...
    T_meas,...
    T0,...
    n_temps,...
    n_inputs,...
    r)

    % Build / reconstruct R,K matrices

    [R,K] = unpack_rank_factors( ...
        theta,...
        n_temps,...
        n_inputs,...
        r);

    T_pred = zeros(size(T_meas));

    % Compute temperature
    % for all monitor nodes

    for i = 1:n_temps

        T_pred(i,:) = temperature_model( ...
            P,...
            t,...
            R(i,:),...
            K(i,:),...
            T0);

    end

    % Residual vector

    err = T_pred(:) - T_meas(:);

end