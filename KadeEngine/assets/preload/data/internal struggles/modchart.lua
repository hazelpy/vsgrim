function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)
    
	makeSprite("darkness","darkness")
    setActorX(0, "darkness")
    setActorY(400, "darkness")
    setActorScale(2, "darkness")

    makeSprite("lighting","lighting", true)
    setActorX(-400, "lighting")
    setActorY(400, "lighting")
    setActorScale(2, "lighting")

    setActorAlpha(0, "lighting")

    makeSprite("shadow","shadow")
    setActorX(0, "shadow")
    setActorY(400, "shadow")
    setActorScale(2, "shadow")
end

function update (elapsed) -- example https://twitter.com/KadeDeveloper/status/1382178179184422918
	local currentBeat = (songPos / 1000)*(bpm/60)
	local shaking = false;
	local testlist = {0, 4, 1, 5, 2, 6, 3, 7}

	if ( 
        (currentBeat >= 80 and currentBeat < 82) or 
        (currentBeat >= 84 and currentBeat < 86) or
        (currentBeat >= 88 and currentBeat < 90) or
        (currentBeat >= 92 and currentBeat < 96) or
        (currentBeat >= 96 and currentBeat < 98) or
        (currentBeat >= 100 and currentBeat < 102) or
        (currentBeat >= 104 and currentBeat < 106) or
        (currentBeat >= 108 and currentBeat < 112) or
        (currentBeat >= 128 and currentBeat < 130) or
        (currentBeat >= 132 and currentBeat < 134) or
        (currentBeat >= 136 and currentBeat < 138) or
        (currentBeat >= 140 and currentBeat < 142) or
        (currentBeat >= 160 and currentBeat < 162) or
        (currentBeat >= 164 and currentBeat < 166) or
        (currentBeat >= 168 and currentBeat < 170) or
        (currentBeat >= 172 and currentBeat < 174) ) then
		shaking = true;
	end
	
    -- 84->86, 88->90, 92->94, 96-98, 100->102, 104->106, 108->110, 112->114

	if not (shaking) then
		--for i,v in ipairs(testlist) do
			--setActorX(_G['defaultStrum'..(i-1)..'X'] + 32 * math.sin((currentBeat/1)-2), v)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat/1)-2), i)
		end
		setCamPosition(0, 0)
		setCameraZoom(1)
	else
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + (16 * math.sin((currentBeat/1)-2)) + ((math.random(10, 30) * 0.2) - 2), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 16 + ((math.random(10, 30) * 0.2) - 2), i)
		end
		setCamPosition(((math.random(10, 30) * 0.5) - 7.5), ((math.random(10, 30) * 0.5) - 7.5))
		setCameraZoom(0.9)
	end
end

function beatHit (beat)
   -- do nothing
end

function stepHit (step)
	-- do nothing
end

print("Mod Chart script loaded :)")