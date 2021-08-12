package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.filters.BitmapFilter;
import openfl.filters.BlurFilter;
import openfl.filters.ColorMatrixFilter;
import openfl8.*;
import openfl.filters.ShaderFilter;
import openfl.Lib;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;

	public static var firstStart:Bool = true;
	public static var nightly:String = "";
	public static var kadeEngineVer:String = "1.4.2" + nightly;
	public static var gameVer:String = "0.2.7.1";
	
	var mainCamera:FlxCamera;
	var specialCamera:FlxCamera;

	var magenta:FlxSprite;
	var vignette:FlxSprite;
	var specialBar:FlxSprite;
	var specialBarTwo:FlxSprite;
	var specialStatic:FlxSprite;
	
	var camFollow:FlxObject;
	
	var vignetteTween:FlxTween;
	var specStaticTween:FlxTween;
	var specCameraTween:FlxTween;
	
	var filters:Array<BitmapFilter> = [];
	var filterMap:Map<String, {filter:BitmapFilter, ?onUpdate:Void->Void}>;

	public static var finishedFunnyMove:Bool = false;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var stc:FlxSprite = new FlxSprite(-100);
			stc.frames = Paths.getSparrowAtlas('menuBackground');
			stc.animation.addByPrefix('static', 'static', 24);
			stc.animation.play('static');
			stc.scrollFactor.x = 0;
			stc.scrollFactor.y = 0.10;
			stc.setGraphicSize(Std.int(stc.width * 1.1));
			stc.updateHitbox();
			stc.screenCenter();
			stc.antialiasing = true;
			stc.alpha = 0.7;
		add(stc);

		specialBar = new FlxSprite(0, -175).loadGraphic(Paths.image('mainmenu/specialBar'));
		specialBar.scrollFactor.x = 0;
		specialBar.scrollFactor.y = 0;
		specialBar.setGraphicSize(Std.int(specialBar.width), Std.int(specialBar.height / 2));
		specialBar.updateHitbox();
		specialBar.alpha = 0.3;
		specialBar.antialiasing = true;
		add(specialBar);

		new FlxTimer().start(1.5, function(tmr:FlxTimer) {
			FlxTween.tween(specialBar, {y: FlxG.height + 175}, 1.45, {
				onComplete: function(t:FlxTween) {
					specialBar.y = -175;
				}
			});
		}, 0);

		specialBarTwo = new FlxSprite(0, -175).loadGraphic(Paths.image('mainmenu/specialBar'));
		specialBarTwo.scrollFactor.x = 0;
		specialBarTwo.scrollFactor.y = 0;
		specialBarTwo.setGraphicSize(Std.int(specialBarTwo.width), Std.int(specialBarTwo.height / 2));
		specialBarTwo.updateHitbox();
		specialBarTwo.alpha = 0.3;
		specialBarTwo.antialiasing = true;
		add(specialBarTwo);

		new FlxTimer().start(0.75, function(tmr:FlxTimer) {
			new FlxTimer().start(1.5, function(tmr:FlxTimer) {
				FlxTween.tween(specialBarTwo, {y: FlxG.height + 175}, 1.45, {
					onComplete: function(t:FlxTween) {
						specialBarTwo.y = -175;
					}
				});
			}, 0);
		});

		filterMap = [
			"Tiltshift" => {
				filter: new ShaderFilter(new Tiltshift()),
			}
		];
		
		filters.push(filterMap.get("Tiltshift").filter);

		mainCamera = new FlxCamera();
		specialCamera = new FlxCamera();
		specialCamera.bgColor.alpha = 0;

		stc.cameras = [mainCamera];

		FlxG.cameras.add(mainCamera);
		FlxG.cameras.add(specialCamera);
		FlxG.game.filtersEnabled = true;

		mainCamera.setFilters(filters);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, FlxG.height * 1).loadGraphic(Paths.image('mainmenu/' + (optionShit[i].replace(' ', ''))));
				menuItem.setGraphicSize( Std.int(menuItem.height * 3) );
				menuItem.updateHitbox();
				menuItem.ID = i;
				menuItem.scrollFactor.set();
				menuItem.antialiasing = true;
				menuItem.alpha = 0.6;
				menuItem.x = -FlxG.width;
				menuItem.y = 0; 
			menuItems.add(menuItem);

			switch(optionShit[i]) {
				case 'donate':
					menuItem.y += menuItem.height / 4;

					FlxTween.tween(menuItem, {x: FlxG.width - (menuItem.width * 12)}, 1, {
						ease: FlxEase.expoOut
					});
				default:
					menuItem.y += (FlxG.height / 10) + (((FlxG.height / 6) + menuItem.height) * i);

					FlxTween.tween(menuItem, {x: ((menuItem.width / 12) - 300)}, 1, {
						ease: FlxEase.expoOut
					});
			}
		}

		firstStart = false;

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		specialStatic = new FlxSprite(-100);
		specialStatic.frames = Paths.getSparrowAtlas('darkStatic');
		specialStatic.animation.addByPrefix('static', 'static', 24);
		specialStatic.animation.play('static');
		specialStatic.scrollFactor.x = 0;
		specialStatic.scrollFactor.y = 0.10;
		specialStatic.setGraphicSize(Std.int(specialStatic.width * 1.1));
		specialStatic.updateHitbox();
		specialStatic.screenCenter();
		specialStatic.color = 0x00AAAAAA;
		specialStatic.antialiasing = true;
		specialStatic.alpha = 0;
		add(specialStatic);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionShit.cameras = [specialCamera];
		add(versionShit);

		vignette = new FlxSprite(-(FlxG.width/10), -(FlxG.height/10)).loadGraphic(Paths.image('mainmenu/vignette'));
		vignette.scrollFactor.x = 0;
		vignette.scrollFactor.y = 0;
		vignette.updateHitbox();
		vignette.screenCenter();
		vignette.antialiasing = true;
		vignette.alpha = 0;

		add(vignette);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		for (filter in filterMap) {
			if (filter.onUpdate != null)
				filter.onUpdate();
		}

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game", "&"]);
					#else
					FlxG.openURL('https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game');
					#end
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									goToState();
								});
							}
							else
							{
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									goToState();
								});
							}
						}
					});
				}
			}
		}

		super.update(elapsed);
	}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new FreeplayState());

				trace("Freeplay Menu Selected");

			case 'options':
				FlxG.switchState(new OptionsMenu());
		}
	}

	function changeItem(huh:Int = 0)
	{
		vignetteTween = FlxTween.tween(vignette, {alpha: 0.8}, 0.0001, {
			ease: FlxEase.expoIn,
			onComplete: function(twn:FlxTween) {
				FlxTween.cancelTweensOf(vignette);
				FlxTween.tween(vignette, {alpha: 0.4}, 0.4, {
					ease: FlxEase.expoIn
				});
			}
		});

		specStaticTween = FlxTween.tween(specialStatic, {alpha: 0.75}, 0.0001, {
			ease: FlxEase.expoIn,
			onComplete: function(twn:FlxTween) {
				FlxTween.cancelTweensOf(specialStatic);
				FlxTween.tween(specialStatic, {alpha: 0}, 0.3, {
					ease: FlxEase.expoIn
				});
			}
		});

		specCameraTween = FlxTween.tween(mainCamera, {zoom: 2}, 0.0001, {
			ease: FlxEase.expoIn,
			onComplete: function(twn:FlxTween) {
				FlxTween.cancelTweensOf(mainCamera);
				FlxTween.tween(mainCamera, {zoom: 1}, 0.3, {
					ease: FlxEase.quadOut
				});
			}
		});

		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			var curX = spr.x;

			if (spr.ID == 3) {
				spr.x = FlxG.width - (spr.width / 11);
				spr.y = 0 + spr.height / 4;
			}

			if (spr.ID == curSelected)
			{
				// whee
				spr.color = 0x00FFFFFF;

				FlxTween.cancelTweensOf(spr);
				FlxTween.tween(spr, {x: ((spr.width / 12) - 50), alpha: 1}, 0.4, {
					ease: FlxEase.expoOut
				});
			} else {
				spr.color = 0x00424242;

				FlxTween.cancelTweensOf(spr);
				FlxTween.tween(spr, {x: ((spr.width / 12) - 275), alpha: 0.5}, 0.4, {
					ease: FlxEase.expoOut
				});
			}

			spr.updateHitbox();
		});
	}
}