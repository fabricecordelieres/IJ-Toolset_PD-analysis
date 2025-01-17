//Macro version
var version="1.0";

//Projection methods
var projMeth=newArray("Average Intensity", "Max Intensity", "Min Intensity", "Sum Slices", "Standard Deviation", "Median");
var proj="Max Intensity";

//Channels & original image
var chWalls=1;
var chPDs=2;

var ori;

//Preprocess Walls
var useCellpose=true;

//Cellpose
var models=newArray("cyto", "nuclei", "cyto2", "tissuenet", "livecell");
var model="cyto2";
var cellDiameter=100;
var flowThr=0.3;
var cellProbThr=-1;

//Regular method
var gamma=0.5;
var subBkgdWalls=15;
var blockSize=25;
var medRad=5;
var gaussRad=15;
var openItWalls=8;
var openCountWalls=3;

//Isolate walls
var enlargeWalls=2;

//Isolate cells
var maxRad=8;
var minRad=4; 
var maxSize=30000;

//Preprocess PDs
var subBkgdPDs=15;
var enlargePDs=6;

//Isolate PDs
var prominence=0.6;
var radMeasure=3;

//Find parents
var radPDs=6;
var radJPs=10;
var radWalls=10;

//Batch
var batch=false;
var inDir="";
var outDir="";

//-------------------------------------------------------
macro "CZI to Zip Action Tool - N66C31aDc8C0beDe1C5c0DbdC07cCeeeCff0D47D56D57D66D67D76D77D86D87D96D97Da6Da7Db6Db7Dc6Ca30D3eD4eD5eD6eD7eD8eD9eDaeCcceC0adDc1C48cCdffCabdC17aCaceD62C0fcD4bD5bD6bD7bD8bD9bDabC28cCeefCff2D55C985D48D58D68D78D88D98Da8CbdeC8adC58cCffeD54CcccC25aC9ceD92Da2Db2C3f1DbcC0adDb1CeeeCff1D37D46Cb44CcdeC5adC4acDc0Dd0CfffD19CabdC26bC9dfC4adDe0C39cCeffD1cCaacCb54CdeeC7bdC89cCfffCdfcD1dC20bD39C8ceDc2C4e0D3dD4dD5dD6dD7dD8dD9dDadC09dD91CeeeCa30DbeCcceC0aeC49cD90CfffCabdC17cD4aD5aD6aD7aD8aD9aDaaCbceC3f3DcbC38cCeefCdd6D28C876Db8CceeC9bdD72C69dCfffDdeDedCccdC42aDd7C9ceC4f3D3cC19dCeeeCff1D65D75D85D95Da5Db5Dc5Dd5Ca51DdcCdceD1aC7adC5adCbccD51C37bCbdfC9adC2aeCeefCbbcD50C99aD60CddfC8cdD61C98dD29CffdD64D74D84D94Da4Db4Dc4Dd4De4C10bD49D59D69D79D89D99Da9Db9C7cfC5d0DccC08cD81CddeCcdeC0bdC59cD80CeffCabdC07bCbdeD52C29cCdd4Dd6CddeC8beC59dCbbdC06bC9ceC3f2D4cD5cD6cD7cD8cD9cDacC0adCeefCddeD41C7adC49dCbbdC27bCadfC7acC39cCeffCaacCa95D38CdeeDe3C7beC7adCffdD18C8dfC19cCdefC940DcdCcceC5beC49cDa0Db0CeffCabdCbceD42C0ebDcaC38cCff9D27D36D45C5abCcefC9bdC7acCcddC46aC8efC5e1DdbC1adCffeCa52D2eC7bdC5adCbcdC47bCaefC9adC49cCceaDebCd98CdefC8ceDd2C8acC08cDbaCbdeC0adC48cCeffC06bCaceC37cCcdeC9bdC77cDe7CccdC16aC09dC6adCbbdC36bC0fcD3bCabcCd88DceDddC79dC8ceC1adC49cC9bdC6f8DdaC38cC68bC9bdCcddC35aC0adDa1CbcdC47bC39dDe2CddbD1eC8beC99cC7dfC08dCedeCbdeC0beDd1C48cC06bD3aC28cCff6De5CccdC15cDc9Dd8C6beC4adC27bD71CafeDe9C8adC39cCdaaDecC9bdD82C8dfC19dC2edD2bDd9C4dbDbbC38cC79bD70CcffD1bCdddDe6C55aC6f2D2dC1adCba3Dc7C7beCbcdC46cD2aC9bcC39dCcfaDeaCd99C8cdDe8Ca9cCabdC59aC58cC06bCadeCcdeC5aeC4bdC9eaD2cC55aBf0C31aC0beD01C5c0C07cD63CeeeCff0Ca30CcceC0adC48cCdffCabdC17aCaceC0fcC28cCeefD10Cff2C985CbdeC8adD29C58cCffeCcccC25aC9ceC3f1C0adCeeeCff1Cb44CcdeC5adC4acCfffD16D17D1bD76D78D79D7bD7dD81CabdC26bC9dfC4adC39cD03D14CeffCaacCb54CdeeC7bdD74C89cD65CfffD08D33D7eCdfcC20bC8ceC4e0C09dCeeeCa30CcceD67D6cC0aeD12C49cCfffD07CabdD69D6eC17cCbceC3f3C38cCeefD84Cdd6C876CceeD34C9bdC69dD47D4cD58D5dCfffCccdD31C42aC9ceC4f3C19dCeeeCff1Ca51CdceC7adD2eD39C5adD72CbccC37bCbdfD42C9adD25C2aeCeefCbbcC99aCddfC8cdC98dCffdC10bC7cfC5d0C08cCddeCcdeC0bdC59cCeffD1cCabdD61C07bCbdeD46D4bC29cCdd4CddeD82C8beD4aC59dCbbdD6aC06bD54C9ceC3f2C0adD02CeefCddeC7adD3eD45C49dCbbdC27bCadfC7acC39cCeffD19D1eD32CaacCa95CdeeC7beD3bC7adD56D66CffdC8dfC19cCdefD75D83C940CcceD71C5beC49cCeffCabdD26CbceD21C0ebC38cD3aCff9C5abCcefC9bdD49D4eC7acD6bCcddC46aD57D5cC8efD23C5e1C1adCffeD05Ca52C7bdD24C5adD38D3dCbcdD41C47bD5aCaefD43C9adD2aC49cD73CceaCd98CdefD15C8ceC8acD68D6dC08cCbdeC0adC48cD3cCeffC06bCaceD48C37cCcdeC9bdC77cCccdC16aD64C09dD13C6adCbbdD28D2dC36bC0fcCabcCd88C79dD27D2cC8ceD44C1adC49cC9bdD2bC6f8C38cC68bD59D5eC9bdCcddD04C35aD55C0adCbcdC47bC39dCddbC8beD36C99cC7dfC08dD53CedeCbdeC0beC48cC06bC28cCff6CccdC15cC6beC4adC27bCafeC8adD5bC39cCdaaC9bdC8dfD22C19dD62C2edC4dbC38cD35C79bCcffCdddC55aC6f2C1adCba3C7beD00CbcdC46cC9bcC39dD52CcfaCd99C8cdCa9cCabdD51C59aC58cD37C06bCadeD4dCcdeC5aeD11C4bdC9eaC55aB0fC31aC0beC5c0C07cD62CeeeD0aD8aCff0Ca30CcceD65C0adC48cCdffD28CabdD87C17aCaceC0fcC28cCeefD15D83Cff2C985CbdeD29C8adD66C58cD30CffeCcccC25aD54C9ceC3f1C0adCeeeD7aCff1Cb44CcdeD2aD5aC5adD73C4acCfffD06D84CabdC26bC9dfD42C4adC39cCeffCaacD26Cb54CdeeD01C7bdC89cCfffD32CdfcC20bC8ceC4e0C09dD03D12CeeeD10Ca30CcceC0aeC49cCfffD86CabdC17cCbceD60C3f3C38cD08CeefDaaCdd6C876CceeC9bdC69dCfffCccdC42aC9ceD36D46C4f3C19dCeeeCff1Ca51CdceC7adD77C5adD18D49CbccC37bD24CbdfC9adC2aeD67CeefD31CbbcC99aCddfD76C8cdC98dCffdC10bC7cfD47C5d0C08cCddeD81CcdeD4aC0bdC59cDa7CeffD38CabdC07bD58CbdeC29cCdd4CddeD6aD82C8beD40C59dD34D44CbbdC06bC9ceD21C3f2C0adCeefD70CddeD9aC7adC49dCbbdD09C27bD59CadfD41C7acD19C39cD78CeffCaacD89Ca95CdeeC7beC7adCffdC8dfD43C19cCdefC940CcceC5beD48C49cD14CeffD37CabdD79Da6CbceC0ebC38cCff9C5abCcefD27C9bdC7acCcddD1aC46aC8efD22C5e1C1adD04CffeCa52C7bdC5adCbcdC47bD50CaefC9adD25C49cCceaCd98CdefC8ceC8acC08cCbdeC0adC48cCeffD33C06bD63CaceC37cD88CcdeD3aC9bdC77cCccdD16C16aC09dD13C6adD71CbbdC36bD55C0fcCabcD96Cd88C79dC8ceC1adC49cC9bdC6f8C38cD98C68bD64C9bdD97CcddC35aC0adCbcdC47bDa8C39dD61CddbC8beC99cD20Da9C7dfD23C08dD57CedeCbdeD74C0beC48cD56C06bD52C28cD51Cff6CccdC15cC6beC4adD69C27bCafeC8adC39cD72CdaaC9bdC8dfC19dD68C2edC4dbD17C38cD35C79bCcffCdddC55aC6f2C1adCba3C7beD45CbcdD07C46cC9bcC39dCcfaCd99C8cdD05Ca9cCabdC59aD02D11C58cC06bD53CadeCcdeD39C5aeC4bdC9eaC55aD99Nf0C31aC0beC5c0C07cCeeeCff0Ca30CcceC0adC48cD75CdffCabdC17aDc5CaceC0fcC28cD74CeefCff2C985CbdeC8adC58cCffeCcccD53C25aC9ceC3f1C0adCeeeDe2Cff1Cb44D30D40D50D60D70D80D90Da0CcdeC5adC4acCfffD45CabdD73C26bDd8C9dfC4adC39cCeffCaacCb54D20CdeeC7bdD65C89cCfffCdfcC20bC8ceC4e0C09dCeeeCa30CcceC0aeC49cCfffDa8DbaCabdC17cCbceC3f3C38cCeefD76D86D96De6Cdd6C876CceeC9bdC69dCfffDc0CccdC42aC9ceC4f3C19dD94CeeeDa9DdaDeaCff1Ca51CdceC7adC5adCbccC37bCbdfDc7C9adDc6C2aeCeefCbbcC99aCddfC8cdC98dCffdC10bC7cfC5d0C08cCddeCcdeD54C0bdDd4C59cCeffD66CabdD83D93Da3C07bCbdeC29cDd5Cdd4CddeDb6C8beC59dDd7CbbdC06bC9ceC3f2C0adCeefCddeD44C7adC49dDc8CbbdDb9C27bCadfC7acC39cDe8CeffDa6CaacCa95CdeeC7beC7adCffdC8dfC19cD84CdefDb7C940CcceC5beC49cCeffCabdCbceDe7C0ebC38cCff9C5abDe3CcefC9bdC7acCcddC46aC8efC5e1C1adCffeCa52C7bdC5adCbcdC47bCaefC9adC49cD95CceaCd98Db0CdefC8ceC8acC08cCbdeDb8C0adDc4C48cCeffC06bCaceC37cCcdeC9bdDd6C77cCccdC16aC09dC6adCbbdC36bC0fcCabcCd88C79dC8ceC1adDb4C49cD85C9bdC6f8C38cC68bC9bdDb3Dc3CcddC35aC0adCbcdD63C47bC39dCddbC8beC99cC7dfC08dCedeDcaCbdeC0beDe4C48cC06bC28cDb5Cff6CccdD55De9C15cC6beD64C4adDa5C27bCafeC8adC39cCdaaC9bdC8dfC19dC2edC4dbC38cC79bCcffCdddD43C55aDc9C6f2C1adDa4Cba3C7beCbcdC46cC9bcDd3C39dCcfaCd99D10C8cdCa9cDd9CabdC59aC58cC06bCadeCcdeC5aeC4bdDe5C9eaC55a"{
	run("Close All");
	GUI_extract();
	cziNames=getFilteredFileNamesWoExtension(in, ".czi");
	
	//setBatchMode(true); Batch mode is screwing the BioFormat plugin: duplicate extract the same dataset
	for(i=0; i<cziNames.length;i++){
		cziToZip(inDir, lifNames[i], proj, outDir);
	}
	
	outDir=inDir;
}

