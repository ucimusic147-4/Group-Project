//
//  Voice.h
//  Music147_2012
//
//  Created by Kojiro Umezaki on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Envelope.h"


@interface Voice : NSObject {
    BOOL on;
    Float64 amp;
    Envelope* env;

}

@property Float64 amp;
@property (retain,nonatomic) Envelope* env;


-(void)fillSampleBuffer:(Float64*)buffer:(UInt32)num_samples;

-(BOOL)isOn;
-(void)on;
-(void)off;

@end
