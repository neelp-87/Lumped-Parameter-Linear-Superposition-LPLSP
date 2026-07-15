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


df_out = table(t,'VariableNames',{'t'});

for i = 1:M
    df_out.(sprintf('T%d',i)) = T_pred(i,:)';
end

writetable(df_out,'output_rank_reduced.xlsx');

fprintf('\nSaved output_rank_reduced.xlsx\n');

%% ------------------------------------------------------------------------
% Plot temperatures

figure('Color','w');

hold on

for i = 1:M
    plot(t,T_pred(i,:),'LineWidth',1.5,'DisplayName',sprintf('T%d',i));
end

title('Predicted Temperatures');
xlabel('Time [s]');
ylabel('Temperature [^{\circ}C]');
grid on;
legend('show');