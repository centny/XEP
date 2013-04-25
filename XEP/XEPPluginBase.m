//
//  PluginBase.m
//  XcodeExtPlugin
//
//  Created by Wen ShaoHong on 9/29/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "XEPPluginBase.h"
#import "XEPDef.h"
@implementation XEPPluginBase
@synthesize bundle = _bundle;
- (id)initWithBundle:(NSBundle *)bundle
{
	self = [super init];

	if (self) {
		self.bundle = bundle;
	}

	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
	NSDLog(@"applicationDidFinishLaunching...%@", @"");
}

- (void)dealloc
{
	[_bundle release];
	[super dealloc];
}

@end
