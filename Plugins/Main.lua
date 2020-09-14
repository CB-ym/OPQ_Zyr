--[[
    友善提示：此插件为Zyr自由人入口文件，请忽擅自修改，任何问题请反馈给逸梦
]]--
require("OPQApi")

function ReceiveFriendMsg(CurrentQQ, data)
    --导入插件
    if (data.Content == "导入插件") then
        Dm = GetUrl("GET","http://47.111.230.167/Zyr/Data/Conf.zyr","")
        if (Pd == Dm) then --检测版本号
            Dm = GetUrl("GET","http://47.111.230.167/Zyr/Data/io.php","robot="..CurrentQQ) --返回标识名
            if (Dm == "失败") then
                SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","你的库里没有可导入的插件咯~")
                return 1
            end
            Cj = GetUrl("GET","http://47.111.230.167/Zyr/Data/Zyr.php","robot="..CurrentQQ) --返回插件代码
            Djson = JsonDeCode(Dm)
            Wirte("lua/"..Djson.io.."/"..Djson.file..".lua",Cj)
            OIO = Read("lua/"..Djson.io..".json") --json{"num":0,"zyr":[{"file":"zhangsan.lua"},{"file":"zhangsan.lua"},{"file":"zhangsan.lua"}]}
            Ojson = JsonDeCode(OIO)
            if (Ojson.num ~= 0) then
                for i, v in pairs(Ojson.zyr) do --查询插件是否存在
                    if (v.file == Djson.file) then --存在则更新插件完毕
                        SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","更新成功！\n插件名:"..Djson.name.."\n插件作者:"..Djson.author.."\n插件版本:"..Djson.version.."\n插件类型:"..Djson.io)
                        return 1
                    end
                end
            end
            Ojson.num = Ojson.num + 1
            Ojson.zyr[Ojson.num] = {file = Djson.file,is = "启用"}
            D = JsonEnCode(Ojson)
            Wirte("lua/"..Djson.io..".json",D)
            SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","导入成功！\n插件名:"..Djson.name.."\n插件作者:"..Djson.author.."\n插件版本:"..Djson.version.."\n插件类型:"..Djson.io)
        else
            SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","检测到有新版本\n当前版本："..Pd.."\n最新版本："..Dm.."\n请先将Zyr更新到最新版本")
        end
        return 1
    end

    --导入插件，检索定时器，有定时器

    --禁用插件
    if (string.find(data.Content, "^禁用插件")) then
        Str = Gsub(data.Content,"禁用插件")
        Msg = State("禁用","Group",Str)
        if (Msg == "error") then
            SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","∴当前插件本就处于禁用状态")
            return 1
        elseif (Msg == "ok") then
            SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","∴插件禁用成功！")
            return 1
        end
        Msg = State("禁用","Friend",Str)
        if (Msg == "error") then
            SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","∴当前插件本就处于禁用状态")
            return 1
        elseif (Msg == "ok") then
            SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","∴插件禁用成功！")
            return 1
        end
        Msg = State("禁用","Events",Str)
        if (Msg == "error") then
            SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","∴当前插件本就处于禁用状态")
        elseif (Msg == "ok") then
            SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","∴插件禁用成功！")
        elseif (Msg == nil) then
            SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","∴此插件不存在，请查看插件标识是否正确")
        end
    end

    --启用插件
    if (string.find(data.Content, "^启用插件")) then
        Str = Gsub(data.Content,"启用插件")
        Msg = State("启用","Group",Str)
        if (Msg == "error") then
            SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","∴当前插件本就处于启用状态")
            return 1
        elseif (Msg == "ok") then
            SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","∴插件启用成功！")
            return 1
        end
        Msg = State("启用","Friend",Str)
        if (Msg == "error") then
            SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","∴当前插件本就处于启用状态")
            return 1
        elseif (Msg == "ok") then
            SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","∴插件启用成功！")
            return 1
        end
        Msg = State("启用","Events",Str)
        if (Msg == "error") then
            SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","∴当前插件本就处于启用状态")
        elseif (Msg == "ok") then
            SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","∴插件启用成功！")
        elseif (Msg == nil) then
            SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","∴此插件不存在，请查看插件标识是否正确")
        end
    end

    --删除插件
    if (string.find(data.Content, "^删除群聊插件")) then
        Str = Gsub(data.Content,"删除群聊插件")
        OIO = Read("lua/Group.json")
        if (string.find(OIO, Str)) then
            GetUrl("GET","http://47.111.230.167/Zyr/zyrdata.php","file="..Str.."&io=Dele")
            Ojson = JsonDeCode(OIO)
            Ojson.num = Ojson.num - 1
            Dstr = JsonEnCode(Ojson)
            if (Ojson.zyr[1].file == Str) then
                Zyr = Gsub(Dstr,'{"file":"'..Str..'"},')
            else
                Zyr = Gsub(Dstr,',{"file":"'..Str..'"}')
            end
            Rm_file = os.remove("lua/Group/"..Str..".lua")
            Wirte("lua/Group.json",Zyr)
            SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","已删除插件:"..Str)
        else
            SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","不存在这个插件，看看插件标识是否对了")
        end
        return 1
    elseif (string.find(data.Content, "^删除私聊插件")) then
        Str = Gsub(data.Content,"删除私聊插件")
        OIO = Read("lua/Friend.json")
        if (string.find(OIO, Str)) then
            GetUrl("GET","http://47.111.230.167/Zyr/zyrdata.php","file="..Str.."&io=Dele")
            Ojson = JsonDeCode(OIO)
            Ojson.num = Ojson.num - 1
            Dstr = JsonEnCode(Ojson)
            if (Ojson.zyr[1].file == Str) then
                Zyr = Gsub(Dstr,'{"file":"'..Str..'"},')
            else
                Zyr = Gsub(Dstr,',{"file":"'..Str..'"}')
            end
            Rm_file = os.remove("lua/Friend/"..Str..".lua")
            Wirte("lua/Friend.json",Zyr)
            SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","已删除插件:"..Str)
        else
            SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","不存在这个插件，看看插件标识是否对了")
        end
        return 1
    elseif (string.find(data.Content, "^删除事件插件")) then
        Str = Gsub(data.Content,"删除事件插件")
        OIO = Read("lua/Events.json")
        if (string.find(OIO, Str)) then
            GetUrl("GET","http://47.111.230.167/Zyr/zyrdata.php","file="..Str.."&io=Dele")
            Ojson = JsonDeCode(OIO)
            Ojson.num = Ojson.num - 1
            Dstr = JsonEnCode(Ojson)
            if (Ojson.zyr[1].file == Str) then
                Zyr = Gsub(Dstr,'{"file":"'..Str..'"},')
            else
                Zyr = Gsub(Dstr,',{"file":"'..Str..'"}')
            end
            Rm_file = os.remove("lua/Events/"..Str..".lua")
            Wirte("lua/Events.json",Zyr)
            SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","已删除插件:"..Str)
        else
            SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","不存在这个插件，看看插件标识是否对了")
        end
        return 1
    end

    --更新Zyr
    if (data.Content == "更新zyr") then
        Dm = GetUrl("GET","http://47.111.230.167/Zyr/Data/Conf.zyr","") --获取最新版本
        if (Pd == Dm) then --检测版本号
            SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","当前Zyr版本为最新版，无需更新")
        else
            Dm = GetUrl("GET","http://47.111.230.167/Zyr/Data/OPQApi.zyr","")
            Wirte("lua/OPQApi.lua",Dm)
            Bm = GetUrl("GET","http://47.111.230.167/Zyr/Data/Main.zyr","")
            if (Bm ~= "null") then
                Wirte("Main.lua",Bm)
            end
            SedMsg(CurrentQQ,data.FromUin,1,"TextMsg",0,"","","","","","","更新成功！\n".."当前版本:"..Dm)
        end
        return 1
    end

    --重量级插件入口，如果你的分量不够，本大大不建议擅自修改哦
    OIO = Read("lua/Friend.json") --json{"num":0,"zyr":[{"file":"zhangsan.lua"},{"file":"zhangsan.lua"},{"file":"zhangsan.lua"}]}
    Ojson = JsonDeCode(OIO)
    if (Ojson.num ~= 0) then
        for i, v in pairs(Ojson.zyr) do --将插件以库的行式逐个导入，运行速度与正常插件无差别，后续加入优先级
            if (v.is == "启用") then
                require("Friend."..v.file)
                ZyrMain(data.Content,data.FromUin,data.MsgType,data.MsgSeq,CurrentQQ)
            end
        end
    end
    return 1
