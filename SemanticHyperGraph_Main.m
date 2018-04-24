%hte matlab program constructs the semantic hypergraph
clear all;
clc;
QueryPath='E:\QueryForTest\';%the query test path
allQuery=dir(QueryPath);

pool=parpool();
Rate=[0.01,0.02,0.05,0.1,0.2,0.5,1];%this is percent for selecting the tags generating hyperedge
for x=1:length(Rate)
parfor i=3:length(allQuery)
    feval(@SemanticHyperGraph,allQuery(i).name,Rate(x));
end
end
delete(pool);