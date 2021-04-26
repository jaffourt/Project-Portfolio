import subprocess
import json
import os
import codecs
import sys
import json
import glob
import shutil


def create_subj_info_file(directory, ID, subj_dict, task_dict):

	ID = int(ID)

	os.chdir(os.path.abspath(os.path.expanduser(directory)))

	f  = open("subjectinfo", "w+") 

	subIDinfo = [subj_dict[ID] + "\n" + task_dict[ID] + "\n"]
	f.write(''.join(subIDinfo))
	f.close() 


def create_directories(ID, subj_dict, task_dict):

	ID = int(ID)

	target = "/mindhive/evlab/u/Shared/SUBJECTS_FS/rawdata_symbolic/sub{}".format(ID)
	mkdirCmd  = ["mkdir", target]
	subprocess.Popen(mkdirCmd)

	directory = "/mindhive/evlab/u/Shared/SUBJECTS_FS/analysis/sub{}".format(ID)
	mkdirCmd = ["mkdir", directory]
	p = subprocess.Popen(mkdirCmd)


def create_soft_links_2_frame_subj(ID, subj_dict, task_dict):

	ID = int(ID)

	subfolder = subj_dict[ID]

	check_directory = "/mindhive/evlab/u/Shared/SUBJECTS/{}/".format(subfolder)

	if os.path.isdir(check_directory):
		directory = glob.glob("/mindhive/evlab/u/Shared/SUBJECTS/{}/*dicoms".format(subfolder))[0]
	else:
		directory = glob.glob("/mindhive/evlab/u/Shared/SUBJECTS/{}*/*dicoms".format(ID))[0]

	os.chdir(os.path.abspath(os.path.expanduser(directory)))

	mkDirMR = ['mkdir', 'MR']
	subprocess.Popen(mkDirMR)

	mr_files = glob.glob('MR.*')
	for f in mr_files:
		new_destination = '{}/MR/{}'.format(directory, f)
		old_destination = '{}/{}'.format(directory,f)
		shutil.move(old_destination, new_destination)

	mkDirOld = ['mkdir', 'old_softlinks']
	subprocess.Popen(mkDirOld)

	dicom_files = glob.glob('*.dcm')
	for f in dicom_files:
		print(f)
		new_destination = '{}/old_softlinks/{}'.format(directory, f)
		old_destination = '{}/{}'.format(directory,f)
		shutil.move(old_destination, new_destination)

        dicom_files_to_link = glob.glob('old_softlinks/*.dcm')
        for f in dicom_files_to_link:
		split_1_f = f.split(".")
		split_f = split_1_f[0].split("-")
		second_part = "0" + str(split_f[1]) if len(split_f[1]) == 2 else "00" + str(split_f[1])
		third_part = "0" + str(split_f[2]) if len(split_f[2]) == 3 else "00" + str(split_f[2]) if len(split_f[2]) == 2 else "000" + str(split_f[2])
                new_file = glob.glob("MR/MR.*-{}-{}.dcm".format(second_part, third_part))

                if len(new_file) != 0:
			lnkCmd = ['ln', '-s', new_file[0], f.split("/")[1]]
			subprocess.Popen(lnkCmd)

	

def create_soft_links(ID, subj_dict, task_dict):

	ID = int(ID)
	fancy_ID = "00" + str(int(ID)) if int(ID) < 10 else "0" + str(int(ID)) if int(ID) < 100 and int(ID) >= 10 else int(ID)

	target = "/mindhive/evlab/u/Shared/SUBJECTS_FS/rawdata_symbolic/sub{}".format(ID)

	subfolder = subj_dict[ID]

	os.chdir(os.path.abspath(os.path.expanduser("/mindhive/evlab/u/Shared/SUBJECTS/")))

	check_directory = "/mindhive/evlab/u/Shared/SUBJECTS/{}/".format(subfolder)

	# for the 2 frame subjects
	if os.path.isdir(check_directory):
		print("here")
		directory = glob.glob("/mindhive/evlab/u/Shared/SUBJECTS/{}/*dicoms".format(subfolder))[0]
	else:
		print("or here")
		directory = glob.glob("/mindhive/evlab/u/Shared/SUBJECTS/{}*/*dicoms".format(fancy_ID))[0]

	print(directory)

	os.chdir(os.path.abspath(os.path.expanduser(target)))

	lnkCmd = ["ln", "-s", directory, "."]
	subprocess.Popen(lnkCmd)


