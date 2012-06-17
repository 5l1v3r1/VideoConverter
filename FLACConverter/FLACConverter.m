//
//  FLACConverter.m
//  VideoConverter
//
//  Created by Alex Nichol on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FLACConverter.h"

@implementation FLACConverter

+ (NSString *)bundleName {
    return @"com.aqnichol.FLACConverter";
}

+ (BOOL)supportsExtension:(NSString *)oldExt toExtension:(NSString *)newExt {
    NSArray * supportedSource = [NSArray arrayWithObjects:@"flac", @"wav", nil];
    NSArray * supportedDestination = [NSArray arrayWithObjects:@"flac", @"wav", nil];
    if ([supportedSource containsObject:oldExt]) {
        if ([supportedDestination containsObject:newExt]) {
            return YES;
        }
    }
    return NO;
}

- (void)executeConversion {
    BOOL encodingResult = NO;
    encodingResult = [self encodeWithNoOptions];
    
    if (!encodingResult) {
        [self removeTempSource];
        if ([[NSThread currentThread] isCancelled]) return;
        
        callback(ACConverterCallbackTypeError, 0, [[self class] errorWithCode:2 message:@"No presets worked"]);
        return;
    }
    
    [self removeTempSource];
    if ([[NSThread currentThread] isCancelled]) return;
    
    NSError * placeError = nil;
    if (![self placeTempFile:&placeError]) {
        callback(ACConverterCallbackTypeError, 0, placeError);
        return;
    }
}

- (BOOL)encodeWithNoOptions {
    return [self executeEncoderWithArguments:[NSArray arrayWithObjects:@"-stats", 
                                              @"-i", tempSource,
                                              tempFile, nil]];
}

@end
