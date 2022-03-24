
// old

select_path = getDirectory("Choose the Input Directory");
filelist=getFileList(select_path);

for (j = 0; j < filelist.length; j++) {
	if (endsWith(filelist[j], ".tif")){
		
		run("ROI Manager...");
		roiManager ("Reset");
		
		roiname=substring(filelist[j],0,lengthOf(filelist[j])-3)+"zip";
		imgname=substring(filelist[j],0,lengthOf(filelist[j])-3)+"tif";
		roiManager("Open", select_path+roiname);
		open(select_path+filelist[j]);
		img=getTitle();
		run("Duplicate...", "duplicate channels=1-2");
		img=getTitle();
		n=roiManager ("Count");
		for (i = 0; i < 3; i++){
			selectWindow(img);
			run("Duplicate...", "duplicate");
			mask=getTitle();
			roiManager("Select", i);
			run("Clear Outside", "stack");
			saveAs("Tiff", select_path+"BR_"+i+1+"_"+imgname);
			close();
		}
		roiManager ("Reset");
		close("*");
	}
}