def delete_soft_links(ID, subj_dict, task_dict):

	ID = int(ID)

	os.chdir(os.path.abspath(os.path.expanduser("/mindhive/evlab/u/Shared/SUBJECTS_FS/rawdata_symbolic/")))

	target = "/mindhive/evlab/u/Shared/SUBJECTS_FS/rawdata_symbolic/sub{}".format(ID)
	delCmd  = ["rm", "-r", target]
	subprocess.Popen(delCmd)
	

def unpacking_data(ID,subj_dict,task_dict):

	ID = int(ID)

	os.chdir(os.path.abspath(os.path.expanduser("/mindhive/evlab/u/Shared/SUBJECTS_FS/")))

	src = glob.glob("./rawdata_symbolic/sub{}/*dicoms".format(ID))[0]
	targ = "./sub{}".format(ID)
	scan = "./unpackdata/sub{}/scan.info".format(ID)

	unpackCmd = ["unpacksdcmdir", "-src", src, "-targ", targ, "-scanonly", scan]
	p = subprocess.Popen(unpackCmd)
	p.communicate()

def get_number(full_str):

	split_str = full_str.split("/")
	full_run_name = split_str[-1]
	split_full_name = full_run_name.split("-")

	return int(split_full_name[1])


def get_runs(subj_dict, ID, task_dict):

	ID = int(ID)

	os.chdir(os.path.abspath(os.path.expanduser("/mindhive/evlab/u/Shared/SUBJECTS_FS/811atlasset")))

	task_name = task_dict[ID] + ".json"

	with open(task_name,'r') as f:
		data=json.load(f)

        full_name = subj_dict[ID]
	runs = data[full_name]

        if type(runs[0]) == list:
                #assume that [[],[]] means struct+func
                func_runs = runs[0]
                struct_runs = runs[1]
        else:
                #assume that [] means no struct
                func_runs=runs
                struct_runs=[]
        
	func_nums = [get_number(f) for f in func_runs]
	
	struct_nums = [get_number(s) for s in struct_runs]
        
	return func_nums, struct_nums


def unpacking_functional_runs(ID, subj_dict, task_dict):

	ID = int(ID)

	os.chdir(os.path.abspath(os.path.expanduser("/mindhive/evlab/u/Shared/SUBJECTS_FS/")))

	src = glob.glob("./rawdata_symbolic/sub{}/*dicoms".format(ID))[0]
	targ = "./sub{}".format(ID)

	func_nums, struct_nums = get_runs(subj_dict, ID, task_dict)

	os.chdir(os.path.abspath(os.path.expanduser("/mindhive/evlab/u/Shared/SUBJECTS_FS/")))

	struct_num_string = [" -run " + str(struct_nums[i]) + " mprage nii 001.nii.gz " for i in range(len(struct_nums))]

	func_num_string = [" -run " + str(func_nums[i]) + " bold nii f.nii.gz " for i in range(len(func_nums))]

        unpackCmd = ["unpacksdcmdir", "-src", src, "-targ", targ, ''.join(struct_num_string), ''.join(func_num_string)]

	p=subprocess.Popen(unpackCmd)
	p.communicate()


def reconall(ID, subj_dict, task_dict):

	ID = int(ID)

	struct_num = str(get_runs(subj_dict, ID, task_dict)[1][0])
	struct_run = "00" + struct_num if len(struct_num) == 1 else "0" + struct_num

	i = "./sub{}/mprage/{}/001.nii.gz".format(ID, struct_run)
	subject = "./FS/sub{}".format(ID)
	reconallCmd = ["recon-all","-i", i, "-subject", subject, "-all"]

	os.chdir(os.path.abspath(os.path.expanduser("/mindhive/evlab/u/Shared/SUBJECTS_FS/")))

	p=subprocess.Popen(reconallCmd)
	p.communicate()

		
