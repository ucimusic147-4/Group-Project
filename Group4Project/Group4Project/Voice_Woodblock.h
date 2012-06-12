//
//  Voice_Woodblock.h
//  Group4Project
//
//  Created by Lab User on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Voice_Synth.h"

#import "Envelope_Kick.h"
#import "Effect.h"


#define kWaveTableSize 1024

/* whatever sample type you want */
typedef Float64 smp_typeI;

/* this holds the data required to update samples thru a filter */
typedef struct {
    Float64 a0, a1, a2, a3, a4;
    Float64 x1, x2, y1, y2;
}
biquadI;



@interface Voice_Woodblock : Voice_Synth {
    Float64 table[kWaveTableSize];
    
    Envelope_Kick* env;
    

    biquadI* b;

    Float64   dbGain;
    Float64   ffreq;
    Float64   bandwidth;
    
    /* create a temporary buffer of Float64 type samples */
	Float64 buffer_temp[kWaveTableSize];
    

}

@property (retain,nonatomic) Envelope_Kick* env;


-(void)fillSampleBuffer:(Float64*)buffer:(UInt32)num_samples;
-(BOOL)isOn;
-(void)on;
-(void)off;


-(smp_typeI) biQuadI:(smp_typeI)sample;

-(void) biQuad_set;

-(void) process:(Float64*)buffer:(UInt32)num_samples;


@end
