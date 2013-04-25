//
//  XEPLua.h
//  XEP
//
//  Created by Wen ShaoHong on 10/20/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSLua.h"
#import "XEPCfg.h"
#import "XEPPreferences.h"
@interface XEPLua : NSLua {
	NSMutableDictionary *_cfg;
}
+ (id)luaWithPrjPath:(NSString *)path;
- (id)initWithPrjPath:(NSString *)path;
@property (nonatomic, readonly) NSDictionary *cfg;
@end
