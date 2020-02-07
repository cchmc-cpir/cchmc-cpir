function [Total_Dissolved_Key_Diff_Fig,RBC_PctRBC_Key_Diff_Fig,Binning_Fig,Histograms,Barrier_Key_Diff_Fig,BarFig,QQ_Osc_Signal_Fig] = analyze_display_detrend_keyhole_dissolvedPhase_V3(High_Image,Low_Image,Tot_Image,Gas_Image,Mask,Low_Res_Mask,Subject,ScannerType,path)

%Function to analyze and Display images obtained using keyhole dissolved
%phase imaging.
%Pass Phase-shifted images so that RBC images are in the real, and Barrier
%are in the -Imaginary

%% Definitions
NewCMap = summer;
NewCMap(1,:) = [0 0 0];

%% Specify Healthy Cohort Means and SDs for Oscillations, RBC, Barrier, and RBC/Barrier

%Sometimes the absolute signal intensity is super low... scale to get to
%something a little more friendly to work with
if mean(abs(Gas_Image(Mask==1)))<1e-4
    Gas_Image = Gas_Image*1e8;
    Low_Image = Low_Image*1e8;
    High_Image = High_Image*1e8;
    Tot_Image = Tot_Image*1e8;
end

if contains(ScannerType,'GE')
    healthy_mean_Osc = 8.4997;
    healthy_std_Osc = 11.2616;

    %healthy_mean_Osc = 12.6974;
    %healthy_std_Osc = 12.1411;
    
    healthy_mean_RBC = 1.9062e-6;
    healthy_std_RBC = 1.1085e-6;
    
    healthy_mean_Bar = 3.3855e-6;
    healthy_std_Bar = 1.2928e-6;
    
    healthy_mean_RBCBar = 0.4835;
    healthy_std_RBCBar = 0.2457;
    %Load in Healthy Cohort Distribution for Later QQ Plots
    load('C:\Users\NIES4T\OneDrive - cchmc\Documents\Data Analysis\RBC Oscillations\Duke Data\All Subjects from ERJ Plus CTEPH\HealthyCohorts\GE_Healthy.mat');

    Mean_Disp_Range = [healthy_mean_Osc-2*healthy_std_Osc healthy_mean_Osc+4*healthy_std_Osc];
elseif contains(ScannerType,'Siemens')
    healthy_mean_Osc = 9.8104;
    healthy_std_Osc = 9.0112;
    %healthy_mean_Osc = 6.8026;
    %healthy_std_Osc = 9.6307;
    
    healthy_mean_RBC = 5.0354e-4;
    healthy_std_RBC = 3.0529e-4;
    
    healthy_mean_Bar = 8.2819e-4;
    healthy_std_Bar = 4.2079e-4;
    
    healthy_mean_RBCBar = 0.5463;
    healthy_std_RBCBar = 0.2507;

    
    Mean_Disp_Range = [healthy_mean_Osc-2*healthy_std_Osc healthy_mean_Osc+4*healthy_std_Osc];
    %Load in Healthy Cohort Distribution for Later QQ Plots
    load('C:\Users\NIES4T\OneDrive - cchmc\Documents\Data Analysis\RBC Oscillations\Duke Data\All Subjects from ERJ Plus CTEPH\HealthyCohorts\Siemens_Healthy.mat');

elseif contains(ScannerType,'Philips_V2')
    healthy_mean_Osc = 9.9252;
    healthy_std_Osc = 14.2747;
    
    healthy_mean_RBC = 5.8668e-6;
    healthy_std_RBC = 5.1294e-6;
    
    healthy_mean_Bar = 1.4210e-5;
    healthy_std_Bar = 1.0290e-5;
    
    healthy_mean_RBCBar = 0.4132;
    healthy_std_RBCBar = 0.1700;

    
    Mean_Disp_Range = [healthy_mean_Osc-2*healthy_std_Osc healthy_mean_Osc+4*healthy_std_Osc];
    %Load in Healthy Cohort Distribution for Later QQ Plots
    load('C:\Users\NIES4T\OneDrive - cchmc\Documents\Data Analysis\RBC Oscillations\Duke Data\All Subjects from ERJ Plus CTEPH\HealthyCohorts\Philips_V2_Healthy.mat');
elseif contains(ScannerType,'Philips_V3')
    healthy_mean_Osc = 9.7605;
    healthy_std_Osc = 13.1853;
    
    healthy_mean_RBC = 1.3842e-6;
    healthy_std_RBC = 8.6914e-7;
    
    healthy_mean_Bar = 5.1424e-6;
    healthy_std_Bar = 1.8317e-6;
    
    healthy_mean_RBCBar = 0.2954;
    healthy_std_RBCBar = 0.1767;

    
    Mean_Disp_Range = [healthy_mean_Osc-2*healthy_std_Osc healthy_mean_Osc+4*healthy_std_Osc];
    %Load in Healthy Cohort Distribution for Later QQ Plots
    load('C:\Users\NIES4T\OneDrive - cchmc\Documents\Data Analysis\RBC Oscillations\Duke Data\All Subjects from ERJ Plus CTEPH\HealthyCohorts\Philips_V3_Healthy.mat');

end

%% Separate into image components
RBC_High = real(High_Image);
if mean(RBC_High(Mask==1)) < 0
    RBC_High = -RBC_High;
end
RBC_Low = real(Low_Image);
if mean(RBC_Low(Mask==1)) < 0
    RBC_Low = -RBC_Low;
end
RBC_Tot = real(Tot_Image);
if mean(RBC_Tot(Mask==1)) < 0
    RBC_Tot = -RBC_Tot;
end
Mag_Tot = abs(Tot_Image);

Bar_High = imag(High_Image);
if mean(Bar_High(Mask==1)) < 0
    Bar_High = -Bar_High;
end
Bar_Low = imag(Low_Image);
if mean(Bar_Low(Mask==1)) < 0
    Bar_Low = -Bar_Low;
end
Bar_Tot = imag(Tot_Image);
if mean(Bar_Tot(Mask==1)) < 0
    Bar_Tot = -Bar_Tot;
end
Mag_Tot = abs(Tot_Image);

