#import "FSLogger.h"
#import "FSState.h"
#import "FSEvent.h"



@implementation FSDefaultLogger

-(void)stateMachineDidReceiveEvent:(FSEvent *)event andPerformedTransitionFrom:(FSState *)state1 to:(FSState *)state2
{
    NSLog(@"(%@): [%@] -> [%@]", event.name, state1.name, state2.name);
}

@end
