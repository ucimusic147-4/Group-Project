//
//  Envelope.h
//  Music147
//
//  Created by Kojiro Umezaki on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Envelope : NSObject {

    Float64 attack;
    Float64 release;

    Float64 delta_attack;
    Float64 delta_release;

    Float64 delta;

    Float64 output;
}

@property (nonatomic,readwrite) Float64 attack;
@property (nonatomic,readwrite) Float64 release;

@property (readonly) Float64 output;

-(void)update:(UInt32)num_samples;
-(void)on;
-(void)off;

@end
