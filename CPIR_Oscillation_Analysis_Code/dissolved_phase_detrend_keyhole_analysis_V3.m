function dissolved_phase_detrend_keyhole_analysis_V3(Traj,GasFID,DisFID,TR,RBC2Barrier,lowpassYN,ScannerType,Subject,path)

%Arguments:
%          ScannerType - 'GE','Siemens',or 'Philips' - so that the images that are output are rotated properly 

%% Start by cutting out approach to steady state
N_App_Steady = 40; %In the past, 40 has seemed like a good number
%For consistency, cut out points in Gas, Dissolved, and trajectories

GasFID(:,1:N_App_Steady) = [];
DisFID(:,1:N_App_Steady) = [];
Traj(:,:,1:N_App_Steady) = [];

%% Bin into High and Low keys based on RBC Oscillations
[High_Key,Low_Key,DisFID,GasHigh,GasLow,RBC2Bar,Shift_Raw_FIDs_Fig,Smooth_Detrend_Fig] = dissolved_phase_RBC_detrend_bin(Traj,GasFID,DisFID,TR,RBC2Barrier,lowpassYN,ScannerType);

%% Reshape Data for Reconstruction
Traj_x = reshape(Traj(1,:,:),1,[])';
Traj_y = reshape(Traj(2,:,:),1,[])';
Traj_z = reshape(Traj(3,:,:),1,[])';

Traj_C = [Traj_x,Traj_y,Traj_z];

GasFID_C = reshape(GasFID,1,[])';
DisFID_C = reshape(DisFID,1,[])';

High_Key_C = reshape(High_Key,1,[])';
Low_Key_C = reshape(Low_Key,1,[])';
GasHigh_C = reshape(GasHigh,1,[])';
GasLow_C = reshape(GasLow,1,[])';
%Remove Zeros and corresponding trajectory points from the key raw data

Zeros_High = find(High_Key_C == 0);
Zeros_Low = find(Low_Key_C == 0);

High_Traj_C = Traj_C;
Low_Traj_C = Traj_C;

High_Key_C(Zeros_High) = [];
High_Traj_C(Zeros_High,:) = [];

Low_Key_C(Zeros_Low) = [];
Low_Traj_C(Zeros_Low,:) = [];

GasHigh_C(Zeros_High) = [];
GasLow_C(Zeros_Low) = [];

%% Reconstruct Images - Set Image Size
if size(GasFID,1) == 32 %|| size(GasFID,1) == 64
    ImSize = 48;
else
    ImSize = 96;
end

