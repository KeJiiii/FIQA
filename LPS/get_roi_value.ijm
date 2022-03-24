//wait for user

select_path = getDirectory("Choose the Input Directory");
filelist=getFileList(select_path);

for (j = 0; j < filelist.length; j++) {
	if (endsWith(filelist[j], ".roi")){
		roiManager ("Reset");
		imgname=substring(filelist[j],7,lengthOf(filelist[j])-3)+"tif";
		list1="list_ch1_"+substring(filelist[j],0,lengthOf(filelist[j])-3)+"csv";
		list2="list_ch2_"+substring(filelist[j],0,lengthOf(filelist[j])-3)+"csv";

		open(select_path+imgname);
		raw=getTitle();
		setMinAndMax(0, 4095);
		setMinAndMax(0, 4095);
		// note the channel !
		roiManager("Open", select_path+filelist[j]);
		run("Duplicate...", "duplicate channels=1");
		ch1=getTitle();
		selectWindow(raw);
		run("Duplicate...", "duplicate channels=2");
		ch2=getTitle();
		
		selectWindow(ch1);
		roiManager("Select", 0);
		roiManager("Multi Measure");
		saveAs("Results", select_path+list1);
		
		run("Clear Results");
	
		selectWindow(ch2);
		roiManager("Select", 0);
		roiManager("Multi Measure");
		saveAs("Results", select_path+list2);
		run("Clear Results");

		roiManager ("Reset");
	}
	close("*");
}