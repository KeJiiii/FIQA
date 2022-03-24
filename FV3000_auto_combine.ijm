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
		b=dir+son_directory+"\\"+file+"A01_G00"+i+1+"_000"+volume+".oir";
		run("Bio-Formats", "open="+b+" autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	}
	run("Combine...", "stack1="+file+"A01_G001_000"+volume+".oir"+" stack2="+file+"A01_G002_000"+volume+".oir");
	if (fishnumber > 2)
	{
		for (j = 3; j < fishnumber+1; j++)
		{
			run("Combine...", "stack1=[Combined Stacks]"+" stack2="+file+"A01_G00"+j+"_000"+volume+".oir");
		}
	}	
	selectWindow("Combined Stacks");
	run("Split Channels");
	for (k = 0; k < 3; k++)
	{
		kk = "C"+k+1+"-Combined Stacks";
		selectWindow(kk);
		run("Subtract Background...", "rolling=200 stack");
		setMinAndMax(0, 4095);
		saveAs("Tiff", dir+file+"V"+volume+"-"+kk);
		selectWindow(file+"V"+volume+"-"+kk+".tif");
		run("Z Project...", "projection=[Average Intensity] all");
		saveAs("Tiff", dir+"AVG_"+file+"V"+volume+"-"+kk);
	}
	close("*");
}
	
for (i = 0; i < directory_list.length; i++)
{  
	son_directory = directory_list[i];
	print("son_directory_name"+son_directory);
	file_list = getFileList(dir+son_directory);
	a=substring(son_directory,0,lengthOf(son_directory)-6);
	if (endsWith(son_directory, "Cycle/"))
	{
		oirnumber = (file_list.length-2);
		n=0;
		print(file_list.length);
		for (j = 0; j < file_list.length; j++)
		{
			if (endsWith(file_list[j], "0001.oir"))	
			{
				n=n+1;
			}
		}
		fishnumber=oirnumber/n;
		print(fishnumber);
		for (k = 0; k < fishnumber; k++)
		{
			volume=k+1;
			print(n);
			print(volume);
			combine(a,dir,n,volume);
		}
	}
}
close("*");
