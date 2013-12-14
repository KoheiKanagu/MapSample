//  Copyright (c) 2013年 KoheiKanagu. All rights reserved.

#import "MapViewController.h"

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [mv setMapType:MKMapTypeStandard];
    [mv setDelegate:self];
    [mv setShowsUserLocation:YES];
    
    [self becomeFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated
{
    [mv setUserTrackingMode:MKUserTrackingModeFollow
                   animated:YES];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"shake Begin");
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [mv setUserTrackingMode:MKUserTrackingModeNone
                   animated:YES];
    
    CLLocationCoordinate2D coordinate = mv.userLocation.coordinate;
    MKCoordinateRegion cr = mv.region;
    cr.center = coordinate;
    
    cr.span.latitudeDelta = 0.1;
    cr.span.longitudeDelta = 0.1;
    
    [mv setRegion:cr
         animated:YES];

    NSLog(@"shake End");
}



-(IBAction)longTap:(id)sender
{
    UILongPressGestureRecognizer *lpgr = (UILongPressGestureRecognizer *)sender;
    
    if([lpgr state] == UIGestureRecognizerStateBegan){
        
        CGPoint touchedPoint = [lpgr locationInView:mv];
        CLLocationCoordinate2D touchCoordinate = [mv convertPoint:touchedPoint toCoordinateFromView:mv];
        
        [mv removeAnnotations:[mv annotations]];
        
        MKPointAnnotation *pa = [[MKPointAnnotation alloc]init];
        [pa setCoordinate:touchCoordinate];
        [mv addAnnotation:pa];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if(annotation == [mapView userLocation]){
        return nil;
    }
    
    static NSString* Identifier = @"PinAnnotationIdentifier";
    
    MKPinAnnotationView *pav = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:Identifier];
    
    if(pav == nil){
        pav = [[MKPinAnnotationView alloc]initWithAnnotation:annotation
                                             reuseIdentifier:Identifier];
        [pav setAnimatesDrop:YES];
        return pav;
    }
    pav.annotation = annotation;
    return pav;
}



-(IBAction)segment:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    
    switch(seg.selectedSegmentIndex){
        case 0:
            [mv setMapType:MKMapTypeStandard];
            break;
            
        case 1:
            [mv setMapType:MKMapTypeHybrid];
            break;
            
        case 2:
            [mv setMapType:MKMapTypeSatellite];
            break;
    }
}


-(IBAction)doneButton:(id)sender
{
    NSArray *array = [mv annotations];
    
    for(MKPointAnnotation *pa in array){

        if((MKUserLocation *)pa == mv.userLocation){
            continue;
        }
        CLLocationCoordinate2D coordinate = pa.coordinate;
        
        NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
        
        NSLog(@"%@ , %@", latitude, longitude);
        
        [self cancelButton:nil];
        return;
    }
}

-(IBAction)cancelButton:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    NSLog(@"cancel");
}




@end
