function T_pred = compute_temperatures(P,t,R,K)

% Pass the saved R, K along with new input power P to the model and predict 
% temperature

    M = size(R,1);

    T_pred = zeros(M,length(t));

    T0 = 20;

    for i = 1:M

        T_pred(i,:) = temperature_model(P,t,R(i,:),K(i,:),T0);

    end

end