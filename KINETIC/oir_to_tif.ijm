//stacks to frame
select_path = getDirectory("Choose the Input Directory");
select_path_list = getFileList(select_path);

for (i = 0; i < select_path_list.length; i++){
	Cycle_name = select_path_list[i];
	name_main=substring(Cycle_name,0,lengthOf(Cycle_name)-4);
	run("Viewer", "open="+select_path+Cycle_name);
	saveAs("Tiff", select_path+name_main+".tif");
	close("*");

}