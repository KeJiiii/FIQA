
// c2 substract 50 values

select_path = getDirectory("Choose the Input Directory");
filelist=getFileList(select_path);

for (j = 0; j < filelist.length; j++) {
	if (endsWith(filelist[j], ".zip")){
		roiManager ("Reset");
		open(select_path+filelist[j]);
		roiManager("Open", select_path+filelist[j]);
		imgname=substring(filelist[j],6,lengthOf(filelist[j])-3)+"tif";
		open(select_path+imgname);
		img=getTitle();
		run("Duplicate...", "duplicate channels=1");
		channel1=getTitle();
		selectWindow(img);
		run("Duplicate...", "duplicate channels=2");
		channel2=getTitle();
		run("Colors...", "foreground=black background=black selection=yellow");
		n=roiManager ("Count");
		selectWindow(channel1);
		for (i = 0; i < n; i++){
			selectWindow(channel1);
			roiManager("Select", i);
			run("Clear Outside", "slice");
			selectWindow(channel2);
			roiManager("Select", i);
			run("Clear Outside", "slice");
		}
		selectWindow(channel1);
		saveAs("Tiff", select_path+"M_C1_"+imgname);
		run("Z Project...", "projection=[Average Intensity] all");
		saveAs("Tiff", select_path+"Z_M_C1_"+imgname);
		selectWindow(channel2);
		run("Select None");
		run("Subtract...", "value=50 stack");//   substract 50 values
		saveAs("Tiff", select_path+"M_C2-100_"+imgname);
		run("Z Project...", "projection=[Average Intensity] all");
		saveAs("Tiff", select_path+"Z_M_C2_"+imgname);
		roiManager ("Reset");
		close("*");
	}
}
