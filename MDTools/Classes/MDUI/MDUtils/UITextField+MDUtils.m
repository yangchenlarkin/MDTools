//
//  UITextField+MDUtils.m
//  RideSharing
//
//  Created by 杨晨 on 2019/5/17.
//  Copyright © 2019 allride.ai. All rights reserved.
//

#import "UITextField+MDUtils.h"
#import <objc/runtime.h>

@implementation UITextField (utils)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class aClass = [self class];
        
        SEL originalSelector = @selector(drawPlaceholderInRect:);
        SEL swizzledSelector = @selector(_drawPlaceholderInRect:);
        
        Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector);
        BOOL didAddMethod =
        class_addMethod(aClass,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(aClass,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)_drawPlaceholderInRect:(CGRect)rect {
    UIFont *font = self.placeholderFont ?: self.font;
    UIColor *color = self.placeholderColor ?: self.textColor;
    NSUnderlineStyle underlineStyle = self.placeholderUnderlineStyle;
    
    CGSize placeholderSize = [self.placeholder sizeWithAttributes:@{NSFontAttributeName:font}];
    
    [self.placeholder drawInRect:CGRectMake(0,
                                            (rect.size.height - placeholderSize.height)/2,
                                            rect.size.width,
                                            rect.size.height)
                  withAttributes:@{NSForegroundColorAttributeName:color,
                                   NSFontAttributeName:font,
                                   NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:underlineStyle],
                                   }];
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    UIFont *_font = objc_getAssociatedObject(self, "placeholderFont");
    if (_font != placeholderFont) {
        _font = placeholderFont;
        objc_setAssociatedObject(self, _cmd, _font, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [self setNeedsDisplay];
    }
}

- (UIFont *)placeholderFont {
    return objc_getAssociatedObject(self, "placeholderFont");
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    UIColor *_color = objc_getAssociatedObject(self, "placeholderColor");
    if (_color != placeholderColor) {
        _color = placeholderColor;
        objc_setAssociatedObject(self, "placeholderColor", _color, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [self setNeedsDisplay];
    }
}

- (UIColor *)placeholderColor {
    return objc_getAssociatedObject(self, "placeholderColor");
}

- (void)setPlaceholderUnderlineStyle:(NSUnderlineStyle)placeholderUnderlineStyle {
    if (self.placeholderUnderlineStyle != placeholderUnderlineStyle) {
        objc_setAssociatedObject(self, "placeholderUnderline", [NSNumber numberWithInteger:placeholderUnderlineStyle], OBJC_ASSOCIATION_COPY_NONATOMIC);
        [self setNeedsDisplay];
    }
}

- (NSUnderlineStyle)placeholderUnderlineStyle {
    return [objc_getAssociatedObject(self, "placeholderUnderline") integerValue];;
}

@end
