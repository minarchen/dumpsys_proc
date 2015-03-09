# dumpsys_proc

Android dumpsys[1] contains very useful information for performance
monitoring/debugging etc. but is too unstructured.  This project aims to parse
Android dumpsys to enable side-by-side "diffing" of two dumps and possibly
integrate into larger projects.

Code for processing a particular dump type, eg: batteryinfo, usagestats is
separated into their own folders 

[1] https://source.android.com/devices/input/dumpsys.html
