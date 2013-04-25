//
//  XEPPreferences.m
//  XEP
//
//  Created by Wen ShaoHong on 10/12/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "XEPPreferences.h"
#import "RegexKitLite.h"
#import "XEPDef.h"
@interface XEPPreferences () <NSWindowDelegate>{
	NSMutableDictionary *_config;
}

@end

// static fields.
static NSMutableDictionary * __config_ = nil;
static NSBundle *__bundle_	= nil;
static NSLua	*__L		= nil;
@implementation XEPPreferences
@synthesize bundle = _bundle;
//
// + (NSLua *)sharedLua
// {
//	if (__L == nil) {
//        NSILog(@"using comment script:%@",[self commentScript]);
//		__L = [NSLua luaWithFile:[[self commentScript] UTF8String]];
//        NSLua *lua=[XEPPreferences sharedLua];
//        [lua pushstring:[NSUserName()UTF8String]];
//        [lua setglobal:"USERNAME"];
//        [lua pushstring:[NSFullUserName()UTF8String]];
//        [lua setglobal:"FULLUSERNAME"];
//	}
//
//	return __L;
// }

+ (void)initConfig:(NSBundle *)bundle
{
	IF_REL(__bundle_);
	__bundle_ = bundle;
}

+ (void)loadConfig
{
	if (__bundle_ == nil) {
		NSWLog(@"the target bundle is nil when loading the configure.%@", @"");
		return;
	}

	NSString *path = [__bundle_ pathForResource:@"XEPPreferences" ofType:@"plist"];
	IF_REL(__config_);
	__config_ = [[NSMutableDictionary alloc] initWithContentsOfFile:path];

	// validate configure.
	if ([__config_ objectForKey:CFG_UNCRUSTIFY] == nil) {
		[__config_ setObject:@"/usr/local/bin/uncrustify" forKey:CFG_UNCRUSTIFY];
	}

	if ([__config_ objectForKey:CFG_UNCRUSTIFY_CFG] == nil) {
		[__config_ setObject:@"$(XEP_HOME)/Resouces/uncrustify.cfg" forKey:CFG_UNCRUSTIFY_CFG];
	}

	if ([__config_ objectForKey:CFG_FORMAT_FILE_EXT] == nil) {
		[__config_ setObject:@"*.mm;*.m;*.h;*.hpp" forKey:CFG_FORMAT_FILE_EXT];
	}
}

+ (void)saveConfig
{
	if (__bundle_ == nil) {
		NSWLog(@"the target bundle is nil when saving the configure.%@", @"");
		return;
	}

	NSString *path = [__bundle_ pathForResource:@"XEPPreferences" ofType:@"plist"];
	[__config_ writeToFile:path atomically:YES];
}

+ (void)releaseConfig
{
	IF_REL(__config_);
	IF_REL(__bundle_);
	IF_REL(__L);
}

+ (NSDictionary *)config
{
	if (nil == __config_) {
		[self loadConfig];
	}

	return __config_;
}

+ (NSString *)uncrustifyCfgPath
{
	NSString *old = [[self config] objectForKey:CFG_UNCRUSTIFY_CFG];

	return [old stringByReplacingOccurrencesOfRegex:@"\\$\\([^\\)]+\\)" usingBlock:^NSString * (NSInteger captureCount, NSString * const *capturedStrings, const NSRange * capturedRanges, volatile BOOL * const stop) {
			NSString *math = [(*capturedStrings) substringWithRange:NSMakeRange (2, (*capturedStrings).length - 3)];

			if ([math isEqualToString:@"XEP_HOME"]) {
				return [__bundle_ bundlePath];
			}

			const char *ev = getenv ([math UTF8String]);

			if (ev) {
				return [NSString stringWithFormat:@"%s", ev];
			} else {
				return @"";
			}
		}];
}
+ (NSString *)commentScript
{
	return [__bundle_ pathForResource:@"XEPComment" ofType:@"lua"];
}

+ (NSDictionary *)blockTypes
{
	return [NSDictionary dictionaryWithContentsOfFile:[__bundle_ pathForResource:@"XEPBlockTypes" ofType:@"plist"]];
}

//
//
- (id)initWithWindowNibName:(NSString *)windowNibName bundle:(NSBundle *)bundle
{
	self = [super initWithWindowNibName:windowNibName];

	if (self) {
		self.bundle				= bundle;
		_config					= (NSMutableDictionary *)[XEPPreferences config];
		self.window.delegate	= self;
	}

	return self;
}

- (void)showConfig
{
	if (_config == nil) {
		return;
	}

	[self.uncrustify.cell setTitle:[_config objectForKey:CFG_UNCRUSTIFY]];
	[self.uncrustify_cfg.cell setTitle:[_config objectForKey:CFG_UNCRUSTIFY_CFG]];
	NSMutableString *extend = [[NSMutableString alloc] init];

	for (NSString *e in [_config objectForKey : CFG_FORMAT_FILE_EXT]) {
		if ([@"" isEqualToString:[e stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
			continue;
		}

		[extend appendFormat:@"*.%@;", e];
	}

	[self.formatExt.cell setTitle:extend];
	[self.prjcfg.cell setTitle:[_config objectForKey:CFG_PRJ_CFG_FILE]];
	[extend release];
}

- (IBAction)clkSave:(id)sender
{
	[_config setObject:[self.uncrustify.cell title] forKey:CFG_UNCRUSTIFY];
	[_config setObject:[self.uncrustify_cfg.cell title] forKey:CFG_UNCRUSTIFY_CFG];
	NSString		*extend = [[self.formatExt.cell title] stringByReplacingOccurrencesOfString:@"*." withString:@""];
	NSMutableArray	*ary	= [[NSMutableArray alloc] init];

	for (NSString *e in [extend componentsSeparatedByString : @";"]) {
		if ([@"" isEqualToString:[e stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
			continue;
		}

		[ary addObject:e];
	}

	[_config setObject:ary forKey:CFG_FORMAT_FILE_EXT];
	[_config setObject:[self.uncrustify_cfg.cell title] forKey:CFG_PRJ_CFG_FILE];
	[ary release];
	[XEPPreferences saveConfig];
	[self close];
}

- (IBAction)clkRestore:(id)sender
{
	[self showConfig];
}

- (IBAction)showWindow:(id)sender
{
	[super showWindow:sender];
	[self showConfig];
}

- (void)windowDidLoad
{
	[super windowDidLoad];
	[self showConfig];
}

- (void)dealloc
{
	IF_REL(_bundle);
	NSDLog(@"XEPPreferences release...%@", @"");
	[super dealloc];
}

@end
