function [ ccm ] = GenCCEnsemble( varargin )
%% GENCCENSEMBLE Generate the struct for ensemble colour correction

if numel(varargin) == 1
    varargin = varargin{1};
end
nargin = numel(varargin);

rgb = varargin{1};
xyz = varargin{2};

[ ccm_1, eXyz ] = GenCCEnsemblePart1(rgb, xyz);

objFunc = @(eXyz, xyz, t_factor) GenCCEnsemblePart2(eXyz, ...
    xyz, t_factor, ccm_1);
disp('GenCCEnsemble');
disp('Search for Tikhonov factor...');
t_factor = CalcTFactor(eXyz, xyz, objFunc, @ApplyCCEnsemble);
disp(t_factor);
ccm = GenCCEnsemblePart2(eXyz, xyz, t_factor, ccm_1);

end

function [ ccm, eXyz ] = GenCCEnsemblePart1(rgb, xyz)

ccm.ccmHomo = GenCCHomo(rgb, xyz);
ccm.ccmHPP = GenCCHPP(rgb, xyz);
ccm.ccmRP =  GenCCRootPolynomial(rgb, xyz, 2, 0);

HomoXyz = ApplyCCLinear(rgb, ccm.ccmHomo);
HPPXyz = ApplyCCHPP(rgb, ccm.ccmHPP);
RPXyz = ApplyCCRootPolynomial(rgb, ccm.ccmRP);

eXyz = [HomoXyz, HPPXyz, RPXyz];

end

function [ ccm ] = GenCCEnsemblePart2(eXyz, xyz, t_factor, ccm)
ccm.ensemble = (eXyz' * eXyz + t_factor * eye(size(eXyz, 2)) ) \ ...
    (eXyz' * xyz);
end