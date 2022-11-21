% this code is for testing 
clc
clear all
close all
cd Testing
[J,P]=uigetfile('*.*','select the image');
I=imread(strcat(P,J));
cd ..
disp(['Query Image class is  ' ,J(end-4)])
tic
I=imresize(I,[512,512]);
figure,imshow(I);title('Query Image');
L=rgb2lab(I);
K=mat2gray(L(:,:,1));
T=reshape(K,[size(K,1)*size(K,2) 1]);
[dx,cc]=kmeans(T,3);
kdx=find(min(cc)==cc);
D=reshape(dx,size(K));
R=zeros(size(K));
dx=find(D==kdx);
R(dx)=1;
se=strel('octagon',6);
RF=imclose(R,se);
RIMG=RF.*double(I(:,:,1));
%figure,imshow(RIMG,[]);
%==========================
[GLFV,CFV,HL]=my_fvtrvect(mat2gray(RIMG));
FQ=[GLFV CFV HL'];
load m1
load n1
CLS=multi_svmtest(FQ,m1,n1)
toc
title(['Classified as class ', num2str(CLS(end))])