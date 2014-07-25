#import "FSMachineBuilder.h"
#import "FSMachine.h"



@implementation FSMachineBuilder

-(id)init
{
    if (self = [super init]) {
        _states = [NSMutableArray array];
    }
    return self;
}

-(FSState *)addState:(NSString *)name
{
    return [self addState:name enterAction:nil exitAction:nil];
}

-(FSState *)addState:(NSString *)name enterAction:(FSActionBlock)enter
{
    return [self addState:name enterAction:enter exitAction:nil];
}

-(FSState *)addState:(NSString *)name exitAction:(FSActionBlock)exit
{
    return [self addState:name enterAction:nil exitAction:exit];
}

-(FSState *)addState:(NSString *)name enterAction:(FSActionBlock)enter exitAction:(FSActionBlock)exit
{
    FSState *state = [FSState stateWithName:name enterAction:enter exitAction:exit];
    [_states addObject:state];
    return state;
}

-(FSState *)initialState
{
    return [_states firstObject];
}

-(void)setInitialState:(FSState *)initialState
{
    NSInteger index = [_states indexOfObject:initialState];
    if (index == NSNotFound) {
        [_states insertObject:initialState atIndex:0];
    } else if (index != 0) {
        [_states exchangeObjectAtIndex:index withObjectAtIndex:0];
    }
}

-(FSEvent *)addEvent:(NSString *)name
{
    return [FSEvent eventWithName:name];
}

-(FSMachine *)build
{
    return [[FSMachine alloc] initWithStates:_states];
}

@end