#import "SBMediaController.h"
#import "SBIconController.h"
#import "SBIconModel.h"
//#import "MPAVController.h"
#import <MediaPlayer/MPMusicPlayerController.h>
#import <Foundation/Foundation.h>

@interface SpringBoard : UIApplication 
-(void)applicationOpenURL:(NSURL *)url;
@end


@interface SBIcon : UIView
-(id)generateIconImage:(int)image;
- (void)updateIcon;
-(void)longPressTimerFired;
@end

@interface SBApplicationIcon : SBIcon
-(id)displayName;
-(BOOL)isInDock;
@end

@interface SBIconList
-(BOOL)containsIcon:(SBIcon *)icon;
@end



@interface NSObject (GAH)
-(BOOL)containsIcon:(id)idcon;
@end

//@interface SBControlPlayPause : SBApplicationIcon
//@end 

@interface SBIconImageView {
	UIImage *image;
}
-(void)setImage:(id)image;
@end

@interface SBIconLabel
- (void)setText:(id)text;
@end

@interface SBIconViewMap
+(SBIconViewMap*)homescreenMap;
-(SBIcon*)mappedIconViewForIcon:(SBIcon*)icon;
@end


//NSDictionary *&_nowPlayingInfo = (MSHookIvar<NSDictionary *>(controller, "_nowPlayingInfo"));
//image = [UIImage imageWithData:[_nowPlayingInfo valueForKey:@"artworkData"]];

static BOOL held = NO;
static BOOL nextPrevOpen = NO;
static BOOL invertPlayPause = NO;
static BOOL isSeeking = NO;
static BOOL isMuted = NO;
NSTimer *timer;

%subclass SBControlPlayPause : SBApplicationIcon <UIAlertViewDelegate>

-(BOOL)isInDock {
	return false;
}

-(void)setInDock:(BOOL)dock {}

