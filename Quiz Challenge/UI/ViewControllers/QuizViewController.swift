//
//  ViewController.swift
//  Quiz Challenge
//
//  Created by Pedro Almeida on 10/01/20.
//  Copyright © 2020 Pedro Almeida. All rights reserved.
//

import UIKit

protocol QuizViewProtocol: ViewProtocol {
    func setQuiz(quiz: Quiz)
    func showResult(won: Bool)
    func updateTime(time: Double)
    func updateScore()
    func setState(running: Bool)
}

class QuizViewController: BaseViewController {

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
    fileprivate let isLoading = false
    
    fileprivate lazy var viewModel: QuizViewModelProtocol = QuizViewModel(viewProtocol: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        //Add keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setLoading(true)
        viewModel.getQuiz()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func didTappedOnStartStop(_ sender: Any) {
        viewModel.toggleState()
    }
    
    private func setupView() {        
        txfKeyword.backgroundColor = Colors.whiteSmoke
        txfKeyword.layer.masksToBounds = true
        txfKeyword.layer.cornerRadius = kButtonCornerRadius
        txfKeyword.setLeftPadding(8.0)
        txfKeyword.delegate = self
        txfKeyword.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        btnControl.layer.cornerRadius = kButtonCornerRadius
        btnControl.setTitle(NSLocalizedString("btn_start_title", comment: ""), for: .normal)
        
        tableView.dataSource = self
        
        updateTime(time: viewModel.totalTime)
        updateScore()
    }
    
    private func setLoading(_ loading: Bool) {
        viewQuestion.isHidden = loading
        showLoading(loading)
    }
    
    private func reset() {
        tableView.reloadData()
        btnControl.setTitle(NSLocalizedString("btn_start_title", comment: ""), for: .normal)
        updateScore()
        updateTime(time: viewModel.totalTime)
        txfKeyword.text = ""
        self.view.endEditing(true)
    }
    
    fileprivate func getStringFromInt(_ timeValue: Int) -> String {
        let value = timeValue
        return value > 9 ? String(value) : "0\(value)"
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        let answer = textField.text ?? ""
        viewModel.validate(answer: answer)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if viewControlBottomConstraint.constant == 0 {
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

extension QuizViewController: QuizViewProtocol {
    func setQuiz(quiz: Quiz) {
        setLoading(false)
        lblQuestion.text = quiz.question
        updateScore()
    }
    
    func showResult(won: Bool) {
        let title = NSLocalizedString(won ? "congratulations_alert_title" : "you_lost_alert_title", comment: "")
        let message = String(format: NSLocalizedString(won ? "congratulations_alert_message" : "you_lost_alert_message", comment: ""), viewModel.userAnswers.count, viewModel.answers.count)
        let actionTitle = NSLocalizedString(won ? "congratulations_alert_action" : "you_lost_alert_action", comment: "")
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { action in
            self.viewModel.reset()
        }))

        self.present(alert, animated: true)
    }
    
    func updateTime(time: Double) {
        let minutes = Int(time/60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60.0))
        
        print("\(minutes):\(seconds)")
        lblTime.text = "\(getStringFromInt(minutes)):\(getStringFromInt(seconds))"
    }
    
    func updateScore() {
        lblAnswers.text = "\(getStringFromInt(viewModel.userAnswers.count))/\(getStringFromInt(viewModel.answers.count))"
        self.tableView.reloadData()
        txfKeyword.text = ""
    }
    
    func setState(running: Bool) {
        if running {
            btnControl.setTitle(NSLocalizedString("btn_reset_title", comment: ""), for: .normal)
            txfKeyword.becomeFirstResponder()
        } else {
            reset()
        }
    }
    
}

extension QuizViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier) {
            cell = reusableCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: kCellIdentifier)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17.0)
        }
        
        cell.textLabel?.text = (self.viewModel.userAnswers.reversed())[indexPath.row]
        
        return cell
    }
}

extension QuizViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txfKeyword {
            if btnControl.currentTitle == NSLocalizedString("btn_start_title", comment: "") {
                let alert = UIAlertController(title: NSLocalizedString("not_started_alert_title", comment: ""), message: NSLocalizedString("not_started_alert_message", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("not_started_alert_action", comment: ""), style: .default, handler: nil))

                self.present(alert, animated: true)
            }
            
            return btnControl.currentTitle == NSLocalizedString("btn_reset_title", comment: "")
        }
        
        return true
    }
}
