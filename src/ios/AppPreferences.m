#import "AppPreferences.h"
#import "Footprint.h"

// Private Interface methods
@interface AppPreferences()

+ (void) initialize;
#if (TARGET_OS_IPHONE)
- (CDVPlugin *) initWithWebView:(UIWebView *)theWebView;
#else
- (CDVPlugin *) initWithWebView:(WebView *)theWebView;
#endif
- (NSString *) getSettingFromBundle:(NSString*)settingName;

@end

@implementation AppPreferences

static NSString *finalPath = nil;

+ (void) initialize
{
    NSString *pathStr;
#if (TARGET_IOS_IPHONE)
    pathStr = [[NSBundle mainBundle] bundlePath];
#else
    pathStr = [[NSBundle mainBundle] resourcePath];
#endif
	NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
	finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
}

#if (TARGET_OS_IPHONE)
- (CDVPlugin *) initWithWebView:(UIWebView *)theWebView
#else
- (CDVPlugin *) initWithWebView:(WebView *)theWebView
#endif
{
    self = (AppPreferences *)[super initWithWebView:theWebView];
    return self;
}

- (void) get:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult = nil;
	NSString *settingsName = [command.arguments objectAtIndex:0];
    
    @try
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[self _get:settingsName]];
    }
    @catch (NSException * e)
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT messageAsString:[e reason]];
    }
    @finally
    {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (NSString *) _get:(NSString *)settingsName
{
    NSString *returnVar;
    if ([settingsName isEqualToString:@"deviceId"]){
        returnVar = [Footprint uniqID];
    } else if ([settingsName isEqualToString:@"reachable"]){
        returnVar = [Footprint portalAvailable] ? @"1" : @"0";
    } else {
        // At the moment we only return strings bool: true = 1, false = 0
        returnVar = [[NSUserDefaults standardUserDefaults] stringForKey:settingsName];
        if (returnVar == nil)
        {
            returnVar = [self getSettingFromBundle:settingsName]; //Parsing Root.plist
            
            if (returnVar == nil){
                @throw [NSException exceptionWithName:nil reason:@"Key not found" userInfo:nil];;
            }
        }
    }
    
    return returnVar;
}

- (void) set:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult = nil;
    
    NSString *settingsName = [command.arguments objectAtIndex:0];
    NSString *settingsValue = [command.arguments objectAtIndex:1];
    
    @try
    {
        [[NSUserDefaults standardUserDefaults] setValue:settingsValue forKey:settingsName];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    @catch (NSException * e)
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT messageAsString:[e reason]];
    }
    @finally
    {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void) load:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult = nil;
    @try
    {
        NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
        NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
        
        NSMutableDictionary *appPrefs = [NSMutableDictionary dictionaryWithCapacity:0];
        NSString *key;
        NSObject *value;
        for (NSDictionary *prefItem in prefSpecifierArray) {
            key = [prefItem objectForKey:@"Key"];
            if (key == nil) continue;
            value = [self _get:key];
            [appPrefs setObject:value forKey:key];
        }
        [appPrefs setObject:[self _get:@"reachable"] forKey:@"reachable"];
        NSString *devId = [self _get:@"deviceId"];
        [appPrefs setObject:devId forKey:@"deviceId"];
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:appPrefs options:0 error:&error];
        NSString *returnVar = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:returnVar];
        
    }
    @catch (NSException * e)
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT messageAsString:[e reason]];
    }
    @finally
    {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

/*
 Parsing the Root.plist for the key, because there is a bug/feature in Settings.bundle
 So if the user haven't entered the Settings for the app, the default values aren't accessible through NSUserDefaults.
 */
- (NSString *)getSettingFromBundle:(NSString *)settingsName
{
	NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
	NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
	NSDictionary *prefItem;
	for (prefItem in prefSpecifierArray)
	{
		if ([[prefItem objectForKey:@"Key"] isEqualToString:settingsName])
			return [prefItem objectForKey:@"DefaultValue"];
	}
	return nil;
}

@end
