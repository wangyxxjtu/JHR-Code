function SemanticHyperGraph(queryPath,rate)
%this function generate semantic hyperedge for each each query
%queryPath-the query.txt with images
%rate- the percent for tags selection

output=['E:\JHR_SemanticHyperGraph\',num2str(rate),'\'];%the output path
query=queryPath(1:strfind(queryPath,'.')-1);%get the query name


imageOfQuery=getImagesOfQuery(query);
highFreTags=getHighFreTags(query,rate*length(imageOfQuery));%select the high frequency tags for hyperedge generation
mkdir([output,query]);
write=fopen([output,query,'\hyperGraph.txt'],'w+');

for i=1:length(imageOfQuery)%traverse all the images
    tags=getTagsOfImage(imageOfQuery{i});     
    for p=1:length(highFreTags)%if the images contains the selected tags, mark as '1' else '0'
        if contains(highFreTags(p),tags)
           fprintf(write,[num2str(1),'\t']); 
        else
           fprintf(write,[num2str(0),'\t']); 
        end
    end
   fprintf(write,'\n');
end
 fclose(write);
%%
    function highFreTags=getHighFreTags(query,freThres)
       tagFrePath='E:\QueryInfo\TagFreUnderQuery\';%this path saves all the tags under query and corresponding cooccurence frequency
       path=[tagFrePath,query,'\','*.txt'];
       allTags=dir(path);
       count=1;
       highFreTags={};
       for j=1:length(allTags)
       read=fopen([tagFrePath,query,'\',allTags(j).name]);
       s=fgetl(read);
       tagFre=str2num(s);
       
       if tagFre>freThres%if the cooccurence tags, we select
           na=allTags(j).name;
           tag=na(1:strfind(na,'.')-1);
           highFreTags{count}=tag;
           count=count+1;
       end
       fclose(read);
       end
    end
%%
    function images=getImagesOfQuery(query)
	%read the images of query
        queryForTest='E:\QueryForTest\';%all the query test path
        read_image=fopen([queryForTest,query,'.txt']);
        count=1;
        while ~feof(read_image)
            images{count}=fgetl(read_image);
            count=count+1;
        end
        fclose(read_image);       
    end
%%
    function tags=getTagsOfImage(imageName)
	%read the image tags
        tagPath='E:\imageTagsNusWide\';%all the images tags path
        read1=fopen([tagPath,imageName,'.txt']);
        k=1;
        while  ~feof(read1)
            tags{k}=fgetl(read1);
            k=k+1;
        end
        fclose(read1);
    end
%%
    function flag=contains(highFre,tags)
       %this function judges whether a tag set (tags) contains some high frequency tag or not.
       flag=0;
       for q=1:length(tags)
          if strcmp(highFre,tags(q))
              flag=1;
              break;
          end          
       end
    end
end