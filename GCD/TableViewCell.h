//
//  TableViewCell.h
//  GCD
//
//  Created by apple on 07/03/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet MKMapView *map;

@end
