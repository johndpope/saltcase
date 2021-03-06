//
//  SCExporter.h
//  SaltCase
//
//  Created by Sota Yokoe on 8/13/12.
//  Copyright (c) 2012 Pankaku Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCSynth.h"

typedef enum SCExportStyle {
    SCExportVocalTrackOnly,
    SCExportAllTracks
} SCExportStyle;

@interface SCExporter : NSObject
- (id)initWithURL:(NSURL*)url style:(SCExportStyle)style;
- (void)exportWithSynth:(SCSynth*)synth completionHandler:(void (^)(void))completionHandler updateHandler:(void (^)(int framesWrote))updateHandler;
@property (strong) id<SCAudioRenderer> renderer;
@property (assign) int numOfFrames;
@end