- (void)launch {
    if (![[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/HomeScreenMusic/note.txt"]) {
	UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Instructions" message:@"Instructions for use:\n1. To play and pause, tap the icon once.\n2. To show/hide the song control buttons, tap and hold the icon.\n3. To move the icon around, tap and hold any other app, then move this icon as you please.\n\n This app was brought to you 100% free. If you enjoy using this tweak please take a moment to follow the developers, @iPodUplink, on Twitter. \nThis message will not be shown again. All of this information can be found at http://jailbreaknation.com/HomeScreenMusic. If you want to review this tweak please link to that page.\n\nBig thanks to DHowett, rpetrich, TheZimm, conradev, and everyone else who helped me make this!" delegate:self cancelButtonTitle:@"Follow" otherButtonTitles: @"Dismiss", nil];
	[a show];
	return;
    }
    if (held) {
		held = NO;
		return;
	}
    SBMediaController *controller = [%c(SBMediaController) sharedInstance];
    [controller togglePlayPause];
}

%new(v@:@i)

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		if ([((SpringBoard *)[UIApplication sharedApplication]) canOpenURL:[NSURL URLWithString:@"tweetie://user?screen_name=ipoduplink"]]) {
			[((SpringBoard *)[UIApplication sharedApplication]) applicationOpenURL:[NSURL URLWithString:@"tweetie://user?screen_name=ipoduplink"]];
		}
		else {
			[((SpringBoard *)[UIApplication sharedApplication]) applicationOpenURL:[NSURL URLWithString:@"http://twitter.com/ipoduplink"]];
		}
	}
	NSString *s = @"Instructions for use:\n1. To play and pause, tap the icon once.\n2. To show/hide the song control buttons, tap and hold the icon.\n3. To move the icon around, tap and hold any other app, then move this icon as you please.\n\n This app was brought to you 100% free. If you enjoy using this tweak please take a moment to follow the developers, @iPodUplink, on Twitter, or like us on Facebook.";
	if (![[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/HomeScreenMusic"]) [[NSFileManager defaultManager] createDirectoryAtPath:@"/var/mobile/Library/HomeScreenMusic" withIntermediateDirectories:YES attributes:nil error:nil];
	[s writeToFile:@"/var/mobile/Library/HomeScreenMusic/note.txt" atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

%new(v@:@i)

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		if ([((SpringBoard *)[UIApplication sharedApplication]) canOpenURL:[NSURL URLWithString:@"tweetie://user?screen_name=ipoduplink"]]) {
			[((SpringBoard *)[UIApplication sharedApplication]) applicationOpenURL:[NSURL URLWithString:@"tweetie://user?screen_name=ipoduplink"]];
		}
		else {
			[((SpringBoard *)[UIApplication sharedApplication]) applicationOpenURL:[NSURL URLWithString:@"http://twitter.com/ipoduplink"]];
		}
	}
	NSString *s = @"Instructions for use:\n1. To play and pause, tap the icon once.\n2. To show/hide the song control buttons, tap and hold the icon.\n3. To move the icon around, tap and hold any other app, then move this icon as you please.\n\n This app was brought to you 100% free. If you enjoy using this tweak please take a moment to follow the developers, @iPodUplink, on Twitter, or like us on Facebook.";
	if (![[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/HomeScreenMusic"]) [[NSFileManager defaultManager] createDirectoryAtPath:@"/var/mobile/Library/HomeScreenMusic" withIntermediateDirectories:YES attributes:nil error:nil];
	[s writeToFile:@"/var/mobile/Library/HomeScreenMusic/note.txt" atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

%new(v@:@i)

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		if ([((SpringBoard *)[UIApplication sharedApplication]) canOpenURL:[NSURL URLWithString:@"tweetie://user?screen_name=ipoduplink"]]) {
			[((SpringBoard *)[UIApplication sharedApplication]) applicationOpenURL:[NSURL URLWithString:@"tweetie://user?screen_name=ipoduplink"]];
		}
		else {
			[((SpringBoard *)[UIApplication sharedApplication]) applicationOpenURL:[NSURL URLWithString:@"http://twitter.com/ipoduplink"]];
		}
	}
	NSString *s = @"Instructions for use:\n1. To play and pause, tap the icon once.\n2. To show/hide the song control buttons, tap and hold the icon.\n3. To move the icon around, tap and hold any other app, then move this icon as you please.\n\n This app was brought to you 100% free. If you enjoy using this tweak please take a moment to follow the developers, @iPodUplink, on Twitter, or like us on Facebook.";
	if (![[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/HomeScreenMusic"]) [[NSFileManager defaultManager] createDirectoryAtPath:@"/var/mobile/Library/HomeScreenMusic" withIntermediateDirectories:YES attributes:nil error:nil];
	[s writeToFile:@"/var/mobile/Library/HomeScreenMusic/note.txt" atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(id)displayName {
	SBMediaController *controller = [%c(SBMediaController) sharedInstance];
	if (invertPlayPause) {
		if ([controller isPlaying])  {
            		return @"Play";
		}
		return (NSString *) [controller nowPlayingTitle];
		invertPlayPause = NO;
	}
	if (![controller isPlaying])  {
		return @"Play";
	}
	return (NSString *) [controller nowPlayingTitle];
}

-(void)longPressTimerFired
{
	if (![[%c(SBIconController) sharedInstance] isEditing])  {
		nextPrevOpen = !nextPrevOpen;
		if (nextPrevOpen) {
			UIButton *forward = [UIButton buttonWithType:UIButtonTypeCustom];
			[forward setFrame:CGRectMake([self frame].origin.x+[self frame].size.width-51, [self frame].origin.y+5, 51, 51)];
			[forward setBackgroundImage:[UIImage imageWithContentsOfFile:@"/Applications/SBControlsPlayPause.app/next@2x.png"] forState:UIControlStateNormal];
			[forward addTarget:(SBControlPlayPause *)self action:@selector(changeSong:) forControlEvents:(UIControlEventTouchUpInside)];
            [forward addTarget:self action:@selector(changeSongPressedDown:) forControlEvents:UIControlEventTouchDown];
			[forward setAlpha:0.0];
			[forward setTag:12345];
			[forward setBackgroundColor:[UIColor clearColor]];
			[[self superview] addSubview:forward];
			[UIView transitionWithView:forward
        	        	  duration:0.5f 
        	        	   options:UIViewAnimationCurveEaseInOut
        	        	animations:^(void) {
                            [forward setAlpha:1.0];
                            [forward setFrame:CGRectMake([forward frame].origin.x+45, [forward frame].origin.y, [forward frame].size.width, [forward frame].size.height)];
        	        	} 
        	        	completion:^(BOOL finished) {
        	        	     // Do nothing
        	        	}]; 
			
			UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
			[back setFrame:CGRectMake([self frame].origin.x, [self frame].origin.y+5, 51, 51)];
			[back setBackgroundImage:[UIImage imageWithContentsOfFile:@"/Applications/SBControlsPlayPause.app/previous@2x.png"] forState:UIControlStateNormal];
			[back addTarget:(SBControlPlayPause *)self action:@selector(changeSong:) forControlEvents:(UIControlEventTouchUpInside)];
            [back addTarget:self action:@selector(changeSongPressedDown:) forControlEvents:UIControlEventTouchDown];
			[back setAlpha:0.0];
			[back setTag:12346];
			[back setBackgroundColor:[UIColor clearColor]];
			[[self superview] addSubview:back];
			[UIView transitionWithView:back
        	        	  duration:0.5f 
               		 	   options:UIViewAnimationCurveEaseInOut
                		animations:^(void) {
                            [back setAlpha:1.0];
                            [back setFrame:CGRectMake([back frame].origin.x-45, [back frame].origin.y, [back frame].size.width, [back frame].size.height)];
                		} 
                		completion:^(BOOL finished) {

                		}];
			CGRect frame = CGRectMake([self frame].origin.x+20, [self frame].origin.y+20, 10.0, 10.0);
			UISlider *slider = [[UISlider alloc] initWithFrame:frame];
			[slider addTarget:self action:@selector(volumeChanged:) forControlEvents:UIControlEventValueChanged];
			[slider setBackgroundColor:[UIColor clearColor]];
			[slider setMinimumValue:0.0];
			[slider setMaximumValue:1.0];
			[slider setContinuous:YES];
			[slider setValue:0.5]; 
            [slider setAlpha:0.0];
			[slider setTag:12347];
			[[self superview] addSubview:slider];
			[UIView transitionWithView:slider
        	        	  duration:0.5f 
               		 	   options:UIViewAnimationCurveEaseInOut
                		animations:^(void) {
                            [slider setAlpha:1.0];
                            [slider setFrame:CGRectMake([slider frame].origin.x-65, [slider frame].origin.y+31, [slider frame].size.width+140, [slider frame].size.height)];
                		} 
                		completion:^(BOOL finished) {
                		     [slider setValue:[[%c(MPMusicPlayerController) iPodMusicPlayer] volume] animated:YES];
                		}];
		}	
		else {
			for (UIView *v in [self superview].subviews) {
				if ([v tag] == 12346) {
					[UIView transitionWithView:v
        	        	  		duration:0.5f 
        	        	   		options:UIViewAnimationCurveEaseInOut
        	        			animations:^(void) {
                                        [v setAlpha:0.0];
        	        	     			[v setFrame:CGRectMake([self frame].origin.x, [self frame].origin.y+5, 51, 51)];
        	        			} 
        	        			completion:^(BOOL finished) {
        	        	     			[v removeFromSuperview];
        	        			}];
				}
				else if ([v tag] == 12345) {
					[UIView transitionWithView:v
        	        	  		duration:0.5f 
        	        	   		options:UIViewAnimationCurveEaseInOut
        	        			animations:^(void) {
                                        [v setAlpha:0.0];
        	        	     			[v setFrame:CGRectMake([self frame].origin.x+[self frame].size.width-51, [self frame].origin.y+5, 51, 51)];
        	        			} 
       		         			completion:^(BOOL finished) {
        	        	     			[v removeFromSuperview];
        	        			}];
				}
				else if ([v tag] == 12347) {
					[UIView transitionWithView:v
        	        	  		duration:0.5f 
        	        	   		options:UIViewAnimationCurveEaseInOut
        	        			animations:^(void) {
                                        [v setAlpha:0.0];
        	        	     			[v setFrame:CGRectMake([self frame].origin.x+20, [self frame].origin.y+20, 10.0, 10.0)];
        	        			} 
       		         			completion:^(BOOL finished) {
        	        	     			[v removeFromSuperview];
        	        			}];
				}
			}
		}
	}
	else {
		for (UIView *v in [self superview].subviews) {
			if ([v tag] == 12346) {
				[UIView transitionWithView:v
        	          		duration:0.5f 
        	           		options:UIViewAnimationCurveEaseInOut
        	        		animations:^(void) {
                                    [v setAlpha:0.0];
        	             			[v setFrame:CGRectMake([self frame].origin.x, [self frame].origin.y+5, 51, 51)];
        	        		} 
        	        		completion:^(BOOL finished) {
        	             			[v removeFromSuperview];
        	        		}];
			}
			else if ([v tag] == 12345) {
				[UIView transitionWithView:v
        	         		duration:0.5f 
        	           		options:UIViewAnimationCurveEaseInOut
        	        		animations:^(void) {
                                    [v setAlpha:0.0];
        	             			[v setFrame:CGRectMake([self frame].origin.x+[self frame].size.width-51, [self frame].origin.y+5, 51, 51)];
        	        		} 
       		         		completion:^(BOOL finished) {
        	        	    		[v removeFromSuperview];
        	        		}];
			}
            else if ([v tag] == 12347) {
                [UIView transitionWithView:v
                    duration:0.5f 
                    options:UIViewAnimationCurveEaseInOut
                    animations:^(void) {
                        [v setAlpha:0.0];
                        [v setFrame:CGRectMake([self frame].origin.x+20, [self frame].origin.y+20, 10.0, 10.0)];
                    }
                    completion:^(BOOL finished) {
                        [v removeFromSuperview];
                    }];
            } 

		}
		%orig;
	}
}

%new(v@:@) 
-(void)volumeChanged:(id)sender {
	[[%c(SBMediaController) sharedInstance] setVolume:[(UISlider*)sender value]];
}

%new(v@:@)
-(void)changeSong:(id)sender {
    if (isSeeking) {
        [[%c(SBMediaController) sharedInstance] endSeek:[(UIView *)sender tag] == 12345 ? 1 : -1];
        isSeeking = NO;
        return;
    }
    [timer invalidate];
	SBMediaController *controller = [%c(SBMediaController) sharedInstance];
	if ([(UIView *)sender tag] == 12345) {
		[controller changeTrack:1];
	}
	else {
		[controller changeTrack:-1];
	}
}

%new(v@:@)
-(void)changeSongPressedDown:(id)sender {
    if ([(UIView *)sender tag] == 12345) {
        timer = [%c(NSTimer) scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(frontSeek:) userInfo:nil repeats:NO];
    }
    else {
        timer = [%c(NSTimer) scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(backSeek:) userInfo:nil repeats:NO];
    }
}

%new(v@:@)
-(void)backSeek:(id)sender {
    [[%c(SBMediaController) sharedInstance] beginSeek:-1];
    isSeeking = YES;
}


%new(v@:@)
-(void)frontSeek:(id)sender {
    [[%c(SBMediaController) sharedInstance] beginSeek:1];
    isSeeking = YES;
}
    

%new(v@:@)
-(void)backASong:(id)sender {
	SBMediaController *controller = [%c(SBMediaController) sharedInstance];
	[controller changeTrack:-1];
}


%new(v@:)

- (void)updateIcon
{



	SBIconLabel *label = nil;

	SBIconImageView *imageView = nil;

	if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0f) {

		SBIconLabel *&label2 = (MSHookIvar<SBIconLabel *>(self, "_label"));
		label = label2;

		SBIconImageView *&imageView2 = (MSHookIvar<SBIconImageView *>(self, "_iconImageView"));
		imageView = imageView2;

	} 
	else {

		SBIconLabel *&label2 = (MSHookIvar<SBIconLabel *>([[%c(SBIconViewMap) homescreenMap] mappedIconViewForIcon:(SBIcon*)self], "_label"));
		label = label2;

		SBIconImageView *&imageView2 = (MSHookIvar<SBIconImageView *>([[%c(SBIconViewMap) homescreenMap] mappedIconViewForIcon:(SBIcon*)self], "_iconImageView"));
		imageView = imageView2;

	}

	[label setText:[self displayName]];

	imageView.image = [self generateIconImage:0];

}

-(id)generateIconImage:(int)image
{
	SBMediaController *controller = [%c(SBMediaController) sharedInstance];
	if (invertPlayPause) {
		if (![controller isPlaying]) {

			return [UIImage imageWithContentsOfFile:@"/Applications/SBControlsPlayPause.app/pause@2x.png"];//[UIImage imageWithData:[(MSHookIvar<NSDictionary *>(controller, "_nowPlayingInfo")) valueForKey:@"artworkData"]];;

		} else {

			return [UIImage imageWithContentsOfFile:@"/Applications/SBControlsPlayPause.app/play@2x.png"];

		}
	invertPlayPause = NO;
	}
	if ([controller isPlaying]) {

		return [UIImage imageWithContentsOfFile:@"/Applications/SBControlsPlayPause.app/pause@2x.png"];//[UIImage imageWithData:[(MSHookIvar<NSDictionary *>(controller, "_nowPlayingInfo")) valueForKey:@"artworkData"]];;

	} else {

		return [UIImage imageWithContentsOfFile:@"/Applications/SBControlsPlayPause.app/play@2x.png"];

	}

}
-(id)getStandardIconImageForLocation:(int)location
{
	return [self generateIconImage:location];
}

-(id)getIconImage:(int)image
{
	return [self generateIconImage:image];
}

-(id)getGenericIconImage:(int)image
{
	return [self generateIconImage:image];
}

%end

%hook SBIconView

-(void)longPressTimerFired {		
	SBIcon *&icon = (MSHookIvar<SBIcon *>(self, "_icon"));


	if (![[%c(SBIconController) sharedInstance] isEditing] && [(NSObject*)icon isKindOfClass:objc_getClass("SBControlPlayPause")]) {
		UIButton *forward = [UIButton buttonWithType:UIButtonTypeCustom];
		[forward setFrame:CGRectMake([icon frame].origin.x+[icon frame].size.width-30, [icon frame].origin.y+5, 30, [icon frame].size.height-10)];
		[forward addTarget:(SBControlPlayPause *)icon action:@selector(forwardASong:) forControlEvents:(UIControlEventTouchDragEnter)];
		[forward setOpaque:YES];
		[forward setAlpha:1.0];
		[forward setBackgroundColor:[UIColor whiteColor]];
		[[self superview] addSubview:forward];
		[UIView transitionWithView:forward
                	  duration:0.5f 
                	   options:UIViewAnimationCurveEaseInOut
                	animations:^(void) {
                	     [forward setFrame:CGRectMake([forward frame].origin.x+30, [forward frame].origin.y, [forward frame].size.width, [forward frame].size.height)];
                	} 
                	completion:^(BOOL finished) {
                	     // Do nothing
                	}]; 

	} else {

		%orig;

	}


}


%end

%hook SBAwayController

- (void)unlockWithSound:(BOOL)sound
{
	%orig;

	if ([[[[%c(SBIconController) sharedInstance] currentRootIconList] model] containsIcon:[[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"]]) {
		invertPlayPause = YES;
		[[[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"] updateIcon];

	}

}

%end

%hook SBMediaController 

-(BOOL)changeTrack:(int)track {
    BOOL b = %orig;
    if ([[[[%c(SBIconController) sharedInstance] currentRootIconList] model] containsIcon:[[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"]]) {
        invertPlayPause = NO;
        [[[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"] updateIcon];

    }
    return b;
}

-(void)setVolume:(float)volume {
    %orig;
    if (nextPrevOpen) {
        if ([[[[%c(SBIconController) sharedInstance] currentRootIconList] model] containsIcon:[[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"]]) {
            invertPlayPause = YES;
            SBIcon *i = [[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"];
            for (UISlider *s in [[i superview] subviews]) {
                if ([s tag] == 12347) {
                    [s setValue:volume];
                }
            }   
        }
    }

}

-(BOOL)togglePlayPause {
    BOOL b = %orig;
    if ([[[[%c(SBIconController) sharedInstance] currentRootIconList] model] containsIcon:[[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"]]) {
        invertPlayPause = YES;
        [[[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"] updateIcon];

    }
    return b;
}
    
%end


%hook SBIconController

-(void)scrollViewDidScroll:(id)scrollView {
	%orig;
	if ([[[self currentRootIconList] model] containsIcon:[[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"]]) {
		invertPlayPause = NO;
		[[[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"] updateIcon];

	}
}

%end


%hook MPMediaPlayerController

-(void)play {
	%orig;

	if ([[[[%c(SBIconController) sharedInstance] currentRootIconList] model] containsIcon:[[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"]]) {

		[[[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"] updateIcon];

	}
}

-(void)pause {
	
	%orig;

	if ([[[[%c(SBIconController) sharedInstance] currentRootIconList] model] containsIcon:[[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"]]) {

		[[[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"] updateIcon];

	}
}
	
%end

%hook VolumeControl 
-(void)toggleMute {
    %orig;
    isMuted = !isMuted;
    if ([[[[%c(SBIconController) sharedInstance] currentRootIconList] model] containsIcon:[[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"]]) {

        SBIcon *i = [[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"];
        for (UISlider *s in [[i superview] subviews]) {
            if ([s tag] == 12347) {
                [s setEnabled:!isMuted];
            }
        } 
    }
}

-(void)increaseVolume {
    %orig;
    if ([[[[%c(SBIconController) sharedInstance] currentRootIconList] model] containsIcon:[[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"]]) {

        SBIcon *i = [[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"];
        for (UISlider *s in [[i superview] subviews]) {
            if ([s tag] == 12347) {
                [s setValue:[s value]+(1/16)];
            }
        } 
    }
}
-(void)decreaseVolume {
    %orig;
    if ([[[[%c(SBIconController) sharedInstance] currentRootIconList] model] containsIcon:[[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"]]) {

        SBIcon *i = [[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"];
        for (UISlider *s in [[i superview] subviews]) {
            if ([s tag] == 12347) {
                [s setValue:[s value]+(1/16)];
            }
        } 
    }
}
-(void)_changeVolumeBy:(float)by {
    %orig(by);
    if ([[[[%c(SBIconController) sharedInstance] currentRootIconList] model] containsIcon:[[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"]]) {

        SBIcon *i = [[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"];
        for (UISlider *s in [[i superview] subviews]) {
            if ([s tag] == 12347) {
                [s setValue:[s value]+by];
            }
        } 
    }
}

-(void)_presentVolumeHUDWithMode:(int)mode volume:(float)volume {
    if (nextPrevOpen) {
        return;
    }
    %orig(mode, volume);
}
    
    
%end

%hook SBIcon

-(void)launch {
    if (nextPrevOpen) {
        SBIcon *i = [[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"];
        for (UIView *v in [i superview].subviews) {
            if ([v tag] == 12346) {
                [UIView transitionWithView:v
                        duration:0.2f 
                        options:UIViewAnimationCurveEaseInOut
                        animations:^(void) {
                            [v setAlpha:0.0];
                            [v setFrame:CGRectMake([i frame].origin.x, [i frame].origin.y+5, 51, 51)];
                        } 
                        completion:^(BOOL finished) {
                            [v removeFromSuperview];
                        }];
            }
            else if ([v tag] == 12345) {
                [UIView transitionWithView:v
                        duration:0.2f 
                        options:UIViewAnimationCurveEaseInOut
                        animations:^(void) {
                            [v setAlpha:0.0];
                            [v setFrame:CGRectMake([i frame].origin.x+[i frame].size.width-51, [i frame].origin.y+5, 51, 51)];
                        } 
                        completion:^(BOOL finished) {
                            [v removeFromSuperview];
                        }];
            }
            else if ([v tag] == 12347) {
                [UIView transitionWithView:v
                        duration:0.2f 
                        options:UIViewAnimationCurveEaseInOut
                        animations:^(void) {
                            [v setAlpha:0.0];
                            [v setFrame:CGRectMake([i frame].origin.x+20, [i frame].origin.y+20, 10.0, 10.0)];
                        }
                        completion:^(BOOL finished) {
                            [v removeFromSuperview];
                        }];
            } 

        }
        nextPrevOpen = NO;

    }
    else {
        %orig;
    }
}

-(void)longPressTimerFired {
	if (/*[[[[%c(SBIconController) sharedInstance] currentRootIconList] model] containsIcon:[[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"]] && */nextPrevOpen) {
		SBIcon *i = [[%c(SBIconModel) sharedInstance] leafIconForIdentifier:@"com.appuplink.sbcontrolsplaypause"];
		for (UIView *v in [i superview].subviews) {
			if ([v tag] == 12346) {
				[UIView transitionWithView:v
					duration:0.2f 
					options:UIViewAnimationCurveEaseInOut
					animations:^(void) {
						[v setAlpha:0.0];
						[v setFrame:CGRectMake([i frame].origin.x, [i frame].origin.y+5, 51, 51)];
					} 
					completion:^(BOOL finished) {
						[v removeFromSuperview];
					}];
			}
			else if ([v tag] == 12345) {
				[UIView transitionWithView:v
					duration:0.2f 
					options:UIViewAnimationCurveEaseInOut
					animations:^(void) {
						[v setAlpha:0.0];
						[v setFrame:CGRectMake([i frame].origin.x+[i frame].size.width-51, [i frame].origin.y+5, 51, 51)];
					} 
					completion:^(BOOL finished) {
						[v removeFromSuperview];
					}];
			}
			else if ([v tag] == 12347) {
				[UIView transitionWithView:v
					duration:0.2f 
					options:UIViewAnimationCurveEaseInOut
					animations:^(void) {
						[v setAlpha:0.0];
						[v setFrame:CGRectMake([i frame].origin.x+20, [i frame].origin.y+20, 10.0, 10.0)];
					}
					completion:^(BOOL finished) {
						[v removeFromSuperview];
					}];
			} 

		}
		nextPrevOpen = NO;

	}
	%orig;
}

%end