
#define PORTAL_HOST @"www.projectscapa.com"
#define PORTAL_URL @"http://" PORTAL_HOST

#define LAUNCH_URL_KEY @"launchUrl"

@interface Footprint : NSObject

+ (BOOL) portalAvailable;
+ (NSString *) uniqID;

@end
