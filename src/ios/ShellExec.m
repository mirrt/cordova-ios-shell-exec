#import "ShellExec.h"
#import <Cordova/CDV.h>
#import "NSTask.h"

@implementation ShellExec

- (void)exec:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* execCommand = [command.arguments objectAtIndex:0];

    if (execCommand != nil && [execCommand length] > 0) {
        NSTask *task = [[NSTask alloc] init];
        [task setLaunchPath:@"/bin/sh"];
        
        NSArray *arguments = [NSArray arrayWithObjects:
                              @"-c" ,
                              [NSString stringWithFormat:@"%@", execCommand],
                              nil];
        NSLog(@"bash:%@", execCommand);
        [task setArguments:arguments];
        
        NSPipe *pipe = [NSPipe pipe];
        [task setStandardOutput:pipe];
        
        NSFileHandle *file = [pipe fileHandleForReading];
        
        [task launch];
        
        NSData *data = [file readDataToEndOfFile];
        
        NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"output %@out", output);
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:output];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end