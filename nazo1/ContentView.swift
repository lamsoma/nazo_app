import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var audioPlayer: AVAudioPlayer?
    let cymbalData = NSDataAsset(name:"start")!.data
    let buData = NSDataAsset(name:"bu")!.data
    @State private var gameIsOver = false // ゲームオーバー状態を管理

    var body: some View {
        NavigationView {
            ZStack {
                Image("myedit")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                VStack {
                    Text("SEVEN ANSWER").font(.system(.title, design: .serif))
                    
                    NavigationLink(destination: SecondView().navigationBarBackButtonHidden(true)) {
                        Text("START")
                            .frame(width: 140, height: 140)
                            .font(.system(size: 24.0))
                            .foregroundColor(Color.black)
                    }
                    .navigationBarTitle("", displayMode: .inline)
                }
            }
        }.navigationViewStyle(.stack)
        .onAppear {
            playBackgroundMusic()
        }
        .onChange(of: gameIsOver) { isOver in
            if isOver {
                stopBackgroundMusic()
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("GameOverNotification"), object: nil, queue: .main) { _ in
                stopBackgroundMusic()
            }
        }
    }
    
    func playBackgroundMusic() {
        do {
            audioPlayer = try AVAudioPlayer(data: cymbalData)
            audioPlayer?.numberOfLoops = -1 // 無限ループ
            audioPlayer?.volume = 0.5 // 音量を調整（0.0から1.0の範囲で）
            audioPlayer?.prepareToPlay() // 音楽ファイルをロードして準備
            audioPlayer?.play() // 音楽を再生
        } catch {
            print("音楽の再生に失敗しました: \(error.localizedDescription)")
        }
    }
    
    func stopBackgroundMusic() {
        print("Stopping background music")
        audioPlayer?.stop() // 音楽を停止
    }
    
    // ゲームオーバー条件が満たされたときに呼び出す関数
    func gameOver() {
        gameIsOver = true
    }
}

// SecondView と SontentView は変更なし




struct SecondView: View {
    var body: some View {
        NavigationView {
            ZStack{
                Image("myedit")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                VStack(spacing: 27) {
                    VStack{
                        Text("RULE").font(.system(size: 28.0))}
                    VStack{Text(" ")}
                    VStack{Text("・７問目を解くことがクリア条件です")}
                    VStack{Text("  ・１~６問目を解くと７問目を解くこと\n      ができます")}
                    VStack{Text("・制限時間は１５分です                      ")}
                    VStack{Text("")}
                    VStack{NavigationLink(destination: SontentView().navigationBarBackButtonHidden(true)) {
                        Text("GAME START").frame(width:120,height:70).foregroundColor(Color.black)
                        }
                        .navigationBarTitle("", displayMode: .inline)
                    }
                }
            }
        }.navigationViewStyle(.stack)
        
    }
}


struct SontentView: View {
    @State private var selectedButton: Int? = nil
    @State private var timerStarted = false
    @State private var elapsedTime: TimeInterval = 0.0
    @State private var timer: Timer? = nil
    @State private var a: Int = 0 // aをContentView内で管理
    @State private var b: Int = 0 // aをContentView内で管理
    @State private var c: Int = 0 // aをContentView内で管理
    @State private var d: Int = 0 // aをContentView内で管理
    @State private var e: Int = 0 // aをContentView内で管理
    @State private var f: Int = 0 // aをContentView内で管理
    let countdownDuration: TimeInterval = 15*60 // 15分の秒数

    var body: some View {
        NavigationView {
            ZStack {
                Image("myedit")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                VStack {
                    VStack(spacing: 80) {
                        VStack { Text("") }
                        VStack {
                            Text("残り時間: \(formattedRemainingTime)")
                                .font(.largeTitle)
                                .font(.headline)
                                .padding(.bottom, 20)
                        }
                    }

                    CircularButtonView(selectedButton: $selectedButton, a: $a,b: $b,c: $c,d: $d,e: $e,f: $f, timer: $timer)
                        .onAppear {
                            // ContentViewが表示されたときにタイマーを開始
                            if !timerStarted {
                                startTimer()
                                timerStarted = true
                            }
                        }
                    
                    // ナビゲーションリンクを使って遷移する
                    NavigationLink(destination: destinationView(), tag: 8, selection: $selectedButton) {
                        EmptyView()
                    }.hidden()
                }
                .navigationBarTitle("", displayMode: .inline)
            }
        }.navigationViewStyle(.stack)
    }

