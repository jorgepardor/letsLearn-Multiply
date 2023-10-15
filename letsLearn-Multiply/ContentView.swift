import SwiftUI

struct ContentView: View {
    
    @State private var isSet = false
    @State private var questionList: [(String, Int)] = [("Test", 1)]
    @State private var questionNumber = 0
    @State private var currentNumber = 1
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        if isSet {
            Question(questionList: $questionList, isSet: $isSet)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
        } else {
            VStack {
                Text("Aprendiendo a:")
                Text("Multiplicar")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .padding()
            .background(.blue)
            .cornerRadius(15)
            .shadow(radius: 10)
            
            Text("¿Qué tabla de multiplicar quieres practicar?")
            ScrollView {
               LazyVGrid(columns: columns, spacing: 20) {
                   ForEach(2..<11) { number in
                       Button("\(number)") {
                           self.currentNumber = number
                           self.generateQuestions()
                       }
                       .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                       .padding()
                       .background(Color.blue)
                       .foregroundColor(.white)
                       .cornerRadius(10)
                   }
               }
               .padding(.all)
            }
        }
    }

    
    func generateQuestions() {
        questionList.removeAll()
        
        for _ in 1...12 {
            let randomFactor = Int.random(in: 1...10)
            let question = "\(currentNumber) x \(randomFactor)"
            let answer = currentNumber * randomFactor
            
            questionList.append((question, answer))
        }
        
        isSet = true
    }
}


#Preview {
    ContentView()
}
