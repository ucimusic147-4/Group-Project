//
//  Voice_WavetableNoise.m
//  Group4Project
//
//  Created by Lab User on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Voice_WavetableNoise.h"

#import "AQplayer.h"


@implementation Voice_WavetableNoise

@synthesize env;


-(id)init
{
    self = [super init];

    amp = 0.;
    
    b = malloc(sizeof(biquad));
    [self biQuad_set];    

    
	env = [[Envelope_Kick alloc] init];
	env.attack = 0.05;
	env.release = 0.05;    


    
    Float64 harmonics[24] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1};
    
    
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
        
		buffer_temp[i] = amp * 10 * env.output * s;
        buffer_temp[i] = [self biQuad:buffer_temp[i]];

        
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

-(void) biQuad_set
{
    Float64 A, omega, sn, cs, alpha, beta;
    Float64 a0, a1, a2, b0, b1, b2;
    
    ffreq = 500.;
    dbGain = 0.;
    
    /* setup variables */
    A = pow(10, dbGain /40);
    omega = 2 * M_PI * ffreq /kSR;
    sn = sin(omega);
    cs = cos(omega);
    alpha = sn * sinh(M_LN2 /2 * 1 * omega /sn);
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
-(smp_type) biQuad:(smp_type)sample
{
    smp_type result;
    
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
