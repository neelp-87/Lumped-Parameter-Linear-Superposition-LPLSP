function [R,K] = unpack_rank_factors(theta,n_temps,n_inputs,r)

    idx = 1;

    % Extract A

    A = reshape(theta(idx:idx+n_temps*r-1),n_temps,r);

    idx = idx + n_temps*r;

    % Extract B

    B = reshape(theta(idx:idx+n_inputs*r-1),n_inputs,r);

    idx = idx + n_inputs*r;

    % Extract C

    C = reshape(theta(idx:idx+n_temps*r-1),n_temps,r);

    idx = idx + n_temps*r;

    % Extract D

    D = reshape(theta(idx:idx+n_inputs*r-1),n_inputs,r);

    % Reconstruct R,K

    R = A * B';
    K = C * D';

end
