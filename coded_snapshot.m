function [ E_noisy, Ci,F ] = coded_snapshot( H,W,T,noiseMean,noiseSD)
%Obtain coded snapshot with gaussian random noise

V = mmread('../cars.avi',1:T);
F = zeros(H,W,T);
E = zeros(H,W);
Ci = randi([0, 1], [H,W,T]);
for i=1:T
    F(:,:,i) = double(rgb2gray(V.frames(i).cdata(288-H+1:288,352-W+1:352,:)));
    E = E + Ci(:,:,i).*F(:,:,i);
end

noise = noiseMean + noiseSD*randn(size(E));
E_noisy = E+ noise;
figure;imshow(mat2gray(E_noisy));
end

