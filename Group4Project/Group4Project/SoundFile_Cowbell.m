//
//  SoundFile_Cowbell.m
//  Group4Project
//
//  Created by Lab User on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoundFile_Cowbell.h"

@implementation SoundFile_Cowbell

-(id)init
{
	self = [super init];
	
    /* get a path to the sound file */
    /* note that the file name and file extension are set here */
	CFURLRef mSoundFileURLRef = CFBundleCopyResourceURL(CFBundleGetMainBundle(),CFSTR("cowbell"),CFSTR("wav"),NULL);
    
	/* open the file and get the fileID */
	OSStatus result = noErr;
	result = AudioFileOpenURL(mSoundFileURLRef,kAudioFileReadPermission,0,&fileID);
	if (result != noErr)
		NSLog(@"AudioFileOpenURL exception %ld",result);
	
    [self play];
    
	return self;
}

-(void)dealloc
{
	/* close the file */
	OSStatus result = noErr;
	result = AudioFileClose(fileID);
	if (result != noErr)
		NSLog(@"AudioFileClose %ld",result);	
}


-(void)fillSampleBuffer:(Float64*)buffer:(UInt32)num_buf_samples
{
    /* set up arguments needed by AudioFileReadPackets */
	UInt32 ioNumPackets = num_buf_samples * 1 ;
	SInt64 inStartingPacket = (SInt64)filePos; /* convert float to int */
	UInt32 outNumBytes = 0;
    
    /* read some data */
	OSStatus result = AudioFileReadPackets(fileID,NO,&outNumBytes,NULL,inStartingPacket,&ioNumPackets,fileBuffer);
	if (result != noErr)
		NSLog(@"AudioFileReadPackets exception %ld",result);
    
    /* advance the member variable filePos to know where to read from next time this method is called */
	if (ioNumPackets == num_buf_samples * 1)
    {
        filePos += ioNumPackets;
    }
    else
    {
        filePos = 0;
    }
    
    if (pauseFile == NO)
    {
        /* convert the buffer of sample read from sound file into the app's internal audio buffer */
        for (UInt32 buf_pos = 0; buf_pos < num_buf_samples; buf_pos++)
        {
            Float64 s = (SInt16)CFSwapInt16BigToHost(fileBuffer[buf_pos*1]);
            buffer[buf_pos] += s / INT16_MAX;
        }
    }
}
-(BOOL)isPaused { return pauseFile; }
-(void)pause
{
    pauseFile = YES;
}

-(void)play
{
    pauseFile = NO;
}

@end
