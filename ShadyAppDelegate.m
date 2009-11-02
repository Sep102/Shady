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
#define KEY_OPACITY		@"" // name of the saved opacity setting

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
	[window setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
	[window setIgnoresMouseEvents:YES];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:DEFAULT_OPACITY] forKey:KEY_OPACITY]];
	
	self.opacity = [defaults floatForKey:KEY_OPACITY];
	
	// Put window on screen.
	[window makeKeyAndOrderFront:self];
	
	// Put this app into the background (the shade won't hide due to how its window is set up above).
	[NSApp hide:self];
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
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setFloat:opacity forKey:KEY_OPACITY];
		[defaults synchronize];
	}
}


@end
