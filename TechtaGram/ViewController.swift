//
//  ViewController.swift
//  TechtaGram
//
//  Created by Yamamoto Miu on 2020/09/17.
//  Copyright © 2020 Yamamoto Miu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate
, UINavigationControllerDelegate {

    @IBOutlet var cameraImageView: UIImageView!
    
    //画像加工するための元となる画像
    var originalImage : UIImage!
    
    //画像加工するフィルターの宣言
    var filter : CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //撮影するボタンを押した時のメソッド
    @IBAction func takePhoto() {
        //カメラが使えるかの確認
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            //インスタンスを作る
            let picker = UIImagePickerController()
            //pickerインスタンスのプロパティにアクセス
            picker.sourceType = .camera
            //デリゲート先の指定
            picker.delegate = self
            //編集の可否
            picker.allowsEditing = true
            
            //画面遷移　　第一引数：遷移先のUIViewController 第二引数:アニメーションの有無
            present(picker, animated: true, completion: nil)
        }else{
            //カメラを使えないときはエラーがコンソールに表示
            print("error")
        }
    }
    //撮影した画像を保存するメソッド
    @IBAction func savePhoto() {
        UIImageWriteToSavedPhotosAlbum(cameraImageView.image!, nil, nil, nil)
    }
    //表示している画像フィルターを加工するときのメソッド
    @IBAction func colorFilter() {
        
        let filterImage : CIImage = CIImage(image: originalImage)!
        
        //フィルターの設定
        filter = CIFilter(name: "CIColorControls")!
        filter.setValue(filterImage, forKey: kCIInputImageKey)
        
        //彩度の調整
        filter.setValue(1.0, forKey: "inputSaturation")
        
        //明度の調整
        filter.setValue(0.5, forKey: "inputBrightness")
        
        //コントラストの調整
        filter.setValue(2.5, forKey: "inputContrast")
        
        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        cameraImageView.image = UIImage(cgImage: cgImage!)
        
    }
    //カメラロールにある画像を取り込む時のメソッド
    @IBAction func openAlbum() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            //カメラロールの画像を選択して画像を表示するまでの一連の流れ
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        }
    }
    //SNSに編集した画像を投稿したい時のメソッド
    @IBAction func snsPhoto() {
        //投稿する時に一緒に載せるコメント
        let shareText = "写真加工いえーーーーーーーー"
        
        //投稿する画像の選択
        let shareImage = cameraImageView.image!
        
        //投稿する画像とコメントの準備
        let activityItems: [Any] = [shareText, shareImage]
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        let excludedActivityTypes = [UIActivity.ActivityType.postToWeibo, .saveToCameraRoll, .print]
        
        activityViewController.excludedActivityTypes = excludedActivityTypes
        
        present(activityViewController, animated: true, completion: nil)
        
        
    }
    
    //カメラ、カメラロールを起動した時に選択した画像をアプリ内に表示するためのメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        cameraImageView.image = info[.editedImage] as? UIImage
        
        //撮った写真を加工前の元画像として記憶しておく
        originalImage = cameraImageView.image
        
        //モーダルを閉じる
        dismiss(animated: true, completion: nil)
    }


}

