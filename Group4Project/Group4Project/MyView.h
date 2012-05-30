//
//  MyView.h
//  Music147_2012
//
//  Created by Kojiro Umezaki on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// stephen added a note

#import <UIKit/UIKit.h>

@interface MyView : UIView {
    
}

-(IBAction)playToggle:(id)sender;
-(IBAction)toggleVoice1:(id)sender;
-(IBAction)toggleVoice2:(id)sender;
-(IBAction)toggleVoice3:(id)sender;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

/* accelerometer becoming first responder

- (BOOL)canBecomeFirstResponder;
- (void)viewDidAppear:(BOOL)animated;

// accelerometer functions

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event;

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event;

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event;

*/  

@end
