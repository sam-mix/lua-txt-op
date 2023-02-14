require('lib')

handler = {
    lines = {},
    offset = 1,
    pageSize = 10, 
    allLineNum = 0,
    singleLine = 1,
    fileNameFull = "";
}

function handler.load() 
    print("请输入要操作的文件名,不必给出扩展名(例如:name,test,ssa 默认为text，不要出现/,存储在./out路径下):")
    fileName = trim(io.read())
    if fileName == '' then
        fileName = 'test'
    end
    handler.fileNameFull = string.format("./out/%s.txt", fileName)
    tempFile = io.open(handler.fileNameFull, 'r')
    if tempFile == nil then
        f = io.open(handler.fileNameFull, 'w')
        f:flush()
        f:close()
    end
    count = 0
    for line in io.lines(handler.fileNameFull) do
        table.insert(handler.lines, line)
        count=count+1
    end 
    handler.allLineNum = count
end

-- 读取文件
function handler.read()
    while (true) do
        os.execute("clear")
        printTitle()
        for i = handler.offset, math.min(handler.offset+handler.pageSize - 1, handler.allLineNum), 1 do
            printContent(i)
        end
        printBottom()
        print(string.format("最大行号:%d,显示起始行号:%d,显示页面大小:%d",handler.allLineNum,handler.offset,handler.pageSize))
        print([[设置起始行号输入b,设置显示页面大小输入s,上一页输入p,显示下一页输入n,既要设置页面大小又要设置起始行号输入a]])
        op = io.read()
        if op == '' then
            handler.offset=handler.offset % handler.allLineNum +1
            os.execute("clear")
        elseif op=='n' then
            handler.offset = handler.offset + handler.pageSize
            os.execute("clear")
        elseif op == 'b' then
            print("请输入起始行号,当前最大行号为:"..handler.allLineNum)
            s=io.read()
            p = tonumber(s)
            if p == nil or p <= 0 then
                goto s_continue
            end
            if p + handler.pageSize > handler.allLineNum then 
                p = handler.allLineNum - handler.pageSize + 1;
            end
            if p <= 0 then
                p = 1
            end
            handler.offset = p
            ::s_continue::
        elseif op == 's' then
            print("请输入页面大小:")
            s=io.read()
            p = tonumber(s)
            if p == nil or p <= 0 then
                goto p_continue
            end
            os.execute("clear")
            handler.pageSize = p
            ::p_continue::
        elseif op == 'a' then
            print("请输入起始行号,当前最大行号为:"..handler.allLineNum)
            s=io.read()
            p = tonumber(s)
            if p == nil or p <= 0 then
                goto a_continue
            end
            if p + handler.pageSize > handler.allLineNum then 
                p = handler.allLineNum - handler.pageSize + 1;
            end
            if p <= 0 then
                p = 1
            end
            handler.offset = p
            print("请输入页面大小:")
            s=io.read()
            p = tonumber(s)
            if p == nil or p <= 0 then
                goto a_continue
            end
            os.execute("clear")
            handler.pageSize = p
            ::a_continue::
        elseif op == 'q' then
            print("再次输入回车展示主菜单")
            break
        elseif op == 'p' then
            handler.offset = handler.offset - handler.pageSize
            if handler.offset <= 0 then 
                handler.offset = 1
            end
        end

    end
end

function printTitle()
    print(string.format("行号    |内容"))
    print(string.format("________|______________________________________________________________________________________________________"))
end

function printContent(i) 
    content = handler.lines[i]
    if content == nil then
        content = ''
    end
    print(string.format("%-8d|%s",i,content))
end

function printBottom()
    print(string.format("________|______________________________________________________________________________________________________"))
end

-- 读取 指定 行 内容
function handler.readLineContent()
    print("=====================读取 指定 行 内容=====================")
    if handler.allLineNum <= 0 then 
        print("当前文件没有任何内容，快选择其他功能向文件里添加更多内容吧！！！")
        return
    end
    while true do
        print(string.format("请输入要查看的行号,当前最大行号为:%d,输入范围为[1,%d],直接回车从直接展示下一行, q退出子菜单",handler.allLineNum,handler.allLineNum))
        s = trim(io.read())
        if s == 'q' then
            print("再次回车展示主菜单")
            break
        end
        if s == '' then
            goto continue_1
        end
        i = tonumber(s)
        if i == nil or i <= 0 or i > handler.allLineNum then
            goto continue
        end
        handler.singleLine = i
        ::continue_1::
        printTitle()
        printContent(handler.singleLine)
        printBottom()
        ::continue::
        handler.singleLine = handler.singleLine % handler.allLineNum + 1
    end
end

