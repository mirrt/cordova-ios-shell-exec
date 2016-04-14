#import <Cordova/CDV.h>
#import "NSTask.h"

@interface ShellExec : CDVPlugin

- (void)exec:(CDVInvokedUrlCommand*)command;

@end