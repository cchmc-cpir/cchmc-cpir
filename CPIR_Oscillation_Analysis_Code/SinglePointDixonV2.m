function [DixonImage, Delta_angle_deg, B0PhaseMap] = SinglePointDixonV2(DissolvedImage,RbcBarrierRatio,GasImage,GasMask)
%% User Defined Parameters

%% B0 Inhomogeneities Corrections
% Itterate until mean phase is zero
iterCount = 0;
meanphase = inf;
while((abs(meanphase) > 1E-7))
    if(iterCount > 10)
        warning('Could not get zero mean phase within 10 iterations...');
    end
    if(iterCount > 100)
        error('Could not get zero mean phase within 100 iterations...');
    end
    iterCount = iterCount + 1;
    diffphase = angle(GasImage);
    meanphase = mean(diffphase(GasMask(:)));
    GasImage = GasImage*exp(-1i*meanphase);
end
diffphase = angle(GasImage);
B0CorrectedDissolvedImage = DissolvedImage.*exp(1i*-diffphase);

B0PhaseMap=diffphase;

%% Calculate Parameters from User Defined Parameters
Desired_angle_rad=atan2(1/RbcBarrierRatio,1);
Desired_angle_deg=rad2deg(Desired_angle_rad);

%% Calculate Initial Phase
Initial_angle_rad=angle(sum(B0CorrectedDissolvedImage(GasMask)));
Initial_angle_deg=rad2deg(Initial_angle_rad);

%% Calculate Delta Angle
Delta_angle_rad=Desired_angle_rad-Initial_angle_rad;
Delta_angle_deg=Desired_angle_deg-Initial_angle_deg;

%% Global Phase Shift to Align 
DixonImage = DissolvedImage.*exp(1i*(Delta_angle_rad-diffphase));



end