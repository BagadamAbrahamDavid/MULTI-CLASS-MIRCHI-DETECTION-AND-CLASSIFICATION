function result=multi_svmtest(TestSet,mdel,NC)
for j = 1:NC
    [~,score] = predict(mdel{j},TestSet);
    Scores(:,j) = score(:,2); 
end 
dx=find(Scores>0);
result=dx;
    