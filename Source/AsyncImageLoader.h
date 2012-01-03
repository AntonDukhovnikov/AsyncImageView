#import <UIKit/UIKit.h>

/// @brief Protocol used by AsyncImageLoader to callback to UIImageView when it's image is loaded.
@protocol ImageLoaderDelegate 
/// Method is called by AsyncImageLoader to return loaded image to UIImageView.
- (void)loadedImage:(UIImage *)image;
@end

/// @brief This class is used to load images from web asynchronously. All loaded images are stored in cache. When new image is requested to load, queue of requested URLs is checked to avoid multiple loading of the same image.
@interface AsyncImageLoader : NSOperationQueue

/// Method to return shared image loader. Automatically instantiates image loader if needed.
/// @return shared instance of image loader
+ (AsyncImageLoader *)sharedInstance;

/// Method to load image vith given URL. AsyncImageLoader adds requested URL into queue if it is not present in the queue already. Loaded image is returned to delegate and stored in the image cache.
/// @param url URL of image to load
/// @param delegate object to return loaded image to.
- (void)loadImageWithURL:(NSString *)url delegate:(id <ImageLoaderDelegate>) delegate;

/// Method to cancel loading image with given URL. In current implementation this method only removes given delegate from all images in loading queue. If some image has no associated delegates it remains in loading queue and will be loaded. This is done to achieve image preload even if there is no consumer for given image at the moment.
/// @param delegate delegate which does not need image to be loaded anymore.
- (void)cancelLoadingImage:(id)delegate;

/// Method to clear image cache to free memory. Usually [[AsyncImageLoader sharedInstance] clear cache] should be added to [UIApplicationDelegate applicationDidReceiveMemoryWarning:] implementation. All images will be removed from image chache. Images which are currently retained by some UIImageViews will reside in memory until they are released by named UIImageViews.  
- (void)clearCache;
@end

