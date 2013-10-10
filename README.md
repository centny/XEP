The Xcode Extend Plug-in
===
![icon](https://raw.github.com/Centny/XEP/master/XEP/Resources/XEP.png "XEP")

###Provided features
- format the source code(it depended by uncrustify tools).   
- copy one line to up or down.
- using project configure file to create the comment(only effect to FULLUSERNAME/VERSION  configure to the @author and @since).


###Install
- install uncrustify:

	```
ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
brew install uncrustify
	```
- install Plug-in
	- download <a href="https://raw.github.com/Centny/XEP/master/Publish/XEP-v1.2.0.pkg">XEP-*.pkg</a> and <a href="https://raw.github.com/Centny/XEP/master/Publish/PrjEnv.cfg" >PrjEnv.cfg</a>
	- install the <a href="https://raw.github.com/Centny/XEP/master/Publish/XEP-v1.2.0.pkg">XEP-*.pkg</a>
	- copy the `PrjEnv.cfg` to you project home directory and rename to `.PrjEnv.cfg`,then edit it.
	- then restart the Xcode
	
###Uninstall

```
	cd ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins
	rm -rf XEP.xcplugin
	brew uninstall uncrustify
```

###Configure sample

```
	#the file to configure the proejct environment.
	#save this file to the project home directory(the directory
	#  contained *.xcodeproj file) as .PrjEnv.cfg
	#you can change the file name and directory by setting in 
	#  XEP->Preferences->Project .cfg file.
	####
	#specified the @author to the comment.
	FULLUSERNAME=Centny
	#specified the @since to the commend.
	VERSION=1.10
```
*note:if you have any suggestions or bugs,you can email to centny@gmail.com*