//--------------------------------------------------------------------------------------------------------------------------
macro " Action Tool - "{

}

//--------------------------------------------------------------------------------------------------------------------------
macro "Single_file Action Tool - N66C000D86D87D88D89D96D97D98D99Da6Da7Da8Da9Db6Db7Db8Db9C00fD08D18D28D39C806D49D4aD5bD5cD6dD6eCf00D7aD7bD8aD8bD8cD8dD8eD9aD9bD9cD9dD9eDaaDabDacDadDaeDbaDbbDbcDbdDbeDc8Dc9DcaDcbDccDcdDceDd7Dd8Dd9DdaDdbDdcDddDdeDe9DeaDebDecDedDeeC0ffCff0C0bbD59D69D78Dc6Dd5C0f0C5ffD0aD0bD0cD0dD0eD1aD1bD1cD1dD1eD2bD2cD2dD2eD3bD3cD3dD3eD4eCf0fD00D01D02D03D04D05D10D11D12D13D14D15D20D21D22D23D24D25D26D30D31D32D33D34D35D36D40D41D42D43D44D45D46D47D50D51D52D53D54D55D56D60D61D62D63D64D65D66D70D71D72D73D74D75D80D81D82D83D84D85D90D91D92D93D94Da0Da1Da2Da3Da4Db0Db1Db2Db3Dc0Dc1Dc2Dc3Dd0Dd1De5Cf90De4C5f8Bf0C000D18D19D1aD1bD28D29D2aD2bD38D39D3aD3bD48D49D4aD4bC00fC806Cf00D0bD0cD0dD0eD1cD1dD1eD2eC0ffCff0C0bbC0f0D35D36D37D43D44D45D46D47D50D51D52D53D54D55D56D57D58D59D5aD5bD60D61D62D63D64D65D66D67D68D69D6aD6bD6cD70D71D72D73D74D75D76D77D78D79D7aD7bD7cD7dD7eD80D81D82D83D84D85D86D87D88D89D8aD8bD8cD8dD8eD90D91D92D93D94D95D96D97D98D99D9aD9bD9cD9dD9eDa0Da1Da2Da3Da4Da5Da6Da7Da8Da9DaaDabDacDadDaeC5ffCf0fD06D07D3cD4dD5eCf90D02D03D10D11C5f8B0fC000D07D08D09D0aD17D18D19D1aD50D51D52D53D60D61D62D63D70D71D72D73D80D81D82D83C00fC806Cf00D00D01D02D03D04D05D06D10D11D12D13D14D15D20D21D22D23D24D25D30D31D32D33D34D42D43D44C0ffD74D84D94Da4Cff0D2aD39D3aD49D4aD58D59D5aD68D69D6aD77D78D79D7aD87D88D89D8aD96D97D98D99D9aDa6Da7Da8Da9DaaC0bbC0f0D90D91D92Da0Da1Da2C5ffCf0fCf90C5f8D27D36D46D55D65Nf0C000D60D61D62D63D70D71D72D73D80D81D82D83D90D91D92D93Dd7Dd8Dd9DdaDe7De8De9DeaC00fC806D84D85D96D97D98Da9DaaCf00Da0Da1Da2Da3Da4Da5Db0Db1Db2Db3Db4Db5Db6Db7Db8Dc0Dc1Dc2Dc3Dc4Dc5Dc6Dc7Dd0Dd1Dd2Dd3Dd4Dd5Dd6De0De1De2De3De4De5De6C0ffCff0C0bbC0f0C5ffD00D01D02D03D04D05D06D07D08D09D0aD10D11D12D13D14D15D16D17D18D19D1aD20D21D22D23D24D25D26D27D28D29D2aD30D31D32D33D34D35D36D37D38D39D3aD40D41D42D43D44D45D46D47D48D49D4aD52D53D54D55D56D57D58D59D5aD65D66D67D68D69D6aD78D79D7aCf0fCf90C5f8DbaDc9"{
	oneFile();
}


