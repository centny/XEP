#XEP
![Mou icon](http://mouapp.com/Mou_128.png)
The Xcode Extend Plug-in


==This Plug-in provided==
 # format the source code(it depended by uncrustify tools).   
 # copy one line to up or down.
 # using project configure file to create the comment(only effect to FULLUSERNAME/VERSION  configure to the @author and @since).
<br/>
==Install==
 # install uncrustify:
{{{
ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
brew install uncrustify
}}}
 # install Plug-in
 * download `XEP-*.pkg` and `PrjEnv.cfg` in Downloads tab
 * install the Plug-in
 * copy the `PrjEnv.cfg` to you project home directory and rename to `.PrjEnv.cfg`,then edit it.
 * then restart the Xcode
<br />
==Uninstall==
{{{
cd ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins
rm -rf XEP.xcplugin
brew uninstall uncrustify
}}}
<br />
==Configure sample file==
{{{
####
#the file to configure the proejct environment.
#save this file to the project home directory(the directory contained *.xcodeproj file) as .PrjEnv.cfg
#you can change the file name and directory by setting in XEP->Preferences->Project .cfg file.
####
#specified the @author to the comment.
FULLUSERNAME=Centny
#specified the @since to the commend.
VERSION=1.10
}}}
<br />
note:if you have any suggestions or bugs,you can email to centny@gmail.com