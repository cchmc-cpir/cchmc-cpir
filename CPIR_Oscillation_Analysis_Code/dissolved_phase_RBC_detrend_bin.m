function [High_Key,Low_Key,DisFID,GasHigh,GasLow,RBC2Bar,Shift_Raw_FIDs_Fig,Smooth_Detrend_Fig] = dissolved_phase_RBC_detrend_bin(Traj,GasFID,DisFID,TR,RBC2Barrier,lowpassYN,ScannerType)
%Function to Bin Dissolved Phase Data based on RBC oscillations
%Arguments: Traj - trajectories in 3xNPtsxNProj format
%GasFID and DisFID - FIDs for Gas and Dissolved Phase in NPtsxNProj Matrix
%TR - Repetition time (For making nicer figures)
%RBC2Barrier - RBC to Barrier Ratio (for separating RBC and Barrier)

%Returns:
%High_Key - KSpace with keyholing for High RBC Bin (Using Detrended Data)
%Low_Key - KSpace with keyholing for Low RBC Bin (Using Detrended Data)
%RBC2Bar - Structure holding High, Low, Total RBC/Barrier Ratios and
%Ratios of high to low total signal
%Shift_Raw_FIDs_Fig - Figure Handle for figure showing raw k0 points before
%and after phase shift
%Smooth_Detrend_Fig - Figure Handle for figure showing binning workflow

%% Get Number of Projections

NProj = size(GasFID,2);
%% Perform Phase Shift
%Empirically, this is the way to properly phase shift data on each platform
switch ScannerType
    case 'GE'
        [Sh_DisFID,RBC2Bar.PhaseShift] = SinglePointDixonV2_FID(DisFID,-RBC2Barrier,GasFID); 
    case 'Siemens'
        [Sh_DisFID,RBC2Bar.PhaseShift] = SinglePointDixonV2_FID(DisFID,RBC2Barrier,GasFID); 
    case 'Philips_V2'
        [Sh_DisFID,RBC2Bar.PhaseShift] = SinglePointDixonV2_FID(DisFID,-RBC2Barrier,GasFID); 
    case 'Philips_V3'
        [Sh_DisFID,RBC2Bar.PhaseShift] = SinglePointDixonV2_FID(DisFID,-RBC2Barrier,GasFID); 
end
%Store Phase Shift Angle - I used this for some other stuff... probably not
%needed, but not hurting anything.
RBC2Bar.meanAngle = mean(angle(Sh_DisFID(1,:)));
RBC2Bar.InitAngle = mean(angle(DisFID(1,:)));
RBC2Bar.GasAngle = mean(angle(GasFID(1,:)));
RBC2Bar.PhaseChange = RBC2Bar.meanAngle-RBC2Bar.InitAngle+RBC2Bar.GasAngle;
Time_Axis = (0:(NProj-1))*TR; 

%Display k0 point before and after phase shift... Could be commented out if
%you want
figure('Name','Phase of first point of FID')
plot(Time_Axis,angle(Sh_DisFID(1,:)),'k*');
hold on
plot(Time_Axis,angle(GasFID(1,:)),'g*')
plot(Time_Axis,angle(DisFID(1,:)),'b*');
legend('Shifted','Gas','Unshifted')
plot([0 max(Time_Axis)],[RBC2Bar.meanAngle RBC2Bar.meanAngle],'r-','LineWidth',2)
plot([0 max(Time_Axis)],[mean(angle(DisFID(1,:))) mean(angle(DisFID(1,:)))],'g-','LineWidth',2)

%% Display k0 points

Shift_Raw_FIDs_Fig = figure('Name','Dissolved Phase Mag Real Imaginary k0 Before and After phase shift');

%Give RBC, Barrier, and Total new names to cut down on typing
Raw_Mag_k0 = abs(DisFID(1,:));
Raw_Real_k0 = real(DisFID(1,:));
Raw_Imag_k0 = imag(DisFID(1,:));

Sh_Mag_k0 = abs(Sh_DisFID(1,:));
Sh_Real_k0 = real(Sh_DisFID(1,:));
Sh_Imag_k0 = imag(Sh_DisFID(1,:));

subplot(3,2,1);
plot(Time_Axis,Raw_Mag_k0,'-*','Color',[.49 .13 .53])
title('Magnitude Dissolved Phase k0 (Before Phase Shift)')
xlabel('Time (s)')
ylabel('Intensity (Arb. Units)')
ax = gca;
ax.FontSize = 12;
xlim([0 14.5])
subplot(3,2,3);
plot(Time_Axis,Raw_Real_k0,'r-*')
title('Real Dissolved Phase k0 (Before Phase Shift)')
xlabel('Time (s)')
ylabel('Intensity (Arb. Units)')
ax = gca;
ax.FontSize = 12;
xlim([0 14.5])

