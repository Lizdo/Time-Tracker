//
//  MTTAppDelegate.m
//  MinimalTimeTracking
//
//  Created by Liz on 13-4-30.
//  Copyright (c) 2013年 Liz. All rights reserved.
//

#import "MTTAppDelegate.h"

@implementation MTTAppDelegate

#define UPDATE_INTERVAL 1.0f
#define kElapasedTime @"ElapsedTime"

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _elapsedTime = [[NSUserDefaults standardUserDefaults] floatForKey:kElapasedTime];
    [self activateStatusMenu];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:UPDATE_INTERVAL
                                             target:self
                                           selector:@selector(updateTimer)
                                           userInfo:nil
                                            repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

- (void)activateStatusMenu
{
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    
    _statusItem = [bar statusItemWithLength:NSVariableStatusItemLength];
    
    //[_statusItem setTitle: NSLocalizedString(@"Time Tracker",@"")];
    [_statusItem setImage:[NSImage imageNamed:@"StatusIconActive.png"]];
    [_statusItem setHighlightMode:YES];
    [_statusItem setMenu:_statusBarMenu];
}


- (IBAction)togglePauseResume:(id)sender
{
    self.paused = !self.paused;
    if (self.paused){
        [_pauseResumeItem setTitle: NSLocalizedString(@"Resume", @"")];
        [_statusItem setImage:[NSImage imageNamed:@"StatusIconInactive.png"]];
    }else{
        [_pauseResumeItem setTitle: NSLocalizedString(@"Pause", @"")];
        [_statusItem setImage:[NSImage imageNamed:@"StatusIconActive.png"]];
    }
}

- (IBAction)reset:(id)sender
{
    _elapsedTime = 0.0f;
    [_elapsedTimeItem setTitle:[self elapsedTimeString]];
}

- (IBAction)quit:(id)sender
{
    [[NSApplication sharedApplication] terminate:nil];
}

- (void)updateTimer
{
    if (!_paused){
        _elapsedTime += UPDATE_INTERVAL;
        [_elapsedTimeItem setTitle:[self elapsedTimeString]];
        [[NSUserDefaults standardUserDefaults]setFloat:_elapsedTime forKey:kElapasedTime];
        //NSLog(@"Updating....");
        //NSLog(@"%@", [self elapsedTimeString]);
    }
}

- (NSString *)elapsedTimeString
{
    int remainingTime = floor(_elapsedTime);
    
    int days = floor(remainingTime/(60 * 60 * 24));
    remainingTime -= 60 * 60 * 24 * days;
    
    NSString *dayString = (days == 0 ? @"" :[NSString stringWithFormat:@"%d days ", days]);
    
    int hours = floor(remainingTime/(60*60));
    remainingTime -= 60 * 60 * hours;
    
    NSString *hourString = (hours == 0 ? @"" :[NSString stringWithFormat:@"%d hours ", hours]);
    
    int minutes = floor(remainingTime/60);
    remainingTime -= 60 * minutes;
    
    NSString *minutesString = (minutes == 0 ? @"" :[NSString stringWithFormat:@"%d minutes ", minutes]);
    
    int seconds = remainingTime;
    NSString *secondsString = (seconds == 0 ? @"" :[NSString stringWithFormat:@"%d seconds ", seconds]);
    
    
    return [NSString stringWithFormat:@"%@%@%@%@", dayString, hourString, minutesString, secondsString];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [[NSUserDefaults standardUserDefaults]setFloat:_elapsedTime forKey:kElapasedTime];
}





@end
