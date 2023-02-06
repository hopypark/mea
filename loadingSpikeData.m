% loading spike data file(*.spk)
clear 

AllData = AxisFile('D:\001.workspace\001.matlab\yenikim\testData\spike\20160712\plate1_2016.07.12(000).spk').DataSets.LoadData;
%AllData = AxisFile('D:\001.workspace\001.matlab\yenikim\testData\spike\20160726\plate1_2016.07.26(000).spk').DataSets.LoadData;
[nwr, nwc, nec, ner]=size(AllData);


for i = 1:nec
    for j = 1:ner
        %Select the spike times from each electrode in the well
        if ~isempty(AllData{2,1,i,j})
        ts=[AllData{2,1,i,j}(:).Start];
        hold on;
        %Plot a vertical line at each
        plot([ts;ts],-(i-1)*ner-j+[0.75*ones(size(ts));zeros(size(ts))],'k'); 
        fprintf('nec = %d, ner = %d, # spikes = %d\n', i,j, size(ts,2));
        %timepoint corresponding to a spike
        hold off;
        else
            
            hold on;
            ts=[0];
            fprintf('nec = %d, ner = %d, # spikes = %d, \n', i,j, size(ts,2)-1);
            plot([ts;ts],-(i-1)*ner-j+[0.75*ones(size(ts));zeros(size(ts))],'k'); 
            hold off;
        end
    end
end

% title('plate1-2016.07.26(000).spk','FontSize',13);
% xlabel('time(sec)');ylabel('electrode');

% figure;
% [r,c] = size(AllData{2,1,1,1});
% hold on
% for i=1:c
%     % i is index the spike detected on Well B1 Electrode 11.
%     [t,v] = AllData{2,1,1,1}(i).GetTimeVoltageVector; 
%     plot(v);
% end
% %

