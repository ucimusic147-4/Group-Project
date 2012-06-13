//
//  Voice_Rim.m
//  Group4Project
//
//  Created by Lab User on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Voice_Rim.h"

#import "AQplayer.h"

// not in use

@implementation Voice_Rim

@synthesize env;


-(id)init
{
    self = [super init];

    amp = 0.;
    
    b = malloc(sizeof(biquadD));
    [self biQuad_set];    

    
	env = [[Envelope_Kick alloc] init];
	env.attack = 0.001;
	env.release = 0.002;    
//    env.sustain = 0.0237;
    env.sustain = 0.1;


    
    Float64 harmonics[24] = {0.2638, 0.8637, 0.2233, 0.0215, 0.1238, 0.1004, 0.1266, 0.0889, 0.0664, 0.0243, 0.0174, 0.0639, 0.0603, 0.0333, 0.0204, 0.0179, 0.0331, 0.0367, 0.0296, 0.0121, 0.0051, 0.0194, 0.0243, 0.0194};
    
    
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
    deltaTheta = 784.0 / kSR;
    
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
        
        
        buffer_temp[i] = amp * s * env.output;        
        //buffer_temp[i] = [self biQuadD:buffer_temp[i]];

        
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
-(smp_typeD) biQuadD:(smp_typeD)sample
{
    smp_typeD result;
    
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
