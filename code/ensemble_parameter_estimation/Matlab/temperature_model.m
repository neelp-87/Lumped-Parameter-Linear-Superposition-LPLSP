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

        % Create local copy because first sample is considered 0 as it does
        % not contribute to temperature rise

        Pj = P(j,:);
        Pj(1) = 0;

        % Detect indices where input changes

        idx_list = find(diff(Pj) ~= 0) + 1;

        if isempty(idx_list)
            continue;
        end

        % Convert power to temperature response

        TC = Pj .* Rj;

        % Add temperature response from every detected index change

        for idx = idx_list

            delta = TC(idx) - TC(idx-1);

            t_step = t(idx-1);

            dt = t(idx:end) - t_step;

            % First-order response - LPLSP

            T_out(idx:end) = T_out(idx:end)+delta.*(1 - exp(-Kj .* dt));

        end

    end

    T_pred = T0 + T_out;

end