%Scale by the gas signal - Leave original images untouched just to keep
%life easy for oscillation mapping
RBC_High2Gas = RBC_High./(abs(Gas_Image)*39.1931);
RBC_Low2Gas = RBC_Low./(abs(Gas_Image)*39.1931);
RBC_Tot2Gas = RBC_Tot./(abs(Gas_Image)*39.1931);
Bar_High2Gas = Bar_High./(abs(Gas_Image)*39.1931);
Bar_Low2Gas = Bar_Low./(abs(Gas_Image)*39.1931);
Bar_Tot2Gas = Bar_Tot./(abs(Gas_Image)*39.1931);
RBC_to_Bar = RBC_Tot./Bar_Tot;

%Get SNR
RBC_High_SNR = (mean((RBC_High(Low_Res_Mask==1))) - mean((RBC_High(Low_Res_Mask == 0))))/ std((RBC_High(Low_Res_Mask==0)));
RBC_Low_SNR = (mean((RBC_Low(Low_Res_Mask==1))) - mean((RBC_Low(Low_Res_Mask == 0))))/ std((RBC_Low(Low_Res_Mask==0)));
RBC_Tot_SNR = (mean((RBC_Tot(Low_Res_Mask==1))) - mean((RBC_Tot(Low_Res_Mask == 0))))/ std((RBC_Tot(Low_Res_Mask==0)));

%Create a Mask accounting for RBC Defects - use a cutoff of 1.5?
RBC_Noise = std((RBC_Tot(Low_Res_Mask==0)));
RBC_Mask = Mask;
RBC_Mask(RBC_Tot<1.5*RBC_Noise) = 0;

%% Display High and Low Key Images (Total Dissolved) and Pct Difference Map
First_Slice = 0;
sumMask = 0;
while sumMask == 0
    First_Slice = First_Slice+1;
    sumMask = sum(reshape(Mask(First_Slice,:,:),1,[]));
end
Last_Slice = size(Mask,1)+1;
sumMask = 0;
while sumMask == 0
    Last_Slice = Last_Slice-1;
    sumMask = sum(reshape(Mask(Last_Slice,:,:),1,[]));
end
if (Last_Slice-First_Slice) > 18
    First_Slice = First_Slice+6;
    Last_Slice = Last_Slice-6;
end
%Let's display six slices
step = floor((Last_Slice - First_Slice)/5);
Slices = First_Slice:step:(First_Slice+5*step);

Total_Dissolved_Key_Diff_Fig = figure('Name','Difference between High and Low Key ');
set(Total_Dissolved_Key_Diff_Fig,'color','white','Units','inches','Position',[0.25 0.25 12 6])
[ha, ~] = tight_subplot(3, length(Slices), 0.01, 0.01, [0.05 0.01]);
maxvox = max(max([abs(High_Image(:)) abs(Low_Image(:))]));

for slice = 1:length(Slices)
    %Display Ratio Image
    axes(ha(slice));
    imagesc(abs((((squeeze(High_Image(Slices(slice),:,:)))))))
    colormap(gray)
    caxis manual
    caxis([0 maxvox])
    axis square
    axis off
end
for slice = 1:length(Slices)
    %Display Ratio Image
    axes(ha(slice+length(Slices)));
    imagesc(abs((((squeeze(Low_Image(Slices(slice),:,:)))))))
    colormap(gray)
    caxis manual
    caxis([0 maxvox])
    axis square
    axis off
end

%Calculate Total Dissolved Phase Oscillation Map
Dissolved_Pct_Diff = (abs(High_Image) - abs(Low_Image))./mean(Mag_Tot(Mask==1))*100;
Dissolved_Pct_Diff = Dissolved_Pct_Diff.*Mask;
%Make sure the background is black
Tmp_Dis_Pct_Diff = Dissolved_Pct_Diff;
Tmp_Dis_Pct_Diff(Mask==0) = -500;

Tot_Diff = Dissolved_Pct_Diff;
Tot_Diff(Mask == 0) = [];
%Kill any obviously spurrious points
Tot_Diff(Tot_Diff>70) = [];
Tot_Diff(Tot_Diff<-35) = [];

Mean_Tot_Diff = mean(Tot_Diff);
SD_Tot_Diff = std(Tot_Diff);

for slice = 1:length(Slices)
    %Display Ratio Image
    axes(ha(slice+2*length(Slices)));
    imagesc(((((squeeze(Tmp_Dis_Pct_Diff(Slices(slice),:,:)))))))
    colormap(ha(slice+2*length(Slices)),NewCMap)
    caxis manual
    caxis(Mean_Disp_Range)
    axis square
    axis off
end
axes(ha(1+2*length(Slices)));
c = colorbar('south');
c.Color = 'w';

axes(ha(1));
ax = gca;
ax.FontSize = 12;
ylabel('Dissolved High Key')
ax.YLabel.Visible = 'on';

axes(ha(1+1*length(Slices)));
ax = gca;
ax.FontSize = 12;
ylabel('Dissolved Low Key')
ax.YLabel.Visible = 'on';

axes(ha(1+2*length(Slices)));
c = colorbar('south');
c.Color = 'w';
axes(ha(1+2*length(Slices)));
ax = gca;
ax.FontSize = 12;
ylabel('Dissolved Oscillation')
ax.YLabel.Visible = 'on';

%% Display High and Low Key Images (Barrier) and Pct Difference Map
First_Slice = 0;
sumMask = 0;
while sumMask == 0
    First_Slice = First_Slice+1;
    sumMask = sum(reshape(Mask(First_Slice,:,:),1,[]));
end
Last_Slice = size(Mask,1)+1;
sumMask = 0;
while sumMask == 0
    Last_Slice = Last_Slice-1;
    sumMask = sum(reshape(Mask(Last_Slice,:,:),1,[]));
end

if (Last_Slice-First_Slice) > 18
    First_Slice = First_Slice+6;
    Last_Slice = Last_Slice-6;
end
%Let's display six slices
step = floor((Last_Slice - First_Slice)/5);
Slices = First_Slice:step:(First_Slice+5*step);

Barrier_Key_Diff_Fig = figure('Name','Difference between High Key Barrier and Low Key Barrier');
set(Barrier_Key_Diff_Fig,'color','white','Units','inches','Position',[0.25 0.25 12 6])
[ha, ~] = tight_subplot(3, length(Slices), 0.01, 0.01, [0.05 0.01]);
maxvox = max(max([abs(Bar_High(:)) abs(Bar_Low(:))]));

