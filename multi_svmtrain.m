function [mdels numClasses]=multi_svmtrain(TrainingSet,GroupTrain)
u=unique(GroupTrain);
numClasses=length(u);
for k=1:numClasses
    %Vectorized statement that binarizes Group where 1 is the current class and 0 is all other classes
    G=double((GroupTrain==u(k)));
    mdels{k}=fitcsvm(TrainingSet,G);
end