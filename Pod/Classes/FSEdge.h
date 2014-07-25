#import <Foundation/Foundation.h>
#import "FSAction.h"
#import "FSCondition.h"



@class FSState;
@class FSEvent;


/*!
 Represents a transition between two states.
 */
@interface FSEdge : NSObject <NSCopying>

-(id)initWithDestinationState:(FSState*)state event:(FSEvent*)event;
-(id)initWithDestinationState:(FSState*)state event:(FSEvent*)event action:(FSActionBlock)action condition:(FSConditionBlock)condition;

@property (nonatomic, strong, readonly) FSEvent *event;
@property (nonatomic, strong, readonly) FSState *destinationState;
@property (nonatomic, copy) FSActionBlock action;
@property (nonatomic, copy) FSConditionBlock condition;

@end