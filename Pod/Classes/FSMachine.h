#import <Foundation/Foundation.h>
#import "FSMachineBuilder.h"
#import "FSEvent.h"
#import "FSState.h"
#import "FSLogger.h"
#import "FSAction.h"



/*!
 A Finite-state Machine with support for both Moore and Mealy-style implementations.

 For more information, see:
 https://en.wikipedia.org/wiki/Finite-state_machine
 https://en.wikipedia.org/wiki/Moore_machine
 https://en.wikipedia.org/wiki/Mealy_machine
 */
@interface FSMachine : NSObject

#pragma mark - Creating a State Machine

/*!
 Initialises a newly allocated state machine.

 @param states A list of states (and associated transitions). The first state in the list is interpreted as the initial state.
 */
-(id)initWithStates:(NSArray*)states;

/*!
 Creates a state machine.

 @param states A list of states (and associated transitions). The first state in the list is interpreted as the initial state.
 */
+(instancetype)machineWithStates:(NSArray*)states;

/*!
 Initialises a newly allocated state machine.

 @param states A list of states (and associated edges). The first state in the list is interpreted as the initial state.
 @param queue Dispatch queue on which to run state transitions. Defaults to the main queue if unspecified.
 */
-(id)initWithStates:(NSArray*)states queue:(dispatch_queue_t)queue;

/*!
 Creates a state machine.

 @param states A list of states (and associated edges). The first state in the list is interpreted as the initial state.
 @param queue Dispatch queue on which to run state transitions. Defaults to the main queue if unspecified.
 */
+(instancetype)machineWithStates:(NSArray*)states queue:(dispatch_queue_t)queue;

/*!
 Initialises a newly allocated state machine.

 @param machine Builder with which to construct the machine. The enclosing block is called immediately, so it is safe to access variables initialised inside the block immediately afterwards.
 */
-(id)initWithBuilder:(void (^) (FSMachineBuilder *machine))block;

/*!
 Creates a state machine using the provided builder block.

 @param machine Builder with which to construct the machine. The enclosing block is called immediately, so it is safe to access variables initialised inside the block immediately afterwards.
 */
+(instancetype)machineWithBuilder:(void (^) (FSMachineBuilder *machine))block;

#pragma mark - Triggering State Transitions

/*!
 Posts an event to the current state.
 */
-(void)post:(FSEvent*)event;

#pragma mark - Observing the Machine's Behaviour

/*! The current state. */
@property (nonatomic, strong, readonly) FSState *state;

/*!
 Logger to call when events are posted and during state transitions.

 Defaults to an instance of FSDefaultLogger.
 */
@property (nonatomic, strong) id<FSLogger> logger;





@end
