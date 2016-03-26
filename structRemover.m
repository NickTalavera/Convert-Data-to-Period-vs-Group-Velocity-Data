function [ newStruct, badFileNames ] = structRemover( arrayOfElementsToRemove, structuredArray )
count=0;
for i = (arrayOfElementsToRemove>1)
    i
    count=count+1;
end
newStruct=structuredArray(arrayOfElementsToRemove>0)
end