%% Reconstruct, Rotate, and Crop Images
switch ScannerType
    case 'GE'
        if size(GasFID,1) == 32 %|| size(GasFID,1) == 64
            CropSize = 48;
        else
            CropSize = 96;
        end
        %Reconstruct Images
        Gas_Image = dissolved_phase_recon_lowres(ImSize,GasFID_C,Traj_C);
        Dis_Image = dissolved_phase_recon_lowres(ImSize,DisFID_C,Traj_C);
        High_Image = dissolved_phase_recon_lowres(ImSize,High_Key_C,High_Traj_C);
        Low_Image = dissolved_phase_recon_lowres(ImSize,Low_Key_C,Low_Traj_C);
        HighGas_Image = dissolved_phase_recon_lowres(ImSize,GasHigh_C,High_Traj_C);
        LowGas_Image = dissolved_phase_recon_lowres(ImSize,GasLow_C,Low_Traj_C);

        [~,Low_Res_Gas_Mask] = erode_dilate(Gas_Image,1,5);
        %Get a High Res Gas Image as well, for masking purposes
        Gas_HiRes_Image = dissolved_phase_recon_highres(ImSize,GasFID_C,Traj_C);
        [~,High_Res_Gas_Mask] = erode_dilate(Gas_HiRes_Image,1,5);
        
        %Center Lungs in Center of Image
        Gas_Image = center_and_crop(Gas_Image,High_Res_Gas_Mask,CropSize);
        High_Image = center_and_crop(High_Image,High_Res_Gas_Mask,CropSize);
        Low_Image = center_and_crop(Low_Image,High_Res_Gas_Mask,CropSize);
        Dis_Image = center_and_crop(Dis_Image,High_Res_Gas_Mask,CropSize);
        HighGas_Image = center_and_crop(HighGas_Image,High_Res_Gas_Mask,CropSize);
        LowGas_Image = center_and_crop(LowGas_Image,High_Res_Gas_Mask,CropSize);
        
        Gas_HiRes_Image = center_and_crop(Gas_HiRes_Image,High_Res_Gas_Mask,CropSize);
        
        %Rotate Images
        Gas_Image = GE_image_rotate(Gas_Image);
        Dis_Image = GE_image_rotate(Dis_Image);
        High_Image = GE_image_rotate(High_Image);
        Low_Image = GE_image_rotate(Low_Image);
        HighGas_Image = GE_image_rotate(HighGas_Image);
        LowGas_Image = GE_image_rotate(LowGas_Image);
        [~,Low_Res_Gas_Mask] = erode_dilate(Gas_Image,1,5);
        Gas_HiRes_Image = GE_image_rotate(Gas_HiRes_Image);
        [~,High_Res_Gas_Mask] = erode_dilate(Gas_HiRes_Image,1,5);
    case 'Siemens'
        ImSize = 128;
        %Reconstruct Images
        Gas_Image = dissolved_phase_recon_Siemenslowres(ImSize,GasFID_C,Traj_C);
        Dis_Image = dissolved_phase_recon_Siemenslowres(ImSize,DisFID_C,Traj_C);
        High_Image = dissolved_phase_recon_Siemenslowres(ImSize,High_Key_C,High_Traj_C);
        Low_Image = dissolved_phase_recon_Siemenslowres(ImSize,Low_Key_C,Low_Traj_C);
        HighGas_Image = dissolved_phase_recon_Siemenslowres(ImSize,GasHigh_C,High_Traj_C);
        LowGas_Image = dissolved_phase_recon_Siemenslowres(ImSize,GasLow_C,Low_Traj_C);

        [~,Low_Res_Gas_Mask] = erode_dilate(Gas_Image,1,5);
        %Get a High Res Gas Image as well, for masking purposes
        Gas_HiRes_Image = dissolved_phase_recon_SIEMENShires(ImSize,GasFID_C,Traj_C);
        
        [~,High_Res_Gas_Mask] = erode_dilate(Gas_HiRes_Image,1,5);
        
        %Center Lungs in the center of images
        Gas_Image = center_and_crop(Gas_Image,High_Res_Gas_Mask,ImSize);
        High_Image = center_and_crop(High_Image,High_Res_Gas_Mask,ImSize);
        Low_Image = center_and_crop(Low_Image,High_Res_Gas_Mask,ImSize);
        Dis_Image = center_and_crop(Dis_Image,High_Res_Gas_Mask,ImSize);
        HighGas_Image = center_and_crop(HighGas_Image,High_Res_Gas_Mask,ImSize);
        LowGas_Image = center_and_crop(LowGas_Image,High_Res_Gas_Mask,ImSize);
        
        Gas_HiRes_Image = center_and_crop(Gas_HiRes_Image,High_Res_Gas_Mask,ImSize);
        
        %Rotate Images
        Gas_Image = Siemens_image_rotate(Gas_Image);
        Dis_Image = Siemens_image_rotate(Dis_Image);
        High_Image = Siemens_image_rotate(High_Image);
        Low_Image = Siemens_image_rotate(Low_Image);
        HighGas_Image = Siemens_image_rotate(HighGas_Image);
        LowGas_Image = Siemens_image_rotate(LowGas_Image);
        Gas_HiRes_Image = Siemens_image_rotate(Gas_HiRes_Image);
        [~,Low_Res_Gas_Mask] = erode_dilate(Gas_Image,1,5);
        [~,High_Res_Gas_Mask] = erode_dilate(Gas_HiRes_Image,1,5);
        %For Siemens data, the low res mask is way better than the high
        %res:
        %High_Res_Gas_Mask = Low_Res_Gas_Mask;
    case 'Philips_V2'
        ImSize = 56;
        %Reconstruct Images
        Gas_Image = dissolved_phase_recon_Siemenslowres(ImSize,GasFID_C,Traj_C);
        Dis_Image = dissolved_phase_recon_Siemenslowres(ImSize,DisFID_C,Traj_C);
        High_Image = dissolved_phase_recon_Siemenslowres(ImSize,High_Key_C,High_Traj_C);
        Low_Image = dissolved_phase_recon_Siemenslowres(ImSize,Low_Key_C,Low_Traj_C);
        HighGas_Image = dissolved_phase_recon_Siemenslowres(ImSize,GasHigh_C,High_Traj_C);
        LowGas_Image = dissolved_phase_recon_Siemenslowres(ImSize,GasLow_C,Low_Traj_C);
        Gas_HiRes_Image = dissolved_phase_recon_SIEMENShires(ImSize,GasFID_C,Traj_C);
        
        [~,Low_Res_Gas_Mask] = erode_dilate(Gas_Image,1,5);
        %Get a High Res Gas Image as well, for masking purposes
        [~,High_Res_Gas_Mask] = erode_dilate(Gas_HiRes_Image,1,5);
        
        %Put in a check to make sure that masks have at least some voxels
        thresh = 5;
        while sum(High_Res_Gas_Mask(:))==0
            thresh = thresh - 1;
            [~,High_Res_Gas_Mask] = erode_dilate(Gas_HiRes_Image,1,thresh);
        end

        %Center Images
        Gas_Image = center_and_crop(Gas_Image,High_Res_Gas_Mask,ImSize);
        High_Image = center_and_crop(High_Image,High_Res_Gas_Mask,ImSize);
        Low_Image = center_and_crop(Low_Image,High_Res_Gas_Mask,ImSize);
        Dis_Image = center_and_crop(Dis_Image,High_Res_Gas_Mask,ImSize);
        HighGas_Image = center_and_crop(HighGas_Image,High_Res_Gas_Mask,ImSize);
        LowGas_Image = center_and_crop(LowGas_Image,High_Res_Gas_Mask,ImSize);
        Gas_HiRes_Image = center_and_crop(Gas_HiRes_Image,High_Res_Gas_Mask,ImSize);
        
        %Rotate Images
        Gas_Image = Philips_Dis_image_rotate_1(Gas_Image);
        Dis_Image = Philips_Dis_image_rotate_1(Dis_Image);
        High_Image = Philips_Dis_image_rotate_1(High_Image);
        Low_Image = Philips_Dis_image_rotate_1(Low_Image);
        Gas_HiRes_Image = Philips_Dis_image_rotate_1(Gas_HiRes_Image);
        [~,Low_Res_Gas_Mask] = erode_dilate(Gas_Image,1,thresh);
        [~,High_Res_Gas_Mask] = erode_dilate(Gas_HiRes_Image,1,thresh);
