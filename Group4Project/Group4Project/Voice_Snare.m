//
//  Voice_Snare.m
//  Group4Project
//
//  Created by Lab User on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Voice_Snare.h"

#import "AQplayer.h"

// this generates the sound when you shake the phone.

@implementation Voice_Snare

@synthesize env;


-(id)init
{
    self = [super init];

    amp = 0.;
    
    b = malloc(sizeof(biquadE));
    [self biQuad_set];    

    // one theory on why the sounds behave differently, is that Absynth can deal with finer grain control of envelope times.
    
	env = [[Envelope_Kick alloc] init];
	env.attack = 0.001;
	env.release = 0.002;    
//    env.sustain = 0.0322;
    env.sustain = 0.1;


    // harmonics
    
    Float64 harmonics[24] = {0.0056, 0.0148, 0.0412, 0.1561, 0.0406, 0.204, 0.0625, 0.0544, 0.0451, 0.0602, 0.0625, 0.0489, 0.0138, 0.0287, 0.0159, 0.017, 0.028, 0.0373, 0.0281, 0.0202, 0.0207, 0.0309, 0.0329, 0.0386};
    
    
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
    deltaTheta = 38.0 / kSR;
    
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
        
        // an odd hack to allow us to process the instrument, then apply filtering (see for loop w/ buffer and buffer_temp below).  Found out you get really odd distortion if you try to biQuad the entire buffer instead of frame by frame.  --Stephen

        
        buffer_temp[i] = amp * s * env.output;        
        buffer_temp[i] = [self biQuadE:buffer_temp[i]];

        
		theta += deltaTheta;
	}

    
    
    
    for (SInt32 i = 0; i < num_samples; i++)
    {
        buffer[i] += buffer_temp[i];

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

// an attempt to define instrument specific filtering in the class


-(void) biQuad_set
{
    Float64 A, omega, sn, cs, alpha, beta;
    Float64 a0, a1, a2, b0, b1, b2;
    
    ffreq = 500.;
    dbGain = 0.;
    bandwidth = 1.0;
    
    /* setup variables */
    A = pow(10, dbGain /40);
    omega = 2 * M_PI * ffreq /kSR;
    sn = sin(omega);
    cs = cos(omega);
    alpha = sn * sinh(M_LN2 /2 * bandwidth * omega /sn);
    beta = sqrt(A + A);
    

            b0 = (1 - cs) /2;
            b1 = 1 - cs;
            b2 = (1 - cs) /2;
            a0 = 1 + alpha;
            a1 = -2 * cs;
            a2 = 1 - alpha;
    
    /* precompute the coefficients */
    b->a0 = b0 /a0;
    b->a1 = b1 /a0;
    b->a2 = b2 /a0;
    b->a3 = a1 /a0;
    b->a4 = a2 /a0;
    
    /* zero initial samples */
    b->x1 = b->x2 = 0;
    b->y1 = b->y2 = 0;
}

/* Below this would be biquad.c */
/* Computes a BiQuad filter on a sample */
-(smp_typeE) biQuadE:(smp_typeE)sample
{
    smp_typeE result;
    
    /* compute result */
    result = b->a0 * sample + b->a1 * b->x1 + b->a2 * b->x2 -
    b->a3 * b->y1 - b->a4 * b->y2;
    
    /* shift x1 to x2, sample to x1 */
    b->x2 = b->x1;
    b->x1 = sample;
    
    /* shift y1 to y2, result to y1 */
    b->y2 = b->y1;
    b->y1 = result;
    
    return result;
}

@end
