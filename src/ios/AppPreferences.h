#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface AppPreferences : CDVPlugin

- (void) load:(CDVInvokedUrlCommand *)command;
- (void) get:(CDVInvokedUrlCommand *)command;
- (void) set:(CDVInvokedUrlCommand *)command;

- (NSString *) _get:(NSString *)settingsName;

@end
