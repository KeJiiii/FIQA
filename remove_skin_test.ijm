mergestring="";
	//open(fix);
	Dialog.create("remove zebrafish skin Option");
		Dialog.addMessage("Enter your setting here");
		Dialog.addNumber("minimum threshold", 700);
		Dialog.addNumber("Fill times", 11);
		Dialog.addNumber("Erode times", 50);
	Dialog.show();
	threshold=Dialog.getNumber;
	Fill=Dialog.getNumber;
	Erode=Dialog.getNumber;
	reference=getTitle();
	getDimensions(width, height, channels, Znumber, frames);
	print("channels====="+channels);
	//open(move);
	mask=reference;
	selectWindow(mask);
	run("Duplicate...", "duplicate channels=2");
	//run("8-bit");
	mask1 = getTitle();
	run("Gaussian Blur...", "sigma=4 stack");
	run("Subtract Background...", "rolling=200 light stack");
	run("Enhance Contrast...", "saturated=0.1 process_all use");
	//run("Find Edges", "stack");
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