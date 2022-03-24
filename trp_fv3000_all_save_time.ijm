//var operator = "";
//operator = getString("请输入操作者(大写)",operator);
//选择cycle 上级文件夹
var dir = getDirectory("Choose the Input Directory");
print("dir="+dir);
var parent_path = File.getParent(dir);
print("parent_path="+parent_path);
directory_list = getFileList(dir); 

//combine 功能，以及split channel ,avg功能
function combine(fishnumber,filelocation,file)
{
	print("combine");
	run("Combine...", "stack1="+file+1+".tif"+" stack2="+file+2+".tif");
	if (fishnumber > 2)
	{
		for (j = 3; j < fishnumber+1; j++)
		{
			run("Combine...", "stack1=[Combined Stacks]"+" stack2="+file+j+".tif");
		}
	}	
	selectWindow("Combined Stacks");
	run("Split Channels");
	for (k = 0; k < 3; k++)
	{
		kk = "C"+k+1+"-Combined Stacks";
		//selectWindow(kk);
		//run("Subtract Background...", "rolling=200 stack");
		selectWindow(kk);
		setMinAndMax(0, 4095);
		saveAs("Tiff", dir+file+kk);
		selectWindow(file+kk+".tif");
		run("Z Project...", "projection=[Average Intensity] all");
		saveAs("Tiff", dir+"AVG_"+file+kk);
	}
	close("*");
}

function stitch(stitchloca,oir_num,name)
{
	run("Grid/Collection stitching", "type=[Grid: column-by-column] order=[Down & Right                ] grid_size_x=1 grid_size_y="+oir_num+" tile_overlap=20 first_file_index_i=1 directory="+stitchloca+" file_names="+name+"{i}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");
}

for (i = 0; i < directory_list.length; i++)
{
	son_directory = directory_list[i];
	print("son_directory_name"+son_directory);
	file_list = getFileList(dir+son_directory);
	a=substring(son_directory,0,lengthOf(son_directory)-6);
	if (endsWith(son_directory, "Cycle/"))
	{
		n=0;
		m=0;
		for (j = 0; j < file_list.length; j++)
		{
			if (endsWith(file_list[j], "0001.oir"))	
			{
				n=n+1;
			}
			if (endsWith(file_list[j], ".oir"))	
			{
				m=m+1;
				run("Viewer", "open="+dir+son_directory+file_list[j]);
				oirrule=substring(file_list[j],0,lengthOf(file_list[j])-3);
				saveAs("Tiff", dir+son_directory+oirrule);
				//close("*");
			}
		}
		volumenumber = m/n;
		print(volumenumber);
		p=0;
		for (k = 0; k < file_list.length; k++)
		{
			if (endsWith(file_list[k], "0001.tif"))
			{		
				p=p+1;
				print("p========"+p);
				if (p<10)
				{
					d=dir+son_directory+a+"A01_G00"+p+"_0001.tif";
					tifname=a+"A01_G00"+p+"_0001.tif";
				} 
				else 
				{
					d=dir+son_directory+a+"A01_G0"+p+"_0001.tif";
					tifname=a+"A01_G0"+p+"_0001.tif";
				}
				if (volumenumber == 1)
				{
					//open(d);
					selectWindow(tifname);
					print("Subtract Background...");
					run("Subtract Background...", "rolling=200 stack");
					setMinAndMax(0, 4095);
					setMinAndMax(0, 4095);
					saveAs("Tiff", dir+a+"_"+p);
					close("*");
					
				}
				if (volumenumber > 1)
				{
					stitchloca=dir+son_directory+"\\";
					name=substring(tifname,0,lengthOf(tifname)-5);
					print("name======"+name);
					oir_num=volumenumber;
					stitch(stitchloca,oir_num,name);
					print("Subtract Background...");
					run("Subtract Background...", "rolling=200 stack");
					setMinAndMax(0, 4095);
					getDimensions(width, height, channels, Znumber, frames);
					run("Duplicate...", "duplicate slices="+Znumber-19+"-"+Znumber);
					saveAs("Tiff", dir+a+"_"+p);
					close("*");
				}
			}
		}
	fishnumber=n;
	filelocation=dir;
	file=a+"_";
	print("file====="+file);
	combine(fishnumber,filelocation,file);
	}
}