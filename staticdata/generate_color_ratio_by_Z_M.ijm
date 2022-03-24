
select_path = getDirectory("Choose the Input Directory");
son_file_list=getFileList(select_path);

color_ratio_low=0
color_ratio_high=2
color_ratio_brightness=300
for (l = 0; l < son_file_list.length; l++){
	if (startsWith(son_file_list[l],"Z_M_C1")){
		open(select_path+son_file_list[l]);
		ch1=getTitle();
		ch2name="Z_M_C2"+substring(son_file_list[l], 6, lengthOf(son_file_list[l]));
		open(select_path+ch2name);
		ch2=getTitle();
		run("Color Ratio Plus v1", "image1=["+ch1+"] image2=["+ch2+"] background1=0 clipping_value1=0 background2=0 clipping_value2=0 multiplication=1 color_scale_low="+color_ratio_low+" color_scale_high="+color_ratio_high+" brightness="+color_ratio_brightness);
		selectWindow("Color Ratio");
		saveAs("tiff", select_path+"ratio_Z_M"+substring(son_file_list[l], 6, lengthOf(son_file_list[l])));
		run("Close All");
	}
}