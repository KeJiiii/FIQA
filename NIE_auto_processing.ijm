//var operator = "";
//operator = getString("请输入操作者(大写)",operator);
var dir = getDirectory("Choose the Input Directory");
print("dir="+dir);
var parent_path = File.getParent(dir);
print("parent_path="+parent_path);
directory_list = getFileList(dir); 

dst_name="";

function combine(file,dir,fishnumber,volume)
{
	for (i = 0; i < fishnumber; i++)
	{
		b=dir+son_directory+"\\"+file+"000"+i+".nd2";
		print(b);
		run("Bio-Formats Importer", "open="+b+" autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		image = getTitle();
		selectImage(image);
		run("Subtract Background...", "rolling=200 stack");
		setMinAndMax(0, 4095);
		setMinAndMax(0, 4095);
		saveAs("Tiff", dir+file+i+1+"_");
	}
	run("Combine...", "stack1="+file+"1_.tif"+" stack2="+file+"2_.tif");
	if (fishnumber > 2)
	{
		for (j = 2; j < fishnumber; j++)
		{
			run("Combine...", "stack1=[Combined Stacks]"+" stack2="+file+j+1+"_.tif");
		}
	}	
	selectWindow("Combined Stacks");
	run("Split Channels");
	for (k = 0; k < 2; k++)
	{
		kk = 0;
		selectWindow("C"+k+1+"-Combined Stacks");
		//run("Subtract Background...", "rolling=200 stack");
		//setMinAndMax(0, 4095);
		if (k == 0)
		{
			kk = "C2";
		}
		if (k == 1)
		{
			kk = "C1";
		}
		//if (k == 2)
		//{
			//kk = "C3";
		//}
		saveAs("Tiff", dir+file+kk);
		selectWindow(file+kk+".tif");
		run("Z Project...", "projection=[Average Intensity] all");
		saveAs("Tiff", dir+"AVG_"+file+kk);
	}
	close("*");
}
	
for (i = 0; i < directory_list.length; i++)
{  
	son_directory = directory_list[i];
	son_directory=substring(son_directory,0,lengthOf(son_directory)-1);
	print("son_directory_name"+son_directory);
	file_list = getFileList(dir+son_directory);
	a=substring(son_directory,0,lengthOf(son_directory)-5);
	if (endsWith(son_directory, "Cycle"))
	{
		n=0;
		print(file_list.length);
		for (j = 0; j < file_list.length; j++)
		{
			if (endsWith(file_list[j], ".nd2"))	
			{
				n=n+1;
			}
		}
		fishnumber=n;
		print(fishnumber);
		combine(a,dir,n,1);
	}
}
close("*");