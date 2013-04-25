//
//  XEPPluginMgr.m
//  XEP
//
//  Created by Wen ShaoHong on 10/10/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "XEPPluginMgr.h"
#import "XEPPluginBase.h"
#import "XEPDef.h"
#import "XEPPreferences.h"
#import "NSFLog.h"
#import "XEPXcode.h"
#import "RegexKitLite.h"
//
static NSMutableArray	*gRegisteredClasses = nil;
static NSMutableArray	*gPlugins			= nil;
static NSString			*gEditingFileLock	= @"gEditingFileLock";
static NSURL			*gEditingFile		= nil;
static NSMutableArray	*gProejcts			= nil;
//
//
@implementation XEPPluginMgr
#pragma mark - Register plugin.

+ (void)registerPluginClass:(Class)cls
{
	@synchronized([self class]) {
		if (!gRegisteredClasses) {
			gRegisteredClasses = [[NSMutableArray alloc] init];
		}

		if (cls) {
			[gRegisteredClasses addObject:cls];
		}

		NSDLog(@"register class:%@", [cls description]);
	}
}

+ (void)applicationDidFinishLaunching:(NSNotification *)notification
{
	//
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

	[nc removeObserver	:self
		name			:NSApplicationDidFinishLaunchingNotification
		object			:NSApp];
	[nc addObserver:self selector:@selector(releaseConfig) name:NSApplicationWillTerminateNotification object:nil];

	for (XEPPluginBase *plugin in gPlugins) {
		[plugin applicationDidFinishLaunching:notification];
	}
}

//
+ (void)pluginDidLoad:(NSBundle *)bundle
{
	// initial the configure
	[self initConfig:bundle];
	//
	gPlugins = [[NSMutableArray alloc] initWithCapacity:[gRegisteredClasses count]];

	for (Class cls in gRegisteredClasses) {
		XEPPluginBase *plugin = [[cls alloc] initWithBundle:bundle];

		if (plugin) {
			[gPlugins addObject:plugin];
			[plugin release];
		}
	}

	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	//	[nc addObserver:self selector:@selector(transitionListen:) name:@"transition from one file to another" object:nil];
	//	[nc addObserver:self selector:@selector(openLastDocListen:) name:@"IDESourceCodeDocumentDidUpdateSourceModelNotification" object:nil];
	[nc addObserver:self selector:@selector(loadPrj:) name:@"PBXProjectDidOpenNotification" object:nil];
	//    [nc addObserver :self
	//        selector    :@selector(openLastDocListen:)
	//        name        :@"IDESourceCodeDocumentDidUpdateSourceModelNotification"
	//        object      :nil];
	//    [nc addObserver :self
	//        selector    :@selector(listen:)
	//        name        :nil
	//        object      :nil];

#if UseDebugCode
		[self applicationDidFinishLaunching:nil];
#else
		[nc addObserver :self
			selector	:@selector(applicationDidFinishLaunching:)
			name		:NSApplicationDidFinishLaunchingNotification
			object		:NSApp];
#endif
	NSILog(@"have %ld plugin class been loaded", [gRegisteredClasses count]);
	IF_REL(gRegisteredClasses);
}

+ (void)listen:(NSNotification *)notice
{
	//    if([notice.name rangeOfString:@"IDESourceCodeDocumentDidUpdateSourceModelNotification"].length>0)
	NSDLog(@"%@,%@", notice.name, [notice.object debugDescription]);
}

//
#pragma mark - Configure reference.
+ (void)initConfig:(NSBundle *)bundle
{
	[NSFLog initFLog:[[bundle bundlePath] stringByAppendingString:@"/Contents/XEP_E.log"]];
	[NSFLog sharedFLog].console = YES;
	[NSFLog sharedFLog].level	= LOG_DEBUG;
	NSILog(@"file log initialed%@", @"");
	[XEPPreferences initConfig:bundle];
	gProejcts = [[NSMutableArray alloc] init];
}

+ (void)releaseConfig
{
	NSILog(@"file log closed%@", @"");
	[XEPPreferences releaseConfig];
	[NSFLog relFLog];
	IF_REL(gEditingFile);
	IF_REL(gProejcts);
	IF_REL(gPlugins);
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
}

#pragma mark - PBXProject references method.
+ (void)loadPrj:(NSNotification *)notice
{
	@synchronized(gProejcts) {
		[gProejcts addObject:notice.object];
	}
	NSLog(@"one project have loaded:%@", [notice.object path]);
}

+ (id)loadedProjects; {
	return gProejcts;
}
+ (id)ownerProject:(NSString *)filePath
{
	NSArray *names = [filePath componentsSeparatedByString:@"/"];

	if (names.count < 1) {
		return nil;
	}

	NSString	*name	= [names lastObject];
	NSString	*rfp	= [filePath stringByReplacingOccurrencesOfString:@"file://localhost" withString:@""];
	id			prj		= nil;
	@synchronized(gProejcts) {
		for (id p in gProejcts) {
			if ([[XEPXcode filePathForProject:p name:name] isEqualToString:rfp]) {
				prj = p;
				break;
			}
		}
	}

	if (prj == nil) {
		NSDLog(@"can't find the owner project for file:%@", filePath);
	}

	return prj;
}

+ (NSString *)ownerProjectPath:(NSString *)filePath
{
	return [[self ownerProject:filePath] path];
}

+ (NSString *)ownerProjectHome:(NSString *)filePath
{
	NSString *opp = [self ownerProjectPath:filePath];

	return [opp stringByReplacingOccurrencesOfRegex:@"/[^/]*\\.xcodeproj$" withString:@""];
}

// #pragma mark - listen editing document change.
// + (void)openLastDocListen:(NSNotification *)notice
// {
//	@synchronized(gEditingFileLock) {
//		IF_REL(gEditingFile);
//		gEditingFile = [[notice.object fileURL] retain];
//		//        NSDLog(@"open last file:%@",gEditingFile);
//	}
// }

// + (void)transitionListen:(NSNotification *)notice
// {
//	NSDictionary	*dict	= notice.object;
//	id				obj		= [dict objectForKey:@"next"];
//
//	if (nil == obj) {
//		return;
//	}
//
//	@synchronized(gEditingFileLock) {
//		IF_REL(gEditingFile);
//		gEditingFile = [[obj documentURL] retain];
//		//        NSDLog(@"transition to file:%@",gEditingFile);
//	}
// }
//
// + (NSURL *)editingFile
// {
//	NSURL *tmp;
//
//	@synchronized(gEditingFileLock) {
//		tmp = [NSURL URLWithString:[gEditingFile absoluteString]];
//	}
//	return tmp;
// }
//
// + (NSString *)editingFilePath
// {
//	@synchronized(gEditingFileLock) {
//		NSString *fp = [[gEditingFile absoluteString] stringByReplacingOccurrencesOfString:@"file://localhost" withString:@""];
//
//		NSDLog(@"useing current file:%@", fp);
//		return fp;
//	}
// }

@end
