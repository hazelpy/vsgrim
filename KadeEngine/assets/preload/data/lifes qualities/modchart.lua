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
end

function update (elapsed) -- example https://twitter.com/KadeDeveloper/status/1382178179184422918
	local currentBeat = (songPos / 1000)*(bpm/60)
	local shaking = false;
	local testlist = {0, 4, 1, 5, 2, 6, 3, 7}

	if ( false ) then
		shaking = true;
	end
	
    -- 84->86, 88->90, 92->94, 96-98, 100->102, 104->106, 108->110, 112->114

	if (shaking) then
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