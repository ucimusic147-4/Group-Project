//
//  AQPlayer.h
//  MInC
//
//  Created by Kojiro Umezaki on 4/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <Foundation/Foundation.h>

#import "Voice.h"
#import "SoundFile.h"
#import "Effect.h"


/* number of buffers used by system */
#define kNumberBuffers	3

/* number of voice */
#define kNumberVoices   18

/* number of effects */
#define kNumberEffects  4

/* sample rate */
#define kSR				22050.

@interface AQPlayer : NSObject {

	AudioQueueRef				queue;
	AudioQueueBufferRef			buffers[kNumberBuffers];
	AudioStreamBasicDescription	dataFormat;
    
    Voice* voices[kNumberVoices];
    
    Effect* effect[kNumberEffects];

}

-(void)setup;

-(OSStatus)start;
-(OSStatus)stop;

-(void)fillAudioBuffer:(Float64*)buffer:(UInt32)num_samples;

-(Voice*)getFreeVoice;

-(void)voiceToggle:(UInt16)pos;
-(void)voiceOn:(UInt16)pos;
-(void)voiceOff:(UInt16)pos;

-(void)reportElapsedTime:(Float64)elapsed_time;

@end
