directory_number = newArray("son","grandson")
Dialog.create("Option");
	Dialog.addMessage("Enter your setting here");
	Dialog.addChoice("where is the Cycle files?", directory_number,directory_number[0]);
Dialog.show();
Cycle_direcrory = Dialog.getChoice();
select_path = getDirectory("Choose the Input Directory");

function splitchannel(title,file){
	selectWindow(title);
	run("Split Channels");
	for (k = 0; k < 3; k++){
		kk = "C"+k+1+"-"+title;
		selectWindow(kk);
		saveAs("Tiff", filelocation+file+"_C"+k+1);
		selectWindow(file+"_C"+k+1+".tif");
		run("Z Project...", "projection=[Average Intensity] all");
		saveAs("Tiff", filelocation+"AVG_"+file+"_C"+k+1);
	}
	close("*");
}

function combine(fishnumber,filelocation,file){
	for (i = 0; i < fishnumber; i++){
		b=filelocation+file+i+1+"_.tif";
		open(b);
	}
	if (fishnumber == 1){
		title = file+1+"_.tif";
		file = file;
		splitchannel(title,file);
	}
	if (fishnumber > 1){
		run("Combine...", "stack1="+file+1+"_.tif"+" stack2="+file+2+"_.tif");
		if 	(fishnumber > 2){
			for (j = 3; j < fishnumber+1; j++)
			{
				run("Combine...", "stack1=[Combined Stacks]"+" stack2="+file+j+"_.tif");
			}
		}
		title = "Combined Stacks";
		file = file;	
		splitchannel(title,file);
	}
}

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
				run("Subtract Background...", "rolling=200 stack");
				setMinAndMax(0, 4095);
				saveAs("Tiff", stitch_path+"stitch/"+"stitch_"+stitch_name_main+"_"+m+1+".tif");
				close("*");
			}
	    }
    } 
}

function no_stitch(no_stitch_path) { 
	no_stitch_path_list=getFileList(no_stitch_path);
	File.makeDirectory(no_stitch_path+"no_stitch/");
	for (i = 0; i < lengthOf(no_stitch_path_list); i++){
		if (endsWith(no_stitch_path_list[i], "0001.oir")) { 
			no_stitch_name_main=substring(no_stitch_path_list[i],0,lengthOf(no_stitch_path_list[i])-9);
			run("Viewer", "open="+no_stitch_path+no_stitch_path_list[i]); 
			saveAs("Tiff", no_stitch_path+"no_stitch/"+no_stitch_name_main+".tif");  
		}
	}
}
// function description


if (Cycle_direcrory == "son"){
	open_by_olympus(select_path);
}
if (Cycle_direcrory == "grandson"){
	grandparent_path = select_path;
	grandparent_path_list = getFileList(select_path);
	for (l = 0; l < grandparent_path_list.length; l++){
		father_path = grandparent_path + grandparent_path_list[l];
		open_by_olympus(father_path);
	}
}
