//
//  UIView+HYDraggable.m
//  HYDraggableView-master
//
//  Created by 黄海燕 on 16/9/29.
//  Copyright © 2016年 huanghy. All rights reserved.
//

#import "UIView+HYDraggable.h"
#import <objc/runtime.h>
@implementation UIView (HYDraggable)

- (void)makeDraggable
{
    NSAssert(self.superview, @"Super view is required when make view draggable");
    [self makeDraggableInView:self.superview damping:0.4];
}

- (void)makeDraggableInView:(UIView *)view damping:(CGFloat)damping
{
    if (!view) return;
    
    [self removeDraggable];
    self.hy_playground = view;
    self.hy_damping = damping;
    
    [self hy_creatAnimator];
    [self hy_addPangesture];
    
}

- (void)removeDraggable
{
    [self removeGestureRecognizer:self.hy_panGesture];
    self.hy_panGesture = nil;
    self.hy_playground = nil;
    self.hy_snapBehavior = nil;
    self.hy_attachmentBehavior = nil;
    self.hy_centerPoint = CGPointZero;
}

- (void)updateSnapPoint
{
    self.hy_centerPoint = [self convertPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) toView:self.hy_playground];
    self.hy_snapBehavior = [[UISnapBehavior alloc]initWithItem:self snapToPoint:self.hy_centerPoint];
    self.hy_snapBehavior.damping = self.hy_damping;
}

- (void)hy_creatAnimator
{
    self.hy_animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.hy_playground];
    [self updateSnapPoint];
}

- (void)hy_addPangesture
{
    self.hy_panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(hy_panGesture:)];
    [self addGestureRecognizer:self.hy_panGesture];
}

#pragma mark - Gesture
- (void)hy_panGesture:(UIPanGestureRecognizer *)panGesture
{
    CGPoint panLocation = [panGesture locationInView:self.hy_playground];
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        UIOffset offset = UIOffsetMake(panLocation.x - self.hy_centerPoint.x, panLocation.y - self.hy_centerPoint.y);
        [self.hy_animator removeAllBehaviors];
        self.hy_attachmentBehavior = [[UIAttachmentBehavior alloc]initWithItem:self offsetFromCenter:offset attachedToAnchor:panLocation];
        [self.hy_animator addBehavior:self.hy_attachmentBehavior];
    }else if (panGesture.state == UIGestureRecognizerStateChanged){
        [self.hy_attachmentBehavior setAnchorPoint:panLocation];
    }else if(panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled || panGesture.state == UIGestureRecognizerStateFailed){
        [self.hy_animator removeAllBehaviors];
        [self.hy_animator addBehavior:self.hy_snapBehavior];
    }
}

#pragma mark - Associated Object
- (void)setHy_playground:(id)object{
    objc_setAssociatedObject(self, @selector(hy_playground), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)hy_playground{
    return objc_getAssociatedObject(self, @selector(hy_playground));
}

- (void)setHy_animator:(id)object{
    objc_setAssociatedObject(self, @selector(hy_animator), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIDynamicAnimator *)hy_animator{
    return objc_getAssociatedObject(self, @selector(hy_animator));
}

- (void)setHy_snapBehavior:(id)object{
    objc_setAssociatedObject(self, @selector(hy_snapBehavior), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UISnapBehavior *)hy_snapBehavior{
    return objc_getAssociatedObject(self, @selector(hy_snapBehavior));
}

- (void)setHy_attachmentBehavior:(id)object{
    objc_setAssociatedObject(self, @selector(hy_attachmentBehavior), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIAttachmentBehavior *)hy_attachmentBehavior{
    return objc_getAssociatedObject(self, @selector(hy_attachmentBehavior));
}

- (void)setHy_panGesture:(id)object{
    objc_setAssociatedObject(self, @selector(hy_panGesture), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIPanGestureRecognizer *)hy_panGesture{
    return objc_getAssociatedObject(self, @selector(hy_panGesture));
}

- (void)setHy_centerPoint:(CGPoint)point{
    objc_setAssociatedObject(self, @selector(hy_centerPoint), [NSValue valueWithCGPoint:point], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGPoint)hy_centerPoint{
    return [objc_getAssociatedObject(self, @selector(hy_centerPoint)) CGPointValue];
}

- (void)setHy_damping:(CGFloat)object{
    objc_setAssociatedObject(self, @selector(hy_damping), @(object), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)hy_damping{
    return [objc_getAssociatedObject(self, @selector(hy_damping)) floatValue];
}

@end
