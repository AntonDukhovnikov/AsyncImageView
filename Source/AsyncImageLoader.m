#import "AsyncImageLoader.h"
#import "URLOperation.h"

static AsyncImageLoader *sharedImageLoader = nil;

@interface AsyncImageLoader ()
{
@private
    __strong NSMutableDictionary *cache;
    __strong NSMutableDictionary *delegates;
}
@end

@implementation AsyncImageLoader

- (AsyncImageLoader *)init
{
    self = [super init];
	if (self)
	{
		cache = [NSMutableDictionary new];
		delegates = [NSMutableDictionary new];
		[self setMaxConcurrentOperationCount:5];
	}
	return self;
}

+ (AsyncImageLoader *)sharedInstance
{
	if (sharedImageLoader == nil) sharedImageLoader = [[AsyncImageLoader alloc] init];
	return sharedImageLoader;
}

- (void)finishedOperation:(URLOperation *)item
{
	@synchronized(self)
	{
		UIImage *image = [UIImage imageWithData:item.data];

		NSMutableArray* array = [delegates objectForKey:item.url];
		for (id<ImageLoaderDelegate> d in array) [d loadedImage:image];

		[delegates removeObjectForKey:item.url];
		[cache setObject:image forKey:item.url];
	}
}

- (void)loadImageWithURL:(NSString*)url delegate:(id<ImageLoaderDelegate>) delegate
{
	@synchronized(self)
	{
		if ([[cache allKeys] containsObject:url])
		{
			[delegate loadedImage:[cache objectForKey:url]];
			return;
		}

        NSMutableArray* array = [delegates objectForKey:url];

        if (array)
        {
            [array addObject:delegate];
            return;
        }
        
		array = [NSMutableArray arrayWithCapacity:10];
		[delegates setObject:array forKey:url];
		[array addObject:delegate];

		URLOperation* item = [[URLOperation alloc] initWithURL:url delegate:self selector:@selector(finishedOperation:)];
		
		[self  addOperation:item];
	}	
}

- (void)cancelLoadingImage:(id)delegate
{
	@synchronized(self)
	{
		for(NSMutableArray* array in [delegates allValues])
			if ([array containsObject:delegate]) 
                [array removeObject:delegate];
	}	
}

- (void)clearCache
{
	@synchronized(self)
	{
		[cache removeAllObjects];
	}
}
@end

