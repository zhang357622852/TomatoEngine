--[[
     继承至BaseLayer(一个透明图层，并且屏蔽下层的消息)  
     
    registerWithSafeArea()----点击非图片区域会关闭此图层
    
    注意：
        1.安全区域层的模板node的锚点是cc.p(0.5, 0.5)--这里为了不写太多的if-elseif的句子，如果有需求多的话再增加
--]]

PopupLayer = class("PopupLayer", function() return BaseLayer.create() end)

function PopupLayer.create()
    local layer = PopupLayer.new()

    return layer
end

function PopupLayer:ctor()
    self.popupLayer = nil
end

function PopupLayer:registerWithSafeArea(node)
    
    if self._popupLayer then
        print("you have recently registered a SafeArea")
    else
        local layer = cc.Layer:create()
        layer:setContentSize(node:getBoundingBox().width, node:getBoundingBox().height) --要考虑到这个节点可能被缩放了
        layer:setAnchorPoint(cc.p(0, 0))       
        layer:setPosition(node:getPositionX()-node:getBoundingBox().width/2, node:getPositionY()-node:getBoundingBox().height/2)
        self:addChild(layer)
        
        local function onTouchBegan(touch, event)
            local pos = touch:getLocation()
            local box = layer:getBoundingBox()
            
            if cc.rectContainsPoint(box, pos) then
                return false
            else
                return true
            end
        end
        
        local function onTouchEnded(touch, event)
            self:close()
        end
        
        local listener = cc.EventListenerTouchOneByOne:create()
        listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
        listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
        
        local disp = layer:getEventDispatcher()
        disp:addEventListenerWithSceneGraphPriority(listener, layer)
    end    
	
end