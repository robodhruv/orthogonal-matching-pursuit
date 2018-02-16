%% Parameters
H = 120;
W = 240;
Tlist = [3,5,7];
noiseMean = 0;
noiseSD = 2;
epsilon = 16;
patch = 8;
stride = 1;
%% Reconstruction method
% The matrix A for OMP is formed by aligning the code matrix along diagonal  
% of an HWxHW matrix for each frame. All the diagonal matrices are then
% concatenated. [C1| C2| ..]
% The vector b is constructed by vectorizing the noisy coded snapshot.
relMseVall2 = zeros(length(Tlist),1);
for Ti=1:length(Tlist)
    T = Tlist(Ti);
    [E_noisy,Ci,F] = coded_snapshot(H,W,T,noiseMean,noiseSD);

    x = zeros(H,W,T);
    h = H/stride - patch/stride +1;
    w = W/stride - patch/stride +1;
    normalization_mat = zeros(H,W);
    for i=1:h
        i_b = (i-1)*stride+1;
        for j=1:w
            j_b = (j-1)*stride+1;
            x(i_b:i_b+patch-1,j_b:j_b+patch-1,:)=x(i_b:i_b+patch-1,j_b:j_b+patch-1,:)...
                    + OMP_reconstruct(E_noisy(i_b:i_b+patch-1,j_b:j_b+patch-1),Ci(i_b:i_b+patch-1,j_b:j_b+patch-1,:),patch,T,epsilon);
            normalization_mat(i_b:i_b+patch-1,j_b:j_b+patch-1) = normalization_mat(i_b:i_b+patch-1,j_b:j_b+patch-1)+1;
        end
    end
    relMseVall2_img=zeros(T, 1);
    for i=1:T
        x(:,:,i) = x(:,:,i)./normalization_mat;
        output = mat2gray([x(:,:,i) F(:,:,i)]);
        figure;imshow(output);
        fname=sprintf(strcat('output', num2str(i), num2str(T), '.png'));
        imwrite(output,fname,'PNG');
        relMseVall2_img(i) = mean2((x(:,:,i)- F(:,:,i)).^2)/mean2(F(:,:,i).^2);
    end
    relMseVall2(Ti)=mean(relMseVall2_img);
end
relMseVall2
%relative mean squared increases on increasing the number of frames