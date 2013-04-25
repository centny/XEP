//
//  XEPPluginMgr.h
//  XEP
//
//  Created by Wen ShaoHong on 10/10/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XEPDef.h"
@interface XEPPluginMgr : NSObject
#pragma mark - Register plugin.
+ (void)registerPluginClass:(Class)cls;
+ (void)pluginDidLoad:(NSBundle *)bundle;

#pragma mark - PBXProject reference method.
+ (NSArray *)loadedProjects;
+ (id)ownerProject:(NSString *)filePath;
+ (NSString *)ownerProjectPath:(NSString *)filePath;
+ (NSString *)ownerProjectHome:(NSString *)filePath;
@end
