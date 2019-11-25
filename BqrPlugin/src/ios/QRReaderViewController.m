//
//  ViewController.m
//  Ionic Plugin QRCode Reader
//
//  Created by Vigneshwaran Murugesan on 01/01/19.
//  Copyright © 2019 Vigneshwaran Murugesan. All rights reserved.
//

#import "QRReaderViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface QRReaderViewController ()
@end

@implementation QRReaderViewController


-(void)viewWillAppear:(BOOL)animated{
    [self startCapturingImageFrames];
}
-(void)startCapturingImageFrames{
    self.avCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *avCaptureError;
    self.captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.avCaptureDevice error:&avCaptureError];
    if(!self.captureDeviceInput||avCaptureError){
        NSLog(@"Cannot initialize capturing device %@",avCaptureError.localizedDescription);
    }
    self.avCaptureSesion = [[AVCaptureSession alloc] init];
    [self.avCaptureSesion addInput:self.captureDeviceInput];
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.avCaptureSesion addOutput:captureMetadataOutput];
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.avCaptureSesion];
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.videoPreviewLayer setFrame:self.previewView.layer.bounds];
    [self.previewView.layer addSublayer:self.videoPreviewLayer];
    [self.avCaptureSesion startRunning];


}
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if(metadataObjects&&metadataObjects.count>0){
        AVMetadataMachineReadableCodeObject *readMetadata =metadataObjects[0];
        if([readMetadata.type isEqualToString:AVMetadataObjectTypeQRCode]){
            [self.delegate didReadData:readMetadata.stringValue];
            [self stopCapturingQRFrames];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            });
        }
    }else{

        [self stopCapturingQRFrames];
    }

}

-(void)stopCapturingQRFrames{
    [self.avCaptureSesion stopRunning];
    self.avCaptureSesion = nil;
}
-(IBAction)didCancelTapped:(id)sender{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end


