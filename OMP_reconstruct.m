function x = OMP_reconstruct( E_noisy,Ci,p,T,epsilon )
% function to reconstruct each patch with 2-DCT basis

C = double(reshape(Ci,p*p,T));
y = double(E_noisy(:));
dct1dT = dctmtx(8)';
dct2dT = kron(dct1dT,dct1dT);
A = zeros(p*p,p*p*T);
for i=1:T
    A(:,(i-1)*p*p + 1 : i*p*p) = diag(C(:,i))*dct2dT;
end
theta = omp_solve(A,y,epsilon);
theta = reshape(theta,[p*p T]);
x = zeros(p*p,T);
for i=1:T
    x(:,i) = dct2dT*theta(:,i);
end
x = reshape(x,[p p T]);
end

