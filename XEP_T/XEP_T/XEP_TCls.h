//
//  XEP_TCls.h
//  XEP_T
//
//  Created by Wen ShaoHong on 10/21/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XEP_T_DEF @"abc"
#define XEP_T_A(a) getenv(a)
#define XEP_T_B(a) printf(a)
#define XEP_T_C(a,b) printf(a,b)
#define XEP_T_D(a,b,c) printf(a,b,c)

typedef enum XEP_TEnum{
    XT_A,XT_B,XT_C
}XEP_TEnum;

struct XEP_TStruct{
    int a;
    NSString *b;
    XEP_TEnum t;
}XEP_TStruct;

@protocol XEP_TPro
-(void)normalProMethod;
-(NSString*)nMet:(NSString*)arga b:(int)argb;
@end

@interface XEP_TCls : NSObject

+(void)staticMethod;
+(void)staticMethod:(NSString*)arga;
+(void)staticMethod:(NSString*)arga b:(int)argb;
+(int)sMethod:(NSString*)arga b:(int)argb;
+(NSString*)sMet:(NSString*)arga b:(int)argb;
+(void)staticMethod:(NSString*)arga b:(int)argb c:(void*)argc;

-(void)normalMethod;
-(void)normalMethod:(NSString*)arga;
-(void)normalMethod:(NSString*)arga b:(int)argb;
-(int)nMethod:(NSString*)arga b:(int)argb;
-(NSString*)nMet:(NSString*)arga b:(int)argb;
-(void)normalMethod:(NSString*)arga b:(int)argb c:(void*)argc;

@property(nonatomic,assign)int arga;
@property(nonatomic,retain)NSString* argb;
@property(nonatomic,retain)id<XEP_TPro> argc;
@end
