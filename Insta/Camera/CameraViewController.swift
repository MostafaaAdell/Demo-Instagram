//
//  CameraViewController.swift
//  Insta
//
//  Created by Mostafa Adel on 6/28/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController ,AVCapturePhotoCaptureDelegate ,UIViewControllerTransitioningDelegate{
    
    let returnButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrowshape.turn.up.right.fill" ,withConfiguration:  UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .medium) )?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handelReturnButton), for: .touchUpInside)
        return button
    }()
    @objc func handelReturnButton(){
        dismiss(animated: true, completion: nil)
    }
    
    let capturePhoto : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "largecircle.fill.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 60, weight: .regular, scale: .large))?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handelCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        setViewButtons()
        setUpCapturing()
        transitioningDelegate = self
        
        // Do any additional setup after loading the view.
    }
    override var prefersStatusBarHidden: Bool{
        true
    }
    let customPresent = CustomAnimationPresenting()
    let customDismiss = CustomAnimationDismiss()
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customPresent
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customDismiss
    }
    
    fileprivate func setViewButtons(){
        view.addSubview(returnButton)
        returnButton.Anchor(top: view.topAnchor, bottom: nil, left: nil, right: view.rightAnchor, paddingTop: 40, paddingBottom: 0, paddingLeft: 0, paddingRight: -24, width: 50, height: 50)
        
        view.addSubview(capturePhoto)
        capturePhoto.Anchor(top: nil, bottom: view.bottomAnchor, left: nil, right: nil, paddingTop: 0, paddingBottom: -60, paddingLeft: 0, paddingRight: 0, width: 80, height: 80)
        capturePhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    let output = AVCapturePhotoOutput()
    @objc func handelCapturePhoto(){
        let setting = AVCapturePhotoSettings()
        guard let previewFormatType = setting.availablePreviewPhotoPixelFormatTypes.first else{return}
        setting.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String : previewFormatType]
        
        output.capturePhoto(with: setting, delegate: self)
        
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()
        let previewImage = UIImage(data: imageData!)
        
        let prev = PreviewImageController()
        prev.imageView.image = previewImage
        view.addSubview(prev)
        prev.Anchor(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        //        let previewImageView = UIImageView(image: previewImage)
        //        view.addSubview(previewImageView)
        //        previewImageView.Anchor(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    
    fileprivate func setUpCapturing(){
        let captureSession = AVCaptureSession()
        if  let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) {
            do{
                let input = try  AVCaptureDeviceInput(device: captureDevice)
                if captureSession.canAddInput(input){
                    captureSession.addInput(input)
                }
            }catch let err {
                print("There is an error in input : \(err.localizedDescription)")
            }
            
            
            if captureSession.canAddOutput(output){
                captureSession.addOutput(output)
            }
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = view.frame
            view.layer.addSublayer(previewLayer)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
