#import "FSState.h"
#import "FSEdge.h"
#import "FSCondition.h"



@implementation FSState

-(id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return self;
}

-(id)initWithName:(NSString *)name enterAction:(FSActionBlock)enter exitAction:(FSActionBlock)exit
{
    if (self = [super init]) {
        _name = name;
        _enterAction = enter;
        _exitAction = exit;
        _edges = [NSMutableArray array];
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    FSState *state = [[FSState alloc] initWithName:_name enterAction:[_enterAction copy] exitAction:[_exitAction copy]];
    if (_edges) {
        state.edges = [[NSMutableArray alloc] initWithArray:_edges copyItems:YES];
    }
    return state;
}

+(instancetype)stateWithName:(NSString *)name
{
    return [[FSState alloc] initWithName:name enterAction:nil exitAction:nil];
}

+(instancetype)stateWithName:(NSString *)name enterAction:(FSActionBlock)enter
{
    return [[FSState alloc] initWithName:name enterAction:enter exitAction:nil];
}

+(instancetype)stateWithName:(NSString *)name exitAction:(FSActionBlock)exit
{
    return [[FSState alloc] initWithName:name enterAction:nil exitAction:exit];
}

+(instancetype)stateWithName:(NSString *)name enterAction:(FSActionBlock)enter exitAction:(FSActionBlock)exit
{
    return [[FSState alloc] initWithName:name enterAction:enter exitAction:exit];
}

-(void)transitionTo:(FSState *)state onEvent:(FSEvent *)event withAction:(FSActionBlock)action ifTrue:(FSConditionBlock)condition
{
    [_edges addObject:[[FSEdge alloc] initWithDestinationState:state event:event action:action condition:condition]];
}

-(void)transitionTo:(FSState *)state onEvent:(FSEvent *)event withAction:(FSActionBlock)action ifFalse:(FSConditionBlock)condition
{

    [_edges addObject:[[FSEdge alloc] initWithDestinationState:state event:event action:action condition:^BOOL() { return !condition(); }]];
}

-(void)transitionTo:(FSState *)state onEvent:(FSEvent *)event withAction:(FSActionBlock)action
{
    [_edges addObject:[[FSEdge alloc] initWithDestinationState:state event:event action:action condition:nil]];
}

-(void)transitionTo:(FSState *)state onEvent:(FSEvent *)event ifTrue:(FSConditionBlock)condition
{
    [_edges addObject:[[FSEdge alloc] initWithDestinationState:state event:event action:nil condition:condition]];
}

-(void)transitionTo:(FSState *)state onEvent:(FSEvent *)event ifFalse:(FSConditionBlock)condition
{
    [_edges addObject:[[FSEdge alloc] initWithDestinationState:state event:event action:nil condition:^BOOL() { return !condition(); }]];
}

-(void)transitionTo:(FSState *)state onEvent:(FSEvent *)event
{
    [_edges addObject:[[FSEdge alloc] initWithDestinationState:state event:event action:nil condition:nil]];
}

-(NSArray *)edges
{
    return [NSArray arrayWithArray:_edges];
}

-(BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    } else if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    } else {
        return [_name isEqualToString:[object name]];
    }
}

-(NSUInteger)hash
{
    return [_name hash];
}

@end
