
select_path = getDirectory("Choose the Input Directory");
son_file_list=getFileList(select_path);


scale=500;
circle1=0.1;
circle2=1;



for (l = 0; l < son_file_list.length; l++){
	if (startsWith(son_file_list[l],"BLK") && endsWith(son_file_list[l],".tif")){
		open(select_path+son_file_list[l]);
		img1=getTitle();
		file2=substring(son_file_list[l],4,lengthOf(son_file_list[l]));
		
		
		img1=getTitle();
		open(select_path+"M_C2"+file2);
		
		img2=getTitle();
		roiManager("reset");

		
		waitForUser ("圈roi");
		selectWindow(img1);
		roiManager ("Select",0);
		run("Duplicate...", "duplicate");
		target1=getTitle();
		run("Duplicate...", "duplicate");
		target=getTitle();
		
		
		selectWindow(img2);
		roiManager ("Select",0);
		run("Duplicate...", "duplicate");
		target2=getTitle();
		
		roiManager("reset");

		selectWindow(target);
		run("Gaussian Blur...", "sigma=4 stack");
		run("Convert to Mask", "method=Default background=Dark calculate");
		run("Watershed", "stack");
		run("Analyze Particles...", "size=500-Infinity circularity=0.10-0.60 display clear include add in_situ stack");
		//run("Analyze Particles...", "size="+scale+"-Infinity circularity="+circle1+"-"+circle2+" display clear include add in_situ stack");
		
		run("Clear Results");
		selectWindow(target1);
		roiManager("Show All");
		roiManager("Measure");
		filename="muscle"+substring(file2,0,lengthOf(file2)-4);
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