Bar_High_tmp = Bar_High.*Mask;
Bar_Low_tmp = Bar_Low.*Mask;
Bar_High_tmp(Bar_High_tmp==0)=-500;
Bar_Low_tmp(Bar_Low_tmp==0)=-500;

for slice = 1:length(Slices)
    %Display Ratio Image
    axes(ha(slice));
    imagesc(((((squeeze(Bar_High(Slices(slice),:,:)))))))
    colormap(gray)
    caxis manual
    caxis([0 maxvox])
    axis square
    axis off
end
for slice = 1:length(Slices)
    %Display Ratio Image
    axes(ha(slice+length(Slices)));
    imagesc(((((squeeze(Bar_Low(Slices(slice),:,:)))))))
    colormap(gray)
    caxis manual
    caxis([0 maxvox])
    axis square
    axis off
end

%Calculate Barrier Oscillation Map
Barrier_Pct_Diff = (abs(Bar_High) - abs(Bar_Low))./mean(Bar_Tot(Mask==1))*100;
Barrier_Pct_Diff = Barrier_Pct_Diff.*Mask;

Bar_Diff = Barrier_Pct_Diff;
Bar_Diff(Mask == 0) = [];
%Kill any obviously spurrious points
Bar_Diff(Bar_Diff>70) = [];
Bar_Diff(Bar_Diff<-35) = [];
Mean_Bar_Diff = mean(Bar_Diff);
SD_Bar_Diff = std(Bar_Diff);

Barrier_Pct_Diff(Barrier_Pct_Diff==0) = -500;
for slice = 1:length(Slices)
    %Display Ratio Image
    axes(ha(slice+2*length(Slices)));
    imagesc(((((squeeze(Barrier_Pct_Diff(Slices(slice),:,:)))))))
    colormap(ha(slice+2*length(Slices)),NewCMap)
    caxis manual
    caxis(Mean_Disp_Range)
    axis square
    axis off
end
axes(ha(1+2*length(Slices)));
c = colorbar('south');
c.Color = 'w';

axes(ha(1));
ax = gca;
ax.FontSize = 12;
ylabel('Barrier High Key')
ax.YLabel.Visible = 'on';

axes(ha(1+1*length(Slices)));
ax = gca;
ax.FontSize = 12;
ylabel('Barrier Low Key')
ax.YLabel.Visible = 'on';

axes(ha(1+2*length(Slices)));
c = colorbar('south');
c.Color = 'w';
axes(ha(1+2*length(Slices)));
ax = gca;
ax.FontSize = 12;
ylabel('Barrier Oscillation')
ax.YLabel.Visible = 'on';

%% Display High and Low Key Images (RBC) and Pct Difference Map

RBC_PctRBC_Key_Diff_Fig = figure('Name','Difference between High and Low Key ');
set(RBC_PctRBC_Key_Diff_Fig,'color','white','Units','inches','Position',[0.25 0.25 12 7])
[ha, ~] = tight_subplot(4, length(Slices), 0.01, 0.01, [0.05 0.01]);
maxvox = max(max([abs(RBC_High(:)) abs(RBC_Low(:))]));

for slice = 1:length(Slices)
    axes(ha(slice));
    imagesc(((((squeeze(RBC_High(Slices(slice),:,:)))))))
    colormap(gray)
    caxis manual
    caxis([0 maxvox])
    axis square
    axis off
end
for slice = 1:length(Slices)
    axes(ha(slice+length(Slices)));
    imagesc(((((squeeze(RBC_Low(Slices(slice),:,:)))))))
    colormap(gray)
    caxis manual
    caxis([0 maxvox])
    axis square
    axis off
end

axes(ha(1));
ax = gca;
ax.FontSize = 12;
ylabel('RBC High Key')
ax.YLabel.Visible = 'on';

axes(ha(1+1*length(Slices)));
ax = gca;
ax.FontSize = 12;
ylabel('RBC Low Key')
ax.YLabel.Visible = 'on';

Mean_Pct_Diff = (RBC_High - RBC_Low)/mean(RBC_Tot(RBC_Mask==1))*100;
Mean_Pct_Diff = Mean_Pct_Diff.*RBC_Mask;
Tmp_Mean_Pct_Diff = Mean_Pct_Diff;
Tmp_Mean_Pct_Diff(Mean_Pct_Diff == 0) = -500;
for slice = 1:length(Slices)
    axes(ha(slice+2*length(Slices)));
    imagesc(((((squeeze(Tmp_Mean_Pct_Diff(Slices(slice),:,:)))))))
    colormap(ha(slice+2*length(Slices)),NewCMap)
    caxis manual
    caxis(Mean_Disp_Range) 
    axis square
    axis off
end

axes(ha(1+2*length(Slices)));
c = colorbar('south');
c.Color = 'w';
axes(ha(1+2*length(Slices)));
ax = gca;
ax.FontSize = 12;
ylabel('RBC Oscillation')
ax.YLabel.Visible = 'on';

%% Bin Oscillation Image
MeanBinMap = zeros(size(Mean_Pct_Diff));
for ii = 1:size(MeanBinMap,3)
    for jj = 1:size(MeanBinMap,2)
        for kk = 1:size(MeanBinMap,1)
            if Mask(kk,jj,ii) == 0
                MeanBinMap(kk,jj,ii) = 0; %0 - black
            elseif Mean_Pct_Diff(kk,jj,ii) <= healthy_mean_Osc - 2 * healthy_std_Osc
                MeanBinMap(kk,jj,ii) = 1; %1 - red
            elseif Mean_Pct_Diff(kk,jj,ii) <= healthy_mean_Osc - 1 * healthy_std_Osc
                MeanBinMap(kk,jj,ii) = 2; %2 - orange
            elseif Mean_Pct_Diff(kk,jj,ii) <= healthy_mean_Osc 
                MeanBinMap(kk,jj,ii) = 3; %3 - green 1
            elseif Mean_Pct_Diff(kk,jj,ii) <= healthy_mean_Osc + 1 * healthy_std_Osc
                MeanBinMap(kk,jj,ii) = 4; %4 - green 2
            elseif Mean_Pct_Diff(kk,jj,ii) <= healthy_mean_Osc + 2 * healthy_std_Osc
                MeanBinMap(kk,jj,ii) = 5; %5 - blue 1
            elseif Mean_Pct_Diff(kk,jj,ii) <= healthy_mean_Osc + 3 * healthy_std_Osc
                MeanBinMap(kk,jj,ii) = 6; %5 - blue 1
            elseif Mean_Pct_Diff(kk,jj,ii) <= healthy_mean_Osc + 4 * healthy_std_Osc
                MeanBinMap(kk,jj,ii) = 7; %5 - blue 1
            elseif Mean_Pct_Diff(kk,jj,ii) > healthy_mean_Osc + 4 * healthy_std_Osc
                MeanBinMap(kk,jj,ii) = 8; %6 - blue 2
            end
            
            if Mask(kk,jj,ii) == 1 && RBC_Mask(kk,jj,ii) == 0
                MeanBinMap(kk,jj,ii) = 9;
            end
        end
    end
