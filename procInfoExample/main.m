//
//  File: main.m
//  Project: procInfoExample
//
//  Created by: Patrick Wardle
//  Copyright:  2017 Objective-See
//  License:    Creative Commons Attribution-NonCommercial 4.0 International License
//

#import "procInfo.h"
#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        //process info obj
        ProcInfo* processInfo = nil;
        
        //dbg msg
        NSLog(@"Process Info Example");
        
        //alloc/init
        processInfo = [[ProcInfo alloc] init];
        
        //individual proc info
        if( (2 == argc) &&
            (0 != strcmp(argv[1], "-all")) )
        {
            //dbg msg
            NSLog(@"getting process info for %d", atoi(argv[1]));
            
            //init process obj
            Process* process = [[Process alloc] init:atoi(argv[1])];
            if(nil == process)
            {
                //bail
                goto bail;
            }

            //dump process info
            NSLog(@"process:\n%@", process);
            
            //bail
            goto bail;
        }
        
        //all running processes
        else if( (2 == argc) &&
                 (0 == strcmp(argv[1], "-all")) )
        {
            //dbg msg
            NSLog(@"enumerating all running process (this takes a bit)...");
            
            //enum all existing procs
            for(Process* process in [processInfo currentProcesses])
            {
                //dump process info
                NSLog(@"new process:\n%@", process);
            }
            
            //bail
            goto bail;
        }
        
        //monitor for process create/exit events
        else
        {
            //dbg msg
            NSLog(@"starting process monitor");
            
            //warn if not root
            if(0 != geteuid())
            {
                //dbg msg
                NSLog(@"since running as non-root, only application events can be monitored");
            }
            
            //define block
            // ->automatically invoked upon process events
            ProcessCallbackBlock block = ^(Process* process)
            {
                //process start event
                // ->fork, spawn, exec, etc.
                if(process.type != EVENT_EXIT)
                {
                    //print
                    NSLog(@"process start:\n%@\n", process);
                }
                //process exit event
                else
                {
                    //print
                    // ->only pid
                    NSLog(@"process exit: %d\n", process.pid);
                }
            };
            
            //start monitoring
            // ->pass in block for events
            [processInfo start:block];
            
            //dbg msg
            NSLog(@"process monitor enabled...");
            
            //run loop
            // ->as don't want to exit
            [[NSRunLoop currentRunLoop] run];

        }
    }
    
bail:
    
    return 0;
}
