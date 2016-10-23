import UIKit
import AVFoundation

class PlayerView: UIView {
    var playerItem:AVPlayerItem!
    var avplayer:AVPlayer!
    var playerLayer:AVPlayerLayer!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 检测连接是否存在 不存在报错
        guard let url = URL(string: "https://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4") else { fatalError("连接错误") }
        
        playerItem = AVPlayerItem(url: url) // 创建视频资源
        
        // 监听状态改变
        playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        
        self.avplayer = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: avplayer)
        
        
        //设置模式
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        playerLayer.contentsScale = UIScreen.main.scale
        
        self.layer.insertSublayer(playerLayer, at: 0)
    }
    
    deinit{
        playerItem.removeObserver(self, forKeyPath: "status")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = self.bounds
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let playerItem = object as? AVPlayerItem else { return }
        if keyPath == "status"{
            //            AVPlayerItemStatusUnknown,AVPlayerItemStatusReadyToPlay, AVPlayerItemStatusFailed。只有当status为AVPlayerItemStatusReadyToPlay是调用 AVPlayer的play方法视频才能播放。
            print(playerItem.status.rawValue)
            if playerItem.status == AVPlayerItemStatus.readyToPlay{
                // 只有在这个状态下才能播放
                self.avplayer.play()
            }else{
                print("加载异常")
            }
        }
    }
}
