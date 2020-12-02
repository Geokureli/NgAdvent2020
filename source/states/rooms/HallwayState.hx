package states.rooms;

import flixel.tweens.FlxEase;
import flixel.FlxG;
import openfl.filters.ShaderFilter;
import vfx.ShadowShader;
import flixel.tweens.FlxTween;
import vfx.ShadowSprite;
import data.Game;
import data.Manifest;

class HallwayState extends RoomState
{
    var shade:ShadowSprite;
    
    override function create()
    {
        super.create();
        
    }
    
    override function initEntities()
    {
        super.initEntities();
        
        #if debug
        if(Game.state.match(Day1Intro(Started)))
            Game.state = Day1Intro(Dressed);
        #end
        
        switch(Game.state)
        {
            case Day1Intro(Dressed):
            {
                var floor = background.getByName("hallway");
                floor.setBottomHeight(floor.frameHeight);
                shade = new ShadowSprite(floor.x, floor.y);
                shade.makeGraphic(floor.frameWidth, floor.frameHeight, 0xFF000000);
                shade.shadow.setLightPos(2, FlxG.width / 4 - 16, floor.height / 2);
                shade.shadow.setLightPos(3, FlxG.width / 2, floor.height / 2);
                shade.shadow.setLightPos(4, FlxG.width / 4 * 3 + 16, floor.height / 2);
                add(shade);
                
                player.active = false;
                
                tweenLightRadius(1, 0, 60, 0.35, { startDelay:1.0, onComplete:(_)->player.active = true });
            }
            case Day1Intro(Hallway):
            {
                var floor = background.getByName("hallway");
                floor.setBottomHeight(floor.frameHeight);
                shade = new ShadowSprite(floor.x, floor.y);
                shade.makeGraphic(floor.frameWidth, floor.frameHeight, 0xFF000000);
                
                shade.shadow.setLightRadius(1, 60);
                
                shade.shadow.setLightPos(2, FlxG.width / 4 - 16, floor.height / 2);
                shade.shadow.setLightPos(3, FlxG.width / 2, floor.height / 2);
                shade.shadow.setLightPos(4, FlxG.width / 4 * 3 + 16, floor.height / 2);
                add(shade);
            }
            case _:
        }
    }
    
    function tweenLightRadius(light:Int, from:Float, to:Float, duration:Float, options:TweenOptions)
    {
        if (options == null)
            options = {};
            
        if (options.ease == null)
            options.ease = FlxEase.circOut;
        
        FlxTween.num(from, to, duration, options, (num)->shade.shadow.setLightRadius(light, num));
    }
    
    override function initClient()
    {
        if(!Game.state.match(Day1Intro(_)))
            super.initClient();
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        switch(Game.state)
        {
            case Day1Intro(eventState):
            {
                shade.shadow.setLightPos(1, player.x + player.width / 2, player.y + player.height / 2);
                
                if (eventState == Dressed && player.x > shade.shadow.getLightX(2))
                {
                    Game.state = Day1Intro(Hallway);
                    for (i in 0...3)
                        tweenLightRadius(i + 2, 0, 80, 0.6, { startDelay:i * 0.75 });
                }
            }
            case _:
        }
    }
}