//
//  SCNote.m
//  SaltCase
//
//  Created by Sota Yokoe on 7/21/12.
//  Copyright (c) 2012 Pankaku Inc. All rights reserved.
//

#import "SCNote.h"

@implementation SCNote
@synthesize startsAt, length;
- (NSDictionary*)dictionaryRepresentation {
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:startsAt], @"startsAt", 
            [NSNumber numberWithFloat:length], @"length", nil];
}
- (NSString*)description { return [[self dictionaryRepresentation] description]; }
@end
