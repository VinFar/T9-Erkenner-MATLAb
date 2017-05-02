% *** DATA PREPROCESSING ***


% Clear workspace and console, close all figures
clear all;
close all;
clc;


% Select language: 'German' or 'English'
language = 'English';

% Specify filename for respective text corpus obtained from
% http://wortschatz.uni-leipzig.de/en/download
switch language
    
    case 'English'
        filename = 'eng_news_2015_10K-words.txt';
        
    case 'German'
        filename = 'deu_news_2015_10K-words.txt';
        
    otherwise
        error('No valid language selected! Choose English or German!');
end

% Define possible input symbols
keySet = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '#'}'; %, '*'}';

% Define possible output symbols
valueSet = { ...
    '0' ...
    '1.,' ...
    '2abc' ...
    '3def' ...
    '4ghi' ...
    '5jkl' ...
    '6mno' ...
    '7pqrs' ...
    '8tuv' ...
    '9wxyz' ...
    ... %'+' ...            % switch between upper and lowercase
    '_' ...             % symbol for a space
    }';

% Compose entire alphabet
alphabet = char(join(string(valueSet), ''));
keys = char(join(keySet, ''));

% Create input -> output map
dictionary = containers.Map(keySet, valueSet);

% Compute number of keys
nKeys = dictionary.Count;

% Read text corpus
fileID = fopen(['../Corpora/', filename]);
corpus = textscan(fileID, '%d %s %s %d', 'Delimiter',{'\t'});
fclose(fileID);

% Extract only the words from the corpus
wordsRawCell = corpus{2};

% Store words as an array of strings
wordsRaw = string(wordsRawCell);

% Compute the number of words in the raw corpus
nWordsRaw = length(wordsRaw);

for index = 1:nWordsRaw
    
    % Mark records that consist of characters not contained in the alphabet
    if sum(~ismember(char(wordsRaw(index)), alphabet)) ~= 0
        wordsRaw(index) = "-----";
    end
    
end

% Extract words containing only characters existing in the alphabet
words = wordsRaw(wordsRaw ~= "-----");

% Convert all strings to lowercase
words = lower(words);

% Compute number of words
nWords = length(words);






% Define array that stores words comprised of input symbols that map to the
% respective character.
wordsInputSym = strings(size(words));

for k = 1 : nWords
    
    word = char(words(k));
    
    for i = 1 : length(word)
        
        character = word(i);
        
        for j = 1 : nKeys
            
            if ismember(character, char(dictionary(keySet{j})))
                character = keys(j);
            end
            
        end
        
        word(i) = character;
        
    end
    
    wordsInputSym(k) = string(word);
    
end

% Save workspace variables to file
save(['data/data', language], ...
    'alphabet', 'dictionary', 'idxTest', 'idxTrain', 'nKeys', 'nTestSet', ...
    'nTrainSet', 'nWords', 'testSet', 'trainSet', 'valueSet', 'words', ...
    'language', 'wordsInputSym', 'partition');

