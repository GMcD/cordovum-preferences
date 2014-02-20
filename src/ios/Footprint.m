#import "Footprint.h"
#import "CDVReachability.h"

@implementation Footprint

+ (void) initialize
{

}

//
// Simple Reachability Test
//
+ (BOOL) portalAvailable
{    
    CDVReachability *reachable = [CDVReachability reachabilityWithHostName:PORTAL_HOST];
    NetworkStatus networkStatus = [reachable currentReachabilityStatus];
    return (networkStatus != NotReachable);
}

//
// Unique Identifier for lifetime of app install
//
+ (NSString *) uniqID
{
    NSString* uniqueIdentifier = nil;
    if( [UIDevice instancesRespondToSelector:@selector(identifierForVendor)] ) {
        // iOS 6+
        uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else {
        // before iOS 6, so just generate an identifier and store it
        uniqueIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:@"identiferForVendor"];
        if( !uniqueIdentifier ) {
            CFUUIDRef uuid = CFUUIDCreate(NULL);
            uniqueIdentifier = (__bridge_transfer NSString*)CFUUIDCreateString(NULL, uuid);
            CFRelease(uuid);
            [[NSUserDefaults standardUserDefaults] setObject:uniqueIdentifier forKey:@"identifierForVendor"];
        }
    }
    return uniqueIdentifier;
}

@end