end

%Six Bin Map for RBC
SixBinMap = [0 0 0
             1 0 0  %Red
             1 0.7143 0  %Orange
             0.4 0.7 0.4  %Green1
             0 1 0  %Green2
             0 0.57 0.71  %Blue1
             0 0 1  %Blue2
             ];
         
%Eight Bin Map for Barrier
EightBinMap = [0 0 0
             1 0 0  %Red
             1 0.7143 0  %Orange
             0.4 0.7 0.4  %Green1
             0 1 0  %Green2
             184/255 226/255 145/255  %Green3
             243/255 205/255 213/255  %Light Pink
             225/255 129/255 162/255  %Med Pink
             197/255 27/255 125/255  %Dark Pink
             ];

%Nine Bin Map for RBC Oscillations
EightBinMap_Osc = [0 0 0
             1 0 0  %Red
             1 0.7143 0  %Orange
             0.4 0.7 0.4  %Green1
             0 1 0  %Green2
             184/255 226/255 145/255  %Green3
             243/255 205/255 213/255  %Light Pink
             225/255 129/255 162/255  %Med Pink
             197/255 27/255 125/255  %Dark Pink
             1 1 1 % White (For regions of RBC Defect)
             ];
         
for slice = 1:length(Slices)
    axes(ha(slice+3*length(Slices)));
    imagesc(((((squeeze(MeanBinMap(Slices(slice),:,:)))))))
    colormap(ha(slice+3*length(Slices)),EightBinMap_Osc)
    caxis manual
    caxis([0 9])
    axis square
    axis off
end
colorbar(ha(3*length(Slices)+1),'north', 'Color', [1 1 1])
axes(ha(1+3*length(Slices)));
ax = gca;
ax.FontSize = 12;
ylabel('Binned Oscillations')
ax.YLabel.Visible = 'on';

%% Image with Binned RBC, Bar, and Osc
Binned_RBC = six_bin_image(RBC_Tot2Gas,Mask,healthy_mean_RBC,healthy_std_RBC);
Binned_Bar = eight_bin_image(Bar_Tot2Gas,Mask,healthy_mean_Bar,healthy_std_Bar);

Binning_Fig = figure('Name','Difference between High and Low Key ');
set(Binning_Fig,'color','white','Units','inches','Position',[0.25 0.25 12 7])
[ha, ~] = tight_subplot(3, length(Slices), 0.01, 0.01, [0.05 0.01]);

for slice = 1:length(Slices)
    axes(ha(slice));
    imagesc(((((squeeze(Binned_RBC(Slices(slice),:,:)))))))
    colormap(ha(slice),SixBinMap)
    caxis manual
    caxis(ha(slice),[0 6]) 
    axis square
    axis off
end
axes(ha(1));
c = colorbar('south');
c.Color = 'w';
ax = gca;
ax.FontSize = 12;
ylabel('Binned RBC')
ax.YLabel.Visible = 'on';

for slice = 1:length(Slices)
    axes(ha(slice+length(Slices)));
    imagesc(((((squeeze(Binned_Bar(Slices(slice),:,:)))))))
    colormap(ha(slice+length(Slices)),EightBinMap)
    caxis manual
    caxis(ha(slice+length(Slices)),[0 8]) 
    axis square
    axis off
end
axes(ha(1+1*length(Slices)));
c = colorbar('south');
c.Color = 'w';
ax = gca;
ax.FontSize = 12;
ylabel('Binned Barrier')
ax.YLabel.Visible = 'on';

for slice = 1:length(Slices)
    axes(ha(slice+2*length(Slices)));
    imagesc(((((squeeze(MeanBinMap(Slices(slice),:,:)))))))
    colormap(ha(slice+2*length(Slices)),EightBinMap_Osc)
    caxis manual
    caxis([0 9])
    axis square
    axis off
end
colorbar(ha(2*length(Slices)+1),'south', 'Color', [1 1 1])
axes(ha(1+2*length(Slices)));
ax = gca;
ax.FontSize = 12;
ylabel('Binned Oscillations')
ax.YLabel.Visible = 'on';

%% Get Means and STDs for both measures of RBC oscillation pct.

outlier_thresh = [-35 70];

Mean_Pct_Diff_Data = Mean_Pct_Diff;
Mean_Pct_Diff_Data(RBC_Mask == 0) = [];
Mean_Pct_Diff_Data(Mean_Pct_Diff_Data<outlier_thresh(1)) = [];
Mean_Pct_Diff_Data(Mean_Pct_Diff_Data>outlier_thresh(2)) = [];

Pct_Mean_Mean = mean(Mean_Pct_Diff_Data);
Pct_Mean_STD = std(Mean_Pct_Diff_Data);
Pct_Mean_CV = Pct_Mean_STD/Pct_Mean_Mean;

mean_High_data = RBC_High(Mask==1);
mean_Low_data = RBC_Low(Mask==1);
mean_Tot_data = RBC_Tot(Mask==1);

mean_High_data(mean_High_data<0) = [];
mean_Low_data(mean_Low_data<0) = [];
mean_Tot_data(mean_Tot_data<0) = [];

mean_High_data(isoutlier(mean_High_data)) = [];
mean_Low_data(isoutlier(mean_Low_data)) = [];
mean_Tot_data(isoutlier(mean_Tot_data)) = [];

mean_High = mean(mean_High_data);
mean_Low = mean(mean_Low_data);
mean_Tot = mean(mean_Tot_data);

