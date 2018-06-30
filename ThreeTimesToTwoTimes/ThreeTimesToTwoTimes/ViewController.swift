//
//  ViewController.swift
//  ThreeTimesToTwoTimes
//
//  Created by HJQ on 2018/6/30.
//  Copyright © 2018年 HJQ. All rights reserved.
//

import UIKit

// MARK: - 用@3x转@2x
// 桌面文件夹路径
private let kPath = "/Users/hjq/Desktop/3x"

class ViewController: UIViewController {

    @IBOutlet weak var labelMessage: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func inputFolderPath(folderPath: String){

        let fileManager = FileManager.default
        let enumerator:FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: folderPath)!

        for temp in enumerator {

            let threeImage = (temp as! String)
            let pathString = folderPath + "/" + threeImage
            if threeImage.hasSuffix("@3x.png") {
                threeTimesThePicturesTwoTimes(pathFile: pathString)

            } else if threeImage.hasSuffix("@2x.png") { // 不做处理

            } else { // 如果不包含@3x.png
                threeTimesToTwoTimes(pathFile: pathString)
            }
        }

    }

    // 没有后缀 生成@3x、@2x
    func threeTimesToTwoTimes(pathFile: String){

        let arrayString = pathFile.components(separatedBy: "/")
        // 取到最后一个（文件名称）
        let temp = arrayString[arrayString.count - 1]
        let nsstr = temp as NSString
        let pathS = pathFile as NSString

        // 需要处理
        let twoTimes = nsstr.replacingOccurrences(of: ".", with: "@2x.")
        let threeTimes = nsstr.replacingOccurrences(of: ".", with: "@3x.")

        let imageNameTwo = pathS.replacingOccurrences(of: temp, with: twoTimes)
        let imageNameThress = pathS.replacingOccurrences(of: temp, with: threeTimes)

        // 拿到真实的图片
        let nsd = NSData.init(contentsOfFile: pathFile)
        guard let img = UIImage(data: nsd! as Data) else {
            return
        }

        // 图片的宽高
        let imageSize = img.size
        var twoTimesResult = false
        var threeTimesResult = false

        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: imageNameTwo) {
            // 生成2倍图
            let width = imageSize.width / 3 * 2
            let height = imageSize.height / 3 * 2
            let sizeChange = CGSize(width: width,height: height)
            let imageDate = img.reSizeImage(reSize: sizeChange)
            let filePath: String = imageNameTwo as String
            let data: NSData = UIImagePNGRepresentation(imageDate)! as NSData
            twoTimesResult = data.write(toFile: filePath, atomically: true)

        }

        // 直接输出三倍图
        if !fileManager.fileExists(atPath: imageNameThress) {
            let threefilePath: String = imageNameThress as String
            let threeData: NSData = UIImagePNGRepresentation(img)! as NSData
            threeTimesResult = threeData.write(toFile: threefilePath, atomically: true)
        }
        // 移除没带倍图后缀的图片
        if fileManager.fileExists(atPath: pathFile) {
            do {
                try fileManager.removeItem(atPath: pathFile)
            }
            catch {

            }
        }

        if twoTimesResult && threeTimesResult {
            labelMessage.text = "生成成功"
        }

    }

    // 有后缀@3x生成@2x
    func threeTimesThePicturesTwoTimes(pathFile: String){

        let arrayString = pathFile.components(separatedBy: "/")
        // 取到最后一个（文件名称）
        let temp = arrayString[arrayString.count - 1]
        let nsstr = temp as NSString
        let pathS = pathFile as NSString
        let han =  nsstr.replacingOccurrences(of: "@3x", with: "@2x")
        let imageName = pathS.replacingOccurrences(of: temp, with: han)

        let nsd = NSData.init(contentsOfFile: pathFile)
        let img = UIImage(data: nsd! as Data)
        let width = (img?.size.width)! / 3 * 2
        let height = (img?.size.height)! / 3 * 2
        let sizeChange = CGSize(width: width,height: height)
        let imageDate = img?.reSizeImage(reSize: sizeChange)
        let filePath: String = imageName as String
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: imageName) {
            labelMessage.text = "图片已存在"
            return
        }

        let data: NSData = UIImagePNGRepresentation(imageDate!)! as NSData
        let result = data.write(toFile: filePath, atomically: true)
        if result {
            labelMessage.text = "生成成功"
        }

    }

    // MARK: - Event response
    @IBAction func buttonGenerateAction(_ sender: Any) {
        inputFolderPath(folderPath: kPath )
    }

}

// MARK: - UIImage 拓展
extension UIImage {

    func reSizeImage(reSize:CGSize)->UIImage {

        UIGraphicsBeginImageContextWithOptions(reSize,false,1)
        draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return reSizeImage

    }

}

