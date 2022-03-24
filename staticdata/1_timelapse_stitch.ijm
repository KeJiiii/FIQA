function timelapse_stitch(stitch_path,x,y){
	stitch_path_list=getFileList(stitch_path);
	File.makeDirectory(stitch_path+"stitch/");
	for (i = 0; i < lengthOf(stitch_path_list); i++){	
	    if (endsWith(stitch_path_list[i], "0001.oir")) { 
	    	stitch_name_main=substring(stitch_path_list[i],0,lengthOf(stitch_path_list[i])-5);
	        run("Viewer", "open="+stitch_path+stitch_path_list[i]);
	        getDimensions(width, height, channels, Znumber, frames);
	        close("*");
	        for (k = 0; k <y; k++) {
	        	stitch_other=stitch_name_main+k+1+".oir";
				run("Viewer", "open="+stitch_path+stitch_other);
				stitch_otherchannel=getTitle();
	        	for (j = 0; j < frames; j++){	
					selectWindow(stitch_otherchannel);
					run("Duplicate...", "duplicate frames="+j+1+"-"+j+1);
					saveAs("Tiff", stitch_path+"stitch/"+stitch_name_main+"_"+j+1+"_"+k+1+".tif");
	        	}
	        	close("*");
	        }
			for (m = 0; m < frames; m++){
				path=stitch_path+"stitch/";
				file_names=stitch_name_main+"_"+m+1+"_{i}.tif";
				run("Grid/Collection stitching", "type=[Grid: column-by-column] order=[Down & Right                ] grid_size_x=1 grid_size_y="+y+" tile_overlap=10 first_file_index_i=1 directory="+path+" file_names="+file_names+" output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
				stitch_img=getTitle();
				selectWindow(stitch_img);
				//run("Subtract Background...", "rolling=200 stack");
				//setMinAndMax(0, 4095);
				saveAs("Tiff", stitch_path+"stitch/"+"stitch_"+stitch_name_main+"_"+m+1+".tif");
				close("*");
			}
	    }
    } 
}
select_path = getDirectory("Choose the Input Directory");
select_path_list = getFileList(select_path);
for (i = 0; i < select_path_list.length; i++){
		Cycle_name = select_path_list[i];
		if (endsWith(Cycle_name, "Cycle/")){
			stitch_path = select_path+Cycle_name;
			timelapse_stitch(stitch_path,1,3);
		}
}