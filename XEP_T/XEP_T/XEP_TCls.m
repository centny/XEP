//
//  XEP_TCls.m
//  XEP_T
//
//  Created by Wen ShaoHong on 10/21/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import "XEP_TCls.h"

@implementation XEP_TCls
+(void)staticMethod{
    
}
+(void)staticMethod:(NSString*)arga{
    
}
+(void)staticMethod:(NSString*)arga b:(int)argb{
    
}
+(int)sMethod:(NSString*)arga b:(int)argb{
    return 0;
}
+(NSString*)sMet:(NSString*)arga b:(int)argb{
    return @"";
}
+(void)staticMethod:(NSString*)arga b:(int)argb c:(void*)argc{
    
}

-(void)normalMethod{
    
}
-(void)normalMethod:(NSString*)arga{
    
}
-(void)normalMethod:(NSString*)arga b:(int)argb{
    
}
-(int)nMethod:(NSString*)arga b:(int)argb{
    return 1;
}
-(NSString*)nMet:(NSString*)arga b:(int)argb{
    return @"";
}
-(void)normalMethod:(NSString*)arga b:(int)argb c:(void*)argc{
    
}
@end
