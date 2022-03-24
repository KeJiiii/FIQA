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
		//selectWindow(kk);
		//run("Subtract Background...", "rolling=200 stack");
		selectWindow(kk);
		//setMinAndMax(0, 4095);
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

function open_by_olympus(father_path){ // 用奥林巴斯插件打开图片并扣背景，设置范围，存于父文件下
	father_path_list = getFileList(father_path);
	for (i = 0; i < father_path_list.length; i++){
		Cycle_name = father_path_list[i];
		file_list = getFileList(father_path+Cycle_name);
		Cycle_main=substring(Cycle_name,0,lengthOf(Cycle_name)-6);
		if (endsWith(Cycle_name, "Cycle/")){
			print("Cycle_name======="+Cycle_name);
			n=0;
			for (j = 0; j < file_list.length; j++){
				if (endsWith(file_list[j], "_0001.oir")){
					n=n+1;
				}	
			}
			print("oir_number===="+n);
			for (k = 0; k < n; k++) {
				oir_path = father_path+Cycle_name+"matl.omp2info group"+k+1+"_level1";
				print("oir_path===="+oir_path);
				run("Viewer", "open="+oir_path);
				saveAs("Tiff", father_path+Cycle_main+k+1+"_");
				close("*");
				open(father_path+Cycle_main+k+1+"_.tif");
				group=getTitle();
				selectWindow(group);
				run("Subtract Background...", "rolling=200 stack");
				setMinAndMax(0, 4095);
				setMinAndMax(0, 4095);
				run("Save");
				close("*");
			}
			fishnumber = n;
			combine(fishnumber,father_path,Cycle_main);
		}
	}
}



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
