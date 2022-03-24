directory_number = newArray("son","grandson")
Dialog.create("remove zebrafish skin Option");
	Dialog.addMessage("Enter your setting here");
	Dialog.addNumber("minimum threshold", 700);// 1000 for lps data
	Dialog.addNumber("Fill times", 11); //5 for lps data 
	Dialog.addNumber("Erode times", 50); // 30 for lps data
	Dialog.addChoice("where is the Cycle files?", directory_number,directory_number[0]);
Dialog.show();
threshold=Dialog.getNumber;
Fill=Dialog.getNumber;
Erode=Dialog.getNumber;
Cycle_direcrory = Dialog.getChoice();

select_path = getDirectory("Choose the Input Directory");


// remove the skin of zebrafish stack
function remove_zskin(fix,move,save_dir,threshold,Fill,Erode) { 
	mergestring="";
	open(fix); 
	reference=getTitle();
	getDimensions(width, height, channels, Znumber, frames);
	print("channels====="+channels);
	open(move);
	mask=getTitle();
	selectWindow(mask);
	run("Duplicate...", "duplicate channels=2");
	mask1 = getTitle();
	run("Gaussian Blur...", "sigma=4 stack");
	//run("Subtract Background...", "rolling=200 light stack");
	run("Enhance Contrast...", "saturated=0.5 process_all use");
	//run("Find Edges", "stack");  启用后ventrol 部分缺失 
	setAutoThreshold("Percentile dark");
	setThreshold(threshold, 65535);
	setOption("BlackBackground", true);
	run("Convert to Mask", "method=MinError background=Dark black");
	
	for (i = 0; i < Fill; i++) {
		run("Fill Holes", "stack");
		run("Dilate", "stack");
		run("Fill Holes", "stack");
	}
	
	for (i = 0; i < Erode; i++) {
		run("Erode", "stack");
	}
	selectWindow(mask1);
	mergestring="";
	for (i = 0; i < channels; i++) {
		mergestring=mergestring+"c"+i+1+"=["+mask1+"] ";
	}
	print("mergestring====="+mergestring);
	run("Merge Channels...", mergestring+" create");
	Mask2 = getTitle();
	selectWindow(Mask2);
	run("Divide...", "value=255.000 stack");
	imageCalculator("Multiply create stack", reference,Mask2);
	reference1=getTitle();
	selectImage(reference1);
	saveAs("tiff", save_dir+"rem_"+reference1);
	close("*");
}


son_file_list=getFileList(select_path);

if (Cycle_direcrory == "son"){
	for (l = 0; l < son_file_list.length; l++){
		if (endsWith(son_file_list[l],".tif")){
			fix=select_path+son_file_list[l];
			move=select_path+son_file_list[l];
			save_dir=select_path+"remove_skin_2/";
			File.makeDirectory(select_path+"remove_skin_2/");
			remove_zskin(fix,move,save_dir,threshold,Fill,Erode);
		}
	close("*");
	}
}

if (Cycle_direcrory == "grandson"){
	grandparent_path = select_path;
	grandparent_path_list = getFileList(select_path);
	for (j = 0; j < grandparent_path_list.length; j++){
		father_path = grandparent_path + grandparent_path_list[j];
		father_path_list=getFileList(father_path);
		for (l = 0; l < father_path_list.length; l++){
			if (endsWith(father_path_list[l],".tif")){
				fix=father_path+father_path_list[l];
				move=father_path+father_path_list[l];
				save_dir=father_path+"remove_skin_2/";
				File.makeDirectory(father_path+"remove_skin_2/");
				remove_zskin(fix,move,save_dir,threshold,Fill,Erode);
			}
		close("*");
		}
	}
}