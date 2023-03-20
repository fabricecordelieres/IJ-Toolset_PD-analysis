# Plasmodesmata Analysis Workflow

*This combinaison of tools (toolset and Colab script) is aimed at automatically segmenting cells, walls and plasmodesmata keeping track of relational informations between the three types of elements.*


## What was the user's request ?
<p align=center>
	<img src="https://github.com/fabricecordelieres/IJ-Toolset_PD-analysis/blob/main/images/Montage.jpg?raw=true" width="512">
</p>
The user has confocal stacks presenting in one channel a labelling of cell walls, on the other channel a calose staining. The aim of automation is to get a delineationg of cells, walls and calose positive puncta:
- Each cell should be tagged with an ID and basic morphometric informations should be extracted.
- Each wall should be tagged with an ID and basic morphometric informations should be extracted. Each wall should be associated with the IDs of its two bording cells to relate both structures. As a strating point, walls are considered to be segments running between two tri-points (see below).
- Each puncta should be tagged with an ID and basic morphometric informations should be extracted. Each punta should be associated with the ID of the wall it's sitting on.

The toolset allows segmenting all elements, extracting relational and basic morphometrical informations. The Colab script is a a basic tool to shape and visualize the extracted data.

## How does it work ?
### IJ Toolset
#### Data structure for output
The toolset will output many data. In order to keep everything sorted, a specific folder/subfolders structure is adopted. The datastructure is generated as the user is activating the different tools. For each of the following folders, a subfolder is created per input file. This data structure is hosted in a user-defined root folder.
	
