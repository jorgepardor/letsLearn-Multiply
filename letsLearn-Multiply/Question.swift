import SwiftUI

struct Question: View {
    @Binding var questionList: [(String, Int)]
    @Binding var isSet: Bool
    
    @State private var currentQuestionIndex = 0
    @State private var currentScore = 0
    
    @State private var showingFeedback = false
    @State private var feedbackTitle = ""
    @State private var feedbackMessage = ""
    @State private var nextQuestionReady = false
    
    func generateOptions(correctAnswer: Int) -> [Int] {
        var options = Set<Int>()
        options.insert(correctAnswer)
        
        while options.count < 4 {
            let randomOption = Int.random(in: 1...100)
            options.insert(randomOption)
        }
        
        return Array(options).shuffled()
    }
    
    var body: some View {
        ZStack {
            VStack {
                if currentQuestionIndex < questionList.count {
                    
                    let correctAnswer = questionList[currentQuestionIndex].1
                    let shuffledOptions = generateOptions(correctAnswer: correctAnswer)
                    
                    Text("Pregunta \(currentQuestionIndex + 1)/\(questionList.count)")
                        .font(.headline)
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle().frame(width: geometry.size.width, height: 8)
                                .opacity(0.3)
                                .foregroundColor(Color(UIColor.systemTeal))
                            
                            Rectangle().frame(width: geometry.size.width * CGFloat(currentQuestionIndex) / CGFloat(questionList.count), height: 8)
                                .foregroundColor(Color(UIColor.systemTeal))
                        }
                        .cornerRadius(4.0)
                    }
                    .frame(height: 8)
                    .padding(.horizontal)


                    
                    Text("¿Cuánto es \(questionList[currentQuestionIndex].0)?")
                    
                    HStack {
                        ForEach(shuffledOptions, id: \.self) { option in
                            Button("\(option)") {
                                if option == correctAnswer {
                                    feedbackTitle = "Respuesta Correcta"
                                    feedbackMessage = "Respuesta Correcta"
                                    showingFeedback = true
                                    nextQuestionReady = true
                                    currentScore += 1
                                } else {
                                    feedbackTitle = "Respuesta Incorrecta"
                                    feedbackMessage = "La respuesta correcta era: \(questionList[currentQuestionIndex].0) = \(correctAnswer)"
                                    showingFeedback = true
                                    nextQuestionReady = true
                                }
                                showingFeedback = true
                                   DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                       self.nextQuestionReady = true
                                   }
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    

                    
                    Text("Puntuación actual: \(currentScore)")
                } else {
                    if currentScore <= 5 {
                        Text("¡Buen trabajo, aunque debes seguir practicando para dominar la multiplicación!")
                            .font(.headline)
                            .padding()
                    } else if currentScore > 6 && currentScore <= 10 {
                        Text("¡Enhorabuena, has acertado la mayoría de las preguntas!")
                            .font(.headline)
                            .padding()
                    } else {
                        Text("¡Excelente, ya sabes la tabla del #numeroaqui!")
                            .font(.headline)
                            .padding()
                    }
                    Text("Has acertado \(currentScore) de un total de 12 preguntas.")
                        .font(.subheadline)
                        .padding()
                    Button("Jugar otra vez") {
                        currentQuestionIndex = 0
                        currentScore = 0
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Button("Volver a las tablas de multiplicar") {
                       currentQuestionIndex = 0
                       currentScore = 0
                       isSet = false
                   }

                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
            
            if showingFeedback {
                VStack {
                    Text(feedbackTitle)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(15.0)
                    Text(feedbackMessage)
//                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(15.0)
                    Text("Toca la pantalla para continuar")
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .background(Color.black.opacity(0.4))
                .onTapGesture {
                    self.showingFeedback = false
                    if self.nextQuestionReady {
                        self.currentQuestionIndex += 1
                        self.nextQuestionReady = false
                    }
                }
                .gesture(TapGesture().onEnded({ _ in
                    self.showingFeedback = false
                    if nextQuestionReady {
                        self.currentQuestionIndex += 1
                        self.nextQuestionReady = false
                    }
                }))
            }

        }
        .onAppear {
            if showingFeedback && nextQuestionReady {
                self.currentQuestionIndex += 1
                self.nextQuestionReady = false
            }
        }
    }
}
