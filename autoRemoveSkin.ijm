Dialog.create("remove zebrafish skin Option");
	Dialog.addMessage("Enter your setting here");
	Dialog.addNumber("minimum threshold", 5);
	Dialog.addNumber("Fill times", 15);
	Dialog.addNumber("Erode times", 70);
Dialog.show();
threshold=Dialog.getNumber;
Fill=Dialog.getNumber;
Erode=Dialog.getNumber;

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
	run("8-bit");
	mask1 = getTitle();
	run("Gaussian Blur...", "sigma=4 stack");
	//run("Enhance Local Contrast (CLAHE)", "blocksize=127 histogram=256 maximum=3 mask=*None* fast_(less_accurate)");
	run("Find Edges", "stack");
	setAutoThreshold("Default dark");
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
for (l = 0; l < son_file_list.length; l++){
	if (endsWith(son_file_list[l],"_.tif")){
		fix=select_path+son_file_list[l];
		move=select_path+son_file_list[l];
		save_dir=select_path+"remove_skin_1/";
		File.makeDirectory(select_path+"remove_skin/");
		remove_zskin(fix,move,save_dir,threshold,Fill,Erode);
	}
	close("*");
}