//wait for user

select_path = getDirectory("Choose the Input Directory");
filelist=getFileList(select_path);

for (j = 0; j < filelist.length; j++) {
	if (endsWith(filelist[j], ".tif")){
		open(select_path+filelist[j]);
		run("Select None");
		raw=getTitle();
		name_behind=substring(filelist[j],5,lengthOf(filelist[j])-4)+".zip";
		
		run("ROI Manager...");
		roiManager ("Reset");


		list1="list_ch1_"+substring(filelist[j],0,lengthOf(filelist[j])-3)+"csv";
		list2="list_ch2_"+substring(filelist[j],0,lengthOf(filelist[j])-3)+"csv";

		selectWindow(raw);
		run("Duplicate...", "duplicate channels=1");
		ch1=getTitle();
		selectWindow(raw);
		run("Duplicate...", "duplicate channels=2");
		ch2=getTitle();
		
		for (i = 0; i < filelist.length; i++) {
			if (endsWith(filelist[i], name_behind)){
				roiManager("Open", select_path+filelist[i]);
				selectWindow(ch1);
				run("Select All");
				roiManager("Measure");
				saveAs("Results", select_path+list1);
				run("Clear Results");

				
				selectWindow(ch2);
				run("Select All");
				roiManager("Measure");
				saveAs("Results", select_path+list2);
				run("Clear Results");
				
			}
		}

		roiManager ("Reset");
	}
	close("*");
}