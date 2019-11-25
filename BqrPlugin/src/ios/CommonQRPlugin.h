//
//  QRReaderPlugin.h
//  Ionic Plugin QRCode Reader
//
//  Created by Vigneshwaran Murugesan on 01/01/19.
//  Copyright © 2019 Vigneshwaran Murugesan. All rights reserved.
//

#import <Cordova/CDVPlugin.h>
#import "QRReaderViewController.h"
@interface CommonQRPlugin : CDVPlugin <QRReaderDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
-(void)cameraplugin:(CDVInvokedUrlCommand*)command;
-(void)galleryplugin:(CDVInvokedUrlCommand *)command;
@end
