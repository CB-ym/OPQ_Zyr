--[[
Zyr(自由人)
当前版本1.0.0

--案例参考--
if (data.Content == "QC") then
    SedMsg(CurrentQQ,2353065854,1,"TextMsg",0,"","","","","","",0,"ok")
end

]]--
local Api = require("coreApi")
local http = require("http")
local log = require("log")
local json = require("json")

Pd = "1.0.1" --版本号请忽改动

--发送消息
function SedMsg(CurrentQQ,Data,ToType,MsgType,Groupid,VoiceUrl,VoiceBase64Buf,PicBase64Buf,Md5,PicUrl,FlashPic,Msg)
    ApiRet = Api.Api_SendMsg(
        CurrentQQ,
        {
        toUser = Data,
        sendToType = ToType,
        sendMsgType = MsgType,
        groupid = Groupid,
        content = Msg,
        picBase64Buf = PicBase64Buf, --Base64编码图片
        picMd5s = Md5,--Md5图片
        picUrl = PicUrl, --链接图片
        voiceUrl = VoiceUrl, --发送语音的网络地址 文本型
        voiceBase64Buf = VoiceBase64Buf, --bas64编码语音
        flashPic = FlashPic --是否所发图片是否为发送闪照 true 闪照 false 普通发送
        }
    )
	return ApiRet
end

--群包操作 加群 拉人 退群 移出
function GroupMgr(CurrentQQ,ActionType,GroupID,ActionUserID,Content)
    ApiRet = Api.Api_GroupMgr(
        CurrentQQ,
        {
        ActionType = ActionType, --群操作类型
        GroupID = GroupID, --目标群ID
        ActionUserID = ActionUserID, --移除群的UserID
        Content = Content --加群理由
        }
    )
    return ApiRet
end

--获取QQ好友列表
function GetQQUserList(CurrentQQ, StartIndex)
    return Api.Api_CallFunc(CurrentQQ, "friendlist.GetFriendListReq", {StartIndex = StartIndex})
end

--获取QQ群列表
function GetQQUserList(CurrentQQ, NextToken)
    return Api.Api_CallFunc(CurrentQQ, "friendlist.GetTroopListReqV2", {NextToken = NextToken})
end

--获取群成员
function GetGroupUserList(CurrentQQ, GroupUin, LastUin)
    return Api.Api_CallFunc(CurrentQQ, "friendlist.GetTroopMemberListReq", {GroupUin = GroupUin, LastUin = LastUin})
end

--搜索QQ群组
function SearchGroup(CurrentQQ, Content, Page)
    return Api.Api_CallFunc(CurrentQQ, "OidbSvc.0x8ba_31", {Content = Content, Page = Page})
end

--撤回消息
function RevokeMsg(CurrentQQ, GroupID, MsgSeq, MsgRandom)
    ApiRet = Api.Api_CallFunc(CurrentQQ, "PbMessageSvc.PbMsgWithDraw", {GroupID = GroupID,MsgSeq = MsgSeq,MsgRandom = MsgRandom})
    return ApiRet
end

--群成员禁言
function ShutUp(CurrentQQ, GroupID, ShutUpUserID, ShutTime)
    ApiRet = Api.Api_CallFunc(CurrentQQ, "OidbSvc.0x570_8", {GroupID = GroupID,ShutUpUserID = ShutUpUserID,ShutTime = ShutTime})
    return ApiRet
end

--群全体禁言
function ShutUpAll(CurrentQQ, GroupID, Switch)
    ApiRet = Api.Api_CallFunc(CurrentQQ, "OidbSvc.0x89a_0", {GroupID = GroupID,Switch = Switch})
    return ApiRet
end

--退出指定QQ
function LogOut(CurrentQQ, Flag)
    return Api.Api_LogOut(CurrentQQ, Flag)
end

--获取登录QQ相关ck
function GetUserCook(CurrentQQ)
    return Api.Api_GetUserCook(CurrentQQ)
