% fehlerz�hler mit test korpus
% test korpus wird in tasten umgewandelt und mit dem T9-Erkenner wieder
% zur�ck gewandelt
% Ausgabe wird mit urspr�nglichen Text verglichen und unterschiede erkannt
% Fehlerrate = Fehler / test_korpus_l�nge

clear all;
close all;
clc;

global keySequence
global newKey
global symbolTree
global dictionary
global previousIndices
global nodeIndices
global probTree
global cap
global nGram

% Initialise tree structure
symbolTree = tree({'_', 1,1});

% set cap for appendToTree
cap = 0;

% Initialise arrays
previousIndices = 1;
nodeIndices = {0 0}';
keySequence = [];
newKey = [];
nGram = 3;

% define language
language = 'german';

%load corpus clean
load([language,'TestClean.mat']);

%load prob Tree
load([language,'ProbabilityTree.mat']);

% Test sequence
test_sequence = corpus(1:50);
% test_sequence = 'hallo_ich_,_komme_aus._hallo_ich_komme_aus';

% initialise 
key_sequence = test_sequence;
prov_sequence = '';

% change to key_sequence for t9
for j = 1 : nKeys
    
key_sequence(ismember(test_sequence, dictionary(keySet{j}))) = keySet{j};

end

% get keys into append to tree
for j = 1 : 1 : length(key_sequence)
    
    if (key_sequence(j) ~= '1')
    newKey = num2str(key_sequence(j)); 
    keySequence = [keySequence, newKey];
    [symbolTree,index] = appendToTree(newKey, symbolTree, probTree, nGram);   
    
    else
    prov_buffer = symbolTree.Node{index(length(index)),1}{1, 1};
    prov_sequence = [prov_sequence,'.',prov_buffer(2:end)];
    
    symbolTree = tree({'_', 1,1});
    previousIndices = 1;
    nodeIndices = {0 0}';
    keySequence = [];
    newKey = [];
    end
    
end
    
    % wenn nicht mit punkt oder komma abgeschlossen wird
    if(key_sequence(end) ~= '1')
    prov_buffer = symbolTree.Node{index(length(index)),1}{1, 1};
    prov_sequence = [prov_sequence,'.',prov_buffer(2:end)];
    end
    
    error_rate = 0;
    inco_sign = 0;
    
     for j =  1 : length(test_sequence)
      if(prov_sequence(j+1) ~= test_sequence(j))
           inco_sign = inco_sign + 1;
      end
     end
     
     

    error_rate = inco_sign / length(test_sequence)
    
    
    
    
  