case 'Philips_V3'
        ImSize = 56;
        %Reconstruct Images
        Gas_Image = dissolved_phase_recon_Siemenslowres(ImSize,GasFID_C,Traj_C);
        Dis_Image = dissolved_phase_recon_Siemenslowres(ImSize,DisFID_C,Traj_C);
        High_Image = dissolved_phase_recon_Siemenslowres(ImSize,High_Key_C,High_Traj_C);
        Low_Image = dissolved_phase_recon_Siemenslowres(ImSize,Low_Key_C,Low_Traj_C);
        HighGas_Image = dissolved_phase_recon_Siemenslowres(ImSize,GasHigh_C,High_Traj_C);
        LowGas_Image = dissolved_phase_recon_Siemenslowres(ImSize,GasLow_C,Low_Traj_C);
        Gas_HiRes_Image = dissolved_phase_recon_SIEMENShires(ImSize,GasFID_C,Traj_C);
        
        [~,Low_Res_Gas_Mask] = erode_dilate(Gas_Image,1,5);
        %Get a High Res Gas Image as well, for masking purposes
        [~,High_Res_Gas_Mask] = erode_dilate(Gas_HiRes_Image,1,5);
        
        %Put in a check to make sure that masks have at least some voxels
        thresh = 5;
        while sum(High_Res_Gas_Mask(:))==0
            thresh = thresh - 1;
            [~,High_Res_Gas_Mask] = erode_dilate(Gas_HiRes_Image,1,thresh);
        end

        %Center Images
        Gas_Image = center_and_crop(Gas_Image,High_Res_Gas_Mask,ImSize);
        High_Image = center_and_crop(High_Image,High_Res_Gas_Mask,ImSize);
        Low_Image = center_and_crop(Low_Image,High_Res_Gas_Mask,ImSize);
        Dis_Image = center_and_crop(Dis_Image,High_Res_Gas_Mask,ImSize);
        HighGas_Image = center_and_crop(HighGas_Image,High_Res_Gas_Mask,ImSize);
        LowGas_Image = center_and_crop(LowGas_Image,High_Res_Gas_Mask,ImSize);
        Gas_HiRes_Image = center_and_crop(Gas_HiRes_Image,High_Res_Gas_Mask,ImSize);
        
        %Rotate Images
        Gas_Image = Philips_Dis_image_rotate_1(Gas_Image);
        Dis_Image = Philips_Dis_image_rotate_1(Dis_Image);
        High_Image = Philips_Dis_image_rotate_1(High_Image);
        Low_Image = Philips_Dis_image_rotate_1(Low_Image);
        Gas_HiRes_Image = Philips_Dis_image_rotate_1(Gas_HiRes_Image);
        [~,Low_Res_Gas_Mask] = erode_dilate(Gas_Image,1,thresh);
        [~,High_Res_Gas_Mask] = erode_dilate(Gas_HiRes_Image,1,thresh);
