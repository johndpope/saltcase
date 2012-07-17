//
//  SCPianoRoll.m
//  SaltCase
//
//  Created by Sota Yokoe on 7/14/12.
//  Copyright (c) 2012 Pankaku Inc. All rights reserved.
//

#import "SCPianoRoll.h"

@implementation SCPianoRoll

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor grayColor] set];
    [NSBezierPath setDefaultLineWidth:1];
    
    float y = 0.0f;
    while (y <= self.frame.size.height) {
        [NSBezierPath strokeLineFromPoint:NSMakePoint(0.0f, y) toPoint:NSMakePoint(self.frame.size.width, y)];
        y += kSCNoteLineHeight;
    }
    
    float x = 0.0f;
    while (x <= self.frame.size.width) {
        [NSBezierPath strokeLineFromPoint:NSMakePoint(x, 0.0f) toPoint:NSMakePoint(x, self.frame.size.height)];
        x += kSCPianoRollHorizontalGridInterval;
    }
}

#pragma mark Mouse events
- (double)beatPositionAtPoint:(NSPoint)point {
    return point.x / kSCPianoRollHorizontalGridInterval;
}
- (UInt32)pitchNumberAtPoint:(NSPoint)point {
    int pitchNumber = (int)floor(point.y / kSCNoteLineHeight);
    return pitchNumber >= 0 ? pitchNumber : 0;
}
- (NSPoint)pointOfEvent:(NSEvent*)event {
    return [self convertPoint:event.locationInWindow fromView:nil];
}
- (void)mouseDown:(NSEvent *)theEvent {
    NSPoint cursorAt = [self pointOfEvent:theEvent];
    NSLog(@"mouseDown at (%f, %d)", [self beatPositionAtPoint:cursorAt], [self pitchNumberAtPoint:cursorAt]);
}
- (void)mouseDragged:(NSEvent *)theEvent {
    NSPoint cursorAt = [self pointOfEvent:theEvent];
    NSLog(@"mouseDragged at (%f, %d)", [self beatPositionAtPoint:cursorAt], [self pitchNumberAtPoint:cursorAt]);
}
- (void)mouseUp:(NSEvent *)theEvent {
    NSPoint cursorAt = [self pointOfEvent:theEvent];
    NSLog(@"mouseUp at (%f, %d)", [self beatPositionAtPoint:cursorAt], [self pitchNumberAtPoint:cursorAt]);
}
@end
