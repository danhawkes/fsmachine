#import "FSMachine.h"
#import "FSEdge.h"
#import "FSLogger.h"
#import "FSExceptions.h"



@interface FSMachine ()

-(void)validateConfiguration;
-(void)logEvent:(FSEvent*)event andPossibleTransitionFrom:(FSState*)state1 to:(FSState*)state2;

@property (nonatomic, strong, readwrite) FSState *state;
@property (nonatomic, strong) NSArray *states;
@property (nonatomic) dispatch_queue_t queue;

@end



@implementation FSMachine

-(id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return self;
}

-(id)initWithStates:(NSArray *)states
{
    return [self initWithStates:states queue:nil];
}

+(instancetype)machineWithStates:(NSArray *)states
{
    return [[FSMachine alloc] initWithStates:states];
}

-(id)initWithStates:(NSArray *)states queue:(dispatch_queue_t)queue
{
    if (self = [super init]) {
        states = [[NSArray alloc] initWithArray:states copyItems:YES];
        _states = states;
        _state = [states firstObject];
        _logger = [FSDefaultLogger new];
        _queue = queue ? queue : dispatch_get_main_queue();
        [self validateConfiguration];
    }
    return self;
}

+(instancetype)machineWithStates:(NSArray *)states queue:(dispatch_queue_t)queue
{
    return [[FSMachine alloc] initWithStates:states queue:queue];
}

-(id)initWithBuilder:(void (^)(FSMachineBuilder *))block
{
    if (self = [super init]) {
        FSMachineBuilder *builder = [FSMachineBuilder new];
        block(builder);
        _states = [[NSArray alloc] initWithArray:builder.states copyItems:YES];
        _state = [_states firstObject];
        _logger = [FSDefaultLogger new];
        _queue = builder.queue ? builder.queue : dispatch_get_main_queue();
        [self validateConfiguration];

    }
    return self;
}

+(instancetype)machineWithBuilder:(void (^)(FSMachineBuilder *))block
{
    return [[FSMachine alloc] initWithBuilder:block];
}

-(void)validateConfiguration
{
    if (_states.count < 1) {
        @throw [FSExceptions validationExceptionWithReason:@"At least one state is required"];
    }
    if (_state.edges.count == 0) {
        @throw [FSExceptions validationExceptionWithReason:[NSString stringWithFormat:@"Initial state %@ does not have any exiting edges: it is impossible to leave the state.", _state]];
    }
    NSMutableDictionary *stateEdgesMap = [NSMutableDictionary dictionary];
    for (FSState *state in _states) {
        [stateEdgesMap setObject:[NSMutableArray array] forKey:state];
    }
    for (FSState *state in _states) {
        for (FSEdge *edge in state.edges) {
            [stateEdgesMap[state] addObject:edge];
            [stateEdgesMap[edge.destinationState] addObject:edge];
        }
    }
    for (FSState *state in stateEdgesMap.allKeys) {
        NSDictionary *edges = stateEdgesMap[state];
        if (edges.count == 0) {
            @throw [FSExceptions validationExceptionWithReason:[NSString stringWithFormat:@"State %@ is not connected to other states by any edges: it is impossible to enter the state.", state]];
        }
    }
}

-(void)logEvent:(FSEvent *)event andPossibleTransitionFrom:(FSState *)state1 to:(FSState *)state2
{
    if (state1 && state2) {
        if ([_logger respondsToSelector:@selector(stateMachineDidReceiveEvent:andPerformedTransitionFrom:to:)]) {
            [_logger stateMachineDidReceiveEvent:event andPerformedTransitionFrom:state1 to:state2];
        }
    } else {
        if ([_logger respondsToSelector:@selector(stateMachineDidReceiveEventButNoTransitionOccurred:)]) {
            [_logger stateMachineDidReceiveEventButNoTransitionOccurred:event];
        }
    }
}

-(void)post:(FSEvent *)event
{
    dispatch_async(_queue, ^{

        FSEdge *transition = nil;

        for (FSEdge *edge in _state.edges) {

            if ([edge.event isEqual:event]) {

                // Attempt transition
                if (edge.condition && !edge.condition()) {
                    // Failed condition, so continue
                    continue;
                } else {
                    // No condition, so transition
                    transition = edge;
                    break;
                }
            }
        }

        [self logEvent:event andPossibleTransitionFrom:_state to:transition.destinationState];

        if (transition) {

            if (_state.exitAction) {
                _state.exitAction();
            }
            if (transition.action) {
                transition.action();
            }
            self.state = transition.destinationState;
            if (_state.enterAction) {
                _state.enterAction();
            }
        }
    });
}

@end
