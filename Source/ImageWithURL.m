#import "ImageWithURL.h"
#import "AsyncImageLoader.h"

@implementation UIImageView (ImageWithURL)

- (UIActivityIndicatorView *)indicatorView
{
	UIActivityIndicatorView *indicatorView = (UIActivityIndicatorView *)[self viewWithTag:12345];

    if (!indicatorView) 
	{
		indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        indicatorView.tag = 12345;
		indicatorView.frame = self.bounds;
        indicatorView.contentMode = UIViewContentModeCenter;
        indicatorView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
		[self addSubview:indicatorView];
	}

	return indicatorView;
}

- (void)loadImageWithURL:(NSString *)url
{
	[[self indicatorView] startAnimating];	
	[[AsyncImageLoader sharedInstance] loadImageWithURL:url delegate:self];
}

- (void)loadedImage:(UIImage*)image
{
	[[self indicatorView] stopAnimating];
	[self setImage:image];
}

- (void)cancel
{
	[[AsyncImageLoader sharedInstance] cancelLoadingImage:self];
	[[self indicatorView] stopAnimating];
	[self setImage:nil];
}

@end