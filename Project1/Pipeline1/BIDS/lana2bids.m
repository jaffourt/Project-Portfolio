function lana2bids()
    events=model2events();
    addpath('/mindhive/evlab/u/jaffourt/fieldtrip');
    clear cfg;
    cfg.bidsroot='/mindhive/evlab/u/Shared/LanA_BIDS';
    cfg.method='copy';
    cfg.InstitutionName             = 'MIT';
    cfg.InstitutionAddress          = '43 Vassar St. Cambridge MA, 02139';
    cfg.InstitutionalDepartmentName = 'Brain and Cognitive Sciences';

    for file = dir('LanA')'
       if file.isdir && ~strcmp(file.name(1),'.')
          uid=file.name(1:3);
          cfg.sub=uid;
          run=0;
          %functionals
          cfg.datatype='bold';
          cfg.task='langloc';
          cfg.mri.RepetitionTime=2000;
          for subfile = dir(['LanA/' file.name '/functionals'])'
              if ~strcmp(subfile.name(1),'.')
                  run=run+1;
                  cfg.run=run;
                  cfg.dataset=['LanA/' file.name '/functionals/' subfile.name];
                  values=events(file.name);
                  cfg.events=values{run};
                  data2bids(cfg);
                  %disp(subfile.name)
              end
          end
          %structurals
          cfg.run='';
          cfg.datatype='T1w';
          cfg.task='';
          cfg.mri.RepetitionTime=2530;
          cfg = rmfield(cfg,'events');
          for subfile = dir(['LanA/' file.name '/structurals'])'
              if ~strcmp(subfile.name(1),'.') && strcmp(subfile.name(1:4),'anon')
                  cfg.dataset=['LanA/' file.name '/structurals/' subfile.name];
                  data2bids(cfg);
                  %disp(subfile.name)
              end
          end
       end
    end
end
