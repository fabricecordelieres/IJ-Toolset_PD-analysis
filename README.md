# Plasmodesmata Analysis Workflow

*This combinaison of tools (toolset and Colab script) is aimed at automatically segmenting cells, walls and plasmodesmata keeping track of relational informations between the three types of elements.*


## What was the user's request ?
<p align=center>
	<img src="https://github.com/fabricecordelieres/IJ-Toolset_PD-analysis/blob/main/images/Montage.jpg?raw=true">
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
		- **CSV:**
			- Cells.csv:
			- Junction_points.csv:
			- Walls_Modeling.csv:
			- Walls.csv:
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
