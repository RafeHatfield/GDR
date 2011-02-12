<?php
	require_once("../../includes/general.php");
	require_once("../../classes/ManagerEngine.php");

	// Get input
	$returnURL = getRequestParam('return_url', '');
	$path = getRequestParam('path', '');
	$rootpath = getRequestParam('rootpath', '');
	$user = getRequestParam('user', '');
	$key = getRequestParam('key');

	// Setup mananager
	$man =& new Moxiecode_ManagerEngine($type);
	require_once($basepath . "CorePlugin.php");
	require_once("../../config.php");

	// Pre init and grab config
	$man->dispatchEvent("onPreInit", array($type));
	$config =& $man->getConfig();

	// Change this to match the one in config.php
	$secretKey = "someSecretKey";

	// Is the hash correct
	if ($key == MD5($returnURL . $path . $rootpath . $user . $secretKey)) {
		@session_start();
		$_SESSION['mcmanager_ext_auth'] = true;
		$_SESSION['mcmanager_ext_path'] = $path;
		$_SESSION['mcmanager_ext_rootpath'] = $rootpath;

		header('location: ' . $returnURL);
	} else {
		sleep(1); // Prevent bots from trying
		die('Error: Invalid hash verify that the secret keys match up.');
	}
?>