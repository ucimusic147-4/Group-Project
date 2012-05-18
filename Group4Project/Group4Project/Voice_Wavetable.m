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
    
    Float64 harmonics[24] = {0.7532,0.3546,0.1916,0.096,0.0968,0.0352,0.0034,0.0236,0.0111,0.0070,0.0070,0.0059,0.0055,0.0074,0.0059,0.0035,0.0026,0.0023,0.0023,0.0025,0.0009,0.0008,0.0008,0.0007};
    /*
    harmonics[0] = 0.7532;
    harmonics[1] = 0.3546;
    harmonics[2] = 0.1916;
    harmonics[3] = 0.0996;
    harmonics[4] = 0.0968;
    harmonics[5] = 0.0352;
    harmonics[6] = 0.0034;
    harmonics[7] = 0.0236;
    harmonics[8] = 0.0111;
    harmonics[9] = 0.0070;
    harmonics[10] = 0.0070;
    harmonics[11] = 0.0059;
    harmonics[12] = 0.0055;
    harmonics[13] = 0.0074;
    harmonics[14] = 0.0059;
    harmonics[15] = 0.0035;
    harmonics[16] = 0.0026;
    harmonics[17] = 0.0023;
    harmonics[18] = 0.0025;
    harmonics[19] = 0.0009;
    harmonics[20] = 0.0008;
    harmonics[21] = 0.0008;
    harmonics[22] = 0.             
    harmonics[23] = 0.             
       */       
              
              
              
              
              
              
    /* for each harmonic (outer loop) */
    for (UInt16 k = 1; k <= 24; k++)
    {
        
        /* add to the wavetable the harmonic, a sinusoid that is an integer multiple of the fundamental frequency (inner loop) */
        if (k/2 !=0)
        {
            for (UInt16 i = 0; i < kWaveTableSize; i++)
            {
                const Float64 t = (Float64)i / kWaveTableSize * k;
                table[i] += sin(t * 2 * M_PI) * harmonics[k-1];
                
                
                
                
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
