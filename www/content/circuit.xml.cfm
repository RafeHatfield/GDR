<?xml version="1.0" encoding="UTF-8"?>
<circuit access="public">

	<fuseaction name="display">

		<do action="v_content.displayContent" contentVariable="content.mainContent" append="yes" />

	</fuseaction>

	<fuseaction name="showImage">

		<set name="attributes.displayMode" value="noNav" overwrite="yes" />

		<invoke object="application.imageObj" methodcall="getImageByID(img_id)" returnVariable="qImage" />

		<do action="v_content.showImage" contentVariable="content.mainContent" append="yes" />

	</fuseaction>

</circuit>