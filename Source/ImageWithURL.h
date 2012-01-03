#import <UIKit/UIKit.h>
#import "AsyncImageLoader.h"

/// @brief Category for UIImageView to add methods for asyncronous image loading. To load image asynchronously loadImageWithURL: should be performed with the URL of requested image. If the image with given URL is already loaded and found in image cache, then this image will be set into UIImageView immideately. Image is added into loading queue otherwise. If some image is requested to load, cancel method should be performed before requesting other image to load or before setting image property of UIImageView. 
@interface UIImageView (ImageWithURL) <ImageLoaderDelegate>

/// Method to load image asynchornously. Loaded image will be set to UIImageView automatically after being loaded.
/// @param url URL of image to load.
- (void)loadImageWithURL:(NSString*)url;

/// Method to cancel current image loading. This is usually performed before setting image property of UIImageView or before requesting to load another image.
- (void)cancel;
@end