clc
clear all
close all
warning off;
F=fullfile('SEL_IMAGES');
categories = {'C1','C2','C3','C4'};
m = imageDatastore(fullfile(F,categories), 'LabelSource', 'foldernames');
sz=size(m.Files)
SP=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1;0 0];
se=strel('octagon',6);
h=waitbar(0,'Please wait the system is training ...');
for ii=1:sz(1)   
    str=m.Files{ii};
    grp(ii)=double(m.Labels(ii));
    I=imread(str);
    I=imresize(I,[512,512]);
    L=rgb2lab(I);
    J=mat2gray(L(:,:,1));

    %J=I(:,:,3);
    E=entropy(J);
    X=reshape(J,[size(J,1)*size(J,2),1]);
    [idx,cc] = kmeans(X,3);
    kdx=find(min(cc)==cc);
    D=reshape(idx,size(J));
    R=zeros(size(J));
    dx=find(D==kdx);
    R(dx)=1;
    RF=imclose(R,se);
    RIMG=RF.*double(I(:,:,1));
     figure,imshow(RIMG,[]);
%     title(['Entropy',num2str(E)]);
    %==========================
   [GLFV,CFV,HL]=my_fvtrvect(mat2gray(RIMG));
    FVT(ii,:)=[GLFV CFV HL'];
waitbar(ii/sz(1))
    
end
close(h)
[m1, n1]=multi_svmtrain(FVT,grp);

save m1 m1
save n1 n1



