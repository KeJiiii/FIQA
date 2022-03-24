select_path = getDirectory("Choose the Input Directory");
son_file_list=getFileList(select_path);

for (l = 0; l < son_file_list.length; l++){
	if (endsWith(son_file_list[l],".oir")){
		filename=substring(son_file_list[l], 0, lengthOf(son_file_list[l])-3);
		run("Viewer", "open="+select_path+son_file_list[l]);
		saveAs("Tiff", select_path+filename+"tif");
		close("*");   
}
