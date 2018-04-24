%this program conduct the adaptative hypergraph learning process
%based on our final hypergraph

clc;
clear all;
close all;
hyperGraph='D:\JHR_SemanticHyperGraph\';%the semantic hypergraph path
hyperPth_vis='D:\JHR_fuseHypergraph\';%joint visual hypergraph path
predoGt='D:\P_RelevanceFeedback\';%the pseudo-relevance feedback for query test

output='D:\JHR\ReleScore\';%the output path, save the obtained relevance score
MAX_ITER=20;%the iteration number
mkdir(output);
allParam=dir(hyperPth_vis);%visual hypergrap name under all the parameter (different frequency of visual words)
allQuery=dir(hyperGraph);%all the query name
Mu=[0.01,0.02,0.05,0.1];%the hyperparameter in hypergraph learning
Lambda=[1,20,50,100,200,500,1000];%the hyperparameter in the hypergraph learning
for x=3:length(allParam)
    mkdir([output,allParam(x).name]);
for J=1:length(Lambda)%20:20:100%50:300

lambda=Lambda(J);
     phi=1/(1+lambda);
    for j=1:length(Mu)
 mu=Mu(j);
output1=[output,allParam(x).name,'_',num2str(lambda),'_',num2str(mu),'_fused\'];
fprintf('%s-%f-%f\n',allParam(x).name,lambda,mu);
mkdir(output1);
     for i=3:length(allQuery)

    H1=load([hyperGraph,allQuery(i).name,'\hyperGraph.txt']);%load sematnic hypergraph
    H2=load([hyperPth_vis,allParam(x).name,'\',allQuery(i).name,'\hyperGraph.txt']);%load visual hypergraph
    H=[H1,H2'];
    [m,n]=size(H);
    Ne=size(H,2);%the number of hypergraph in total
    de=sum(H,1);%the degrees of hyperedges
    de=de';
    de=1./de;
    De=diag(de);
  
    %load the preseudo relevanec feedback
    y=load([predoGt,allQuery(i).name,'.txt']);
    
    I=eye(size(H,1));
    %initialize the hyperedge weights
    w=ones(Ne,1)/Ne; 
      iter=0; %count the iteration
    %initiazlie the degrees of vertex
    dv=zeros(m,1);
    for v=1:m
       idx=find(H(v,:)~=0);
       dv(v)=sum(w(idx));
    end
    dv=dv.^(-0.5);
    Dv=diag(dv);
      Gamma=Dv*H;
      PHI=1;
	
	%start the hypergraph learning processing
    while PHI<0.01 || iter<MAX_ITER
        iter=iter+1; 
    W=diag(w);
    Theta=Dv*H*W*De*H'*Dv;
    %update f
    f=1/(1-phi)*inv(I-phi*Theta)*y;
    
       %update the value of loss function
    PHI=f'*(I-Theta)*f+lambda*norm(f-y)^2+mu*norm(w)^2;
   
    % update w
    for L=1:length(w)
        w(L)=1/Ne-(f'*Gamma*De*Gamma'*f)/(2*Ne*mu)...
            +(f'*Gamma(:,L)*de(L)*Gamma(:,L)'*f)/(2*mu);
    end 
    %update dv
      for v=1:m
       idx=find(H(v,:)~=0);
       dv(v)=sum(w(idx));
      end
    dv=dv.^(-0.5);
    Dv=diag(dv);  
    %update matrix gamma
    Gamma=Dv*H;
    end
    write=fopen([output1,allQuery(i).name,'.txt'],'w+');
    dlmwrite([output1,allQuery(i).name,'.txt'],real(f),'delimiter','\t','newline','pc');
    fclose(write);
     end
    end
end
end