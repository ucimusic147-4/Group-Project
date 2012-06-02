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

@synthesize env;


-(id)init
{
    self = [super init];
    
    amp = 0.;
    
	env = [[Envelope alloc] init];
	env.attack = 0.07;
	env.release = 0.2;
    
    Float64 harmonics[24] = {0.7532,0.3546,0.1916,0.096,0.0968,0.0352,0.0034,0.0236,0.0111,0.0070,0.0070,0.0059,0.0055,0.0074,0.0059,0.0035,0.0026,0.0023,0.0023,0.0025,0.0009,0.0008,0.0008,0.0007};
     
      
    /* for each harmonic (outer loop) */
    for (UInt16 k = 1; k <= 24; k++)
    {
        
        /* add to the wavetable the harmonic, a sinusoid that is an integer multiple of the fundamental frequency (inner loop) */
            for (UInt16 i = 0; i < kWaveTableSize; i++)
            {
                const Float64 t = (Float64)i / kWaveTableSize * k;
                table[i] += sin(t * 2 * M_PI) * harmonics[k-1];
            }
    }   
    
    /* find maximum value in table */
    Float64 max = 0.;
    for (UInt16 i = 0; i < kWaveTableSize; i++)
    {
        if (fabs(table[i]) > max)
            max = fabs(table[i]);
    }
    NSLog(@"MAX: %f",max);
    
    /* scale table by maximum value (i.e. normalize) */
    for (UInt16 i = 0; i < kWaveTableSize; i++)
    {
        table[i] = table[i] / max;
       // NSLog(@"%d %f",i,table[i]);
    }
    
    return self;
}


-(void)fillSampleBuffer:(Float64*)buffer:(UInt32)num_samples
{
    deltaTheta = freq / kSR;
    
	for (SInt32 i = 0; i < num_samples; i++)
	{
        /* i0 is the "lower" index; i1 is the "higher" index */   
        SInt32 i0 = (SInt32)(theta * kWaveTableSize) % kWaveTableSize;
        SInt32 i1 = (i0 + 1) % kWaveTableSize;
        
        /* k is the fractional amount between i0 and i1 */
        Float64 k = theta - (SInt32)theta;
        
        /* s0 and s1 are table values at i0 and i1, respectively */
        Float64 s0 = table[i0];
        Float64 s1 = table[i1];
        
        /* s is the interpolated table value */
        Float64 s = s0 + (s1 - s0) * k;
        
        /* update the envelope by one sample */
        [env update:1];
        
		buffer[i] += amp * env.output * s;
        
		theta += deltaTheta;
	}
}


-(BOOL)isOn
{
    return env.output > 0.;
}

-(void)on
{
    [env on];
}

-(void)off
{
    [env off];
}

@end