//--------------------------------------------------------------------------------------------------------------------------
macro "Multiple_files Action Tool - N66C000D00D01D02D03D04D05D06D07D08D09D0aD0bD0cD0dD0eD10D20D30D40D45D46D47D48D49D4aD4bD4cD4dD4eD50D55D60D64D65D70D75D80D85D8aD8bD8cD8dD8eD90D95D9aDa0Da5Da9DaaDb0Db5DbaDc0Dc5DcaDd0Dd5DdaDe0De5DeaDeeCf0fD11D12D21D22D23D31D32D33D41D42D51D56D57D61D66D67D68D76D77D78D86D87D96D9bD9cDa6DabDacDadDbbDbcDbdDcbDccDdbDebC010C6ffD2aC400C5ccD3bC422Ca8cD26D6bC1f1C8ffCf00C9cdD35D7aC4f4Db3Cf0fD52D97DdcC0f0Dc2Dc3Dd1Dd2Dd3Dd4De1De2De3De4C6ffD29D3cD6eCd00C5ffD17D18D19D1aD1bD1cD1dD1eD2bD2cD2dD2eD3dD3eD5cD5dD5eCd00CbbcD36D7bC3f3Dc1CcffCfddD82Dc7C6abD3aC060Cc00C757Cf3fD62Da7DecC1f1C9ffD28D6dCafdCff0Cf2fD43D88DcdCe00Cc66CdafD14D59D9eCffcCc9bC111C900C444Ca8dD25D6aCcdcDa4De9C8d8Cf1fD13D58D71D9dDb6Cd00Cf33CbbcD44D89DceCcdeCabbD39D7eC0f0Dc4Ca5aCf9fD34D72D79Db7DbeCbffCfc8D91Dd6Cf00Cc7bD37D7cCfafD93Dd8CfffDb1CbebC030Ca00C88fD15D5aCaddD73Db8C7f7Cf11CbadD83Dc8CfbfC7bbC0b0Cb4bD53D98DddCf7fD24D69DaeCaefD27D6cCff1Cc77CefeDa3De8CdabC322Ca45Cf8fD94Dd9CbfcCf99D84Dc9Cf44CcacD38D7dCffeDa1De6CafaDb2C2d2Db4Cb9bD63Da8DedCbffD16D5bCff5Cc8bCfafCfdaD92Dd7C111D54D99DdeC423Cf00C244Cf66CdfeC111C766D74Db9Ce98C787C811C8fdCf22CfcfD81Dc6Cab9C0b0Cff1Cd8aCf99C232CbfdCe66Cff6Ce9aC833C276Ce89Cf56Bf0C000D00D05D0aD10D11D12D13D14D15D1aD25D2aD35D3aD45D4aD55D56D57D58D59D5aD6aD7aD8aD9aD9bD9cD9dD9eCf0fC010C6ffC400C5ccC422Ca8cC1f1C8ffCf00C9cdC4f4D08D4dCf0fC0f0D01D02D03D04D17D18D26D27D28D29D36D37D38D39D46D47D48D49D5cD5dD6bD6cD6dD6eD7bD7cD7dD7eD8bD8cD8dD8eC6ffCd00C5ffCd00CbbcC3f3D16D5bCcffCfddD1cC6abC060Cc00C757Cf3fC1f1C9ffCafdCff0Cf2fCe00Cc66CdafCffcCc9bC111C900C444Ca8dCcdcD3eC8d8Cf1fD0bCd00Cf33CbbcCcdeCabbC0f0D19D5eCa5aCf9fD0cCbffCfc8D2bCf00Cc7bCfafD2dCfffD06D4bCbebC030Ca00C88fCaddD0dC7f7Cf11CbadD1dCfbfC7bbC0b0Cb4bCf7fCaefCff1Cc77CefeD3dCdabC322Ca45Cf8fD2eCbfcCf99D1eCf44CcacCffeD3bCafaD07D4cC2d2D09D4eCb9bCbffCff5Cc8bCfafCfdaD2cC111C423Cf00C244Cf66CdfeC111C766D0eCe98C787C811C8fdCf22CfcfD1bCab9C0b0Cff1Cd8aCf99C232CbfdCe66Cff6Ce9aC833C276Ce89Cf56B0fC000D0aD1aD29D2aD31D3aD41D4aD5aD65D6aD7aD8aD90D91D92D93D94D95D96D97D98D99D9aCf0fC010D40C6ffC400C5ccC422D55Ca8cC1f1D85C8ffCf00D02D03D04D05D06D07D11D12D13D14D15D16D17D23D24D25D26D34D35D36D46C9cdC4f4Cf0fC0f0D60D61D70D71D72D73D80D81D82D83D84C6ffCd00C5ffCd00CbbcC3f3CcffCfddC6abC060D74Cc00C757D54Cf3fC1f1D62C9ffCafdD67Cff0D79D89Cf2fCe00D01D22Cc66D21CdafCffcD49D68Cc9bC111D19C900D18C444Ca8dCcdcC8d8D52Cf1fCd00Cf33D10D37CbbcCcdeCabbC0f0Ca5aD42Cf9fCbffD77Cfc8Cf00D08Cc7bCfafCfffCbebD57C030D75Ca00D00C88fCaddC7f7D63Cf11CbadCfbfD43C7bbC0b0D51Cb4bCf7fCaefCff1D88Cc77D09CefeCdabD20C322Ca45D32Cf8fCbfcD48Cf99Cf44CcacCffeCafaC2d2Cb9bCbffCff5D59Cc8bCfafD53CfdaC111C423Cf00D27C244D66Cf66D44CdfeD58C111D30C766Ce98D47C787D39C811D28C8fdD86Cf22D45CfcfCab9D38C0b0D50Cff1D69Cd8aCf99C232D64CbfdD87Ce66Cff6D78Ce9aC833D56C276D76Ce89Cf56D33Nf0C000D00D01D11D21D31D40D41D42D43D44D45D46D56D66D76D80D81D82D83D84D85D86D87D88D89D8aD9aDaaDbaDc5DcaDd5DdaDe0DeaCf0fC010C6ffD60Da5C400Dd4C5ccD71Db6C422Ca8cDa1C1f1C8ffDc9Cf00De2De3C9cdDb0C4f4Cf0fC0f0C6ffD72Da4Db7Cd00Dd1C5ffD10D20D30D50D51D52D53D54D55D61D62D63D64D65D73D74D75D92D93D94D95D96D97D98D99Da6Da7Da8Da9Db8Db9Cd00De6CbbcDb1C3f3CcffDc8CfddC6abD70Db5C060Cc00De1De5C757Cf3fC1f1C9ffDa3CafdCff0Cf2fCe00Cc66CdafCffcCc9bDd8C111C900C444Dc6Ca8dDa0CcdcC8d8Cf1fCd00De4Cf33CbbcCcdeDc7CabbDb4C0f0Ca5aCf9fCbffCfc8Cf00Cc7bDb2CfafCfffCbebC030Ca00C88fD90CaddC7f7Cf11Dd3CbadCfbfC7bbDc0C0b0Cb4bCf7fCaefDa2Cff1Cc77CefeCdabC322Dc4Ca45Cf8fCbfcCf99Cf44De7CcacDb3Dd9CffeCafaC2d2Cb9bCbffD91Cff5Cc8bDd7CfafCfdaC111Dd0C423Dd6Cf00Dd2C244Cf66CdfeC111C766Ce98C787C811C8fdCf22CfcfCab9C0b0Cff1Cd8aDe9Cf99Dc2C232CbfdCe66Dc1Cff6Ce9aDc3C833C276Ce89De8Cf56"{
	multipleFiles();
}

