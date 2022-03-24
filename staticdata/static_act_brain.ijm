
select_path = getDirectory("Choose the Input Directory");
son_file_list=getFileList(select_path);

for (l = 0; l < son_file_list.length; l++){
	if (startsWith(son_file_list[l],"M_C1") && endsWith(son_file_list[l],".tif")){
		print(son_file_list[l]);
		open(select_path+son_file_list[l]);
		img1=getTitle();
		file2=substring(son_file_list[l],4,lengthOf(son_file_list[l]));
		filemain=substring(son_file_list[l],13,lengthOf(son_file_list[l])-4);
		img1=getTitle();
		open(select_path+"M_C2"+file2);
		img2=getTitle();
		roiManager("reset");
		

		
		waitForUser ("圈roi");
		selectWindow(img1);
		roiManager ("Select",0);
		run("Clear", "stack");
		run("Remove Overlay");
		run("Select None");
		
		selectWindow(img2);
		roiManager ("Select",0);
		run("Clear", "stack");
		run("Remove Overlay");
		run("Select None");

		roiManager("reset");

		// open roi file from stable firelocation
		roifile_path="D:/TRP_DATA/good/static/act/roi_list/";
		roifile_list=getFileList(roifile_path);
		for (i = 0; i < roifile_list.length; i++){
			roifilemain=filemain+".zip";
			if (endsWith(roifile_list[i],roifilemain)){
				
				roiManager("Open", roifile_path+roifile_list[i]);
				
				run("Clear Results");
				selectWindow(img1);
				roiManager("Show All");
				roiManager("Measure");
				filename="brain"+substring(file2,0,lengthOf(file2)-4);
				//nROIs = roiManager("count");
				//print(nROIs);
				saveAs("Results", select_path+"list_ch1_"+filename+".csv");
				run("Clear Results");
				selectWindow(img2);
				roiManager("Show All");
				roiManager("Measure");
				saveAs("Results", select_path+"list_ch2_"+filename+".csv");
				//roiManager("Show All");
				//roiManager("Save", select_path+"ROI_"+nROIs+"_"+filename+".zip");
				run("Clear Results");
				roiManager("Show All");
				roiManager("reset");
				selectWindow(img1);
				saveAs("tiff", select_path+"ere_"+filename+".tif");
				close("*");
			}
		}
	}
}