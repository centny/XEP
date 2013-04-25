//
//  NSLineString.h
//  Centny
//
//  Created by Wen ShaoHong on 10/13/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSLineString : NSObject {
	NSString		*_targetStr;
	NSMutableArray	*_lines;
	NSMutableArray	*_linesLocation;
}
+ (id)lineStringWith:(NSString *)targetStr;
- (id)initWithString:(NSString *)targetStr;
- (NSRange)rangeOfLineNumber:(NSUInteger)line;
- (NSString *)stringOfLineNumber:(NSUInteger)line;
- (NSUInteger)lineOfLocation:(unsigned long long)loc;
- (NSUInteger)lineCount;
- (NSString *)lastLine;
@property (nonatomic, retain) NSString	*targetStr;
@property (nonatomic, readonly) NSArray *lines;
@end
