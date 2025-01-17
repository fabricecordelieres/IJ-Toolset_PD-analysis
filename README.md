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

## How does it work ? - IJ Toolset -
### Data structure for output
The toolset will output many data. In order to keep everything sorted, a specific folder/subfolders structure is adopted. The datastructure is generated as the user is activating the different tools. For each of the following folders, a subfolder is created per input file. This data structure is hosted in a user-defined root folder.
	
- _**User defined output folder**_: 
	- _**Sub-folder named after the image's title**_: 
		- **composite:**
			- *Dilated_Composite.tif:* A composite image made of 7 channels (each channel can be identified from the image's status bar):
				- Channel 1: Ori_Walls, the original image of walls, in gray LUT
				- Channel 2: Ori_PDs, the original image of PDs, in purple LUT
				- Channel 3: Skeleton, once cells have been isolated, the outer space is processed and subjected to skeletonization. This version of the output provides a dilated version of the skeleton to ease visualization. The image is displayed with the gray LUT.
				- Channel 4: Tagged_junction_points, from the skeleton image; the tri-point are isolated and tagged (one ID per junction point). This version of the output is dilated version to ease visualization. The image is displayed with the glasbey on dark LUT.
				- Channel 5: Tagged_walls, from the skeleton image; the tri-point are isolated, dilated and subtracted to the skeleton. The remaining fragments are individualized and tagged (one ID per wall). This version of the output is dilated version to ease visualization. The image is displayed with the glasbey on dark LUT.
				- Channel 6: Tagged_PDs, from the original image of PDs, each structure is individualized and tagged (one ID per PD). This version of the output is dilated version to ease visualization. The image is displayed with the glasbey on dark LUT.
				- Channel 7: Tagged_Cells, this is the inverted image from the dilated skeleton, where each cell is incividualized and tagged (one ID per cell). The image is displayed with the glasbey on dark LUT.
			- *Raw_Composite.tif:* same composition of channels as above, without the dilation step.
				<p align=center>
					<p align=center><img src="https://github.com/fabricecordelieres/IJ-Toolset_PD-analysis/blob/main/images/Dilated_composite_1.jpg?raw=true" width= "1024"></p>
					<p align=center><img src="https://github.com/fabricecordelieres/IJ-Toolset_PD-analysis/blob/main/images/Dilated_composite_2.jpg?raw=true" width=" 768"></p>
					<p align=center><b><em>Example of the different channels within the Dilated_Composite output</em></b></p>
				</p>
		- **CSV:**
			- *Cells.csv:* a csv file containing the following information, for each element:
				- ID: element's ID.
				- X_pix: X coordinates of the element's outlines.
				- Y_pix: Y coordinates of the element's outlines.
				- XCenter_pix: X coordinate of the element's geometrical centre.
				- YCenter_pix: Y coordinate of the element's geometrical centre.
				- Area_unit2: area of the element, expressed in the calibration unit of the image.
				- Mean_Intensity: average intensity over the element.
				- Total_Intensity: summed intensity over the element.
			- *Junction_points.csv:* a csv file containing the following information, for each element:
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
			- *PDs.csv:* a csv file containing the following information, for each element:
				- ID: element's ID.
				- X_pix: X coordinates of the element's outlines (single point).
				- Y_pix: Y coordinates of the element's outlines (single point).
				- XCenter_pix: X coordinate of the element's geometrical centre.
				- YCenter_pix: Y coordinate of the element's geometrical centre.
				- Area_unit2: area of the element, expressed in the calibration unit of the image.
				- Mean_Intensity: average intensity over the element (depends how large the expansion parameter has been chosen to integrate signal).
				- Total_Intensity: summed intensity over the element (depends how large the expansion parameter has been chosen to integrate signal).
				- ID_Parent_Wall: ID of first parent wall or 0.
			- *Walls.csv:* a csv file containing the following information, for each element:
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
			- *Walls_Modeling.csv:* a csv file containing the following information, for each element:
				- Total_Intensity: summed intensity over the element (same as Mean_Intensity).
				- Length_unit: length of the element, expressed in the calibration unit of the image (basically the area halfed as the outline is countouring the one pixel thick structure).
				- ID_Parent_Cell_1: ID of the first parent cell or 0.
				- ID_Parent_Cell_2: ID of the second parent cell or 0.
		- **JSON:**
			- *data.json:* contains all the data (same as in the csv files+analysis parameters and image metadata), as dictionnary entries including sub-directories (one per element), one per group of data:
				- analysis parameters
				- image metadata
				- cells
				- walls
				- junction points
				- PDs
		- **png:** Same inmages as in the "composite" folder, asved as individual png files.
			- Ori_PDs.png
			- Ori_Walls.png
			- Skeleton.png
			- Tagged_Cells.png
			- Tagged_junction_points.png
			- Tagged_PDs.png
			- Tagged_Walls.png

### Tool 1: CZI to Zip Tool
<p align=center>
	<img src="https://github.com/fabricecordelieres/IJ-Toolset_PD-analysis/blob/main/images/Toolbar_Tool1.jpg?raw=true" width="256">
</p>

*This tool is aimed at easing the analysis by performing automated projection of all CZI files within the provided input folder.*

<p align=center>
	<img src="https://github.com/fabricecordelieres/IJ-Toolset_PD-analysis/blob/main/images/GUI_CZI_to_Zip.png?raw=true" width="512"></br>
	<b><em>Graphical user interface: CZI to Zip</em></b>
</p>

1. Set the following parameters:
	- *Where are the files ?:* Either dragging and dropping the folder or using the Browse button, point at the folder where the CZI files are stored.
	- *Where to save projections ?:* Either dragging and dropping the folder or using the Browse button, point at the folder where projections should be saved.
	- *Projections type:* Select the projection type amongst the following options: Average Intensity, Max Intensity, Min Intensity, Sum Slices, Standard Deviation or Median.
2. Press Ok. NB: in order to speed up the process, none of the files will be displayed.
	
### Tool 2: Single file Tool
<p align=center>
	<img src="https://github.com/fabricecordelieres/IJ-Toolset_PD-analysis/blob/main/images/Toolbar_Tool2.jpg?raw=true" width="256">
</p>

*This tool is aimed at performing the analysis of a single image, that should already be opened.*

<p align=center>
	<img src="https://github.com/fabricecordelieres/IJ-Toolset_PD-analysis/blob/main/images/GUI_Single_file_Tool.png?raw=true" width="512"></br>
	<b><em>Graphical user interface: Single file Tool</em></b>
</p>

1. Set the following parameters:
	- *Output folder:* Either dragging and dropping the folder or using the Browse button, point at the folder where projections should be saved.
	- *Preprocessing parameters for walls detection:*
		- Gamma: defaut 0.5
		- Subtract background radius (pixels): defaut 15
		- CLAHE block size (pixels): 25
		- Median filter radius (pixels): defaut 5
		- Gaussian filter radius (pixels): defaut 15
		- Opening, number of iterations: defaut 8
		- Opening, count: defaut 3
	- *Preprocessing parameters for PDs detection:*
		- Subtract background radius (pixels): defaut 15
		- ROI enlargement (pixels): defaut 6
	- *Detection parameters for cells:*
		- Max filter radius (pixels): defaut 8
		- Min filter radius (pixels): defaut 4
		- Max cell size (pixels): defaut 30000
	- *Detection parameters for walls:*
		- ROI enlargement (pixels): defaut 2
	- *Detection parameters for PDs:*
		- ROI enlargement (pixels): defaut 3
	- *Tolerances for parents' search:*
		- PDs, search radius (pixels): defaut 6
		- Junction points, search radius (pixels): defaut 10
		- Walls, search radius (pixels): defaut 10
2. Press Ok. NB: in order to speed up the process, none of the files will be displayed.

### How does it work ?
The process takes place in several steps:

#### Step 1 - Pre-process walls:
1. The original walls image is duplicated twice, duplicates being named Ori_walls and Skeleton, respectively.
2. A gamma transform is applied to the Skeleton image, in order to enhance low intensity walls.
3. The Skeleton image is subjected to [CLAHE transform](https://imagej.net/plugins/clahe#:~:text=The%20plugin%20Enhance%20Local%20Contrast,Enhance%20Local%20Contrast%20(CLAHE).), in order to further enhance the local contrast of walls.
4. Background is subtracted unsing the ImageJ Subtract Background function.
5. A median filter is applied to locally homogeneize intensities.
6. The resulting image is duplicated, named "Blur" and subjected to Gaussian blur: this step allow extracting low frequencies, allowing to estimate the general non uniformity of the background.
7. The Skeleton image is divided by the Blur image. The result image is 32-bit to take into account non integer resulting values. This division allows normalizing the Skeleton intensities relative to uneven illumination estimate, therefore correcting for the default in illumination.
8. The Blur image is closed.
9. The Skeleton image is scaled down to 8-bit, thresholded using the Huang method, considering the white parts as background: in a way, we are trying to isolate the cells i.e. "the non-walls".
10. The image is converted to a mask where the holes are filled, and a open operation is performed to both avoid having holes inside cells and start separating cells that may be linked by few pixels.
11. The Skeleton image is inverted: the walls are now in white over a black background.
12. The image is finally subjected to Skeletonization.
   
#### Step 2 - Find 3 points:
1. The Skeleton image is selected, duplicated and the duplicate named "3_points".
2. A specific erosion is performed, using a 6 pixels neighborhood condition: only pixels having 3 pixels are retained.
3. In some cases, several close pixels might be kept: in order to have only one point per group, the Find Maxima function is used to create a map containing only one spot per group.
4. A tagged map (i.e. map where each object appears with an intensity corresponding to its ID) is generated, named "Tagged_junction_points".
5. A table named "Junction_points" is generated, containing for each three points (ROI) all the parameters already described  in the [Data structure for output section](#how-does-it-work----ij-toolset--).

#### Step 3 - Isolate walls:
1. The "Junction_points" table is selected and the coordinates of individuals three points is stored.
2. The Skeleton image is duplicated and named "Walls_Raw".
3. A multiple point selection is created, made of points having as coordinated the coordinates of the three points. This selection is enlarged to take shape of multiple circles that are then cleared. As a result, the skeleton image see its network cut out into segments, by removing all the junction points between three segments.
4. A tagged map (i.e. map where each object appears with an intensity corresponding to its ID) is generated, named "Tagged_Walls".
5. A table named "Walls" is generated, containing for each all the parameters already described  in the [Data structure for output section](#how-does-it-work----ij-toolset--).

#### Step 4 - Isolate cells:
1. The Tagged_walls image is selected, any ROI on it is removed? The image is duplicated and the duplicate named "Cells_Raw".
2. The image is subjected to morphological closing: a maximum filter is applied, followed by minimum filter. NB: by default, this is not a pure closing operation as the max and min filters may be of different radius.
3. A tagged map (i.e. map where each object appears with an intensity corresponding to its ID) is generated, named "Tagged_Cells".
5. A table named "Cells" is generated, containing for each cell (ROI) all the parameters already described  in the [Data structure for output section](#how-does-it-work----ij-toolset--).

#### Step 5 - Pre-process PDs:
#### Step 6 - Isolate PDs:
#### Step 7 - Get parents
* PD relative to a single wall
* Junction point relative to three walls
* Walls relative to two adjacent cells
Step 8 - Export data as JSON file



### Tool 3: Multiple file Tool
<p align=center>
	<img src="https://github.com/fabricecordelieres/IJ-Toolset_PD-analysis/blob/main/images/Toolbar_Tool3.jpg?raw=true" width="256">
</p>


### Tool 4: ZipIt & View
<p align=center>
	<img src="https://github.com/fabricecordelieres/IJ-Toolset_PD-analysis/blob/main/images/Toolbar_Tool4.jpg?raw=true" width="256">
</p>

	
## How does it work ? - Colab script -
The Colab script will take care of YYY.
1. 

### 

## How to install/use it ?

The [release page](https://github.com/fabricecordelieres/IJ-Toolset_PD-analysis/releases/tag/v1.0) displays a download link for PD-analysis_Workflow.zip file. Once unzipped, it contains everything that needs to be installed.

*The toolset mostly relies on functions and plugins that are already embarqued within Fiji. Tool 4, however, requires a separate plugin that should be installed before using the toolset:*
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
