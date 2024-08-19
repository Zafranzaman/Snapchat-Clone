//
//  ProfileViewController.swift
//  Snapchat
//
//  Created by Zafran Mac on 02/12/2023.
//
import UIKit
import SwiftUI

class ProfileViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nickNameLabel:UILabel!
    @IBOutlet weak var bodystackview:UIStackView!
    
    var initialContainerViewHeight: CGFloat = 1300
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel:UILabel!
    @IBOutlet weak var corpinLabel:UILabel!
    
    @IBOutlet weak var imageView2: UIImageView!
    
    var isScrollingUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        print("StackView frame: \(bodystackview.frame.height)")
        print("containerView frame: \(containerView.frame.height)")
        
        // ... (existing code)
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: 1205)
        
        // Add tap gesture recognizer to nameLabel
        let tapGestureForNameLabel = UITapGestureRecognizer(target: self, action: #selector(nameLabelTapped))
        nameLabel.addGestureRecognizer(tapGestureForNameLabel)
        nameLabel.isUserInteractionEnabled = true
        
        // Check if name is saved in UserDefaults and update the label
        if let savedName = UserDefaults.standard.string(forKey: "userName") {
            nameLabel.text = savedName
            // nickNameLabel.text = "user_\(savedName)"
        }
        let tapGestureForscoreLabel = UITapGestureRecognizer(target: self, action: #selector(scoreLabelTapped))
        scoreLabel.addGestureRecognizer(tapGestureForscoreLabel)
        scoreLabel.isUserInteractionEnabled = true
        
        // Check if name is saved in UserDefaults and update the label
        if let StreakName = UserDefaults.standard.string(forKey: "Streak") {
            scoreLabel.text = StreakName
        }
        // nick name
        let tapGestureFornickLabel = UITapGestureRecognizer(target: self, action: #selector(nickLabelTapped))
        nickNameLabel.addGestureRecognizer(tapGestureFornickLabel)
        nickNameLabel.isUserInteractionEnabled = true
        
        // Check if name is saved in UserDefaults and update the label
        if let StreakName = UserDefaults.standard.string(forKey: "Nick") {
            nickNameLabel.text = StreakName
        }
        // corpin
        let tapGestureForcorpinLabel = UITapGestureRecognizer(target: self, action: #selector(corpinLabelTapped))
        corpinLabel.addGestureRecognizer(tapGestureForcorpinLabel)
        corpinLabel.isUserInteractionEnabled = true
        
        // Check if name is saved in UserDefaults and update the label
        if let StreakName = UserDefaults.standard.string(forKey: "corpin") {
            corpinLabel.text = StreakName
        }
        
        
        scrollView.delegate = self
        
        if let imageData = DatabaseManager.shared.loadImageFromDatabase() {
            imageView.image = UIImage(data: Data(imageData))
        }
        if let imageData = DatabaseManager.shared.loadImageFromDatabase1() {
            tempImageView.image = UIImage(data: Data(imageData))
        }
        let tapGestureForPickImageView = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        pickImageView.addGestureRecognizer(tapGestureForPickImageView)
        pickImageView.isUserInteractionEnabled = true

        let tapGestureForTempImageView = UITapGestureRecognizer(target: self, action: #selector(tempImageViewTapped))
        tempImageView.addGestureRecognizer(tapGestureForTempImageView)
        tempImageView.isUserInteractionEnabled = true
        
        //round()
        Header()
    }
    //name
    @objc func nameLabelTapped() {
        // Display an alert with a text field
        let alertController = UIAlertController(title: "Enter Name", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            // Save the entered name to UserDefaults
            if let nameTextField = alertController.textFields?.first,
               let enteredName = nameTextField.text {
                self.nameLabel.text = enteredName
                //self.nickNameLabel.text = "user_\(enteredName)"
                UserDefaults.standard.set(enteredName, forKey: "userName")
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //score
    @objc func scoreLabelTapped() {
        // Display an alert with a text field
        let alertController = UIAlertController(title: "Enter Streak", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Streak"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            // Save the entered name to UserDefaults
            if let nameTextField = alertController.textFields?.first,
               let enteredName = nameTextField.text {
                self.scoreLabel.text = enteredName
                UserDefaults.standard.set(enteredName, forKey: "Streak")
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        present(alertController, animated: true, completion: nil)
    }
    //nick
    @objc func nickLabelTapped() {
        // Display an alert with a text field
        let alertController = UIAlertController(title: "Enter ID Name", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "ID Name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            // Save the entered name to UserDefaults
            if let nameTextField = alertController.textFields?.first,
               let enteredName = nameTextField.text {
                self.nickNameLabel.text = enteredName
                UserDefaults.standard.set(enteredName, forKey: "Nick")
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        present(alertController, animated: true, completion: nil)
    }
    //corpin
    @objc func corpinLabelTapped() {
        // Display an alert with a text field
        let alertController = UIAlertController(title: "Enter Astrological Profile", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Astrological Profile"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            // Save the entered name to UserDefaults
            if let nameTextField = alertController.textFields?.first,
               let enteredName = nameTextField.text {
                self.corpinLabel.text = enteredName
                UserDefaults.standard.set(enteredName, forKey: "corpin")
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func imageViewTapped() {
        presentImagePicker(forImageView: pickImageView)
    }

    @objc func tempImageViewTapped() {
        presentImagePicker(forImageView: tempImageView)
    }

    func presentImagePicker(forImageView imageView: UIImageView) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        // Set a tag or any identifier to differentiate between image views
        imagePickerController.view.tag = imageView.tag
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            if let imageData = pickedImage.pngData() {
                print("tempImageView.tag:", tempImageView.tag)
                print("picker.view?.tag:", picker.view?.tag)
                
                if picker.view?.tag == tempImageView.tag {
                    print("Condition is true for tempImageView!")
                    DatabaseManager.shared.saveImageToDatabase(table: "QRprofile", imageData: imageData) { success in
                        if success {
                            self.loadImageAndUpdateUI1(forImageViewTag: picker.view?.tag)
                        } else {
                            print("Failed to save image to database.")
                        }
                    }
                } else {
                    print("Condition is true for imageView!")
                    // Save to the database and display in imageView
                    DatabaseManager.shared.saveImageToDatabase(table: "profiles", imageData: imageData) { success in
                        if success {
                            self.loadImageAndUpdateUI(forImageViewTag: picker.view?.tag)
                        } else {
                            print("Failed to save image to database.")
                        }
                    }
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
    }


    func loadImageAndUpdateUI1(forImageViewTag tag: Int?) {
        DispatchQueue.main.async {
            if let imageData = DatabaseManager.shared.loadImageFromDatabase1() {
                self.tempImageView.image = UIImage(data: Data(imageData))
            }
        }
    }
    func loadImageAndUpdateUI(forImageViewTag tag: Int?) {
        DispatchQueue.main.async {
            if let imageData = DatabaseManager.shared.loadImageFromDatabase() {
                self.imageView.image = UIImage(data: Data(imageData))
            }
        }
    }

    
    func Header() {
        //        // Set the back button image
        //              let backButtonImage = UIImage(named: "back")
        //              navigationController?.navigationBar.backIndicatorImage = backButtonImage
        //              navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        // Set the title
        self.title = ""
        
        // Set the back button image
        let backButtonImage = UIImage(named: "back")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.imageInsets = UIEdgeInsets(top: 0, left: -60, bottom: 0, right: 0) // Adjust the left inset
        navigationItem.leftBarButtonItem = backButton
        
        // Disable the default back button
        navigationController?.navigationItem.hidesBackButton = true
        
        
        // Set the right side image
        if let originalImage = UIImage(named: "icon6") {
            let imageSize = CGSize(width: 85, height: 40) // Set the desired size for the image
            
            // Resize the original image to the desired size
            UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
            originalImage.draw(in: CGRect(origin: .zero, size: imageSize))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // Create a UIBarButtonItem with the resized image
            let rightBarButtonItem = UIBarButtonItem(image: resizedImage?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(rightImageTapped))
            
            // Optionally, adjust the right inset
            rightBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
            
            // Set the right bar button item
            navigationItem.rightBarButtonItem = rightBarButtonItem
        }
        
    }
    
    @objc func rightImageTapped() {
        // Handle right image tap action
        print("Right image tapped")
    }
    @objc func backButtonTapped() {
        // Handle custom back button tap action
        print("Back button tapped")
        navigationController?.popViewController(animated: true)
    }
    
    func round() {
        let cornerRadius: CGFloat = 30.0
        let maskPath = UIBezierPath(
            roundedRect: containerView.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        containerView.layer.mask = maskLayer
        
        let maskPath1 = UIBezierPath(
            roundedRect: scrollView.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        let maskLayer1 = CAShapeLayer()
        maskLayer1.path = maskPath1.cgPath
        scrollView.layer.mask = maskLayer1
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        let currentOffset = scrollView.contentOffset.y

        // You can adjust the threshold value based on your preference
        let threshold: CGFloat = 50.0

        if currentOffset > threshold && !isScrollingUp {
            // Scrolling up, hide images
            isScrollingUp = true
            hideImages()
        } else if currentOffset <= threshold && isScrollingUp {
            // Scrolling down or at the top, show images
            isScrollingUp = false
            showImages()
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        profileViewController.modalPresentationStyle = .fullScreen
        self.present(profileViewController, animated: true)
    }
    
    func hideImages() {
        UIView.animate(withDuration: 0.3) {
            self.pickImageView.alpha = 0
            self.imageView2.alpha = 0
        }
    }
    
    func showImages() {
        UIView.animate(withDuration: 0.3) {
            self.pickImageView.alpha = 1
            self.imageView2.alpha = 1
        }
    }
}

