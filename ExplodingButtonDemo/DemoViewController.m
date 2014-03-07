//
//  ERSViewController.m
//  BubbleButtonDemo
//
//  Created by Rudi Tactica on 1/13/2014.
//  Copyright (c) 2014 Rudi Strahl. All rights reserved.
//

#import "DemoViewController.h"
#import "RSExplodingButton.h"

@interface DemoViewController ()
@property (nonatomic, weak) IBOutlet RSExplodingButton   *explodingButton;
@property (weak, nonatomic) IBOutlet UILabel *infoTextLabel;
@end

#pragma mark - UIViewController Lifecycle

@implementation DemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_explodingButton setTitle:@"0" forState:UIControlStateNormal];
    for (int i = 0; i < 4; i++)
    {
        RSExplodingButton *button = [self.explodingButton addButtonWithTitle:[NSString stringWithFormat:@"%d", i+1]];
        [button addTarget:self action:@selector(didTouchUpButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)didTouchDownButton:(id)sender
{
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.infoTextLabel.alpha = 0;
    } completion:^(BOOL finished) {
        self.infoTextLabel.text = @"...Drag finger to option and release";
        [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.infoTextLabel.alpha = 1.0f;
        } completion:nil];
    }];
}

- (IBAction)didTouchUpRootButton:(id)sender
{
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.infoTextLabel.alpha = 0;
    } completion:^(BOOL finished) {
        self.infoTextLabel.text = @"Tap and Hold to Activate...";
        [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.infoTextLabel.alpha = 1.0f;
        } completion:nil];
    }];
}

- (IBAction)didTouchUpButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    UIAlertView *buttonTapAlert = [[UIAlertView alloc] initWithTitle:@"Button Tapped"
                                                             message:[NSString stringWithFormat:@"Button %@ was tapped", button.titleLabel.text]
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
    [buttonTapAlert show];
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.infoTextLabel.alpha = 0;
    } completion:^(BOOL finished) {
        self.infoTextLabel.text = @"Tap and Hold to Activate...";
        [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.infoTextLabel.alpha = 1.0f;
        } completion:nil];
    }];
}

@end