end
%% Display Images - Show some total Dissolved Phase Images
First_Slice = 0;
sumMask = 0;
while sumMask == 0
    First_Slice = First_Slice+1;
    sumMask = sum(reshape(High_Res_Gas_Mask(First_Slice,:,:),1,[]));
end
Last_Slice = size(High_Res_Gas_Mask,1)+1;
sumMask = 0;
while sumMask == 0
    Last_Slice = Last_Slice-1;
    sumMask = sum(reshape(High_Res_Gas_Mask(Last_Slice,:,:),1,[]));
end

First_Slice = First_Slice+6;
Last_Slice = Last_Slice-6;
%Let's display six slices
step = floor((Last_Slice - First_Slice)/8);
Slices = First_Slice:step:(First_Slice+8*step);

High_Key_Slices_Fig = figure('Name','Selected Slices of High Dissolved Phase Key');
set(High_Key_Slices_Fig,'color','white','Units','inches','Position',[0.25 0.25 6 6])
[ha, pos] = tight_subplot(3, 3, 0.01, 0.01, 0.01);
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

Low_Key_Slices_Fig = figure('Name','Selected Slices of Low Dissolved Phase Key');
set(Low_Key_Slices_Fig,'color','white','Units','inches','Position',[9 0.25 6 6])
[ha, pos] = tight_subplot(3, 3, 0.01, 0.01, 0.01);

for slice = 1:length(Slices)
    %Display Ratio Image
    axes(ha(slice));
    imagesc(abs((((squeeze(Low_Image(Slices(slice),:,:)))))))
    colormap(gray)
    caxis manual
    caxis([0 maxvox])
    axis square
    axis off
end

