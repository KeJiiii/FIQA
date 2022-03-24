//stacks to frame
select_path = getDirectory("Choose the Input Directory");
select_path_list = getFileList(select_path);
File.makeDirectory(select_path+"frame/");
for (i = 0; i < select_path_list.length; i++){
	Cycle_name = select_path_list[i];
	name_main=substring(Cycle_name,0,lengthOf(Cycle_name)-4);
	if (startsWith(Cycle_name, "Sub")){
		
		open(select_path+Cycle_name);
		getDimensions(width, height, channels, Znumber, frames);
		for (j = 0; j < frames; j++){
			run("Duplicate...", "duplicate frames="+j+1+"-"+j+1);
			saveAs("Tiff", select_path+"frame/"+name_main+"_"+j+1+".tif");
		}
	close("*");
	}

}