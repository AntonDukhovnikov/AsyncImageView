#import "URLOperation.h"
#import "UIKit/UIKit.h"

static int counter;

@interface URLOperation()
{
@private
    BOOL executing;
    BOOL finished;
    SEL method;
    __strong NSURLConnection *connection;
    __strong id delegate;
}
@end

@implementation URLOperation
@synthesize url, data;

- (id)initWithURL:(NSString*)u delegate:(id)d selector:(SEL)selector// callback:(id)c
{
    self = [super init];
	if (self)
	{
		url = u;
		delegate = d;
		method = selector;
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
    if (delegate && method) 
    {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [delegate performSelector:method withObject:self];
        #pragma clang diagnostic pop
    }
    
    [self finish];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self finish];
}
@end