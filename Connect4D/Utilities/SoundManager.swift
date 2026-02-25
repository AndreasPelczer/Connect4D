//
//  SoundManager.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//


import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
    func playDropSound() {
        // Erzeuge einen kurzen "Klack" per Synthese
        let sampleRate: Double = 44100
        let duration: Double = 0.08
        let frameCount = Int(sampleRate * duration)
        
        var samples = [Float](repeating: 0, count: frameCount)
        
        for i in 0..<frameCount {
            let t = Float(i) / Float(sampleRate)
            let envelope = expf(-t * 60)  // Schneller Abfall
            let frequency: Float = 800 - (t * 3000)  // Fallende Tonhöhe
            samples[i] = sinf(2 * .pi * frequency * t) * envelope * 0.5
        }
        
        // WAV-Header bauen
        let dataSize = frameCount * 2  // 16-bit samples
        var wavData = Data()
        
        // RIFF Header
        wavData.append(contentsOf: "RIFF".utf8)
        wavData.append(uint32: UInt32(36 + dataSize))
        wavData.append(contentsOf: "WAVE".utf8)
        
        // Format Chunk
        wavData.append(contentsOf: "fmt ".utf8)
        wavData.append(uint32: 16)          // Chunk size
        wavData.append(uint16: 1)           // PCM
        wavData.append(uint16: 1)           // Mono
        wavData.append(uint32: 44100)       // Sample rate
        wavData.append(uint32: 88200)       // Byte rate
        wavData.append(uint16: 2)           // Block align
        wavData.append(uint16: 16)          // Bits per sample
        
        // Data Chunk
        wavData.append(contentsOf: "data".utf8)
        wavData.append(uint32: UInt32(dataSize))
        
        for sample in samples {
            let intSample = Int16(max(-1, min(1, sample)) * Float(Int16.max))
            wavData.append(uint16: UInt16(bitPattern: intSample))
        }
        
        do {
            audioPlayer = try AVAudioPlayer(data: wavData)
            audioPlayer?.play()
        } catch {
            // Still spielen wenn Audio nicht geht
        }
    }
    
    func playWinSound() {
        let sampleRate: Double = 44100
        let duration: Double = 0.3
        let frameCount = Int(sampleRate * duration)
        
        var samples = [Float](repeating: 0, count: frameCount)
        
        for i in 0..<frameCount {
            let t = Float(i) / Float(sampleRate)
            let envelope = expf(-t * 8)
            // Zwei Töne: Aufsteigende Quinte
            let tone1 = sinf(2 * .pi * 523.25 * t)  // C5
            let tone2 = sinf(2 * .pi * 783.99 * t)  // G5
            let mix = (t < 0.15) ? tone1 : tone2
            samples[i] = mix * envelope * 0.4
        }
        
        var wavData = Data()
        wavData.append(contentsOf: "RIFF".utf8)
        let dataSize = frameCount * 2
        wavData.append(uint32: UInt32(36 + dataSize))
        wavData.append(contentsOf: "WAVE".utf8)
        wavData.append(contentsOf: "fmt ".utf8)
        wavData.append(uint32: 16)
        wavData.append(uint16: 1)
        wavData.append(uint16: 1)
        wavData.append(uint32: 44100)
        wavData.append(uint32: 88200)
        wavData.append(uint16: 2)
        wavData.append(uint16: 16)
        wavData.append(contentsOf: "data".utf8)
        wavData.append(uint32: UInt32(dataSize))
        
        for sample in samples {
            let intSample = Int16(max(-1, min(1, sample)) * Float(Int16.max))
            wavData.append(uint16: UInt16(bitPattern: intSample))
        }
        
        do {
            audioPlayer = try AVAudioPlayer(data: wavData)
            audioPlayer?.play()
        } catch {}
    }
}

// MARK: - Data Helper

private extension Data {
    mutating func append(uint32: UInt32) {
        var value = uint32.littleEndian
        append(Data(bytes: &value, count: 4))
    }
    
    mutating func append(uint16: UInt16) {
        var value = uint16.littleEndian
        append(Data(bytes: &value, count: 2))
    }
}