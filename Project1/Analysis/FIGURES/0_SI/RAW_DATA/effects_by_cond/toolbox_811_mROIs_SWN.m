%% 1. Find beta weights for S-N in the 812langatlas set. 
%%    Technically, we want B* S - B* N, so the contrast image should be used here..
%% 2. Extract voxel level responses across whole brain (or maybe grey matter mask)
%% Last updated: 06/09/2020

addpath('/om/group/evlab/software/evlab17')
evlab17 init
% subjects specified

experiments(1)=struct(...
'pwd1','/mindhive/evlab/u/Shared/SUBJECTS/',...  %SUBJECTS directory
'pwd2', 'firstlevel_SWNlocIPS168',... %first level directory
'data', {{
    '017_domspec_09_PL2017'
    '019_KAN_langevents_08_PL2017'
    '019_KAN_langmus_05_PL2017'
    '019_KAN_domspec_03_PL2017'
    '021_domspec_10_PL2017'
    '023_langmus_07_PL2017'
    '030_KAN_langstroopBL_11_PL2017'
    '034_domspec_01_PL2017'
    '035_domspec_04_PL2017'
    '036_KAN_domspec_05_PL2017'
    '037_domspec_06_PL2017'
    '038_domspec_07_PL2017'
    '039_domspec_08_PL2017'
    '040_domspec_11_PL2017'
    '040_KAN_langevents_01_PL2017'
    '040_KAN_langstroop_05_PL2017'
    '041_KAN_domspec_12_PL2017'
    '042_domspec_13_PL2017'
    '043_langmus_01_PL2017'
    '044_langmus_02_PL2017'
    '045_langmus_06_PL2017'
    '046_KAN_langmus_08_PL2017'
    '046_KAN_langstroop_01_PL2017'
    '047_KAN_syntax_12_PL2017'
    '047_langmus_09_PL2017'
    '048_KAN_syntax_08_PL2017'
    '048_langmus_10_PL2017'
    '049_KAN_langmus_11_PL2017'
    '050_KAN_langmus_12_PL2017'
    '050_KAN_syntax_05_PL2017'
    '051_langmus_13_PL2017'
    '052_langmus_14_PL2017'
    '054_KAN_langstroop_02_PL2017'
    '056_KAN_langstroop_04_PL2017'
    '056_KAN_langevents_05_PL2017'
    '057_KAN_langevents_02_PL2017'
    '058_domspec_14_PL2017'
    '059_KAN_langevents_04_PL2017'
    '060_domspec_15_PL2017'
    '061_KAN_lingviol_02_PL2017'
    '061_KAN_stories_05_PL2017'
    '061_KAN_syntax_07_PL2017'
    '061_KAN_langstroopBL_05_PL2017'
    '062_KAN_langstroopBL_06_PL2017'
    '063_KAN_langstroopBL_07_PL2017'
    '064_KAN_langstroopBL_08_PL2017'
    '065_KAN_langstroopBL_09_PL2017'
    '066_KAN_langstroopBL_10_PL2017'
    '067_KAN_langevents_06_PL2017'
    '068_KAN_langevents_07_PL2017'
    '069_KAN_langevents_10_PL2017'
    '070_KAN_langevents_11_PL2017'
    '071_KAN_langstroopBL_12_PL2017'
    '072_KAN_langstroopBL_13_PL2017'
    '073_KAN_langstroopBL_14_PL2017'
    '074_KAN_langstroopBL_15_PL2017'
    '075_KAN_langmustask_01_PL2017'
    '076_KAN_langevents_16_PL2017'
    '076_KAN_langstroopBL_16_PL2017'
    '077_KAN_langmustask_02_PL2017'
    '078_KAN_langstroopBL_17_PL2017'
    '078_KAN_langevents_13_PL2017'
    '079_KAN_langstroopBL_18_PL2017'
    '080_KAN_langmustask_03_PL2017'
    '081_KAN_langstroopBL_19_PL2017'
    '082_KAN_langmustask_04_PL2017'
    '083_KAN_langstroopBL_20_PL2017'
    '084_KAN_syntax_02_PL2017'
    '084_KAN_langstroopBL_21_PL2017'
    '085_KAN_langstroopBL_22_PL2017'
    '085_KAN_stories_02_PL2017'
    '086_KAN_langstroopBL_23_PL2017'
    '087_KAN_langevents_12_PL2017'
    '088_KAN_stories_04_PL2017'
    '088_KAN_langevents_14_PL2017'
    '088_KAN_syntax_01_PL2017'
    '089_KAN_langevents_15_PL2017'
    '090_KAN_stories_01_PL2017'
    '092_KAN_syntax_03_PL2017'
    '095_KAN_syntax_04_PL2017'
    '096_KAN_syntax_06_PL2017'
    '097_KAN_syntax_09_PL2017'
    '098_KAN_stories_03_PL2017'
    '099_KAN_syntax_10_PL2017'
    '100_KAN_syntax_11_PL2017'
    '101_KAN_lingviol_09_PL2017'
    '101_KAN_syntax_13_PL2017'
    '103_KAN_lingviol_01_PL2017'
    '104_KAN_domspec_16_PL2017'
    '105_KAN_domspec_17_PL2017'
    '106_domspec_18_PL2017'
    '107_KAN_lingviol_04_PL2017'
    '108_KAN_domspec_19_PL2017'
    '109_KAN_lingviol_05_PL2017'
    '110_KAN_lingviol_07_PL2017'
    '111_KAN_lingviol_08_PL2017'
}});

