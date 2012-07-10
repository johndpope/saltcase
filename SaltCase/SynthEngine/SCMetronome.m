//
//  SCMetronome.m
//  SaltCase
//
//  Created by Sota Yokoe on 7/10/12.
//  Copyright (c) 2012 Pankaku Inc. All rights reserved.
//

#import "SCMetronome.h"

#import "SCSynth.h"
#import "SCDocument.h"

@interface SCMetronome() {
    UInt32 nextPacket;
    float theta;
    float currentAmplitude;
}
@end

@implementation SCMetronome
- (void)renderToBuffer:(float*)buffer numOfPackets:(UInt32)numOfPackets player:(SCSynth*)player {
    int currentPacket = player.renderedPackets;
    
    for (int i = 0; i < numOfPackets; i++) {
        if (nextPacket <= currentPacket) {
            currentAmplitude = 0.75f;
            nextPacket += (60.0f / player.composition.tempo) * player.samplingFrameRate;
        }
        theta += 0.075f;
        if (theta >= 6.28) theta -= 6.28;
        float wave = sin(theta) * currentAmplitude;
        *buffer++ = wave; // Left
        *buffer++ = wave; // Right
        
        currentAmplitude -= 0.001f;
        currentAmplitude = fmaxf(0.0f, currentAmplitude);
        
        currentPacket++;
    }
}

- (void)reset {
    nextPacket = 0;
}
@end
