function cafe --description 'Toggle caffeinate and refresh starship'
    # 只認 cafe 自己開的那隻 caffeinate。
    # 不能用 `pgrep -x caffeinate`：Claude Code 等工具也會開 `caffeinate -i -t 300`，
    # 會害這個 toggle 反向（誤判成已開啟而去 killall），圖示也會誤亮。
    set -l pidfile "$HOME/.cache/cafe.pid"
    set -l pid (cat $pidfile 2>/dev/null)

    if test -n "$pid"; and test (ps -o comm= -p $pid 2>/dev/null | string match -r 'caffeinate')
        kill $pid 2>/dev/null
        rm -f $pidfile
        echo "☕️ Sleep mode restored."
    else
        # 使用 -di 確保螢幕跟系統都不睡
        command caffeinate -di >/dev/null 2>&1 &
        set -l new_pid $last_pid
        disown
        mkdir -p (dirname $pidfile)
        echo $new_pid >$pidfile
        echo "☕️ Coffee time! Computer awake."
    end

    # 關鍵：發送訊號給 shell 重新繪製 Prompt
    # 這樣咖啡圖示才會立刻出現或消失
    commandline -f repaint
end
