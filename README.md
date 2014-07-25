# FSMachine

[![CI Status](http://img.shields.io/travis/danhawkes/FSMachine.svg?style=flat)](https://travis-ci.org/danhawkes/FSMachine)
[![Version](https://img.shields.io/cocoapods/v/FSMachine.svg?style=flat)](http://cocoadocs.org/docsets/FSMachine)
[![License](https://img.shields.io/cocoapods/l/FSMachine.svg?style=flat)](http://cocoadocs.org/docsets/FSMachine)
[![Platform](https://img.shields.io/cocoapods/p/FSMachine.svg?style=flat)](http://cocoadocs.org/docsets/FSMachine)

A straightforward state machine in Obj-C.

Features:

* Support for Moore and Mealy-style machines
* Actions on state enter/exit, and during transitions
* Conditional transitions
* Up-front machine validation
* Configurable logging

## Installation

FSMachine is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "FSMachine"

## Usage

// TODO

## Example

```objective-c
// Dispense a can for 3 mBTC. Don't give any change, but carry credit over to the next person.

FSEvent *insert1 = [FSEvent eventWithName:@"insert 1"];
FSEvent *insert2 = [FSEvent eventWithName:@"insert 2"];

FSMachine *machine = [FSMachine machineWithBuilder:^(FSMachineBuilder *machine) {

    FSState *zero = [machine addState:@"zero"];
    FSState *one = [machine addState:@"one"];
    FSState *two = [machine addState:@"two"];

    FSActionBlock dispenseCan = ^{
        NSLog(@"Kerchunk!");
    };

    [zero transitionTo:one onEvent:insert1];
    [zero transitionTo:two onEvent:insert2];

    [one transitionTo:two onEvent:insert1];
    [one transitionTo:zero onEvent:insert2 withAction:dispenseCan];

    [two transitionTo:zero onEvent:insert1 withAction:dispenseCan];
    [two transitionTo:one onEvent:insert2 withAction:dispenseCan];
}];

[machine post:insert1]; // [zero] -> [one]
[machine post:insert1]; // [one] -> [two]
[machine post:insert2]; // [two] -> [one], "Kerchunk!"

// (next person comes along…)

[machine post:insert2];  // [one] -> [zero], "Kerchunk!"

```

## To do

* More examples
* Markov models?

## Contributing

…is encouraged. Bug reports and pull requests are welcome.

## License

Apache 2.0. See the LICENSE file for more info.
