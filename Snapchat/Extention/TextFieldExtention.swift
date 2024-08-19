//
//  UIview+TextFiled Extention.swift
//  Emall
//
//  Created by Zafran Mac on 01/12/2023.
//

import Foundation
import UIKit

@IBDesignable
class UITextFieldX: UITextField {
    
    var isPresenting: Bool = false
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightPadding: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        self.clearButtonMode = .whileEditing
        setLeftImage()
        setRightImage()
        
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.clearButtonRect(forBounds: bounds)
        return originalRect.offsetBy(dx: -10, dy: 0)
    }
    
    func setLeftImage() {
        
        leftViewMode = UITextField.ViewMode.always
        var view: UIView
        
        if let image = leftImage {
            let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: 18, height: 18))
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = tintColor
            imageView.contentMode = .scaleAspectFit
            
            var width = imageView.frame.width + leftPadding
            
            if borderStyle == UITextField.BorderStyle.none || borderStyle == UITextField.BorderStyle.line {
                width += 5
            }
            
            view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
            view.addSubview(imageView)
        } else {
            view = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: 20))
        }
        view.addTapGesture {
            self.delegate?.textFieldDidBeginEditing?(self)
            _ = self.delegate?.textFieldShouldBeginEditing?(self)
        }
        leftView = view
    }
    
    func setRightImage() {
        rightViewMode = UITextField.ViewMode.unlessEditing
        
        var view: UIView
        
        if let image = rightImage, isRightViewVisible {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = tintColor
            imageView.contentMode = .scaleAspectFit
            
            var width = imageView.frame.width + rightPadding
            
            if borderStyle == UITextField.BorderStyle.none || borderStyle == UITextField.BorderStyle.line {
                width += 5
            }
            
            view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
            view.addSubview(imageView)
            view.addTapGesture {
                self.delegate?.textFieldDidBeginEditing?(self)
                _ = self.delegate?.textFieldShouldBeginEditing?(self)
            }
        } else {
            view = UIView(frame: CGRect(x: 0, y: 0, width: rightPadding, height: 20))
        }
        
        rightView = view
    }
    
    private var _isRightViewVisible: Bool = true
    
    var isRightViewVisible: Bool {
        get {
            return _isRightViewVisible
        }
        set {
            _isRightViewVisible = newValue
            updateView()
        }
    }
    @IBInspectable open var maxLength: Int = 0{
        didSet{
            NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextField.textDidChangeNotification, object: self)
        }
    }
     
     // Limit the length of text
    
     @objc func textDidChange(notification: Notification) {
         if let sender = notification.object as? UITextFieldX, sender == self {
             let text = text ?? ""
             if maxLength > 0 && text.count > maxLength {
                 let endIndex = text.index(text.startIndex, offsetBy: maxLength)
                 self.text = String(text[..<endIndex])
                 undoManager?.removeAllActions()
                 print("Max character limit is \(maxLength)")
                 }
             setNeedsDisplay()
         }
     }
    
}


extension UITextFieldX {

    func hideErrorInTextfiled(){
        self.borderWidth = 0
    }

}



//MARK: - UIView Code

extension UIView{
    
    enum RoundCornersAt{
        case topRight
        case topLeft
        case bottomRight
        case bottomLeft
    }
    
    //multiple corners using CACornerMask
    func roundCorners(corners:[RoundCornersAt], radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [
            corners.contains(.topRight) ? .layerMaxXMinYCorner:.init(),
            corners.contains(.topLeft) ? .layerMinXMinYCorner:.init(),
            corners.contains(.bottomRight) ? .layerMaxXMaxYCorner:.init(),
            corners.contains(.bottomLeft) ? .layerMinXMaxYCorner:.init(),
        ]
    }
    
}
//extension UICollectionViewCell {
//    func shadowDecorate() {
//        self.layer.cornerRadius = 10
//        self.layer.borderWidth = 0.0
//        self.layer.borderColor = UIColor.lightGray.cgColor
//
//        self.layer.backgroundColor = UIColor.white.cgColor
//        self.layer.shadowColor = UIColor.gray.cgColor
//        self.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
//        self.layer.shadowRadius = 2.0
//        self.layer.shadowOpacity = 0.5
//        self.layer.masksToBounds = false
//    }
//}
extension UIView {
    
