#import "FSEdge.h"
#import "FSEvent.h"
#import "FSState.h"



@implementation FSEdge

-(id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

-(id)initWithDestinationState:(FSState *)state event:(FSEvent *)event
{
    return [self initWithDestinationState:state event:event action:nil condition:nil];
}

-(id)initWithDestinationState:(FSState *)state event:(FSEvent *)event action:(FSActionBlock)action condition:(FSConditionBlock)condition
{
    if (self = [super init]) {
        _destinationState = state;
        _event = event;
        _action = action;
        _condition = condition;
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    return [[FSEdge alloc] initWithDestinationState:_destinationState
                                              event:_event
                                             action:[_action copy]
                                          condition:[_condition copy]
            ];
}

@end
