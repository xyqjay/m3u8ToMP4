//
//  LocalHostAddress.m
//  m3u8ToMp4
//
//  Created by Jay on 16/1/28.
//  Copyright © 2016年 imooc. All rights reserved.
//

#import "LocalHostAddress.h"
#import <ifaddrs.h>
#import <netinet/in.h>
#import <sys/socket.h>
@implementation LocalHostAddress
+ (NSMutableDictionary *)list
{
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    struct ifaddrs*	addrs;
    BOOL success = (getifaddrs(&addrs) == 0);
    
    if (success)
    {
        const struct ifaddrs* cursor = addrs;
        while (cursor != NULL)
        {
            NSMutableString* ip;
            if (cursor->ifa_addr->sa_family == AF_INET)
            {
                const struct sockaddr_in* dlAddr = (const struct sockaddr_in*)cursor->ifa_addr;
                const uint8_t* base = (const uint8_t*)&dlAddr->sin_addr;
                ip = [[NSMutableString alloc] init];
                for (int i = 0; i < 4; i++)
                {
                    if (i != 0)
                        [ip appendFormat:@"."];
                    [ip appendFormat:@"%d", base[i]];
                }
                [result setObject:(NSString*)ip forKey:[NSString stringWithFormat:@"%s", cursor->ifa_name]];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    
    return result;
    //获取外网IP
//    NSURL *netIPURL = [NSURL URLWithString:@"http://whatismyip.org"];//http://whatismyip.org/ipimg.php (image)
//    NSString *netIP = [NSString stringWithContentsOfURL:netIPURL encoding:NSUTF8StringEncoding error:nil];
//    
//    if (netIP)
//    {
//        [result setObject:netIP forKey:@"www"];
//    }
}

@end
