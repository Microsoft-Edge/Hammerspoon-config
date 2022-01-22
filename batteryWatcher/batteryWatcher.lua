
local current = hs.audiodevice.defaultOutputDevice():volume()

-- 使用原有音量
function setWarn(speckstring)
    muted = hs.audiodevice.defaultOutputDevice():muted()
    local volumeSet = true
    if muted == true then
        hs.audiodevice.defaultOutputDevice():setMuted(false)
    end
    print(current)
    if current < 25 then
        hs.audiodevice.defaultOutputDevice():setVolume(25)
        volumeSet =false
    end
    speaker = hs.speech.new()
    speaker:speak(speckstring)
    print(hs.audiodevice.defaultOutputDevice():volume())
    hs.timer.doAfter(6, function()
        print("播放完成,还原设置")
        if muted == true then
            hs.audiodevice.defaultOutputDevice():setMuted(true)
            print("重新静音")
        end
        if volumeSet == false then
            hs.audiodevice.defaultOutputDevice():setVolume(current)
        end
    end)
end

-- 调节音量，但不可高于40
function changeVolume(diff,speckstring)
    current = hs.audiodevice.defaultOutputDevice():volume()
    local new = math.min(100, math.max(0, math.floor(current + diff)))
    local next = current+new
    if (next > 40) then
        new = 30
    end
    if new > 0 then
        hs.audiodevice.defaultOutputDevice():setMuted(false)
    end
    hs.audiodevice.defaultOutputDevice():setVolume(new)
    speaker = hs.speech.new()
    speaker:speak(speckstring)
    hs.timer.doAfter(6, function()
        hs.audiodevice.defaultOutputDevice():setVolume(current)
    end)
end

function batt_watch_changed()
    pct = hs.battery.percentage()
    if not hs.battery.isCharging() and pct < 32 then
        -- changeVolume(30,"警告,请充电,电量已低于32%")
        -- setWarn("警告,请充电,电量已低于32%")
        setWarn(string.format("警告,请充电,电量已低至%d%%", pct))
        hs.alert.show(string.format("需要充电，还有%d%% !!", pct),hs.alert.defaultStyle,hs.screen.mainScreen(),5)
        hs.notify.new({title = "⚠️充电警告",informativeText = string.format("⚠️电量已低至%d%%", pct)}):send()
    else if hs.battery.isCharging() and pct > 82 then
        -- changeVolume(30, "警告,请停止充电,已充至82%")
        -- setWarn("警告,请停止充电,已充至82%")
        setWarn(string.format("警告,请停止充电,已充至%d%%", pct))
        hs.alert.show(string.format("已充%d%%，请停止充电 !!", pct),hs.alert.defaultStyle,hs.screen.mainScreen(),5)
        hs.notify.new({title = "⚠️充电警告",informativeText = string.format("⚠️已充电至%d%%", pct)}):alwaysPresent(true):send()
        -- hs.execute("curl https://api.day.app/xxxxxx/MBP14/BatteryEnough\\?level=timeSensitive\\&group=macBattery\\&sound=shake")
    end
    end
end
-- hs.battery.watcher.new(batt_watch_changed):start()
batteryWatcher = hs.battery.watcher.new(batt_watch_changed)
batteryWatcher:start() -- 开始监控
