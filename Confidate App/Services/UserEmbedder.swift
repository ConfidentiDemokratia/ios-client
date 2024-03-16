//
//  UserEmbedder.swift
//  Confidate
//
//  Created by Nikolai Trukhin on 16.03.2024.
//
import CoreML
import Foundation

class UserEmbedder {

    private let model: BERTEmbedder
    private let tokenizer: BertTokenizer

    init(){
        model = BERTEmbedder()
        tokenizer = BertTokenizer(maxLen: 256)
    }

    func embed(questions: [DelegatorQuestion]) throws -> MLMultiArray? {
        let prompt = createEmbeddingPrompt(questions: questions)
        print("generating embedding with prompt: ", prompt)
        // token ids array
        let tokenIdsArray: [Int] = tokenizer.tokenizeToIds(text: prompt)
        do {
            let tokenIds = try MLMultiArray(shape: [1, NSNumber(value: tokenIdsArray.count)], dataType: .double)
            for (index, id) in tokenIdsArray.enumerated() {
                tokenIds[index] = NSNumber(value: id)
            }
            // Continue using 'tokenIds' here
            let modelInput = BERTEmbedderInput(input_ids: tokenIds)
            // Now you can use modelInput with your BERTEmbedder model
            let prediction = try? model.prediction(input: modelInput).var_559
            return prediction
        } catch {
           throw error
        }
    }

    func createEmbeddingPrompt(questions: [DelegatorQuestion]) -> String {
        // create prompts array for efficient concatenation
//        var prompts: [String] = []

        questions.reduce("") { str, question in
            if let answerIndex = question.answerIndex {
                return str + question.title + ":" + question.answers[answerIndex] + "\n"
            }
            return str
        }

        // create and append prompts
//        let basePrompt: String = "The user is a"
//        prompts.append(basePrompt)
//        let genderPrompt: String = userInfo.gender
//        prompts.append(genderPrompt)
//        let agePrompt: String = "and his favorite animal is \(userInfo.animal)."
//        prompts.append(agePrompt)
//        let hobbiePrompt: String = "The users hobbie is \(userInfo.hobbie)."
//        prompts.append(hobbiePrompt)
        // concat prompts into one prompt
//        return prompts.joined(separator: " ")
    }
}
