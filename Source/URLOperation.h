#import <Foundation/Foundation.h>

/// @brief NSOperation subclass used to load data with specified URL asynchronously on background thread. After data load successfully, specified selector of specified delegate object is called with URLOperation instance as the only parameter. Requested URL and loaded data can be retrieved using instance properties. When one or more operations in progress, network activity indicator will be visible. When no operations in progress, network activity indicator will be hidden. URLOperation can be subclassed to add additional connection options like HTTP method, HTTP body, authentication, etc. 
@interface URLOperation : NSOperation

/// URL of data to load.
@property (strong, nonatomic) NSString *url;

/// Loaded data.
@property (strong, nonatomic) NSMutableData *data;

/// Initialize object with URL of data to load, delegate and selector for callback.
/// @param u URL of data to load.
/// @param d delegate to send loaded data
/// @param selector selector to let delegate know when data is loaded. Method given by this selector should have the only one parameter with type URLOperation *, where this instance will be returned.
/// @return initialized object.
- (id)initWithURL:(NSString *)u delegate:(id)d selector:(SEL)selector;
@end