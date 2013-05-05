//
//  MTTAppDelegate.m
//  MinimalTimeTracking
//
//  Created by Liz on 13-4-30.
//  Copyright (c) 2013 Liz. All rights reserved.
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
    [_statusItem setImage:[NSImage imageNamed:@"StatusIconActive"]];
    [_statusItem setHighlightMode:YES];
    [_statusItem setMenu:_statusBarMenu];
}


- (IBAction)togglePauseResume:(id)sender
{
    self.paused = !self.paused;
    if (self.paused){
        [_pauseResumeItem setTitle: NSLocalizedString(@"Resume", @"")];
        [_statusItem setImage:[NSImage imageNamed:@"StatusIconInactive"]];
    }else{
        [_pauseResumeItem setTitle: NSLocalizedString(@"Pause", @"")];
        [_statusItem setImage:[NSImage imageNamed:@"StatusIconActive"]];
    }
}

- (IBAction)reset:(id)sender
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:NSLocalizedString(@"Reset it.", @"")];
    [alert addButtonWithTitle:NSLocalizedString(@"Not right now.", @"")];
    [alert setMessageText:NSLocalizedString(@"Reset the timer?", @"")];
    [alert setInformativeText:NSLocalizedString(@"Your timer will be reset to 0. You won't be able to get your time back.", @"")];
    [alert setAlertStyle:NSWarningAlertStyle];
    
    if ([alert runModal] == NSAlertFirstButtonReturn) {
        // OK clicked, delete the record
        [self doReset];
    }
}


- (void)doReset
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
    
    // Hide seconds if we're over an hour
    if (days != 0 || hours != 0){
        secondsString = @"";
    }
    
    // Hide minutes if we're over a day
    if (days !=0) {
        minutesString = @"";
    }
    
    return [NSString stringWithFormat:@"%@%@%@%@", dayString, hourString, minutesString, secondsString];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [[NSUserDefaults standardUserDefaults]setFloat:_elapsedTime forKey:kElapasedTime];
}


@end
