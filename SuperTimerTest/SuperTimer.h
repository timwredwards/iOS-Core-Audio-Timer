//
//  SuperTimer.h
//  SuperTimerTest
//
//  Created by Timothy Edwards on 20/12/2014.
//  Copyright (c) 2014 Timothy Edwards. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface SuperTimer : NSObject
{
    @public

    uint64_t    intervalSamples,
                samplesSinceLastCall;
    
    AudioUnit   timerAU;
    
    void (^tickMethod)(void);
}

-(id)initWithInterval:(uint64_t)samples :(void(^)(void))completion;

-(void)setInterval:(uint64_t)samples;

-(void)setCompletion:(void(^)(void))completion;

@end