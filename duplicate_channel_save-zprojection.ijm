select_path = getDirectory("Choose the Input Directory");
filelist=getFileList(select_path);

for (j = 0; j < filelist.length; j++) {
	if (endsWith(filelist[j], "tif")){
		open(select_path+filelist[j]);
		raw=getTitle();
		run("Select None");
		run("Duplicate...", "duplicate channels=1"); 
		saveAs("Tiff", select_path+"M1_"+substring(filelist[j],11,lengthOf(filelist[j])));
		run("Z Project...", "projection=[Average Intensity] all");
		saveAs("Tiff", select_path+"Z_M1_"+substring(filelist[j],11,lengthOf(filelist[j])));


		selectWindow(raw);
		run("Duplicate...", "duplicate channels=2"); 
		saveAs("Tiff", select_path+"M2_"+substring(filelist[j],11,lengthOf(filelist[j])));
		run("Z Project...", "projection=[Average Intensity] all");
		saveAs("Tiff", select_path+"Z_M2_"+substring(filelist[j],11,lengthOf(filelist[j])));

		close("*");
		
		
		
	}
}