end

--修改群名片
function ModifyGroupCard(CurrentQQ, GroupID, UserID, NewNick)
    ApiRet = Api.Api_CallFunc(CurrentQQ, "friendlist.ModifyGroupCardReq", {GroupID = GroupID,UserID = UserID,NewNick = NewNick})
    return ApiRet
end

--设置头衔
function SetUniqueTitle(CurrentQQ, GroupID, UserID, NewTitle)
    ApiRet = Api.Api_CallFunc(CurrentQQ, "OidbSvc.0x8fc_2", {GroupID = GroupID,UserID = UserID,NewTitle = NewTitle})
    return ApiRet
end

--QQ超级赞 可达50次
function QQZan(CurrentQQ, UserID) --轮询
    ApiRet = Api.Api_CallFunc(CurrentQQ, "OidbSvc.0x7e5_4", {UserID = UserID})
    return ApiRet
end

--获取任意用户信息昵称头像等
function GetUserInfo(CurrentQQ, UserID)
    return Api.Api_GetUserInfo(CurrentQQ, UserID)
end

--访问url
function GetUrl(url_class,url,caulrt)
    response, error_message =
        http.request(
        url_class,
        url,
        {
            query = caulrt
        }
    )
    html = response.body
    return html
end

--随机数生成
function Random(min,max)
    math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 9)))
    Ran = math.random(min,max)
    return Ran
end

--创建文件夹
function Folder(msg)
    os.execute('mkdir -p '..msg)
end

--读取数据函数
function Read(url)
    file = io.open(url, "r")
	if (file == nil) then
	    return nil
	else
        file:seek("set")
	    str = file:read("*a")
	    file:close()
        return str
	end
end

--写入数据函数
function Wirte(url,msg)
    file = io.open(url, "w+")
    file:write(msg)
	file:close()
    return "ok"
end

--json解析
function JsonDeCode(Data)
    return json.decode(Data)
end

--表转Json
function JsonEnCode(Data)
    return json.encode(Data)
end

--去除指定字符串
function Gsub(msg,str)
    return msg:gsub(str, "")
end

--删除文件
function Dele(filename)
    Rm_file = os.remove(filename)
    if (Rm_file == nil) then
        return "失败"
    else
        return "成功"
    end
end

--打印输出
function Log(msg)
    log.info(msg,"")
end

--添加定时任务
function AddCrons(Robot, Crons, Luaname, FuncTask)
    if (string.find(Crons, "秒")) then
        Str = Gsub(Crons,"秒")
        Crons = "0/"..Str.." * * * * ?"
    elseif (string.find(Crons, "分")) then
        Str = Gsub(Crons,"分")
        Crons = "0 0/"..Str.." * * * ?"
    elseif (string.find(Crons, "时")) then
        Str = Gsub(Crons,"时")
        Crons = "0 0 0/"..Str.." * * ?"
    elseif (string.find(Crons, "天")) then
        Str = Gsub(Crons,"天")
        Crons = "0 0 0 1/"..Str.." * ?"
    end
    Api.Api_AddCrons({
        {
        QQ=Robot,--执行任务的机器人
        Sepc=Crons,--cron表达式 定期执行一次
        FileName=Luaname,--#执行的lua文件名
        FuncName=FuncTask --#执行的lua文件名下的TaskTwo方法名
        }
    })
end

--获取当前时间
function Date(time)
    return os.date(time, os.time())
end

--url编码
function Url_Encode(str)
    if (str) then
        str = string.gsub(str, "\n", "\r\n")
        str =
            string.gsub(
            str,
            "([^%w ])",
            function(c)
                return string.format("%%%02X", string.byte(c))
            end
        )
        str = string.gsub(str, " ", "+")
    end
    return str
end

--At处理,0表示at全体
function At(at)
    if (at == 0) then
        Str = "[ATALL()]"
    else
        Str = "[ATUSER("..at..")]"
    end
    return Str
end
