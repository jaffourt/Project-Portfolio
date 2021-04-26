addpath('/om/group/evlab/software/spm12');
for file = dir('LanA')'
    if file.isdir && ~strcmp(file.name(1),'.')
        job.images='';
        skip=0;
        for subfile = dir(['LanA/' file.name '/structurals'])'
              if ~strcmp(subfile.name(1),'.')
  if strcmp(subfile.name(1:4),'anon')
		       skip=1;
		  else
		    job.images=['LanA/' file.name '/structurals/' subfile.name];
		  end
	      end
	end
	if ~skip
	   spm_deface(job);
	end
    end
end
