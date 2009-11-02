//
//  ShadyAppDelegate.m
//  Shady
//
//  Created by Matt Gemmell on 02/11/2009.
//

#import "ShadyAppDelegate.h"
#import "MGTransparentWindow.h"

#define OPACITY_UNIT	0.05; // "20 shades ought to be enough for _anybody_."
#define DEFAULT_OPACITY	0.4
#define MAX_OPACITY		0.90 // the darkest the screen can be, where 1.0 is pure black.

@implementation ShadyAppDelegate

@synthesize window;
@synthesize opacity;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Create partially transparent window.
	NSRect screensFrame = [[NSScreen mainScreen] frame];
	for (NSScreen *thisScreen in [NSScreen screens]) {
		screensFrame = NSUnionRect(screensFrame, [thisScreen frame]);
	}
	window = [[MGTransparentWindow alloc] 
			   initWithContentRect:screensFrame 
			   styleMask:NSBorderlessWindowMask 
			   backing:NSBackingStoreBuffered 
			   defer:NO];
	
	[window setReleasedWhenClosed:YES];
	[window setHidesOnDeactivate:NO];
	[window setCanHide:NO];
	[window setCollectionBehavior:NSWindowCollectionBehaviorStationary];
	[window setIgnoresMouseEvents:YES];
	
	self.opacity = DEFAULT_OPACITY;
	
	// Put window on screen.
	[window makeKeyAndOrderFront:self];
}


- (void)keyDown:(NSEvent *)evt
{
	NSLog(@"pop");
}


- (IBAction)increaseOpacity:(id)sender
{
	// i.e. make screen darker by making our mask less transparent.
	self.opacity = opacity + OPACITY_UNIT;
}


- (IBAction)decreaseOpacity:(id)sender
{
	// i.e. make screen lighter by making our mask more transparent.
	self.opacity = opacity - OPACITY_UNIT;
}


- (void)setOpacity:(float)newOpacity
{
	float normalisedOpacity = MIN(MAX_OPACITY, MAX(newOpacity, 0.0));
	if (normalisedOpacity != opacity) {
		opacity = normalisedOpacity;
		[window setBackgroundColor:[NSColor colorWithCalibratedWhite:0.0 alpha:opacity]];
	}
}


@end
