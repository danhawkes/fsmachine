#import "FSExceptions.h"



NSString * const FSValidationException = @"FSValidationException";


@implementation FSExceptions

+(NSException*)validationExceptionWithReason:(NSString*)reason
{
    return [NSException exceptionWithName:FSValidationException reason:reason userInfo:nil];
}

@end