//--------------------------------------------------------------------------------------------------------------------------
macro "  Action Tool - "{

}

//--------------------------------------------------------------------------------------------------------------------------
macro "ZipIt_&_View Action Tool - N66C000C07aDa1Cfc2CfffC220C7acCfc3C17aD1eD2dD2eD3cD3dD3eD4bD4cD4dD5aD5bD5cD69D6aD6bD78D79D7aD88D89D98Db4Dc3Dc4Dd2Dd3Dd4De1De2De3C17bD74Cfc2Ca81CfeaCfd4C06aD84C17aDb7Cfd2C27aCcddCfd3C48bCfd2DdeDeeCfc1CdedCfd6C179DcbDdaDdbDe9DeaC07bD1aD28D29C17aD9bDaaDabDb9DbaDbbDc7Dc8Dc9DcaDd7Dd8Dd9De6De7De8CacdCfd3D9eDaeDbeDceC38bD0bDb0Cfc1CfecCfe5C17aD4eD5dD6cD7bD8aD8bD99D9aDa4Da8Da9Db8De4De5C17bD19D1bD2aD38D39D47D48D57D73D81Db1C37aCbdeD63D64Cfd4C59bD8cCffdCfe8DadDbdC169DebC17aD0cD1cD1dD2bD2cD3aD3bD49D4aD58D59D68Db2Db3Dc0Dc1Dc2Dd1C971C9bdCfd3C38aCeb1CffbCfd5C07aD91C17aD0dD67D77D87D97Da7Dd0Dd5CcdeCfd3C49cD27Da0CffdCfe7CbddD6eC38bD0eDe0Cfc1CffcCfd5C37aCceeD65Cfd4D8eC7acD9cDacDbcDccDdcCdefD08Cfe9D9dC046D82Da3C750C8bdC27aD5eCc91CfebCfd4CcddC49bD75D95Da5CffcCfe6CacdD76D86D96Da6Db6C38bDc5CcdeD17D62C7acDecCffeCfe8C279C9cdC38bCfc1CcdeD7dC59cCfe8DcdDddDedCbdeD66D80C48bDb5CdeeCffeCfeaD7eC012D92C8bcC18bD37D72CeedCfd6C5acD0aC9cdDc6Cec1CeffD26C057Da2C970C8bdC28aD7cDd6Ceb1Cfd5CbdeD46D56Cfd7C48bD6dCceeD36C6adD71D90Cfe9CacdC39bD85CfffD61C000D93C035D83CffcD8dC058D94C8cdD09C39cD18CfffD70Bf0C000C07aCfc2D5eD6dD7cD8bD9aCfffC220C7acD0cCfc3C17aD01D02D11C17bCfc2DadCa81CfeaD66D76D97Cfd4DabC06aC17aCfd2D3eD4dD4eD5cD5dD6bD6cD7aD7bD88D89D8aD99C27aD33D34D35D36D37CcddD47D48D49Cfd3D3dC48bCfd2D0eD1eD2eD5bD67D68D69D6aD77D78D79Cfc1D6eD7dD7eD8cD8dD8eD9bD9cD9dD9eCdedD4aCfd6DaaC179D08D09D17D18D26D27C07bC17aD05D06D07D14D15D16D23D24D25CacdCfd3C38bCfc1CfecCfe5C17aD03D04D12D13D22C17bC37aD2bCbdeCfd4D98DaeC59bCffdD86Da8Cfe8C169D0aD0bD19D1aD1bD28D29D2aC17aC971C9bdD3bCfd3DacC38aD32Ceb1CffbD56Cfd5D4cD59C07aC17aCcdeD43D44D45Cfd3C49cCffdCfe7D1dCbddC38bCfc1CffcCfd5D57D58C37aD3aCceeD20Cfd4D87C7acCdefCfe9C046C750C8bdD10C27aCc91CfebD4bCfd4D5aCcddD46C49bCffcD3cCfe6D2dCacdC38bCcdeC7acCffeCfe8C279D38D39C9cdD31C38bCfc1CcdeD2cC59cD00Cfe8D0dCbdeC48bCdeeD42CffeCfeaC012C8bcD1cC18bCeedCfd6C5acC9cdCec1CeffC057C970C8bdC28aD21Ceb1Cfd5CbdeCfd7C48bCceeC6adCfe9Da9CacdC39bCfffC000C035CffcC058C8cdC39cCfffB0fC000D17C07aCfc2D22D31D33D40D43D53D73CfffD3aD49C220D18C7acCfc3C17aC17bCfc2Ca81D08CfeaCfd4D0aD83C06aC17aCfd2D02D11D12D20D21D30C27aCcddCfd3C48bCfd2D00D01D03D10D13D23Cfc1D32D36D37D38D41D42D50D51D52D60D61D62D63D70D71D80CdedCfd6C179C07bC17aCacdCfd3C38bCfc1D72D81D90D91CfecCfe5C17aC17bC37aCbdeCfd4D92C59bCffdCfe8C169C17aC971D07C9bdCfd3C38aCeb1D26CffbD04D14D24D34D46D47Cfd5D05D15C07aC17aCcdeCfd3C49cCffdCfe7CbddC38bCfc1D29CffcD44D48D54D64Cfd5Da0C37aCceeCfd4C7acCdefCfe9C046C750D27C8bdC27aCc91D16CfebD2aCfd4CcddC49bCffcD45D74D93Cfe6CacdC38bCcdeC7acCffeDa2Cfe8C279C9cdC38bCfc1D09D82CcdeC59cCfe8CbdeC48bCdeeCffeD84CfeaC012C8bcC18bCeedCfd6D1aC5acC9cdCec1D06CeffC057C970D28C8bdC28aCeb1D19Cfd5D25D35CbdeCfd7D39C48bCceeC6adCfe9Da1CacdC39bCfffC000C035CffcC058C8cdC39cCfffNf0C000C07aCfc2Da9Db8Db9Dc7Dc8Dd6Dd7DdaDe6CfffC220C7acCfc3DcaC17aD10D11D20C17bCfc2Ca81CfeaCfd4DbaC06aC17aCfd2D98D99Da7Da8Db6Db7Dc6C27aCcddCfd3D89DeaC48bD51D52D53Cfd2D85D86D87D88D94D95D96D97Da3Da4Da5Da6Db2Db3Db4Db5Dc0Dc1Dc2Dc3Dc5Dd0Dd1Dd2De0De1De2Cfc1Dc9Dd8Dd9De7De8De9CdedCfd6C179C07bC17aD32D33D41D42D43CacdD34Cfd3D75D80D81D82D83D90D91D92Da0Da1Db0C38bCfc1CfecD61D62D63Cfe5D70C17aD21D22D30D31D40C17bC37aCbdeCfd4Dc4C59bCffdD68Cfe8C169C17aC971C9bdCfd3D76D77D84D93Da2Db1Dd3De3C38aD23Ceb1CffbDe4Cfd5Dd5De5C07aC17aCcdeCfd3D71D72D73D74C49cCffdD8aCfe7CbddC38bCfc1CffcD64D65D66D67Cfd5DaaC37aCceeCfd4D78C7acCdefCfe9C046C750C8bdC27aCc91CfebDd4Cfd4CcddC49bCffcCfe6CacdC38bD50CcdeC7acCffeCfe8D9aC279C9cdC38bD12Cfc1CcdeC59cD00Cfe8CbdeD54C48bCdeeD02D24CffeCfeaD79C012C8bcC18bCeedD60Cfd6C5acC9cdCec1CeffC057C970C8bdD01C28aCeb1Cfd5CbdeCfd7C48bCceeC6adCfe9CacdD13D44C39bCfffC000C035CffcC058C8cdC39cCfff"{
	checkForPlugin("Zip it", "Zip It", "https://github.com/fabricecordelieres/IJ-Plugin_Zip-It/releases/download/v1.0/Zip_It.jar");

	zipIt(outDir);
	
	//Launch the colab script
	showMessage("Next step: data compilation with Python", "A web browser window will pop-up\nwith the Google Colab script to compile the data:\nfollow the instructions.");
	exec("open", "https://colab.research.google.com/github/fabricecordelieres/IJ-Toolset_Root-Photoactivation-Analysis/blob/main/Python_Script/Colab_Root_Photoactivation_Analysis.ipynb");
}
	
