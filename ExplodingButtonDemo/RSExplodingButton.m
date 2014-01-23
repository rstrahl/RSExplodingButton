//
//  ERSBubbleButton.m
//
//  Created by Rudi Strahl on 1/14/2014.
//  Copyright (c) 2014 Rudi Strahl. All rights reserved.
//

#import "RSExplodingButton.h"
#import <QuartzCore/QuartzCore.h>

@interface RSExplodingButton()

@property (nonatomic, assign) CGRect            defaultFrame;
@property (nonatomic, assign) CGRect            explodedFrame;
@property (nonatomic, strong) NSMutableArray    *leafButtons;

@end

@implementation RSExplodingButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self configureFrame];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self configureFrame];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *color = [UIColor blueColor];
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, self.bounds);
}

- (void)configureFrame
{
    self.leafButtons = [NSMutableArray array];
    self.layer.cornerRadius = self.frame.size.width / 2;
    _defaultFrame = self.frame;
    _explodedFrame = CGRectMake(_defaultFrame.origin.x - (_defaultFrame.size.width / 2),
                                _defaultFrame.origin.y - (_defaultFrame.size.height / 2),
                                (_defaultFrame.size.width * 2),
                                (_defaultFrame.size.height * 2));
    self.layer.masksToBounds = YES;
}

#pragma mark - Add/Remove Sub-Buttons

- (RSExplodingButton *)addButton
{
    RSExplodingButton *button = [[RSExplodingButton alloc] initWithFrame:self.frame];
    [self.leafButtons addObject:button];
    if (self.superview)
    {
        [self.superview insertSubview:button belowSubview:self];
    }
    return button;
}

- (RSExplodingButton *)addButtonWithTitle:(NSString *)title
{
    RSExplodingButton *button = [self addButton];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

- (RSExplodingButton *)addButtonWithIcon:(UIImage *)image
{
    RSExplodingButton *button = [self addButton];
    [button setImage:image forState:UIControlStateNormal];
    return button;
}

#pragma mark - Responder Chain

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touches began");
    [self explodeButton];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touches Cancelled");
    [self implodeButton];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touches ended");
    [self implodeButton];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touches moved");
    UITouch *touch = [touches anyObject];
    for (UIControl *button in _leafButtons)
    {
        if([[self hitTest:[touch locationInView:button] withEvent:event] isKindOfClass:[RSExplodingButton class]])
        {
            NSLog(@"touch detected on button");
        }
    }
}

#pragma mark - Animations

- (void)explodeButton
{
    if (self.leafButtons.count > 0)
    {
        CGFloat width = self.frame.size.width;
        CGFloat distance = width + 10;
        CGFloat angleIncrement = (360 / self.leafButtons.count) * M_PI / 180;
        CGFloat angle = M_PI_4;
        for (RSExplodingButton *button in _leafButtons)
        {
            CGFloat newX = (distance * cosf(angle));
            CGFloat newY = (distance * sinf(angle));
            if (IS_EARLIER_THAN_OS7)
            {
                [UIView animateWithDuration:0.15f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     button.frame = CGRectOffset(button.frame, newX, newY);
                                 } completion:nil];
            }
            else
            {
                [UIView animateWithDuration:0.4f
                                      delay:0.0f
                     usingSpringWithDamping:0.5f
                      initialSpringVelocity:0.5f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     button.frame = CGRectOffset(button.frame, newX, newY);
                                 } completion:nil];
            }
            angle += angleIncrement;
        }
    }
}

- (void)implodeButton
{
    for (RSExplodingButton *button in _leafButtons)
    {
        if (IS_EARLIER_THAN_OS7)
        {
            [UIView animateWithDuration:0.15f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 button.frame = _defaultFrame;
                             } completion:nil];
        }
        else
        {
            [UIView animateWithDuration:0.4f
                                  delay:0.0f
                 usingSpringWithDamping:0.8f
                  initialSpringVelocity:0.5f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 button.frame = _defaultFrame;
                             } completion:nil];
        }
    }
}

- (void)explodeAnimation
{
    if (IS_EARLIER_THAN_OS7)
    {
        [UIView animateWithDuration:0.15f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [self setFrame:_explodedFrame];
                             self.layer.cornerRadius = _explodedFrame.size.width / 2;
                         } completion:nil];
    }
    else
    {
        [UIView animateWithDuration:0.4f
                              delay:0.0f
             usingSpringWithDamping:0.5f
              initialSpringVelocity:0.5f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
                         } completion:nil];
    }
}

- (void)implodeAnimation
{
    if (IS_EARLIER_THAN_OS7)
    {
        [UIView animateWithDuration:0.15f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [self setFrame:_defaultFrame];
                             self.layer.cornerRadius = _defaultFrame.size.width / 2;
                         } completion:nil];
    }
    else
    {
        [UIView animateWithDuration:0.4f
                              delay:0.0f
             usingSpringWithDamping:0.6f
              initialSpringVelocity:0.5f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         } completion:nil];
    }
}

@end
