//
//  MainViewController.m
//  TVOut
//
//  Created by john goodstadt on 05/09/2012.
//  Copyright (c) 2012 John Goodstadt. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "MainViewController.h"


@interface MainViewController ()

@end

@implementation MainViewController

@synthesize rightSlider,rightLabel,leftSlider, leftLabel;
@synthesize topSlider,topLabel,bottomSlider, bottomLabel;

@synthesize externalDisplayHandler=_externalDisplayHandler;
@synthesize redSquare,redSquareTV,yellowBorder;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
  
    
    /*Quick test - is a TV attached?*/    
    if(ExternalDisplayHandler.monitorExists)
         NSLog(@"TV is attached");
     else 
         NSLog(@"TV is not attached");
     
 
    //Step 1
    self.externalDisplayHandler = [[ExternalDisplayHandler alloc] init];
    self.externalDisplayHandler.delegate = self;    
    
    /*now 'contentView' is available for adding any of your UIViews */
    
    
    CGSize TVSize = self.externalDisplayHandler.contentView.bounds.size;    
    NSLog(@"external screen of size:%@ ",NSStringFromCGSize(TVSize));
    

    
     //Step 2 
     /* Add red square to the centre*/
    self.redSquareTV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    self.redSquareTV.backgroundColor = [UIColor redColor];
    self.redSquareTV.center = self.externalDisplayHandler.contentView.center;
    
    NSLog(@"%@",NSStringFromCGRect( self.redSquareTV.frame));
    
    [self.externalDisplayHandler.contentView addSubview:self.redSquareTV];
    
    CGRect fullScreen = self.externalDisplayHandler.contentView.frame;
       
    self.yellowBorder = [[UIView alloc] initWithFrame:fullScreen];
    self.yellowBorder.backgroundColor = [UIColor clearColor];
    self.yellowBorder.layer.borderWidth = 2;
    self.yellowBorder.layer.borderColor = [UIColor yellowColor].CGColor;
    
    UILabel* sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 600, 50)];
    //sizeLabel.text = NSStringFromCGSize(self.externalDisplayHandler.contentView.bounds.size);
    sizeLabel.text = [NSString stringWithFormat:@"TV frame:%@, ContentInsets:%@", NSStringFromCGSize(self.externalDisplayHandler.contentView.frame.size),NSStringFromUIEdgeInsets(self.externalDisplayHandler.contentInset)];
    sizeLabel.backgroundColor = [UIColor clearColor];
    sizeLabel.textColor = [UIColor whiteColor];
    sizeLabel.tag = 1; // find this later
    [yellowBorder addSubview:sizeLabel];
    
    [self.externalDisplayHandler.contentView insertSubview:self.yellowBorder belowSubview:self.redSquareTV];
 
    
    /* Add square to mobile device */
    [self addToMobileDevice];

    
}
- (void)addToMobileDevice
{
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
        self.redSquare = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    else 
        self.redSquare = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    
    redSquare.backgroundColor = [UIColor redColor];
    redSquare.center = self.view.center;
 

 
    
    [self.view addSubview:redSquare];

    
    UILabel* messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, 50)];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
        messageLabel.text = @"Drag me";
    else
        messageLabel.text = @"Drag this square around the screen";
    
        
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textColor = [UIColor whiteColor];

    [redSquare addSubview:messageLabel];
    
    CGRect fullScreen = self.view.bounds;
    
    
    UIView* yellowBorderDevice = [[UIView alloc] initWithFrame:fullScreen];
    yellowBorderDevice.backgroundColor = [UIColor clearColor];
    yellowBorderDevice.layer.borderWidth = 2;
    yellowBorderDevice.layer.borderColor = [UIColor yellowColor].CGColor;
    yellowBorderDevice.autoresizesSubviews = YES;
    yellowBorderDevice.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UILabel* sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    sizeLabel.text = NSStringFromCGSize(self.view.bounds.size);
    sizeLabel.backgroundColor = [UIColor clearColor];
    sizeLabel.textColor = [UIColor whiteColor];
    [yellowBorderDevice addSubview:sizeLabel];
    
    [self.view insertSubview:yellowBorderDevice belowSubview:redSquare];

 
    /* */
    UIPanGestureRecognizer *panSquare = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAnyView:)];   
    [self.redSquare addGestureRecognizer:panSquare]; 
    
    
    self.rightLabel.text = [NSString stringWithFormat:@"%i",self.externalDisplayHandler.contentInset.right];
    self.rightSlider.value = self.externalDisplayHandler.contentInset.right;    
    [self.view bringSubviewToFront:self.rightSlider];// tappable if on top

    self.leftLabel.text = [NSString stringWithFormat:@"%i",self.externalDisplayHandler.contentInset.left];
    self.leftSlider.value = self.externalDisplayHandler.contentInset.left;    
    [self.view bringSubviewToFront:self.leftSlider];

    self.topLabel.text = [NSString stringWithFormat:@"%i",self.externalDisplayHandler.contentInset.top];
    self.topSlider.value = self.externalDisplayHandler.contentInset.top;    
    [self.view bringSubviewToFront:self.topSlider];

    self.bottomLabel.text = [NSString stringWithFormat:@"%i",self.externalDisplayHandler.contentInset.bottom];
    self.bottomSlider.value = self.externalDisplayHandler.contentInset.bottom;    
    [self.view bringSubviewToFront:self.bottomSlider];
    
    
    externalDisplayHandler.borderOffsets = CGRectMake(60, 70, 250, 170);

}
#pragma mark - Adjust borders
- (IBAction)rightSliderAction:(id)sender 
{
    
    UIEdgeInsets edgeInsets = self.externalDisplayHandler.contentInset;
    edgeInsets.right = self.rightSlider.value;

    self.externalDisplayHandler.contentInset = edgeInsets;
    self.rightLabel.text = [NSString stringWithFormat:@"%i",(int)self.externalDisplayHandler.contentInset.right];
    
    [self refreshText];
    
    
}