//******************************* Generate the projections from raw data *******************************
//-------------------------------------------------------
function GUI_extract(){
	Dialog.create("Data projection");
	Dialog.addDirectory("Where_are_the_files_?", "");
	Dialog.addDirectory("Where_to_save_projections_?", "");
	Dialog.addChoice("Projection_type", projMeth, proj);
	
	Dialog.show();
	
	inDir=Dialog.getString()+File.separator;
	outDir=Dialog.getString()+File.separator;
	
	if(!endsWith(inDir, File.separator)){
		inDir+=File.separator;
	}
	
	if(!endsWith(outDir, File.separator)){
			outDir+=File.separator;
		}
	
	proj=Dialog.getString();
}

//-------------------------------------------------------
function cziToZip(in, fileName, proj, out){
	run("Bio-Formats Macro Extensions"); 

	Ext.setId(in+File.separator+fileName+".czi");
	Ext.getSeriesCount(seriesCount);

	for(i=0; i<seriesCount; i++){
		Ext.setSeries(i);

		Ext.getSeriesName(seriesName);

		run("Bio-Formats Importer", "open=["+in+fileName+".czi] autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_"+(i+1));
		name=substring(seriesName, 0, lastIndexOf(seriesName, "/"));
			
		run("Z Project...", "projection=["+proj+"]");
		saveAs("ZIP", out+fileName+"-"+name+"_"+proj+".zip");
			
		run("Close All");

		call("java.lang.System.gc");
	}
	Ext.close();
}

//-------------------------------------------------------
function getFilteredFileNamesWoExtension(folder, ext){
	fileNames=getFileList(folder);
	for(i=0; i<fileNames.length; i++){
		if(!endsWith(fileNames[i], ext)){
			fileNames=Array.deleteIndex(fileNames, i);
			i--;
		}else{
			fileNames[i]=replace(fileNames[i], ext, "");
		}
	}
	return fileNames;
}

//******************************* Process a single file *******************************
//--------------------------------------------------------------------------------------------------------------------------
function oneFile(){
	roiManager("Reset");
	
	GUI(false);
	processSingleFile();
}

//******************************* Batch process files *******************************
//--------------------------------------------------------------------------------------------------------------------------
function multipleFiles(){
	cleanup(false);
	run("Close All");
	
	GUI(true);
	files=getFileList(inDir);
	setBatchMode(true);
	for(i=0; i<files.length; i++){
		if(!File.isDirectory(inDir+files[i])){
			cleanup(false);
			open(inDir+files[i]);
			processSingleFile();
		}
	}
	run("Close All");
}

//--------------------------------------------------------------------------------------------------------------------------
function GUI(batch){
	Dialog.create("Cells, walls and PDs");
	if(batch){
		Dialog.addDirectory("Input_folder", inDir);
	}
	Dialog.addDirectory("Output_folder", outDir);
	Dialog.addMessage("---- Preprocess walls ----");
	Dialog.addCheckbox("Use_cellpose_segmentation", useCellpose);
	
	Dialog.addMessage("---- Preprocess walls using Cellpose ----");
	Dialog.addChoice("Model_to_use", models, model);
	Dialog.addNumber("Expected_cell_diameter", cellDiameter);
	Dialog.addNumber("Flow_threshold", flowThr);
	Dialog.addNumber("Cell_probability_threshold", cellProbThr);
	
	Dialog.addMessage("---- Preprocess walls using regular method ----");
	Dialog.addNumber("Gamma", gamma);
	Dialog.addNumber("Subtract_background_radius_(pixels)", subBkgdWalls);
	Dialog.addNumber("CLAHE_block_Size_(pixels)", blockSize);
	Dialog.addNumber("Median_filter_radius_(pixels)", medRad);
	Dialog.addNumber("Gaussian_filter_radius_(pixels)", gaussRad);
	Dialog.addNumber("Opening:_nb_iterations", openItWalls);
	Dialog.addNumber("Opening:_count", openCountWalls);

	Dialog.addMessage("---- Preprocess PDs ----");
	Dialog.addNumber("Subtract_background_radius_(pixels)", subBkgdPDs);
	Dialog.addNumber("ROI_enlargement_(pixels)", enlargePDs);

	Dialog.addMessage("---- Isolate cells ----");
	Dialog.addNumber("Max_filter_radius_(pixels)", maxRad);
	Dialog.addNumber("Min_filter_radius_(pixels)", minRad);
	Dialog.addNumber("Max_cell_size_(pixels)", maxSize);
	
	Dialog.addMessage("---- Isolate walls ----");
	Dialog.addNumber("ROI_enlargement_(pixels)", enlargeWalls);

	Dialog.addMessage("---- Isolate PDs ----");
	Dialog.addNumber("Prominence_for_maxima_detection", prominence);
	Dialog.addNumber("ROI_enlargement_(pixels)", radMeasure);

	Dialog.addMessage("---- Find parents ----");
	Dialog.addNumber("PDs:_Search_radius_(pixels)", radPDs);
	Dialog.addNumber("Junction_points:_Search_radius_(pixels)", radJPs);
	Dialog.addNumber("Walls:_Search_radius_(pixels)", radWalls);

	Dialog.show();

//---------------------------------------------------
	//Batch
	if(batch){
		inDir=Dialog.getString();
		if(!endsWith(inDir, File.separator)){
			inDir+=File.separator;
		}
	}
	
	outDir=Dialog.getString();
	if(!endsWith(outDir, File.separator)){
		outDir+=File.separator;
	}
	
	//Preprocess Walls
	useCellpose=Dialog.getCheckbox();
	model=Dialog.getChoice();
	cellDiameter=Dialog.getNumber();
	flowThr=Dialog.getNumber();
	cellProbThr=Dialog.getNumber();
	
	gamma=Dialog.getNumber();
	subBkgdWalls=Dialog.getNumber();
	blockSize=Dialog.getNumber();
	medRad=Dialog.getNumber();
	gaussRad=Dialog.getNumber();
	openItWalls=Dialog.getNumber();
	openCountWalls=Dialog.getNumber();
	
	//Preprocess PDs
	subBkgdPDs=Dialog.getNumber();
	enlargePDs=Dialog.getNumber();
	
	//Isolate cells
	maxRad=Dialog.getNumber();
	minRad=Dialog.getNumber();
	maxSize=Dialog.getNumber();
	
	//Isolate walls
	enlargeWalls=Dialog.getNumber();
	
	//Isolate PDs
	prominence=Dialog.getNumber();
	radMeasure=Dialog.getNumber();
	
	//Find parents
	radPDs=Dialog.getNumber();
	radJPs=Dialog.getNumber();
	radWalls=Dialog.getNumber();	
}