    @IBInspectable var shadowColor: UIColor?{
        set {
            guard let uiColor = newValue else { return }
            layer.shadowColor = uiColor.cgColor
        }
        get{
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var shadowOpacity: Float{
        set {
            layer.shadowOpacity = newValue
        }
        get{
            return layer.shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize{
        set {
            layer.shadowOffset = newValue
        }
        get{
            return layer.shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat{
        set {
            layer.shadowRadius = newValue
        }
        get{
            return layer.shadowRadius
        }
    }
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func addShadow() {
        layer.shadowColor = self.shadowColor?.cgColor
        layer.shadowOffset = self.shadowOffset
        layer.shadowOpacity = self.shadowOpacity
        layer.shadowRadius = self.shadowRadius
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        
    }
    
    func roundCorners(_ corners: CACornerMask, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    func roundCorners(with CACornerMask: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [CACornerMask]
    }
    
}


extension UIView {
    
    func  addTapGesture(action : @escaping ()->Void ){
        let tap = MyTapGestureRecognizer(target: self , action: #selector(self.handleTap(_:)))
        tap.action = action
        tap.numberOfTapsRequired = 1
        
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        
    }
    @objc func handleTap(_ sender: MyTapGestureRecognizer) {
        sender.action!()
    }
}

class MyTapGestureRecognizer: UITapGestureRecognizer {
    var action : (()->Void)? = nil
}

extension UIView {
    
    func shake(offset: CGFloat = 10) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.5
        animation.values = [-offset, offset, -offset, offset, -offset/2, offset/2, -offset/4, offset/4, offset/4 ]
        layer.add(animation, forKey: "shake")
    }
}


extension UIStackView {
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach{ self.addArrangedSubview($0) }
    }
}

@IBDesignable
class UIViewX: UIView {
    // MARK: - Gradient
    var _first : UIColor = .clear{
        didSet{
            updateView()
        }
    }
    @IBInspectable var firstColor: UIColor{
        get {
            return _first
        }
        set{
            self._first = newValue
        }
    }
    var _second : UIColor = .clear{
        didSet{
            updateView()
        }
    }
    @IBInspectable var secondColor: UIColor{
        get {
            return _second
        }
        set{
            self._second = newValue
        }
    }
    var _isHorizantal = false{
        didSet{
            updateView()
        }
    }
    @IBInspectable var horizontalGradient: Bool{
        get {
            return _isHorizantal
        }
        set{
            self._isHorizantal = newValue
        }
    }
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [ firstColor.cgColor, secondColor.cgColor ]
        if (horizontalGradient) {
            layer.startPoint = CGPoint(x: 0.0, y: 0.5)
            layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 0, y: 1)
        }
    }
}

extension UIView {
    @discardableResult
    func addLineDashedStroke(pattern: [NSNumber]?, radius: CGFloat, color: CGColor) -> CALayer {
        let borderLayer = CAShapeLayer()
        self.translatesAutoresizingMaskIntoConstraints = false
        borderLayer.strokeColor = color
        borderLayer.lineDashPattern = pattern
        borderLayer.frame = bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        
        layer.addSublayer(borderLayer)
        return borderLayer
    }
}

extension UIButton {
    
    func rotate(degrees: CGFloat) {
        let degreesToRadians: (CGFloat) -> CGFloat = { (degrees: CGFloat) in
            return degrees / 180.0 * CGFloat.pi
        }
        self.transform =  CGAffineTransform(rotationAngle: degreesToRadians(degrees))
    }
}

extension UIButton {
    func addBlurEffect(style: UIBlurEffect.Style? = nil) {
        var style = style
        if style == nil{
            if #available(iOS 13.0, *) {
                style = .systemUltraThinMaterialDark
            }else{
                style = .regular
            }
        }
        
        backgroundColor = .clear
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: style ?? .regular))
        let abc = self.contentEdgeInsets
        blurView.frame = bounds.inset(by: UIEdgeInsets(top: -abc.top, left: -abc.left, bottom: -abc.bottom, right: -abc.right))
        blurView.isUserInteractionEnabled = false
        blurView.backgroundColor = .clear
        if self.layer.cornerRadius > 0 {
            blurView.layer.cornerRadius = self.layer.cornerRadius
            blurView.layer.masksToBounds = true
        }
        self.insertSubview(blurView, at: 0)
        if let imageView = self.imageView{
            imageView.backgroundColor = .clear
            self.bringSubviewToFront(imageView)
        }
    }
}

@IBDesignable
class CustomGradientView: UIView {
    
    @IBInspectable var FirstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var SecondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass : AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView(){
        let layer = self.layer as! CAGradientLayer
        layer.colors = [FirstColor.cgColor, SecondColor.cgColor]
        layer.startPoint = CGPoint(x: 0.3, y: 0)
        layer.endPoint = gradientHorizontal ? CGPoint(x: 1, y: 0) : CGPoint(x: 0.3, y: 1)
        //        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
    }
    
    @IBInspectable open var gradientHorizontal: Bool = false{
        didSet{
            updateView()
        }
    }
}



