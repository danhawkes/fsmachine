#import <Foundation/Foundation.h>



extern NSString * const FSValidationException;



@interface FSExceptions : NSObject

+(NSException*)validationExceptionWithReason:(NSString*)reason;

@end
