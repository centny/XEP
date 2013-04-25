//
//  NSLua.h
//  XEP
//
//  Created by Wen ShaoHong on 10/13/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
@interface NSLua : NSObject {
	lua_State *_l;
}
@property (nonatomic, readonly) lua_State *l;
+ (id)luaWithFile:(const char *)file;
- (id)initWithFile:(const char *)file;
- (void)dofile:(const char *)file;
- (void)getglobal:(const char *)s;
- (void)pushnil;
- (void)pushnumber:(lua_Number)n;
- (void)pushinteger:(lua_Integer)i;
- (void)pushlstring:(const char *)s len:(size_t)len;
- (void)pushstring:(const char *)s;
- (void)pushNSString:(NSString *)s;
- (void)pushboolean:(bool)b;
- (void)pushcfunction:(void *)func;
- (void)settable:(int)idx;
- (void)setglobal:(const char *)k;
//
- (lua_Number)tonumber:(int)idx;
- (lua_Integer)tointeger:(int)idx;
- (int)toboolean:(int)idx;
- (const char *)tolstring:(int)idx len:(size_t *)len;
- (NSString *)toNSString:(int)idx;
- (size_t)objlen:(int)idx;
- (lua_State *)tothread:(int)idx;
- (const void *)topointer:(int)idx;
//
- (void)call:(int)nargs nrs:(int)nresults;
- (void)pcall:(int)nargs nrs:(int)nresults;
//
- (void)pop:(int)n;
@end
