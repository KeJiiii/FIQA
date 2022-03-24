// for static experiment 
// generate color ratio and circle the roi by hand. auto rename and save the roi file
select_path = getDirectory("Choose the Input Directory");
son_file_list=getFileList(select_path);


for (l = 0; l < son_file_list.length; l++){
	if (startsWith(son_file_list[l],"stitch") && endsWith(son_file_list[l],".tif")){
		open(select_path+son_file_list[l]);
		filename=substring(son_file_list[l], 0, lengthOf(son_file_list[l])-3);
		raw=getTitle();
		//selectWindow(raw);
		//run("Subtract Background...", "rolling=200 stack");
		//run("Save");
		selectWindow(raw);
		roiManager ("Reset"); 
		waitForUser ("圈背景");
		
		run("Select None");
		run("Duplicate...", "duplicate channels=1");
		rename("C1");
		selectWindow("C1");
		roiManager ("Select",0);
		
		//run("Measure Stack...");// for static data
		run("Measure Stack...", "channels slices frames order=czt(default)"); // for kinetic timelampse data

		
		Table.sort("Mean");
		C1_value=getResult("Mean");
		C1_value=parseInt(C1_value)+1;
		run("Clear Results");
		


		selectWindow(raw);
		run("Select None");
		run("Duplicate...", "duplicate channels=2");
		rename("C2");
		selectWindow("C2");
		roiManager ("Select",0);
		//run("Measure Stack...");
		run("Measure Stack...", "channels slices frames order=czt(default)"); // for kinetic timelampse data
		Table.sort("Mean");
		C2_value=getResult("Mean");
		C2_value=parseInt(C2_value)+1;
		run("Clear Results");

		/*
		Dialog.create("get value ");
			Dialog.addMessage("Enter your setting here");
			Dialog.addNumber("C1 value", 0);
			Dialog.addNumber("C2 value", 0);
		Dialog.show();
		C1_value=Dialog.getNumber;
		C2_value=Dialog.getNumber;
		*/
		selectWindow("C1");
		run("Select None");
		run("Subtract...", "value="+C1_value+" stack");
		
		selectWindow("C2");
		run("Select None");
		run("Subtract...", "value="+C2_value+" stack");
		
		run("Merge Channels...", "c1=[C1] c2=[C2] create");
		saveAs("Tiff", select_path+"Sub_"+C1_value+"_"+C2_value+"_"+filename+"tif");
		roiManager ("Reset"); 
		run("Close All");
	}
}