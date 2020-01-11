//
//  QuizViewModel.swift
//  Quiz Challenge
//
//  Created by Pedro Henrique Almeida on 11/01/20.
//  Copyright © 2020 Pedro Almeida. All rights reserved.
//

import Foundation

protocol QuizViewModelProtocol: class {
    var totalTime: Double { get }
    var answers: [String] { get }
    var userAnswers: [String] { get }
    
    init(viewProtocol: QuizViewProtocol)
    func getQuiz()
    func toggleState()
    func validate(answer: String)
    func reset()
}

class QuizViewModel: QuizViewModelProtocol {

    let totalTime = 60.0

    var quiz: Quiz? = nil
    var userAnswers: [String] = []
    var answers: [String] {
        return quiz?.answer ?? []
    }
    private let view: QuizViewProtocol
    private var timer: CountDownTimer?
    
    required init(viewProtocol: QuizViewProtocol) {
        self.view = viewProtocol
    }
    
    func getQuiz() {
        
        QuizRepository().get(success: { quiz in
            self.quiz = quiz
            self.view.setQuiz(quiz: quiz)
        }, error: { error in
            self.view.showError(message: NSLocalizedString("default_error_message", comment: ""))
        })
    }
    
    func toggleState() {
        if timer == nil {
            timer = CountDownTimer(timeInSeconds: totalTime, timeUpdated: { self.view.updateTime(time: $0) }, timeFinished: { self.checkResult() })
            timer?.start()
            view.setState(running: true)
        } else {
            timer = nil
            reset()
        }
    }
    
    func validate(answer: String) {
        if let _ = answers.first(where: { $0 == answer }), !userAnswers.contains(answer) {
            self.userAnswers.append(answer)
            view.updateScore()
            checkResult()
        }
    }
    
    func reset() {
        userAnswers = []
        view.setState(running: false)
    }
    
    private func checkResult() {
        if didUserHitAllAnswers() {
            timer = nil
            view.showResult(won: true)
        }
    }
    
    private func didUserHitAllAnswers() -> Bool {
        return userAnswers.count == answers.count
    }
}
