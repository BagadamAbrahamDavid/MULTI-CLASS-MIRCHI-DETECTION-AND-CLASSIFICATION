clc
clear all
close all;
F=fullfile('TESTING');
categories = {'C1','C2','C3','C4'};
m = imageDatastore(fullfile(F,categories), 'LabelSource', 'foldernames');
sz=size(m.Files,1);
load m1
load n1
it=0;
for ii=1:sz

    str=m.Files{ii};
    I=imread(str);
    fd=find(46==double(str));
    JS=str2num(str(fd-1))
I=imresize(I,[512,512]);
L=rgb2lab(I);
K=mat2gray(L(:,:,1));
T=reshape(K,[size(K,1)*size(K,2) 1]);
[dx,cc]=kmeans(T,4);
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
CLS=multi_svmtest(FQ,m1,n1);
if numel(CLS)>1
if isequal(CLS(end),JS)
    it=it+1;    
end
else
    it=it+1;
end
end
acc=it/sz*100