%% Phase Shift Images - Different scanner platforms require slightly different shifts
switch ScannerType
    case 'GE'
        [Shifted_Tot_Image, Tot_Ang,B0PhaseMap] = SinglePointDixonV2(Dis_Image,-RBC2Barrier,Gas_Image,logical(High_Res_Gas_Mask));
        [Shifted_High_Image, High_Ang,B0PhaseMap_High] = SinglePointDixonV2(High_Image,-RBC2Bar.High,Gas_Image,logical(High_Res_Gas_Mask));
        [Shifted_Low_Image, Low_Ang,B0PhaseMap_Low] = SinglePointDixonV2(Low_Image,-RBC2Bar.Low,Gas_Image,logical(High_Res_Gas_Mask));
 %       [Shifted_Tot_Image, Tot_Ang,B0PhaseMap] = SinglePointDixonV2_Osc_Min(Dis_Image,-RBC2Barrier,High_Image,Low_Image,Gas_Image,logical(High_Res_Gas_Mask));
        
    case 'Siemens'
        [Shifted_Tot_Image, Tot_Ang,B0PhaseMap] = SinglePointDixonV2(Dis_Image,RBC2Barrier,Gas_Image,logical(High_Res_Gas_Mask));
        [Shifted_High_Image, High_Ang,B0PhaseMap_High] = SinglePointDixonV2(High_Image,RBC2Bar.High,Gas_Image,logical(High_Res_Gas_Mask));
        [Shifted_Low_Image, Low_Ang,B0PhaseMap_Low] = SinglePointDixonV2(Low_Image,RBC2Bar.Low,Gas_Image,logical(High_Res_Gas_Mask));
    case 'Philips_V2'
        [Shifted_Tot_Image, Tot_Ang,B0PhaseMap] = SinglePointDixonV2(Dis_Image,-RBC2Barrier,Gas_Image,logical(High_Res_Gas_Mask));
        [Shifted_High_Image, High_Ang,B0PhaseMap_High] = SinglePointDixonV2(High_Image,-RBC2Bar.High,Gas_Image,logical(High_Res_Gas_Mask));
        [Shifted_Low_Image, Low_Ang,B0PhaseMap_Low] = SinglePointDixonV2(Low_Image,-RBC2Bar.Low,Gas_Image,logical(High_Res_Gas_Mask));
    case 'Philips_V3'
        [Shifted_Tot_Image, Tot_Ang,B0PhaseMap] = SinglePointDixonV2(Dis_Image,-RBC2Barrier,Gas_Image,logical(High_Res_Gas_Mask));
        [Shifted_High_Image, High_Ang,B0PhaseMap_High] = SinglePointDixonV2(High_Image,-RBC2Bar.High,Gas_Image,logical(High_Res_Gas_Mask));
        [Shifted_Low_Image, Low_Ang,B0PhaseMap_Low] = SinglePointDixonV2(Low_Image,-RBC2Bar.Low,Gas_Image,logical(High_Res_Gas_Mask));
end


%Make sure shifted images have positive values:
RBC_High = real(Shifted_High_Image);
if mean(RBC_High(High_Res_Gas_Mask==1)) < 0
    RBC_High = -RBC_High;
end
RBC_Low = real(Shifted_Low_Image);
if mean(RBC_Low(High_Res_Gas_Mask==1)) < 0
    RBC_Low = -RBC_Low;
end
RBC_Tot = real(Shifted_Tot_Image);
if mean(RBC_Tot(High_Res_Gas_Mask==1)) < 0
    RBC_Tot = -RBC_Tot;
end
Bar_High = imag(Shifted_High_Image);
if mean(Bar_High(High_Res_Gas_Mask==1)) < 0
    Bar_High = -Bar_High;
end
Bar_Low = imag(Shifted_Low_Image);
if mean(Bar_Low(High_Res_Gas_Mask==1)) < 0
    Bar_Low = -Bar_Low;
end
Bar_Tot = imag(Shifted_Tot_Image);
if mean(Bar_Tot(High_Res_Gas_Mask==1)) < 0
    Bar_Tot = -Bar_Tot;
end

%Check RBC to Barrier Ratios after phase shift to make sure it was done
%right
TmpMask = High_Res_Gas_Mask;
%TmpMask(RBC_High == 0) = 0;
HighRBC = RBC_High;
HighRBC(TmpMask == 0) = [];
HighBar = Bar_High;
HighBar(TmpMask == 0) = [];

TmpMask = High_Res_Gas_Mask;
%TmpMask(RBC_Low == 0) = 0;
LowRBC = RBC_Low;
LowRBC(TmpMask == 0) = [];
LowBar = Bar_Low;
LowBar(TmpMask == 0) = [];

