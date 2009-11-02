//
//  ShadyAppDelegate.h
//  Shady
//
//  Created by Matt Gemmell on 02/11/2009.
//

#import <Cocoa/Cocoa.h>

@interface ShadyAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	float opacity;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) float opacity;

- (IBAction)increaseOpacity:(id)sender;
- (IBAction)decreaseOpacity:(id)sender;

@end
