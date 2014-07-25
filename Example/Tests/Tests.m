#import "FSMachine.h"
#import "FSExceptions.h"



SPEC_BEGIN(InitialTests)

context(@"Machine validation", ^{

    context(@"should fail if created with", ^{

        it(@"no states", ^{
            [[theBlock(^{
                [FSMachine machineWithBuilder:^(FSMachineBuilder *add) {}];
            }) should] raiseWithName:FSValidationException];
        });

        it(@"no edges from initial state", ^{
            [[theBlock(^{
                [FSMachine machineWithBuilder:^(FSMachineBuilder *add) {
                    [add addState:@"initial"];
                }];
            }) should] raiseWithName:FSValidationException];
        });

        it(@"inaccessible states", ^{
            [[theBlock(^{
                [FSMachine machineWithBuilder:^(FSMachineBuilder *add) {
                    id initial = [add addState:@"initial"];
                    id second = [add addState:@"second"];
                    [add addState:@"inaccessible"];
                    [initial transitionTo:second onEvent:[add addEvent:@"transition"]];
                }];
            }) should] raiseWithName:FSValidationException];
        });
    });
});

context(@"Machine", ^{

    __block id move;
    __block id one;
    __block id two;
    __block FSMachine *machine;

    beforeEach(^{
        move = [FSEvent eventWithName:@"move"];
        one = [FSState stateWithName:@"one"];
        two = [FSState stateWithName:@"two"];
    });

    context(nil, ^{

        beforeEach(^{
            [one transitionTo:two onEvent:move];
            machine = [FSMachine machineWithStates:@[one, two]];
        });

        it(@"should start in initial state", ^{
            [[machine.state should] equal:one];
        });


        it(@"should perform unconditional transition", ^{
            [machine post:move];
            [[expectFutureValue(machine.state) shouldEventually] equal:two];
        });
    });

    context(nil, ^{

        __block FSConditionBlock passingCondition = ^{ return YES; };
        __block FSConditionBlock failingCondition = ^{ return NO; };

        it(@"should perform satisfied conditional transition", ^{
            [one transitionTo:two onEvent:move ifTrue:passingCondition];
            machine = [FSMachine machineWithStates:@[one, two]];
            [machine post:move];
            [[expectFutureValue(machine.state) shouldEventually] equal:two];
        });

        it(@"should not perform unsatisfied conditional transition", ^{
            [one transitionTo:two onEvent:move ifTrue:failingCondition];
            machine = [FSMachine machineWithStates:@[one, two]];
            [machine post:move];
            [[expectFutureValue(machine.state) shouldEventually] equal:one];
        });
    });
});

context(@"Machine construction", ^{

    // This is a dev area for the DSL, rather than a set of tests that might fail at runtime

    it(@"should work via initialiser", ^{

        FSState *idle = [FSState stateWithName:@"idle"];
        FSState *running = [FSState stateWithName:@"running"];

        FSEvent *start = [FSEvent eventWithName:@"start"];
        FSEvent *stop = [FSEvent eventWithName:@"stop"];

        [idle transitionTo:running onEvent:start];
        [running transitionTo:idle onEvent:stop];

        id machine = [[FSMachine alloc] initWithStates:@[idle, running]];
#pragma unused(machine)
    });

    it(@"should work via builder", ^{

        [FSMachine machineWithBuilder:^(FSMachineBuilder *add) {

            FSState *idle = [add addState:@"idle"];
            FSState *running = [add addState:@"running"];

            FSEvent *start = [add addEvent:@"start"];
            FSEvent *stop = [add addEvent:@"stop"];
            
            [idle transitionTo:running onEvent:start];
            [running transitionTo:idle onEvent:stop];
        }];
    });
});

SPEC_END
