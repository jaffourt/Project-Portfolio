%% 1. Find beta weights for S-N in the 812langatlas set. 
%%    Technically, we want B* S - B* N, so the contrast image should be used here..
%% 2. Extract voxel level responses across whole brain (or maybe grey matter mask)
%% Last updated: 06/09/2020

addpath('/om/group/evlab/software/evlab17')
evlab17 init
% subjects specified

experiments(1)=struct(...
'pwd1','/mindhive/evlab/u/Shared/SUBJECTS/',...  %SUBJECTS directory
'pwd2', 'firstlevel_SWJNV2',... %first level directory
'data', {{
    '008_SWJNV2_01_PL2017'
    '009_SWJNV2_02_PL2017'
    '010_SWJNV2_03_PL2017'
    '011_SWJNV2_04_PL2017'
    '012_SWJNV2_05_PL2017'
    '013_SWJNV2_06_PL2017'
    '014_SWJNV2_07_PL2017'
    '015_SWJNV2_08_PL2017'
    '016_SWJNV2_09_PL2017'
    '018_SWJNV2_10_PL2017'
    '020_SWJNV2_12_PL2017'
    '021_SWJNaudio_04_PL2017'
    '022_SWJNaudio_06_PL2017'
    '023_SWJNaudio_07_PL2017'
    '024_SWJNaudio_08_PL2017'
    '024_SWJNV2_13_PL2017'
    '025_SWJNV2_15_PL2017'
    '026_SWJNaudio_11_PL2017'
    '027_SWJNaudio_12_PL2017'
    '028_SWJNaudio_13_PL2017'
    '029_SWJNaudio_14_PL2017'
    '030_SWJNaudio_15_PL2017'
    '031_SWJNaudio_16_PL2017'
    '032_SWJNaudio_17_PL2017'
    '033_SWJNaudio_18_PL2017'

}});

experiments(2)=struct(...
'pwd1','/mindhive/evlab/u/Shared/SUBJECTS/',...  %SUBJECTS directory
'pwd2', 'firstlevel_SWJN',... %first level directory
'data', {{
    '001_SWJN_01_PL2017'
    '002_SWJN_05_PL2017'
    '003_SWJN_07_PL2017'
    '004_SWJN_09_PL2017'
    '005_SWJN_11_PL2017'
    '006_SWJN_12_PL2017'
    '007_SWJN_13_PL2017'
}});

experiments(3)=struct(...
'pwd1','/mindhive/evlab/u/Shared/SUBJECTS/',...  %SUBJECTS directory
'pwd2', 'firstlevel_SWJNaud',... %first level directory
'data', {{
    '021_SWJNaudio_04_PL2017'
    '022_SWJNaudio_06_PL2017'
    '023_SWJNaudio_07_PL2017'
    '024_SWJNaudio_08_PL2017'
    '026_SWJNaudio_11_PL2017'
    '027_SWJNaudio_12_PL2017'
    '028_SWJNaudio_13_PL2017'
    '030_SWJNaudio_15_PL2017'
    '031_SWJNaudio_16_PL2017'
    '032_SWJNaudio_17_PL2017'
    '033_SWJNaudio_18_PL2017'
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
          'swd',[pwd '/EffectSizes_SWJN'],...
          'EffectOfInterest_spm',{effectofinterest_spmfiles},...
          'Localizer_spm',{localizer_spmfiles},...
          'EffectOfInterest_contrasts',{{ ...
           'S' 'W' 'J' 'N'
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

