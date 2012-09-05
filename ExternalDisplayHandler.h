//
//  ExternalDisplayHandler.h
//  ExternalDisplay
//
//  Created by john goodstadt on 02/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ExternalDisplayHandlerDelegate <NSObject>
@optional
-(void)TVDidConnectNotification:(NSNotification *)notification;
-(void)TVDidDisconnectNotification;
@end


@interface ExternalDisplayHandler : NSObject
{
    id <ExternalDisplayHandlerDelegate>	delegate;
    
    UIScreen					*extScreen;
	UIWindow					*extWindow;
	UIView                      *contentView;
	NSArray						*availableModes;
    
    CGRect borderOffsets; // deprecated
    
    UIEdgeInsets contentInset;
    
}
@property (nonatomic, retain) id <ExternalDisplayHandlerDelegate> delegate;


@property (nonatomic, retain) UIScreen *extScreen;
@property (nonatomic, retain) UIWindow *extWindow;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) NSArray *availableModes;
@property (assign) CGRect borderOffsets;// deprecated
@property (assign,setter = setContentInset:,getter = contentInset) UIEdgeInsets contentInset;

+(BOOL)monitorExists;
+(BOOL)monitorNotConnected;
-(BOOL)monitorExists;
-(void)denotify;
- (void)screenDidChange:(NSNotification *)notification;
@end
