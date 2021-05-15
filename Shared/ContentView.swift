//
//  ContentView.swift
//  Shared
//
//  Created by Abdul Hakim on 14/05/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 11")
           
        }
    }
}


struct Home: View {
//    Liqued swipe offset
    @State var offset: CGSize = .zero
    @State var showHome = false
    
    var body: some View {
        ZStack{
            Color("bg")
                .overlay(
                    VStack(alignment: .leading, spacing: 10, content: {
                        Text("For Gaming")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                        
                            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore")
                                .font(.caption)
                                .fontWeight(.bold)
                    })
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                )
                .clipShape(LiquidSwipe(offset: offset))
                .ignoresSafeArea()
                .overlay(
                    Image(systemName: "chevron.left")
                        .font(.largeTitle)
//                        For Draggesture
                        .frame(width: 50, height: 50)
                        .contentShape(Rectangle())
                        .gesture(DragGesture().onChanged({ (value) in
                          
//                            Animating swipeoffset
                            withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.6, blendDuration: 0.6)){
                                offset = value.translation
                            }
                        }).onEnded({ (value) in
                            
                            let screen  = UIScreen.main.bounds
                            
                            if -offset.width > screen.width / 2{
                                offset.width = -screen.height
                            }
                            withAnimation(.spring()){
                                if -offset.width > screen.width / 2{
                                    offset.width = -screen.height
                                    showHome.toggle()
                                }
                                else{
                                    offset = .zero
                                }
                            }
                        })
                        )
                        .offset(x: 15, y: 58)
                        .opacity(offset == .zero ? 1 : 0)

                    ,alignment: .topTrailing
                )
                .padding(.trailing)
            
            if showHome{
                Text("Wellcome Home !!!")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .onTapGesture {
                    withAnimation(.spring()){
                        offset = .zero
                        showHome.toggle()
                    }
                }
            }
        }
    }
}


// Custom Shape

struct LiquidSwipe: Shape {
    
//    getting offset value
    var offset: CGSize
    
    func path(in rect: CGRect) -> Path {
        return Path{path in
            
//            when user move left, increase size both in top and bottom
//            and viola
            let width = rect.width + (-offset.width > 0 ? offset.width : 0)
            
//            First constructing recatngle shape
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height ))
            
//            Now constructing curve shape
//            From
            let from = 80 + (offset.width)
            path.move(to: CGPoint(x: rect.width , y:  from > 80 ? 80 : from))
//            To
            var to = 180 + (offset.height) + (-offset.width)
            to = to < 180 ? 180 : to


            let mid: CGFloat = 80 + ((180 - 80) / 2)
            
            path.addCurve(to: CGPoint(x: rect.width, y: to), control1: CGPoint(x: width - 50, y: mid), control2: CGPoint(x: width - 50, y: mid))
        }
    }
}
