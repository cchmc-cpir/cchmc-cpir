function Image_Out = dissolved_phase_recon_lowres(ImageSize,data,traj)
%% A Function written to reconstruct Images when K-space data and trajectories are passed to it
% Uses Scott Robertson's reconstruction code - This just makes it more
% modular and easy to implement - This is for 3D data
% 
% ImageSize - Scalar: Output image matrix size
%
% data - KSpace Data in column vector (N x 1)
%
% traj - point in kspace corresponding to the data vector - columns for
% x,y, and z. (N x 3)

%These Parameters Give an image that matches Duke's Dissolved Phase Image
%quite closely... Not sure I really like the image quality... let's see if
%I can do better...

kernel.sharpness = 0.14;
kernel.extent = 9*kernel.sharpness;
overgrid_factor = 3;
output_image_size = ImageSize*[1 1 1];
nDcfIter = 15;
deapodizeImage = false;%true();
fermi_filter = true;
nThreads = 10;
cropOvergriddedImage = true();
verbose = true();

%  Choose kernel, proximity object, and then create system model
kernelObj = Recon.SysModel.Kernel.Gaussian(kernel.sharpness, kernel.extent, verbose);
%kernelObj = Recon.SysModel.Kernel.KaiserBessel(kernel.sharpness, kernel.extent, verbose);
%kernelObj = Recon.SysModel.Kernel.Sinc(kernel.sharpness, kernel.extent, verbose);

proxObj = Recon.SysModel.Proximity.L2Proximity(kernelObj, verbose);
%proxObj = Recon.SysModel.Proximity.L1Proximity(kernelObj, verbose);
clear kernelObj;
systemObj = Recon.SysModel.MatrixSystemModel(traj, overgrid_factor, ...
    output_image_size, proxObj, verbose);

% Choose density compensation function (DCF)
dcfObj = Recon.DCF.Iterative(systemObj, nDcfIter, verbose);
%dcfObj = Recon.DCF.Voronoi(traj, header, verbose);
%dcfObj = Recon.DCF.Analytical3dRadial(traj, verbose);
%dcfObj = Recon.DCF.Unity(traj, verbose);

% Choose Reconstruction Model
reconObj = Recon.ReconModel.LSQGridded(systemObj, dcfObj, verbose);
clear modelObj;
clear dcfObj;
reconObj.crop = cropOvergriddedImage;
reconObj.deapodize = deapodizeImage;
%PJN - add for fermi filtering
reconObj.fermifilter = fermi_filter;

% Reconstruct image using trajectories in pixel units
Image_Out = reconObj.reconstruct(data, traj);

