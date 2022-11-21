function [GLFV,CFV,HL]=my_fvtrvect(I);
if size(I,3)>1
    J=rgb2gray(I);
else
    J=I;
end
J=double(J);
cc=corr2(J',J);
G=graycomatrix(uint8(J));
stats = graycoprops(G,{'contrast','Energy','homogeneity'});
cn=stats.Contrast;
hm=stats.Homogeneity;
En=stats.Energy;
sk=skewness(J(:));
kr=kurtosis(J(:));
szG=size(G);
[col,row]=meshgrid(1:szG(1),1:szG(2));
IDM=sum(G(:)./(1+(row(:)-col(:)).^2)).*1e-4;
GLFV=[cc cn hm En sk kr IDM];
%=============
[M N]=size(J);
%%%% Contrast visiblity %%%%%%
mu=mean2(J);
CV=sum(sum(abs(J-mu)./mu))/(M*N);
%%%%% spatial Frequency %%%%%
tm=[];
for i=1:M
    for j=2:N
        temp1=(I(i,j)-I(i,j-1))^2;
        tm=[tm temp1];
    end
end
RF=sqrt(sum(tm))./(M*N);
tm=[];
for i=2:M
    for j=1:N
        temp1=(I(i,j)-I(i-1,j))^2;
        tm=[tm temp1];
    end
end
CF=sqrt(sum(tm))./(M*N);
SF=sqrt(RF^2+CF^2);
%%%%  Energy of gradient %%%%%%%%%%%%
for i=2:M
    for j=1:N
        f1(i-1)=I(i,j)-I(i-1,j);
    end
end
for i=1:M
    for j=2:N
        f2(j-1)=I(i,j)-I(i,j-1);
    end
end
EOG=sum(f1.^2+f2.^2);

CFV=[CV SF EOG];
%============

SP=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1;0 0];
limg=lbp(J,SP,1,'i');
HL=imhist(mat2gray(limg));
