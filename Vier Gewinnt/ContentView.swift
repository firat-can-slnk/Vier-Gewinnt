//
//  ContentView.swift
//  Vier Gewinnt
//
//  Created by Firat Sülünkü on 01.02.22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var gameField = GameModel().gameField
    
    var body: some View {
        ScrollView
        {
            VStack
            {
                gamefieldView
                playerMoveView
                winnerView
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
            if let winner = gameField.winner, winner != Player.none
            {
                stoneView(.init(player: winner))
                Text("Player \(winner.rawValue) won!")
            }
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
