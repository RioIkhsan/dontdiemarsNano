//
//  LosingAScene.swift
//  dontdieinmarsNano
//
//
//  Created by Tania Cresentia on 29/04/24.
//

import Foundation
import SpriteKit
import AVFoundation

class LosingAScene: SKScene {
    
    private var backgroundMusicPlayer: AVAudioPlayer!
    
    let background = SKSpriteNode(imageNamed: "bg-clean-of-dust")
    let liquid1 = SKSpriteNode(imageNamed: "liquid1")
    let liquid2 = SKSpriteNode(imageNamed: "liquid2")
    let liquid3 = SKSpriteNode(imageNamed: "liquid3")
    let liquid4 = SKSpriteNode(imageNamed: "liquid4")
    let liquid5 = SKSpriteNode(imageNamed: "liquid5")
    let ghost = SKSpriteNode(imageNamed: "ghost")
    
    func createFadeInSequence(waitDuration: TimeInterval, fadeInDuration: TimeInterval) -> SKAction {
        let fadeInAction = SKAction.fadeIn(withDuration: fadeInDuration)
        let waitAction = SKAction.wait(forDuration: waitDuration)
        let fadeInSequence = SKAction.sequence([waitAction, fadeInAction])
        return fadeInSequence
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .red
        setUpBgm()
        
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 1
        addChild(background)

        liquid1.position = CGPoint(x: 0, y: size.height)
        liquid1.size = CGSize(width: 800, height: 800)
        liquid1.zPosition = 2
        liquid1.alpha = 0
        addChild(liquid1)

        liquid2.position = CGPoint(x: size.width, y: size.height)
        liquid2.size = CGSize(width: 800, height: 800)
        liquid2.zPosition = 2
        liquid2.alpha = 0
        addChild(liquid2)

        liquid3.position = CGPoint(x: size.width, y: 0)
        liquid3.size = CGSize(width: 600, height: 600)
        liquid3.zPosition = 2
        liquid3.alpha = 0
        addChild(liquid3)
        
        liquid4.position = CGPoint(x: size.width/2, y: size.height/2)
        liquid4.size = CGSize(width: 600, height: 600)
        liquid4.zPosition = 2
        liquid4.alpha = 0
        addChild(liquid4)

        liquid5.position = CGPoint(x: 0, y: 0)
        liquid5.size = CGSize(width: 800, height: 800)
        liquid5.zPosition = 2
        liquid5.alpha = 0
        addChild(liquid5)
        
        ghost.size = CGSize(width: 200, height: 200)
        ghost.position = CGPoint(x: size.width / 2, y: 0)
        ghost.zPosition = 2
        ghost.alpha = 0
        addChild(ghost)
        
        let waitAction = SKAction.wait(forDuration: 2)
        let fadeInAction = SKAction.fadeIn(withDuration: 2)
        let moveAction = SKAction.move(to: CGPoint(x: size.width / 2, y: size.height+100), duration: 2)
        let fadeOutAction = SKAction.fadeOut(withDuration: 1)
        let groupAction = SKAction.group([fadeInAction, moveAction])
        let fullSequence = SKAction.sequence([waitAction, groupAction ,fadeOutAction])


        liquid1.run(createFadeInSequence(waitDuration: 1/2, fadeInDuration: 2/2))
        liquid2.run(createFadeInSequence(waitDuration: 0/2, fadeInDuration: 2/2))
        liquid3.run(createFadeInSequence(waitDuration: 2/2, fadeInDuration: 2/2))
        liquid4.run(createFadeInSequence(waitDuration: 0/2, fadeInDuration: 2/2))
        liquid5.run(createFadeInSequence(waitDuration: 2/2, fadeInDuration: 2/2))
        ghost.run(fullSequence)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if (liquid5.contains(location) || liquid4.contains(location) || liquid3.contains(location) || liquid2.contains(location) || liquid1.contains(location)) {
                let game = TransitionDustScene(size: self.size)
                let transition = SKTransition.fade(with: .black, duration: 3)
                
                self.view?.presentScene(game, transition: transition)
            }
        }
    }
    
    func setUpBgm(){
        // Load and play background music
        if let musicURL = Bundle.main.url(forResource: "heartbeat-deathscene", withExtension: "mp3") {
            print("masuk if {}")
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: musicURL)
                
                playAudioWithDelay(delay: 0.2)
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
