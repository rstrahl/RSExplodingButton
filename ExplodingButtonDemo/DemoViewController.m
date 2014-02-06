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
@end

#pragma mark - UIViewController Lifecycle

@implementation DemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_explodingButton setHighlightedColor:[UIColor redColor]];
    for (int i = 0; i < 4; i++)
    {
        RSExplodingButton *button = [self.explodingButton addButtonWithTitle:[NSString stringWithFormat:@"%d", i]];
        [button addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)buttonWasPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    UIAlertView *buttonTapAlert = [[UIAlertView alloc] initWithTitle:@"Button Tapped"
                                                             message:[NSString stringWithFormat:@"Button %@ was tapped", button.titleLabel.text]
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
    [buttonTapAlert show];
}

@end