experiments(2)=struct(...
'pwd1','/mindhive/evlab/u/Shared/SUBJECTS/',...  %SUBJECTS directory
'pwd2', 'firstlevel_SuperLocSWN',... %first level directory
'data', {{
    '072_KAN_prod_02_PL2017'
    '072_KAN_syntshapes_11_PL2017'
    '112_KAN_stories_06_PL2017'
    '114_KAN_stories_08_PL2017'
    '118_KAN_syntshapes_03_PL2017'
    '119_KAN_syntshapes_04_PL2017'
    '123_KAN_syntshapes_06_PL2017'
    '130_KAN_syntshapes_10_PL2017'
    '131_KAN_syntshapes_12_PL2017'
    '146_KAN_stories_11_PL2017'
    '153_KAN_stories_14_PL2017'
    '157_KAN_events2_01_PL2017'
}});

experiments(3)=struct(...
'pwd1','/mindhive/evlab/u/Shared/SUBJECTS/',...  %SUBJECTS directory
'pwd2', 'firstlevel_SWNloc_morph',... %first level directory
'data', {{
    '113_KAN_stories_07_PL2017'
    '116_KAN_langsyntaxshapes_01_PL2017'
    '117_KAN_langsyntaxshapes_02_PL2017'
    '126_KAN_langsyntaxshapes_07_PL2017'
    '129_KAN_langsyntaxshapes_09_PL2017'
    '132_KAN_langsyntaxshapes_13_PL2017'
}});

experiments(4)=struct(...
'pwd1','/mindhive/evlab/u/Shared/SUBJECTS/',...  %SUBJECTS directory
'pwd2', 'firstlevel_SWNloc_morphcont',... %first level directory
'data', {{
    '122_KAN_langsyntaxshapes_05_PL2017'
    '127_KAN_langsyntaxshapes_08_PL2017'
}});

experiments(5)=struct(...
'pwd1','/mindhive/evlab/u/Shared/SUBJECTS/',...  %SUBJECTS directory
'pwd2', 'firstlevel_SWNloc_NV',... %first level directory
'data', {{
    '127_KAN_prod_03_PL2017'
    '132_KAN_stories_10_PL2017'
    '145_KAN_stories_09_PL2017'
    '149_KAN_parametric_05_PL2017'
    '152_KAN_stories_13_PL2017'
}});

localizer_spmfiles={};
effectofinterest_spmfiles={};
i=0;
for nexps=1:length(experiments)
	    for nsub=1:length(experiments(nexps).data)
		       i=i+1;
localizer_spmfiles{i}=fullfile(experiments(nexps).pwd1,experiments(nexps).data{nsub},experiments(nexps).pwd2,'SPM.mat');
effectofinterest_spmfiles{i}=fullfile(experiments(nexps).pwd1,experiments(nexps).data{nsub},experiments(nexps).pwd2,'SPM.mat');
    end
end

ss=struct(...
          'swd',[pwd '/EffectSizes_SWN'],...
          'EffectOfInterest_spm',{effectofinterest_spmfiles},...
          'Localizer_spm',{localizer_spmfiles},...
          'EffectOfInterest_contrasts',{{ ...
           'S' 'W' 'N'
        }},...
          'Localizer_contrasts',{{'S-N'}},...
          'Localizer_thr_type','percentile-ROI-level',...
          'Localizer_thr_p',0.1,...
          'type','mROI',...
          'ManualROIs','/mindhive/evlab/u/Shared/ROIS_Nov2020/Func_Lang_LHRH_SN220/allParcels_language.nii',...
          'overlap_thr_roi',     0,...
          'model',1,...
          'estimation','OLS',...
          'overwrite',true,...
          'ExplicitMasking','',...
          'ask', 'none');

ss=spm_ss_design(ss);
ss=spm_ss_estimate(ss);

