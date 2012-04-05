#import "URLOperation.h"
#import "UIKit/UIKit.h"

static int counter;

@interface URLOperation()
{
@private
    BOOL executing;
    BOOL finished;
    NSURLConnection *connection;
    void (^successBlock)(id result);
    void (^failureBlock)(NSError *error);
}
@end

@implementation URLOperation
@synthesize url, data;

- (id)initWithURL:(NSString*)u successBlock:(void (^)(id result))success failureBlock:(void (^)(NSError *error))failure
{
    self = [super init];
	if (self)
	{
		url = u;
		successBlock = success;
        failureBlock = failure;
		executing = NO;
		finished = NO;
	}
	return self;
}

- (void)dealloc
{
	if (connection) [connection cancel];
}

#pragma mark - Private methods

+ (void)increaseCounter
{
    @synchronized([UIApplication sharedApplication])
    {
        counter++;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
}

+ (void)decreaseCounter
{
    @synchronized([UIApplication sharedApplication])
    {
        counter--;
        if (!counter) [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)finish
{
    [self willChangeValueForKey:@"isFinished"];
	finished = YES;
	[self didChangeValueForKey:@"isFinished"];
	
    [self willChangeValueForKey:@"isExecuting"];
	executing = NO;
	[self didChangeValueForKey:@"isExecuting"];
    
    [URLOperation decreaseCounter];
}

#pragma mark - NSOperation implementation

- (void)start
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    
    [URLOperation increaseCounter];
	
	[self willChangeValueForKey:@"isExecuting"];
	executing = YES;
	[self didChangeValueForKey:@"isExecuting"];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	[request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (BOOL)isConcurrent
{
	return YES;
}

- (BOOL)isExecuting
{
	return executing;
}

- (BOOL)isFinished
{
	return finished;
}

#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)incrementalData 
{
    if (data == nil) data = [[NSMutableData alloc] initWithCapacity:2048];
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection 
{
    successBlock(self);
    [self finish];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    failureBlock(error);
    [self finish];
}
@end