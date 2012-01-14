About NME

	Building a game or application with NME is almost like writing for a single platform. However, 
	when you are ready to publish your application, you can choose between targets like iOS, webOS, 
	Android, Windows, Mac, Linux and Flash Player.

	Instead of using the lowest common denominator between platforms with a "universal" runtime, 
	NME projects are compiled as SWF bytecode or C++ applications, using the Haxe language compiler 
	and the standard C++ compiler toolchain for each platform.
	
	Read more: 
	http://www.haxenme.org/

Development

	NME is very close to Flash API but using 'nme' as the root package (ie. nme.display.Sprite).
	http://www.haxenme.org/api/

	Just code like you would code a Flash application, with the limitation that you can only use
	the drawing API, bitmaps (see below) and TextFields.
	
	In NME 3.0, SWFs and videos aren't supported yet.

Assets

	Place all your images, sounds, fonts in /assets and access them in your code using the 
	global Assets class which abstracts assets management for all platforms:
	
		var img = new Bitmap(Assets.getBitmapData("assets/my-image.png"));
		addChild(img);
	
	Tutorials:
	http://www.haxenme.org/developers/tutorials/

Debugging

	By default your project targets Flash so you'll be able to add breakpoints and debug your app 
	like any AS3 project.

Project configuration, libraries, classpaths
	
	NME integration in FlashDevelop is still early and you'll have to configure the classpath and
	haxelibs both in the FD project and in the build.nmml file.
	
Native targets

	Change the NME target in your Project Properties > Test Project > Edit...
	Enter a valid target in the field, like:
	- flash
	- cpp
	- android
	
	Attention, for non-Flash targets you'll need to install additional compilers & SDKs:
	http://www.haxenme.org/developers/get-started/
	
	Tips: 
	- in C++ expect first compilation to be very long as it first compiles the whole NME API,
	- if a change is not taken in account, delete everything in /bin to start a fresh compilation.
	
