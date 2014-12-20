//
//  SuperTimer.m
//  SuperTimerTest
//
//  Created by Timothy Edwards on 20/12/2014.
//  Copyright (c) 2014 Timothy Edwards. All rights reserved.
//

#import "SuperTimer.h"

// render callback function
static OSStatus renderCallback (void                        *inRefCon,
                                AudioUnitRenderActionFlags  *ioActionFlags,
                                const AudioTimeStamp        *inTimeStamp,
                                UInt32                      inBusNumber,
                                UInt32                      inNumberFrames,
                                AudioBufferList             *ioData)
{
    // underscore = local var
    // create object pointer at SuperTimer instance
    SuperTimer *_superTimer   = (__bridge SuperTimer*)inRefCon;
    
    // increment count
    _superTimer->samplesSinceLastCall += inNumberFrames;
    
    if (_superTimer->samplesSinceLastCall == _superTimer->intervalSamples) {
        
        _superTimer->tickMethod();
        
        _superTimer->samplesSinceLastCall = 0;
    }
    return 0;
}


@implementation SuperTimer

-(id)initWithInterval:(uint64_t)samples :(void (^)(void))completion
{
    if ([super init]) {
        UInt32 propsize = 0;
    
        //Specify RemoteIO Audio Unit Component Desciption.
        AudioComponentDescription RIOUnitDescription;
        RIOUnitDescription.componentType          = kAudioUnitType_Output;
        RIOUnitDescription.componentSubType       = kAudioUnitSubType_RemoteIO;
        RIOUnitDescription.componentManufacturer  = kAudioUnitManufacturer_Apple;
        RIOUnitDescription.componentFlags         = 0;
        RIOUnitDescription.componentFlagsMask     = 0;
        
        //Get RemoteIO AU from Audio Unit Component Manager
        AudioComponent rioComponent=AudioComponentFindNext(NULL, &RIOUnitDescription);
        AudioComponentInstanceNew(rioComponent, &(timerAU));
        
        
        //Set up render callback function for the RemoteIO AU.
        AURenderCallbackStruct renderCallbackStruct;
        renderCallbackStruct.inputProc=renderCallback;
        renderCallbackStruct.inputProcRefCon=(__bridge void *)(self);
        propsize=sizeof(renderCallbackStruct);
        
        // Here be dragons
        AudioUnitSetProperty(timerAU,
                             kAudioUnitProperty_SetRenderCallback,
                             kAudioUnitScope_Global,
                             0,
                             &renderCallbackStruct,
                             propsize);
        
        AudioUnitInitialize(timerAU);
        
        [self setInterval:samples];
        
        [self setCompletion:completion];
        
        AudioOutputUnitStart(timerAU);
    }
    
    return self;
}

-(void)setInterval:(uint64_t)samples{
    
    double sampleRate = [[AVAudioSession sharedInstance] sampleRate];
    double bufferDuration = [[AVAudioSession sharedInstance] IOBufferDuration];
    float bufferLength = sampleRate*bufferDuration;
    
    // var setup
    if ((samples % 512) != 0) {
        NSLog(@"WARNING: SAMPLE INTERVAL GIVEN NOT DIVISIBLE BY 512. ROUNDING TO NEAREST FIGURE.");
        
        // round sample interval to nearest figure
        float sampleRounding = (float)samples/bufferLength;
        sampleRounding = sampleRounding + 0.5;
        sampleRounding = (int)sampleRounding;
        
        intervalSamples = sampleRounding * bufferLength;
    } else intervalSamples = samples;
    
    float intervalSeconds = (float)intervalSamples/sampleRate;
    
    NSLog(@"TIMER INTERVAL (SAMPLES): %llu", intervalSamples);
    NSLog(@"TIMER INTERVAL (SECONDS): %f", intervalSeconds);
    
    samplesSinceLastCall = 0;
}

-(void)setCompletion:(void (^)(void))completion{
    tickMethod = completion;
}

// start RemoteIO timer
-(void)startTimer
{
    AudioOutputUnitStart(timerAU);
}

// stop RemoteIO timer & reset beat to beginning of bar
-(void)pauseTimer
{
    AudioOutputUnitStop(timerAU);
}

@end