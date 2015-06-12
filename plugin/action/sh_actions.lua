--[[
< CATHERINE > - A free role-playing framework for Garry's Mod.
Development and design by L7D.

Catherine is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Catherine.  If not, see <http://www.gnu.org/licenses/>.
]]--

local PLUGIN = PLUGIN

CAT_ACT_STARTANI = 1
CAT_ACT_EXITANI = 2

local actionTable = {
	[ "sit" ] = {
		text = "Sit!",
		actions = {
			citizen_male = {
				seq = "sit_ground",
				noAutoExit = true,
				doStartSeq = "Idle_to_Sit_Ground",
				doExitSeq = "Sit_Ground_to_Idle"
			},
			citizen_felame = {
				seq = "sit_ground",
				noAutoExit = true,
				doStartSeq = "Idle_to_Sit_Ground",
				doExitSeq = "Sit_Ground_to_Idle"
			}
		}
	},
	[ "cheer" ] = {
		text = "Cheer!",
		actions = {
			citizen_male = {
				seq = "cheer1"
			},
			citizen_felame = {
				seq = "cheer1"
			}
		}
	},
	[ "stand" ] = {
		text = "Stand!",
		actions = {
			citizen_male = {
				seq = "lineidle01",
				noAutoExit = true
			},
			citizen_felame = {
				seq = "lineidle01",
				noAutoExit = true
			},
			metrocop = {
				seq = "plazathreat2",
				noAutoExit = true
			}
		}
	}
}

PLUGIN.actions = actionTable