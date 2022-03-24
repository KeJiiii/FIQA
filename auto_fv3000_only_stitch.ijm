//var operator = "";
//operator = getString("请输入操作者(大写)",operator);
var dir = getDirectory("Choose the Input Directory");
print("dir="+dir);
var parent_path = File.getParent(dir);
print("parent_path="+parent_path);
directory_list = getFileList(dir); 


function stitch(stitchloca,oir_num,name)
{
	run("Grid/Collection stitching", "type=[Grid: column-by-column] order=[Down & Right                ] grid_size_x=1 grid_size_y="+oir_num+" tile_overlap=20 first_file_index_i=1 directory="+stitchloca+" file_names="+name+"{i}.oir output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");
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
			}
		}
		volumenumber = m/n;
		
		print(volumenumber);
		for (k = 0; k < file_list.length; k++)
		{
			if (endsWith(file_list[k], "0001.oir"))
			{
				stitchloca=dir+son_directory+"\\";
				name=substring(file_list[k],0,lengthOf(file_list[k])-5);
				oir_num=volumenumber;
				stitch(stitchloca,oir_num,name);
				run("Subtract Background...", "rolling=200 stack");
				setMinAndMax(0, 4095);
				call("ij.ImagePlus.setDefault16bitRange", 12);
				getDimensions(width, height, channels, Znumber, frames);
				run("Duplicate...", "duplicate slices="+Znumber-19+"-"+Znumber);
				run("Split Channels");
				for (k = 0; k < 3; k++)
				{
					kk = "C"+k+1+"-Fused-1";
					kkk="C"+k+1+"-Fused"
					//selectWindow(kk);
					//run("Subtract Background...", "rolling=200 stack");
					selectWindow(kk);
					//setMinAndMax(0, 4095);
					saveAs("Tiff", dir+a+"_"+kkk);
					selectWindow(a+"_"+kk+".tif");
					run("Z Project...", "projection=[Average Intensity] all");
					saveAs("Tiff", dir+"AVG_"+a+"_"+kkk);
					close("*");
				}
				close("*");
					
			}
		}
	}
	

}