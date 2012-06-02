//
//  Voice_WavetableNoise.h
//  Group4Project
//
//  Created by Lab User on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Voice_Synth.h"
#define kWaveTableSize 1024

@interface Voice_WavetableNoise : Voice_Synth {
    Float64 table[kWaveTableSize];
    
}

-(void)fillSampleBuffer:(Float64*)buffer:(UInt32)num_samples;

@end
