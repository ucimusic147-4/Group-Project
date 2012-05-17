//
//  Voice_Wavetable.m
//  Group4Project
//
//  Created by Lab User on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Voice_Wavetable.h"

#import "AQplayer.h"

@implementation Voice_Wavetable

-(id)init
{
    self = [super init];
    
    /* for each harmonic (outer loop) */
    for (UInt16 k = 1; k <= 10; k++)
    {
        
        /* add to the wavetable the harmonic, a sinusoid that is an integer multiple of the fundamental frequency (inner loop) */
        if (k/2 !=0)
        {
            for (UInt16 i = 0; i < kWaveTableSize; i++)
            {
                const Float64 t = (Float64)i / kWaveTableSize * k;
                table[i] += sin(t * 2 * M_PI) / (k*k);
                
                
                
                
            }
        }
        
    }    
    return self;
}


-(void)fillSampleBuffer:(Float64*)buffer:(UInt32)num_samples
{
    
    
    deltaTheta = freq / kSR;
    
    

    
	for (SInt32 i = 0; i < num_samples; i++)
	{
        SInt32 i0 = (SInt32)(theta * kWaveTableSize) % kWaveTableSize;
        SInt32 i1 = (i0 + 1) % kWaveTableSize; /* the next adjacent table index */
        Float64 k = theta - (SInt32)theta; /* get the fractional amount of theta */
        Float64 s0 = table[i0]; /* get the origin sample */
        Float64 s1 = table[i1]; /* get the next sample */
        Float64 s = s0 + (s1 - s0) * k; /* now find the point between the two samples that we actually care about, which is the fractional offset of theta */
        
        buffer[i] += amp * s;
        
		theta += deltaTheta;
	}
}


@end
