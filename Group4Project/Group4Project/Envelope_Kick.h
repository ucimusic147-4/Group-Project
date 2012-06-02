//
//  Envelope_Kick.h
//  Group4Project
//
//  Created by Lab User on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Envelope_Kick : NSObject {
    
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
