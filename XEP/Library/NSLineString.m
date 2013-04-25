//
//  NSLineString.m
//  Centny
//
//  Created by Centny on 10/13/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "NSLineString.h"

@implementation NSLineString
@synthesize targetStr = _targetStr, lines = _lines;
+ (id)lineStringWith:(NSString *)targetStr
{
	return [[[NSLineString alloc] initWithString:targetStr] autorelease];
}

- (id)initWithString:(NSString *)targetStr
{
	self = [super init];

	if (self) {
		_lines			= [[NSMutableArray alloc] init];
		_linesLocation	= [[NSMutableArray alloc] init];
		self.targetStr	= targetStr;
	}

	return self;
}

- (NSRange)rangeOfLineNumber:(NSUInteger)line
{
	if (line > [_lines count]) {
		NSLog(@"line is out of the arrary");
		return NSMakeRange(NSNotFound, 0);
	}

	return NSMakeRange([[_linesLocation objectAtIndex:line] longLongValue], [[_lines objectAtIndex:line] length]);
}

- (NSString *)stringOfLineNumber:(NSUInteger)line
{
	return [_targetStr substringWithRange:[self rangeOfLineNumber:line]];
}

- (NSUInteger)lineOfLocation:(unsigned long long)loc
{
	NSUInteger	lcount	= [_linesLocation count];
	NSUInteger	line	= lcount;

	for (NSUInteger i = 0; i < lcount; i++) {
		if (loc < [[_linesLocation objectAtIndex:i] longLongValue]) {
			line = i;
			break;
		}
	}

	return line - 1;
}

- (NSUInteger)lineCount
{
	return [_lines count];
}

- (NSString *)lastLine
{
	return [_lines objectAtIndex:[_lines count] - 1];
}

- (void)setTargetStr:(NSString *)targetStr
{
	[_lines removeAllObjects];
	[_linesLocation removeAllObjects];
	[_lines addObjectsFromArray:[targetStr componentsSeparatedByString:@"\n"]];
	_targetStr = [targetStr retain];
	NSNumber *old = [NSNumber numberWithUnsignedLongLong:0];
	[_linesLocation addObject:old];

	for (NSString *line in _lines) {
		old = [NSNumber numberWithUnsignedLongLong:([old longLongValue] + line.length + 1)];
		[_linesLocation addObject:old];
	}

	//    NSLog(@"line count:%ld",[_lines count]);
}

- (void)dealloc
{
	[_targetStr release];
	[_lines release];
	[_linesLocation release];
	[super dealloc];
}

@end
