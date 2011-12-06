function [EQ Q] = ValQuality(ImOrig,ImTest)

EQ = discrepancy(ImTest,[],ImOrig,'EdgeQpond');
Q = discrepancy(ImTest,[],ImOrig,'Wang1');