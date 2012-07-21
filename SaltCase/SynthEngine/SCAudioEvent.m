//
//  SCAudioEvent.m
//  SaltCase
//
//  Created by Sota Yokoe on 7/21/12.
//  Copyright (c) 2012 Pankaku Inc. All rights reserved.
//

#import "SCAudioEvent.h"

@implementation SCAudioEvent
@synthesize timing, timingPacketNumber;

- (NSString*)description {
    return [NSString stringWithFormat:@"%.2f(%d) - ", timing, timingPacketNumber];
}
@end
