# AsyncImageView

Source code contains the category for UIImageView named ImageWithURL. This category has two methods:

- loadImageWithURL:(NSString *url)

which loads image file with given URL asynchronously. UIImageView's current image will be replaced with loaded images automatically on successful download. Spinning indicator is shown on top of current image while loading.

- cancel;

which cancels current image loading in case if other image should be shown on image view, but previous image is still loading.

Class AsyncImageLoader implements background logic for UIImageView(ImageWithURL). It contains loading queue, images cache and other things. If some image is requested for loading and there is other image with same URL is loading or added in queue for loading, no new instances are added into loading queue. It is safe to add lots of images with same URL into queue without any additional checks on client side.

The only method of this class designed to be called from client code is - (void)clearCache. It removes all currently unused images from cache. Can be called as a response to low memory warning.

Test application shows how to use classes.

## License.

BSD-style license. See License.txt
