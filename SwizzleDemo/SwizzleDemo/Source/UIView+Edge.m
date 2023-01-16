//
//  UIView+Edge.m
//  SwizzleDemo
//
//  Created by YZK on 2023/1/16.
//

#import "UIView+Edge.h"
#import <objc/runtime.h>
#import "NSObject+FRRuntimeAdditions.h"

@implementation UIView (Edge)

+ (void)load
{
    [self swizzleInstanceMethod:@selector(pointInside:withEvent:)
                           with:@selector(yzk_pointInside:withEvent:)];
}

- (void)setYzk_responseEdge1:(UIEdgeInsets)yzk_responseEdge1 {
    objc_setAssociatedObject(self, @selector(yzk_responseEdge1), [NSValue valueWithUIEdgeInsets:yzk_responseEdge1], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)yzk_responseEdge1 {
    NSValue *value = objc_getAssociatedObject(self, _cmd);
    return value ? [value UIEdgeInsetsValue] : UIEdgeInsetsZero;
}

- (BOOL)yzk_pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event {
    BOOL inside = [self yzk_pointInside:point withEvent:event];
    if (inside) {
        return YES;
    }

    CGRect hitFrame = UIEdgeInsetsInsetRect(self.bounds, self.yzk_responseEdge1);
    return CGRectContainsPoint(hitFrame, point);
}




@end
