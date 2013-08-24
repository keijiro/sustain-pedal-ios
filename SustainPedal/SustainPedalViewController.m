#import "SustainPedalViewController.h"

@interface SustainPedalViewController ()

- (void)sendSustainPedalMessage:(int)param;

@end

@implementation SustainPedalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.grayColor;

    MIDIClientCreate(CFSTR("SustainPedal Client"), nil, nil, &client);
    MIDIOutputPortCreate(client, CFSTR("SustainPedal Output Port"), &outputPort);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self->touchCount == 0) {
        [self sendSustainPedalMessage:0x7f];
        self.view.backgroundColor = UIColor.whiteColor;
    }
    
    self->touchCount += touches.count;
    
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self->touchCount -= touches.count;

    if (self->touchCount == 0) {
        [self sendSustainPedalMessage:0];
        self.view.backgroundColor = UIColor.grayColor;
    }
    
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self->touchCount -= touches.count;
    
    if (self->touchCount == 0) {
        [self sendSustainPedalMessage:0];
        self.view.backgroundColor = UIColor.grayColor;
    }

    [super touchesCancelled:touches withEvent:event];
}

- (void)sendSustainPedalMessage:(int)param
{
    const Byte message[] = {0xb0, 0x40, param};
    
    MIDIPacketList packetList;
    MIDIPacket *packet = MIDIPacketListInit(&packetList);
    MIDIPacketListAdd(&packetList, sizeof(packetList), packet, 0, sizeof(message), message);
    
    ItemCount destinationCount = MIDIGetNumberOfDestinations();
    for (int i = 0; i < destinationCount; i++) {
        MIDISend(outputPort, MIDIGetDestination(i), &packetList);
    }
}

@end
