function symbolTree = appendToTree(newKey, symbolTree, probTree, nGram)
%appenToTree appends all possible output symbols corresponding to the 
% character newKey to the symbolTree

%previousIndices initalized in ConstructSymbolTree
global previousIndices;
global dictionary;
global cap;
global probArray;

% Extract current symbol set
currentSymbolSet = dictionary(newKey);

% Initialise buffer that holds indices
indicesBuffer = [];

for previousIndex = previousIndices
    
    % Initialise buffer that holds newly added indices
    %array of new indices to attach
    indicesAdded = zeros(size(currentSymbolSet));
    
    for j = 1:length(currentSymbolSet)
        
        %store current
        currentSymbol = currentSymbolSet(j);
        
        % Get cell array attached to previous node
        if(previousIndex~=0)
        previousNodeContent = symbolTree.get(previousIndex);
        else 
            break;
        end
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
        % P(sequence)
        p = exp(-pSequence(probTree, newChars, 1, nGram));
        
        % Combine both node properties in a cell array
        % newchars is strcat
        nodeContent = {newChars, p};
        
        % Versuch ein array mit wahrscheinlichkeiten und sequence zu
        % erzeugen um mit max die beste wahrscheinlichkeit zu finden
        % symbolTree.Node{t,1}{1,2} = p
        % nodeContent = probTree.get(currentIndex);
        % frequency = nodeContent{2};
        probArray = [probArray nodeContent];
        
        if (p == 0 || p == inf)
        else
         % Add node to tree
        [symbolTree, indicesAdded(j)] = symbolTree.addnode(previousIndex, nodeContent);
        end
        
    end
  
    if any(indicesAdded)
      indicesAdded = indicesAdded(indicesAdded~=0);   %only add the indices that were added as a node
    indicesBuffer = [indicesBuffer indicesAdded];
    else
    end
    
end

% Store indices of previous nodes
previousIndices = indicesBuffer;

end