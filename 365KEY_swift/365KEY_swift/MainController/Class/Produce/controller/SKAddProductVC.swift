//
//  SKAddProductVC.swift
//  365KEY_swift
//
//  Created by 牟松 on 2016/12/23.
//  Copyright © 2016年 DoNews. All rights reserved.
//

import UIKit

class SKAddProductVC: UIViewController {
    
    var navBar: UINavigationBar?
    var navItem: UINavigationItem?
    
    var addressTF: UITextField?
    var nameTF: UITextField?
    var productInfoTV: prodectInfoTextView?
    
    var uploadImageLogo: UIImageView?
    var uplodeImageBtn: UIButton?
    
    var uploadBtn: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupSubView()
    }

}
extension SKAddProductVC{
    @objc private func backBtnDidclick() {
        _ = navigationController?.popViewController(animated: true)
    }
    @objc private func uploadImageLogoDidClick() {
        let imagePickVC = UIImagePickerController()
        imagePickVC.sourceType = .photoLibrary
        imagePickVC.delegate = self
        navigationController?.present(imagePickVC, animated: true, completion: nil)
        
        
    }
    @objc private func uploadBtnDidClick() {
        if !checkAddress(string: (addressTF?.text)!) {
            return
        }
        if !checkName(string: (nameTF?.text)!) {
            return
        }
        
    }
    func setupSubView() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.screenWidth, height: 64))
        navBar?.isTranslucent = false
        navBar?.barTintColor = UIColor().mainColor
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        view.addSubview(navBar!)
        
        navItem = UINavigationItem()
        navItem?.title = "新增产品"
        navItem?.leftBarButtonItem = UIBarButtonItem(SK_barButtonItem: UIImage(named:"icon_back"), selectorImage: UIImage(named:"icon_back"), tragtic: self, action: #selector(backBtnDidclick))
        
        navBar?.items = [navItem!]
        
        addressTF = UITextField(frame: CGRect(x: 40, y: 64+30, width: UIScreen.main.screenWidth-80, height: 40))
        addressTF?.layer.borderWidth = 1
        addressTF?.layer.borderColor = UIColor(white: 207/255.0, alpha: 1).cgColor
        addressTF?.layer.cornerRadius = 6
        addressTF?.layer.masksToBounds  = true
        addressTF?.placeholder = "产品链接"
        addressTF?.delegate = self
        addressTF?.textAlignment = .center
        view.addSubview(addressTF!)
        
        nameTF = UITextField(frame: CGRect(x: 40, y: 64+30+40+10, width: UIScreen.main.screenWidth-80, height: 40))
        nameTF?.layer.borderWidth = 1
        nameTF?.layer.borderColor = UIColor(white: 207/255.0, alpha: 1).cgColor
        nameTF?.layer.cornerRadius = 6
        nameTF?.layer.masksToBounds  = true
        nameTF?.placeholder = "产品名称"
        nameTF?.textAlignment = .center
        nameTF?.delegate = self
        view.addSubview(nameTF!)
        
        productInfoTV = prodectInfoTextView(frame: CGRect(x: 40, y: 64+30+40+10+40+10, width: UIScreen.main.screenWidth-80, height: 130))
        productInfoTV?.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(productInfoTV!)
        
        uploadImageLogo = UIImageView(frame: CGRect(x: (UIScreen.main.screenWidth-100)/2, y: 64+30+40+10+40+10+130+20, width: 100, height: 100))
        uploadImageLogo?.image = UIImage(named: "bg_protupian")
        uploadImageLogo?.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(uploadImageLogoDidClick))
        tap.numberOfTapsRequired = 1
        uploadImageLogo?.addGestureRecognizer(tap)
        view.addSubview(uploadImageLogo!)
        
        uplodeImageBtn = UIButton(frame: CGRect(x: (UIScreen.main.screenWidth-108)/2, y: 64+30+40+10+40+10+100+20+130+10, width: 108, height: 32))
        uplodeImageBtn?.backgroundColor = UIColor(white: 130/255.0, alpha: 1)
        uplodeImageBtn?.setTitle("产品图片上传", for: .normal)
        uplodeImageBtn?.addTarget(self, action: #selector(uploadImageLogoDidClick), for: .touchUpInside)
        uplodeImageBtn?.layer.cornerRadius = 16
        uplodeImageBtn?.layer.masksToBounds = true
        uplodeImageBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(uplodeImageBtn!)
        
        uploadBtn = UIButton(frame: CGRect(x: 0, y: UIScreen.main.screenHeight-50, width: UIScreen.main.screenWidth, height: 50))
        uploadBtn?.backgroundColor = UIColor(white: 245/255.0, alpha: 1)
        uploadBtn?.setTitle("提交", for: .normal)
        uploadBtn?.setTitleColor(UIColor().mainColor, for: .normal)
        uploadBtn?.addTarget(self, action: #selector(uploadBtnDidClick), for: .touchUpInside)
        view.addSubview(uploadBtn!)
   
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func checkAddress(string: String) -> Bool {
        if string.isEmpty || string.characters.count == 0 {
            SKProgressHUD.setErrorString(with: "产品地址不能为空")
            return false
        }
        return true
    }
    func checkName(string: String) -> Bool {
        if string.isEmpty || string.characters.count == 0 {
            SKProgressHUD.setErrorString(with: "产品名称不能为空")
            return false
        }
        return true
    }
}

extension SKAddProductVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension SKAddProductVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
    }
}

class prodectInfoTextView: UITextView {
    private var placeHolder: String
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        
        placeHolder = "产品简介（少于30字）"
        super.init(frame: frame, textContainer: textContainer)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor(white: 207/255.0, alpha: 1).cgColor
        layer.cornerRadius = 6
        layer.masksToBounds = true
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: .UITextViewTextDidChange, object: nil)
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.screenWidth, height: 35))
        toolBar.barStyle = .default
        let barBtn = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(barBtnDidClick))
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceBtn.width = UIScreen.main.screenWidth-60
        let barBtnArray = [spaceBtn, barBtn]
        toolBar.setItems(barBtnArray, animated: true)
        
        
        inputAccessoryView = toolBar
        
        
        
    }
    @objc private func barBtnDidClick(){
        resignFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
    }
    
    @objc private func textDidChange(){
        if text.lengthOfBytes(using: .utf8) >= 30 {
            let strIndex = text.index(text.startIndex, offsetBy: 30)
            text = text.substring(to: strIndex)
        }
        setNeedsDisplay()
    }
    
    override var text: String!{
        didSet{
            setNeedsDisplay()
        }
    }
    override var font: UIFont?{
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        if hasText {return}
        var attributesDic = [String: Any]()
        attributesDic[NSForegroundColorAttributeName] = UIColor(white: 207/255.0, alpha: 1) as Any
        attributesDic[NSFontAttributeName] = UIFont.systemFont(ofSize: 17) as Any
        
        self.placeHolder.draw(in: CGRect(x:(width-176)/2, y:10, width: 200, height: 20), withAttributes: attributesDic)
    }
    
    
}
