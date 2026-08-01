//
//  ContentView.swift
//  Exploring Text Renderer
//
//  Created by jyotirmoy_halder on 1/8/26.
//

import SwiftUI

struct ContentView: View {
    @State private var blur = 1.0
    let heart = Image(systemName: "heart.fill")
    
    var helloWorld: Text {
        Text("Hello \(heart) World")
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundStyle(.red)
            .customAttribute(CustomAttr())
    }
    var body: some View {
        VStack {
            Text("Yet another \"\(helloWorld)\" example.")
                .font(.title)
                .multilineTextAlignment(.center)
                .textRenderer(Renderer(blur: blur))
            
            Spacer()
            
            Slider(value: $blur, in: 0...10)
        }
        .padding()
    }
}

struct Renderer: TextRenderer {
    let blur: CGFloat
    
    func draw(layout: Text.Layout, in ctx: inout GraphicsContext) {
        let allLines = layout
            .flatMap({ $0 })
        
        for line in allLines {
            // Extract custom attribute text
            if line[CustomAttr.self] != nil {
                var localContext = ctx
                
                let blurFilter = GraphicsContext.Filter.blur(radius: blur)
                
                localContext
                    .addFilter(blurFilter)
                
                localContext.draw(line)
            } else {
                let localContext = ctx
                localContext.draw(line)
            }
        }
    }
}

struct CustomAttr: TextAttribute {
    // Additional Properties
    
}

#Preview {
    ContentView()
}
