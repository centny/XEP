//
//  NSFLog.h
//  XEP
//
//  Created by Centny on 10/16/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum LogLevel {
	LOG_ERROR = 1, LOG_WARNING, LOG_INFO, LOG_DEBUG
} LogLevel;
#define FLOG_INFO(fmt, ...)		[[NSFLog sharedFLog] info : fmt, __VA_ARGS__]
#define FLOG_DEBUG(fmt, ...)	[[NSFLog sharedFLog] debug : fmt, __VA_ARGS__]
#define FLOG_WARN(fmt, ...)		[[NSFLog sharedFLog] warn : fmt, __VA_ARGS__]
#define FLOG_ERROR(fmt, ...)	[[NSFLog sharedFLog] error : fmt, __VA_ARGS__]

/**
 *    the log class for write log to file.
 *    @author Wen ShaoHong
 */
@interface NSFLog : NSObject {
	NSString	*_fpath;
	LogLevel	_level;
	BOOL		_console;
}
+ (void)initFLog:(NSString *)path;
+ (NSFLog *)sharedFLog;
+ (void)relFLog;
- (id)initWithFilePath:(NSString *)path;
- (NSFLog *)info:(NSString *)fmt, ...;
- (NSFLog *)debug:(NSString *)fmt, ...;
- (NSFLog *)error:(NSString *)fmt, ...;
- (NSFLog *)warn:(NSString *)fmt, ...;
@property (nonatomic, readonly) NSString	*fpath;
@property (nonatomic, assign) LogLevel		level;
@property (nonatomic, assign) BOOL			console;
@end
