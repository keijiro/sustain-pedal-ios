#import <UIKit/UIKit.h>
#import <CoreMIDI/CoreMIDI.h>

@interface SustainPedalViewController : UIViewController
{
    MIDIClientRef client;
    MIDIPortRef outputPort;
    int touchCount;
}

@end
