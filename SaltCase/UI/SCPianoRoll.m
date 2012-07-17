//
//  SCPianoRoll.m
//  SaltCase
//
//  Created by Sota Yokoe on 7/14/12.
//  Copyright (c) 2012 Pankaku Inc. All rights reserved.
//

#import "SCPianoRoll.h"

@interface SCPianoRoll()
@property (weak) NSView* selectedNote;
@end

@implementation SCPianoRoll
@synthesize selectedNote;

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
    
    float y = [self pitchNumberAtPoint:cursorAt] * kSCNoteLineHeight;
    NSButton* button = [[NSButton alloc] initWithFrame:NSMakeRect(cursorAt.x, y, 50.0f, kSCNoteLineHeight)];
    [self addSubview:button];
    self.selectedNote = button;
}
- (void)moveSelectedNoteTo:(NSPoint)cursorAt {
    if (self.selectedNote) {
        float y = [self pitchNumberAtPoint:cursorAt] * kSCNoteLineHeight;
        self.selectedNote.frame = NSMakeRect(cursorAt.x, y, self.selectedNote.frame.size.width, kSCNoteLineHeight);
    }
}
- (void)mouseDragged:(NSEvent *)theEvent {
    [self moveSelectedNoteTo:[self pointOfEvent:theEvent]];
}
- (void)mouseUp:(NSEvent *)theEvent {
    [self moveSelectedNoteTo:[self pointOfEvent:theEvent]];
    self.selectedNote = nil;
}
@end
