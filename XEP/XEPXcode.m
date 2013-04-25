//
//  XEPXcode.m
//  XEP
//
//  Created by Wen ShaoHong on 10/19/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "XEPXcode.h"

@implementation XEPXcode
+ (NSURL *)fileURLForSourceTextView:(id)tv
{
	id		tvdelegate	= [tv delegate];
	NSURL	*tfile		= [[tvdelegate sourceCodeDocument] fileURL];

	return tfile;
}

+ (NSString *)filePathForSourceTextView:(id)tv
{
	NSString *fpath = [[self fileURLForSourceTextView:tv] absoluteString];

	return [fpath stringByReplacingOccurrencesOfString:@"file://localhost" withString:@""];
}

+ (NSString *)filePathForProject:(id)prj name:(NSString *)name
{
	return [[prj fileReferenceForFileName:name] resolvedAbsolutePath];
}

@end
