handler = require('handler')

menu = {}

local m = [[
==============================菜单=============================
                    0 --- 读取文件
                    1 --- 读取 指定 行 内容
                    2 --- 读取 指定 内容 行
                    3 --- 插入 指定 行 内容
                    4 --- 插入 指定 内容 前
                    5 --- 插入 指定 内容 后
                    6 --- 删除 指定 行 内容
                    7 --- 删除 指定 内容 行
                    8 --- 检测文件行是否包含指定内容
                    9 --- 保存文件
                    q --- 退出 exit or quit
===============================================================
请输入对应功能的编号(1-9,q):]]

function menu.show()
    os.execute("clear")
    print(m)
end

function menu.select() 
    num = trim(io.read())
    if num == '0' then
        handler.read()
    elseif num == '1' then
        handler.readLineContent()
    elseif num == '2' then 
        handler.readContentLine()
    elseif num == '3' then
        handler.insertLineContent()
    elseif num == '4' then
        handler.insertContentBefore()
    elseif num == '5' then
        handler.insertContentAfter()
    elseif num == '6' then
        handler.deleteLineContent()
    elseif num == '7' then 
        handler.deleteContentLine()
    elseif num == '8' then
        handler.checkLineContain()
    elseif num == '9' then
        handler.save()
    elseif num == 'q' then
        handler.exit()
    elseif num == '' then
        menu.show()
    else
        handler.notFound(num)
    end
end

return menu
