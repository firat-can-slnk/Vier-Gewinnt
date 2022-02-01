//
//  ContentView.swift
//  Vier Gewinnt
//
//  Created by Firat Sülünkü on 01.02.22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var gameField = GameModel().gameField
    @State var counter: (one: Int, two: Int) = (0, 0)
    
    var body: some View {
        ScrollView
        {
            VStack
            {
                scoreBoardView
                gamefieldView
                playerMoveView
                winnerView
                restartView
            }
        }
    }
    
    var scoreBoardView: some View
    {
        VStack
        {
            Text("Scores")
            HStack
            {
                ZStack
                {
                    stoneView(.init(player: Player.one))
                        .opacity(0.5)
                    Text("\(counter.one)")
                        .font(.title3)
                        .bold()
                }
                Text(":")
                ZStack
                {
                    stoneView(.init(player: Player.two))
                        .opacity(0.5)
                    Text("\(counter.two)")
                        .font(.title3)
                        .bold()
                }
            }
        }
    }
    
    var gamefieldView: some View
    {
        HStack
        {
            ForEach(Array(zip(gameField.field.indices, gameField.field)), id: \.1.id)
            {
                i, column in
                
                VStack
                {
                    ForEach(Array(zip(column.indices, column)), id: \.1.id)
                    {
                        j, row in
                        HStack
                        {
                            Button {
                                gameField.addMove(player: gameField.playersTurn, column: i)
                                
                                if let winner = gameField.winner, !gameField.gameOver
                                {
                                    if winner == .one
                                    {
                                        counter.one += 1
                                    }
                                    else if winner == .two
                                    {
                                        counter.two += 1
                                    }
                                    else if winner == .none
                                    {
                                        counter.one += 1
                                        counter.two += 1
                                    }
                                    gameField.gameOver = true
                                }
                                
                            } label: {
                                stoneView(row)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .padding()
        .background(.indigo)
        .cornerRadius(20)
    }
    
    var playerMoveView: some View
    {
        HStack
        {
            stoneView(.init(player: gameField.playersTurn))
            Text("Player \(gameField.playersTurn.rawValue) move")
        }
    }
    
    var winnerView: some View
    {
        HStack
        {
            if let winner = gameField.winner
            {
                if winner != .none
                {
                    stoneView(.init(player: winner))
                    Text("Player \(winner.rawValue) won!")
                }
                else
                {
                    Text("Thats a tie!")
                }
            }
        }
    }
    
    var restartView: some View
    {
        Button {
            self.gameField.reset()
        } label: {
            Text("Restart")
        }

    }
    
    public func stoneView(_ stone: Stone) -> some View
    {
        let size = UIScreen.main.bounds.size.width / CGFloat(gameField.field.count) - 20
        return Circle()
            .foregroundColor(stone.color)
            .frame(width: size, height: size, alignment: .center)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
