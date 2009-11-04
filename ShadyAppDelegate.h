//
//  ShadyAppDelegate.h
//  Shady
//
//  Created by Matt Gemmell on 02/11/2009.
//

#import <Cocoa/Cocoa.h>

@interface ShadyAppDelegate : NSObject {
    NSWindow *window;
	float opacity;
	BOOL showsHelpWhenActive;
	NSWindow *helpWindow;
	NSMenu *statusMenu;
	NSSlider *opacitySlider;
	NSStatusItem *statusItem;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) float opacity;
@property (assign) IBOutlet NSMenu *statusMenu;
@property (assign) IBOutlet NSSlider *opacitySlider;

- (IBAction)showAbout:(id)sender;
- (IBAction)increaseOpacity:(id)sender;
- (IBAction)decreaseOpacity:(id)sender;
- (IBAction)opacitySliderChanged:(id)sender;
- (void)toggleHelpDisplay;
- (void)applicationActiveStateChanged:(NSNotification *)aNotification;

@end
