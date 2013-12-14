//  Copyright (c) 2013年 KoheiKanagu. All rights reserved.

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController <MKMapViewDelegate, UITabBarDelegate, UITabBarControllerDelegate>
{
    IBOutlet MKMapView *mv;
}

-(IBAction)longTap:(id)sender;
-(IBAction)segment:(id)sender;

-(IBAction)doneButton:(id)sender;
-(IBAction)cancelButton:(id)sender;

@end