MeanRBCMeasure = ((mean_High - mean_Low)/mean_Tot)*100;

%% Get Histograms for RBC Differences
Mean_Pct_Diff = (RBC_High - RBC_Low)/mean(RBC_Tot(RBC_Mask==1))*100;
Mean_Pct_Diff = Mean_Pct_Diff.*RBC_Mask;
Mean_Pct_Diff_Tmp = Mean_Pct_Diff;
Mean_Pct_Diff_Tmp(Mean_Pct_Diff_Tmp==0) = [];

if contains(Subject,'GE')
    Mean_Edges = linspace(-40,80,100);
else
    Mean_Edges = linspace(-30,60,100);
end

Healthy_Osc_Dist = normpdf(Mean_Edges,healthy_mean_Osc,healthy_std_Osc);
NormFactor = sum(Healthy_Osc_Dist(:));
Healthy_Osc_Dist = Healthy_Osc_Dist./NormFactor;
Histograms = figure('Name','Histograms');
set(Histograms,'color','white','Units','inches','Position',[0.25 0.25 8 6])

%RBC
subplot(2,2,1)
RBCEdges = linspace(0,healthy_mean_RBC+10*healthy_std_RBC,100);
HeatlhyRBCDist = normpdf(RBCEdges,healthy_mean_RBC,healthy_std_RBC);
NormFactor = sum(HeatlhyRBCDist(:));
HeatlhyRBCDist = HeatlhyRBCDist./NormFactor;
RBC_Vox_tmp = RBC_Tot2Gas;
RBC_Vox_tmp(Mask==0) = [];
hold on
histogram(RBC_Vox_tmp,RBCEdges,'Normalization','probability','FaceColor',[1 0.1 0.11],'FaceAlpha',1);
plot(RBCEdges,HeatlhyRBCDist,'k--');
axis([0 RBCEdges(end-1)+RBCEdges(end-1)-RBCEdges(end-2) 0 inf])
legend('Subjects Distribution','Healthy Control Distribution','Location','south');
title('RBC-transfer Histogram')

%Barrier
subplot(2,2,2)
BarrierEdges = linspace(0,healthy_mean_Bar+10*healthy_std_Bar,100);
HeatlhyBarrierDist = normpdf(BarrierEdges,healthy_mean_Bar,healthy_std_Bar);
NormFactor = sum(HeatlhyBarrierDist(:));
HeatlhyBarrierDist = HeatlhyBarrierDist./NormFactor;
hold on
Bar_Vox_tmp = Bar_Tot2Gas;
Bar_Vox_tmp(Mask==0) = [];
histogram(Bar_Vox_tmp,BarrierEdges,'Normalization','probability','FaceColor',[0.1 0.1 1],'FaceAlpha',1);
plot(BarrierEdges,HeatlhyBarrierDist,'k--');
axis([0 BarrierEdges(end-1)+BarrierEdges(end-1)-BarrierEdges(end-2) 0 inf])
legend('Subjects Distribution','Healthy Control Distribution','Location','south');
title('Barrier-uptake Histogram')

%RBC/Barrier
subplot(2,2,3)
RBCBarrierEdges = linspace(0,healthy_mean_RBCBar+10*healthy_std_RBCBar,100);
HeatlhyRBCBarrierDist = normpdf(RBCBarrierEdges,healthy_mean_RBCBar,healthy_std_RBCBar);
NormFactor = sum(HeatlhyRBCBarrierDist(:));
HeatlhyRBCBarrierDist = HeatlhyRBCBarrierDist./NormFactor;
RBC_Bar_tmp = RBC_Tot./Bar_Tot;
RBC_Bar_tmp(Mask==0) = [];
hold on
histogram(RBC_Bar_tmp,RBCBarrierEdges,'Normalization','probability','FaceColor',[0.75 0 0.75],'FaceAlpha',1);
plot(RBCBarrierEdges,HeatlhyRBCBarrierDist,'k--');
axis([0 RBCBarrierEdges(end-1)+RBCBarrierEdges(end-1)-RBCBarrierEdges(end-2) 0 inf])
legend('Subjects Distribution','Healthy Control Distribution','Location','south');
title('RBC:Barrier Ratio Histogram')

%Oscillations Histogram
subplot(2,2,4)
hold on
histogram(Mean_Pct_Diff_Tmp,Mean_Edges,'Normalization','probability','FaceColor',[.1 0.67 0.67],'FaceAlpha',1);
plot(Mean_Edges,Healthy_Osc_Dist,'k--');
ylabel('Bin Count')
xlabel('Percent Oscillation (of mean non-keyholed RBC)')
legend('Subjects Distribution','Healthy Control Distribution','Location','south');
hold off
title('Cardio-Pulmonary Oscillations Histogram')

%Find the percentage of voxels in each particular bin
NumVox = length(find(Mask==1));
Bin1 = length(find(MeanBinMap==1))/NumVox;
Bin2 = length(find(MeanBinMap==2))/NumVox;
Bin3 = length(find(MeanBinMap==3))/NumVox;
Bin4 = length(find(MeanBinMap==4))/NumVox;
Bin5 = length(find(MeanBinMap==5))/NumVox;
Bin6 = length(find(MeanBinMap==6))/NumVox;
Bin7 = length(find(MeanBinMap==7))/NumVox;
Bin8 = length(find(MeanBinMap==8))/NumVox;
Bin9 = length(find(MeanBinMap==9))/NumVox;

%% Find mean oscillation and percentage of voxels in each oscillation bin for each RBC and Barrier Bin
%RBC:
RBC_bin1_osc = mean(Mean_Pct_Diff(Binned_RBC==1));
RBC_bin2_osc = mean(Mean_Pct_Diff(Binned_RBC==2));
RBC_bin3_osc = mean(Mean_Pct_Diff(Binned_RBC==3));
RBC_bin4_osc = mean(Mean_Pct_Diff(Binned_RBC==4));
RBC_bin5_osc = mean(Mean_Pct_Diff(Binned_RBC==5));
RBC_bin6_osc = mean(Mean_Pct_Diff(Binned_RBC==6));
%Barrier
Bar_bin1_osc = mean(Mean_Pct_Diff(Binned_Bar==1));
Bar_bin2_osc = mean(Mean_Pct_Diff(Binned_Bar==2));
Bar_bin3_osc = mean(Mean_Pct_Diff(Binned_Bar==3));
Bar_bin4_osc = mean(Mean_Pct_Diff(Binned_Bar==4));
Bar_bin5_osc = mean(Mean_Pct_Diff(Binned_Bar==5));
Bar_bin6_osc = mean(Mean_Pct_Diff(Binned_Bar==6));
Bar_bin7_osc = mean(Mean_Pct_Diff(Binned_Bar==7));
Bar_bin8_osc = mean(Mean_Pct_Diff(Binned_Bar==8));