    // タイマーを開始する関数
    private func startTimer() {
        // カウントダウン用のタイマーを設定
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedTime += 1.0
            if elapsedTime >= countdownDuration {
                // 15分経過したら遷移
                selectedButton = 8 // 8番のボタンをタップして遷移
                timer?.invalidate()
                timer = nil
            }
        }
    }

    // 残り時間をフォーマットする計算型プロパティ
    private var formattedRemainingTime: String {
        let remainingTime = max(countdownDuration - elapsedTime, 0) // タイマーが0未満にならないように
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // 遷移先のビューを返す関数
    private func destinationView() -> some View {
        switch selectedButton {
        case 8:
            return AnyView(Q8View().navigationBarBackButtonHidden(true).navigationBarBackButtonHidden(true))
        default:
            return AnyView(EmptyView()) // デフォルトのビューを指定
        }
    }
}



// CircularButtonView の定義と Q1View, Q2View, Q7View の定義も同じままです


struct CircularButtonView: View {
    let buttonCount = 6 // ボタンの数を7に変更
    let radius: CGFloat = 100 // 円の半径
    @Binding var selectedButton: Int?
    @Binding var a: Int
    @Binding var b: Int
    @Binding var c: Int
    @Binding var d: Int
    @Binding var e: Int
    @Binding var f: Int
    @Binding var timer: Timer?
    @State private var buttonBackgroundColors: [Int: Image] = [:]
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(1...buttonCount, id: \.self) { index in
                    let angle = 2 * .pi / Double(buttonCount) * Double(index)
                    let x = geometry.size.width / 2 + radius * CGFloat(cos(angle-2 * .pi/3))
                    let y = geometry.size.height / 2 + radius * CGFloat(sin(angle-2 * .pi/3))
                    
                    Button(action: {
                        // ボタンがタップされたときの処理
                        selectedButton = index
                    }) {
                        Text("\(index)")
                            .font(.largeTitle)
                            .padding()
                            .background(buttonBackgroundColors[index])
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .clipShape(Circle())
                    }
                    .position(x: x, y: y)
                    .background(NavigationLink("", destination: destinationView(for: index), tag: index, selection: $selectedButton))
                }
                
