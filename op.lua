menu = require('menu')
handler = require('handler')

op = {
    lines = {}
}
function op.run()
    handler.load()
    menu.show()
    while true do
        menu.select()
    end
end

return op