//--------------------------------------------------------------------------------------------------------------------------
function cleanup(closeLog){
	roiManager("Reset");
	run("Options...", "iterations=1 count=6 pad");
	
	//Close ALL windows
	img=getList("image.titles");
	win=getList("window.titles");
	windows=Array.concat(img, win);
	for(i=0; i<windows.length; i++){
		if(!closeLog && windows[i]!="Log"){
			closeNonImageWindow(windows[i]);
		}
	}
}

//--------------------------------------------------------------------------------------------------------------------------
function processSingleFile(){
	setBatchMode(true);
	
	ori=getTitle();
	
	print("---------------- Processing "+ori+" ----------------");
	start=getTime();
	print(getFormattedDateAndTime()+": Start time");
	roiManager("Show None");
	print(getFormattedDateAndTime()+": Pre-processing walls");
	preprocessWalls(chWalls, gamma, subBkgdWalls, blockSize, medRad, gaussRad, openItWalls, openCountWalls);
	print(getFormattedDateAndTime()+": Finding junction points");
	find3Points("Ori_Walls");
	print(getFormattedDateAndTime()+": Isolating walls");
	isolateWalls("Ori_Walls", enlargeWalls);
	print(getFormattedDateAndTime()+": Isolating cells");
	isolateCells("Ori_Walls", maxRad, minRad, maxSize);
	print(getFormattedDateAndTime()+": Pre-processing PDs");
	preprocessPDs(ori, chPDs, subBkgdPDs, enlargePDs);
	print(getFormattedDateAndTime()+": Isolating PDs");
	isolatePDs("Ori_PDs", prominence, radMeasure);
	
	print(getFormattedDateAndTime()+": Finding parent walls for PDs");
	getParents("Tagged_Walls", "PDs", radPDs, "ID_Parent_Wall", 1);
	print(getFormattedDateAndTime()+": Finding parent walls for junction points");
	getParents("Tagged_Walls", "Junction_points", radJPs, "ID_Parent_Wall", 3);
	print(getFormattedDateAndTime()+": Finding parent cells for walls");
	getParents("Tagged_Cells", "Walls", radWalls, "ID_Parent_Cell", 2);
	
	selectWindow(ori);
	print(getFormattedDateAndTime()+": Generating JSON file content");
	metadataJSON=exportMetadataToJSON();
	
	cellsJSON=tableToJSON("Cells");
	wallsJSON=tableToJSON("Walls");
	junctionPointsJSON=tableToJSON("Junction_points");
	PDsJSON=tableToJSON("PDs");
	
	JSONout="{"+exportParametersToJSON()+",\n"+metadataJSON+",\n"+cellsJSON+",\n"+wallsJSON+",\n"+junctionPointsJSON+",\n"+PDsJSON+"}";
	
	print(getFormattedDateAndTime()+": Saving all outputs");
	saveData(JSONout);
	
	print(getFormattedDateAndTime()+": End time");
	
	deltaTime=getTime()-start;
	min=floor(deltaTime/60000);
	mmss=IJ.pad(min, 2)+":"+IJ.pad(floor(deltaTime/1000-min*60), 2);
	print("---------------- Done processing in "+mmss+" ----------------");
	print("");
	
	setBatchMode("exit and display");
}


//--------------------------------------------------------------------------------------------------------------------------
function preprocessWalls(chWalls, gamma, subBkgd, blockSize, medRad, gaussRad, openItWalls, openCountWalls){
	close("\\Others");
	run("Select None");
	
	//Skeleton
	run("Duplicate...", "title=Ori_Walls duplicate channels="+chWalls);
	run("Duplicate...", "title=Skeleton duplicate channels="+chWalls);
	run("Gamma...", "value="+gamma);
	run("Enhance Local Contrast (CLAHE)", "blocksize="+blockSize+" histogram=256 maximum=3 mask=*None* fast_(less_accurate)");
	run("Subtract Background...", "rolling="+subBkgd);
	run("Median...", "radius="+medRad);
	run("Duplicate...", "title=Blur");
	run("Gaussian Blur...", "sigma="+gaussRad);
	imageCalculator("Divide 32-bit", "Skeleton","Blur");
	close("Blur");
	run("Enhance Contrast", "saturated=0.35");
	setOption("ScaleConversions", true);
	run("8-bit");
	setAutoThreshold("Huang");
	setOption("BlackBackground", false);
	run("Convert to Mask");
	run("Fill Holes");
	run("Options...", "iterations="+openItWalls+" count="+openCountWalls+" pad do=Open");
	run("Invert");
	run("Skeletonize");
	close("Skeleton");
	rename("Skeleton");
}

//--------------------------------------------------------------------------------------------------------------------------
function getWallsFromCellPose(){
	run("Find Edges");
	getStatistics(area, mean, min, max, std, histogram);
	setThreshold(1.0000, max);
	setOption("BlackBackground", true);
	run("Convert to Mask");
	run("Skeletonize");
	run("Invert LUT");
	rename("Skeleton");
}

//--------------------------------------------------------------------------------------------------------------------------
function preprocessPDs(ori, chPDs, subBkgd, enlargePDs){
	selectWindow(ori);
	run("Select None");
	
	run("Duplicate...", "title=Ori_PDs duplicate channels="+chPDs);
	run("Duplicate...", "title=Detection_PDs");
	
	run("Subtract Background...", "rolling="+subBkgd);
	selectWindow("Tagged_Walls");
	setThreshold(0, 0);
	run("Create Selection");
	run("Make Inverse");
	run("Enlarge...", "enlarge="+enlargePDs+" pixel");
	resetThreshold;
	selectWindow("Detection_PDs");
	run("Restore Selection");
	
	setBackgroundColor(0, 0, 0);
	run("Clear Outside");
	run("Grays");
	Roi.setStrokeColor("Green");
	run("Add Selection...");
	run("Median...", "radius=1");
	
	//Normalize
	getStatistics(area, mean, min, max, std, histogram);
	run("32-bit");
	run("Subtract...", "value="+mean);
	run("Divide...", "value="+std);
	
	run("Enhance Contrast", "saturated=0.35");
}


//--------------------------------------------------------------------------------------------------------------------------
function find3Points(image){
	//Find and clean 3 points
	run("Duplicate...", "title=3_points");
	run("Options...", "iterations=1 count=6 pad do=Erode");
	run("Find Maxima...", "prominence=1 light output=[Single Points]");
	
	getTaggedMap(255, 0, "Infinity", "Tagged_junction_points");
	roiToTable(image, "Junction_points", true, -1, false);
	
	close("3_points*");
}

//--------------------------------------------------------------------------------------------------------------------------
function isolateWalls(image, enlargeWalls){
	selectWindow("Junction_points");
	xpoints=Table.getColumn("X_pix");
	ypoints=Table.getColumn("Y_pix");
	
	//Walls tagging
	selectWindow("Skeleton");
	run("Duplicate...", "title=Walls_Raw");
	makeSelection("point", xpoints, ypoints);
	run("Enlarge...", "enlarge="+enlargeWalls+" pixel");
	
	setBackgroundColor(255, 255, 255);
	run("Clear", "slice");
	getTaggedMap(255, 0, "Infinity", "Tagged_Walls");
	roiToTable(image, "Walls", false, -1, true);
	close("Walls_Raw");
}

//--------------------------------------------------------------------------------------------------------------------------
function isolateCells(image, maxRad, minRad, maxSize){
	selectWindow("Tagged_Walls");
	run("Select None");
	run("Duplicate...", "title=Cells_Raw");
	run("Maximum...", "radius="+maxRad);
	run("Minimum...", "radius="+minRad);
	
	getTaggedMap(0, 0, maxSize, "Tagged_Cells");
	roiToTable(image, "Cells", false, -1, false);
	close("Cells_Raw");
}

//--------------------------------------------------------------------------------------------------------------------------
function isolatePDs(image, prominence, radMeasure){
	selectWindow("Detection_PDs");	
	run("Select None");
	run("Find Maxima...", "prominence="+prominence+" output=[Single Points]");
	
	getTaggedMap(255, 0, "Infinity", "Tagged_PDs");
	roiToTable(image, "PDs", true, radMeasure, false);
	close("Detection*");
}

