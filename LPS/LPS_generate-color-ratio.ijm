// for lps experiment 
// generate color ratio and circle the roi by hand. auto rename and save the roi file
select_path = getDirectory("Choose the Input Directory");
son_file_list=getFileList(select_path);

color_ratio_low=0
color_ratio_high=1.5
color_ratio_brightness=200
for (l = 0; l < son_file_list.length; l++){
	if (startsWith(son_file_list[l],"Z") && endsWith(son_file_list[l],".tif")){
		open(select_path+son_file_list[l]);
		filename=substring(son_file_list[l], 0, lengthOf(son_file_list[l])-3);
		raw=getTitle();
		//selectWindow(raw);
		//run("Subtract Background...", "rolling=200 stack");
		//run("Save");
		selectWindow(raw);
		run("Duplicate...", "duplicate channels=1");
		img1=getTitle();
		selectWindow(raw);
		run("Duplicate...", "duplicate channels=2");
		img2=getTitle();
		run("Color Ratio Plus v1", "image1=["+img1+"] image2=["+img2+"] background1=0 clipping_value1=0 background2=0 clipping_value2=0 multiplication=1 color_scale_low="+color_ratio_low+" color_scale_high="+color_ratio_high+" brightness="+color_ratio_brightness);
		selectWindow("Color Ratio");
		run("Duplicate...", "duplicate");

		waitForUser ("圈roi");
		roiManager ("Select",0);
		roiManager("Save", select_path+"Muscle_"+filename+"roi");
		roiManager ("Reset"); 
		run("Close All");
	}
}