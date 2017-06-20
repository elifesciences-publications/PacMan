%--------------------------------------------------------------------------
% The purpose of this script is to create a 'batch' file for SPM motion
% correction. This batch can then be run using the SPM GUI, with the
% advantage that a plot of the motion parameters is automatically created
% by SPM.
%--------------------------------------------------------------------------
% This version is used for motion correction within runs, as a preparation
% for distortion correction. An approximate brain mask that can be created
% automatically with FSL BET is used as reference weighting. A second round
% of motion correction across runs needs to be performed after distortion
% correction.
%--------------------------------------------------------------------------
% Ingo Marquardt, 23/06/2016
%--------------------------------------------------------------------------
%% Define variable parameters:
clear;
% Path of the SPM moco directory:
strPathParent = '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/spm_regWithinRun/';
% The number of functional runs:
varNumRuns = 10;
%% Loop through runs:
for idxRun = 1:varNumRuns
    % Name of the 'SPM batch' to be created:
    if idxRun < 10
        strPathOut = [ ...
            strPathParent, ...
            'spm_moco_batch_0', ...
            num2str(idxRun), ...
            '.mat'];
    else
        strPathOut = [ ...
            strPathParent, ...
            'spm_moco_batch_', ...
            num2str(idxRun), ...
            '.mat'];
    end
    %----------------------------------------------------------------------
    %% Prepare input - file lists of nii files:
    % The paths of the functional runs:
    cllPathFunc = cell(1);
    if idxRun < 10
        strTmp = strcat(strPathParent, ...
            'func_0', ...
            num2str(idxRun), ...
            '/');
    else
        strTmp = strcat(strPathParent, ...
            'func_', ...
            num2str(idxRun), ...
            '/');
    end
    cllPathFunc{1} = spm_select('ExtList', ...
        strTmp, ...
        '.nii', ...
        Inf);
    cllPathFunc{1} = cellstr(cllPathFunc{1});
    cllPathFunc{1} = strcat(strTmp, cllPathFunc{1});
    %----------------------------------------------------------------------
    %% Prepare input - reference weighting:
    % Temporary name string for current run:
    if idxRun < 10
        strTmp = strcat('func_0', num2str(idxRun));
    else
        strTmp = strcat('func_', num2str(idxRun));
    end
    % The path to the reference weighting volume:
    strPathRefweigth = strcat(strPathParent, strTmp, '_ref_weighting/');
    % The cell array with the file name of the reference weighting volume:
    cllPathRefweight = spm_select('ExtList', ...
        strPathRefweigth, ...
        '.nii', ...
        Inf);
    cllPathRefweight = cellstr(cllPathRefweight);
    cllPathRefweight{1} = strcat(strPathRefweigth, cllPathRefweight{1});
    %----------------------------------------------------------------------
    %% Prepare parameters for motion correction
    % Initialise jobs configuration:
    % spm_jobman('initcfg');
    % Clear old batches:
    clear matlabbatch;
    % Here we determine the settings for the SPM registrations. See SPM
    % manual for details. First, the parameters for the estimation:
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 1.0;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 0.8;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 1.6;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 7;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = ...
        cllPathRefweight;
    % Secondly, the parameters for the reslicing:
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 7;
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
    % The cell array containing the input files. There are now several cell
    % arrays that include the input data. We need to combine those into one
    % cell array. Note: We only include the functional time series in this
    % array, not the reference weighting image. That one is entered
    % separately.
    matlabbatch{1}.spm.spatial.realign.estwrite.data = ...
        [cllPathFunc]; %#ok<NBRAK>
    %----------------------------------------------------------------------
    %% Save SPM batch file:
    save(strPathOut, 'matlabbatch');
    %----------------------------------------------------------------------
end
%--------------------------------------------------------------------------

