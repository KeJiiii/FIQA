//var operator = "";
//operator = getString("请输入操作者(大写)",operator);
var dir = getDirectory("Choose the Input Directory");
print("dir="+dir);
var parent_path = File.getParent(dir);
print("parent_path="+parent_path);
directory_list = getFileList(dir); 
print(directory_list.length)

dst_name="";
for (i = 0; i < directory_list.length; i++)
{    
	var oir_num = 0;
	print(directory_list[i]+"\n");
	son_directory = directory_list[i];
	
	print("son_directory_name"+son_directory);
	
	file_list = getFileList(dir+son_directory);
	a=substring(son_directory,0,lengthOf(son_directory)-6);
	b=dir+son_directory+"\\"+a+"A01_G001_0001.oir";
	c=dir+son_directory+"\\"+a+"A01_G002_0001.oir";
	d=dir+son_directory+"\\"+a+"A01_G003_0001.oir";
	//e=dir+son_directory+"\\"+a+"A01_G004_0001.oir";
	//f=dir+son_directory+"\\"+a+"A01_G005_0001.oir";
	//g=dir+son_directory+"\\"+a+"A01_G006_0001.oir";
	//h=dir+son_directory+"\\"+a+"A01_G007_0001.oir";
	//k=dir+son_directory+"\\"+a+"A01_G008_0001.oir";
	print(b);
	run("Bio-Formats", "open="+b+" autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	run("Bio-Formats", "open="+c+" autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	run("Bio-Formats", "open="+d+" autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	//run("Bio-Formats", "open="+e+" autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	//run("Bio-Formats", "open="+f+" autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	//run("Bio-Formats", "open="+g+" autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	//run("Bio-Formats", "open="+h+" autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	//run("Bio-Formats", "open="+k+" autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	run("Combine...", "stack1="+a+"A01_G001_0001.oir"+" stack2="+a+"A01_G002_0001.oir");
	run("Combine...", "stack1=[Combined Stacks]"+" stack2="+a+"A01_G003_0001.oir");
	//run("Combine...", "stack1=[Combined Stacks]"+" stack2="+a+"A01_G004_0001.oir");
	//run("Combine...", "stack1=[Combined Stacks]"+" stack2="+a+"A01_G005_0001.oir");
	//run("Combine...", "stack1=[Combined Stacks]"+" stack2="+a+"A01_G006_0001.oir");
	//run("Combine...", "stack1=[Combined Stacks]"+" stack2="+a+"A01_G007_0001.oir");
	//run("Combine...", "stack1=[Combined Stacks]"+" stack2="+a+"A01_G008_0001.oir");
	//run("Combine...", "stack1=[Combined Stacks]"+" stack2="+a+"A01_G002_0001.oir");
	run("Split Channels");
	
	selectWindow("C1-Combined Stacks");
	run("Subtract Background...", "rolling=200 stack");
	setMinAndMax(0, 4095);
	saveAs("Tiff", dir+a+"v1-C1-Combined Stacks");
	selectWindow(a+"v1-C1-Combined Stacks.tif");
	run("Z Project...", "projection=[Average Intensity] all");
	saveAs("Tiff", dir+"AVG_"+a+"v1-C1-Combined Stacks");
	
	
	selectWindow("C2-Combined Stacks");
	run("Subtract Background...", "rolling=200 stack");
	setMinAndMax(0, 4095);
	saveAs("Tiff", dir+a+"v1-C2-Combined Stacks");
	selectWindow(a+"v1-C2-Combined Stacks.tif");
	run("Z Project...", "projection=[Average Intensity] all");
	saveAs("Tiff", dir+"AVG_"+a+"v1-C2-Combined Stacks");
	
	selectWindow("C3-Combined Stacks");
	run("Subtract Background...", "rolling=200 stack");
	setMinAndMax(0, 4095);
	saveAs("Tiff", dir+a+"v1-C3-Combined Stacks");
	selectWindow(a+"v1-C3-Combined Stacks.tif");
	run("Z Project...", "projection=[Average Intensity] all");
	saveAs("Tiff", dir+"AVG_"+a+"v1-C3-Combined Stacks");

//run combine for all the C1 figure or C2 figure
	
	close("*");
	
	  
}
//directory_newlist = getFileList(dir);
//for (j = directory_list.length; j < directory_newlist.length; i++)
//{    
//open(dir+20210608_cyto_leo_01-02_C1-Combined Stacks.tif");
//selectWindow("20210608_cyto_leo_01-02_C1-Combined Stacks.tif");
//run("Combine...", "stack1=[20210608_cyto_his_01-02_C1-Combined Stacks.tif] stack2=[20210608_cyto_leo_01-02_C1-Combined Stacks.tif]");

//print("dst_name"+dst_name);
//print(dir+dst_name+"_"+operator+"\\");

/*
*/