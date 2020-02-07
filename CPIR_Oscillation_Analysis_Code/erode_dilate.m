function [segm_img, BNmask]= erode_dilate(img_in,SE,thresh);
%% Generate Binary Mask using a noise threshold and a errosion/dilation pair.

segm_img = abs(img_in); % magnitude image for ease of viewing

    %imshow(segm_img(:,:,1), 'InitialMagnification', 1000, 'DisplayRange', []);
%     title(gca,['Image Slice ', int2str(1)])  
%     disp('Select a ROI to remove any object in the slice.')
%     BW = roipoly;
    nzROI = segm_img(1,:,:);
%     nzROI(BW)=[];

%close;

meanNZ = mean(nzROI(:));
stdNZ = std(nzROI(:));  % calculate background noise
threshold = meanNZ + thresh*stdNZ; % define noise mask threshold

% generate binary mask
BNmask=segm_img;                        
BNmask(BNmask<threshold)=0;
BNmask(BNmask>threshold)=1;

% Perform Erosion and Dilation and Generate Final Image

[x,y,z]=meshgrid(-SE:SE,-SE:SE, -SE:SE);
nhood=x.^2+y.^2+z.^2 <=SE^2;                % structuring element size
se1=strel('arbitrary',nhood);

BNmask=imerode(BNmask,se1);
BNmask=imdilate(BNmask,se1);

segm_img = segm_img.*BNmask;       % apply mask