subplot(3,2,5);
plot(Time_Axis,Raw_Imag_k0,'b-*')
title('Imaginary Dissolved Phase k0 (Before Phase Shift)')
xlabel('Time (s)')
ylabel('Intensity (Arb. Units)')
ax = gca;
ax.FontSize = 12;
xlim([0 14.5])

subplot(3,2,2);
plot(Time_Axis,Sh_Mag_k0,'-*','Color',[.49 .13 .53])
title('Magnitude Dissolved Phase k0 (After Phase Shift)')
xlabel('Time (s)')
ylabel('Intensity (Arb. Units)')
ax = gca;
ax.FontSize = 12;
xlim([0 14.5])

subplot(3,2,4);
plot(Time_Axis,Sh_Real_k0,'r-*')
title('Real Dissolved Phase k0 (After Phase Shift)')
xlabel('Time (s)')
ylabel('Intensity (Arb. Units)')
ax = gca;
ax.FontSize = 12;
xlim([0 14.5])

subplot(3,2,6);
plot(Time_Axis,Sh_Imag_k0,'b-*')
title('Imaginary Dissolved Phase k0 (After Phase Shift)')
xlabel('Time (s)')
ylabel('Intensity (Arb. Units)')
ax = gca;
ax.FontSize = 12;
xlim([0 14.5])

set(Shift_Raw_FIDs_Fig,'color','white','Units','inches','Position',[0.25 1 12 7])
%% Smooth and Detrend Data
%Assume Oscillation rate of approx 1 Hz... Thus, there would be NProj*TR
%oscillations. That means the number of points per osc is 
%NProj/NProj*TR = 1/TR. Then, we want about 1/5th that number, so...
Sm_Window = floor(1/TR/5);
Samp_Rate = 1/TR;

%Make sure that we have positive RBC and Barrier Values
Mag_Raw_Dis = Sh_Mag_k0;
if mean(Sh_Real_k0) > 0
    RBC_Raw = Sh_Real_k0;
else
    RBC_Raw = -Sh_Real_k0;
end
if mean(Sh_Imag_k0) > 0
    Bar_Raw = Sh_Imag_k0;
else
    Bar_Raw = -Sh_Imag_k0;
end

%To make my life easier, normalize the RBC Data
Sh_Real_k0 = Sh_Real_k0/max(Sh_Real_k0);

%Smooth RBC Data
RBC_Smoothed = smooth(Sh_Real_k0,Sm_Window);

%Display a detrending and binning workflow figure
Smooth_Detrend_Fig = figure('Name',"Smoothing and Detrending Workflow");

subplot(2,4,1)
plot(Time_Axis,Sh_Real_k0,'k*');
title('1. RBC Raw k0 Points')
axis square;
xlabel('Time (s)')
ylabel('Intensity (Arb. Units)')

