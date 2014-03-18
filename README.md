RSExplodingButton
=================

A custom UIButton inspired by the ["radial menu"](http://en.wikipedia.org/wiki/Pie_menu) that displays any number of subordinate buttons ("leaf buttons") when tapped and held.

<p align="center"><img src="https://s3.amazonaws.com/me.rudistrahl/images/RSExplodingButtonAnimatedSample.gif" alt="RSExplodingButton Sample Animation" /></p>

It's designed to be a drop-in replacement for UIButton, supporting `UIControlEvent` for user-interaction and `UIControlState` for controlling its changes in appearance.  Thus it supports being used and configured from Interface-Builder as well as directly from code.

A simple interactive demo project is included.

## Usage:

### Initialization

Creating a button via code can be accomplished as follows:

```objc
RSExplodingButton *button = [RSExplodingButton alloc] initWithFrame:frame];
[self.view addSubview:button];
```

### Adding leaf-buttons

Adding a leaf button is done through instance methods that duplicates the appearance of the root button. As with standard UIButton controls, a leaf button will require a method selector to be provided for responding to touch events:

```objc
for (int i = 0; i < numberOfButtonsDesired; i++)
{
    RSExplodingButton *button = [self.explodingButton addButtonWithTitle:[NSString stringWithFormat:@"%d", i+1]];
    [button addTarget:self action:@selector(didTouchUpButton:) forControlEvents:UIControlEventTouchUpInside];
}
```

### Appearance

By default, the button assumes the `tintColor` property as the fill color for its highlighted state and the `backgroundColor` as the fill color for its normal state.  When the button is highlighted, the colors inverse.

The button appearance can be customized in the following ways:

- `setDefaultColor:` will update the background color of the button for `UIControlStateNormal`
- `setHighlightColor:` will update the tint color for `UIControlStateNormal` and the background color for `UIControlStateHighlighted`