- (IBAction)leftSliderAction:(id)sender 
{
    UIEdgeInsets edgeInsets = self.externalDisplayHandler.contentInset;
    edgeInsets.left = self.leftSlider.value;
    
    self.externalDisplayHandler.contentInset = edgeInsets;
    self.leftLabel.text = [NSString stringWithFormat:@"%i",(int)self.externalDisplayHandler.contentInset.left];
    
    [self refreshText];

}
- (IBAction)topSliderAction:(id)sender 
{
    UIEdgeInsets edgeInsets = self.externalDisplayHandler.contentInset;
    edgeInsets.top = self.topSlider.value;
    
    self.externalDisplayHandler.contentInset = edgeInsets;
    self.topLabel.text = [NSString stringWithFormat:@"%i",(int)self.externalDisplayHandler.contentInset.top];
    
    [self refreshText];
    
}
- (IBAction)bottomSliderAction:(id)sender 
{
    UIEdgeInsets edgeInsets = self.externalDisplayHandler.contentInset;
    edgeInsets.bottom = self.bottomSlider.value;
    
    self.externalDisplayHandler.contentInset = edgeInsets;
    self.bottomLabel.text = [NSString stringWithFormat:@"%i",(int)self.externalDisplayHandler.contentInset.bottom];
    
    [self refreshText];
}


- (void)viewDidUnload
{

    [self setRightSlider:nil];
    [self setRightLabel:nil];
    [self setLeftSlider:nil];
    [self setLeftLabel:nil];
    [super viewDidUnload];
        
    if(externalDisplayHandler)
    {
        [externalDisplayHandler denotify]; // removeconnect/disconnect notifications
        externalDisplayHandler = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
    

}

#pragma mark - Gesture Routines
// scale and rotation transforms are applied relative to the layer's anchor point
// this method moves a gesture recognizer's view's anchor point between the user's fingers
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

- (IBAction)panAnyView:(UIPanGestureRecognizer *)gestureRecognizer
{ 
    
    UIView *view = [gestureRecognizer view];
    
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[view superview]];
        
        [view setCenter:CGPointMake([view center].x + translation.x , [view center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[view superview]];
        
        
        
    }
    
    /* adjust TV square */
    CGRect frame = self.redSquareTV.frame;
    //1. work out percenatge on mobile device from left
    float fromLeft = self.redSquare.frame.origin.x / self.view.bounds.size.width;
    //2. work out percenatge on mobile device from top
    float fromTop = self.redSquare.frame.origin.y / self.view.bounds.size.height;
    
    /*set same percentage for external screen*/
    float fromLeftTV = self.externalDisplayHandler.contentView.bounds.size.width * fromLeft;
    float fromTopTV =  self.externalDisplayHandler.contentView.bounds.size.height * fromTop;
    
    frame.origin.x = fromLeftTV;
    frame.origin.y = fromTopTV;        

    
          
    self.redSquareTV.frame = frame;

    
}

#pragma mark - TV Delegate methods
-(void)TVDidDisconnectNotification
{
    NSLog(@"TV was Disconnected");
    
   
}
-(void)refreshText
{
    /*refresh TV*/
    UILabel* sizeLabel = (UILabel*)[self.yellowBorder viewWithTag:1];
    if(sizeLabel)
        sizeLabel.text = [NSString stringWithFormat:@"TV frame:%@, ContentInsets:%@", NSStringFromCGSize(self.externalDisplayHandler.contentView.frame.size),NSStringFromUIEdgeInsets(self.externalDisplayHandler.contentInset)];
    
    self.yellowBorder.frame = self.externalDisplayHandler.contentView.frame;

}
-(void)TVDidConnectNotification:(NSNotification *)notification
{
    NSLog(@"TV was Connected");
    
    
    
    if(self.externalDisplayHandler) 
    {
         NSLog(@"external screen of size:%@ ",NSStringFromCGRect(self.externalDisplayHandler.contentView.frame));
         
        [self.externalDisplayHandler.contentView addSubview:self.redSquareTV];
        [self.externalDisplayHandler.contentView insertSubview:self.yellowBorder belowSubview:self.redSquareTV];
        
 
        [self refreshText];
 
        
    }
}
@end
