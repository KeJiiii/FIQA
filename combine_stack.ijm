select_path = getDirectory("Choose the Input Directory");

function splitchannel(title,file){
	selectWindow(title);
	run("Split Channels");
	for (k = 0; k < 2; k++){
		kk = "C"+k+1+"-"+title;
		//selectWindow(kk);
		//run("Subtract Background...", "rolling=200 stack");
		selectWindow(kk);
		//setMinAndMax(0, 4095);
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
			ii=i+1;
			new_i="0"+i+1;
			//new_i=i+1;
			print(new_i);
		}
			else {
				new_i=i+1;
		}
		b=filelocation+file+new_i+".tif";
		//b=filelocation+file+new_i+"-1.tif";
		print("b========"+b);
		open(b);
		run("Z Project...", "start=13 stop=30 projection=[Average Intensity] all");
		rename(i);
	}
	if (fishnumber == 1){
		title = file+1+".tif";
		file = file;
		splitchannel(title,file);
	}
	if (fishnumber > 1){
		run("Combine...", "stack1=["+"0]"+" stack2=["+"1]");
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
file="stitch_20211212_ACT-GRIT-HIS-PRE_A01_G0"
combine(8,select_path,file);