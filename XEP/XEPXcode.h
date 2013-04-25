//
//  XEPXcode.h
//  XEP
//
//  Created by Wen ShaoHong on 10/19/12.
//  Copyright (c) 2012 Centny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XEPDef.h"

@protocol XEPDef <NSObject>
- (id)resolvedAbsolutePath;
- (NSURL *)documentURL;
- (NSArray *)_childItems;
- (id)documentType;
- (id)fileReference;
- (BOOL)isMajorGroup;
- (BOOL)isLeaf;
- (void)commentAndUncommentCurrentLines:(id)o;
- (NSUInteger)_currentLineNumber;
- (id)fileReferenceForFileName:(NSString *)name;
- (id)sourceCodeDocument;
@end

@interface XEPXcode : NSObject
+ (NSString *)filePathForSourceTextView:(id)tv;
+ (NSURL *)fileURLForSourceTextView:(id)tv;
+ (NSString *)filePathForProject:(id)prj name:(NSString *)name;
@end
