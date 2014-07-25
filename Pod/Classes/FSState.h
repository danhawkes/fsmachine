#import <Foundation/Foundation.h>
#import "FSAction.h"
#import "FSCondition.h"



@class FSEvent;



@interface FSState : NSObject <NSCopying>

#pragma mark - Creating a State

-(id)initWithName:(NSString*)name enterAction:(FSActionBlock)enter exitAction:(FSActionBlock)exit;

+(instancetype)stateWithName:(NSString*)name;
+(instancetype)stateWithName:(NSString*)name enterAction:(FSActionBlock)enter;
+(instancetype)stateWithName:(NSString*)name exitAction:(FSActionBlock)exit;
+(instancetype)stateWithName:(NSString*)name enterAction:(FSActionBlock)enter exitAction:(FSActionBlock)exit;

#pragma mark - Creating Transitions from this State

/*!
 Triggers a state transition when the named event is received and the given condition is satisfied.

 @param action Action block to execute during the transition.
 @param condition Condition that must be satisfied for the transition to occur.
 */
-(void)transitionTo:(FSState*)state onEvent:(FSEvent*)event withAction:(FSActionBlock)action ifTrue:(FSConditionBlock)condition;

/*!
 Triggers a state transition when the named event is received and the given condition is satisfied.

 @param action Action block to execute during the transition.
 @param condition Condition that must be satisfied for the transition to occur.
 */
-(void)transitionTo:(FSState*)state onEvent:(FSEvent*)event withAction:(FSActionBlock)action ifFalse:(FSConditionBlock)condition;

/*!
 Triggers a state transition when the named event is received.

 @param action Action block to execute during the transition.
 */
-(void)transitionTo:(FSState*)state onEvent:(FSEvent*)event withAction:(FSActionBlock)action;

/*!
 Triggers a state transition when the named event is received and the given condition is satisfied.

 @param condition Condition that must be satisfied for the transition to occur.
 */
-(void)transitionTo:(FSState*)state onEvent:(FSEvent*)event ifTrue:(FSConditionBlock)condition;

/*!
 Triggers a state transition when the named event is received and the given condition is satisfied.

 @param condition Condition that must be satisfied for the transition to occur.
 */
-(void)transitionTo:(FSState*)state onEvent:(FSEvent*)event ifFalse:(FSConditionBlock)condition;

/*!
 Triggers a state transition when the named event is received.
 */
-(void)transitionTo:(FSState*)state onEvent:(FSEvent*)event;

#pragma mark - State Properties

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong) NSMutableArray *edges;

/*!
 Action to perform when entering the state.

 @discussion Use this when implementing a Moore-style machine where outputs correspond directly to states.
 */
@property (nonatomic, copy) FSActionBlock enterAction;

/*!
 Action to perform when leaving the state.
 */
@property (nonatomic, copy) FSActionBlock exitAction;

@end