end

function ReceiveGroupMsg(CurrentQQ, data)
    --重量级插件入口，如果你的分量不够，本大大不建议擅自修改哦
    OIO = Read("lua/Group.json") --json{"num":0,"zyr":[{"file":"zhangsan.lua"},{"file":"zhangsan.lua"},{"file":"zhangsan.lua"}]}
    Ojson = JsonDeCode(OIO)
    if (Ojson.num ~= 0) then
        for i, v in pairs(Ojson.zyr) do
            if (v.is == "启用") then
                require("Group."..v.file)
                ZyrMain(data.Content,data.FromGroupId,data.FromGroupName,data.FromUserId,data.FromNickName,data.MsgType,data.MsgSeq,data.MsgTime,data.MsgRandom,CurrentQQ)
            end
        end
    end
    return 1
end

function ReceiveEvents(CurrentQQ, data, extData)
    --系统事件还未加入，后续加入
    --重量级插件入口，如果你的分量不够，本大大不建议擅自修改哦
    --[[OIO = Read("lua/Events.json") --json{"num":0,"zyr":[{"file":"zhangsan.lua"},{"file":"zhangsan.lua"},{"file":"zhangsan.lua"}]}
    Ojson = JsonDeCode(OIO)
    if (Ojson.num ~= 0) then
        for i, v in pairs(Ojson.zyr) do
            if (v.is == "启用") then
                --require("Events."..v.file)
                --ZyrMain(data.Content,data.FromGroupId,data.FromGroupName,data.FromUserId,data.FromNickName,data.MsgType,data.MsgSeq,data.MsgTime,data.MsgRandom,CurrentQQ)
            end
        end
    end]]--
    return 1
end