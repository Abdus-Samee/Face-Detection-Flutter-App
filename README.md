# Face-Detection-Flutter-App
A Flutter application built with a face detection model formed via google teachable machine.

# Detection
It detects between Samee and Ghochu(:P).

# Plugins
 - tflite : ^1.1.1
 - image_picker : ^0.6.7+12
 
# Other options
The following block was added inside the android block inside the /android/app/build.gradle:
   - aaptOptions{
        noCompress "tflite"
     }
     
Besides, the minSdkVersion was edited to 21 which was previously 19.