- _**User defined output folder**_: 
	- _**Sub-folder named after the image's title**_: 
		- **composite:**
			- Dilated_Composite.tif: A composite image made of 7 channels (each channel can be identified from the image's status bar):
				- Channel 1: Ori_Walls, the original image of walls, in gray LUT
				- Channel 2: Ori_PDs, the original image of PDs, in purple LUT
				- Channel 3: Skeleton, once cells have been isolated, the outer space is processed and subjected to skeletonization. This version of the output provides a dilated version of the skeleton to ease visualization. The image is displayed with the gray LUT.
				- Channel 4: Tagged_junction_points, from the skeleton image; the tri-point are isolated and tagged (one ID per junction point). This version of the output is dilated version to ease visualization. The image is displayed with the glasbey on dark LUT.
				- Channel 5: Tagged_walls, from the skeleton image; the tri-point are isolated, dilated and subtracted to the skeleton. The remaining fragments are individualized and tagged (one ID per wall). This version of the output is dilated version to ease visualization. The image is displayed with the glasbey on dark LUT.
				- Channel 6: Tagged_PDs, from the original image of PDs, each structure is individualized and tagged (one ID per PD). This version of the output is dilated version to ease visualization. The image is displayed with the glasbey on dark LUT.
				- Channel 7: Tagged_Cells, this is the inverted image from the dilated skeleton, where each cell is incividualized and tagged (one ID per cell). The image is displayed with the glasbey on dark LUT.
				- Raw_Composite.tif:
<p align=center>
	<p align=center><img src="https://github.com/fabricecordelieres/IJ-Toolset_PD-analysis/blob/main/images/Dilated_composite_1.jpg?raw=true" width= "1024"></p>
	<p align=center><img src="https://github.com/fabricecordelieres/IJ-Toolset_PD-analysis/blob/main/images/Dilated_composite_2.jpg?raw=true" width=" 768"></p>
	<p align=center><b><em>Example of the different channels within the Dilated_Composite output</em></b></p>
</p>
			
		- **CSV:**
			- Cells.csv: a csv file containing the following information, for each element:
				- ID: element's ID.
				- X_pix: X coordinates of the element's outlines.
				- Y_pix: Y coordinates of the element's outlines.
				- XCenter_pix: X coordinate of the element's geometrical centre.
				- YCenter_pix: Y coordinate of the element's geometrical centre.
				- Area_unit2: area of the element, expressed in the calibration unit of the image.
				- Mean_Intensity: average intensity over the element.
				- Total_Intensity: summed intensity over the element.
			- Junction_points.csv: a csv file containing the following information, for each element:
				- ID: element's ID.
				- X_pix: X coordinates of the element's outlines (single point).
				- Y_pix: Y coordinates of the element's outlines (single point).
				- XCenter_pix: X coordinate of the element's geometrical centre.
				- YCenter_pix: Y coordinate of the element's geometrical centre.
				- Area_unit2: area of the element, expressed in the calibration unit of the image.
				- Mean_Intensity: average intensity over the element (same as Total_Intensity).
				- Total_Intensity: summed intensity over the element (same as Mean_Intensity).
				- ID_Parent_Wall_1: ID of the first parent wall or 0.
				- ID_Parent_Wall_2: ID of the second parent wall or 0.
				- ID_Parent_Wall_3: ID of the third parent wall or 0.
			- PDs.csv: a csv file containing the following information, for each element:
				- ID: element's ID.
				- X_pix: X coordinates of the element's outlines (single point).
				- Y_pix: Y coordinates of the element's outlines (single point).
				- XCenter_pix: X coordinate of the element's geometrical centre.
				- YCenter_pix: Y coordinate of the element's geometrical centre.
				- Area_unit2: area of the element, expressed in the calibration unit of the image.
				- Mean_Intensity: average intensity over the element (depends how large the expansion parameter has been chosen to integrate signal).
				- Total_Intensity: summed intensity over the element (depends how large the expansion parameter has been chosen to integrate signal).
				- ID_Parent_Wall: ID of first parent wall or 0.
			- Walls.csv: a csv file containing the following information, for each element:
				- ID: element's ID.
				- X_pix: X coordinates of the element's outlines.
				- Y_pix: Y coordinates of the element's outlines.
				- XCenter_pix: X coordinate of the element's geometrical centre.
				- YCenter_pix: Y coordinate of the element's geometrical centre.
				- Area_unit2: area of the element, expressed in the calibration unit of the image.
				- Mean_Intensity: average intensity over the element (same as Total_Intensity).
				- Total_Intensity: summed intensity over the element (same as Mean_Intensity).
				- Length_unit: length of the element, expressed in the calibration unit of the image (basically the area halfed as the outline is countouring the one pixel thick structure).
				- ID_Parent_Cell_1: ID of the first parent cell or 0.
				- ID_Parent_Cell_2: ID of the second parent cell or 0.
			- Walls_Modeling.csv: a csv file containing the following information, for each element:
				- Total_Intensity: summed intensity over the element (same as Mean_Intensity).
				- Length_unit: length of the element, expressed in the calibration unit of the image (basically the area halfed as the outline is countouring the one pixel thick structure).
				- ID_Parent_Cell_1: ID of the first parent cell or 0.
				- ID_Parent_Cell_2: ID of the second parent cell or 0.
		- **JSON:**
			- data.json:
		- **png:**
			- Ori_PDs.png:
			- Ori_Walls.png:
			- Skeleton.png:
			- Tagged_Cells.png:
			- Tagged_junction_points.png:
			- Tagged_PDs.png:
			- Tagged_Walls.png:

#### Tool 1: 
	
#### Tool 2: 


#### Tool 3: 
	
### Colab script
The Colab script will take care of YYY.
1. 

### 

## How to install/use it ?

The [release page](https://github.com/fabricecordelieres/IJ-Toolset_PD-analysis/releases/tag/v1.0) displays a download link for PD-analysis_Workflow.zip file. Once unzipped, it contains everything that needs to be installed.

*The toolset mostly relies on functions and plugins that are already embarqued within Fiji. Tool 3, however, requires a separate plugin that should be installed before using the toolset:*
1. Download [Zip_It.jar](https://github.com/fabricecordelieres/IJ-Plugin_Zip-It/releases/tag/v1.0).
3. Drag-and-drop the .jar file to your ImageJ/Fiji toolbar.
4. In the File saver window, press Ok.
5. Restart Fiji/ImageJ.

*The toolset installation is quite straightforward:*
1. Copy/Paste the toolset file to Fiji's installation folder, in macros/toolset.
3. Under the ImageJ toolbar, on the right-most side, click on the red double arrow and select the appropriate toolset (choose "Startup macro" to go back to the original status).
4. Default ImageJ tools have partly been replaced by your toolset's buttons.

To use the toolset, first activate it, then press the buttons.


## Revisions:
### Version 1: 15/03/2023
