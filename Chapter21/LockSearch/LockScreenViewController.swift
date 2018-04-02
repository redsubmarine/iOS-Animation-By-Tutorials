/*
 * Copyright (c) 2016-present Razeware LLC
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

// image by NASA: https://www.flickr.com/photos/nasacommons/29193068676/

import UIKit

class LockScreenViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateTopConstraint: NSLayoutConstraint!
    
    let blurView = UIVisualEffectView(effect: nil)
    
    var settingsController: SettingsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.bringSubview(toFront: searchBar)
        blurView.effect = UIBlurEffect(style: .dark)
        blurView.alpha = 0
        blurView.isUserInteractionEnabled = false
        view.insertSubview(blurView, belowSubview: searchBar)
        
        tableView.estimatedRowHeight = 130.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillLayoutSubviews() {
        blurView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.transform = CGAffineTransform(scaleX: 0.67, y: 0.67)
        tableView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AnimatorFactory.scaleUp(view: tableView)
            .startAnimation()
    }
    
    func toggleBlur(_ blurred: Bool) {
        AnimatorFactory.fade(view: blurView, visible: blurred)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func presentSettings(_ sender: Any? = nil) {
        //present the view controller
        settingsController = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        present(settingsController, animated: true, completion: nil)
    }
    
}

extension LockScreenViewController: WidgetsOwnerProtocol { }

extension LockScreenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Footer") as! FooterCell
            cell.didPressEdit = {[unowned self] in
                self.presentSettings()
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! WidgetCell
            cell.tableView = tableView
            cell.owner = self
            return cell
        }
    }
}

extension LockScreenViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        toggleBlur(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        toggleBlur(false)
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchBar.resignFirstResponder()
        }
    }
}
