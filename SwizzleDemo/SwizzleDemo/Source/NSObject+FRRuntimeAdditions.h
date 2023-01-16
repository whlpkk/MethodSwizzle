//
//  NSObject+FRRuntimeAdditions.h
//  SwizzleDemo
//
//  Created by YZK on 2023/1/16.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (FRRuntimeAdditions)

+ (void)swizzleInstanceMethod:(SEL)originalSEL with:(SEL)replacementSEL;
+ (void)swizzleClassMethod:(SEL)originalSEL with:(SEL)replacementSEL;

@end