def preprocessing(ID, subj_dict,task_dict):

	ID = int(ID)

	subID = "sub{}".format(ID)

	directory = "/mindhive/evlab/u/Shared/SUBJECTS_FS/analysis/sub{}".format(ID)

	create_subj_info_file(directory, ID, subj_dict, task_dict)

	cpCmd = ["cp", "/mindhive/evlab/u/Shared/SUBJECTS_FS/analysis/sessdir", directory]

	p = subprocess.Popen(cpCmd)
	p.communicate()

	preprocCmd = ["preproc-sess", "-s", subID, "-df", "sessdir", "-per-run", "-fsd", "bold", "-fwhm", "4", "-surface", "fsaverage", "lhrh", "-force"]

	os.chdir(os.path.abspath(os.path.expanduser(directory)))

	p=subprocess.Popen(preprocCmd)
	p.communicate()


def create_subjectname_file(ID, subj_dict,task_dict):

	ID = int(ID)

	directory = "/mindhive/evlab/u/Shared/SUBJECTS_FS/sub{}".format(ID)
	os.chdir(os.path.abspath(os.path.expanduser(directory)))

	f  = open("subjectname", "w+") 

	subID = "sub{}".format(ID)
	f.write(subID)
	f.close() 

def create_lang_loc_rlf(ID, subj_dict, task_dict):

	ID = int(ID)

	directory = "/mindhive/evlab/u/Shared/SUBJECTS_FS/sub{}/bold".format(ID)
	os.chdir(os.path.abspath(os.path.expanduser(directory)))
        
        f1=open("lang-loc-rlf.txt", "w+")
        f2=open("lang-loc-rlf_ODD.txt","w+")
        f3=open("lang-loc-rlf_EVEN.txt","w+")

	ALL = [ str("%03d") % v for v in get_runs(subj_dict, ID, task_dict)[0]]
        
        f1.write('\n'.join(ALL))
        f2.write('\n'.join(ALL[0::2]))
        f3.write('\n'.join(ALL[1::2]))

        f1.close()
        f2.close()
        f3.close()

def mk_par_file(ID, subj_dict, task_dict):

	ID = int(ID)
        taskname=task_dict[ID]
	fancy_ID = "00" + str(int(ID)) if int(ID) < 10 else "0" + str(int(ID)) if int(ID) < 100 and int(ID) >= 10 else int(ID)

	func_num = [str(v) for v in get_runs(subj_dict, ID, task_dict)[0]]
	func_runs = ["00" + num if len(num) == 1 else "0" + num for num in func_num]
	i = 0
	for func_run in func_runs:
		i +=1
		f_in = "/om5/group/evlab/LanA_BIDS/sub-{}/func/sub-{}_task-langloc_run-{}_events.tsv".format(fancy_ID,fancy_ID,i)
		f_out = "/mindhive/evlab/u/Shared/SUBJECTS_FS/sub{}/bold/{}/langloc.par".format(ID, func_run)
		mkPar = ["python", "/om5/group/evlab/LanA_BIDS/convert.py", f_in, f_out, taskname]

		p = subprocess.Popen(mkPar)
		p.communicate()

def get_par_info(subj_dict, ID, task_dict):

	ID = int(ID)

	func_num = [str(v) for v in get_runs(subj_dict, ID, task_dict)[0]]
	func_runs = ["00" + num if len(num) == 1 else "0" + num for num in func_num]

	file = "/mindhive/evlab/u/Shared/SUBJECTS_FS/sub{}/bold/{}/langloc.par".format(ID, func_runs[0])

	with codecs.open(file, "r") as f:
		lines = f.readlines()

		colDict = {}
		nconditions = 0
		for i in range(len(lines)):
			line = lines[i]
			col1, col2, col3 = line.split("\t", 2)
			colDict[col2] = col3
			if nconditions < int(col2):
				nconditions = int(col2)

		refeventdur = colDict["1"]

	return refeventdur, nconditions


