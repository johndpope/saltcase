#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>

#import "SCSynth.h"
@class SCCompositionController;
@interface SCAppController : NSObject
@property (strong, readonly) id<SCAudioRenderer> currentlyPlaying;
@property (strong) SCSynth* synth;
+ (SCAppController*)sharedInstance;
- (BOOL)playComposition:(id<SCAudioRenderer>)composition;
- (void)stopComposition:(id<SCAudioRenderer>)composition;
@end
