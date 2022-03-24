select_path = getDirectory("Choose the Input Directory");
filelist=getFileList(select_path);

for (j = 0; j < filelist.length; j++) {
	if (endsWith(filelist[j], ".roi")){
		roiManager ("Reset");
		imgname="Z_202510926_lyz_pbs_"+substring(filelist[j],9,lengthOf(filelist[j])-3)+"tif";
		list1="whole_"+substring(filelist[j],0,lengthOf(filelist[j])-3)+"csv";
		list2="yolk_"+substring(filelist[j],0,lengthOf(filelist[j])-3)+"csv";

		open(select_path+imgname);
		// note the channel !
		run("Duplicate...", "duplicate channels=2");
		ch1=getTitle();
		selectWindow(ch1);
		setAutoThreshold("Default dark");
		setThreshold(67, 65535);
		run("Convert to Mask", "method=Default background=Dark black");
		run("Watershed", "stack");

		selectWindow(ch1);
		run("Analyze Particles...", "size=20-Infinity pixel circularity=0.10-1.00 clear include summarize add in_situ stack");
		saveAs("Results", select_path+list1);
		selectWindow(list1);
		run("Close");

		roiManager ("Reset");
		selectWindow(ch1);
		roiManager("Open", select_path+filelist[j]);
		roiManager("Select", 0);
		run("Clear Outside", "stack");
		roiManager ("Reset");
		selectWindow(ch1);
		run("Analyze Particles...", "size=20-Infinity pixel circularity=0.10-1.00 clear include summarize add in_situ stack");
		saveAs("Results", select_path+list2);
		selectWindow(list2);
		run("Close");
		roiManager ("Reset");
	}
	close("*");
}