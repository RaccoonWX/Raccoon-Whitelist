local label = 
[[
  //
  ||       ____                                       _       ____    _ __       ___      __ 
  ||      / __ \____ _______________  ____  ____     | |     / / /_  (_) /____  / (_)____/ /_
  ||     / /_/ / __ `/ ___/ ___/ __ \/ __ \/ __ \    | | /| / / __ \/ / __/ _ \/ / / ___/ __/
  ||    / _, _/ /_/ / /__/ /__/ /_/ / /_/ / / / /    | |/ |/ / / / / / /_/  __/ / (__  ) /_  
  ||   /_/ |_|\__,_/\___/\___/\____/\____/_/ /_/     |__/|__/_/ /_/_/\__/\___/_/_/____/\__/  																													
  ||       				Created by TheRaccoon#1023
  ||]]  
Citizen.CreateThread(function()
	local CurrentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
	if not CurrentVersion then
		print('^1Raccoon-Whitelist Version Check Failed!^7')
	end

	function VersionCheckHTTPRequest()
		PerformHttpRequest('https://raw.githubusercontent.com/PeEcEeChIP/version-history/version/raccoon-whitelist.json', VersionCheck, 'GET')
	end

	function VersionCheck(err, response, headers)
		Citizen.Wait(3000)
		if err == 200 then
			local Data = json.decode(response)
			if CurrentVersion ~= Data.NewestVersion then
				print( label )			
				print('  ||    \n  ||    Raccoon-Whitelist is outdated!')
				print('  ||    Current version: ^2' .. Data.NewestVersion .. '^7')
				print('  ||    Your version: ^1' .. CurrentVersion .. '^7')
				print('  ||    Please download the lastest version from ^5' .. Data.DownloadLocation .. '^7')
				if Data.Changes ~= '' then
					print('  ||    \n  ||    ^5Changes: ^7' .. Data.Changes .. "\n^0  \\\\\n")
				end
			else
				print( label )			
				print('  ||    ^2Raccoon-Whitelist is up to date!\n^0  ||\n  \\\\\n')
			end
		else
			print( label )			
			print('  ||    ^1There was an error getting the latest version information, if the issue persists contact TheRaccoon#1023 on Discord.\n^0  ||\n  \\\\\n')
		end
		
		SetTimeout(60000000, VersionCheckHTTPRequest)
	end

	VersionCheckHTTPRequest()
end)
