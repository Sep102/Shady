//
//  ShadyAppDelegate.m
//  Shady
//
//  Created by Matt Gemmell on 02/11/2009.
//

#import "ShadyAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "MGTransparentWindow.h"

#define OPACITY_UNIT	0.05; // "20 shades ought to be enough for _anybody_."
#define DEFAULT_OPACITY	0.4
#define MAX_OPACITY		0.90 // the darkest the screen can be, where 1.0 is pure black.
#define KEY_OPACITY		@"ShadySavedOpacityKey" // name of the saved opacity setting

@implementation ShadyAppDelegate

@synthesize window;
@synthesize opacity;
@synthesize statusMenu;
@synthesize opacitySlider;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Create transparent window.
	NSRect screensFrame = [[NSScreen mainScreen] frame];
	for (NSScreen *thisScreen in [NSScreen screens]) {
		screensFrame = NSUnionRect(screensFrame, [thisScreen frame]);
	}
	window = [[MGTransparentWindow windowWithFrame:screensFrame] retain];
	
	// Configure window.
	[window setReleasedWhenClosed:YES];
	[window setHidesOnDeactivate:NO];
	[window setCanHide:NO];
	[window setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
	[window setIgnoresMouseEvents:YES];
	[window setLevel:NSScreenSaverWindowLevel];
	[window setDelegate:self];
	
	// Configure contentView.
	NSView *contentView = [window contentView];
	[contentView setWantsLayer:YES];
	CALayer *layer = [contentView layer];
	layer.backgroundColor = CGColorGetConstantColor(kCGColorBlack);
	layer.opacity = 0;
	
	// Only show help text when activated _after_ we've launched and hidden ourselves.
	showsHelpWhenActive = NO;
	
	// Put this app into the background (the shade won't hide due to how its window is set up above).
	[NSApp hide:self];
	
	// Set the default opacity value and load any saved value.
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:DEFAULT_OPACITY] forKey:KEY_OPACITY]];
	opacity = 100.0;
	self.opacity = [defaults floatForKey:KEY_OPACITY];
	
	// Put window on screen.
	[window makeKeyAndOrderFront:self];
	
	// Activate statusItem.
	NSStatusBar *bar = [NSStatusBar systemStatusBar];
    statusItem = [bar statusItemWithLength:NSSquareStatusItemLength];
    [statusItem retain];
    [statusItem setImage:[NSImage imageNamed:@"Shady_Menu_Dark"]];
	[statusItem setAlternateImage:[NSImage imageNamed:@"Shady_Menu_Light"]];
    [statusItem setHighlightMode:YES];
	[opacitySlider setFloatValue:(1.0 - opacity)];
    [statusItem setMenu:statusMenu];
}


- (void)dealloc
{
	if (statusItem) {
		[[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
		[statusItem release];
		statusItem = nil;
	}
	[window removeChildWindow:helpWindow];
	[helpWindow close];
	[window close];
	window = nil; // released when closed.
	helpWindow = nil; // released when closed.
	
	[super dealloc];
}


- (void)applicationDidBecomeActive:(NSNotification *)aNotification
{
	[self applicationActiveStateChanged:aNotification];
}


- (void)applicationDidResignActive:(NSNotification *)aNotification
{
	[self applicationActiveStateChanged:aNotification];
}


- (void)applicationActiveStateChanged:(NSNotification *)aNotification
{
	BOOL appActive = [NSApp isActive];
	if (appActive) {
		// Give the window a kick into focus, so we still get key-presses.
		[window makeFirstResponder:[window contentView]];
		[window makeKeyAndOrderFront:self];
	}
	
	if (!showsHelpWhenActive && !appActive) {
		// Enable help text display when active from now on.
		showsHelpWhenActive = YES;
		
	} else if (showsHelpWhenActive) {
		[self toggleHelpDisplay];
	}
}


- (IBAction)showAbout:(id)sender
{
	// We wrap this for the statusItem to ensure Shady comes to the front first.
	[NSApp activateIgnoringOtherApps:YES];
	[NSApp orderFrontStandardAboutPanel:self];
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


- (IBAction)opacitySliderChanged:(id)sender
{
	self.opacity = (1.0 - [sender floatValue]);
}


- (void)keyDown:(NSEvent *)event
{
	if ([event window] == window) {
		unsigned short keyCode = [event keyCode];
		if (keyCode == 12) { // q
			[NSApp terminate:self];
			
		} else if (keyCode == 126) { // up-arrow
			[self decreaseOpacity:self];
			
		} else if (keyCode == 125) { // down-arrow
			[self increaseOpacity:self];
		}
	}
}


- (void)toggleHelpDisplay
{
	if (!helpWindow) {
		// Create helpWindow.
		NSRect mainFrame = [[NSScreen mainScreen] frame];
		NSRect helpFrame = NSZeroRect;
		float width = 600;
		float height = 200;
		helpFrame.origin.x = (mainFrame.size.width - width) / 2.0;
		helpFrame.origin.y = 200.0;
		helpFrame.size.width = width;
		helpFrame.size.height = height;
		helpWindow = [[MGTransparentWindow windowWithFrame:helpFrame] retain];
		
		// Configure window.
		[window setReleasedWhenClosed:YES];
		[window setHidesOnDeactivate:NO];
		[window setCanHide:NO];
		[window setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
		[window setIgnoresMouseEvents:YES];
		
		// Configure contentView.
		NSView *contentView = [helpWindow contentView];
		[contentView setWantsLayer:YES];
		CATextLayer *layer = [CATextLayer layer];
		layer.opacity = 0;
		[contentView setLayer:layer];
		CGColorRef bgColor = CGColorCreateGenericGray(0.0, 0.6);
		layer.backgroundColor = bgColor;
		CGColorRelease(bgColor);
		layer.string = NSLocalizedString(@"When Shady is frontmost:\rUp/Down to alter shade\rQ to Quit", nil);
		layer.contentsRect = CGRectMake(0, 0, 1, 1.2);
		layer.fontSize = 40.0;
		layer.foregroundColor = CGColorGetConstantColor(kCGColorWhite);
		layer.borderColor = CGColorGetConstantColor(kCGColorWhite);
		layer.borderWidth = 4.0;
		layer.cornerRadius = 15.0;
		layer.alignmentMode = kCAAlignmentCenter;
		
		[window addChildWindow:helpWindow ordered:NSWindowAbove];
	}
	
	if (showsHelpWhenActive) {
		float helpOpacity = (([NSApp isActive] ? 1 : 0));
		[[[helpWindow contentView] layer] setOpacity:helpOpacity];
	}
}


- (void)setOpacity:(float)newOpacity
{
	float normalisedOpacity = MIN(MAX_OPACITY, MAX(newOpacity, 0.0));
	if (normalisedOpacity != opacity) {
		opacity = normalisedOpacity;
		[[[window contentView] layer] setOpacity:opacity];
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setFloat:opacity forKey:KEY_OPACITY];
		[defaults synchronize];
		
		[opacitySlider setFloatValue:(1.0 - opacity)];
	}
}


@end
