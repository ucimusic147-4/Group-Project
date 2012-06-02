//
//  SoundFile_Cowbell.h
//  Group4Project
//
//  Created by Lab User on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Voice.h"

/* the maximum number of samples we can read at one time */
#define kMaxIOBufferSamples	1024

@interface SoundFile_Cowbell : Voice {
    
    /* a kind of system pointer to the audio file */
	AudioFileID		fileID;
    
    /* the buffer which will contain data read from the audio file */
	SInt16			fileBuffer[kMaxIOBufferSamples];
	
    /* the index where the next read in the file will happen  */
	Float64			filePos;
    
    BOOL         pauseFile;
    
}

/* calling this will read the next buffer of samples */
-(void)fillSampleBuffer:(Float64*)buffer:(UInt32)num_buf_samples;
-(void)pause;
-(void)play;
-(BOOL)isPaused;


@end
