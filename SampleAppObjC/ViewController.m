//
//  ViewController.m
//  SampleAppObjC
//
//  Created by Andi Wilson on 3/18/20.
//  Copyright © 2020 Promethean TV. All rights reserved.
//

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"
#import "PTVSDK/PTVSDK-Swift.h"

static NSString * const SampleChannelId = @"5c701be7dc3d20080e4092f4";
static NSString * const SampleStreamId = @"5de7e7c2a6adde5211684519";
static NSString * const SampleVideoUrl = @"https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSURL *videoUrl = [NSURL URLWithString:SampleVideoUrl];
  AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:videoUrl];
  
  player = [AVPlayer playerWithPlayerItem:item];
 
  playerViewController = [AVPlayerViewController new];
  playerViewController.player = player;
  playerViewController.showsPlaybackControls = YES;
  playerViewController.view.frame = self.view.frame;
  
  [self addChildViewController:playerViewController];
  [self.view addSubview:playerViewController.view];
  
  // Add player observers.
  [PTVSDK monitorAVPlayerWithPlayer: player];
  
  // Attach config ready callback handler to use
  // stream sources paired in Broadcast Center.
  PTVSDK.onConfigReady = ^(PTVSDKConfigData *configData) {
    // Load first playable source from array.
    for (PTVSDKStreamSource* source in configData.sources) {
      if ([AVAsset assetWithURL:source.url].isPlayable) {
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:source.url];
        [self->player replaceCurrentItemWithPlayerItem:item];
        break;
      }
    }
  };
  
  // Create overlay data object.
  PTVSDKOverlayData *overlayData = [[PTVSDKOverlayData alloc]
                                    initWithChannelId:SampleChannelId
                                    streamId:SampleStreamId];
  
  // Add overlays to player view.
  [PTVSDK addOverlaysToPlayerViewWithPlayerView:playerViewController.view
                                    overlayData: overlayData];
}


@end