%Pass to a function to display how RBC oscillations stack up in different
%RBC or barrier defect regions... This probably needs a little bit of work
%to be more useful
BarFig = gen_keyhole_bar_fig(MeanBinMap,Binned_RBC,Binned_Bar);

%% Generate Quantile Quantile Plot and Oscillation vs RBC signal

Mean_Pct_Diff_Tmp(Mean_Pct_Diff_Tmp>90) = [];
Mean_Pct_Diff_Tmp(Mean_Pct_Diff_Tmp<-45) = [];
QQ_Osc_Signal_Fig = figure('Name','Quantile-Quantile Plot and Oscillation vs Dissolved signal');
set(QQ_Osc_Signal_Fig,'color','white','Units','inches','Position',[0.25 0.25 12 7])
subplot(1,3,1)
qqplot(Healthy_Cohort_Osc_Dist,Mean_Pct_Diff_Tmp);
hold on
plot([-50 100],[-50 100],'k--')
legend('Quartile Line','1st-3rd Quartiles','Data','y = x','Location','southeast')
xlabel('Healthy Cohort Oscillation Values')
ylabel('Individual Subject Oscillation Values')
title('QQ Plot for Individual Subject vs Healthy Cohort')
xlim([-50 100]);
ylim([-50 100]);
axis square

RBC_Tot2Gas_Tmp = RBC_Tot2Gas(RBC_Mask==1);
Bar_Tot2Gas_Tmp = Bar_Tot2Gas(RBC_Mask==1);
Mean_Osc_Tmp = Mean_Pct_Diff(RBC_Mask==1);

subplot(1,3,2)
plot(Bar_Tot2Gas_Tmp,Mean_Osc_Tmp,'.k')
xlabel('Barrier to Gas in a Given Voxel')
ylabel('RBC Oscillation in a Given Voxel')
title('Oscillation vs Barrier Signal voxel by voxel')

subplot(1,3,3)
plot(RBC_Tot2Gas_Tmp,Mean_Osc_Tmp,'.k')
xlabel('RBC to Gas in a Given Voxel')
ylabel('RBC Oscillation in a Given Voxel')
title('Oscillation vs RBC Signal voxel by voxel')

%% A-P gradients, Apical-Basal Gradients, Center Peripheral Gradients
%Make sure masks are in the right place
First_Slice1 = 0;
sumMask = 0;
while sumMask == 0
    First_Slice1 = First_Slice1+1;
    sumMask = sum(reshape(Mask(First_Slice1,:,:),1,[]));
end
Last_Slice1 = size(Mask,1)+1;
sumMask = 0;
while sumMask == 0
    Last_Slice1 = Last_Slice1-1;
    sumMask = sum(reshape(Mask(Last_Slice1,:,:),1,[]));
end

First_Slice2 = 0;
sumMask = 0;
while sumMask == 0
    First_Slice2 = First_Slice2+1;
    sumMask = sum(reshape(Mask(:,First_Slice2,:),1,[]));
end
Last_Slice2 = size(Mask,1)+1;
sumMask = 0;
while sumMask == 0
    Last_Slice2 = Last_Slice2-1;
    sumMask = sum(reshape(Mask(:,Last_Slice2,:),1,[]));
end

First_Slice3 = 0;
sumMask = 0;
while sumMask == 0
    First_Slice3 = First_Slice3+1;
    sumMask = sum(reshape(Mask(:,:,First_Slice3),1,[]));
end
Last_Slice3 = size(Mask,1)+1;
sumMask = 0;
while sumMask == 0
    Last_Slice3 = Last_Slice3-1;
    sumMask = sum(reshape(Mask(:,:,Last_Slice3),1,[]));
end
% Put together masks
Base_Mask = RBC_Mask;
Base_Mask(1:size(Mask,1)/2,:,:) = 0;

Apex_Mask = RBC_Mask;
Apex_Mask((size(Mask,1)/2+1):size(Mask,1),:,:) = 0;

Post_Mask = RBC_Mask;
Post_Mask(:,1:size(Mask,1)/2,:) = 0;

Ant_Mask = RBC_Mask;
Ant_Mask(:,(size(Mask,1)/2+1):size(Mask,1),:) = 0;

meanrad = mean([(Last_Slice3-First_Slice3)/2 (Last_Slice2-First_Slice2)/2 (Last_Slice1-First_Slice1)/2]);
cent_rad = 0.6*meanrad;

ImSize = size(Mask,1);

Cent_Mask_Pre = zeros(size(RBC_Mask));
[x,y,z] = meshgrid((-((ImSize/2)-1)):(ImSize/2),(-((ImSize/2)-1)):(ImSize/2), (-((ImSize/2)-1)):(ImSize/2));
rad_from_cent = sqrt(x.^2 + y.^2 + z.^2);
Cent_Mask_Pre(rad_from_cent <= cent_rad) = 1;
Edge_Mask_Pre = zeros(size(RBC_Mask));
Edge_Mask_Pre(Cent_Mask_Pre==0) = 1;

Cent_Mask = Cent_Mask_Pre.*RBC_Mask;
Edge_Mask = Edge_Mask_Pre.*RBC_Mask;


Base_Mean_Pct_Diff = Mean_Pct_Diff(Base_Mask==1);
Apex_Mean_Pct_Diff = Mean_Pct_Diff(Apex_Mask==1);
Ant_Mean_Pct_Diff = Mean_Pct_Diff(Ant_Mask==1);
Post_Mean_Pct_Diff = Mean_Pct_Diff(Post_Mask==1);
Cent_Mean_Pct_Diff = Mean_Pct_Diff(Cent_Mask==1);
Edge_Mean_Pct_Diff = Mean_Pct_Diff(Edge_Mask==1);

