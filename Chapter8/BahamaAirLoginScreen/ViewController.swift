/*
 * Copyright (c) 2014-present Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

// A delay function
func delay(seconds: Double, completion: @escaping ()-> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

func tintBackgroundColor(layer: CALayer, toColor: UIColor) {
    let background = CABasicAnimation(keyPath: "backgroundColor")
    background.fromValue = layer.backgroundColor
    background.toValue = toColor.cgColor
    background.duration = 1.0
    layer.add(background, forKey: nil)
    layer.backgroundColor = toColor.cgColor
}

func roundCorners(layer: CALayer, toRadius: CGFloat) {
    let corner = CABasicAnimation(keyPath: "cornerRadius")
    corner.fromValue = layer.cornerRadius
    corner.toValue = toRadius
    corner.duration = 1.0
    layer.add(corner, forKey: nil)
    layer.cornerRadius = toRadius

}

class ViewController: UIViewController {
    
    // MARK: IB outlets
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var heading: UILabel!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    @IBOutlet var cloud1: UIImageView!
    @IBOutlet var cloud2: UIImageView!
    @IBOutlet var cloud3: UIImageView!
    @IBOutlet var cloud4: UIImageView!
    
    // MARK: further UI
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    let status = UIImageView(image: UIImage(named: "banner"))
    let label = UILabel()
    let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Failed"]
    
    var statusPosition = CGPoint.zero
    
    // MARK: view controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up the UI
        loginButton.layer.cornerRadius = 8.0
        loginButton.layer.masksToBounds = true
        
        spinner.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
        spinner.startAnimating()
        spinner.alpha = 0.0
        loginButton.addSubview(spinner)
        
        status.isHidden = true
        status.center = loginButton.center
        view.addSubview(status)
        
        label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
        label.font = UIFont(name: "HelveticaNeue", size: 18.0)
        label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
        label.textAlignment = .center
        status.addSubview(label)
        
        statusPosition = status.center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animateLayers()

        loginButton.center.y += 30.0
        loginButton.alpha = 0.0

    }
    
    private func animateCloudsAlpha() {
        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.isRemovedOnCompletion = false
        fadeIn.fromValue = 0.0
        fadeIn.toValue = 1.0
        fadeIn.duration = 0.5
        [cloud1, cloud2, cloud3, cloud4].enumerated().forEach({ index, view in
            fadeIn.fillMode = kCAFillModeBackwards
            fadeIn.beginTime = CACurrentMediaTime() + 0.2 * Double(index) + 0.5
            view!.layer.add(fadeIn, forKey: nil)
        })
        
    }
    
    private func animateLayers() {
        let flyRight = CABasicAnimation(keyPath: "position.x")
        flyRight.fillMode = kCAFillModeBoth
        flyRight.isRemovedOnCompletion = false
        flyRight.fromValue = -view.bounds.width / 2
        flyRight.toValue = view.bounds.width / 2
        flyRight.duration = 0.5
        heading.layer.add(flyRight, forKey: nil)
        flyRight.beginTime = CACurrentMediaTime() + 0.3
        username.layer.add(flyRight, forKey: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateCloudsAlpha()

        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.0,
                       animations: {
                        self.loginButton.center.y -= 30.0
                        self.loginButton.alpha = 1.0
        },
                       completion: nil
        )
        
        animateCloud(cloud1)
        animateCloud(cloud2)
        animateCloud(cloud3)
        animateCloud(cloud4)
    }
    
    func showMessage(index: Int) {
        label.text = messages[index]
        
        UIView.transition(with: status, duration: 0.33,
                          options: [.curveEaseOut, .transitionFlipFromBottom],
                          animations: {
                            self.status.isHidden = false
        },
                          completion: {_ in
                            //transition completion
                            delay(seconds: 2.0) {
                                if index < self.messages.count-1 {
                                    self.removeMessage(index: index)
                                } else {
                                    //reset form
                                    self.resetForm()
                                }
                            }
        }
        )
    }
    
    func removeMessage(index: Int) {
        
        UIView.animate(withDuration: 0.33, delay: 0.0,
                       animations: {
                        self.status.center.x += self.view.frame.size.width
        },
                       completion: {_ in
                        self.status.isHidden = true
                        self.status.center = self.statusPosition
                        
                        self.showMessage(index: index+1)
        }
        )
    }
    
    func resetForm() {
        UIView.transition(with: status, duration: 0.2, options: .transitionFlipFromTop,
                          animations: {
                            self.status.isHidden = true
                            self.status.center = self.statusPosition
        },
                          completion: { _ in
                            let tintColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
                            tintBackgroundColor(layer: self.loginButton.layer, toColor: tintColor)
                            
                            roundCorners(layer: self.loginButton.layer, toRadius: 8.0)
        })
        
        UIView.animate(withDuration: 0.2, delay: 0.0,
                       animations: {
                        self.spinner.center = CGPoint(x: -20.0, y: 16.0)
                        self.spinner.alpha = 0.0
                        self.loginButton.bounds.size.width -= 80.0
                        self.loginButton.center.y -= 60.0
        },
                       completion: nil)
    }
    
    // MARK: further methods
    
    @IBAction func login() {
        view.endEditing(true)
        
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 0.0,
                       animations: {
                        self.loginButton.bounds.size.width += 80.0
        },
                       completion: {_ in
                        self.showMessage(index: 0)
        }
        )
        
        UIView.animate(withDuration: 0.33, delay: 0.0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.0,
                       animations: {
                        self.loginButton.center.y += 60.0
                        self.spinner.center = CGPoint(x: 40.0, y: self.loginButton.frame.size.height/2)
                        self.spinner.alpha = 1.0
        },
                       completion: nil
        )
        
        let tintColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
        tintBackgroundColor(layer: loginButton.layer, toColor: tintColor)
        
        roundCorners(layer: loginButton.layer, toRadius: 25.0)
    }
    
    func animateCloud(_ cloud: UIImageView) {
        let cloudSpeed = 60.0 / view.frame.size.width
        let duration = (view.frame.size.width - cloud.frame.origin.x) * cloudSpeed
        UIView.animate(withDuration: TimeInterval(duration), delay: 0.0, options: .curveLinear,
                       animations: {
                        cloud.frame.origin.x = self.view.frame.size.width
        },
                       completion: {_ in
                        cloud.frame.origin.x = -cloud.frame.size.width
                        self.animateCloud(cloud)
        }
        )
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextField = (textField === username) ? password : username
        nextField?.becomeFirstResponder()
        return true
    }
    
}
