//
//  SCAudioEvent.h
//  SaltCase
//
//  Created by Sota Yokoe on 7/21/12.
//  Copyright (c) 2012 Pankaku Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum SCAudioEventType {
    SCAudioEventNoteOn = 1,
    SCAudioEventNoteOff = 2,
} SCAudioEventType;

@interface SCAudioEvent : NSObject
@property (assign) int pitch;
@property (assign) NSTimeInterval timing;
@property (assign) UInt32 timingPacketNumber;
@property (assign) SCAudioEventType type;
@property (strong) id note;
@end
