//
//  ExternalDisplayHandler.m
//  ExternalDisplay
//
//  Created by john goodstadt on 02/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ExternalDisplayHandler.h"
#import <QuartzCore/QuartzCore.h>
#import <unistd.h> // do i need this?

@interface ExternalDisplayHandler ()

@end

@implementation ExternalDisplayHandler

@synthesize delegate;
@synthesize extScreen;
@synthesize extWindow;
@synthesize availableModes;
@synthesize contentView;
@synthesize borderOffsets;
@synthesize contentInset=_contentInset;

- (id)init
{
    self = [super init];
    if (self) {

        // No notifications are sent for screens that are present when the app is launched.
        self.borderOffsets = CGRectZero;
       // NSLog(@"1. time check init external monitor"); 
        [self screenDidChange:nil];
        //NSLog(@"2.time check init external monitor"); 
        
        // Register for screen connect and disconnect notifications.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(ScreenDidConnectNotification:)
                                                     name:UIScreenDidConnectNotification 
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(ScreenDidDisconnectNotification:)
                                                     name:UIScreenDidDisconnectNotification 
                                                   object:nil];

        
    }
    
    return self;
}
-(void)denotify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIScreenDidConnectNotification 
												  object:nil];
    
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIScreenDidDisconnectNotification 
												  object:nil];
    

}

//allows test for external monitor without ivars - quick call
+(BOOL)monitorExists
{
    if([UIScreen screens].count > 1)
        return YES;
    else
        return NO;
    
}
+(BOOL)monitorNotConnected
{
    return ![ExternalDisplayHandler monitorExists];    
}

-(BOOL)monitorExists
{
    
//    if(!self.extScreen)
//        [self screenDidChange:nil];

    
    
    if(self.extScreen)
        return YES;
    else
        return NO;
        
}
- (void)screenDidChange:(NSNotification *)notification
{
    
      
	NSArray			*screens;
	UIScreen		*aScreen;
	//UIScreenMode	*mode;
	
	// 1.	
	
	// Log the current screens and display modes
	screens = [UIScreen screens];
	
	
	uint32_t screenNum = 1;
	for (aScreen in screens) {			  
		NSArray *displayModes;
		
		
		displayModes = [aScreen availableModes];
		
		screenNum++;
	}
	
	NSUInteger screenCount = [screens count];
	
	if (screenCount > 1) {
		// 2.
		
		// Select first external screen
		self.extScreen = [screens objectAtIndex:1];
		self.availableModes = [extScreen availableModes];
		
        self.extScreen.currentMode = [availableModes lastObject]; // should be largest

        //self.extScreen.overscanCompensation = UIScreenOverscanCompensationScale; // just at top - off at bottom sides OK
        self.extScreen.overscanCompensation = UIScreenOverscanCompensationInsetBounds; // best
        // extScreen.overscanCompensation = UIScreenOverscanCompensationInsetApplicationFrame; // worst no top mo bottom border at sides

        if (extWindow == nil || !CGRectEqualToRect(extWindow.bounds, [extScreen bounds])) {
            // Size of window has actually changed
            
            // 4.
            self.extWindow = [[UIWindow alloc] initWithFrame:[extScreen bounds]];
            
            // 5.
            self.extWindow.screen = extScreen;
            self.extWindow.backgroundColor = [UIColor blackColor];

        }
        

        CGRect masterFrame = [self.extScreen bounds];
        contentView = [[UIView alloc] initWithFrame:masterFrame]; // used by clients as view to add content to
		contentView.backgroundColor = [UIColor blackColor];
        contentView.layer.borderWidth = 0;
        contentView.layer.borderColor = [UIColor purpleColor].CGColor;

        if (!CGRectEqualToRect(self.borderOffsets, CGRectZero))
        {
            
            CGRect frame = contentView.frame;
            
           // NSLog(@"before change:%@",NSStringFromCGRect(frame));
            frame.origin.x += self.borderOffsets.origin.x;
            frame.origin.y += self.borderOffsets.origin.y;
            frame.size.width -= (self.borderOffsets.origin.x - self.borderOffsets.size.width);
            frame.size.height -= (self.borderOffsets.origin.y - self.borderOffsets.size.height);
            contentView.frame = frame;
           // NSLog(@"after change:%@",NSStringFromCGRect(frame));
            
        }
        contentView.clipsToBounds = YES;
        
        [extWindow addSubview:contentView];
		        
        // 7.
		[extWindow makeKeyAndVisible];
		
		
//		[self.delegate externalWindow:self.extWindow];


	}
	else {
		// Release external screen and window
		self.extScreen = nil;
		
		self.extWindow = nil;
		self.availableModes = nil;
		self.contentView = nil;
        
		//[self.delegate externalWindow:self.extWindow];
			        
       
	}
}

-(void)setBorderOffsets:(CGRect)newBorderOffsets
{
    borderOffsets = newBorderOffsets;
    
    if(!self.contentView)
        return;
    
    // setting to Zero did not get executed
    // however, on Panasonic goes off screen
    //if (!CGRectEqualToRect(borderOffsets, CGRectZero))
    //{
        
        CGRect frame = [extWindow frame];//contentView.frame;
        
       // NSLog(@"before change:%@",NSStringFromCGRect(frame));
        frame.origin.x += borderOffsets.origin.x;
        frame.origin.y += borderOffsets.origin.y;
        frame.size.width = frame.size.width - (borderOffsets.origin.x + borderOffsets.size.width);
        frame.size.height = frame.size.height - (borderOffsets.origin.y + borderOffsets.size.height);
        self.contentView.frame = frame;
        NSLog(@"setBorderOffsets() after change:%@",NSStringFromCGRect(frame));
         
    //}

    
}
-(CGRect)borderOffsets
{
    return borderOffsets;
}
-(UIEdgeInsets)contentInset
{
    return _contentInset;
}
/*The 4 borders - adjust in and out*/
-(void)setContentInset:(UIEdgeInsets)newContentInset
{
    _contentInset = newContentInset;
    
    if(!self.contentView)
        return;
    
    CGRect frame = [extWindow frame];
    
    frame.origin.x = _contentInset.left;
    frame.origin.y = _contentInset.top;
    //frame.size.width = frame.size.width + _contentInset.right; // dont adjust for x here
    
    if(_contentInset.right >=0 )
        frame.size.width = frame.size.width + _contentInset.right; // dont adjust for x here
    else 
        frame.size.width = frame.size.width - abs(_contentInset.right);
 
    if(_contentInset.bottom >=0 )
        frame.size.height = frame.size.height + _contentInset.bottom; // dont adjust for y here 
    else 
        frame.size.height = frame.size.height - abs(_contentInset.bottom);

    
    
    
    self.contentView.frame = frame;
    
    
}

/* When external screen is plugged in*/
- (void)ScreenDidConnectNotification:(NSNotification *)notification
{
    [self screenDidChange:notification];
       
    if(delegate && [self.delegate respondsToSelector:@selector(TVDidConnectNotification:)])
        [delegate TVDidConnectNotification:notification];
}
/* When external screen is plugged out */
- (void)ScreenDidDisconnectNotification:(NSNotification *)notification
{
    [self screenDidChange:notification];
    
    if(delegate && [delegate respondsToSelector:@selector(TVDidDisconnectNotification)])
        [delegate TVDidDisconnectNotification];
}
@end
