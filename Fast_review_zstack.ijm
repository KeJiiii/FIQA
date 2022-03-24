// fast review the 488/405 ratio
// open the 4d stack by gtid/stitching collection 
// z projection = average



function splitchannel(title,file){
	selectWindow(title);
	run("Split Channels");
	for (k = 0; k < 2; k++){
		kk = "C"+k+1+"-"+title;
		//selectWindow(kk);
		//run("Subtract Background...", "rolling=200 stack");
		selectWindow(kk);
		setMinAndMax(0, 4095);
		saveAs("Tiff", filelocation+file+"_C"+k+1);
		selectWindow(file+"_C"+k+1+".tif");
		//run("Z Project...", "projection=[Average Intensity] all");
		//saveAs("Tiff", filelocation+"AVG_"+file+"_C"+k+1);
	}
	close("*");
}


function combine(fishnumber,filelocation,file){
	for (i = 0; i < fishnumber; i++){
		if (i+1 < 10){
			new_i="0"+i+1;
		}
			else {
				new_i=i+1;
		}
		b=filelocation+file+new_i+".tif";
		print("b========"+b);
		open(b);
		rename(i);
	}
	if (fishnumber == 1){
		title = file+1+".tif";
		file = file;
		splitchannel(title,file);
	}
	if (fishnumber > 1){
		run("Combine...", "stack1="+"0"+" stack2="+"1");
		if 	(fishnumber > 2){
			for (j = 2; j < fishnumber; j++)
			{
				
				run("Combine...", "stack1=[Combined Stacks]"+" stack2="+j);
			}
		}
		title = "Combined Stacks";
		file = file;	
		splitchannel(title,file);
	}
}






function do_it(select_path,y) { 
// function description
	son_file_list=getFileList(select_path);
	n=0;
	for (l = 0; l < son_file_list.length; l++){
		if (endsWith(son_file_list[l],"0001.tif")){
			n=n+1;
			path=select_path;
			file_names=substring(son_file_list[l], 0, lengthOf(son_file_list[l])-5)+"{i}.tif";
			file_name_main=substring(son_file_list[l], 0, lengthOf(son_file_list[l])-9);
			
			run("Grid/Collection stitching", "type=[Grid: column-by-column] order=[Down & Right                ] grid_size_x=1 grid_size_y="+y+" tile_overlap=10 first_file_index_i=1 directory="+path+" file_names="+file_names+" output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
			//run("Subtract Background...", "rolling=200 stack");
			saveAs("tiff", select_path+"stitch_"+file_name_main+".tif");
			run("Z Project...", "projection=[Sum Slices] all");
			saveAs("tiff", select_path+"Z_"+file_name_main+".tif");
			
			run("Close All");
		}
	} 
	file="Z_"+substring(file_name_main, 0, lengthOf(file_name_main)-2);
	combine(n,select_path,file);
}


father_path = getDirectory("Choose the Input Directory");
father_file_list=getFileList(father_path);
for (i = 0; i < father_file_list.length; i++) {
	if (endsWith(father_file_list[i],"Cycle/")){
		
		select_path=father_path+father_file_list[i];
		print(select_path);
		do_it(select_path,3);  // change y value
	}
}