Base_MeanBinMap = MeanBinMap(Base_Mask==1);
Apex_MeanBinMap = MeanBinMap(Apex_Mask==1);
Ant_MeanBinMap = MeanBinMap(Ant_Mask==1);
Post_MeanBinMap = MeanBinMap(Post_Mask==1);
Cent_MeanBinMap = MeanBinMap(Cent_Mask==1);
Edge_MeanBinMap = MeanBinMap(Edge_Mask==1);

Base_Mean_Osc = mean(Base_Mean_Pct_Diff);
Apex_Mean_Osc = mean(Apex_Mean_Pct_Diff);
Ant_Mean_Osc = mean(Ant_Mean_Pct_Diff);
Post_Mean_Osc = mean(Post_Mean_Pct_Diff);
Cent_Mean_Osc = mean(Cent_Mean_Pct_Diff);
Edge_Mean_Osc = mean(Edge_Mean_Pct_Diff);

Base_Low_Pct = (nnz(Base_MeanBinMap==1) + nnz(Base_MeanBinMap==2))/nnz(Base_Mask); 
Base_High_Pct = (nnz(Base_MeanBinMap==5) + nnz(Base_MeanBinMap==6)+nnz(Base_MeanBinMap==7)+nnz(Base_MeanBinMap==8))/nnz(Base_Mask); 

Apex_Low_Pct = (nnz(Apex_MeanBinMap==1) + nnz(Apex_MeanBinMap==2))/nnz(Apex_Mask); 
Apex_High_Pct = (nnz(Apex_MeanBinMap==5) + nnz(Apex_MeanBinMap==6)+nnz(Apex_MeanBinMap==7)+nnz(Apex_MeanBinMap==8))/nnz(Apex_Mask); 

Ant_Low_Pct = (nnz(Ant_MeanBinMap==1) + nnz(Ant_MeanBinMap==2))/nnz(Ant_Mask); 
Ant_High_Pct = (nnz(Ant_MeanBinMap==5) + nnz(Ant_MeanBinMap==6)+nnz(Ant_MeanBinMap==7)+nnz(Ant_MeanBinMap==8))/nnz(Ant_Mask); 

Post_Low_Pct = (nnz(Post_MeanBinMap==1) + nnz(Post_MeanBinMap==2))/nnz(Post_Mask); 
Post_High_Pct = (nnz(Post_MeanBinMap==5) + nnz(Post_MeanBinMap==6)+nnz(Post_MeanBinMap==7)+nnz(Post_MeanBinMap==8))/nnz(Post_Mask); 

Cent_Low_Pct = (nnz(Cent_MeanBinMap==1) + nnz(Cent_MeanBinMap==2))/nnz(Cent_Mask); 
Cent_High_Pct = (nnz(Cent_MeanBinMap==5) + nnz(Cent_MeanBinMap==6)+nnz(Cent_MeanBinMap==7)+nnz(Cent_MeanBinMap==8))/nnz(Cent_Mask); 

Edge_Low_Pct = (nnz(Edge_MeanBinMap==1) + nnz(Edge_MeanBinMap==2))/nnz(Edge_Mask); 
Edge_High_Pct = (nnz(Edge_MeanBinMap==5) + nnz(Edge_MeanBinMap==6)+nnz(Edge_MeanBinMap==7)+nnz(Edge_MeanBinMap==8))/nnz(Edge_Mask); 

% %% Save important values to spreadsheet
% %%Summary Oscillation Values
% disp('Saving Values of Interest to Summary Spreadsheet...')
% [~, ~, ExcelFileRaw] = xlsread('C:\Users\NIES4T\OneDrive - cchmc\Documents\Data Analysis\RBC Oscillations\Keyhole_Dissolved_Phase_Summary_Auto_DetDis_New.xlsx');
% NextLine = size(ExcelFileRaw,1)+1;
% NewLine = {Subject, datestr(date,29),MeanRBCMeasure, Pct_Mean_Mean, Pct_Mean_STD, Pct_Mean_CV, RBC_Low_SNR,RBC_High_SNR,RBC_Tot_SNR,Bin1,Bin2,Bin3,Bin4,Bin5,Bin6,Bin7,Bin8,Bin9,RBC_bin1_osc,RBC_bin2_osc,RBC_bin3_osc,RBC_bin4_osc,RBC_bin5_osc,RBC_bin6_osc,Bar_bin1_osc,Bar_bin2_osc,Bar_bin3_osc,Bar_bin4_osc,Bar_bin5_osc,Bar_bin6_osc,Bar_bin7_osc,Bar_bin8_osc};     
% xlRange = ['A',num2str(NextLine)];
% xlswrite('C:\Users\NIES4T\OneDrive - cchmc\Documents\Data Analysis\RBC Oscillations\Keyhole_Dissolved_Phase_Summary_Auto_DetDis_New.xlsx',NewLine,1,xlRange);
% 
% %Summary lung gradients
% [~, ~, ExcelFileRaw] = xlsread('C:\Users\NIES4T\OneDrive - cchmc\Documents\Data Analysis\RBC Oscillations\Ant_Post_Base_Apex_Cent_Periph_Osc_Grads.xlsx');
% NextLine = size(ExcelFileRaw,1)+1;
% NewLine = {Subject, Base_Mean_Osc,Apex_Mean_Osc,Ant_Mean_Osc,Post_Mean_Osc,Cent_Mean_Osc,Edge_Mean_Osc,Base_Low_Pct,Base_High_Pct,Apex_Low_Pct,Apex_High_Pct,Ant_Low_Pct,Ant_High_Pct,Post_Low_Pct,Post_High_Pct,Cent_Low_Pct,Cent_High_Pct,Edge_Low_Pct,Edge_High_Pct};     
% xlRange = ['A',num2str(NextLine)];
% xlswrite('C:\Users\NIES4T\OneDrive - cchmc\Documents\Data Analysis\RBC Oscillations\Ant_Post_Base_Apex_Cent_Periph_Osc_Grads.xlsx',NewLine,1,xlRange);
% 
% %Summary RBC, Barrier, and Total Dissolved Phase Oscillations
% % %% Save important values to spreadsheet 2
% disp('Saving Values of Interest to Summary Spreadsheet...')
% %Subject;Scan Date;Processing Date;Vent SNR;Gas SNR;Barrier SNR;RBC SNR;Vent Mean;Vent STD;Barrier-Uptake Mean;Barrier-Uptake STD;RBC-Transfer Mean;RBC-Transfer STD;RBC/Barrier Mean;RBC/Barrier STD;Vent Defect Percent;Vent Low Percent;Vent High Percent;Barrier Defect Percent;Barrier Low Percent;Barrier High Percent;RBC Defect Percent;RBC Low Percent;RBC High Percent;RBC:Barrier Defect Percent;RBC:Barrier Low Percent;RBC:Barrier High Percent;Gas T2*;Barrier T2*;RBC T2*;Phase Separation;RBC:Barrier Ratio;Gas Phase Contamination;Registered?;Recon Version;Healthy Cohort #;Seqeunce Version;Notes
% [~, ~, ExcelFileRaw] = xlsread('C:\Users\NIES4T\OneDrive - cchmc\Documents\Data Analysis\RBC Oscillations\Tot_Bar_RBC_Oscillations.xlsx');
% NextLine = size(ExcelFileRaw,1)+1;
% NewLine = {Subject,Mean_Tot_Diff,SD_Tot_Diff,Mean_Bar_Diff,SD_Bar_Diff,Pct_Mean_Mean,Pct_Mean_STD};     
% xlRange = ['A',num2str(NextLine)];
% xlswrite('C:\Users\NIES4T\OneDrive - cchmc\Documents\Data Analysis\RBC Oscillations\Tot_Bar_RBC_Oscillations.xlsx',NewLine,1,xlRange);

