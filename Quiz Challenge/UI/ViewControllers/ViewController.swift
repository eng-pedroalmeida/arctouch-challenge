//
//  ViewController.swift
//  Quiz Challenge
//
//  Created by Pedro Almeida on 10/01/20.
//  Copyright © 2020 Pedro Almeida. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    private let kTimeValueInSeconds = 60.0
    private let kButtonCornerRadius: CGFloat = 10.0
    private let kCellIdentifier = "DefaultCell"
    
    @IBOutlet weak var viewQuestion: UIView!
    @IBOutlet weak var viewControl: UIView!
    @IBOutlet weak var viewControlBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var txfKeyword: UITextField!
    @IBOutlet weak var lblAnswers: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnControl: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //Just for test
    fileprivate let kCorrectKeywords = ["abstract","assert","boolean"]
    fileprivate let isLoading = false
    
    private var timer: CountDownTimer?
    fileprivate var correctAnswers: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        //Add keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setLoading(isLoading)
    }
    
    @IBAction func didTappedOnStartStop(_ sender: Any) {
        if timer == nil {
            timer = CountDownTimer(timeInSeconds: kTimeValueInSeconds, timeUpdated: { self.updateTime($0) }, timeFinished: {
                self.updateTime(0.0)
                self.finishQuiz()
            })
            timer?.start()
            txfKeyword.becomeFirstResponder()
            btnControl.setTitle(NSLocalizedString("btn_reset_title", comment: ""), for: .normal)
        } else {
            timer = nil
            resetQuiz()
        }
    }
    
    private func setupView() {
        //Just for test
        lblQuestion.text = "What are all the java keywords?"
        
        txfKeyword.backgroundColor = Colors.whiteSmoke
        txfKeyword.layer.masksToBounds = true
        txfKeyword.layer.cornerRadius = kButtonCornerRadius
        txfKeyword.setLeftPadding(8.0)
        txfKeyword.delegate = self
        txfKeyword.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        btnControl.layer.cornerRadius = kButtonCornerRadius
        btnControl.setTitle(NSLocalizedString("btn_start_title", comment: ""), for: .normal)
        
        tableView.dataSource = self
        
        updateTime(kTimeValueInSeconds)
        updateScore()
    }
    
    private func setLoading(_ loading: Bool) {
        viewQuestion.isHidden = loading
        showLoading(loading)
    }
    
    private func updateScore() {
        lblAnswers.text = "\(getStringFromInt(correctAnswers.count))/\(getStringFromInt(kCorrectKeywords.count))"
        if correctAnswers.count == kCorrectKeywords.count {
            finishQuiz()
        }
    }
    
    private func updateTime(_ time: Double) {
        let minutes = Int(time/60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60.0))
        
        print("\(minutes):\(seconds)")
        lblTime.text = "\(getStringFromInt(minutes)):\(getStringFromInt(seconds))"
    }
    
    private func finishQuiz() {
        showResult(kCorrectKeywords.count == correctAnswers.count)
    }
    
    private func showResult(_ won: Bool) {
        let title = NSLocalizedString(won ? "congratulations_alert_title" : "you_lost_alert_title", comment: "")
        let message = String(format: NSLocalizedString(won ? "congratulations_alert_message" : "you_lost_alert_message", comment: ""), correctAnswers.count, kCorrectKeywords.count)
        let actionTitle = NSLocalizedString(won ? "congratulations_alert_action" : "you_lost_alert_action", comment: "")
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { action in
            self.resetQuiz()
        }))

        self.present(alert, animated: true)
    }
    
    private func resetQuiz() {
        timer = nil
        correctAnswers = []
        tableView.reloadData()
        btnControl.setTitle(NSLocalizedString("btn_start_title", comment: ""), for: .normal)
        updateScore()
        updateTime(kTimeValueInSeconds)
        txfKeyword.text = ""
        self.view.endEditing(true)
    }
    
    func getStringFromInt(_ timeValue: Int) -> String {
        let value = timeValue
        return value > 9 ? String(value) : "0\(value)"
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        print("text: \(textField.text ?? "")")
        let answer = textField.text ?? ""
        if let _ = kCorrectKeywords.first(where: { $0 == answer }), !correctAnswers.contains(answer) {
            self.correctAnswers.append(answer)
            self.tableView.reloadData()
            textField.text = ""
            updateScore()
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print(viewControlBottomConstraint.constant)
            if viewControlBottomConstraint.constant == 0 {
                print("Keyboard size: \(keyboardSize.height)")
                viewControlBottomConstraint.constant = keyboardSize.height
                viewControl.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if viewControlBottomConstraint.constant != 0 {
            viewControlBottomConstraint.constant = 0
            viewControl.layoutIfNeeded()
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return correctAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier) {
            cell = reusableCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: kCellIdentifier)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17.0)
        }
        
        cell.textLabel?.text = (self.correctAnswers.reversed())[indexPath.row]
        
        return cell
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txfKeyword {
            if timer == nil {
                let alert = UIAlertController(title: NSLocalizedString("not_started_alert_title", comment: ""), message: NSLocalizedString("not_started_alert_message", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("not_started_alert_action", comment: ""), style: .default, handler: nil))

                self.present(alert, animated: true)
            }
            
            return timer != nil
        }
        
        return true
    }
}
