//
//  MainViewController.h
//  TVOut
//
//  Created by john goodstadt on 05/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import  "ExternalDisplayHandler.h"

@class ExternalDisplayHandler;

@interface MainViewController : UIViewController <ExternalDisplayHandlerDelegate>
{
    ExternalDisplayHandler* externalDisplayHandler;
    
    UIView* redSquare; // demo square on mobile device
    UIView* redSquareTV; // demo square on TV
    UIView* yellowBorder; // outer edge of TV
    
}


@property (nonatomic, retain) ExternalDisplayHandler* externalDisplayHandler;
@property (nonatomic, retain) UIView* redSquare;
@property (nonatomic, retain) UIView* redSquareTV;
@property (nonatomic, retain) UIView* yellowBorder;

@property (strong, nonatomic) IBOutlet UISlider *rightSlider;
@property (strong, nonatomic) IBOutlet UILabel *rightLabel;

@property (strong, nonatomic) IBOutlet UISlider *leftSlider;
@property (strong, nonatomic) IBOutlet UILabel *leftLabel;

@property (strong, nonatomic) IBOutlet UISlider *topSlider;
@property (strong, nonatomic) IBOutlet UILabel *topLabel;

@property (strong, nonatomic) IBOutlet UISlider *bottomSlider;
@property (strong, nonatomic) IBOutlet UILabel *bottomLabel;

- (void)addToMobileDevice;
- (IBAction)rightSliderAction:(id)sender;
- (IBAction)leftSliderAction:(id)sender;
- (IBAction)topSliderAction:(id)sender;
- (IBAction)bottomSliderAction:(id)sender;
@end
