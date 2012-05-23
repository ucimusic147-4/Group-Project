//
//  Effect_Biquad.h
//  Music147_2012
//
//  Created by Kojiro Umezaki on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Effect.h"

/* filter types */
enum {
    LPF, /* low pass filter */
    HPF, /* high pass filter */
    BPF, /* band pass filter */
    NOTCH, /* notch filter */
    PEQ, /* peaking band EQ filter */
    LSH, /* low shelf filter */
    HSH /* high shelf filter */
};

/* whatever sample type you want */
typedef Float64 smp_type;

/* this holds the data required to update samples thru a filter */
typedef struct {
    Float64 a0, a1, a2, a3, a4;
    Float64 x1, x2, y1, y2;
}
biquad;

@interface Effect_Biquad : Effect {
    biquad* b;
}

-(smp_type) biQuad:(smp_type)sample;

-(void) biQuad_set:(int)type:(Float64)dbGain:(Float64)freq:(Float64)srate:(Float64)bandwidth;

-(void) process:(Float64*)buffer:(UInt32)num_samples;

@end
