# DRM-And-Piracy-Counter
Some Obj-C and PHP for DRM and/or to count piracy statistics. This includes a server-side check for DRM if you're looking for DRM. It also has he advantage of not getting the UDID directly, but instead calculating it, which makes it slightly harder to crack. If you want to make it even harder, then find each piece of the UDID calculation using IOKit, not MobileGestalt. However, this is more of an example, and I will personally use it for statistics, not DRM, but I figured some might want some help with the DRM part as well.

###Notes

* This requires a server with PHP.
* This code works by creating an executable pretending to be an image asset, which is then executed once and removed from the disk. This allows it to run again upon reinstallation, which helps track try-before-buyers. Note--if you are using this for DRM, you probably need to change some stuff to enforce the DRM, as a checker that gets removed when it's done can't do too much :p

###Set up

* Change [line 25 of devicecode.mm](/devicecode.mm#L25) to point to your server
* Change [lines 3 and 4 of packagecheck.php](/packagecheck.php#L3-L4) to your [Cydia connect credentials](https://cydia.saurik.com/connect/api/).
* Change [line 47 of packagecheck.php](/packagecheck.php#L47) to point to the directory you want of your server.
* Change [line 9 of webpage.php](/webpage.php#L9) to point to the same location that packagecheck.php does.
* Make sure that PHP has write permissions for that directory.
* You'll probably want to change the names of the tweak, install paths, tool, etc.
