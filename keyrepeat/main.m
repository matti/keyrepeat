//
//  main.m
//  keyrepeat
//
//  Created by mpa on 26/11/2016.
//  Copyright © 2016 mpa. All rights reserved.
//

#import <Foundation/Foundation.h>

// Copy-pasta from Karabinier-elements
float convert_key_repeat_milliseconds_to_system_preferences_value(uint32_t value) {
    // The unit is 1/60 second.
    return (float) (value) * 60 / 1000;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary<NSString*, id>* dictionary = [userDefaults persistentDomainForName:NSGlobalDomain];
        NSMutableDictionary<NSString*, id>* mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        
        uint32_t initial = (uint32_t) [userDefaults integerForKey:@"initial"];
        uint32_t repeat  = (uint32_t) [userDefaults integerForKey:@"repeat"];
        NSString *serious = [userDefaults stringForKey:@"serious"];
        
        if ( initial == 0 || repeat == 0 ) {
            printf("USAGE: keyrepeat -initial 200 -repeat 30 [-serious yes]\n");
            exit(1);
        }
        if ( ! [serious isEqualToString:@"yes"] && (initial < 100 || repeat < 20) ) {
            printf("-initial: %i and -repeat: %i", initial, repeat);
            printf("\n\nconfirm with -serious yes\n");
            exit(1);
        }
        
        mutableDictionary[@"InitialKeyRepeat"] = @(convert_key_repeat_milliseconds_to_system_preferences_value(initial));
        mutableDictionary[@"KeyRepeat"] = @(convert_key_repeat_milliseconds_to_system_preferences_value(repeat));
        
        [userDefaults setPersistentDomain:mutableDictionary forName:NSGlobalDomain];
    }
    
    return 0;
}
