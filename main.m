//
//  main.m
//  ColorTrigger
//
//  Created by Rahim on 2015-04-13.
//  Copyright (c) 2015 RM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#include <stdlib.h>
#include <ApplicationServices/ApplicationServices.h>
#include <unistd.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSPoint mouseLoc = [NSEvent mouseLocation];
        
        while (true) {
            
            usleep(1000);
            
            mouseLoc = [NSEvent mouseLocation];
            
            uint32_t count = 0;
            CGDirectDisplayID displayForPoint;
            if (CGGetDisplaysWithPoint(NSPointToCGPoint(mouseLoc), 1, &displayForPoint, &count) != kCGErrorSuccess) {
                //fail
                return 0;
            }

            //900 for Macbook Pro
            CGImageRef image = CGWindowListCreateImage(CGRectMake(mouseLoc.x, 900 - mouseLoc.y, 1, 1), kCGWindowListOptionOnScreenOnly, kCGNullWindowID, kCGWindowImageDefault);
            
            NSBitmapImageRep* bitmap = [[NSBitmapImageRep alloc] initWithCGImage:image];
            CGImageRelease(image);
            NSColor* color = [bitmap colorAtX:0 y:0];
            
            
            //NSLog(@"Color: %@", color);
            //NSLog(@"X: %f,   Y: %f", mouseLoc.x, mouseLoc.y);
            //NSLog(@"R: %f  G: %f   B: %f", color.redComponent, color.greenComponent, color.blueComponent);
            
            if (color.greenComponent > 0.85 && color.greenComponent < 0.86 && color.redComponent > 0.25 && color.redComponent < 0.4 && color.blueComponent > 0.4 && color.blueComponent < 0.45 ) {
                
                //Humanized variance delay
                //High variance low min OR low variance high min (?)
                int r = arc4random_uniform(100) + 50;
                
                //Simulate mouse click
                
                //Create mouse events
                CGPoint mouseLocCG = NSPointToCGPoint(mouseLoc);
                CGEventRef clickDown = CGEventCreateMouseEvent(
                                                                 NULL, kCGEventLeftMouseDown,
                                                                 CGPointMake(mouseLocCG.x, mouseLocCG.y),
                                                                 kCGMouseButtonLeft
                                                                 );
                CGEventRef clickUp = CGEventCreateMouseEvent(
                                                               NULL, kCGEventLeftMouseUp,
                                                               CGPointMake(mouseLocCG.x, mouseLocCG.y),
                                                               kCGMouseButtonLeft
                                                               );
                
                //Human delay
                
                usleep(r * 1000);
                
                CGEventPost(kCGHIDEventTap, clickDown);
                
                r = arc4random_uniform(40) + 10;
                usleep(r * 1000);
        
                CGEventPost(kCGHIDEventTap, clickUp);
                
                break;
                
            }
            
            
        }
        
    }
    return 0;
}
