//
//  ERSBubbleButton.h
//
//  Created by Rudi Strahl on 1/14/2014.
//  Copyright (c) 2014 Rudi Strahl. All rights reserved.
//

#define IS_EARLIER_THAN_OS7 ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)

#import <UIKit/UIKit.h>

@interface RSExplodingButton : UIButton

- (RSExplodingButton *)addButton;
- (RSExplodingButton *)addButtonWithTitle:(NSString *)title;
- (RSExplodingButton *)addButtonWithIcon:(UIImage *)image;

@end
