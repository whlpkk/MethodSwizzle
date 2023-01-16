//
//  UIButton+Edge.m
//  SwizzleDemo
//
//  Created by YZK on 2023/1/16.
//

#import "UIButton+Edge.h"
#import <objc/runtime.h>
#import "NSObject+FRRuntimeAdditions.h"

@implementation UIButton (Edge)


+ (void)load
{
    [self swizzleInstanceMethod:@selector(pointInside:withEvent:)
                           with:@selector(yzk2_pointInside:withEvent:)];
}

- (void)setYzk_responseEdge2:(UIEdgeInsets)yzk_responseEdge2 {
    objc_setAssociatedObject(self, @selector(yzk_responseEdge2), [NSValue valueWithUIEdgeInsets:yzk_responseEdge2], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)yzk_responseEdge2 {
    NSValue *value = objc_getAssociatedObject(self, _cmd);
    return value ? [value UIEdgeInsetsValue] : UIEdgeInsetsZero;
}

- (BOOL)yzk2_pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event {
    BOOL inside = [self yzk2_pointInside:point withEvent:event];
    if (inside) {
        return YES;
    }
    CGRect hitFrame = UIEdgeInsetsInsetRect(self.bounds, self.yzk_responseEdge2);
    return CGRectContainsPoint(hitFrame, point);
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    return [super pointInside:point withEvent:event];
//}

@end