                // 7番目のボタンを円の中に配置
                if a==1 && b==1 && c==1 && d==1 && e==1 && f==1{
                    Button(action: {
                        // ボタンがタップされたときの処理
                        selectedButton = 7
                    }) {
                        Text("7")
                            .font(.largeTitle)
                            .padding()
                            .background(Image("stone5"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .clipShape(Circle())
                        
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .background(NavigationLink("", destination: destinationView(for: 7), tag: 7, selection: $selectedButton))
                }
                // 7番目のボタンを円の中に配置
                else{
                    Button(action: {
                        // ボタンがタップされたときの処理
                        selectedButton = 7
                    }) {Text("7")
                            .font(.largeTitle)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .clipShape(Circle())
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
                
            }
        }.onAppear {
            // aの値に応じて7番目のボタンの背景色を設定
            if a == 1 {
                buttonBackgroundColors[1] = Image("stone7") // aが1の場合、赤色に設定
            } else {
                buttonBackgroundColors[1] = Image("stone5") // それ以外の場合、黒色に設定
            }
            if b == 1 {
                buttonBackgroundColors[2] = Image("stone7") // aが1の場合、赤色に設定
            } else {
                buttonBackgroundColors[2] = Image("stone5")// それ以外の場合、黒色に設定
            }
            if c == 1 {
                buttonBackgroundColors[3] = Image("stone7") // aが1の場合、赤色に設定
            } else {
                buttonBackgroundColors[3] = Image("stone5") // それ以外の場合、黒色に設定
            }
            if d == 1 {
                buttonBackgroundColors[4] = Image("stone7") // aが1の場合、赤色に設定
            } else {
                buttonBackgroundColors[4] = Image("stone5") // それ以外の場合、黒色に設定
            }
            if e == 1 {
                buttonBackgroundColors[5] = Image("stone7") // aが1の場合、赤色に設定
            } else {
                buttonBackgroundColors[5] = Image("stone5") // それ以外の場合、黒色に設定
            }
            if f == 1 {
                buttonBackgroundColors[6] = Image("stone7") // aが1の場合、赤色に設定
            } else {
                buttonBackgroundColors[6] = Image("stone5") // それ以外の場合、黒色に設定
            }
            
        }
    }
    // ボタンごとの遷移先ビューを設定するメソッド
    private func destinationView(for buttonIndex: Int) -> some View {
        switch buttonIndex {
        case 1:
            return AnyView(Q1View(a: $a))
        case 2:
            return AnyView(Q2View(b: $b))
        case 3:
            return AnyView(Q3View(c: $c))
        case 4:
            return AnyView(Q4View(d: $d))
        case 5:
            return AnyView(Q5View(e: $e))
        case 6:
            return AnyView(Q6View(f: $f))
        case 7:
            return AnyView(Q7View(a: $a,timer: $timer))
        default:
            return AnyView(EmptyView()) // デフォルトのビューを指定
        }
    }
}

struct Q1View: View {
    @State private var textInput: String = ""
    @State private var isCorrect: Bool = false // 正解かどうかを管理する状態変数
    @Binding var a: Int
    let buData = NSDataAsset(name: "Quiz")!.data
    @State private var audioPlayer: AVAudioPlayer?
    var body: some View {
        ZStack{
            Image("myedit")
                .resizable()
                .ignoresSafeArea()

            VStack {
                Text("箱").font(.system(size:80))
                Text("型").font(.system(size:80))
                Text("前").font(.system(size:80))
                HStack{
                    Text(" ").font(.system(size:60))
                    Text("は").font(.system(size:40))
                    Text(" ").font(.system(size:40))}
            Text("？には何が入る").font(.system(size: 30.0)).padding(5)
            TextField("解答を入力してください", text: $textInput, onCommit: {
                // テキストが確定（Enterキーが押された）ときに実行される処理
                if textInput == "袴" || textInput == "はかま" {
                    handleCorrectAnswer()
                }
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()

            if isCorrect {
                Text("正解")
                    .font(.headline)
                    .padding()
            }
        }
    }
}

func handleCorrectAnswer() {
    if !isCorrect {
        playBackgroundMusic()
        isCorrect = true
        a = 1 // ここで必要な処理を追加
    }
}

func playBackgroundMusic() {
    do {
        if audioPlayer == nil || !audioPlayer!.isPlaying {
            audioPlayer = try AVAudioPlayer(data: buData)
            audioPlayer?.volume = 1
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        }
    } catch {
        print("音楽の再生に失敗しました: \(error.localizedDescription)")
    }
}
}



struct Q2View: View {
    @State private var textInput: String = ""
    @State private var isCorrect: Bool = false // 正解かどうかを管理する状態変数
    @Binding var b: Int
    let buData = NSDataAsset(name: "Quiz")!.data
    @State private var audioPlayer: AVAudioPlayer?
    var body: some View {
        ZStack{
            Image("myedit")
                .resizable()
                .ignoresSafeArea()

        VStack {
            HStack{
                Text("oner = ").font(.system(.title, design: .serif))
                Text("r").font(.system(size:34))
                
            }
            HStack{
                Text("tent = ").font(.system(.title, design: .serif))
                Text("t").font(.system(size:34))
            }
            HStack{
                Text("height = ").font(.system(.title, design: .serif))
                Text("？").font(.system(size:34))}
            Text("？には何が入る").font(.system(size: 30.0)).padding(5)
            TextField("解答を入力してください", text: $textInput, onCommit: {
                // テキストが確定（Enterキーが押された）ときに実行される処理
                if textInput == "H" || textInput == "h" {
                    handleCorrectAnswer()
                }
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()

            if isCorrect {
                Text("正解")
                    .font(.headline)
                    .padding()
            }
        }
    }
}

func handleCorrectAnswer() {
    if !isCorrect {
        playBackgroundMusic()
        isCorrect = true
        b = 1 // ここで必要な処理を追加
    }
}

func playBackgroundMusic() {
    do {
        if audioPlayer == nil || !audioPlayer!.isPlaying {
            audioPlayer = try AVAudioPlayer(data: buData)
            audioPlayer?.volume = 1
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        }
    } catch {
        print("音楽の再生に失敗しました: \(error.localizedDescription)")
    }
}
}

struct Q3View: View {
    @State private var textInput: String = ""
    @State private var isCorrect: Bool = false // 正解かどうかを管理する状態変数
    @Binding var c: Int
    let buData = NSDataAsset(name: "Quiz")!.data
    @State private var audioPlayer: AVAudioPlayer?
    var body: some View {
        ZStack{
            Image("myedit")
                .resizable()
                .ignoresSafeArea()

        VStack {
            HStack{
                Text("⑥③②⑤⑥ = ちょうちょ").font(.system(.title, design: .serif))
                
            }
            HStack{
                Text("②④⑥② = さんかく").font(.system(.title, design: .serif)).padding(5)}
            HStack{
                Text("①③⑥②⑤① = ？").font(.system(.title, design: .serif)).padding(5)}
            Text("？には何が入る").font(.system(size: 30.0)).padding(5)
            TextField("解答を入力してください", text: $textInput, onCommit: {
                // テキストが確定（Enterキーが押された）ときに実行される処理
                if textInput == "ほし" {
                    handleCorrectAnswer()
                }
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()

            if isCorrect {
                Text("正解")
                    .font(.headline)
                    .padding()
            }
        }
    }
}

func handleCorrectAnswer() {
    if !isCorrect {
        playBackgroundMusic()
        isCorrect = true
        c = 1 // ここで必要な処理を追加
    }
}

func playBackgroundMusic() {
    do {
        if audioPlayer == nil || !audioPlayer!.isPlaying {
            audioPlayer = try AVAudioPlayer(data: buData)
            audioPlayer?.volume = 1
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        }
    } catch {
        print("音楽の再生に失敗しました: \(error.localizedDescription)")
    }
}
}

struct Q4View: View {
    @State private var textInput: String = ""
    @State private var isCorrect: Bool = false // 正解かどうかを管理する状態変数
    @Binding var d: Int
    let buData = NSDataAsset(name: "Quiz")!.data
    @State private var audioPlayer: AVAudioPlayer?
    var body: some View {
        ZStack{
            Image("myedit")
                .resizable()
                .ignoresSafeArea()

        VStack {
            Text("-1/4×2/3×1/3+1/2").font(.system(size:40))
            Text("                 ＝負け方").font(.system(size:40))
            Text(" ")
            Text("-3/4×1/3-1/4=?").font(.system(size:40))
            Text(" ")
            Text("?には何が入る").font(.system(size:30))
                TextField("解答を入力してください", text: $textInput, onCommit: {
                    // テキストが確定（Enterキーが押された）ときに実行される処理
                    if textInput == "仲間" || textInput == "なかま" {
                        handleCorrectAnswer()
                    }
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                if isCorrect {
                    Text("正解")
                        .font(.headline)
                        .padding()
                }
            }
        }
    }

    func handleCorrectAnswer() {
        if !isCorrect {
            playBackgroundMusic()
            isCorrect = true
            d = 1 // ここで必要な処理を追加
        }
    }

    func playBackgroundMusic() {
        do {
            if audioPlayer == nil || !audioPlayer!.isPlaying {
                audioPlayer = try AVAudioPlayer(data: buData)
                audioPlayer?.volume = 1
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            }
        } catch {
            print("音楽の再生に失敗しました: \(error.localizedDescription)")
        }
    }
}
struct Q5View: View {
    @State private var textInput: String = ""
    @State private var isCorrect: Bool = false // 正解かどうかを管理する状態変数
    @Binding var e: Int
    let buData = NSDataAsset(name: "Quiz")!.data
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        ZStack{
            Image("myedit")
                .resizable()
                .ignoresSafeArea()

        VStack {
            Group{
                Text("革").font(.system(size: 30.0))
                Text("↑").font(.system(size: 30.0))
                HStack{
                    Text("心").font(.system(size: 30.0))
                    Text("←").font(.system(size: 30.0))
                    Text("A").font(.system(size: 30.0))
                    Text("→").font(.system(size: 30.0))
                    Text("変").font(.system(size: 30.0))
                }
                
                HStack{
                    Text("↓").font(.system(size: 30.0))}
                Text("名").font(.system(size: 30.0))
                Text(" ").font(.system(size: 30.0))
                Text("竹").font(.system(size: 30.0))
                Text("↓").font(.system(size: 30.0))
                HStack{
                    Text("工").font(.system(size: 30.0))
                    Text("→").font(.system(size: 30.0))
                    Text("B").font(.system(size: 30.0))
                    Text("←").font(.system(size: 30.0))
                    Text("凡").font(.system(size: 30.0))
                }
                    Text("↑").font(.system(size: 30.0))
                
                
            }
                Text("木").font(.system(size:30.0))
                Text(" ").font(.system(size: 50.0))
                Text("ABが表す熟語は？").font(.system(size:30.0))
                TextField("解答を入力してください", text: $textInput, onCommit: {
                    // テキストが確定（Enterキーが押された）ときに実行される処理
                    if textInput == "改築" {
                        handleCorrectAnswer()
                    }
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                if isCorrect {
                    Text("正解")
                        .font(.headline)
                        .padding()
                }
            }
        }
    }

    func handleCorrectAnswer() {
        if !isCorrect {
            playBackgroundMusic()
            isCorrect = true
            e = 1 // ここで必要な処理を追加
        }
    }

    func playBackgroundMusic() {
        do {
            if audioPlayer == nil || !audioPlayer!.isPlaying {
                audioPlayer = try AVAudioPlayer(data: buData)
                audioPlayer?.volume = 1
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            }
        } catch {
            print("音楽の再生に失敗しました: \(error.localizedDescription)")
        }
    }
}
struct Q6View: View {
    let buData = NSDataAsset(name: "Quiz")!.data
    @Binding var f: Int
    @State private var textInput: String = ""
    @State private var isCorrect: Bool = false
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        ZStack {
            Image("myedit")
                .resizable()
                .ignoresSafeArea()

            VStack {
                Text("り = N").font(.system(size: 34.0)).padding(5)
                Text("１ = E").font(.system(size: 34.0)).padding(5)
                Text("と = W").font(.system(size: 34.0)).padding(5)
                Text("４ = ?").font(.system(size: 34.0)).padding(5)
                Text("？には何が入る").font(.system(size: 30.0)).padding(5)

                TextField("解答を入力してください", text: $textInput, onCommit: {
                    if textInput == "S" {
                        handleCorrectAnswer()
                    }
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                if isCorrect {
                    Text("正解")
                        .font(.headline)
                        .padding()
                }
            }
        }
    }

    func handleCorrectAnswer() {
        if !isCorrect {
            playBackgroundMusic()
            isCorrect = true
            f = 1 // ここで必要な処理を追加
        }
    }

    func playBackgroundMusic() {
        do {
            if audioPlayer == nil || !audioPlayer!.isPlaying {
                audioPlayer = try AVAudioPlayer(data: buData)
                audioPlayer?.volume = 1
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            }
        } catch {
            print("音楽の再生に失敗しました: \(error.localizedDescription)")
        }
    }
}


struct Q7View: View {
    @Binding var a: Int
    @State private var textInput: String = ""
    @State private var isCorrect: Bool = false // 正解かどうかを管理する状態変数
    @State private var shouldNavigateToQ9: Bool = false // 遷移フラグを追加
    @Binding var timer: Timer?
    var body: some View {
        ZStack {
            Image("myedit")
                .resizable()
                .ignoresSafeArea()
            VStack {
                Text("タイトルー間充５２＝？？")
                    .font(.title)
                    .padding()
                Text("スタートー①③⑥②⑤①＝？")
                    .font(.title)
                    .padding()
                Text("？？？に入る3文字は？")
                    .font(.title)
                TextField("テキストを入力してください", text: $textInput, onCommit: {
                    // テキストが確定（Enterキーが押された）ときに実行される処理
                    if textInput == "ART" || textInput == "アート" {
                        isCorrect = true // 正解の場合、isCorrectをtrueに設定
                        shouldNavigateToQ9 = true // 遷移フラグを設定
                    }
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                if isCorrect {
                    NavigationLink(destination: Q9View(timer: $timer).navigationBarBackButtonHidden(true), isActive: $shouldNavigateToQ9) {
                        EmptyView()
                    }
                    .hidden()
                }
            }}
    }
}



    
struct Q8View: View {
    let buData = NSDataAsset(name:"shock")!.data
    @State private var buAudioPlayer: AVAudioPlayer?
    var body: some View {
        ZStack{
            Image("myedit")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
            VStack {
                Text("GAME OVER")
                    .font(.title)
                
                // Trigger the game over logic when this view appears
                    .onAppear {
                        // Send a notification to stop background music
                        NotificationCenter.default.post(name: NSNotification.Name("GameOverNotification"), object: nil)
                        playBUDataSound()
                        
                    }
                NavigationLink(destination: TeachView(buAudioPlayer: $buAudioPlayer).navigationBarBackButtonHidden(true)) {
                    Text("解説へ")
                        .frame(width: 140, height: 140)
                        .font(.system(size: 24.0))
                        .foregroundColor(Color.black)
                }
                .navigationBarTitle("", displayMode: .inline)
            }
        }
    }
    func playBUDataSound() {
            do {
                buAudioPlayer = try AVAudioPlayer(data: buData)
                buAudioPlayer?.numberOfLoops = 0 // Play once
                buAudioPlayer?.volume = 1.0 // Adjust volume
                buAudioPlayer?.prepareToPlay()
                buAudioPlayer?.play()
            } catch {
                print("BU音の再生に失敗しました: \(error.localizedDescription)")
            }
        }
}

struct Q9View: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var gameIsOver = false // ゲームオーバー状態を管理
    @State private var shouldNavigateToSontentView: Bool = false // 遷移フラグを追加
    @Binding var timer: Timer?
    let buData = NSDataAsset(name:"GameClear")!.data
    @State private var buAudioPlayer: AVAudioPlayer?
    var body: some View {
        ZStack {
            Image("myedit")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
            VStack {
                Text("CLEAR").font(.largeTitle)
                    .onAppear {
                        // Q9Viewが表示されたときにタイマーを停止
                        timer?.invalidate()
                        timer = nil
                        NotificationCenter.default.post(name: NSNotification.Name("GameOverNotification"), object: nil)
                        playBUDataSound()
                        
                        
                    }

                Button(action: {
                    shouldNavigateToSontentView = true // ボタンがタップされたら遷移フラグを設定
                }) {
                    Text("解説へ")
                        .frame(width: 140, height: 140)
                        .font(.system(size: 24.0))
                        .foregroundColor(Color.black)
                }
                .navigationBarTitle("", displayMode: .inline)
                
                // TeachViewに遷移するNavigationLink
                NavigationLink("", destination:
                                TeachView(buAudioPlayer:$buAudioPlayer).navigationBarBackButtonHidden(true), isActive: $shouldNavigateToSontentView)
                    .hidden()
            }
        }
    }
    func playBUDataSound() {
            do {
                buAudioPlayer = try AVAudioPlayer(data: buData)
                buAudioPlayer?.numberOfLoops = 0 // Play once
                buAudioPlayer?.volume = 0.5 // Adjust volume
                buAudioPlayer?.prepareToPlay()
                buAudioPlayer?.play()
            } catch {
                print("BU音の再生に失敗しました: \(error.localizedDescription)")
            }
        }
}

struct TeachView: View {
    @State private var audioPlayer: AVAudioPlayer?
    let cymbalData = NSDataAsset(name:"Trick_style")!.data
    let buData = NSDataAsset(name:"bu")!.data
    @Binding var buAudioPlayer:AVAudioPlayer?
    @State private var gameIsOver = false // ゲームオーバー状態を管理
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("myedit")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                VStack {
                    
                    NavigationLink(destination: A1View().navigationBarBackButtonHidden(true)) {
                        Text("解説")
                            .frame(width: 140, height: 140)
                            .font(.system(size: 24.0))
                            .foregroundColor(Color.black)
                    }
                    .navigationBarTitle("", displayMode: .inline)
                }
            }
        }
        .onAppear {
            buAudioPlayer?.stop()
            playBackgroundMusic()
        }
        .onChange(of: gameIsOver) { isOver in
            if isOver {
                stopBackgroundMusic()
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("GameOverNotification"), object: nil, queue: .main) { _ in
            stopBackgroundMusic()
            }
        }
    }
    
    func playBackgroundMusic() {
        do {
            audioPlayer = try AVAudioPlayer(data: cymbalData)
            audioPlayer?.numberOfLoops = -1 // 無限ループ
            audioPlayer?.volume = 0.1 // 音量を調整（0.0から1.0の範囲で）
            audioPlayer?.prepareToPlay() // 音楽ファイルをロードして準備
            audioPlayer?.play() // 音楽を再生
        } catch {
            print("音楽の再生に失敗しました: \(error.localizedDescription)")
        }
    }
    func stopBackgroundMusic() {
        print("Stopping background music")
        audioPlayer?.stop() // 音楽を停止
    }
    
    // ゲームオーバー条件が満たされたときに呼び出す関数
    func gameOver() {
        gameIsOver = true
    }
    
    
    struct A1View: View {
        var body: some View {
            ZStack{
                Image("myedit")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                VStack {
                    Text("箱").font(.system(size:80))
                    Text("型").font(.system(size:80))
                    Text("前").font(.system(size:80))
                    HStack{
                        Text(" ").font(.system(size:60))
                        Text("は").font(.system(size:40))
                        Text(" ").font(.system(size:40))}
                        Text("それでは解説です.まず第１問.この\n問題は漢字をひらがなにする必要\nがありました.\n　　　　　　　はこ\n　　　　　　　かた\n　　　　　　　まえ\n　　　　　　　　は\n右上から読むとこたえははかま.\n答えは袴になります.").font(.system(size:21))
                    NavigationLink(destination: A2View().navigationBarBackButtonHidden(true)) {
                        Text("次へ")
                            .frame(width: 140, height: 140)
                            .font(.system(size: 24.0))
                            .foregroundColor(Color.black)
                    }
                    .navigationBarTitle("", displayMode: .inline)}}
            }
        }
    
    struct A2View: View {
        var body: some View {
            ZStack{
                Image("myedit")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                VStack {
                    HStack{
                        Text("oner = ").font(.system(.title, design: .serif))
                        Text("r").font(.system(size:34))
                        
                    }
                    HStack{
                        Text("tent = ").font(.system(.title, design: .serif))
                        Text("t").font(.system(size:34))
                    }
                    HStack{
                        Text("height = ").font(.system(.title, design: .serif))
                        Text("？").font(.system(size:34))}
                    Text("？には何が入る").font(.system(size: 30.0)).padding(5)
                        Text(" ").font(.system(size:40))
                        Text("第２問目です.左の明朝体で書かれ\nた英単語には数字が含まれていま\nす.その数字を取り除いたローマ字\nがイコールで繋がれています.よっ\nて答えはeightを取り除いてhにな\nります.").font(.system(size:21))
                    NavigationLink(destination: A3View().navigationBarBackButtonHidden(true)) {
                        Text("次へ")
                            .frame(width: 140, height: 140)
                            .font(.system(size: 24.0))
                            .foregroundColor(Color.black)
                    }
                    .navigationBarTitle("", displayMode: .inline)}}
            }
        }
    
    struct A3View: View {
        var body: some View {
            ZStack{
                Image("myedit")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                VStack {
                    HStack{
                        Text("⑥③②⑤⑥ = ちょうちょ").font(.system(.title, design: .serif))
                        
                    }
                    HStack{
                        Text("②④⑥② = さんかく").font(.system(.title, design: .serif)).padding(5)}
                    HStack{
                        Text("①③⑥②⑤① = ？").font(.system(.title, design: .serif)).padding(5)}
                    Text("？には何が入る").font(.system(size: 30.0)).padding(5)
                    Text(" ").font(.system(size:40))
                Text("第３問目です.まるで括られた\n数字は問題移動のボタンを表\nしていました.⑥③②⑤⑥のボタ\nンを繋ぐとちょうちょのような\n形になります.\n同様に①③⑥②⑤①を繋ぐと星\n形になります.よって答えはほ\nしになります.").font(.system(size:21))
                    NavigationLink(destination: A4View().navigationBarBackButtonHidden(true)) {
                        Text("次へ")
                            .frame(width: 140, height: 140)
                            .font(.system(size: 24.0))
                            .foregroundColor(Color.black)
                    }
                    .navigationBarTitle("", displayMode: .inline)}
        }
            }
        }
    
    struct A4View: View {
        var body: some View {
            ZStack{
                Image("myedit")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                VStack {
                    Text("-1/4×2/3×1/3+1/2").font(.system(size:40))
                    Text("                 ＝負け方").font(.system(size:40))
                    Text(" ")
                    Text("-3/4×1/3-1/4=?").font(.system(size:40))
                    Text(" ")
                    Text("?には何が入る").font(.system(size:30))
                    Text(" ").font(.system(size:40))
                    Text("第４問です.一見数式に見える問題\nですが,実は記号とその記号の何文\n字目かを分数で表していました.\n１文目はマイナスの１文字目,かけ\nるの2文字目,かけるの1文字目,たす\nの１文字目を取ってきて,負け方と\nなります.２つ目の式も同様に行う\nと答えは仲間になります.").font(.system(size:21))
                    NavigationLink(destination: A5View().navigationBarBackButtonHidden(true)) {
                        Text("次へ")
                            .frame(width: 140, height: 140)
                            .font(.system(size: 24.0))
                            .foregroundColor(Color.black)
                    }
                    .navigationBarTitle("", displayMode: .inline)}
                
            }
        }
    }
    
    struct A5View: View {
        var body: some View {
            ZStack{
                Image("myedit")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                VStack {
                    Group{
                        Text("革").font(.system(size: 30.0))
                        Text("↑").font(.system(size: 30.0))
                        HStack{
                            Text("心").font(.system(size: 30.0))
                            Text("←").font(.system(size: 30.0))
                            Text("A").font(.system(size: 30.0))
                            Text("→").font(.system(size: 30.0))
                            Text("変").font(.system(size: 30.0))
                        }
                        
                        HStack{
                            Text("↓").font(.system(size: 30.0))}
                        Text("名").font(.system(size: 30.0))
                        Text(" ").font(.system(size: 30.0))
                        Text("竹").font(.system(size: 30.0))
                        Text("↓").font(.system(size: 30.0))
                        HStack{
                            Text("工").font(.system(size: 30.0))
                            Text("→").font(.system(size: 30.0))
                            Text("B").font(.system(size: 30.0))
                            Text("←").font(.system(size: 30.0))
                            Text("凡").font(.system(size: 30.0))
                        }
                            Text("↑").font(.system(size: 30.0))
                        
                        
                    }
                        Text("木").font(.system(size:30.0))
                        Text(" ").font(.system(size: 5.0))
                        Text("ABが表す熟語は？").font(.system(size:30.0))
                    Text(" ").font(.system(size: 5.0))
                Text("第５問目です. Aは普通の和同開珎\nで改が当てはまります.Bは矢印の\n方向に漢字を合体させると築とい\nう漢字ができます.よって答えは改\n築になります.").font(.system(size:21))
                    NavigationLink(destination: A6View().navigationBarBackButtonHidden(true)) {
                        Text("次へ")
                            .frame(width: 140, height: 140)
                            .font(.system(size: 24.0))
                            .foregroundColor(Color.black)
                    }
                    .navigationBarTitle("", displayMode: .inline)}}
            }
        }
    struct A6View: View {
        var body: some View {
            ZStack{
                Image("myedit")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                VStack {
                    Text("り = N").font(.system(size: 34.0)).padding(5)
                    Text("１ = E").font(.system(size: 34.0)).padding(5)
                    Text("と = W").font(.system(size: 34.0)).padding(5)
                    Text("４ = ?").font(.system(size: 34.0)).padding(5)
                    Text("？には何が入る").font(.system(size: 30.0)).padding(5)
                    Text(" ").font(.system(size: 5.0))
                Text("6問目です.これは⑥に対して左\n側の文字がどこにあるかを示し\nていました.りは残り時間のり\nを表しており,⑥から見てN(No\nrth)の方向にあることを示して\nいます.同様に１はE(East)の方向,\nとは少し難しいですが、前の画\n面のとを表しており,４は今まで\nの方向を参考にするとS(South)\nの方向に存在します.よって答え\nはSになります.").font(.system(size:21))
                    NavigationLink(destination: A71View().navigationBarBackButtonHidden(true)) {
                        Text("次へ")
                            .frame(width: 140, height: 140)
                            .font(.system(size: 24.0))
                            .foregroundColor(Color.black)
                    }
                    .navigationBarTitle("", displayMode: .inline)}
        }
            }
        }
    struct A71View: View {
        var body: some View {
            ZStack{
                Image("myedit")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                VStack {
                    Text("タイトルー間充52＝？？")
                        .font(.title)
                        .padding()
                    Text("始まりー①③⑥②⑤①＝？")
                        .font(.title)
                        .padding()
                    Text("？？？に入る3文字は？")
                        .font(.title)
                    Text(" ").font(.system(size: 30.0))
                Text("最終問題です.解けたでしょうか？\nそもそも到達できたでしょうか？\nまず,1行目の間充52は残り時間の\n間,充は充電口,5,2は⑤,②を表して\nおり,6問目と同様に考えるとNSW\nEと変換できます.2行目の①③⑥②\n⑤①は３問目同様に考えるとほし\nになります.そしてタイトルと始ま\nりは最初のページのSEVEN ANSW\nERとstartを表していました.").font(.system(size:21))
                    NavigationLink(destination: A72View().navigationBarBackButtonHidden(true)) {
                        Text("次へ")
                            .frame(width: 140, height: 140)
                            .font(.system(size: 24.0))
                            .foregroundColor(Color.black)
                    }
                    .navigationBarTitle("", displayMode: .inline)}
        }
            }
        }
    struct A72View: View {
        var body: some View {
            ZStack{
                Image("myedit")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                VStack {
                    Text("SEVEN ANSWER").font(.system(.title, design: .serif))
                    Text("start")
                        .font(.title)
                        .padding()

                    Text(" ").font(.system(size: 30.0))
                Text("ここでSEVEN ANSWERは２問目\nと同様の字体で書かれていた事\nに気づけたでしょうか？２問目\nは明朝体で書かれていた場合,数\n字を取り除くというルールがあ\nりました.そのルールを適用する\nとANSWERとなります.よって\nANSWER-NSWE=AR\nSTART-STAR=T\nとなり,答えはARTとなります").font(.system(size:21))
                    NavigationLink(destination: A8View().navigationBarBackButtonHidden(true)) {
                        Text("終了")
                            .frame(width: 140, height: 140)
                            .font(.system(size: 24.0))
                            .foregroundColor(Color.black)
                    }
                    .navigationBarTitle("", displayMode: .inline)}
        }
            }
        }
    struct A8View: View {
        @State private var buAudioPlayer: AVAudioPlayer?
        var body: some View {
            ZStack{Image("myedit")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                VStack {
                    Text("To be continued...")
                        .font(.title)
                    
                    // Trigger the game over logic when this view appears
                        .onAppear {
                            // Send a notification to stop background music
                            NotificationCenter.default.post(name: NSNotification.Name("GameOverNotification"), object: nil)
                            
                        }
                    NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                        Text("タイトルに戻る")
                            .font(.system(size: 24.0))
                            .foregroundColor(Color.black)
                    }
                    .navigationBarTitle("", displayMode: .inline)
                }
            }
        }}
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
