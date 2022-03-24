// get color threshold mask, 
function get_color_threshold_mask(inputstacks,Hue,braightness) {
	selectWindow(inputstacks);
	getDimensions(width, height, channels, slices, frames);
	print(slices);
	for (n = 0; n < slices; n++) {
		selectWindow(img);
		run("Duplicate...", "duplicate range="+n+1+"-"+n+1+" use");
		a=getTitle();
		min=newArray(3);
		max=newArray(3);
		filter=newArray(3);
		selectWindow(a);
		run("HSB Stack");
		run("Convert Stack to Images");
		selectWindow("Hue");
		rename("0");
		selectWindow("Saturation");
		rename("1");
		selectWindow("Brightness");
		rename("2");
		min[0]=0;
		max[0]=Hue;
		filter[0]="pass";
		min[1]=0;
		max[1]=255;
		filter[1]="pass";
		min[2]=braightness;
		max[2]=255;
		filter[2]="pass";
		for (i=0;i<3;i++){
		  selectWindow(""+i);
		  setThreshold(min[i], max[i]);
		  run("Convert to Mask");
		  if (filter[i]=="stop")  run("Invert");
		}
		imageCalculator("AND create", "0","1");
		imageCalculator("AND create", "Result of 0","2");
		for (i=0;i<3;i++){
		  selectWindow(""+i);
		  close();
		}
		selectWindow("Result of 0");
		close();
		selectWindow("Result of Result of 0");
		rename("flow_"+n+1);
	}
	run("Images to Stack", "name=Stack title=flow_");
}
