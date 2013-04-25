//
//  XEPLua.m
//  XEP
//
//  Created by Wen ShaoHong on 10/20/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "XEPLua.h"
#import <Foundation/Foundation.h>
#import "XEPDef.h"
#import "RegexKitLite.h"

@implementation XEPLua
@synthesize cfg = _cfg;
+ (id)luaWithPrjPath:(NSString *)path
{
	return [[[XEPLua alloc] initWithPrjPath:path] autorelease];
}

- (id)initWithPrjPath:(NSString *)path
{
	self = [super initWithFile:[[XEPPreferences commentScript] UTF8String]];

	if (self) {
		NSString	*cpath	= [[XEPPreferences config] objectForKey:CFG_PRJ_CFG_FILE];
		NSString	*fpath	= [cpath stringByReplacingOccurrencesOfRegex:@"\\$\\([^\\)]*\\)" usingBlock:^NSString * (NSInteger captureCount, NSString * const *capturedStrings, const NSRange * capturedRanges, volatile BOOL * const stop) {
				NSRange rg = {2, (*capturedStrings).length - 3};
				NSString *name = [(*capturedStrings) substringWithRange:rg];

				if ([@"PROJECT_DIR" isEqualToString:name]) {
					return path;
				} else {
					const char *ev = getenv ([name UTF8String]);

					if (ev) {
						return [NSString stringWithFormat:@"%s", ev];
					} else {
						return @"";
					}
				}
			}];
		_cfg = [[NSMutableDictionary alloc] initWithCfgFile:fpath];

		if (nil == [_cfg objectForKey:@"USERNAME"]) {
			[_cfg setObject:NSUserName () forKey:@"USERNAME"];
		}

		if (nil == [_cfg objectForKey:@"FULLUSERNAME"]) {
			[_cfg setObject:NSFullUserName () forKey:@"FULLUSERNAME"];
		}

		for (NSString *key in [_cfg allKeys]) {
			[self pushstring:[[_cfg objectForKey:key] UTF8String]];
			[self setglobal:[key UTF8String]];
		}
	}

	return self;
}
- (void)dealloc
{
	[_cfg release], _cfg = nil;
	[super dealloc];
}

@end