//--------------------------------------------------------------------------------------------------------------------------
function getTaggedMap(thr, minSize, maxSize, name){
	run("Select None");
	setThreshold(thr, thr);
	roiManager("Reset");
	run("Clear Results");
	run("Analyze Particles...", "size="+minSize+"-"+maxSize+" pixel show=[Count Masks] add");
	run("From ROI Manager");
	roiManager("Show All without labels");
	
	rename(name);
	run("glasbey on dark");
	resetMinAndMax();
}

//--------------------------------------------------------------------------------------------------------------------------
function roiToTable(image, tableName, logOnlyCentralCoord, enlargeToMeasure, logLength){
	selectWindow(image);
	getPixelSize(unit, pixelWidth, pixelHeight);
	nRois=roiManager("Count");
	Table.create(tableName);
	for(i=0; i<nRois; i++){
		roiManager("Select", i);
		getSelectionCoordinates(xpoints, ypoints);
		Table.set("ID", i, i+1);
		if(logOnlyCentralCoord){
			List.setMeasurements;
			Table.set("X_pix", i, (List.get("X"))/pixelWidth);
			Table.set("Y_pix", i, (List.get("Y"))/pixelHeight);
		}else{
			Table.set("X_pix", i, String.join(xpoints));
			Table.set("Y_pix", i, String.join(ypoints));
			
		}
		if(enlargeToMeasure!=-1){
			run("Enlarge...", "enlarge="+enlargeToMeasure+" pixel");
		}
		List.setMeasurements;
		Table.set("XCenter_pix", i, (List.get("X"))/pixelWidth);
		Table.set("YCenter_pix", i, (List.get("Y"))/pixelHeight);
		Table.set("Area_unit2", i, List.get("Area"));
		Table.set("Mean_Intensity", i, List.get("Mean"));
		Table.set("Total_Intensity", i, List.get("RawIntDen"));	
		
		if(logLength){
			Table.set("Length_unit", i, (List.get("Perim."))/2);
		}
		
	}
	Table.update;
}

//--------------------------------------------------------------------------------------------------------------------------
function getParents(img, table, enlarge, basename, nParents){
	selectWindow(table);
	x=Table.getColumn("XCenter_pix");
	y=Table.getColumn("YCenter_pix");
	
	parents=newArray(x.length);
	
	for(i=0; i<x.length; i++){
		selectWindow(img);
		makePoint(x[i], y[i]);
		run("Enlarge...", "enlarge="+enlarge+" pixel");
		tmp=getNTags(nParents);
		//Trick to get an coma separated value even with a 1 cell array
		if(tmp.length!=1){
			parents[i]=String.join(tmp);
		}else{
			parents[i]=tmp[0];
		}
	}
	
	for(i=0; i<parents.length; i++){
		selectWindow(table);
		if(nParents!=1){
			tags=split(parents[i], ",");
			
			for(j=0; j<tags.length; j++){
				nameParent=basename+"_"+(j+1);
				Table.set(nameParent, i, tags[j]);
			}
		}else{
			Table.set(basename, i, parents[i]);
		}
	}
	Table.update;
}


//--------------------------------------------------------------------------------------------------------------------------
function getNTags(nTags){
	getRawStatistics(nPixels, mean, min, max, std, histogram); //required to get the full 16-bit histogram
	tags=newArray(nTags);
	index=0;
	for(i=1; i<histogram.length; i++){ //Start at 1 to avoid having the 0
		if(histogram[i]!=0){
			tags[index]=i;
			index++;
		}
		if(index==nTags){
			break;
		}
	}
	return tags;	
}

//--------------------------------------------------------------------------------------------------------------------------
function tableToJSON(table){
	selectWindow(table);
	headings=split(Table.headings, "\t");
	out="\""+table+"\": [\n";
	
	for(i=0; i<Table.size; i++){
		out+="\t{\n";
		for(j=0; j<headings.length; j++){
			if(indexOf(headings[j], "X")==-1){
				data=Table.get(headings[j], i);
				out+="\t\t\""+headings[j]+"\": "+data;
			}else{
				xpoints=split(Table.getString(headings[j], i), ", ");
				ypoints=split(Table.getString(headings[j+1], i), ", ");
				data=stringToCoordinates(xpoints, ypoints);
				
				dataType="Center";
				if(indexOf(headings[j], "Center")==-1){
					dataType="Roi";
				}
				
				out+="\t\t\""+dataType+"\": "+data;
				j++;
			}
			if(j!=headings.length-1){
				out+=",";
			}
			out+="\n";
		}
		out+="\t}";
		if(i!=Table.size-1){
			out+=",";
		}
		out+="\n";
	}
	
	out+="]";
	
	return out;
}

//--------------------------------------------------------------------------------------------------------------------------
function exportMetadataToJSON(){
	metadata=split(getImageInfo(), "\n");
	out="\"Metadata\": {\n";
	
	index=0;
	
	for(i=0; i<metadata.length; i++){
		line=split(metadata[i], "=");
		
		if(line.length==2){
			if(index!=0){
				out+=",\n";
			}
			//Sanitize the metadata's keys
			line[0]=String.trim(line[0]); //Removes leadin/trailing spaces
			line[0]=replace(replace(replace(line[0], "|", "_"), " ", "_"), "#", "_"); //Replaces pipes, spaces and # by underscores
			
			out+="\t\""+line[0]+"\": ";
			line[1]=String.trim(line[1]); //Removes leadin/trailing spaces
			line[1]=replace(line[1], "\\", "\\\\"); //Escape specific characters
			
			//check content
			isText=isNaN(parseFloat(line[1]));
			if(isText){
				line[1]="\""+line[1]+"\"";
			}
			out+=line[1];
			index++;
		}
	}
	
	out+="\n}";
	
	return out;
}

//--------------------------------------------------------------------------------------------------------------------------
function exportParametersToJSON(){
	out="\"Parameters\": {\n";
	
	out+="\t\"macroVersion\": "+version+",\n";
	
	getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
	dateTime="\""+year+"-"+IJ.pad(month+1, 2)+"-"+IJ.pad(dayOfMonth, 2)+" "+IJ.pad(hour, 2)+":"+IJ.pad(minute, 2)+":"+IJ.pad(second, 2)+"\"";

	out+="\t\"DateTime\": "+dateTime+",\n";
	out+="\t\"batch\": "+batch+",\n";
	
	//Batch
	if(batch){
		out+="\t\"inDir\": "+inDir+",\n";
		out+="\t\"outDir\": "+outDir+",\n";
	}
	
	//Preprocess Walls
	out+="\t\"useCellpose\": "+useCellpose+",\n";
	
	out+="\t\"model\": "+model+",\n";
	out+="\t\"cellDiameter\": "+cellDiameter+",\n";
	out+="\t\"flowThr\": "+flowThr+",\n";
	out+="\t\"cellProbThr\": "+cellProbThr+",\n";
	
	out+="\t\"gamma\": "+gamma+",\n";
	out+="\t\"subBkgdWalls\": "+subBkgdWalls+",\n";
	out+="\t\"blockSize\": "+blockSize+",\n";
	out+="\t\"medRad\": "+medRad+",\n";
	out+="\t\"gaussRad\": "+gaussRad+",\n";
	out+="\t\"openItWalls\": "+openItWalls+",\n";
	out+="\t\"openCountWalls\": "+openCountWalls+",\n";
	
	//Preprocess PDs
	out+="\t\"subBkgdPDs\": "+subBkgdPDs+",\n";
	out+="\t\"enlargePDs\": "+enlargePDs+",\n";
	
	//Isolate cells
	out+="\t\"maxRad\": "+maxRad+",\n";
	out+="\t\"minRad\": "+minRad+",\n";
	out+="\t\"maxSize\": "+maxSize+",\n";
	
	//Isolate walls
	out+="\t\"enlargeWalls\": "+enlargeWalls+",\n";
	
	//Isolate PDs
	out+="\t\"prominence\": "+prominence+",\n";
	out+="\t\"radMeasure\": "+radMeasure+",\n";
	
	//Find parents
	out+="\t\"radPDs\": "+radPDs+",\n";
	out+="\t\"radJPs\": "+radJPs+",\n";
	out+="\t\"radWalls\": "+radWalls;
	
	
	out+="\n}";
	
	return out;
}

