// split frame

select_path = getDirectory("Choose the Input Directory");
son_file_list=getFileList(select_path);

for (l = 0; l < son_file_list.length; l++){
	if (startsWith(son_file_list[l],"rem_")) {
		open(select_path+son_file_list[l]);
		filename="split_"+substring(son_file_list[l],0,lengthOf(son_file_list[l])-4);
		getDimensions(width, height, channels, slices, frames);
		for (i = 0; i < frames; i++) {
			k=i+1;
			run("Duplicate...", "duplicate frames="+k+"-"+k); 
			saveAs("tiff", select_path+filename+"_"+k+"_.tif");
		}
	}
	close("*");
}
