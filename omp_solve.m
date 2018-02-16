function [theta,At] = omp_solve(A,y,epsilon)
    N = size(A,2);
    theta = zeros(N,1);
    y = y(:);
    r = y;
    Ti = [];
    
    % norm of each column 
    norm_A = zeros(1,N);
    for j = 1:N
        norm_A(1,j) = norm(A(:,j),2);
    end 
    
    while(norm(r) > epsilon)
        
        % Normalised correlation of each col of A with r
        aj = abs((r'*A) ./ norm_A);
        [ajmax, j] = max(aj);
        Ti = [Ti j];
        At = A(:,Ti);
        s = (At' * At) \ At' * y;
        r = y - At*s;
    end
    
    theta(Ti) = s;
end
