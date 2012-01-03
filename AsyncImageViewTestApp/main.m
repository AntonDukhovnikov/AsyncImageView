/* 
 Sample application to show how asynchronous image loading for UIImageViews can be implemented.
 
 There are several steps to make this code work: 
 
 1. Add import statement for "ImageWithURL.h" to have access to new UIImageView category methods.
 2. Instantiate UIImageView object via Interface Builder of in code. This view can be customized in usual way.
 3. To load image asynchronously perform loadImageWithURL: method of UIImageView with the URL specified. Spinning activity indicator will be visible in the center of the image view until image is loaded. When image is loaded, activity indicator is removed and image is shown.
 4. To cancel image loading perform cancel method of UIImageView.
 5. To clear image cache and to free used memory perform [[AsyncImageLoader sharedInstance] clearCache].
 
 Notes on test application:
 
 - This application shows UITableView with 80 cells. Each cell contains image loaded asynchronously. 4 images are used for these 80 cells, they are assigned ro cells in this manner: Image1, Image2, Image3, Image4, Image1, Image2,... This is done to make several instance of the same image visible on the screen in the same time. It is clearly visible that there is only one instance is loaded, so all images linked with same URL are appears on screen simultaneously.
 - 4 free images from the internet are used. Please change the URLs to what you need to load.
 
 */

#import <UIKit/UIKit.h>

// Add import statement for "ImageWithURL.h" to have access to new UIImageView category methods.
#import "ImageWithURL.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITableViewDataSource>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITableViewController *viewController;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain]; 
    ((UITableView *)self.viewController.view).dataSource = self;
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    /// To clear image cache and to free used memory perform [[AsyncImageLoader sharedInstance] clearCache].
    [[AsyncImageLoader sharedInstance] clearCache];
}

#pragma mark - Table view data source

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%i", indexPath.row];
    
    NSString *imageURL;

    // Use your own URLs to load instead.
    switch (indexPath.row % 4) 
    {
        case 0: imageURL = @"http://icons.iconarchive.com/icons/visualpharm/hardware/48/mouse-icon.png"; break;
        case 1: imageURL = @"http://icons.iconarchive.com/icons/visualpharm/hardware/48/flash-disk-icon.png"; break;
        case 2: imageURL = @"http://icons.iconarchive.com/icons/visualpharm/hardware/48/monitor-icon.png"; break;
        case 3: imageURL = @"http://icons.iconarchive.com/icons/visualpharm/hardware/48/print-icon.png"; break;
    }
    
    // Local image is shown on UIImageView prior to loading image from web. This is done because image on the default UITableViewCell has zero dimensions before it get image property set. I use placeholder here to arrange the space for future image on the cell and to show activity indicator where it should be located. If UIImageView has non-zero frame, this step is not really needed.
    [cell.imageView setImage:[UIImage imageNamed:@"Placeholder.png"]];
    
    // Load image asynchronously and show the image when loaded.
    [cell.imageView loadImageWithURL:imageURL];
    
    return cell;
}

@end

int main(int argc, char *argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
