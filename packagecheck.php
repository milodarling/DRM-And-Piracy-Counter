<?php
//get this info from Cydia connect
$vendor = "lamo";
$secret_key = "lamo1234";

//create a URL-safe base64 encoded string (for Cydia Store API)
function urlsafe_b64encode($string) {
    return str_replace(array('+','/','='), array('-','_',''), base64_encode($string));
}

//from http://test.saurik.com/cydia-packagers/refindex5.php.txt
function cydia_($url, $dict, $key) {
    ksort($dict);
    $query = http_build_query($dict);
    $response = file_get_contents("$url?$query&signature=" . urlsafe_b64encode(hash_hmac("sha1", $query, $key, true)));
    $values = array();
    parse_str($response, $values);
    return $values;
}
//from http://test.saurik.com/cydia-packagers/refindex5.php.txt
function cydia_check($vendor, $package, $version, $device, $host, $mode, $key) {
    return cydia_("http://cydia.saurik.com/api/check", array('device' => $device, 'package' => $package, 'vendor' => $vendor, 'version' => $version, 'mode' => $mode, 'host' => $host, 'nonce' => uniqid(), 'timestamp' => time()), $key);
}
//take the sha1 hash of the string passed to you. This calculates the UDID
$udid = sha1($_GET['hashstr']);

//get the package ID and version (you can hardcode this if you aren't using it for more than one pacakge)
$packageID = $_GET['package'];
$productVersion = $_GET['version'];

//get the response
$response = cydia_check($vendor, $packageID, $productVersion, $udid, $_SERVER['REMOTE_ADDR'], "local", $secret_key);

//see if it's paid
$paid = (isset($response['state']) && $response['state'] == 'completed');

//create the result array
$result = array('paid' => $paid,
	'udid' => $udid);

//return the info to the device
header('Content-Type: application/json');
echo json_encode($result);

//file for writing contents
//this is outside of the web root directory so others can't view the UDIDs
$file = "/var/www/milodarling.me/" . $packageID . ".json"; 

$arrayKey = $paid ? "paid" : "pirated";

//get the array for modifying (or a skeleton one if one doesn't exist yet)
$info = file_exists($file) ? json_decode(file_get_contents($file), true) : array("paid" => array("udids" => array(), 
                                                                                           "count" => 0),
                                                                           "pirated" => array("udids" => array(), 
                                                                                              "count" => 0),
                                                                           "trybeforebuy" => 0);

//the array for either paid or pirated packages
$array = $info[$arrayKey];
//the list of UDIDs for either pirates or purchasers
$udids = $array["udids"];

//if it's already in the array, we don't add it agan
if (!in_array($udid, $udids)) {

    //if this is a paid response and they've pirated it (try before buy)
    if ($paid && in_array($udid, $info["pirated"]["udids"])) {
        $info["trybeforebuy"] = $info["trybeforebuy"] + 1;
    }
    //add the udid to the appropriate UDID array
    array_push($udids, $udid);
    //increment the appropriate count
    $array["count"] = $array["count"] + 1;

    //save all of the changed info back to the main array
	$array["udids"] = $udids;
	$info[$arrayKey] = $array;

	//save the contents to the disk
	file_put_contents($file, json_encode($info));
}


?>