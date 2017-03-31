//
//  ViewController.swift
//  OpenCVBackgroundSubtraction
//
//  Created by Jasmeet Kaur on 24/03/17.
//  Copyright © 2017 Jasmeet Kaur. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    
     @IBOutlet weak var rectButton:UIButton!
    @IBOutlet weak var markBackButton:UIButton!
    @IBOutlet weak var markFrontButton:UIButton!
    
    @IBOutlet weak var navBarButton:UIBarButtonItem!

    
    var overlay:OverlayView = OverlayView()
    var imagePicker = UIImagePickerController()
    var imageView:UIImageView = UIImageView()
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarButton.action = #selector(editButtonClicked(sender:))
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    func getImageWidthHeight()->(CGFloat,CGFloat){
    
        var width =  imageView.frame.size.width
        var height = imageView.frame.size.height
        
        
        if(Float((imageView.image?.size.width)!) > Float((imageView.image?.size.height)!)){
            
            let aspectRatio = (imageView.image?.size.width)!/(imageView.image?.size.height)!
            
            height = width/aspectRatio
            
        }else{
            
            let aspectRatio = (imageView.image?.size.height)!/(imageView.image?.size.width)!
            
            width = height/aspectRatio
            
            
            
        }
        
        
        
        return (width,height)
    
    
    }
    
    
    
  func drawRect(){
    
        
        // createOverlay
        
     //  let (width,height) = getImageWidthHeight()
    
    
    let width = self.imageView.frame.size.width
    let height = self.imageView.frame.size.height
    let x = self.imageView.frame.origin.x + width/4
    
    let y = self.imageView.frame.origin.y + height/4
    
    
    
        overlay = OverlayView.init(frame: CGRect(x:x,y:y ,width:width/2,height:height/2))
        //overlay.frame = overlay.frame.insetBy(dx: OverlayView.kResizeThumbSize/2, dy: OverlayView.kResizeThumbSize/2)
//        overlay.layer.borderColor = OverlayView.BORDER_COLOR.cgColor
//        overlay.layer.borderWidth = 2.0
//    //overlay.bounds = overlay.frame.insetBy(dx: 20.0, dy: 20.0)
//    //overlay.frame = overlay.frame.insetBy(dx: -OverlayView.kResizeThumbSize/2, dy: -OverlayView.kResizeThumbSize/2)
//    
//    
//    
    overlay.addPanGesture(imageView:self.imageView)
    self.view.addSubview(overlay)
        
        
        
        
    }
    
    
        
    
    @IBAction func markBackground(sender:UIButton){
    
    
    }
    
    @IBAction func markForeground(sender:UIButton){
    
    
    }
    
   func editButtonClicked(sender:UIButton){
    
    
    self.imageView.removeFromSuperview()
    self.overlay.removeFromSuperview()
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
        
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
 
    
    
    
    }
    func getPhotoViewSize(image:UIImage,size:CGSize)->CGSize{
        
        
        var width = image.size.width
        var height = image.size.height
        
        
        
        let photoHeight = size.height
        let photoWidth = size.width
        if(width > height){
            
            
            let aspectRatio = width/height
            
            width = photoWidth
            height = photoWidth / aspectRatio
            
            
            
        }else{
            
            let aspectRatio = height/width
            
            height = photoHeight
            width = photoHeight / aspectRatio
            
            
        }
        
        
        
        
        let size = CGSize(width: width,height: height)
        return size
        
        
    }
    
    


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
       
      
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            let size = getPhotoViewSize(image: image, size: CGSize(width:self.view.frame.size.width,height:self.view.frame.size.height - 200))
            
            let x = CGFloat((self.view.frame.size.width - size.width)/2)
            let y = CGFloat((self.view.frame.size.height  - size.height)/2)
            
            imageView = UIImageView(frame: CGRect(x:x,y:y,width:size.width,height:size.height))
            imageView.image = image
            
            
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let size = getPhotoViewSize(image: image, size: CGSize(width:self.view.frame.size.width,height:self.view.frame.size.height - 200))
            
            let x = CGFloat((self.view.frame.size.width - size.width)/2)
            let y = CGFloat((self.view.frame.size.height  - size.height)/2)
            
            imageView = UIImageView(frame: CGRect(x:x,y:y,width:size.width,height:size.height))
            imageView.image = image
        
        } else{
            print("Something went wrong")
        }
        
        
        self.view.addSubview(imageView)
        drawRect()
        self.overlay.createSideViews()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}






