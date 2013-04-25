//
//  XEPCfg.m
//  XEP
//
//  Created by Wen ShaoHong on 10/19/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "XEPCfg.h"
#import "NSLineString.h"
#import "XEPDef.h"

@implementation NSMutableDictionary (XEPCfg)
- (id)initWithCfgFile:(NSString *)filePath
{
	self = [self init];

	if (self) {
		if (filePath == nil) {
			NSELog(@"the configure file path is null:%@", filePath);
			return self;
		}

		BOOL isDirectory = NO, fexist = NO;
		fexist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];

		if (isDirectory) {
			NSELog(@"the configure file is directory:%@", filePath);
			return self;
		}

		if (!fexist) {
			NSELog(@"the configure file is not exist:%@", filePath);
			return self;
		}

		NSError		*error	= nil;
		NSString	*data	= [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];

		if (error) {
			NSELog(@"read configure error:%@", error);
			return self;
		}

		NSLineString *ls = [NSLineString lineStringWith:data];

		for (NSString *line in ls.lines) {
			line = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

			if (line.length < 1) {
				continue;
			}

			if ('#' == [line characterAtIndex:0]) {
				continue;
			}

			NSArray *as = [line componentsSeparatedByString:@"="];

			if (as.count < 2) {
				continue;
			}

			[self setObject:[as[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:[as[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
		}
	}

	return self;
}

@end
