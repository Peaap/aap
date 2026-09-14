-- Legion 7.3.5 UI compatibility shim.
-- AceGUI Window is a widget wrapper; do not call SetScale on it.
AAP = AAP or {}
AAP.UI = AAP.UI or {}

function AAP.UI:ApplyWindowSettings()
    local s = AAP3 and AAP3.UI or {}
    local window = self._window
    if not window then return end

    if s.width then window:SetWidth(s.width) end
    if s.height then window:SetHeight(s.height) end

    if window.frame then
        if window.frame.SetAlpha and s.opacity then
            window.frame:SetAlpha(s.opacity)
        end
        if window.frame.SetMovable then
            window.frame:SetMovable(not s.locked)
        end
        if window.frame.EnableMouse then
            window.frame:EnableMouse(true)
        end
    end

    if window.frame then
        window.frame:ClearAllPoints()
        window.frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", s.x or 0, s.y or 0)
    end
end
