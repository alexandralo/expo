//
//  ABI15_0_0AIRMapSnapshot.h
//  AirMaps
//
//  Created by Hein Rutjes on 26/09/16.
//  Copyright © 2016 Christopher. All rights reserved.
//

#ifndef ABI15_0_0AIRMapSnapshot_h
#define ABI15_0_0AIRMapSnapshot_h

@protocol ABI15_0_0AIRMapSnapshot <NSObject>
@optional
- (void) drawToSnapshot:(MKMapSnapshot *) snapshot context:(CGContextRef) context;
@end

#endif /* ABI15_0_0AIRMapSnapshot_h */
