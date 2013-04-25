//
//  NSFLog.m
//  XEP
//
//  Created by Wen ShaoHong on 10/16/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "NSFLog.h"
static NSFLog *__flog = nil;
//
@implementation NSFLog
@synthesize fpath = _fpath, level = _level, console = _console;
+ (void)initFLog:(NSString *)path
{
	__flog = [[NSFLog alloc] initWithFilePath:path];
}

+ (NSFLog *)sharedFLog
{
	return __flog;
}

+ (void)relFLog
{
	[__flog release], __flog = nil;
}

- (id)initWithFilePath:(NSString *)path
{
	self = [super init];

	if (self) {
		_fpath = [path retain];
	}

	return self;
}

- (void)flog:(NSString *)log
{
	if (![[NSFileManager defaultManager] fileExistsAtPath:_fpath]) {
		NSError *error = nil;
		[log writeToFile:_fpath atomically:YES encoding:NSUTF8StringEncoding error:&error];
	} else {
		NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:_fpath];
		[myHandle seekToEndOfFile];
		[myHandle writeData:[log dataUsingEncoding:NSUTF8StringEncoding]];
	}

	if (_console) {
		NSLog(@"%@", log);
	}
}

- (NSFLog *)info:(NSString *)fmt, ...
	{
	if (_level >= LOG_INFO) {
		NSString	*log;
		va_list		_args;
		va_start(_args, fmt);
		log = [[NSString alloc] initWithFormat:fmt arguments:_args];
		va_end(_args);
		[self flog:[NSString stringWithFormat:@"FLog %@  %@\n", @"INFO", log]];
		[log release];
	}

	return self;
}

- (NSFLog *)debug:(NSString *)fmt, ...
	{
	if (_level >= LOG_DEBUG) {
		NSString	*log;
		va_list		_args;
		va_start(_args, fmt);
		log = [[NSString alloc] initWithFormat:fmt arguments:_args];
		va_end(_args);
		[self flog:[NSString stringWithFormat:@"FLog %@ %@\n", @"DEBUG", log]];
		[log release];
	}

	return self;
}

- (NSFLog *)warn:(NSString *)fmt, ...
	{
	if (_level >= LOG_WARNING) {
		NSString	*log;
		va_list		_args;
		va_start(_args, fmt);
		log = [[NSString alloc] initWithFormat:fmt arguments:_args];
		va_end(_args);
		[self flog:[NSString stringWithFormat:@"FLog %@  %@\n", @"WARN", log]];
		[log release];
	}

	return self;
}

- (NSFLog *)error:(NSString *)fmt, ...
	{
	if (_level >= LOG_ERROR) {
		NSString	*log;
		va_list		_args;
		va_start(_args, fmt);
		log = [[NSString alloc] initWithFormat:fmt arguments:_args];
		va_end(_args);
		[self flog:[NSString stringWithFormat:@"FLog %@ %@\n", @"ERROR", log]];
		[log release];
	}

	return self;
}

- (void)dealloc
{
	[_fpath release];
	[super dealloc];
}

@end
