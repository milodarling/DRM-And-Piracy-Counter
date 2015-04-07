<html>
<head>
<title>Test</title>
</head>
<body>
<h1>SnooScreens</h1>
<?php
//get the array for modifying (or a skeleton one if one doesn't exist yet)
$file = "/var/www/milodarling.me/org.thebigboss.snooscreens.json";
$info = file_exists($file) ? json_decode(file_get_contents($file), true) : array("paid" => array("udids" => array(), 
                                                                                           "count" => 0),
                                                                           "pirated" => array("udids" => array(), 
                                                                                              "count" => 0),
                                                                           "trybeforebuy" => 0);

echo("<h3>" . $info["paid"]["count"] . " paid packages sold");
echo("<h3>" . $info["pirated"]["count"] . " pirated packages downloaded");
echo("<h3>" . $info["trybeforebuy"] . " try before buy-ers");
?>
</body>
</html>