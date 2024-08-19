//
//  LoginViewController.swift
//  Snapchat
//
//  Created by Zafran Mac on 01/12/2023.
//
import SwiftUI
import UIKit
import Lottie

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    let animationHeight: CGFloat = 60
    let animationWidth: CGFloat = 280
    
    @IBOutlet weak var togglecheckButton: UIButton!
    @IBOutlet weak var togglePasswordButton: UIButton!
    var animationView : LottieAnimationView?
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
//        loginButton.backgroundColor = UIColor.lightGray
//        self.loginButton.setTitleColor(UIColor.white, for: .normal)
//
        passwordTextField.isSecureTextEntry = true
        // Set up text field appearance
        configureTextFieldAppearance()
        
        // Set up login button
        configureLoginButton()
        
        // Add observers for text changes in text fields
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func configureTextFieldAppearance() {
        // Hide the borders of text fields
        emailTextField.borderStyle = .none
        passwordTextField.borderStyle = .none
        addBottomBorder(to: emailTextField)
        addBottomBorder(to: passwordTextField)
    }
    
    func initialSetup() {
        self.loginButton.setTitleColor(UIColor.white, for: .disabled)
        animationView = .init(name: "whitelottie")
        animationView!.frame = CGRect(
            x: (view.bounds.width - animationWidth) / 2,
            y: view.bounds.height,
            width: animationWidth,
            height: animationHeight
        )
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        
        animationView!.animationSpeed = 0.1
        animationView!.layer.cornerRadius = 30
        animationView!.clipsToBounds = true
        animationView?.isHidden = true
        animationView!.backgroundColor = UIColor(named: "Load")
        view.addSubview(animationView!)
    }
    
    
    func addBottomBorder(to textField: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textField.frame.height - 1, width: textField.frame.width, height: 0.5)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        textField.layer.addSublayer(bottomLine)
    }
    
    func configureLoginButton() {
        loginButton.layer.cornerRadius = 30
        loginButton.isUserInteractionEnabled = false
        loginButton.alpha = 0.5
        loginButton.backgroundColor = UIColor.lightGray
//        loginButton.setTitleColor(UIColor.white, for: .normal)
//        loginButton.setTitleColor(UIColor.white, for: .disabled)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc func textFieldDidChange() {
        let emailText = emailTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        let isAnyFieldEmpty = emailText.isEmpty || passwordText.isEmpty
        
        loginButton.isUserInteractionEnabled = !isAnyFieldEmpty
        loginButton.backgroundColor = loginButton.isUserInteractionEnabled ? UIColor(named: "Color") : UIColor.lightGray
        UIView.animate(withDuration: 0.3) {
            self.loginButton.alpha = isAnyFieldEmpty ? 0.5 : 1.0
            self.loginButton.setTitleColor(UIColor.white, for: .normal)
            self.loginButton.setTitleColor(UIColor.white, for: .disabled)
        }
    }
    
    
    
    @objc func loginButtonTapped() {
        // Implement login functionality
    }
    
    
    @IBAction func eyeButtonTapped(_ sender: Any) {
        //print("Button tapped")
        
        if togglePasswordButton.isSelected {
            togglePasswordButton.isSelected = false
            //print("Selected state is true")
            passwordTextField.isSecureTextEntry = true
        } else {
            togglePasswordButton.isSelected = true
            //print("Selected state is false")
            passwordTextField.isSecureTextEntry = false
        }
    }
    @IBAction func checkButtonTapped(_ sender: Any) {
        //print("Button tapped")
        
        if togglecheckButton.isSelected {
            togglecheckButton.isSelected = false
        } else {
            togglecheckButton.isSelected = true
        }
    }
    
    @IBAction func LoginButtonTapped(_ sender: Any) {
        // Disable the login button to prevent multiple taps
        loginButton.isEnabled = false
        
        animationView?.isHidden = false
        animateDownWithLottie()
        
        // Simulate loading for 3 seconds
        
    }
    func animateDownWithLottie() {
        self.animationView?.isHidden = false
        self.loginButton.isHidden = true
        self.animationView?.loopMode = .loop
        self.animationView?.play()
        
        // Initial position: Move the view to the middle of the screen
        self.animationView?.frame.origin.y = self.view.bounds.midY - (self.animationHeight / 2)
        
        // Final position: Move the view to the bottom of the screen
        let finalYPosition = self.view.bounds.height - self.animationHeight - 20
        
        // Animate from the middle to the final position
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.animationView?.frame.origin.y = finalYPosition
        }) { (_) in
            // Start a timer to stop the animation after 3 seconds
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
                self.stopAnimationAndNavigate()
            }
        }
    }
    
    
    func stopAnimationAndNavigate() {
        
        
        self.loginButton.isHidden = true
        
        // Enable interaction after stopping the animation
        self.animationView?.isUserInteractionEnabled = true
        
        // Move the view to the final position
        UIView.animate(withDuration: 0.5) {
            self.animationView?.frame.origin.y = self.view.bounds.height - self.animationHeight - 20
        }
        
        // Start a timer to navigate after 3 seconds
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
            //self.animationView?.isHidden = true
            self.animationView?.stop()
            self.navigateToDashboard()
        }
    }
    
    func navigateToDashboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dashboardViewController = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        dashboardViewController.modalPresentationStyle = .fullScreen
        self.present(dashboardViewController, animated: true)
    }
}
