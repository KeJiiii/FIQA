Dialog.create("remove zebrafish skin Option");
	Dialog.addMessage("Enter your setting here");
	Dialog.addNumber("minimum threshold", 64);
	Dialog.addNumber("Fill times", 3);
	Dialog.addNumber("Erode times", 10);
Dialog.show();
threshold=Dialog.getNumber;
Fill=Dialog.getNumber;
Erode=Dialog.getNumber;

select_path = getDirectory("Choose the Input Directory");


// remove the skin of zebrafish stack
function remove_zskin(fix,move,save_dir,threshold,Fill,Erode) { 
	mergestring="";
	open(fix); 
	run("Subtract Background...", "rolling=200 stack");
	reference=getTitle();
	getDimensions(width, height, channels, Znumber, frames);
	print("channels====="+channels);
	open(move);
	mask=getTitle();
	selectWindow(mask);
	run("Duplicate...", "duplicate channels=1");
	mask1 = getTitle();
	selectWindow(mask);
	run("Duplicate...", "duplicate channels=2");
	mask2 = getTitle();
	run("Color Ratio Plus v1", "image1=["+mask1+"] image2=["+mask2+"] background1=0 clipping_value1=0 background2=0 clipping_value2=0 multiplication=1 color_scale_low=0 color_scale_high=2 brightness=50");
	run("Gaussian Blur...", "sigma=4 stack");
	run("Split Channels");
	selectWindow("Color Ratio (green)");
	setAutoThreshold("Percentile dark");
	//run("Threshold...");
	setThreshold(threshold, 255);
	run("Convert to Mask", "method=Percentile background=Dark black");
	
	
	for (i = 0; i < Fill; i++) {
		run("Fill Holes", "stack");
		run("Dilate", "stack");
		run("Fill Holes", "stack");
	}
	
	for (i = 0; i < Erode; i++) {
		run("Erode", "stack");
	}
	mask3=getTitle();
	selectWindow(mask3);
	mergestring="";
	for (i = 0; i < channels; i++) {
		mergestring=mergestring+"c"+i+1+"=["+mask3+"] ";
	}
	print("mergestring====="+mergestring);
	run("Merge Channels...", mergestring+" create");
	Mask4 = getTitle();
	selectWindow(Mask4);
	run("Divide...", "value=255.000 stack");
	imageCalculator("Multiply create stack", reference,Mask4);
	reference1=getTitle();
	selectImage(reference1);
	saveAs("tiff", save_dir+"rem_"+reference1);
	close("*");
}


son_file_list=getFileList(select_path);
for (l = 0; l < son_file_list.length; l++){
	if (startsWith(son_file_list[l],"stitch")){
		fix=select_path+son_file_list[l];
		move=select_path+son_file_list[l];
		save_dir=select_path+"remove_skin_by_channel3/";
		File.makeDirectory(select_path+"remove_skin_by_channel3/");
		remove_zskin(fix,move,save_dir,threshold,Fill,Erode);
	}
	close("*");
}