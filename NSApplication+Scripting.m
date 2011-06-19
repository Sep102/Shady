//
//  NSApplication+Scripting.m
//  Shady
//
//  Created by Michael Lapinsky on 6/19/11.
//  Copyright 2011 Andesite Studios, LLC. All rights reserved.
//

#import "NSApplication+Scripting.h"


@implementation NSApplication (Scripting)

- (void)increaseOpacity:(NSScriptCommand *)command
{
	[[NSApp delegate] increaseOpacity:nil];
}

- (void)decreaseOpacity:(NSScriptCommand *)command
{
	[[NSApp delegate] decreaseOpacity:nil];
}

@end
