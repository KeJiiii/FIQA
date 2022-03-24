
// open the 4d stack by gtid/stitching collection 
// z projection = average


select_path = getDirectory("Choose the Input Directory");
son_file_list=getFileList(select_path);
y=3;
n=0



for (l = 0; l < son_file_list.length; l++){
	if (endsWith(son_file_list[l],"0001.tif")){
		n=n+1;
		path=select_path;
		file_names=substring(son_file_list[l], 0, lengthOf(son_file_list[l])-5)+"{i}.tif";
		file_name_main=substring(son_file_list[l], 0, lengthOf(son_file_list[l])-9);
		run("Grid/Collection stitching", "type=[Grid: column-by-column] order=[Down & Right                ] grid_size_x=1 grid_size_y="+y+" tile_overlap=10 first_file_index_i=1 directory="+path+" file_names="+file_names+" output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
		//run("Subtract Background...", "rolling=200 stack");
		saveAs("tiff", select_path+"stitch_"+file_name_main+".tif");
		//run("Z Project...", "projection=[Average Intensity] all");
		saveAs("tiff", select_path+"Z_"+file_name_main+".tif");
		run("Close All");
	}
} 
