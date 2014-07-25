#import "FSEvent.h"



@implementation FSEvent

-(id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

-(id)initWithName:(NSString *)name
{
    if (self = [super init]) {
        _name = name;
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    return [[FSEvent alloc] initWithName:_name];
}

+(instancetype)eventWithName:(NSString *)name
{
    return [[FSEvent alloc] initWithName:name];
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
