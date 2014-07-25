#import <Foundation/Foundation.h>
#import "FSState.h"
#import "FSEdge.h"


@protocol FSLogger <NSObject>

@optional

/*!
 Called when the machine received an event but did not perform a transition.

 @param event The received event.
 @param state1 The state before the transition.
 @param state2 The state after the transition.
 */
-(void)stateMachineDidReceiveEventButNoTransitionOccurred:(FSEvent*)event;

/*! 
 Called when the machine received an event and performed a transition.
 
 @param event The received event.
 @param state1 The state before the transition.
 @param state2 The state after the transition.
 */
-(void)stateMachineDidReceiveEvent:(FSEvent*)event andPerformedTransitionFrom:(FSState*)state1 to:(FSState*)state2;

@end



@interface FSDefaultLogger : NSObject <FSLogger>

@end