//
//  ViewController.swift
//  ThreeTimesToTwoTimes
//
//  Created by HJQ on 2018/6/30.
//  Copyright © 2018年 HJQ. All rights reserved.
//

import UIKit

// MARK: - 用@3x转@2x
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let path = "/Users/hjq/Desktop/3x"
        inputFolderPath(folderPath: path )
    }

    func inputFolderPath(folderPath: String){

        let fileManager = FileManager.default
        let enumerator:FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: folderPath)!

        for temp in enumerator {

            let threeImage = (temp as! String)
            if threeImage.hasSuffix("@3x.png") {

                let pathString = folderPath + "/" + threeImage
                threeTimesThePicturesTwoTimes(pathFile: pathString)

            }

        }

    }


    func threeTimesThePicturesTwoTimes(pathFile: String){

        let arrayString = pathFile.components(separatedBy: "/")

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

        let data: NSData = UIImagePNGRepresentation(imageDate!)! as NSData

        data.write(toFile: filePath, atomically: true)

    }

}

extension UIImage{

    func reSizeImage(reSize:CGSize)->UIImage {

        UIGraphicsBeginImageContextWithOptions(reSize,false,1)

        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))

        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!

        UIGraphicsEndImageContext()

        return reSizeImage

    }

}