def mkanalysis(ID, subj_dict,task_dict):

	ID = int(ID)

	refeventdur, nconditions = get_par_info(subj_dict, ID, task_dict)


	mkAnalRH = ["sh", "/mindhive/evlab/u/Shared/SUBJECTS_FS/sh_scripts/mkanalysis-lang-rh_self.sh", str(ID), str(refeventdur), str(nconditions)]

	p = subprocess.Popen(mkAnalRH)
	p.communicate()

	mkAnalLH = ["sh", "/mindhive/evlab/u/Shared/SUBJECTS_FS/sh_scripts/mkanalysis-lang-lh_self.sh", str(ID), str(refeventdur), str(nconditions)]

	p = subprocess.Popen(mkAnalLH)
	p.communicate()

	dirLH = "/mindhive/evlab/u/Shared/SUBJECTS_FS/analysis/sub{}/bold.self.sm4.lh.lang".format(ID)
	dirRH = "/mindhive/evlab/u/Shared/SUBJECTS_FS/analysis/sub{}/bold.self.sm4.rh.lang".format(ID)

	subprocess.Popen(["wait"])

	create_subj_info_file(dirLH, ID, subj_dict, task_dict)
	create_subj_info_file(dirRH, ID, subj_dict, task_dict)


def mkcontrasts(ID, subj_dict,task_dict):

	ID = int(ID)

	subID = "sub{}".format(ID)

	mkContrasts = ["sh", "/mindhive/evlab/u/Shared/SUBJECTS_FS/sh_scripts/mkcontrast-SN-self.sh", subID]

	p = subprocess.Popen(mkContrasts)
	p.communicate()
 
def selxavg(ID, subj_dict,task_dict):

	ID = int(ID)

	directory = "/mindhive/evlab/u/Shared/SUBJECTS_FS/analysis/sub{}".format(ID)
	os.chdir(os.path.abspath(os.path.expanduser(directory)))

	subID = "sub{}".format(ID)

	selxavgRH = ["selxavg3-sess", "-s", subID, "-df", "sessdir", "-analysis", "bold.self.sm4.rh.lang", "-overwrite"]

	selxavgLH = ["selxavg3-sess", "-s", subID, "-df", "sessdir", "-analysis", "bold.self.sm4.lh.lang", "-overwrite"]

        selxavgRH_ODD = ["selxavg3-sess", "-s", subID, "-df", "sessdir", "-analysis", "bold.self.sm4.rh.lang_ODD", "-overwrite"]

        selxavgLH_ODD = ["selxavg3-sess", "-s", subID, "-df", "sessdir", "-analysis", "bold.self.sm4.lh.lang_ODD", "-overwrite"]

        selxavgRH_EVEN = ["selxavg3-sess", "-s", subID, "-df", "sessdir", "-analysis", "bold.self.sm4.rh.lang_EVEN", "-overwrite"]

        selxavgLH_EVEN = ["selxavg3-sess", "-s", subID, "-df", "sessdir", "-analysis", "bold.self.sm4.lh.lang_EVEN", "-overwrite"]

	p=subprocess.Popen(selxavgRH)
	p.communicate()

	p=subprocess.Popen(selxavgLH)
	p.communicate()
'''        
        p=subprocess.Popen(selxavgRH_ODD)
        p.communicate()

        p=subprocess.Popen(selxavgLH_ODD)
        p.communicate()

        p=subprocess.Popen(selxavgRH_EVEN)
        p.communicate()

        p=subprocess.Popen(selxavgLH_EVEN)
        p.communicate()
'''
def take_screenshot(ID, subj_dict, task_dict):

	ID = int(ID)

	screenshotCmd = ["sh", "/mindhive/evlab/u/Shared/SUBJECTS_FS/sh_scripts/take_screenshot.sh", str(ID)]

	p = subprocess.Popen(screenshotCmd)
	p.communicate()


if __name__ == "__main__":

	subj_dict = json.load(open(sys.argv[3]))
	task_dict = json.load(open(sys.argv[4]))

	id_num = sys.argv[2]
	
	globals()[sys.argv[1]](id_num, dict(subj_dict), dict(task_dict))

	
