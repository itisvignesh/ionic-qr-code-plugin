//
//  ViewController.h
//  Ionic Plugin QRCode Reader
//
//  Created by Vigneshwaran Murugesan on 01/01/19.
//  Copyright © 2019 Vigneshwaran Murugesan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol QRReaderDelegate <NSObject>
@required
-(void)didReadData:(NSString *) qrData;
-(void)didfailToRead:(NSString *) qrData;
@end
@class PartialTransparentView;
@interface QRReaderViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property AVCaptureDevice *avCaptureDevice;
@property AVCaptureDeviceInput *captureDeviceInput;
@property AVCaptureSession *avCaptureSesion;
@property AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property NSString *commandCallbackID;
@property (weak, nonatomic) IBOutlet UIView *previewView;

@property(nonatomic,assign) id<QRReaderDelegate> delegate;
-(void)startCapturingImageFrames;

@end