%First round of Detrending - Double Exponential Fitting
Detrend_Fit = fit(Time_Axis',RBC_Smoothed,'exp2');%,'StartPoint',[.2 -.5 .7 -.1],'Upper',[1 0 1 1],'Lower',[0 -10 0 -10]);
Detrend_Pts = Detrend_Fit.a*exp(Detrend_Fit.b*Time_Axis)+Detrend_Fit.c*exp(Detrend_Fit.d*Time_Axis);
Detrend_Pts = Detrend_Pts';

RBC_Detrend = (Sh_Real_k0'+1)./(Detrend_Pts+1);

subplot(2,4,2)
plot(Time_Axis,RBC_Smoothed,'k*',Time_Axis,Detrend_Pts,'r','LineWidth',2);
title('2. Smoothed RBC k0 Points')
axis square
xlabel('Time (s)')
ylabel('Intensity (Arb. Units)')

Detrend1_Smooth_RBC = (RBC_Smoothed+1)./(Detrend_Pts+1) - 1;
Detrend1_RBC = (Sh_Real_k0'+1)./(Detrend_Pts+1) - 1;

subplot(2,4,3)
plot(Time_Axis,Detrend1_Smooth_RBC,'-k*');
hold on
plot([0 TR*1000],[0 0],'b--','LineWidth',3)
hold off
title({'3. Detrend using','Double Exponential Fit'})
axis square
xlabel('Time (s)')
ylabel('Intensity (Arb. Units)')

%Second Round of Detrending - High Pass Filter - try doing this before the
%smoothing
if TR == .015
    Detrend2_RBC = highpass(Detrend1_RBC,0.7,Samp_Rate);
    Detrend2_Smooth_RBC = smooth(Detrend2_RBC,Sm_Window);
else
    Detrend2_RBC = Detrend1_RBC;
    Detrend2_Smooth_RBC = Detrend1_Smooth_RBC;
end
%Tell whether or not to perform high pass filter -> at some point, I should
%come up with a way to test this automatically, but for now, it needs
%visual inspection to decide
if lowpassYN == 0
    Detrend2_RBC = Detrend1_RBC;
    Detrend2_Smooth_RBC = Detrend1_Smooth_RBC;
end
subplot(2,4,4)
plot(Time_Axis,Detrend2_Smooth_RBC,'-k*');
hold on
plot([0 TR*1000],[0 0],'b--','LineWidth',3)
hold off
title({'4. Detrend using High Pass','Filter with Cutoff of 0.7 Hz'})
axis square
xlabel('Time (s)')
ylabel('Intensity (Arb. Units)')

FFT_RBC = abs(fftshift(fft(Detrend2_RBC)));
SampF = 1/TR;
%Get x frequency space
Freq_Axis = SampF*((-(NProj/2)+1):(NProj/2))/NProj;

subplot(2,4,5)
plot(Freq_Axis(((NProj/2)+1):end),FFT_RBC(((NProj/2)+1):end),'k');
xlim([0 8])
title({'5. Fourier Transform','of Detrended RBC'})
axis square
xlabel('Frequency (Hz)')
ylabel('Intensity (Arb. Units)')

Freq_Axis2 = Freq_Axis(((NProj/2)+1):end);

[MaxPeak,StrongFreqIndex] = max(FFT_RBC(((NProj/2)+1):end));
RBCOscillationFreq = Freq_Axis2(StrongFreqIndex);
text(2,0.5*MaxPeak,['Oscillation Frequency: ',num2str(RBCOscillationFreq),' Hz']);

Threshold = 0.6;
RBCStretch = stretchdata(Detrend2_Smooth_RBC);

High_Bin_Index = find(RBCStretch>Threshold);
Low_Bin_Index = find(RBCStretch<-Threshold);

Orange_Color = [248/256 136/256 12/156];

subplot(2,4,6)
plot(Time_Axis,RBCStretch,'*-k')
hold on
plot(Time_Axis,Threshold*ones(size(Time_Axis)),'g','LineWidth',2)
plot(Time_Axis,-Threshold*ones(size(Time_Axis)),'Color',Orange_Color, 'LineWidth',2)
plot(Time_Axis(High_Bin_Index),RBCStretch(High_Bin_Index),'g*')
plot(Time_Axis(Low_Bin_Index),RBCStretch(Low_Bin_Index),'*','Color',Orange_Color)
hold off
title({'6. Normalize Peaks and Bin','Using \pm0.6 as Threshold'})
axis square
xlabel('Time (s)')
ylabel('Intensity (Arb. Units)')

subplot(2,4,7)
plot(Time_Axis,RBC_Detrend,'k*')
hold on
plot(Time_Axis(High_Bin_Index),RBC_Detrend(High_Bin_Index),'g*')
plot(Time_Axis(Low_Bin_Index),RBC_Detrend(Low_Bin_Index),'*','Color',Orange_Color)
hold off
title('7. Binning Shown on RBC Data')
axis square
xlabel('Time (s)')
ylabel('Intensity (Arb. Units)')
set(Smooth_Detrend_Fig,'color','white','Units','inches','Position',[0.25 1 15 7])

%% Get some Initial comparisons of mean high and low bins
%Detrend the total dissolved phase data for keyholing and reconstruction
Detrend_Fit = fit(Time_Axis',smooth(abs(DisFID(1,:)),Sm_Window),'exp2');%,'StartPoint',[.2 -.5 .7 -.1],'Upper',[1 0 1 1],'Lower',[0 -10 0 -10]);
Detrend_Pts = Detrend_Fit.a*exp(Detrend_Fit.b*Time_Axis)+Detrend_Fit.c*exp(Detrend_Fit.d*Time_Axis);
Detrend_Pts = Detrend_Pts';

holdFID = DisFID;
for i = 1:NProj
    holdFID(:,i) = (DisFID(:,i))/(Detrend_Pts(i));
end
DisFID = holdFID;

hold_shFID = Sh_DisFID;
for i = 1:NProj
    hold_shFID(:,i) = (Sh_DisFID(:,i))/(Detrend_Pts(i));
end
Sh_DisFID = hold_shFID;

Mag_Raw_Sh_Dis = abs(Sh_DisFID(1,:));%Sh_Mag_k0;
if mean(real(Sh_DisFID(1,:))) > 0
    det_RBC_Raw = real(Sh_DisFID(1,:));
else
    det_RBC_Raw = -real(Sh_DisFID(1,:));
end
if mean(imag(Sh_DisFID(1,:))) > 0
    det_Bar_Raw = imag(Sh_DisFID(1,:));
else
    det_Bar_Raw = -imag(Sh_DisFID(1,:));
end

%Get New RBC to Barrier ratio for high and low keys
mean_Mag_High_k0 = mean(Mag_Raw_Sh_Dis(High_Bin_Index));
mean_Mag_Low_k0 = mean(Mag_Raw_Sh_Dis(Low_Bin_Index));
mean_Mag_Tot_k0 = mean(Mag_Raw_Sh_Dis);

mean_RBC_High_k0 = mean(det_RBC_Raw(High_Bin_Index));
mean_RBC_Low_k0 = mean(det_RBC_Raw(Low_Bin_Index));
mean_RBC_Tot_k0 = mean(det_RBC_Raw);

mean_Bar_High_k0 = mean(det_Bar_Raw(High_Bin_Index));
mean_Bar_Low_k0 = mean(det_Bar_Raw(Low_Bin_Index));
mean_Bar_Tot_k0 = mean(det_Bar_Raw);

High_RBC2Barrier = mean_RBC_High_k0/mean_Bar_High_k0;
Low_RBC2Barrier = mean_RBC_Low_k0/mean_Bar_Low_k0;
Tot_RBC2Barrier = mean_RBC_Tot_k0/mean_Bar_Tot_k0;

RBC2Bar.High = High_RBC2Barrier;
RBC2Bar.Low = Low_RBC2Barrier;
RBC2Bar.Tot = Tot_RBC2Barrier;
RBC2Bar.High2Low = mean_Mag_High_k0/mean_Mag_Low_k0;
% subplot(2,4,8);
% xlim([0 10]);
% ylim([0 10])
dim = [.75 .35 .1 .1];
str = ['RBC/Barrier = ',num2str(RBC2Barrier),newline,...
    'High Key RBC/Barrier = ',num2str(High_RBC2Barrier),newline,...
    'Low Key RBC/Barrier = ',num2str(Low_RBC2Barrier),newline,...
    'Total RBC/Barrier = ',num2str(Tot_RBC2Barrier),newline,...
    'Mean Tot Dissolved = ',num2str(mean_Mag_Tot_k0),newline,...
    'Mean High Tot Dissolved = ',num2str(mean_Mag_High_k0),newline,...
    'Mean Low Tot Dissolved = ',num2str(mean_Mag_Low_k0)];
annotation('textbox',dim,'String',str,'FitBoxToText','on','HorizontalAlignment','center');

%% Keyhole Data
%In order to decide on Keyhole Radius, calculate sampling percentages
radpts = 1:ceil(size(Traj,2)/2);
Num_High_Pro = length(High_Bin_Index);
Num_Low_Pro = length(Low_Bin_Index);

Full_Samp_NPro = 4*pi*radpts.^2;

Full_Samp_Pro = 4*pi*max(radpts).^2;

High_Samp_Pct = Num_High_Pro./Full_Samp_NPro*100;
Low_Samp_Pct = Num_Low_Pro./Full_Samp_NPro*100;

%Set Keyhole Radius to the radius at which we are at least 50% sampled
Key_Radius = max(find((Low_Samp_Pct+High_Samp_Pct)/2>50));

%If there's more than 1 k0 point, we can use a few extra points in the key
Traj_Radius = squeeze(sqrt(Traj(1,:,:).^2+Traj(2,:,:).^2+Traj(3,:,:).^2));
Num_k0Pts = length(find(Traj_Radius(:,1)==0));

%All the data I've seen so far, we are doubly sampled along the radius, so
%we can go out twice as far as what is calculated:
Key_Radius = Key_Radius * 2 + Num_k0Pts - 1;

Keyhole = DisFID;

Keyhole(1:Key_Radius,:) = 0;

High_Key = Keyhole;
High_Key(1:Key_Radius,High_Bin_Index) = DisFID(1:Key_Radius,High_Bin_Index);

Low_Key = Keyhole;
if TR == 0.005
    Low_Key(1:Key_Radius,Low_Bin_Index) = DisFID(1:Key_Radius,Low_Bin_Index)*Num_High_Pro/Num_Low_Pro;
else
    Low_Key(1:Key_Radius,Low_Bin_Index) = DisFID(1:Key_Radius,Low_Bin_Index);
end
%% I wonder if different phase is mapped based on the keyholing... Let's keyhole the gas image as well
%Turns out this doesn't seem to make any difference... could probably be
%removed
GasKeyhole = GasFID;

GasKeyhole(1:Key_Radius,:) = 0;

GasHigh = GasKeyhole;
GasHigh(1:Key_Radius,High_Bin_Index) = GasFID(1:Key_Radius,High_Bin_Index);

GasLow = GasKeyhole;
GasLow(1:Key_Radius,Low_Bin_Index) = GasFID(1:Key_Radius,Low_Bin_Index);