//
//  QuizViewModelTests.swift
//  Quiz ChallengeTests
//
//  Created by Pedro Henrique Almeida on 11/01/20.
//  Copyright © 2020 Pedro Almeida. All rights reserved.
//

import XCTest
@testable import Quiz_Challenge

class QuizViewModelTests: XCTestCase {
    private let view = MockView()
    
    func testValidateKeywordSuccess() {
        //Given
        let viewModel = QuizViewModel(viewProtocol: view)
        let quiz = Quiz(question: "", answer: ["abstract", "assert", "boolean", "break", "byte"])
        viewModel.quiz = quiz
        let keyword = "boolean"
        
        //When
        viewModel.validate(answer: keyword)
        
        //Then
        XCTAssertTrue(viewModel.userAnswers.contains(keyword))
    }
    
    func testValidateKeywordError() {
        //Given
        let viewModel = QuizViewModel(viewProtocol: view)
        let quiz = Quiz(question: "", answer: ["abstract", "assert", "boolean", "break", "byte"])
        viewModel.quiz = quiz
        let keyword = "dog"
        
        //When
        viewModel.validate(answer: keyword)
        
        //Then
        XCTAssertFalse(viewModel.userAnswers.contains(keyword))
    }
    
    func testReset() {
        //Given
        let viewModel = QuizViewModel(viewProtocol: view)
        
        //When
        viewModel.reset()
        
        //Then
        XCTAssertEqual(viewModel.userAnswers.count, 0)
    }
    
    func testTime() {
        //Given
        let viewModel = QuizViewModel(viewProtocol: view)
        let totalTime: Double = 300 //5 minutes
        
        //Then
        XCTAssertEqual(viewModel.totalTime, totalTime)
    }
}

class MockView: QuizViewProtocol {
    func setQuiz(quiz: Quiz) {
        print("Quiz-> question: \(quiz.question)\nanswer: \(quiz.answer)")
    }
    
    func showResult(won: Bool) {
        print("showResult -> won: \(won)")
    }
    
    func updateTime(time: Double) {
        print("updateTime -> time:\(time)")
    }
    
    func updateScore() {
        print("updateScore")
    }
    
    func setState(running: Bool) {
        print("setState -> running: \(running)")
    }
    
    func showError(message: String) {
        print("showError -> message: \(message)")
    }
}
