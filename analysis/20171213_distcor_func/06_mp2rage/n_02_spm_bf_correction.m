%--------------------------------------------------------------------------
% Load default 'batch' file for SPM bias field correction of MP2RAGE
% images, adjust file paths for current subject, and run the batch.
%--------------------------------------------------------------------------
% Ingo Marquardt, 2018
%--------------------------------------------------------------------------
%% Define parameters
clear;
% Path of the default SPM batch:
strPthDflt = '/home/john/PhD/GitHub/PacMan/analysis/SPM_Metadata/spm_default_bf_correction_batch.mat';
% Directory with images to be corrected:
strPthIn = '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20171213/nii_distcor/mp2rage/02_spm_bf_correction/';
%--------------------------------------------------------------------------
%% Prepare input cell array
% The cell array with the file name of the images to be bias field
% corrected:
cllPthIn = spm_select('ExtList', ...
    strPthIn, ...
    '.nii', ...
    Inf);
cllPthIn = cellstr(cllPthIn);
for idxIn = 1:length(cllPthIn)
    cllPthIn{idxIn} = strcat(strPthIn, cllPthIn{idxIn});
end
%% Load default batch
matlabbatch = load(strPthDflt);
% The 'batch' is initially loaded as a 'cell array' within a 'structure
% array' (matlab elegance...). Get the 'cell array' out of the 'strucutre
% array':
matlabbatch = matlabbatch.matlabbatch;
%--------------------------------------------------------------------------
%% Adjust default batch
matlabbatch{1}.spm.spatial.preproc.channel.vols = cllPthIn;
%--------------------------------------------------------------------------
%% Save SPM batch file:
strOut = strcat(strPthIn, 'spm_bf_correction_batch');
save(strOut, 'matlabbatch');
%--------------------------------------------------------------------------
%% Bias field correction
% Initialise "job configuration":
spm_jobman('initcfg');
% Run 'job':
spm_jobman('run', matlabbatch);
%--------------------------------------------------------------------------
%% Exit matlab
% Because this matlab scrit gets called from command line, we have to
% include an exit statement:
exit
%--------------------------------------------------------------------------
