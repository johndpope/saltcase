//
//  SCAppController.m
//  SaltCase
//
//  Created by Sota Yokoe on 7/8/12.
//  Copyright (c) 2012 Pankaku Inc. All rights reserved.
//

#import "SCCompositionController.h"
#import "SCAppController.h"

#import "SCDocument.h"
#import "SCSynth.h"

@implementation SCCompositionController
@synthesize composition;
@synthesize playButton;
@synthesize stopButton;
@synthesize timeLabel;
@synthesize settingsButton;

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserverForName:SCBufferUpdateNotification object:nil queue:[NSOperationQueue new] usingBlock:^(NSNotification *note) {
        if ([SCAppController sharedInstance].currentPlayingComposition == composition) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [timeLabel setStringValue:[NSString stringWithFormat:@"Time: %.1f", ((SCSynth*)note.object).timeElapsed]];
            });
        }
    }];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem {
    NSLog(@"validate %@", theItem);
    if (theItem == playButton) {
        return ([SCAppController sharedInstance].currentPlayingComposition == nil);
    }
    if (theItem == stopButton) {
        return ([SCAppController sharedInstance].currentPlayingComposition != nil);
    }
    if (theItem == settingsButton) {
        // Disabled while the song is playing.
        return ([SCAppController sharedInstance].currentPlayingComposition != composition);
    }
    return NO;
}

- (IBAction)playComposition:(id)sender {
    if ([[SCAppController sharedInstance] playComposition:composition]) {
        NSLog(@"Started playing %@", composition);
    } else {
        NSLog(@"Failed to start playing %@.\nCurrently playing: %@", composition, [SCAppController sharedInstance].currentPlayingComposition);
    }
}
- (IBAction)stopComposition:(id)sender {
    [[SCAppController sharedInstance] stopComposition:composition];
}
- (IBAction)openSettings:(id)sender {
    NSLog(@"Open settings");
}
@end
