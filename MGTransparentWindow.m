#import "MGTransparentWindow.h"

@implementation MGTransparentWindow


- (id)initWithContentRect:(NSRect)contentRect 
                styleMask:(NSUInteger)aStyle 
                  backing:(NSBackingStoreType)bufferingType 
                    defer:(BOOL)flag {
    
    if (self = [super initWithContentRect:contentRect 
                                        styleMask:NSBorderlessWindowMask 
                                          backing:NSBackingStoreBuffered 
                                   defer:NO]) {
        
        [self setLevel:NSScreenSaverWindowLevel];
        [self setBackgroundColor:[NSColor colorWithCalibratedWhite:0.0 alpha:0]];
        [self setAlphaValue:1.0];
        [self setOpaque:NO];
        [self setHasShadow:NO];
    }
    
    return self;
}


- (BOOL)canBecomeKeyWindow
{
    return NO;
}

- (BOOL)canBecomeMainWindow
{
	return NO;
}


@end
