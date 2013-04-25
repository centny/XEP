//
//  XEPMenu.m
//  XEP
//
//  Created by Wen ShaoHong on 10/10/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "XEPMenu.h"
#import "XEPPluginMgr.h"
#import "XEPPreferences.h"
#import "RegexKitLite.h"
#import "XEPLua.h"
#import "NSLineString.h"
#import "XEPXcode.h"

typedef enum CopyDirection {
	CD_UP = 1, CD_DOWN
} CopyDirection;
@interface XEPMenu () {
	XEPPreferences *_preferences;
}
@end
@implementation XEPMenu

#pragma mark - Initial

+ (void)load
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	[XEPPluginMgr registerPluginClass:[self class]];
	[pool drain];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
	NSMenu		*menu	= [NSApp mainMenu];
	NSArray		*items	= [menu itemArray];
	NSMenuItem	*mi		= [[NSMenuItem alloc] initWithTitle:@"XEP" action:nil keyEquivalent:@""];

	mi.submenu = [self createXEPMenu];
	[menu insertItem:mi atIndex:[items count] - 1];
	[mi release];
}

#pragma mark - Create Menu.

- (NSMenu *)createXEPMenu
{
	NSMenu		*xep = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@"XEP"] autorelease];
	NSMenuItem	*item;

	item = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Format" action:@selector(formatCode:) keyEquivalent:@"F"];
	[item setKeyEquivalentModifierMask:(NSShiftKeyMask | NSControlKeyMask)];
	item.target = self;
	[xep addItem:item];
	[item release];
	item = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Comment" action:@selector(createComment:) keyEquivalent:@"J"];
	[item setKeyEquivalentModifierMask:(NSShiftKeyMask | NSControlKeyMask)];
	item.target = self;
	[xep addItem:item];
	[item release];

	item = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"All Comment" action:@selector(createAllComment:) keyEquivalent:@"J"];
	[item setKeyEquivalentModifierMask:(NSControlKeyMask | NSShiftKeyMask | NSCommandKeyMask)];
	item.target = self;
	[xep addItem:item];
	[item release];
	UniChar a;
	a		= 63232;
	item	= [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Copy line up" action:@selector(copyLineUp:) keyEquivalent:[NSString stringWithCharacters:&a length:1]];
	[item setKeyEquivalentModifierMask:(NSControlKeyMask | NSAlternateKeyMask)];
	item.target = self;
	[xep addItem:item];
	[item release];
	a		= 63233;
	item	= [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Copy line down" action:@selector(copyLineDown:) keyEquivalent:[NSString stringWithCharacters:&a length:1]];
	[item setKeyEquivalentModifierMask:(NSControlKeyMask | NSAlternateKeyMask)];
	item.target = self;
	[xep addItem:item];
	[item release];
	item = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Delete line" action:@selector(deleteLine:) keyEquivalent:@"-"];
	[item setKeyEquivalentModifierMask:(NSCommandKeyMask)];
	item.target = self;
	[xep addItem:item];
	[item release];
	item = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Perferences" action:@selector(showPreferences:) keyEquivalent:@","];
	[item setKeyEquivalentModifierMask:(NSShiftKeyMask | NSCommandKeyMask)];
	item.target = self;
	[xep addItem:item];
	[item release];
	return xep;
}

#pragma mark - Delete line
- (void)deleteLine:(id)sender
{
	NSWindow	*nsKeyWindow	= [[NSApplication sharedApplication] keyWindow];
	NSResponder *responder		= [nsKeyWindow firstResponder];
	NSString	*resname		= [[responder class] description];

	if (![resname isEqualToString:@"DVTSourceTextView"]) {
		return;
	}

	NSTextView		*tv		= (NSTextView *)responder;
	NSRange			range	= tv.selectedRange;
	NSLineString	*ls		= [NSLineString lineStringWith:[[tv textStorage] string]];
	NSUInteger		cline	= [ls lineOfLocation:range.location];

	if (range.length > 0) {
		if ('\n' == [ls.targetStr characterAtIndex:range.location + range.length - 1]) {
			range.length -= 1;
		}

		NSRange srange	= [ls rangeOfLineNumber:[ls lineOfLocation:range.location]];
		NSRange erange	= [ls rangeOfLineNumber:[ls lineOfLocation:(range.location + range.length)]];
		range = NSMakeRange(srange.location, erange.location + erange.length + 1 - srange.location);
	} else {
		range = [ls rangeOfLineNumber:cline];
		range.length++;
	}

	[tv insertText:@"" replacementRange:range];
}

#pragma mark - Copy line
- (void)copyLine:(CopyDirection)direction
{
	NSWindow	*nsKeyWindow	= [[NSApplication sharedApplication] keyWindow];
	NSResponder *responder		= [nsKeyWindow firstResponder];
	NSString	*resname		= [[responder class] description];

	if (![resname isEqualToString:@"DVTSourceTextView"]) {
		return;
	}

	NSTextView		*tv		= (NSTextView *)responder;
	NSRange			range	= tv.selectedRange;
	NSLineString	*ls		= [NSLineString lineStringWith:[[tv textStorage] string]];
	NSUInteger		cline	= [ls lineOfLocation:range.location];

	NSString	*ltext;
	NSRange		srg;

	if (range.length > 0) {
		if ('\n' == [ls.targetStr characterAtIndex:range.location + range.length - 1]) {
			range.length -= 1;
		}

		NSRange srange	= [ls rangeOfLineNumber:[ls lineOfLocation:range.location]];
		NSRange erange	= [ls rangeOfLineNumber:[ls lineOfLocation:(range.location + range.length)]];
		range	= NSMakeRange(srange.location, erange.location + erange.length + 1 - srange.location);
		ltext	= [ls.targetStr substringWithRange:range];

		if (direction == CD_UP) {
			srg = range;
		} else {
			srg = NSMakeRange(range.length + range.location, ltext.length);
		}

		range = NSMakeRange(range.length + range.location, 0);
	} else {
		ltext			= [[ls stringOfLineNumber:cline] stringByAppendingString:@"\n"];
		range			= [ls rangeOfLineNumber:cline];
		range.location	= range.location + range.length + 1;
		range.length	= 0;

		if (direction == CD_UP) {
			srg = tv.selectedRange;
		} else {
			srg = NSMakeRange(range.length + range.location + ltext.length - 1, 0);
		}
	}

	[tv insertText:ltext replacementRange:range];
	tv.selectedRange = srg;
}

- (void)copyLineUp:(id)sender
{
	@synchronized(self) {
		@try {
			[self copyLine:CD_UP];
		}
		@catch(NSException *exception) {
			NSELog(@"copy line up error:%@", [exception debugDescription]);
		}
	}
}

- (void)copyLineDown:(id)sender
{
	@synchronized(self) {
		@try {
			[self copyLine:CD_DOWN];
		}
		@catch(NSException *exception) {
			NSELog(@"copy line up error:%@", [exception debugDescription]);
		}
	}
}

#pragma mark - Create all comment for file.
- (void)createAllComment:(id)sender
{
	@synchronized(self) {
		@try {
			NSWindow	*nsKeyWindow	= [[NSApplication sharedApplication] keyWindow];
			NSResponder *responder		= [nsKeyWindow firstResponder];
			NSString	*resname		= [[responder class] description];

			if (![resname isEqualToString:@"DVTSourceTextView"]) {
				return;
			}

			NSTextView		*tv		= (NSTextView *)responder;
			NSLineString	*ls		= [NSLineString lineStringWith:[[tv textStorage] string]];
			NSLineString	*tls	= nil;
			NSUInteger		cline	= 0;
			NSString		*block, *comment;
			NSDictionary	*blockTypes = [XEPPreferences blockTypes];

			for (; true; ) {
				if (cline >= ls.lineCount) {
					break;
				}

				NSUInteger eline;
				//        NSLog(@"cline:%ld,%@",cline,[ls stringOfLineNumber:cline]);
				block = [self findBlock:ls sline:cline eline:&eline btype:blockTypes];

				if ([block stringByReplacingOccurrencesOfRegex:@"\\s" withString:@""].length < 1) {
					cline++;
					continue;
				}

				BOOL created = [self checkCommentCreated:ls cline:cline];

				if (created) {
					cline++;
					continue;
				}

				comment = [self insertBlockComment:tv ls:ls block:block sl:cline cursor:NO];

				if (comment.length < 1) {
					cline++;
					continue;
				}

				tls		= [[NSLineString alloc] initWithString:comment];
				cline	+= tls.lineCount;

				if (tls.lastLine.length == 0) {
					cline--;
				}

				//        NSLog(@"1----cline size:%ld",cline);
				//        NSLog(@"comment count:%ld",tls.lineCount);
				[tls release], tls = nil;
				tls		= [[NSLineString alloc] initWithString:block];
				cline	+= tls.lineCount;

				if (tls.lastLine.length == 0) {
					cline--;
				}

				//        NSLog(@"block count:%ld",tls.lineCount);
				[tls release], tls	= nil;
				ls.targetStr		= [[tv textStorage] string];
			}
		}
		@catch(NSException *exception) {
			NSDLog(@"createAllComment error:%@", [exception debugDescription]);
		}
	}
}

#pragma mark - Create Comment.

- (void)createComment:(id)sender
{
	@synchronized(self) {
		@try {
			NSWindow	*nsKeyWindow	= [[NSApplication sharedApplication] keyWindow];
			NSResponder *responder		= [nsKeyWindow firstResponder];
			NSString	*resname		= [[responder class] description];

			if (![resname isEqualToString:@"DVTSourceTextView"]) {
				return;
			}

			NSTextView *tv = (NSTextView *)responder;
			//            NSLog(@"tv:%@",[[XEPPluginMgr ownerProjectHome:[XEPXcode filePathForSourceTextView:tv]] debugDescription]);
			[self processLineMatch:tv];
		}
		@catch(NSException *exception) {
			NSELog(@"create comment error:%@", exception);
		}
	}
}

- (NSMutableArray *)findOldComment:(NSLineString *)ls cline:(NSUInteger)cline range:(NSRange *)rg
{
	NSMutableArray	*clines = [NSMutableArray array];
	NSUInteger		sline, eline = cline - 1;

	for (int idx = (int)cline - 1; idx >= 0; idx--) {
		NSString *line = [[ls stringOfLineNumber:idx] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

		if (line.length == 0) {
			continue;
		}

		if (line.length < 2) {
			sline = idx + 1;
			break;
		}

		NSString *bsub = [line substringWithRange:NSMakeRange(0, 2)];

		if ([@"//" isEqualToString:bsub]) {
			[clines insertObject:[line stringByReplacingOccurrencesOfRegex:@"^/+" withString:@""] atIndex:0];
		} else {
			sline = idx + 1;
			break;
		}
	}

	NSRange erg = [ls rangeOfLineNumber:eline];
	(*rg).location	= [ls rangeOfLineNumber:sline].location;
	(*rg).length	= (erg.location + erg.length) - (*rg).location;
	return clines;
}

- (BOOL)checkCommentCreated:(NSLineString *)ls cline:(NSUInteger)cline
{
	NSUInteger		sline		= NSNotFound, eline = NSNotFound;
	NSDictionary	*blockTypes = [NSDictionary dictionaryWithObjectsAndKeys:@"/", @"/**", nil];
	NSString		*block		= [self findBlock:ls cline:cline sline:&sline eline:&eline btype:blockTypes];

	if ((block.length > 0) && (cline == eline)) {
		return YES;
	}

	if (eline > cline) {
		return NO;
	}

	NSRange erg = [ls rangeOfLineNumber:eline];
	NSRange crg = [ls rangeOfLineNumber:cline];
	erg.location	+= erg.length;
	erg.length		= crg.location - erg.location;

	if (erg.length == 0) {
		return YES;
	}

	return [[ls.targetStr substringWithRange:erg] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
}

- (NSString *)findBlock:(NSLineString *)ls sline:(NSUInteger)sline eline:(NSUInteger *)eline btype:(NSDictionary *)blockTypes
{
	NSUInteger	lineCount	= [ls lineCount];
	NSString	*line		= [ls stringOfLineNumber:sline];
	NSString	*tline		= [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

	if (tline.length < 1) {
		return @"";
	}

	for (NSString *b in [blockTypes allKeys]) {
		NSRange srg = [tline rangeOfString:b];

		if (srg.location > 0) {
			continue;
		}

		NSString *bv = [blockTypes objectForKey:b];

		if (bv.length == 0) {
			NSString *block = line;

			for (NSUInteger idx = sline + 1; idx < lineCount; idx++) {
				if ('\\' == [block characterAtIndex:block.length - 1]) {
					block = [block stringByAppendingFormat:@"\n%@", [ls stringOfLineNumber:idx]];
					continue;
				} else {
					*eline = idx - 1;
					break;
				}
			}

			NSDLog(@"find the block:%@", block);
			return block;
		}

		for (NSUInteger i = sline; i < lineCount; i++) {
			NSString *nline = [ls stringOfLineNumber:i];

			NSRange rg;
			rg = [nline rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:bv]];

			if (rg.length < 1) {
				continue;
			}

			NSRange nrg = [ls rangeOfLineNumber:i];
			NSRange org = [ls rangeOfLineNumber:sline];
			org.length = nrg.location + rg.location - org.location;

			NSString *sub = [ls.targetStr substringWithRange:org];

			if ([sub stringByReplacingOccurrencesOfRegex:@"\\s" withString:@""].length < 1) {
				continue;
			}

			*eline = i;
			NSDLog(@"find the block:%@", sub);
			return sub;
		}
	}

	*eline = NSNotFound;
	return @"";
}

- (NSString *)findBlock:(NSLineString *)ls cline:(NSUInteger)cline sline:(NSUInteger *)sline eline:(NSUInteger *)eline btype:(NSDictionary *)blockTypes
{
	NSString *block = @"";

	*sline = NSNotFound;

	for (int idx = (int)cline; idx >= 0; idx--) {
		block = [self findBlock:ls sline:idx eline:eline btype:blockTypes];

		if (block.length > 0) {
			*sline = idx;
			break;
		}
	}

	return block;
}

- (NSString *)insertBlockComment:(NSTextView *)tv ls:(NSLineString *)ls block:(NSString *)block sl:(NSUInteger)sline cursor:(BOOL)cursor
{
	NSLua *lua = [XEPLua luaWithPrjPath:[XEPPluginMgr ownerProjectHome:[XEPXcode filePathForSourceTextView:tv]]];

	//
	[lua getglobal:"blockIdx"];
	[lua pushNSString:self.bundle.bundlePath];
	[lua pushNSString:block];
	[lua pcall:2 nrs:1];
	int bidx = (int)[lua tointeger:-1];
	[lua pop:1];
	//	NSLog(@"block idx:%d", bidx);

	if (bidx < 1) {
		return @"";
	}

	[lua getglobal:"blockComment"];
	[lua pushNSString:self.bundle.bundlePath];
	[lua pushNSString:block];
	[lua pushinteger:bidx];
	[lua pcall:3 nrs:1];
	NSString *comment = [lua toNSString:-1];
	[lua pop:1];

	if (comment.length < 1) {
		return @"";
	}

	NSMutableString *ocomment = [NSMutableString string];
	NSRange			ocrg;

	for (NSString *c in [self findOldComment : ls cline : sline range : &ocrg]) {
		[ocomment appendFormat:@"%@\n	", c];
	}

	//    NSLog(@"ocrg:%ld,%ld",ocrg.location,ocrg.length);
	NSDLog(@"find old comment:%@", ocomment);
	NSString	*otc	= [ocomment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString	*tocm	= [ocomment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

	if (tocm.length > 0) {
		comment = [comment stringByReplacingOccurrencesOfString:@"<#Old Description#>" withString:otc];
	} else {
		comment = [comment stringByReplacingOccurrencesOfString:@"<#Old Description#>" withString:@"<#Description#>"];
	}

	NSDLog(@"final comment:%@", comment);
	[lua getglobal:"isReplaceOld"];
	[lua pushNSString:self.bundle.bundlePath];
	[lua pushNSString:block];
	[lua pushinteger:bidx];
	[lua pcall:3 nrs:1];
	int isReplace = (int)[lua tointeger:-1];
	[lua pop:1];
	NSRange rg;

	if (isReplace) {
		rg			= [ls rangeOfLineNumber:sline];
		rg.length	= block.length;
		NSDLog(@"will replace the old block(%ld,%ld)", rg.location, rg.length);
	} else {
		[lua getglobal:"commentInsertLine"];
		[lua pushNSString:self.bundle.bundlePath];
		[lua pushNSString:block];
		[lua pushinteger:bidx];
		[lua pcall:3 nrs:1];
		int insertIdx = (int)[lua tointeger:-1];
		[lua pop:1];
		rg			= [ls rangeOfLineNumber:(sline + insertIdx)];
		rg.length	= 0;
	}

	[tv insertText:comment replacementRange:rg];

	if (tocm.length > 0) {
		[tv insertText:@"" replacementRange:ocrg];
	}

	if (cursor) {
		[lua getglobal:"cursorPosition"];
		[lua pushNSString:self.bundle.bundlePath];
		[lua pushinteger:rg.location];
		[lua pushinteger:comment.length];
		[lua pcall:3 nrs:1];
		rg.location = (NSUInteger)[lua tointeger : -1];
		[lua pop:1];
		rg.length = 0;
		[tv setSelectedRange:rg];
	}

	return comment;
}

- (void)processLineMatch:(NSTextView *)tv
{
	NSRange			range	= [tv selectedRange];
	NSLineString	*ls		= [NSLineString lineStringWith:[[tv textStorage] string]];
	NSUInteger		cline	= [ls lineOfLocation:range.location];
	NSUInteger		sline, eline;
	NSDictionary	*blockTypes = [XEPPreferences blockTypes];
	NSString		*block		= [self findBlock:ls cline:cline sline:&sline eline:&eline btype:blockTypes];

	if ([block stringByReplacingOccurrencesOfRegex:@"\\s" withString:@""].length < 1) {
		return;
	}

	BOOL created = [self checkCommentCreated:ls cline:sline];

	if (!created) {
		[self insertBlockComment:tv ls:ls block:block sl:sline cursor:YES];
	}

	return;
}

#pragma mark - Show Preferences.

// the preferences window.
- (void)showPreferences:(id)sender
{
	if (nil == _preferences) {
		_preferences = [[XEPPreferences alloc] initWithWindowNibName:@"XEPPreferences" bundle:self.bundle];
	}

	[_preferences showWindow:nil];
}

- (BOOL)windowShouldClose:(id)sender
{
	return YES;
}

#pragma mark - Format
// format the code.
- (void)formatCode:(id)sender
{
	@synchronized(self) {
		@try {
			NSWindow	*nsKeyWindow	= [[NSApplication sharedApplication] keyWindow];
			NSResponder *responder		= [nsKeyWindow firstResponder];
			NSString	*resname		= [[responder class] description];

			//            NSDLog(@"forame responder name:%@",resname);
            //            NSDLog(@"pwd:%s",getenv("PWD"));
			if ([resname isEqualToString:@"DVTSourceTextView"]) {
				[self processTextViewFormat:(NSTextView *)responder];
			}

			if ([resname isEqualToString:@"IDENavigatorOutlineView"]) {
				[self processFileFormat:(NSOutlineView *)responder];
			}
		}
		@catch(NSException *exception) {
			NSELog(@"format code error:%@", [exception debugDescription]);
		}
	}
}

- (NSString *)processUncrustify:(NSString *)targetPath
{
	NSTask *task = [[NSTask alloc] init];

	[task setLaunchPath:[[XEPPreferences config] objectForKey:CFG_UNCRUSTIFY]];
	[task setEnvironment:[NSDictionary dictionaryWithObjectsAndKeys:[XEPPreferences uncrustifyCfgPath], @"UNCRUSTIFY_CONFIG", nil]];
	NSString *tp = [targetPath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSILog(@"will format file:%@", tp);
	NSArray *arguments = [NSArray arrayWithObjects:@"--frag", @"-l", @"OC", @"-f", tp, nil];
	[task setArguments:arguments];
	NSPipe *pipe, *epipe;
	pipe	= [NSPipe pipe];
	epipe	= [NSPipe pipe];
	[task setStandardOutput:pipe];
	[task setStandardError:epipe];
	NSFileHandle *file = [pipe fileHandleForReading], *efile = [epipe fileHandleForReading];
	[task launch];
	NSData		*data	= [file readDataToEndOfFile];
	NSData		*edata	= [efile readDataToEndOfFile];
	NSString	*sdata	= [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	NSString	*esdata = [[[NSString alloc] initWithData:edata encoding:NSUTF8StringEncoding] autorelease];

	if ([esdata stringByReplacingOccurrencesOfRegex:@"\\s*" withString:@""].length > 0) {
		NSELog(@"Uncrustify error log:%@", esdata);
	}

	[task release];
	return sdata;
}

- (void)processTextViewFormat:(NSTextView *)tv
{
	NSRange		range			= [tv selectedRange];
	NSString	*targetPath		= nil;
	NSString	*selectedCode	= @"";

	[[NSFileManager defaultManager] createDirectoryAtPath:@"/tmp/XEP" withIntermediateDirectories:YES attributes:nil error:nil];
	targetPath = @"/tmp/XEP/formattmp";

	if (range.length > 0) {
		selectedCode = [[[tv textStorage] string] substringWithRange:range];
	} else {
		selectedCode = [[tv textStorage] string];
	}

	if ([selectedCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
		return;
	}

	[selectedCode writeToFile:targetPath atomically:YES encoding:NSUTF8StringEncoding error:nil];

	NSString *sdata = [self processUncrustify:targetPath];

	if (sdata.length < 1) {
		return;
	}

	if (range.length < 1) {
		[tv insertText:[NSString stringWithFormat:@"%@\n", sdata] replacementRange:NSMakeRange(0, [tv.textStorage length])];
		NSLineString *ls = [NSLineString lineStringWith:tv.textStorage.string];
		range				= [ls rangeOfLineNumber:[ls lineOfLocation:range.location]];
		range.location		+= range.length;
		range.length		= 0;
		tv.selectedRange	= range;
		[tv scrollRangeToVisible:range];
	} else {
		[tv insertText:sdata replacementRange:range];
	}
}

- (void)processNavigableItem:(id)item
{
	if ([item respondsToSelector:@selector(isLeaf)] && [item isLeaf]) {
		NSString	*targetPath = [[[item fileURL] absoluteString] stringByReplacingOccurrencesOfString:@"file://localhost" withString:@""];
		NSArray		*comps		= [targetPath componentsSeparatedByString:@"."];
		NSString	*extend		= [comps objectAtIndex:[comps count] - 1];
		BOOL		contained	= NO;

		for (NSString *e in [[XEPPreferences config] objectForKey : CFG_FORMAT_FILE_EXT]) {
			if ([e isEqualToString:extend]) {
				contained = YES;
				break;
			}
		}

		if (contained) {
			NSString *sdata = [self processUncrustify:targetPath];
			[sdata writeToFile:targetPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
		}
	} else if ([[[item class] description] isEqualToString:@"IDEGroupNavigableItem"]) {
		for (id i in [item _childItems]) {
			[self processNavigableItem:i];
		}
	}
}

- (void)processFileFormat:(NSOutlineView *)ov
{
	NSIndexSet *selected = ov.selectedRowIndexes;

	for (NSUInteger idx = [selected firstIndex]; idx != NSNotFound; idx = [selected indexGreaterThanIndex:idx]) {
		id item = [ov itemAtRow:idx];
		[self processNavigableItem:item];
	}
}

#pragma mark - dealloc
- (void)dealloc
{
	IF_REL(_preferences);
	[super dealloc];
}

@end
