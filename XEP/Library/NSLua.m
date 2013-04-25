//
//  NSLua.m
//  XEP
//
//  Created by Wen ShaoHong on 10/13/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "NSLua.h"

@implementation NSLua
@synthesize l = _l;
+ (id)luaWithFile:(const char *)file
{
	return [[[NSLua alloc] initWithFile:file] autorelease];
}

- (id)initWithFile:(const char *)file
{
	self = [self init];

	if (self) {
		[self dofile:file];
	}

	return self;
}

- (id)init
{
	self = [super self];

	if (self) {
		_l = luaL_newstate();
		luaL_openlibs(_l);
	}

	return self;
}

- (void)dofile:(const char *)file
{
	luaL_dofile(_l, file);
}

- (void)getglobal:(const char *)s
{
	lua_getglobal(_l, s);
}

- (void)pushnil
{
	lua_pushnil(_l);
}

- (void)pushnumber:(lua_Number)n
{
	lua_pushnumber(_l, n);
}

- (void)pushinteger:(lua_Integer)i
{
	lua_pushinteger(_l, i);
}

- (void)pushlstring:(const char *)s len:(size_t)len
{
	lua_pushlstring(_l, s, len);
}

- (void)pushstring:(const char *)s
{
	lua_pushstring(_l, s);
}

- (void)pushNSString:(NSString *)s
{
	[self pushlstring:[s UTF8String] len:s.length];
}

- (void)pushboolean:(bool)b
{
	lua_pushboolean(_l, b);
}

- (void)pushcfunction:(void *)func
{
	lua_pushcfunction(_l, func);
}

- (void)settable:(int)idx
{
	lua_settable(_l, idx);
}

- (void)setglobal:(const char *)k
{
	lua_setglobal(_l, k);
}

//
- (lua_Number)tonumber:(int)idx
{
	return lua_tonumber(_l, idx);
}

- (lua_Integer)tointeger:(int)idx
{
	return lua_tointeger(_l, idx);
}

- (int)toboolean:(int)idx
{
	return lua_toboolean(_l, idx);
}

- (const char *)tolstring:(int)idx len:(size_t *)len
{
	return lua_tolstring(_l, idx, len);
}

- (NSString *)toNSString:(int)idx
{
	size_t		len;
	const char	*data = [self tolstring:idx len:&len];

	return [[[NSString alloc] initWithBytes:data length:len encoding:NSUTF8StringEncoding] autorelease];
}

- (size_t)objlen:(int)idx
{
	return lua_objlen(_l, idx);
}

- (lua_State *)tothread:(int)idx
{
	return lua_tothread(_l, idx);
}

- (const void *)topointer:(int)idx
{
	return lua_topointer(_l, idx);
}

- (void)call:(int)nargs nrs:(int)nresults
{
	lua_call(_l, nargs, nresults);
}

- (void)pcall:(int)nargs nrs:(int)nresults
{
	lua_pcall(_l, nargs, nresults, 0);
}

- (void)pop:(int)n
{
	lua_pop(_l, n);
}

- (void)dealloc
{
	lua_close(_l);
	[super dealloc];
}

@end