TmpMask = High_Res_Gas_Mask;
%TmpMask(RBC_Tot == 0) = 0;
TotRBC = RBC_Tot;
TotRBC(TmpMask == 0) = [];
TotBar = Bar_Tot;
TotBar(TmpMask == 0) = [];

check_tot_shift = mean(TotRBC)/mean(TotBar);
check_high_shift = mean(HighRBC)/mean(HighBar);
check_low_shift = mean(LowRBC)./mean(LowBar);

if check_tot_shift < 0 || check_high_shift < 0 || check_low_shift < 0
    error('RBC and Barrier are not both positive')
end
%% Pass to an analysis function
[Total_Dissolved_Key_Diff_Fig,RBC_PctRBC_Key_Diff_Fig,Binning_Fig,Histograms,Barrier_Key_Diff_Fig,BarFig,QQ_Osc_Signal_Fig] = analyze_display_detrend_keyhole_dissolvedPhase_V3(Shifted_High_Image,Shifted_Low_Image,Shifted_Tot_Image,Gas_Image,High_Res_Gas_Mask,Low_Res_Gas_Mask,Subject,ScannerType,path);

% Get image SNR
RBC_High_SNR = (mean((RBC_High(TmpMask==1))) - mean((RBC_High(TmpMask == 0))))/ std((RBC_High(TmpMask==0)));
RBC_Low_SNR = (mean((RBC_Low(TmpMask==1))) - mean((RBC_Low(TmpMask == 0))))/ std((RBC_Low(TmpMask==0)));
RBC_Tot_SNR = (mean((RBC_Tot(TmpMask==1))) - mean((RBC_Tot(TmpMask == 0))))/ std((RBC_Tot(TmpMask==0)));

Bar_High_SNR = (mean((Bar_High(TmpMask==1))) - mean((Bar_High(TmpMask == 0))))/ std((Bar_High(TmpMask==0)));
Bar_Low_SNR = (mean((Bar_Low(TmpMask==1))) - mean((Bar_Low(TmpMask == 0))))/ std((Bar_Low(TmpMask==0)));
Bar_Tot_SNR = (mean((Bar_Tot(TmpMask==1))) - mean((Bar_Tot(TmpMask == 0))))/ std((Bar_Tot(TmpMask==0)));

Dis_High_SNR = (mean(abs(Shifted_High_Image(TmpMask==1))) - mean(abs(Shifted_High_Image(TmpMask == 0))))/ std(abs(Shifted_High_Image(TmpMask==0)));
Dis_Low_SNR = (mean(abs(Shifted_Low_Image(TmpMask==1))) - mean(abs(Shifted_Low_Image(TmpMask == 0))))/ std(abs(Shifted_Low_Image(TmpMask==0)));
Dis_Tot_SNR = (mean(abs(Shifted_Tot_Image(TmpMask==1))) - mean(abs(Shifted_Tot_Image(TmpMask == 0))))/ std(abs(Shifted_Tot_Image(TmpMask==0)));

Gas_SNR = (mean(abs(Gas_HiRes_Image(TmpMask==1))) - mean(abs(Gas_HiRes_Image(TmpMask == 0))))/ std(abs(Gas_HiRes_Image(TmpMask==0)));

%% PPT Report
%Start new presentation
isOpen  = exportToPPTX();
if ~isempty(isOpen) %If PowerPoint already started, then close first and then open a new one
    exportToPPTX('close');
end
ReportTitle = [Subject,'Keyhole Gas Exchange Summary HighPass_Check'];
exportToPPTX('new','Dimensions',[16 9], ...
    'Title',ReportTitle, ...
    'Author','CPIR @ CCHMC');

%Add slides
exportToPPTX('addslide'); %Title Slide
exportToPPTX('addtext',sprintf(Subject), ...
    'Position',[0 0 16 4.5], ...
    'VerticalAlignment','bottom', ...
    'HorizontalAlignment','center', ...
    'FontSize',72, ...
    'FontWeight','bold');
