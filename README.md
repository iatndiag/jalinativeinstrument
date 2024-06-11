Harp Kora is... read about it on the Internet.

The project is a notation player from csv/tsv files and an editor macro in Excel Windows
(under Mac, changes to the macro are required in terms of opening and saving files).

The entire project is actually in one file main.dart and in drop-down menu file.

The project is being put together in Android Studio Hedgehog 2024 with the Dart plugin.
The choice of platform is made automatic, but due to the android (?Mac) chromatic tuner component,
when assembling for MacOS, you may have to comment out some sections of the code.
They are all marked in the code.

You can try to build it for Web, but it is not recommended.
You can try to use AnimationController for cursor moving and give some of the work to the GPU (see test file) for a smoother beat duration.

lib - Dart source code.

assets - audio samples.

!CSV TSV - music by ear.

ExeApkApp - assembled project.


