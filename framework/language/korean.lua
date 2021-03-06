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

local credit_htmlValue = [[
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
    <title></title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
	<style>
		@import url(http://fonts.googleapis.com/css?family=Open+Sans);
		body {
			font-family: "Open Sans", "나눔고딕", "NanumGothic", "맑은 고딕", "Malgun Gothic", "serif", "sans-serif"; 
			-webkit-font-smoothing: antialiased;
		}
	</style>
</head>
<body>
	<div class="container" style="margin-top:15px;">
	<div class="page-header">
		<h1>제작자&nbsp&nbsp<small>캐서린을 제작하거나 도움을 주신 분들 ...</small></h1>
	</div>
	
	<div class="panel panel-primary">
		<div class="panel-heading">
			<h3 class="panel-title">L7D</h3>
		</div>
			<div class="panel-body">프레임워크 개발 및 디자인.</div>
	</div>
	
	<div class="panel panel-warning">
		<div class="panel-heading">
			<h3 class="panel-title">Chessnut</h3>
		</div>
			<div class="panel-body">좋은 서포터 :)</div>
	</div>
	
	<div class="panel panel-default">
		<div class="panel-heading">
			<h3 class="panel-title">notcake (!cake)</h3>
		</div>
			<div class="panel-body">UTF-8 모듈을 개발.</div>
	</div>
	
	<div class="panel panel-default">
		<div class="panel-heading">
			<h3 class="panel-title">thelastpenguin™</h3>
		</div>
			<div class="panel-body">pON 모듈을 개발.</div>
	</div>
	
	<div class="panel panel-default">
		<div class="panel-heading">
			<h3 class="panel-title">Alexander Grist-Hucker (Alex Grist)</h3>
		</div>
			<div class="panel-body">netstream 2 모듈을 개발.</div>
	</div>

	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
	</body>
</html>
]]
local cashName = catherine.cash.GetOnlyName( )

