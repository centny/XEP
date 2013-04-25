//
//  XEPPreferences.h
//  XEP
//
//  Created by Wen ShaoHong on 10/12/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GeneralDef.h"
#import <stdlib.h>
#import "NSLua.h"
#define CFG_UNCRUSTIFY		@"uncrustify"
#define CFG_UNCRUSTIFY_CFG	@"uncrustify.cfg"
#define CFG_FORMAT_FILE_EXT @"format.file.extend"
#define CFG_PRJ_CFG_FILE	@"PrjCfgFile"

@interface XEPPreferences : NSWindowController {
	NSBundle *_bundle;
}
// +(NSLua*)sharedLua;
+ (void)initConfig:(NSBundle *)bundle;
+ (void)loadConfig;
+ (void)saveConfig;
+ (void)releaseConfig;
+ (NSDictionary *)config;
+ (NSString *)uncrustifyCfgPath;
+ (NSString *)commentScript;
+ (NSDictionary *)blockTypes;
//
- (id)initWithWindowNibName:(NSString *)windowNibName bundle:(NSBundle *)bundle;
- (IBAction)clkSave:(id)sender;
- (IBAction)clkRestore:(id)sender;
@property (nonatomic, retain) NSBundle				*bundle;
@property (nonatomic, assign) IBOutlet NSImageView	*icon;
@property (nonatomic, assign) IBOutlet NSTextField	*uncrustify;
@property (nonatomic, assign) IBOutlet NSTextField	*uncrustify_cfg;
@property (nonatomic, assign) IBOutlet NSTextField	*formatExt;
@property (nonatomic, assign) IBOutlet NSTextField	*prjcfg;
@end
