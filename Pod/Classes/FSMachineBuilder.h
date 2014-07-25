#import <Foundation/Foundation.h>
#import "FSState.h"
#import "FSAction.h"
#import "FSEvent.h"



@class FSMachine;

typedef BOOL (^FSMachineBuilderBlock)(void);



/*! Builder for an FSMachine instance. */
@interface FSMachineBuilder : NSObject

/*! The initial state. This defaults to the first state created via  */
@property (nonatomic, strong) FSState *initialState;

/*! Convenience for creating a state within the builder block. */
-(FSState*)addState:(NSString*)name;

/*! Convenience for creating a state within the builder block. */
-(FSState*)addState:(NSString*)name enterAction:(FSActionBlock)enter;

/*! Convenience for creating a state within the builder block. */
-(FSState*)addState:(NSString*)name exitAction:(FSActionBlock)exit;

/*! Convenience for creating a state within the builder block. */
-(FSState*)addState:(NSString*)name enterAction:(FSActionBlock)enter exitAction:(FSActionBlock)exit;

/*!
 Convenience for creating events within the builder block.

 Note that events can also be created outside the block; they will be included in the state machine as long as they are used within the block. */
-(FSEvent*)addEvent:(NSString*)name;

/*! Queue on which to execute state transitions. Defaults to the main queue. */
@property (nonatomic, assign) dispatch_queue_t queue;

/*! List of states known to the builder. */
@property (nonatomic, strong) NSMutableArray *states;

-(FSMachine*)build;

@end