exportToPPTX('addtext',sprintf(['Processing Date: ',datestr(date,29)]), ...
    'Position',[0 4.5 16 4.5], ...
    'VerticalAlignment','top', ...
    'HorizontalAlignment','center', ...
    'FontSize',36);

exportToPPTX('addslide'); %FIDs
exportToPPTX('addpicture',Shift_Raw_FIDs_Fig);
exportToPPTX('addtext',sprintf('k0 for FIDs'));

exportToPPTX('addslide'); %Binning Figure
exportToPPTX('addpicture',Smooth_Detrend_Fig);
exportToPPTX('addtext',sprintf('Binning Workflow'));

exportToPPTX('addslide');
exportToPPTX('addtext',sprintf('Image Characteristics'));

tableData   = { ...
    'Gas SNR',Gas_SNR; ...
    'Total Dissolved SNR',Dis_Tot_SNR; ...
    'High Dissolved SNR',Dis_High_SNR; ...
    'Low Dissolved SNR',Dis_Low_SNR; ...
    'Total Barrier SNR',Bar_Tot_SNR; ...
    'High Barrier SNR',Bar_High_SNR; ...
    'Low Barrier SNR',Bar_Low_SNR; ...
    'Total RBC SNR',RBC_Tot_SNR; ...
    'High RBC SNR',RBC_High_SNR;...
    'Low RBC SNR',RBC_Low_SNR;
    'Total RBC/Barrier',check_tot_shift;
    'High RBC/Barrier',check_high_shift;
    'Low RBC/Barrier',check_low_shift;};

exportToPPTX('addtable',tableData,'Position',[2 1 8 4], ...
    'Vert','middle','Horiz','center','FontSize',13, ...
    'ColumnWidth',[0.5 0.5 ],'BackgroundColor','w', ...
    'EdgeColor','k','LineWidth',2);

exportToPPTX('addslide'); %Key 1 and Key 2 Images
exportToPPTX('addtext',sprintf('High and Low Key Images'));
exportToPPTX('addpicture',High_Key_Slices_Fig,'Position',[0 1 8 8]);
exportToPPTX('addtext',sprintf('High Key'), ...
        'Position',[0 0.75 7.5 7.5],...
        'HorizontalAlignment','right');
exportToPPTX('addpicture',Low_Key_Slices_Fig,'Position',[8 1 8 8]);
exportToPPTX('addtext',sprintf('Key 2 Images'), ...
        'Position',[8 0.75 8 8],...
        'HorizontalAlignment','right');
    
exportToPPTX('addslide'); %Total Dissolved Phase
exportToPPTX('addpicture',Total_Dissolved_Key_Diff_Fig);
exportToPPTX('addtext',sprintf('Total Dissolved Phase Difference'));

exportToPPTX('addslide'); %Total Dissolved Phase
exportToPPTX('addpicture',Barrier_Key_Diff_Fig);
exportToPPTX('addtext',sprintf('Barrier Phase Difference'));

exportToPPTX('addslide'); %RBC
exportToPPTX('addpicture',RBC_PctRBC_Key_Diff_Fig);
exportToPPTX('addtext',sprintf('RBC Difference'));

exportToPPTX('addslide'); %RBC Binned
exportToPPTX('addpicture',Binning_Fig);
exportToPPTX('addtext',sprintf(['Binned RBC, Barrier, and Oscillations Images for Subject ' Subject]));

exportToPPTX('addslide'); %Histograms
exportToPPTX('addpicture',Histograms);
exportToPPTX('addtext',sprintf(['Whole Lung Histograms for Subject ' Subject]));

exportToPPTX('addslide'); %Bar Graph
exportToPPTX('addpicture',BarFig);
exportToPPTX('addtext',sprintf(['Oscillations within each RBC and Barrier Bin for Subject ' Subject]));

exportToPPTX('addslide'); %QQ Plot
exportToPPTX('addpicture',QQ_Osc_Signal_Fig);
exportToPPTX('addtext',sprintf(['QQ Plot and Local Oscillations for ' Subject]));

%Save presentation and close presentation -- overwrite file if it already exists
newFile = exportToPPTX('save',fullfile(path,ReportTitle));
exportToPPTX('close');
