//
//  Effect_Delay.m
//  Music147
//
//  Created by Kojiro Umezaki on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Effect_Delay.h"


@implementation Effect_Delay

@synthesize delayAmp;
@synthesize delayTime;

-(id) init
{
	delayAmp = 0.5;
	delayTime = kMaxDelayTime * 0.5;
	
	readPos = kMaxDelaySamples - (kMaxDelaySamples * delayTime / kMaxDelayTime);
	writePos = 0;
	
	return self;
}

-(void) process:(Float64*)buffer:(UInt32)num_samples
{
	/* read from delay buffer */
	for (UInt32 i = 0; i < num_samples; i++)
		buffer[i] += buffer[i] + delayAmp * delayBuffer[(i+readPos)%kMaxDelaySamples];
	
	readPos += num_samples;
	readPos %= kMaxDelaySamples;

	/* write into delay buffer */
	for (UInt32 i = 0; i < num_samples; i++)
		delayBuffer[(i+writePos)%kMaxDelaySamples] = buffer[i];
	
	writePos += num_samples;
	writePos %= kMaxDelaySamples;
}

@end
