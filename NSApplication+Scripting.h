//
//  NSApplication+Scripting.h
//  Shady
//
//  Created by Michael Lapinsky on 6/19/11.
//  Copyright 2011 Andesite Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSApplication (Scripting)

- (void)increaseOpacity:(NSScriptCommand *)command;
- (void)decreaseOpacity:(NSScriptCommand *)command;

@end
