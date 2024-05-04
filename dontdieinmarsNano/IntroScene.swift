//
//  IntroScene.swift
//  dontdieinmarsNano
//
//  Created by Rio Ikhsan on 04/05/24.
//

import SwiftUI
import SpriteKit
import AVFoundation


class IntroScene: SKScene {
    
    var backgroundMusicPlayer: AVAudioPlayer!
    private var ufo = SKSpriteNode(imageNamed: "ufo")
    let background = SKSpriteNode(imageNamed: "bg-intro")
    var light = SKSpriteNode(imageNamed: "light-0")
    var lightTextures: [SKTexture] = []
    var astronaut = SKSpriteNode(imageNamed: "astronaut-start")
    
    
    override func didMove(to view: SKView) {
        self.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene?.scaleMode = .aspectFill
        setUpBgm()
        addBackground()
        addAnimation()
        
        // Add Astronaut
        astronaut.position = CGPoint(x: size.width/2, y: size.height/2-250)
        astronaut.zPosition = 1
        astronaut.alpha = 0
        addChild(astronaut)
    }
    
    func addBackground() {
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 1
        addChild(background)
    }
    
    func addAnimation() {
        ufo.position = CGPoint(x: 0, y: size.height)
        ufo.setScale(0.1)
        ufo.zPosition = 3
        let moveUpDown = SKAction.sequence([
            SKAction.moveBy(x: 0, y: -100, duration: 1.0),
            SKAction.moveBy(x: 0, y: 100, duration: 1.0)
        ])
        let repeatAction = SKAction.repeatForever(moveUpDown)
        
        let animateUfo = SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.move(to: CGPoint(x: size.width, y: size.height - 300), duration: 1.0),
            SKAction.move(to: CGPoint(x: size.width/2, y: size.height/2), duration: 1.0),
            repeatAction
        ])
        let scaleUfo = SKAction.scale(by: 10.0, duration: 2.5)
        
        ufo.run(animateUfo)
        ufo.run(scaleUfo)
        addChild(ufo)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if ufo.contains(location) {
                
                ufo.isPaused = true
                
                addLight()
                
                DispatchQueue.main.asyncAfter(deadline:.now() + 1.0) {
                    // Fade in the astronaut over a duration of 1 second
                    let fadeIn = SKAction.fadeIn(withDuration: 1.0)
                    self.astronaut.run(fadeIn)
                }
                
                
                DispatchQueue.main.asyncAfter(deadline:.now() + 3.5) {
                    let game = TransitionDustScene(size: self.size)
                    let transition = SKTransition.fade(with:.black, duration: 2)
                    
                    self.view?.presentScene(game, transition: transition)
                }
            }
            //            let startNode = atPoint(location)
            //
            //            if startNode.name == "ufo" {
            //                let game = GameScene(size: self.size)
            //                let transition = SKTransition.fade(with: .black, duration: 3)
            //
            //                self.view?.presentScene(game, transition: transition)
            //            }
        }
    }
    
    func addLight() {
        for i in 0...6 {
            let texture = SKTexture(imageNamed: "light-\(i)")
            lightTextures.append(texture)
        }
        
        light = SKSpriteNode(texture: lightTextures[0])
        light.position = CGPoint(x: size.width/2, y: size.height/2-300)
        light.zPosition = 2
        light.setScale(1.0)
        addChild(light)
        
        let animateLight = SKAction.animate(with: lightTextures, timePerFrame: 0.15)
        
        light.run(animateLight)
    }
    
    func setUpBgm(){
        // Load and play background music
        if let musicURL = Bundle.main.url(forResource: "space-ambient", withExtension: "mp3") {
            print("masuk if {}")
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: musicURL)
                backgroundMusicPlayer.numberOfLoops = -1 // Loop indefinitely
                playAudioWithDelay(delay: 0.5)
                
                print("masuk do {}")
            } catch {
                print("Error loading background music: \(error)")
            }
        } else {
            print("ga masuk if {}")
        }
    }
    
    // Function to play audio with delay
    func playAudioWithDelay(delay: TimeInterval) {
        // Calculate the time to play audio
        let delayTime = CACurrentMediaTime() + delay
        // Schedule playback with the calculated time
        backgroundMusicPlayer?.play(atTime: delayTime)
    }
    
}

struct IntroSceneView: UIViewRepresentable {
    func makeUIView(context: Context) -> SKView {
        let skView = SKView(frame: .zero)
        skView.presentScene(IntroScene())
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {}
}


struct IntroSceneView_Previews: PreviewProvider {
    static var previews: some View {
        IntroSceneView()
            .ignoresSafeArea()
    }
}