%% Save important values to spreadsheet

% Get image SNR
RBC_High_SNR = (mean((RBC_High(Mask==1))) - mean((RBC_High(Mask == 0))))/ std((RBC_High(Mask==0)));
RBC_Low_SNR = (mean((RBC_Low(Mask==1))) - mean((RBC_Low(Mask == 0))))/ std((RBC_Low(Mask==0)));
RBC_Tot_SNR = (mean((RBC_Tot(Mask==1))) - mean((RBC_Tot(Mask == 0))))/ std((RBC_Tot(Mask==0)));

pct_low = (Bin1+Bin2)/(1-Bin9);
pct_high = (Bin5+Bin6+Bin7+Bin8)/(1-Bin9);

%%Summary Oscillation Values
disp('Saving Values of Interest to Summary Spreadsheet...')
[~, ~, ExcelFileRaw] = xlsread('C:\Users\NIES4T\OneDrive - cchmc\Documents\Data Analysis\RBC Oscillations\Keyhole_Dissolved_Phase_Summary_Auto_HighPass_Check.xlsx');
NextLine = size(ExcelFileRaw,1)+1;
NewLine = {Subject, datestr(date,29),MeanRBCMeasure, Pct_Mean_Mean, Pct_Mean_STD, Pct_Mean_CV, RBC_Low_SNR,RBC_High_SNR,RBC_Tot_SNR,pct_low,pct_high};     
xlRange = ['A',num2str(NextLine)];
xlswrite('C:\Users\NIES4T\OneDrive - cchmc\Documents\Data Analysis\RBC Oscillations\Keyhole_Dissolved_Phase_Summary_Auto_HighPass_Check.xlsx',NewLine,1,xlRange);

%Summary lung gradients
[~, ~, ExcelFileRaw] = xlsread('C:\Users\NIES4T\OneDrive - cchmc\Documents\Data Analysis\RBC Oscillations\Ant_Post_Base_Apex_Cent_Periph_Osc_Grads_2.xlsx');
NextLine = size(ExcelFileRaw,1)+1;
NewLine = {Subject, Base_Mean_Osc,Apex_Mean_Osc,Ant_Mean_Osc,Post_Mean_Osc,Cent_Mean_Osc,Edge_Mean_Osc,Base_Low_Pct,Base_High_Pct,Apex_Low_Pct,Apex_High_Pct,Ant_Low_Pct,Ant_High_Pct,Post_Low_Pct,Post_High_Pct,Cent_Low_Pct,Cent_High_Pct,Edge_Low_Pct,Edge_High_Pct};     
xlRange = ['A',num2str(NextLine)];
xlswrite('C:\Users\NIES4T\OneDrive - cchmc\Documents\Data Analysis\RBC Oscillations\Ant_Post_Base_Apex_Cent_Periph_Osc_Grads_2.xlsx',NewLine,1,xlRange);

%Summary RBC, Barrier, and Total Dissolved Phase Oscillations
% %% Save important values to spreadsheet 2
disp('Saving Values of Interest to Summary Spreadsheet...')
%Subject;Scan Date;Processing Date;Vent SNR;Gas SNR;Barrier SNR;RBC SNR;Vent Mean;Vent STD;Barrier-Uptake Mean;Barrier-Uptake STD;RBC-Transfer Mean;RBC-Transfer STD;RBC/Barrier Mean;RBC/Barrier STD;Vent Defect Percent;Vent Low Percent;Vent High Percent;Barrier Defect Percent;Barrier Low Percent;Barrier High Percent;RBC Defect Percent;RBC Low Percent;RBC High Percent;RBC:Barrier Defect Percent;RBC:Barrier Low Percent;RBC:Barrier High Percent;Gas T2*;Barrier T2*;RBC T2*;Phase Separation;RBC:Barrier Ratio;Gas Phase Contamination;Registered?;Recon Version;Healthy Cohort #;Seqeunce Version;Notes
[~, ~, ExcelFileRaw] = xlsread('C:\Users\NIES4T\OneDrive - cchmc\Documents\Data Analysis\RBC Oscillations\Tot_Bar_RBC_Oscillations_2.xlsx');
NextLine = size(ExcelFileRaw,1)+1;
NewLine = {Subject,Mean_Tot_Diff,SD_Tot_Diff,Mean_Bar_Diff,SD_Bar_Diff,Pct_Mean_Mean,Pct_Mean_STD};     
xlRange = ['A',num2str(NextLine)];
xlswrite('C:\Users\NIES4T\OneDrive - cchmc\Documents\Data Analysis\RBC Oscillations\Tot_Bar_RBC_Oscillations_2.xlsx',NewLine,1,xlRange);

%% Save workspace
save(fullfile(path,'Detrended Gas Exchange Keyhole Workspace V3.mat'));