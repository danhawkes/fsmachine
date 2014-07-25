#import "FSMachine.h"
#import "FSExceptions.h"



SPEC_BEGIN(Examples)

context(nil, ^{

    it(@"Vending Machine", ^{

        // Dispense a can for 3 mBTC. Don't give any change, but carry credit over to the next person.

        id insert1 = [FSEvent eventWithName:@"insert 1"];
        id insert2 = [FSEvent eventWithName:@"insert 2"];

        id machine = [FSMachine machineWithBuilder:^(FSMachineBuilder *machine) {

            id zero = [machine addState:@"zero"];
            id ten = [machine addState:@"one"];
            id twenty = [machine addState:@"two"];

            FSActionBlock dispenseCan = ^{
                NSLog(@"Kerchunk!");
            };

            [zero transitionTo:ten onEvent:insert1];
            [zero transitionTo:twenty onEvent:insert2];

            [ten transitionTo:twenty onEvent:insert1];
            [ten transitionTo:zero onEvent:insert2 withAction:dispenseCan];

            [twenty transitionTo:zero onEvent:insert1 withAction:dispenseCan];
            [twenty transitionTo:ten onEvent:insert2 withAction:dispenseCan];
        }];

        [machine post:insert1]; // "ten"
        [machine post:insert1]; // "twenty"
        [machine post:insert2]; // "Kerchunk!"

        // (next person comes along…)

        [machine post:insert2];  // "Kerchunk!"
    });
});

SPEC_END
