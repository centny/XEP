//
//  PluginBase.h
//  XcodeExtPlugin
//
//  Created by Wen ShaoHong on 9/29/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XEPDef.h"
@interface XEPPluginBase : NSObject {
	NSBundle *_bundle;
}
@property (nonatomic, retain) NSBundle *bundle;
- (id)initWithBundle:(NSBundle *)bundle;
- (void)applicationDidFinishLaunching:(NSNotification *)notification;
@end
