// roi for muscle and brain in kinetic 
select_path = getDirectory("Choose the Input Directory");
son_file_list=getFileList(select_path);





for (l = 0; l < son_file_list.length; l++){
	if (startsWith(son_file_list[l],"Sub") && endsWith(son_file_list[l],".tif")){
		open(select_path+son_file_list[l]);
		run("Duplicate...", "duplicate");
		img1=getTitle();
		file2=substring(son_file_list[l],16,lengthOf(son_file_list[l]));
		roiManager("reset");
		
		
		waitForUser ("圈roi");
		
		selectWindow(img1);
		run("Select None");
		run("Duplicate...", "duplicate");
		roiManager ("Select",0);
		run("Clear Outside", "stack");
		muscle=getTitle();
		selectWindow(img1);
		roiManager ("Select",0);
		run("Clear", "stack");
		saveAs("tiff", select_path+"brain"+file2);
		
		selectWindow(muscle);
		run("Remove Overlay");
		saveAs("tiff", select_path+"muscle"+file2);
		roiManager("reset");
		
		close("*");
	}
}