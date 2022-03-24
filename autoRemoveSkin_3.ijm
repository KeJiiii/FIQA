Dialog.create("remove zebrafish skin Option");
	Dialog.addMessage("Enter your setting here");
	Dialog.addNumber("minimum threshold", 35);
	Dialog.addNumber("Fill times", 30);
	Dialog.addNumber("Erode times", 40);
Dialog.show();
threshold=Dialog.getNumber;
Fill=Dialog.getNumber;
Erode=Dialog.getNumber;


mergestring="";
reference=getTitle();
getDimensions(width, height, channels, Znumber, frames);
print("channels====="+channels);
mask=reference;
selectWindow(mask);
run("Duplicate...", "duplicate channels=1");
run("Gaussian Blur...", "sigma=5 stack");
mask1 = getTitle();
selectWindow(mask);
run("Duplicate...", "duplicate channels=2");
run("Gaussian Blur...", "sigma=5 stack");
mask2 = getTitle();
run("Color Ratio Plus v1", "image1=["+mask1+"] image2=["+mask2+"] background1=0 clipping_value1=0 background2=0 clipping_value2=0 multiplication=1 color_scale_low=0 color_scale_high=2 brightness=50");
run("Gaussian Blur...", "sigma=4 stack");
run("Split Channels");
selectWindow("Color Ratio (green)");
run("Subtract...", "value=110 stack");
setAutoThreshold("Default dark");
setThreshold(threshold, 255);
run("Convert to Mask", "method=Default background=Dark black");

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
//reference1=getTitle();
//selectImage(reference1);
//saveAs("tiff", save_dir+"rem_"+reference1);