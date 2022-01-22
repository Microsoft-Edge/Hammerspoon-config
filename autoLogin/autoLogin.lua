local cmdArr =
    {"cd /Users/zqzess/AutoScripts/autoLogin/shell/ && source main.sh >> /Users/zqzess/Cache/autoLogin/cache/log.txt"}

function shell(cmd)
        os.execute("cd /Users/zqzess/AutoScripts/autoLogin/shell/ && sh  /Users/zqzess/AutoScripts/autoLogin/shell/main.sh >> /Users/zqzess/Cache/autoLogin/cache/log.txt")
end

function ssidChangedCallback() -- 回调
    ssid = hs.wifi.currentNetwork() -- 获取当前 WiFi ssid
    if (ssid ~= nil) then
        if (ssid == 'Njtech-Home') then
            os.execute("cd /Users/zqzess/AutoScripts/autoLogin/shell/ && sh  /Users/zqzess/AutoScripts/autoLogin/shell/start.sh >> /Users/zqzess/Cache/autoLogin/cache/start.log") -- 执行自动登录脚本
                        hs.notify.new({
                title = "wifi切换",
                informativeText = "Njtech-Home自动化登录完成"
            }):send() -- 发出通知
        elseif (ssid == 'Njtech') then
            os.execute("cd /Users/zqzess/AutoScripts/autoLogin/shell/ && sh  /Users/zqzess/AutoScripts/autoLogin/shell/start.sh >> /Users/zqzess/Cache/autoLogin/cache/start.log") -- 执行自动登录脚本
                        hs.notify.new({
                title = "wifi切换",
                informativeText = "Njtech自动化登录完成"
            }):send() -- 发出通知
        else
            -- hs.notify.new({
            --     title = "wifi切换",
            --     informativeText = "无需切换"
            -- }):send()
        end
    end
end

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start() -- 开始监控
