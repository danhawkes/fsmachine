#import <Foundation/Foundation.h>



@interface FSEvent : NSObject <NSCopying>

-(id)initWithName:(NSString*)name;

+(instancetype)eventWithName:(NSString*)name;

@property (nonatomic, strong, readonly) NSString *name;

@end
