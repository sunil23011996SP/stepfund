//
//  getFAQResModel.swift
//  stepfund1
//
//  Created by satish prajapati on 03/08/25.
//

import Foundation

class getFAQResModel: Codable {
    let code, message: String
    let data: [getFAQDataResModel]

    init(code: String, message: String, data: [getFAQDataResModel]) {
        self.code = code
        self.message = message
        self.data = data
    }
}

// MARK: - Datum
class getFAQDataResModel: Codable {
    let id: Int
    let question, answer, status, insertdate: String
    let updatetime: String

    init(id: Int, question: String, answer: String, status: String, insertdate: String, updatetime: String) {
        self.id = id
        self.question = question
        self.answer = answer
        self.status = status
        self.insertdate = insertdate
        self.updatetime = updatetime
    }
}
