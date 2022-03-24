
select_path = getDirectory("Choose the Input Directory");
son_file_list=getFileList(select_path);

for (l = 0; l < son_file_list.length; l++){
	if (startsWith(son_file_list[l],"M") && endsWith(son_file_list[l],".tif")){
		
		run("Bio-Formats", "open="+select_path+son_file_list[l]+" autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		run("Z Project...", "projection=[Sum Slices]");
		saveAs("tiff", select_path+"Z_"+son_file_list[l]);
		run("Close All");
	}
}