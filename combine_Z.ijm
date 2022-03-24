select_path = getDirectory("Choose the Input Directory");


function combine(fishnumber,filelocation,file){
	for (i = 0; i < fishnumber; i++){
		if (i+1 < 10){
			ii=i+1;
			//new_i="0"+i+1;
			new_i=i+1;
			print(new_i);
		}
			else {
				new_i=i+1;
		}
		//b=filelocation+file+new_i+".tif";
		b=filelocation+file+new_i+"-1.tif";
		print("b========"+b);
		open(b);
		rename(i);
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
		selectWindow(title);
		saveAs("Tiff", select_path+"combine_"+file+".tif");	
		
	}
}
file="Z_M_C2_trunk_"
combine(12,select_path,file);