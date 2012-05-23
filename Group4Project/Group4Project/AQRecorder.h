//
//  AQRecorder.h
//  Music147
//
//  Created by Kojiro Umezaki on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <Foundation/Foundation.h>

/* number of buffers used by system */
#define kNumberBuffers	3

/* sample rate */
#define kSR				22050.

/* maximum record buffer size */
#define kMaxRecBufferSize	(UInt32)(kSR * 5.0)

@interface AQRecorder : NSObject {
    
	AudioQueueRef				queue;
	AudioQueueBufferRef			buffers[kNumberBuffers];
	AudioStreamBasicDescription	dataFormat;
	
	Float64	audioBuffer[kMaxRecBufferSize];
	UInt32	readPos;
	UInt32	writePos;
	
	BOOL	playing;
}

-(void)setup;

-(OSStatus)start;
-(OSStatus)stop;

-(void)play;

-(void)saveAudioBuffer:(Float64*)buffer:(UInt32)num_samples;

-(void)fillAudioBuffer:(Float64*)buffer:(UInt32)num_samples;

@end
