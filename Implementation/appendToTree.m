function symbolTree = appendToTree(newKey, symbolTree, probTree, nGram)
%appenToTree appends all possible output symbols corresponding to the 
% character newKey to the symbolTree

global previousIndices;
global dictionary;
global cap;
%global probString;


% Extract current symbol set
currentSymbolSet = dictionary(newKey);

% Initialise buffer that holds indices
indicesBuffer = [];


i=1; 
for previousIndex = previousIndices
    % Initialise buffer that holds newly added indices
    indicesAdded = zeros(size(currentSymbolSet));
    
    for j = 1:length(currentSymbolSet)
        
        currentSymbol = currentSymbolSet(j);
        
        % Get cell array attached to previous node
        previousNodeContent = symbolTree.get(previousIndex);
        
        % Extract character sequence and probability
        previousChars = previousNodeContent{1, 1};
        
        % Capitalise
        if cap == 0
            newChar = currentSymbol;
        elseif cap == 1
            newChar = upper(currentSymbol);
        end
        
        % Character vector containing all previous and the current symbol
        newChars = strcat(previousChars, newChar);
        
        
        % Compute probability of the current symbol using a n-gram
        p = pSequence(probTree, newChars, 1, nGram);
        
        % Combine both node properties in a cell array
        nodeContent = {newChars, p};
        
        if p == Inf   %don't add a node if the probality is zero
            p
        else
        
        % Add node to tree
        [symbolTree, indicesAdded(j)] = symbolTree.addnode(previousIndex, nodeContent);
        nodeContent
        probString(1,i) = p;
        probString(2,i) = indicesAdded(j);
        probString;
        i=i+1
        end
    end
    
      
        
    if any(indicesAdded)
        indicesAdded = indicesAdded(indicesAdded~=0);   %only add the indices that were added as a node
        indicesBuffer = [indicesBuffer indicesAdded];
    else
        
    end
    
      

end

        %extract the probability of the each level of the tree and store it in
        %a string and delete zeros in this string
        probStringupper=probString(1,:);
        probStringlower=probString(2,:);
        zerosprobString=(probStringupper == Inf);
        probStringupper(zerosprobString)=[];
        probStringlower(zerosprobString)=[];
        
        %sort elements of the probability String and print it out 
        [sorted,index] = sort(probStringupper)
        index = probStringlower(index)
        index=flip(index)
        format compact
        %print sorted sequnces
        ctr=1;
        for i=index 
            symbolTree.Node{i,1}
            if ctr == 10
                break
            else
            ctr=ctr+1;
            end
        end
        
% Store indices of previous nodes global
previousIndices = indicesBuffer;

end