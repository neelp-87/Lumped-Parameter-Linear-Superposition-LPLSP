function err = residuals_rank(theta,t,P,T_meas,T0,n_temps,n_inputs,r)

    % Build / reconstruct R,K matrices

    [R,K] = unpack_rank_factors(theta,n_temps,n_inputs,r);

    T_pred = zeros(size(T_meas));

    % Compute temperature for all monitor nodes

    for i = 1:n_temps

        T_pred(i,:) = temperature_model(P,t,R(i,:),K(i,:),T0);

    end

    % Residual vector

    err = T_pred(:) - T_meas(:);

end