//--------------------------------------------------------------------------------------------------------------------------
function stringToCoordinates(xpoints, ypoints){
	out="\t\t\t{\n\t\t\t\t\"type\": ";
	type="Polygon";
	if(xpoints.length==1){
		type="Point";
	}
	out+="\""+type+"\",\n\t\t\t\t\"coordinates\": [\n\t\t\t\t[\n\t\t\t\t\t";
	for(i=0; i<xpoints.length; i++){
		out+="["+xpoints[i]+", "+ypoints[i]+"]";
		if(i!=xpoints.length-1){
			out+=", ";
		}
	}
	out+="\n\t\t\t\t]\n\t\t\t]\n\t\t\t}";
	
	return out;
}

//--------------------------------------------------------------------------------------------------------------------------
function saveData(JSONContent){
	img=substring(ori, 0, lastIndexOf(ori, "."));
	out=outDir+img+File.separator;
	
	dirPng=out+"png"+File.separator;
	dirComposite=out+"composite"+File.separator;
	dirCSV=out+"CSV"+File.separator;
	dirJSON=out+"JSON"+File.separator;
	
	tmp=File.makeDirectory(out);
	tmp=File.makeDirectory(dirPng);
	tmp=File.makeDirectory(dirComposite);
	tmp=File.makeDirectory(dirCSV);
	tmp=File.makeDirectory(dirJSON);
	
	selectWindow("Skeleton");
	run("Grays");
	run("16-bit");
	
	imgs=newArray("Ori_Walls", "Ori_PDs", "Skeleton", "Tagged_junction_points", "Tagged_Walls", "Tagged_PDs", "Tagged_Cells");
	tables=newArray("Junction_points", "Walls", "PDs", "Cells");
	
	//Save quick review data
	for(i=0; i<imgs.length; i++){
		selectWindow(imgs[i]);
		run("Select None");
		
		//Improved contrast for "Ori_*" jpg
		if(indexOf(imgs[i], "Ori")!=-1){
			run("Duplicate...", " ");
			run("Grays");
			resetMinAndMax();
			run("Enhance Contrast", "saturated=0.35");
			setOption("ScaleConversions", true);
			run("8-bit");
		}
		run("Remove Overlay");
		roiManager("Show None");
		if(indexOf(imgs[i], "Tagged")!=-1){
			run("glasbey on dark");
		}
		saveAs("PNG", dirPng+imgs[i]+".png");
		
		if(indexOf(imgs[i], "Ori")!=-1){
			close();
		}
		rename(imgs[i]);
	}
	
	//Save original composites
	arg="";
	for(i=0; i<imgs.length; i++){
		arg+="c"+(i+1)+"="+imgs[i]+" ";
	}
	
	run("Merge Channels...", arg+"create keep");
	
	for(i=0; i<imgs.length; i++){
		Stack.setChannel(i+1);
		setMetadata("Label", imgs[i]);
	}
	Stack.setDisplayMode("color");
	Stack.setChannel(1);
	
	saveAs("Tiff", dirComposite+"Raw_Composite.tif");
	close();
	
	//Save easy to visualize composites
	for(i=2; i<imgs.length-1; i++){
		selectWindow(imgs[i]);
		run("Select None");
		run("Maximum...", "radius="+enlargePDs); //To visualize, une the PDs enlargment parameter
	}
	
	run("Merge Channels...", arg+"create");
	
	for(i=0; i<imgs.length; i++){
		Stack.setChannel(i+1);
		setMetadata("Label", imgs[i]);
	}
	Stack.setDisplayMode("composite");
	Stack.setActiveChannels("0000011");
	
	saveAs("Tiff", dirComposite+"Dilated_Composite.tif");
	close();
	
	//Save tables
	for(i=0; i<tables.length; i++){
		selectWindow(tables[i]);
		saveAs("Results", dirCSV+tables[i]+".csv");
		if(tables[i]=="Walls"){
			exportWallTableForModeling();
			saveAs("Results", dirCSV+tables[i]+"_Modeling.csv");
		}
		run("Close");
	}
	
	//Save JSON
	File.saveString(JSONContent, dirJSON+"data.txt"); //Can't save directly as JSON
	tmp=File.rename(dirJSON+"data.txt", dirJSON+"data.json");
	run("Close");
}

//--------------------------------------------------------------------------------------------------------------------------
function exportWallTableForModeling(){
	colToRemove=newArray("ID", "X_pix", "Y_pix", "XCenter_pix", "YCenter_pix", "Area_unit2", "Mean_Intensity");
	for(i=0; i<colToRemove.length; i++){
		Table.deleteColumn(colToRemove[i]);
	}
	Table.update;
}

//--------------------------------------------------------------------------------------------------------------------------
function closeNonImageWindow(window){
	list=getList("window.titles");
	for(i=0; i<list.length; i++){
		if(list[i]==window){
			selectWindow(window);
			run("Close");
			break;
		}
	}
}

//--------------------------------------------------------------------------------------------------------------------------
function getFormattedDateAndTime(){
	getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
	dateTime=""+year+"-"+IJ.pad(month+1, 2)+"-"+IJ.pad(dayOfMonth, 2)+" "+IJ.pad(hour, 2)+":"+IJ.pad(minute, 2)+":"+IJ.pad(second, 2);
	return dateTime;
}

//******************************* Zip extracted data to upload and review with Colab *******************************
//----------------------------------------------------------------------
function GUI_ZipIt(){
	Dialog.create("Zip and launch visualisation");
	Dialog.addDirectory("Where is the extracted data ?", out);
	Dialog.show();
	
	out=Dialog.getString();
	if(!endsWith(out, File.separator)){
		out+=File.separator;
	}
}

//----------------------------------------------------------------------
function zipIt(out){
	subDirs=getDirList(out, "DataToZip");
	dataToZipPath=out+"DataToZip"+File.separator;
	tmp=File.makeDirectory(dataToZipPath);
	
	for(i=0; i<subDirs.length; i++){
		tmp=File.makeDirectory(dataToZipPath+subDirs[i]);
		tmp=File.copy(out+subDirs[i]+"png"+File.separator+"Ori_PDs.png", dataToZipPath+subDirs[i]+"Ori_PDs.png");
		tmp=File.copy(out+subDirs[i]+"png"+File.separator+"Ori_Walls.png", dataToZipPath+subDirs[i]+"Ori_Walls.png");
		tmp=File.copy(out+subDirs[i]+"JSON"+File.separator+"data.json", dataToZipPath+subDirs[i]+"data.json");
	}
	
	run("Zip it", "input_folder=["+dataToZipPath+"] output_folder=["+out+"] zip_filename=dataToUpload.zip remove_input_folder");
}

//----------------------------------------------------------------------
function getDirList(in, excludeThis){
	list=getFileList(in);
	for(i=0; i<list.length;i++){
		if(!File.isDirectory(in+list[i]) || list[i]==excludeThis){
			list=Array.deleteIndex(list, list[i]);
		}
	}
	return list;
}

//----------------------------------------------------------------------
function checkForPlugin(menuName, pluginName, URL){
	List.setCommands;
	if(List.get(menuName)==""){
		waitForUser("The "+pluginName+" plugin is missing\nand will be downloaded.\nIn the next window, simply\nclick on \"Save\" button to install it.");
		open(URL);
		showStatus(pluginName+" downloaded");
	}else{
		showStatus("Check for "+pluginName+" passed");
	}
}
