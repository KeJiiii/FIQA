// merge the c11 and c2 channel,generate the skin-removing file
select_path = getDirectory("Choose the Input Directory");
filelist=getFileList(select_path);

for (j = 0; j < filelist.length; j++) {
	if (startsWith(filelist[j], "M_C1")){
		open(select_path+filelist[j]);
		run("Select None");
		rename(111);
		c2_name="M_C2_"+substring(filelist[j],5,lengthOf(filelist[j]));
		open(select_path+c2_name);
		run("Select None");
		rename(222);
		run("Merge Channels...", "c1=111 c2=222 create");
		saveAs("Tiff", select_path+"manual_"+substring(filelist[j],5,lengthOf(filelist[j])));
	}
	close("*");
}