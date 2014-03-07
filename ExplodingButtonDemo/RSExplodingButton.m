//
//  ERSBubbleButton.m
//
//  Created by Rudi Strahl on 1/14/2014.
//  Copyright (c) 2014 Rudi Strahl. All rights reserved.
//

#import "RSExplodingButton.h"
#import <QuartzCore/QuartzCore.h>

@interface RSExplodingButton()

@property (assign, nonatomic) CGRect defaultFrame;
@property (assign, nonatomic) CGRect explodedFrame;
@property (strong, nonatomic) NSMutableArray *leafButtons;

@end

@implementation RSExplodingButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self configureButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self configureButton];
    }
    return self;
}

- (void)configureButton
{
    _defaultColor = self.backgroundColor;
    _highlightedColor = [self tintColor];
    self.leafButtons = [NSMutableArray array];
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.borderWidth = 2;
    self.layer.borderColor = [[self tintColor] CGColor];
    _defaultFrame = self.frame;
    _explodedFrame = CGRectMake(_defaultFrame.origin.x - (_defaultFrame.size.width / 2),
                                _defaultFrame.origin.y - (_defaultFrame.size.height / 2),
                                (_defaultFrame.size.width * 2),
                                (_defaultFrame.size.height * 2));
    self.layer.masksToBounds = YES;
}

#pragma mark - Property Overrides

- (void)setHighlightedColor:(UIColor *)highlightedColor
{
    _highlightedColor = highlightedColor;
    self.layer.borderColor = [_highlightedColor CGColor];
}

#pragma mark - Method Overrides

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted)
    {
        if (!self.highlighted)
        {
            NSLog(@"highlighted");
            self.backgroundColor = _highlightedColor;
        }
    }
    else
    {
        if (self.highlighted)
        {
            NSLog(@"unhighlighted");
            [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.backgroundColor = _defaultColor;
            } completion:nil];
        }
    }
    [super setHighlighted:highlighted];
}

- (void)setDefaultColor:(UIColor *)defaultColor
{
    _defaultColor = defaultColor;
    self.backgroundColor = _defaultColor;
}

#pragma mark - Add/Remove Sub-Buttons

- (RSExplodingButton *)addButton
{
    RSExplodingButton *button = [[RSExplodingButton alloc] initWithFrame:self.frame];
    [button setHighlightedColor:_highlightedColor];
    [button setDefaultColor:_defaultColor];
    button.titleLabel.font = self.titleLabel.font;
    [button setTitleColor:[self titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
    [button setTitleColor:[self titleColorForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    [self.leafButtons addObject:button];
    if (self.superview)
    {
        [self.superview insertSubview:button belowSubview:self];
    }
    button.alpha = 0.0f;
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
    [self sendActionsForControlEvents:UIControlEventTouchDown];
    [self explodeButton];
    [self setHighlighted:YES];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touches Cancelled");
    [self implodeButton];
    [self setHighlighted:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touches ended");
    UITouch *touch = [touches anyObject];
    if ([self hitTest:[touch locationInView:self] withEvent:event])
    {
        NSLog(@"Touch ended in root button");
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        for (UIControl *button in _leafButtons)
        {
            if([[self hitTest:[touch locationInView:button] withEvent:event] isKindOfClass:[RSExplodingButton class]])
            {
                NSLog(@"touch detected on button");
                [button setHighlighted:NO];
                [button sendActionsForControlEvents:UIControlEventTouchUpInside];
                [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
                break;
            }
        }
    }
    [self implodeButton];
    [self setHighlighted:NO];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touches moved");
    UITouch *touch = [touches anyObject];
    for (UIControl *button in _leafButtons)
    {
        if([[self hitTest:[touch locationInView:button] withEvent:event] isKindOfClass:[RSExplodingButton class]])
        {
            NSLog(@"Touch detected on leaf button");
            [button setHighlighted:YES];
            break;
        }
        else
        {
            [button setHighlighted:NO];
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
//            button.hidden = NO;
            if (IS_EARLIER_THAN_OS7)
            {
                [UIView animateWithDuration:0.15f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     button.frame = CGRectOffset(button.frame, newX, newY);
                                     button.alpha = 1.0f;
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
                                     button.alpha = 1.0f;
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
                                 button.alpha = 0.0f;
                             } completion:^(BOOL completed) {
                             }];
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
                                 button.alpha = 0.0f;
                             } completion:^(BOOL completed) {
                             }];
        }
    }
}

@end
