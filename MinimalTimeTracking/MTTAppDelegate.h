//
//  MTTAppDelegate.h
//  MinimalTimeTracking
//
//  Created by Liz on 13-4-30.
//  Copyright (c) 2013 Liz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MTTAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSMenu *statusBarMenu;
@property (assign) IBOutlet NSMenuItem *pauseResumeItem;
@property (assign) IBOutlet NSMenuItem *elapsedTimeItem;

@property (retain) NSStatusItem *statusItem;

@property float elapsedTime;
@property bool paused;

- (IBAction)togglePauseResume:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)quit:(id)sender;

@end
