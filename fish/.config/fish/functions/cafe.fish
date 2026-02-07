function cafe --description 'Toggle caffeinate and refresh starship'
    if pgrep -x "caffeinate" > /dev/null
        killall caffeinate
        echo "☕️ Sleep mode restored."
    else
        # 使用 -di 確保螢幕跟系統都不睡
        command caffeinate -di > /dev/null 2>&1 & disown
        echo "☕️ Coffee time! Computer awake."
    end

    # 關鍵：發送訊號給 shell 重新繪製 Prompt
    # 這樣咖啡圖示才會立刻出現或消失
    commandline -f repaint
end
