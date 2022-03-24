
select_path = getDirectory("Choose the Input Directory");
son_file_list=getFileList(select_path);


scale=300;
circle1=0.1;
circle2=1;



for (l = 0; l < son_file_list.length; l++){
	if (startsWith(son_file_list[l],"M_C1") && endsWith(son_file_list[l],".tif")){
		open(select_path+son_file_list[l]);
		run("Select None");
		img1=getTitle();
		file2=substring(son_file_list[l],4,lengthOf(son_file_list[l]));
		
		open(select_path+"M_C2"+file2);
		run("Select None");
		img2=getTitle();
		roiManager("reset");

		
		selectWindow(img1);
		run("Duplicate...", "duplicate");
		target1=getTitle();
		
		
		
		selectWindow(img2);
		run("Duplicate...", "duplicate");
		target2=getTitle();
		run("Duplicate...", "duplicate");
		target=getTitle();
		roiManager("reset");

		selectWindow(target);
		run("Gaussian Blur...", "sigma=2 stack");
		run("Make Binary", "method=Otsu background=Dark calculate");
		run("Watershed", "stack");
		run("Analyze Particles...", "size="+scale+"-Infinity circularity=0.10-1 display clear include add in_situ stack");
		//run("Analyze Particles...", "size="+scale+"-Infinity circularity="+circle1+"-"+circle2+" display clear include add in_situ stack");
		
		run("Clear Results");
		selectWindow(target1);
		roiManager("Show All");
		roiManager("Measure");
		//
		filename="pbs"+substring(file2,0,lengthOf(file2)-4);
		//
		nROIs = roiManager("count");
		print(nROIs);
		saveAs("Results", select_path+"list_ch1_"+filename+".csv");
		run("Clear Results");
		selectWindow(target2);
		roiManager("Show All");
		roiManager("Measure");
		saveAs("Results", select_path+"list_ch2_"+filename+".csv");
		roiManager("Show All");
		roiManager("Save", select_path+"ROI_"+nROIs+"_"+filename+".zip");
		run("Clear Results");
		roiManager("Show All");
		roiManager("reset");
		selectWindow(target1);
		run("Remove Overlay");
		saveAs("tiff", select_path+"muscle"+file2);
		close("*");
	}
}