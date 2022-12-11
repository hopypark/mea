function re = compareCellStrings(s1, s2)

if (~iscell(s1) || ~iscell(s2)) 
    disp('Types of arguments must be a cell.')
    return
end

[r1, c1] = size(s1);
[r2, c2] = size(s2);

if (r1 ~= r2 || c1 ~= c2)
      disp('Arguments must same size.')
    return
end

re = 1; % default value is 1(same)

for iloop = 1:r1
    if ~strcmp(s1{iloop,1}, s2{iloop,1}) 
        re = 0;
        break;
    end
end