local LANGUAGE = catherine.language.New( "korean" )
LANGUAGE.name = "Korean (한국어)"
LANGUAGE.data = {
	// Class
	[ "Class_UI_Title" ] = "클래스",
	[ "Class_UI_LimitStr" ] = "%s / %s",
	[ "Class_UI_SalaryStr" ] = "한 시간에 %s",
	[ "Class_UI_Unlimited" ] = "무제한",
	[ "Class_UI_NoJoinable" ] = "당신이 가입할 수 있는 클래스가 없습니다.",
	[ "Class_UI_CantJoinable" ] = "당신은 이 클래스에 가입 할 수 없습니다!",
	[ "Class_UI_NotValid" ] = "클래스가 올바르지 않습니다!",
	[ "Class_UI_TeamError" ] = "당신은 이 클래스에 가입할 수 없습니다!",
	[ "Class_UI_AlreadyJoined" ] = "당신은 이미 이 클래스에 가입되어 있습니다!",
	[ "Class_UI_HitLimit" ] = "이 클래스는 인원 제한에 도달했습니다!",
	
	// GlobalBan
	[ "GlobalBan_UI_Title" ] = "공식밴",
	[ "GlobalBan_UI_Blank" ] = "아직 공식밴 처리된 사용자가 없습니다.",
	[ "GlobalBan_UI_OpenProfile" ] = "해당 사용자의 스팀 프로필을 방문합니다.",
	[ "GlobalBan_UI_NotUsing" ] = "이 서버는 공식밴 서비스를 사용하고 있지 않습니다.",
	[ "GlobalBan_UI_Users" ] = "%s명의 사용자가 차단되었습니다.",
	
	// News
	[ "News_UI_Title" ] = "뉴스",
	[ "News_UI_Back" ] = "뒤로 가기",
	[ "News_UI_SelectPage" ] = "페이지를 선택하세요.",
	
	// Cash
	[ "Cash_UI_HasStr" ] = "당신은 %s " .. cashName .. " 를 가지고 있습니다.",
	[ "Cash_UI_TargetHasStr" ] = "이 사람은 %s " .. cashName .. " 를 가지고 있습니다.",
	[ "Cash_Notify_Set" ] = "%s 님이 %s 만큼의 돈을 %s 님에게 설정하셨습니다.",
	[ "Cash_Notify_Give" ] = "%s 님이 %s 만큼의 돈을 %s 님에게 주셨습니다.",
	[ "Cash_Notify_Take" ] = "%s 님이 %s 만큼의 돈을 %s 님에게서 빼았었습니다.",
	[ "Cash_Notify_HasNot" ] = "당신은 충분한 " .. cashName .. " 가 없습니다!",
	[ "Cash_Notify_NotValidAmount" ] = "올바른 금액을 입력하세요!",
	[ "Cash_Notify_Salary" ] = "당신은 %s " .. cashName .. " 을 월급으로 받았습니다.",
	[ "Cash_Notify_Get" ] = "당신은 %s " .. cashName .. " 를 찾으셨습니다.",
	
	// Character
	[ "Character_UI_Title" ] = "캐릭터",
	[ "Character_UI_CreateCharStr" ] = "새 인생 시작",
	[ "Character_UI_LoadCharStr" ] = "인생 계속하기",
	[ "Character_UI_Close" ] = "닫기",
	[ "Character_UI_ChangeLogStr" ] = "업데이트 내역",
	[ "Character_UI_ExitServerStr" ] = "서버에서 나가기",
	[ "Character_UI_BackStr" ] = "돌아가기",
	[ "Character_UI_DontHaveAny" ] = "캐릭터가 없습니다.",
	[ "Character_UI_UseCharacter" ] = "이 캐릭터를 사용합니다.",
	[ "Character_UI_DeleteCharacter" ] = "이 캐릭터를 삭제합니다.",
	[ "Character_UI_CharInfo" ] = "캐릭터 정보",
	[ "Character_UI_CharName" ] = "캐릭터 이름",
	[ "Character_UI_CharDesc" ] = "캐릭터 설명",
	[ "Character_UI_MusicError" ] = "백그라운드 음악을 재생하는데에 문제가 있습니다! ( 오류 : %s )",
	[ "Character_UI_Hint01" ] = "캐서린은 다국어를 지원합니다, 오른쪽 하단에 있는 버튼을 눌러 자신이 원하는 언어로 바꾸세요.",
	[ "Character_UI_SelectFaction" ] = "> 팩션을 선택하세요.",
	[ "Character_Notify_DeleteQ" ] = "이 캐릭터를 정말로 삭제하시겠습니까?",
	[ "Character_Notify_ExitQ" ] = "이 서버에서 정말로 나가시겠습니까?",
	[ "Character_Notify_CantDeleteUsing" ] = "사용하고 있는 캐릭터를 지울 수 없습니다!",
	[ "Character_Notify_CantSwitchRagdolled" ] = "기절한 상태에서는 캐릭터를 바꿀 수 없습니다!",
	[ "Character_Notify_IsNotValid" ] = "이 캐릭터는 올바르지 않습니다!",
	[ "Character_Notify_CantUseThisFaction" ] = "당신은 이 팩션을 사용할 수 없습니다!",
	[ "Character_Notify_IsNotValidFaction" ] = "이 캐릭터의 팩션이 올바르지 않습니다!",
	[ "Character_Notify_CharBanned" ] = "이 캐릭터는 밴 되었습니다!",
	[ "Character_Notify_CantSwitch" ] = "지금 캐릭터를 바꿀 수 없습니다!",
	[ "Character_Notify_CantSwitchUsing" ] = "같은 캐릭터를 또 사용할 수 없습니다!",
	[ "Character_Notify_CantSwitchDeath" ] = "죽은 상태에서는 캐릭터를 바꿀 수 없습니다!",
	[ "Character_Notify_CantSwitchTied" ] = "수갑에 묶인 상태에서는 캐릭터를 바꿀 수 없습니다!",
	[ "Character_Notify_MaxLimitHit" ] = "당신은 더 이상 캐릭터를 만드실 수 없습니다!",
	[ "Character_Notify_CharBan" ] = "%s 님이 %s 님의 캐릭터 를 밴하셨습니다.",
	[ "Character_Notify_CharUnBan" ] = "%s 님이 %s 님의 캐릭터 밴을 푸셨습니다.",
	[ "Character_Notify_CantCharBan_UnBan" ] = "이 사람을 캐릭터 밴 / 해제 할 수 없습니다!",
	[ "Character_Notify_SetName" ] = "%s 님이 '%s' 로 %s 의 캐릭터 이름을 바꾸셨습니다.",
	[ "Character_Notify_SetNameError" ] = "캐릭터 이름에 # 이 들어갈 수 없습니다!",
	[ "Character_Notify_SetDesc" ] = "%s 님이 '%s' 로 %s 의 캐릭터 설명을 바꾸셨습니다.",
	[ "Character_Notify_SetDescError" ] = "캐릭터 설명에 # 이 들어갈 수 없습니다!",
	[ "Character_Notify_SetSkin" ] = "%s 님이 %s 로 %s 의 캐릭터 스킨을 바꾸셨습니다.",
	[ "Character_Notify_SetSkinError" ] = "올바르지 않은 숫자 입니다!",
	[ "Character_Notify_SetModel" ] = "%s 님이 %s 로 %s 의 캐릭터 모델을 바꾸셨습니다.",
	[ "Character_Notify_SetDescLC" ] = "당신의 캐릭터 설명을 %s 로 바꿨습니다.",
	[ "Character_Notify_SelectModel" ] = "캐릭터 모델을 선택하세요!",
	[ "Character_Notify_NameLimitHit" ] = "캐릭터 이름은 " .. catherine.configs.characterNameMinLen .." 자 이상 " .. catherine.configs.characterNameMaxLen .. " 자 이하 되어야 합니다!",
	[ "Character_Notify_DescLimitHit" ] = "캐릭터 설명은 " .. catherine.configs.characterDescMinLen .."자 이상 " .. catherine.configs.characterDescMaxLen .. "자 이하 되어야 합니다!",
	
	// Accessory
	[ "Accessory_Wear_ModelError" ] = "모델 오류가 있습니다.",
	[ "Accessory_Wear_BoneExists" ] = "해당 부위에 이미 악세서리가 있습니다.",
	[ "Accessory_Wear_BoneNotExists" ] = "해당 부위에 악세서리가 없습니다.",
	[ "Accessory_Wear_BoneIndexError" ] = "부위 데이터가 올바르지 않습니다.",
	
	// Faction
	[ "Faction_UI_Title" ] = "팩션",
	[ "Faction_Notify_Give" ] = "%s 님이 %s 팩션에 대한 권한을 %s 님에게 부여했습니다.",
	[ "Faction_Notify_Take" ] = "%s 님이 %s 팩션에 대한 권한을 %s 님에게서 빼았었습니다.",
	[ "Faction_Notify_NotValid" ] = "%s 는 올바르지 않은 팩션 입니다!",
	[ "Faction_Notify_NotWhitelist" ] = "%s 는 화이트리스트가 아닙니다!",
	[ "Faction_Notify_AlreadyHas" ] = "%s 님이 이미 %s 화이트리스트를 가지고 있습니다!",
	[ "Faction_Notify_HasNot" ] = "%s 님은 %s 화이트리스트를 가지고 있지 않습니다!",
	[ "Faction_Notify_SelectPlease" ] = "팩션을 선택하세요!",
	
	// Flag
	[ "Flag_Notify_Give" ] = "%s 님이 %s 플래그를 %s 님에게 주셨습니다.",
	[ "Flag_Notify_Take" ] = "%s 님이 %s 플래그를 %s 님에게서 빼았았습니다.",
	[ "Flag_Notify_AlreadyHas" ] = "%s 님은 이미 %s 플래그를 가지고 있습니다!",
	[ "Flag_Notify_HasNot" ] = "%s 님은 %s 플래그를 가지고 있지 않습니다!",
	[ "Flag_Notify_NotValid" ] = "%s 는 올바르지 않은 플래그 입니다!",
	[ "Flag_p_Desc" ] = "게리건에 대한 권한.",
	[ "Flag_t_Desc" ] = "툴건에 대한 권한.",
	[ "Flag_e_Desc" ] = "프롭 소환에 대한 권한.",
	[ "Flag_x_Desc" ] = "엔티티 소환에 대한 권한.",
	[ "Flag_V_Desc" ] = "차 소환에 대한 권한.",
	[ "Flag_n_Desc" ] = "NPC 소환에 대한 권한.",
	[ "Flag_R_Desc" ] = "레그돌 소환에 대한 권한.",
	[ "Flag_s_Desc" ] = "이펙트 소환에 대한 권한.",
	[ "Flag_i_Desc" ] = "아이템 소환, 지급에 대한 권한.",
	
	[ "UnknownError" ] = "알 수 없는 오류가 발생하였습니다, 죄송합니다!",
	[ "Basic_Notify_UnknownPlayer" ] = "올바른 캐릭터의 이름을 입력하세요!",
	[ "Basic_Notify_NoArg" ] = "%s 번째 인수를 입력하세요!",
	[ "Basic_Notify_InputText" ] = "문자를 입력하세요!",

	// Version
	[ "Version_UI_Title" ] = "정보",
	[ "Version_UI_YourVer_AV" ] = "버전 '%s'",
	[ "Version_UI_YourVer_NO" ] = "버전 '올바르지 않음'",
	[ "Version_UI_Checking" ] = "버전을 확인하는 중 ...",
	[ "Version_UI_CheckButtonStr" ] = "버전 확인",
	[ "Version_UI_OpenUpdateLogStr" ] = "업데이트 내역",
	[ "Version_Notify_FoundNew" ] = "이 서버는 최신 버전으로 업데이트가 필요합니다!",
	[ "Version_Notify_AlreadyNew" ] = "이 서버는 최신 버전을 사용하고 있습니다, 감사합니다.",
	[ "Version_Notify_CheckError" ] = "버전을 확인하는 중 오류가 발생하였습니다. - %s",
	[ "Version_Notify_NextTime" ] = "너무 자주 버전을 확인할 수 없습니다, 나중에 다시 시도하세요!",
	
	// Attribute
	[ "Attribute_UI_Title" ] = "능력치",
	
	// Business
	[ "Business_UI_Title" ] = "사업",
	[ "Business_UI_NoBuyable" ] = "당신이 살 수 있는 물건이 없습니다!",
	[ "Business_UI_BuyButtonStr" ] = "물건 구매 > %s",
	[ "Business_UI_ShoppingCartStr" ] = "장바구니",
	[ "Business_UI_TotalStr" ] = "전체 %s",
	[ "Business_UI_Take" ] = "가지기",
	[ "Business_UI_Shipment_Title" ] = "주문물",
	[ "Business_UI_Shipment_Desc" ] = "상자 안에 물건들이 들어있습니다.",
	[ "Business_Notify_BuyQ" ] = "이 물건들을 구매하시겠습니까?",
	[ "Business_Notify_CantOpenShipment" ] = "당신은 이 주문물을 열 수 없습니다!",
	[ "Business_Notify_NeedCartAdd" ] = "장바구니에 먼저 물건을 추가하세요!",
	
	// Inventory
	[ "Inventory_UI_Title" ] = "인벤토리",
	[ "Inventory_Notify_HasNotSpace" ] = "당신의 인벤토리에 공간이 없습니다!",
	[ "Inventory_Notify_HasNotSpaceTarget" ] = "해당 사람의 인벤토리에 공간이 없습니다!",
	[ "Inventory_Notify_CantDrop01" ] = "그렇게 멀리 떨어트릴 수 없습니다!",
	[ "Inventory_Notify_DontHave" ] = "당신은 이 물건을 가지고 있지 않습니다!",
	[ "Inventory_Notify_IsPersistent" ] = "이 물건은 영구적으로 가지고 있어야 합니다!",
	
	// Scoreboard
	[ "Scoreboard_UI_Title" ] = "플레이어 목록",
	[ "Scoreboard_UI_Author" ] = "프레임워크 개발자",
	[ "Scoreboard_UI_UnknownDesc" ] = "당신은 이 사람을 모릅니다.",
	[ "Scoreboard_UI_PlayerDetailStr" ] = "스팀 이름 : %s\n스팀 고유 번호 : %s\n핑 : %s\n플레이어 옵션을 보시려면 클릭하세요.",
	[ "Scoreboard_UI_CanNotLook_Str" ] = "당신은 볼 수 없습니다.",
	[ "Scoreboard_PlayerOption01_Str" ] = "스팀 프로필 열기",
	[ "Scoreboard_PlayerOption02_Str" ] = "캐릭터 이름 바꾸기",
	[ "Scoreboard_PlayerOption02_Q" ] = "이름을 무엇으로 바꾸시겠습니까?",
	[ "Scoreboard_PlayerOption03_Str" ] = "화이트리스트 지급",
	[ "Scoreboard_PlayerOption04_Str" ] = "캐릭터 밴 / 밴 해제",
	[ "Scoreboard_PlayerOption04_Q" ] = "정말로 이 캐릭터를 밴 / 밴 해제 하시겠습니까?",
	[ "Scoreboard_PlayerOption05_Str" ] = "플래그 주기",
	[ "Scoreboard_PlayerOption05_Q" ] = "어떤 플래그를 주시겠습니까?",
	[ "Scoreboard_PlayerOption06_Str" ] = "플래그 뺏기",
	[ "Scoreboard_PlayerOption06_Q" ] = "어떤 플래그를 뺏으시겠습니까?",
	[ "Scoreboard_PlayerOption07_Str" ] = "아이템 주기",
	[ "Scoreboard_PlayerOption07_Q1" ] = "어떤 아이템을 주시겠습니까?",
	[ "Scoreboard_PlayerOption07_Q2" ] = "해당 아이템을 몇개 주시겠습니까?",
	
	// Help
	[ "Help_UI_Title" ] = "도움말",
	[ "Help_UI_DefPageTitle" ] = "도움말에 오신 것을 환영합니다.",
	[ "Help_UI_DefPageDesc" ] = "왼쪽의 메뉴에서 도움말을 선택하세요.",
	[ "Help_Category_Flag" ] = "플래그",
	[ "Help_Desc_Flag" ] = "플래그들을 나열합니다 ...",
	[ "Help_Category_Credit" ] = "제작자",
	[ "Help_HTMLValue_Credit" ] = credit_htmlValue,
	[ "Help_Category_Changelog" ] = "업데이트 로그",
	[ "Help_Category_Command" ] = "명령어",
	[ "Help_Desc_Command" ] = "명령어들을 나열합니다 ...",
	[ "Help_Category_Plugin" ] = "플러그인",
	[ "Help_Desc_Plugin" ] = "플러그인들을 나열합니다 ...",
	
	// Plugin
	[ "Plugin_Value_Author" ] = "개발 및 디자인 - '%s'",
	
	// Storage
	[ "Storage_UI_YourInv" ] = "당신의 인벤토리",
	[ "Storage_UI_StorageNoHaveItem" ] = "이 저장소는 비어있습니다.",
	[ "Storage_UI_PlayerNoHaveItem" ] = "당신은 아무것도 가지고 있지 않습니다.",
	[ "Storage_Notify_HasNotSpace" ] = "이 저장소에는 공간이 없습니다!",
	[ "Storage_Notify_NoStorage" ] = "이 물체는 올바른 저장소가 아닙니다!",
	[ "Storage_CMD_SetPWD" ] = "당신은 이 저장소의 암호를 %s 로 설정하셨습니다.",
	[ "Storage_PWDQ" ] = "이 저장소의 암호가 무엇입니까?",
	[ "Storage_Notify_PWDError" ] = "암호가 올바르지 않습니다!",
	[ "Storage_OpenStr" ] = "열기",
	
	// Item SYSTEM
	[ "Item_GiveCommand_Fin" ] = "당신은 %s개의 %s 아이템을 %s 님에게 줬습니다.",
	[ "Item_Notify_NoItemData" ] = "올바르지 않은 아이템 입니다!",
	
	// Item Base
	[ "Item_Category_Other" ] = "기타",
	[ "Item_Category_Weapon" ] = "무기",
	[ "Item_Category_Storage" ] = "공간",
	[ "Item_Category_Clothing" ] = "의류",
	[ "Item_Category_BodygroupClothing" ] = "의류",
	[ "Item_FuncStr01_BodygroupClothing" ] = "옷 입기",
	[ "Item_Func01Notify01_BodygroupClothing" ] = "당신은 이 옷을 입을 수 없습니다!",
	[ "Item_Func01Notify02_BodygroupClothing" ] = "당신은 이미 이 부위에 옷을 입고 있습니다!",
	[ "Item_Func02Notify01_BodygroupClothing" ] = "당신은 이 옷을 벗을 수 없습니다!",
	[ "Item_Func02Notify02_BodygroupClothing" ] = "당신은 이 부위에 옷을 입고 있지 않습니다!",
	[ "Item_FuncStr02_BodygroupClothing" ] = "옷 벗기",
	[ "Item_FuncStr01_Clothing" ] = "옷 입기",
	[ "Item_FuncStr02_Clothing" ] = "옷 벗기",
	[ "Item_Category_Accessory" ] = "악세서리",
	[ "Item_FuncStr01_Accessory" ] = "착용",
	[ "Item_FuncStr02_Accessory" ] = "벗기",
	[ "Item_Category_Alcohol" ] = "술",
	[ "Item_FuncStr01_Alcohol" ] = "마시기",
	[ "Item_Category_Ammo" ] = "탄약",
	[ "Item_FuncStr01_Ammo" ] = "사용",
	
	[ "Item_Category_Wallet" ] = "지갑",
	[ "Item_Name_Wallet" ] = "지갑",
	[ "Item_Desc_Wallet" ] = cashName .. " 가 쌓여있습니다.",
	[ "Item_Desc_World_Wallet" ] = "%s 가 쌓여있습니다.",
	[ "Item_FuncStr01_Wallet" ] = cashName .. " 가지기",
	[ "Item_FuncStr02_Wallet" ] = cashName .. " 떨어트리기",
	[ "Item_DropQ_Wallet" ] = "떨어트릴 " .. cashName .. " 의 금액을 입력하세요.",
	
	[ "Item_Notify01_ZT" ] = "이 사람은 이미 묶여있습니다!",
	[ "Item_Notify02_ZT" ] = "당신은 수갑이 없습니다!",
	[ "Item_Notify03_ZT" ] = "당신은 수갑에 묶여있습니다!",
	[ "Item_Notify04_ZT" ] = "이 사람은 수갑에 묶여있지 않습니다!",
	[ "Item_Message01_ZT" ] = "수갑을 묶는 중 입니다 ...",
	[ "Item_Message02_ZT" ] = "수갑을 푸는 중 입니다 ...",
	[ "Item_Message03_ZT" ] = "당신은 수갑에 묶여있습니다.",
	
	[ "Item_FuncStr01_Weapon" ] = "장착",
	[ "Item_FuncStr02_Weapon" ] = "장착 해제",
	[ "Item_FuncStr01_Basic" ] = "가지기",
	[ "Item_FuncStr02_Basic" ] = "떨어트리기",
	[ "Item_Notify01_Weapon" ] = "당신은 이 형식의 무기를 더 이상 장착할 수 없습니다!",
	
	[ "Item_Free" ] = "무료!",
	
	// Entity
	[ "Entity_Notify_NotValid" ] = "이것은 올바르지 않은 엔티티 입니다!",
	[ "Entity_Notify_NotPlayer" ] = "이것은 올바르지 않은 플레이어 입니다!",
	[ "Entity_Notify_NotDoor" ] = "이것은 올바르지 않은 문 입니다!",
	[ "Entity_Notify_TooFar" ] = "물체와의 거리가 너무 멈니다!",
	
	// Command
	[ "Command_Notify_NotFound" ] = "해당 명령어는 존재하지 않습니다!",
	[ "Command_DefDesc" ] = "명령어 입니다.",
	[ "Command_OOC_Error" ] = "당신이 OOC 를 하기 위해서는 %s초를 기다려야 합니다!",
	[ "Command_LOOC_Error" ] = "당신이 LOOC 를 하기 위해서는 %s초를 기다려야 합니다!",
	
	// Player
	[ "Player_Message_Dead_HUD" ] = "이 사람은 사망했습니다.",
	[ "Player_Message_Ragdolled_HUD" ] = "이 사람은 기절했습니다.",
	[ "Player_Message_Ragdolled_01" ] = "당신은 기절했습니다 ...",
	[ "Player_Message_Dead_01" ] = "당신은 죽었습니다 ...",
	[ "Player_Message_GettingUp" ] = "정신을 차리고 있습니다 ...",
	[ "Player_Message_AlreayGettingUp" ] = "당신은 이미 정신을 차리고 있습니다!",
	[ "Player_Message_AlreadyFallovered" ] = "당신은 이미 기절했습니다!",
	[ "Player_Message_BlockFallover" ] = "당신은 %s초후 다시 기절 할 수 있습니다!",
	[ "Player_Message_NotFallovered" ] = "당신은 기절하지 않았습니다!",
	[ "Player_Message_HasNotPermission" ] = "당신은 권한이 없습니다!",
	[ "Player_Message_UnTie" ] = "'사용' 키를 눌러 수갑을 풀 수 있습니다.",
	[ "Player_Message_TiedBlock" ] = "수갑에 묶인 상태에서는 할 수 없습니다.",
	
	// Recognize
	[ "Recognize_UI_Option_LookingPlayer" ] = "보고 있는 사람에게 자신의 정보를 알려주기.",
	[ "Recognize_UI_Option_TalkRange" ] = "조금 멀리 사람에게 자신의 정보를 알려주기.",
	[ "Recognize_UI_Option_YellRange" ] = "매우 멀리 있는 사람에게도 자신의 정보를 알려주기.",
	[ "Recognize_UI_Option_WhisperRange" ] = "주변의 사람들에게 자신의 정보를 알려주기.",
	[ "Recognize_UI_Unknown" ] = "알 수 없음",
	
	// Door
	[ "Door_Notify_CMD_Locked" ] = "이 문을 잠갔습니다.",
	[ "Door_Notify_CMD_UnLocked" ] = "이 문을 잠금 해제 하였습니다.",
	[ "Door_Notify_BuyQ" ] = "이 문을 정말로 구매하시겠습니까?",
	[ "Door_Notify_SellQ" ] = "이 문을 정말로 판매하시겠습니까?",
	[ "Door_Message_Locking" ] = "잠그는 중 ...",
	[ "Door_Message_UnLocking" ] = "잠금 해제 중 ...",
	[ "Door_Message_Buyable" ] = "이 문은 구매하실 수 있습니다.",
	[ "Door_Message_CantBuy" ] = "이 문은 구매하실 수 없습니다.",
	[ "Door_Message_AlreadySold" ] = "이 문은 이미 팔렸습니다.",
	[ "Door_Notify_AlreadySold" ] = "이 문은 이미 누군가에게 팔렸습니다!",
	[ "Door_Notify_NoOwner" ] = "당신은 이 문의 주인이 아닙니다!",
	[ "Door_Notify_CantBuyable" ] = "이 문은 구매하실 수 없습니다!",
	[ "Door_Notify_Buy" ] = "이 문을 구매했습니다.",
	[ "Door_Notify_Sell" ] = "이 문을 판매했습니다.",
	[ "Door_Notify_SetTitle" ] = "이 문의 제목을 설정했습니다.",
	[ "Door_Notify_SetDesc" ] = "이 문의 설명을 설정했습니다.",
	[ "Door_Notify_SetDescHitLimit" ] = "문 설명 제한이 초과했습니다!",
	[ "Door_Notify_SetStatus_True" ] = "이 문을 구매할 수 없게 하셨습니다.",
	[ "Door_Notify_SetStatus_False" ] = "이 문을 구매할 수 있게 하셨습니다.",
	[ "Door_Notify_Disabled_True" ] = "이 문을 비 활성화 하셨습니다.",
	[ "Door_Notify_Disabled_False" ] = "이 문을 활성화 하셨습니다.",
	[ "Door_Notify_DoorSpam" ] = "문장난을 하지 마세요!",
	
	[ "Door_Notify_ChangePer" ] = "이 사람의 권한을 바꾸셨습니다.",
	[ "Door_Notify_RemPer" ] = "이 사람의 권한을 없앴습니다.",
	[ "Door_Notify_AlreadyHasPer" ] = "이미 이 사람은 이 권한을 가지고 있습니다!",
	[ "Door_Notify_CantChangeOwner" ] = "주인의 권한을 바꿀 수 없습니다!",
	
	[ "Door_UI_Default" ] = "문",
	[ "Door_UI_DoorDescStr" ] = "문 설명",
	[ "Door_UI_DoorSellStr" ] = "문 팔기",
	[ "Door_UI_AllPerStr" ] = "모든 권한",
	[ "Door_UI_BasicPerStr" ] = "기본 권한",
	[ "Door_UI_RemPerStr" ] = "권한 해제",
	[ "Door_UI_OwnerStr" ] = "주인",
	[ "Door_UI_AllStr" ] = "모든 권한",
	[ "Door_UI_BasicStr" ] = "기본 권한",
	
	// Hint
	[ "Hint_Message_01" ] = "// 를 채팅창에 쳐서 OOC 채팅을 하십시오.",
	[ "Hint_Message_02" ] = ".// 또는 [[ 를 채팅창에 쳐서 LOOC 채팅을 하십시오.",
	[ "Hint_Message_03" ] = "F1 버튼을 눌러 RP 정보를 보십시오.",
	[ "Hint_Message_04" ] = "탭(Tab) 버튼을 눌러 메인 메뉴를 열 수 있습니다.",
	[ "Hint_Message_05" ] = "F2 버튼을 눌러 다른 사람에게 자신을 알리세요.",
	
	// Option
	[ "Option_UI_Title" ] = "설정",
	[ "Option_Category_01" ] = "프레임워크",
	[ "Option_Category_02" ] = "개발자",
	[ "Option_Category_03" ] = "관리자",
	
	[ "Option_Str_BAR_Name" ] = "상단바 표시",
	[ "Option_Str_BAR_Desc" ] = "상단에 있는 바를 표시합니다.",
	
	[ "Option_Str_CHAT_TIMESTAMP_Name" ] = "채팅 수신 시간 표시",
	[ "Option_Str_CHAT_TIMESTAMP_Desc" ] = "채팅이 수신된 시간을 채팅 옆에 표시합니다.",
	
	[ "Option_Str_ADMIN_ESP_Name" ] = "어드민 ESP 표시",
	[ "Option_Str_ADMIN_ESP_Desc" ] = "노클립을 했을 때 플레이어의 위에 정보를 뜨게 합니다.",
	
	[ "Option_Str_Always_ADMIN_ESP_Name" ] = "항상 어드민 ESP 표시",
	[ "Option_Str_Always_ADMIN_ESP_Desc" ] = "노클립을 안했을 때도 플레이어 위에 정보를 뜨게 합니다.",
	
	[ "Option_Str_MAINHUD_Name" ] = "메인 HUD 표시",
	[ "Option_Str_MAINHUD_Desc" ] = "메인 HUD 를 표시합니다.",
	
	[ "Option_Str_MAINLANG_Name" ] = "언어",
	[ "Option_Str_MAINLANG_Desc" ] = "캐서린의 언어를 변경할 수 있습니다.",
	
	[ "Option_Str_HINT_Name" ] = "RP 힌트 표시",
	[ "Option_Str_HINT_Desc" ] = "RP 에 도움이 되는 힌트를 표시합니다.",
	
	// Chat
	[ "Chat_Str_IC" ] = "%s 님의 말 %s",
	[ "Chat_Str_Yell" ] = "%s 님의 소리치기 %s",
	[ "Chat_Str_Whisper" ] = "%s 님의 속삭이기 %s",
	[ "Chat_Str_Console" ] = "콘솔",
	[ "Chat_Str_Roll" ] = "%s 님이 주사위를 굴렸습니다. - %s",
	[ "Chat_Str_Connect" ] = "%s 님이 서버에 들어오셨습니다.",
	[ "Chat_Str_Disconnect" ] = "%s 님이 서버에서 나가셨습니다.",
	
	// Question
	[ "Question_UIStr" ] = "질문",
	[ "Question_KickMessage" ] = "답변중에 틀린 항목이 있습니다!",
	
	[ "Question_UI_Continue" ] = "진행하기",
	[ "Question_UI_Disconnect" ] = "서버에서 나가기",
	[ "Question_Notify_DisconnectQ" ] = "이 서버에서 정말로 나가시겠습니까?",
	
	// Basic
	[ "Basic_UI_StringRequest" ] = "요청",
	[ "Basic_UI_Question" ] = "질문",
	[ "Basic_UI_Notify" ] = "안내",
	[ "Basic_UI_Continue" ] = "진행",
	[ "Basic_UI_OK" ] = "확인",
	[ "Basic_UI_YES" ] = "네",
	[ "Basic_UI_NO" ] = "아니오",
	[ "Basic_UI_Count" ] = "%s개",
	[ "Basic_IDK" ] = "...?",
	[ "Basic_Sorry" ] = "죄송합니다 ...",
	[ "Basic_UI_EntityMenuOptionTitle" ] = "이 물체와의 상호작용을 선택하세요",
	[ "Basic_UI_ItemMenuOptionTitle" ] = "이 아이템과의 상호작용을 선택하세요",
	[ "Basic_UI_RecogniseMenuOptionTitle" ] = "다른 사람에게 어떻게 알리시겠습니까?",
	[ "Basic_Error_NoSchema" ] = "스키마(Schema) 게임모드가 불러와져 있지 않습니다. (CAT_ERR 0x1)",
	[ "Basic_Error_NoDatabase" ] = "데이터베이스에 연결되어 있지 않습니다. (CAT_ERR 0x2) : %s",
	[ "Basic_Error_LibraryLoad" ] = "라이브러리를 불러오는 중 오류가 발생했습니다. (CAT_ERR 0x3) ( 함수 : %s )",
	[ "Basic_Error_LoadTimeoutWait" ] = "캐서린을 로딩하는 중에 문제가 있는 것 같습니다, 다시 로딩을 시도합니다 ... (CAT_ERR 0x4) ( %s번 시도중. )",
	[ "Basic_Error_Reloading" ] = "캐서린을 다시 로딩하는 중 입니다 ...",
	[ "Basic_Framework_Author" ] = "프레임워크 개발 및 디자인 - %s.",
	[ "Basic_Notify_BunnyHop" ] = "버니합을 하지 마십시오!",
	
	// Command
	[ "Command_ChangeLevel_Fin" ] = "%s초 후 맵이 %s 로 바뀝니다.",
	[ "Command_ChangeLevel_Error01" ] = "맵이 올바르지 않습니다!",
	[ "Command_RestartLevel_Fin" ] = "%s초 후 서버가 리부팅 됩니다.",
	[ "Command_ClearDecals_Fin" ] = "맵에 있는 데칼을 모두 지웠습니다.",
	[ "Command_SetTimeHour_Fin" ] = "당신은 RP 시간을 %s시로 설정하셨습니다.",
	[ "Command_PrintBodyGroup_Fin" ] = "해당 사람의 바디그룹 테이블 구조가 콘솔에 표시됩니다.",
	[ "Command_PM_Error01" ] = "자기 자신에게 PM 채팅을 보낼 수 없습니다!",
	
	// AntiHaX
	[ "AntiHaX_KickMessageNotifyAdmin" ] = "%s/%s 유저가 치트 프로그램을 사용하였습니다, 그래서 킥 처리를 하였습니다.",
	[ "AntiHaX_KickMessage" ] = "죄송합니다, 당신은 치트 프로그램 사용으로 감지되어 강퇴당하셨습니다 :(",
	[ "AntiHaX_KickMessage_TimeOut" ] = "죄송합니다, 당신은 치트 프로그램 확인 작업의 제한 시간을 초과했습니다 :(",
	
	// Weapon
	[ "Weapon_MapEntity_Desc" ] = "'사용' 키를 눌러 장착하십시오.",
	[ "Weapon_Instructions_Title" ] = "- 설명서 -",
	[ "Weapon_Purpose_Title" ] = "- 용도 -",
	[ "Weapon_Author_Title" ] = "- 개발자 -",
	
	[ "Weapon_Fists_Name" ] = "손",
	[ "Weapon_Fists_Instructions" ] = "왼쪽 키 : 때리기,\n오른쪽 키 : 노크.",
	[ "Weapon_Fists_Purpose" ] = "사람을 떄리거나 문을 노크할 수 있습니다.",
	
	[ "Weapon_Key_Name" ] = "열쇠",
	[ "Weapon_Key_Instructions" ] = "왼쪽 키 : 잠금,\n오른쪽 키 : 잠금 해제.",
	[ "Weapon_Key_Purpose" ] = "물체를 잠그거나 잠금을 풀 수 있습니다."
}

catherine.language.Register( LANGUAGE )