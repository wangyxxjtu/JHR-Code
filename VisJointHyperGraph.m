function VisJointHypergraph(apGraphPth,siftGraphPth,output,Num_Words)
%this program build the visual joint hypergraph based on
%clustering hypergraph (global) and BoW (based on sift clsutering) hypergraph (local)

%apGraphPth--the hypergraph generated from ap clustering
%siftGraphPth--the hypergraph from BoW (based on local sift)
%Num_Words--the number of high frequency words for joint hypergraph generation 

%output--the outputpath, we save the image id in the same hyperedge


allQuery=dir(siftGraphPth);%all the query test name
for num=1:Num_Words
output1=[output,num2str(num),'\'];
mkdir(output1);
for i=3:length(allQuery)
mkdir([output1,allQuery(i).name]);
%load the global hypergraph
apHyperGraph=load([apGraphPth,allQuery(i).name,'\hyperGraph.txt']);
%local the local hypergraph
bowHyperGraph=load([siftGraphPth,allQuery(i).name,'\hyperGraph.txt']);

for j=1:size(apHyperGraph,2)
apColumn=apHyperGraph(:,j);%traverse all the global hypergrpah
imageId=find(apColumn==1);%find the images (id) in the global hypergraph
%get the visual words in these images
visWord=bowHyperGraph(imageId,:);
%get the top num most frequency visual words in these images.
KfreId=getKMostFre(visWord,num);
imageIdInEdge={};
for p=1:length(KfreId)
index=find(visWord(:,KfreId(p))==1);
% if length(index)<=1
% index=find(visWord(:,KfreId(1))==1);
% end

%if isempty(index)
%  fprintf('%d\n',j);
%  break;
%end
imageIdInEdge{p}=imageId(index);
end
save([output1,allQuery(i).name,'\',num2str(j),'.mat'],'imageIdInEdge');%save the image id of each hyperedge
end
end
end
end
%%
function idx=getKMostFre(visWord,num)
%return the top-num frequency visual words

if size(visWord,1)==1% if there is only one image, return directly
   idx=1; 
else
value=sum(visWord);
[~,idx1]=sort(-value);
idx=idx1(1:num);%get the top num frequency visual words
end
end
end