-- 读取 指定 内容 行
function handler.readContentLine()
    print("=====================读取 指定 内容 行=====================")
    while true do
        list = {}
        print("请输入您要查找的内容:")
        pattern = io.read()
        for i = 1, handler.allLineNum, 1 do
            if string.match(handler.lines[i],pattern) ~= nil then
                table.insert(list, i)
            end
        end
        printTitle()
        for _, i in pairs(list) do
            printContent(i)
        end
        printBottom()
        print("q返回主菜单,直接回车继续")
        op = io.read()
        if op == 'q' then
            print("再次输入回车展示主菜单")
            break
        end
    end
end

-- 插入 指定 行 内容
function handler.insertLineContent()
    print("=====================插入 指定 行 内容=====================")
    while true do
        print("输出插入的行号,输入q退出:")
        s = io.read()
        if s == 'q' then 
            print("输入回车显示主菜单")
            break
        end
        num = tonumber(s)
        if num == nil or num < 1 then
            goto continue
        end
        print("输入写入的内容:")
        content = io.read()
        if num > handler.allLineNum then
            handler.allLineNum = num
            handler.lines[num] = content
        else
            table.insert(handler.lines, num, content)
            handler.allLineNum = handler.allLineNum + 1
        end
        
        ::continue::
    end
end

-- 插入 指定 内容 前
function handler.insertContentBefore()
    print("=====================插入 指定 内容 前=====================")
    while true do
        print("输入指定内容")
        findStr = io.read()
        print("输入要插入的内容")
        replaceStr = io.read()
        replaceStr = replaceStr .. findStr
        for i, content in pairs(handler.lines) do
            handler.lines[i] = string.gsub(content, findStr, replaceStr)
        end
        print("输入q并回车退出")
        if s == 'q' then
            print("回车显示主菜单")
            break
        end
    end
end

-- 插入 指定 内容 后
function handler.insertContentAfter()
    print("=====================插入 指定 内容 后=====================")
    while true do
        print("输入指定内容")
        findStr = io.read()
        print("输入要插入的内容")
        replaceStr = io.read()
        replaceStr =  findStr .. replaceStr
        for i, content in pairs(handler.lines) do
            handler.pairs[i] = string.gsub(content, findStr, replaceStr)
        end
        print("输入q并回车退出")
        if s == 'q' then
            print("回车显示主菜单")
            break
        end
    end
end

-- 删除 指定 行 内容
function handler.deleteLineContent()
    print("=====================删除 指定 行 内容=====================")
    while true do
        print("输入要删除的行号, q 退出")
        s = io.read()
        if s == 'q' then
            print("回车显示主菜单")
            break
        end
        num = tonumber(s)
        if num == nil or num < 1 or num > handler.allLineNum then
            goto continue
        end
        table.remove(handler.lines, num)
        handler.allLineNum = handler.allLineNum - 1
        ::continue::
    end
end

-- 删除 指定 内容 行
function handler.deleteContentLine()
    print("=====================删除 指定 内容 行=====================")
    while true do

        print("输入指定内容, q 退出")
        pattern = io.read()
        if pattern == 'q' then
            print("回车显示主菜单")
            break
        end
        num = 0
        for i = handler.allLineNum,1,-1 do
            if contain(handler.lines[i], pattern) then
                table.remove(handler.lines, i)
                num = num + 1
            end 
        end
        handler.allLineNum = handler.allLineNum - num
        ::continue::
    end
end

-- 检测文件行是否包含指定内容
function handler.checkLineContain()
    print("=====================检测文件行是否包含指定内容=====================")
    while true do
        print("输入要检测的文件行号")
        num = tonumber(io.read())
        if num == nil or num < 1 or num > handler.allLineNum then
            goto continue
        end
        print("输入指定内容:")
        content = io.read()
        question = string.format("%d行文本【%s】是否包含【%s】:",num,handler.lines[num],content)
        ans = question
        if contain(handler.lines[num], content) then
            ans = ans.."是"
        else 
            ans = ans.."否"
        end
        print(ans)
        print("输入q回到主菜单")
        op = io.read()
        if op == 'q' then
            break
        end
        ::continue::
    end
end

function contain(content, pattern)
    if pattern == nil or pattern == '' then
    return true
    end
    if content == nil or content == '' then
    return false
    end
    return string.find(content,pattern,1,true) ~= nil
end

-- 保存文件
function handler.save()
    print("=====================保存文件=====================")
    contentAll = ''
    i = 1
    for num, content in pairs(handler.lines) do
        for n = i,num - 1,1 do
            contentAll = contentAll..''..'\n'
            i = i + 1
        end
        i = i + 1
        contentAll = contentAll..content..'\n'
    end
    file = io.open(handler.fileNameFull,"w+")
    if file == nil then
        print("文件打开失败")
    end
    file:write(contentAll)
    file:flush()
    file:close()
end

-- 退出 exit or quit
function handler.exit() 
    os.execute('clear')
    print('欢迎下次使用,再见!')
    os.exit()
end

-- 找不到对应处理办法
function handler.notFound(num)  
    print("哎呀！！出错了呢，指令"..num.."没有找到对应的功能，可以联系客服进行添加哦！！！！")
end

return handler
