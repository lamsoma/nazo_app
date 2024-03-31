//
//  q1.swift
//  nazo1
//
//  Created by satosoma on 2023/09/05.
//

import SwiftUI

struct q1: View {
    @State private var textInput: String = ""
    @State private var isCorrect: Bool = false // 正解かどうかを管理する状態変数

    
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
                TextField("テキストを入力してください", text: $textInput, onCommit: {
                    // テキストが確定（Enterキーが押された）ときに実行される処理
                    if textInput == "はかま" || textInput == "袴" {
                        isCorrect = true // 正解の場合、isCorrectをtrueに設定
                    }
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                if isCorrect {
                    Text("正解") // 正解の場合に表示
                        .font(.headline)
                        .padding()
                }
                
            }
        }
    }
}

struct q1_Previews: PreviewProvider {
    static var previews: some View {
        q1()
    }
}
