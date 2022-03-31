//
//  SnapCarousel.swift
//  CarouselSlider
//
//  Created by 张亚飞 on 2022/3/31.
//

import SwiftUI

//Tp for Accepting List....
struct SnapCarousel<Content: View, T: Identifiable>: View {
    
    var  content:(T) -> Content
    var  list : [T]
    
    //properties
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    
    init(spacing: CGFloat = 15, trailingSpace: CGFloat = 100, index: Binding<Int>, items:[T], @ViewBuilder content: @escaping (T) -> Content){
        
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }
    
    // offset ....
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    var body: some View {
        
        
        GeometryReader { proxy in
            
            // setting correct width for snap carousel....
            
            // on sided snap caorusel
            let width = proxy.size.width - (trailingSpace - spacing)
            let adjustMentWidth = (trailingSpace / 2) - spacing
            
            HStack(spacing: spacing) {
                
                ForEach(list){item in
                    
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                }
            }
            //spacing will be horizontal padding....
            .padding(.horizontal, spacing)
            // setting only after oth index...
            .offset(x: (CGFloat(currentIndex) * -width) + (currentIndex != 0 ? adjustMentWidth : 0) + offset)
            .gesture(
            
                DragGesture()
                    .updating($offset, body: { value, out, _ in
                        
                        out = value.translation.width
                    })
                    .onEnded({ value in
                        
                        // updating current index...
                        let offsetX = value.translation.width
                        
                        //were going to convert the tranlastion into progress(0- 1)
                        //and round the value....
                        //based on the progress increasing or decreasing the currentIndex.
                        
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        
                        currentIndex = index
                    })
                    .onChanged({ value in
                        
                        //updating only index...
                        
                        // updating current index...
                        let offsetX = value.translation.width
                        
                        //were going to convert the tranlastion into progress(0- 1)
                        //and round the value....
                        //based on the progress increasing or decreasing the currentIndex.
                        
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        
                        index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                    })
            )
        }
        //Animating when offset = 0
        .animation(.easeInOut, value: offset == 0)
    }
}

struct SnapCarousel_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
