#import <Foundation/Foundation.h>

/// @brief NSOperation subclass used to load data with specified URL asynchronously on background thread. Requested URL and loaded data can be retrieved using instance properties. When one or more operations in progress, network activity indicator will be visible. When no operations in progress, network activity indicator will be hidden. URLOperation can be subclassed to add additional connection options like HTTP method, HTTP body, authentication, etc. 
@interface URLOperation : NSOperation

/// URL of data to load.
@property (strong, nonatomic) NSString *url;

/// Loaded data.
@property (strong, nonatomic) NSMutableData *data;

/// Initialize object with URL of data to load.
/// @param u URL of data to load.
/// @param success block to execute in the case of success.
/// @param failure block to execute in the case of failure.
/// @return initialized object.
- (id)initWithURL:(NSString*)u successBlock:(void (^)(id result))success failureBlock:(void (^)(NSError *error))failure;

@end