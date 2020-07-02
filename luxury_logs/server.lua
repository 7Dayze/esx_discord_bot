ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function sendToDiscord (name,message,color)
  local DiscordWebHook = Config.webhook

local embeds = {
    {
        ["title"]=message,
        ["type"]="rich",
        ["color"] =color,
        ["footer"]=  {
            ["text"]= "Luxury RP logs - By Cob",
       },
    }
}

  if message == nil or message == '' then return FALSE end
  PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

sendToDiscord(_U('server'),_U('server_start'),Config.green)

-- Add event when a player give an item
--  TriggerEvent("esx:giveitemalert",sourceXPlayer.name,targetXPlayer.name,ESX.Items[itemName].label,itemCount) -> ESX_extended
RegisterServerEvent("esx:giveitemalert")
AddEventHandler("esx:giveitemalert", function(name,nametarget,itemname,amount)
   if(settings.LogItemTransfer)then
    sendToDiscord(_U('server_item_transfer'),name.._('user_gives_to')..nametarget.." "..amount .." "..itemname,Config.green)
   end

end)

-- Add event when a player give money
-- TriggerEvent("esx:givemoneyalert",sourceXPlayer.name,targetXPlayer.name,itemCount) -> ESX_extended
RegisterServerEvent("esx:givemoneyalert")
AddEventHandler("esx:givemoneyalert", function(name,nametarget,amount)
  if(settings.LogMoneyTransfer)then
    sendToDiscord(_U('server_money_transfer'),name.." ".._('user_gives_to').." "..nametarget.." "..amount .." $",Config.yellow)
  end

end)

-- Add event when a player give weapon
--  TriggerEvent("esx:giveweaponalert",sourceXPlayer.name,targetXPlayer.name,weaponLabel) -> ESX_extended
RegisterServerEvent("esx:giveweaponalert")
AddEventHandler("esx:giveweaponalert", function(name,nametarget,weaponlabel)
  if(settings.LogWeaponTransfer)then
    sendToDiscord(_U('server_weapon_transfer'),name.." ".._('user_gives_to').." "..nametarget.." "..weaponlabel,Config.blue)
  end

end)

-- Add event when a player is washing money
--  TriggerEvent("esx:washingmoneyalert",xPlayer.name,amount) -> ESX_society
RegisterServerEvent("esx:washingmoneyalert")
AddEventHandler("esx:washingmoneyalert", function(name,amount)
  if(settings.LogDirtyWash)then
    sendToDiscord(_U('server_washingmoney'),name.." ".._('user_washingmoney').." ".. amount .." $",Config.red)
  end

end)

-- Add event when a player withdraw money
-- TriggerEvent("esx:withdrawmoneyalert", xPlayer.name, amount) -> new_banking
RegisterServerEvent("esx:withdrawmoneyalert")
AddEventHandler("esx:withdrawmoneyalert", function(name,amount)
   if(settings.LogBankWithdraw)then
    sendToDiscord(_U('server_bank_transfers'),name.." ".._('withdraw').." :$ "..amount .." " .._U('bank'),Config.red)
   end

end)

-- Add event when a player deposit money
-- TriggerEvent("esx:depositmoneyalert", xPlayer.name, amount) -> new_banking
RegisterServerEvent("esx:depositmoneyalert")
AddEventHandler("esx:depositmoneyalert", function(name,amount)
   if(settings.LogBankDeposit)then
    sendToDiscord(_U('server_bank_transfers'),name.." ".._('deposit').." :$ "..amount .." " .._U('bank'),Config.green)
   end

end)

-- Event when a player is writing a tweet
AddEventHandler('chatMessage', function(source, name, message)
  if(settings.LogTweetServer)then
      if message:sub(1, 1) == "/" then
        sm = stringsplit(message, " ");
         if sm[1] == "/twt" then
          local identity = getIdentity(source)
          local nameName = "".. identity.firstname .. " " .. identity.lastname .. "",
             CancelEvent()
             sendToDiscord(nameName,string.sub(message,7),Config.bluetweet)
             --sendToDiscordTweet(_U('server_twitter'), "" .. identity.firstname .. " " .. identity.lastname .." # " .. string.sub(message,7),Config.red)
         end
      end
  end
end)

function stringsplit(inputstr, sep)
  if sep == nil then
      sep = "%s"
  end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      t[i] = str
      i = i + 1
  end
  return t
end

function getIdentity(source)
  local identifier = GetPlayerIdentifiers(source)[1]
  --local result = MySQL.Sync.fetchAll("SELECT * FROM characters WHERE identifier = @identifier", {
local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
      ['@identifier'] = identifier
  })
if result[1] ~= nil then
  local identity = result[1]

  return {
    firstname   = identity['firstname'],
    lastname  = identity['lastname'],
    dateofbirth = identity['dateofbirth'],
    sex   = identity['sex'],
    height    = identity['height']
  }
else
  return {
    firstname   = '',
    lastname  = '',
    dateofbirth = '',
    sex   = '',
    height    = ''
  }
  end
end