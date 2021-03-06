function [ ccm ] = GenCCHPP(varargin)
%% GENCCHPP Wrapper function for Hue Plane Preserving Colour Correction
%   Note: that we are assuming the input training data contains a white
%   patch. 
%
%   INPUT:
%       rgb : A nx3 matrix containing the RGB values from a colour checker.
%           *** NOTE that we expect the colour checker to contain a ***
%           *** white patch, which is detected using                ***
%           *** GetWpFromColourChecker().                           ***
%       xyz : A nx3 matrix containing the XYZ values corresponding to the
%           RGB 
%       

if numel(varargin) == 1
    varargin = varargin{1};
end
nargin = numel(varargin);
rgb = varargin{1};
xyz = varargin{2};

%% Load settings
load('/home/fangfufu/UEA/Colour_Correction_Toolbox/bin/nhppcc-toolbox/settings.mat', ...
	'partitions', 'WPP_flag', 'sep_deg', 'reqNoPatches');

%% Reshape input file
if ndims(rgb)
    rgb = reshape(rgb, [], 3);
end

%% Generate colour correction matrix
[ccm.WP, w_idx] = GetWpFromColourChecker(rgb);
[mat, ~, ~, BH] = colour_correction_NHPPCC(rgb, xyz, w_idx, partitions, ...
    WPP_flag, sep_deg, reqNoPatches);
ccm.MAT = mat;
ccm.BH = BH;

end