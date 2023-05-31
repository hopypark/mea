% loading spike data file(*.spk)
clear 

wellname = 'A-1, B-2, C-3, D-4, E-5, F-6, G-7, H-8';
COL_WELLNAME = 1:12;
ROW_WELLNAME = {'A','B','C','D','E','F','G','H'};

% file selection
[file,path] = uigetfile({'*.spk'}, 'Select One or More Files', 'D:\00.Workspace\00.Matlab\mea\testData\spk','MultiSelect','Off');

% which electrode?
disp(['Well''s row name: ' wellname])
wrow = input('which is row number of well? ','s');
wcol = input('which is col number of well? ','s');

%AllData = AxisFile('D:\00.Workspace\00.Matlab\mea\testData\spk\plate1_2016.07.12(000).spk').DataSets.LoadData;
AllData = AxisFile([path file]).DataSets.LoadData;
[nwr, nwc, nec, ner]=size(AllData);

% 
attnEntValue=zeros(9, 5); % 9-number of electode, 5 - AttnEn(aveg, max-max, min-min, max-min, min-max)
%

figure('Position',[100, 200, 900, 500]);
for i = 1:nec
    for j = 1:ner
        %Select the spike times from each electrode in the well\

        if ~isempty(eval(sprintf('AllData{%s,%s,%d,%d}',wrow, wcol, i, j)))
            ts = eval(sprintf('[AllData{%s,%s,%d,%d}(:).Start]',wrow, wcol, i, j));
%         if ~isempty(AllData{2,2,i,j}) % In case of having spike(s)
%             ts=[AllData{2,2,i,j}(:).Start];

%             % Calculating Attend Entropy            
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             fprintf('Calculating Attendtion Entropy nec = %d, ner = %d ....................', i,j)
%             if size(ts,2) > 20                
%                 [Attn, Hxx, Hnn, Hxn, Hnx]=AttnEn(diff(ts(1,:)));
%                 attnEntValue((i-1)*ner+j,:) = [Attn, Hxx, Hnn, Hxn, Hnx];
% %                 fprintf('nec = %d, ner = %d, # AttnEn = %d\n', i,j, attnEntValue((i-1)*ner+j,1));
%             end
%             fprintf('end\n');
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            hold on;
            %Plot a vertical line at each
            plot([ts;ts],-(i-1)*ner-j+[0.75*ones(size(ts));zeros(size(ts))],'k'); 
            fprintf('nec = %d, ner = %d, # spikes = %d\n', i,j, size(ts,2));
            text(605, -(i-1) * ner - j + 0.5, sprintf('E%d%d = %4d',i,j,size(ts,2)));
            %timepoint corresponding to a spike
            hold off;

        else            
            hold on;
            ts=0;
            fprintf('nec = %d, ner = %d, # spikes = %d, \n', i,j, size(ts,2)-1);
            plot([ts;ts],-(i-1)*ner-j+[0.75*ones(size(ts));zeros(size(ts))],'k');
            text(605, -(i-1) * ner - j + 0.5, sprintf('E%d%d = %4d',i,j,0));
            hold off;
        end
    end
end

title(sprintf('%s(Well - %s%s)',strrep(file,'_','-'), ROW_WELLNAME{1, str2double(wrow)} ,wcol),'FontSize',13);
xlabel('time(sec)');ylabel('electrode');
% x1=[200 200]; y1=[0 -9];
% x2=[400 400]; y2=[0 -9];
% line(x1,y1,'Color','red','LineWidth',2);line(x2,y2,'Color','red','LineWidth',2);
grid on;box on;

T=array2table(attnEntValue,'VariableNames',{'Attn', 'Hxx', 'Hnn', 'Hxn', 'Hnx'});
% figure;
% [r,c] = size(AllData{2,1,1,1});
% hold on
% for i=1:c
%     % i is index the spike detected on Well B1 Electrode 11.
%     [t,v] = AllData{2,1,1,1}(i).GetTimeVoltageVector; 
%     plot(v);
% end
% %

