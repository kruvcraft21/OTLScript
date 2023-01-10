gs = _G or _ENV
pageMemory = pageMemory or 0
math.randomseed(os.time())
lang = {
    ['ru'] = {
        'ОГРОМНЫЙ УРОН',
        'БЕССМЕРТИЕ',
        'ИЗМЕНИТЬ ОРУЖИЕ',
        'УБРАТЬ ПЕРЕЗАРЯДКУ НАВЫКОВ',
        'УСТАНОВИТЬ КОЛИЧЕСТВО МОНЕТ',
        'СЛОМАТЬ ПРЕДМЕТЫ В МАГАЗИНЕ',
        'РАЗБЛОКИРОВАТЬ ВСЕ СТИЛИ ЛОББИ',
        'СДЕЛАТЬ ВСЕХ ПИТОМЦЕВ ДРУЖЕЛЮБНЫМИ',
        '(ОПАСНО) ИЗМЕНИТЬ КОЛИЧЕСТВО ФРАГМЕНТОВ СТИЛЯ',
        'ЗАВЕРШИТЕ ВСЕ ДОСТИЖЕНИЯ',
        'ПОЛУЧИТЬ НАГРАДУ ЗА ДОСТИЖЕНИЯ',
        'ВЫПОЛНИТЬ ВСЕ ДНЕВНЫЕ ПОРУЧЕНИЯ',
        'ДНЕВНЫЕ НАГРАДЫ X5',
        '(ОПАСНО) УСТАНОВИТЬ ОЧКИ АСУРЫ',
        'ВЫХОД'
    },
    ['en_US'] = {
        'HUGE DAMAGE',
        'IMMORTALITY',
        'CHANGE WEAPON',
        'REMOVE SKILL COOLDOWN',
        'SET COIN COUNT',
        'BREAK ITEMS IN THE STORE',
        'UNLOCK ALL STYLE LOBBY',
        'MAKE ALL PETS FRIENDLY',
        '(DANGEROUS) CHANGE THE NUMBER OF STYLE FRAGMENTS',
        'COMPLETE ALL ACHIEVEMENTS',
        'GET A REWARD FOR ACHIEVEMENTS',
        'COMPLETE ALL DAILY ERRANDS',
        'DAILY REWARDS X5',
        '(DANGEROUS) SET ASURA POINTS',
        'EXIT'
    },
}
langClass = {
    ['ru'] = {
        GameProcess = 'Игровой процесс найден',
        PlayerArchive = 'Данные игрока найдены',
        DailyActivityComponent = 'Дневыне задачи найдены',
        DailyActivityView = 'Дневыне задачи найдены',
        DataManager = 'Менеджер данных найден',
        ProductPrice = "Цены предметов найдены",
        Weapon = 'Оружие было найдено',
        UnitSpawn = 'Средства спавна были найдены',
        PropertiesSystemLib = 'Свойства найдены',
        Hero = "Герой найден",
        AchievementManager = "Достижения были найдены",
        MenuSkinUI = "Меню было найдено",
        AppNoSK = 'Выбранный процесс не является игрой Soul knight',
        ErrorData = 'Скрипт будет работать некорректно',
        ManualSK = 'Прочтите инструкцию по установке VMOS Pro для корректной работы скрипта',
        Emtry = 'Пусто',
        ErrorLib = 'Game Guardian не нашёл нужную библиотеку. Скрипт запустится, но будет работать частично некорректно',
        ErrorAlert = 'При выполнении функции произошла ошибка',
    },
    ['en_US'] = {
        GameProcess = 'Game Process found',
        PlayerArchive = 'Player data found',
        DailyActivityComponent = 'Daily tasks found',
        DailyActivityView = 'Daily tasks found',
        DataManager = 'Data manager found',
        Weapon = 'The weapon was found',
        UnitSpawn = 'Spawn funds have been found',
        PropertiesSystemLib = 'Properties found',
        Hero = "The hero is found",
        AchievementManager ="Achievements have been found",
        MenuSkinUI = "Menu was found",
        AppNoSK = 'The selected process is not a Soul knight game',
        ErrorData = 'The script will not work correctly',
        ManualSK = 'Read the instructions for installing VMOS Pro for the script to work correctly',
        Emtry = 'Emtry',
        ErrorLib = "Game Guardian didn't find the right library. The script will run, but it will work partially incorrectly",
        ErrorAlert = 'An error occurred while executing the function',
    },
}

lang_main = setmetatable(lang[gg.getLocale()] or lang['en_US'], {__index = langClass[gg.getLocale()] or langClass['en_US']})

Utf16 = {}

for s in string.gmatch('АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя', "..") do
    local char = gg.bytes(s,'UTF-16LE')
    Utf16[char[1] + (char[2] * 256)] = s
end

for s in string.gmatch("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_/0123456789-'", ".") do
    local char = gg.bytes(s,'UTF-16LE')
    Utf16[char[1] + (char[2] * 256)] = s
end

function switch(check, table, e, ...)
    return ({
        xpcall(
            table[check],
            function ()
                return table[check] or (
                    function()
                        if type(e) ~= 'function' then return e end
                        return e()
                    end
                )()
            end,
            ...
        )
    })[2]
end

Protect = {
    ErrorHandler = function(err)
        gg.alert(lang_main['ErrorAlert'])
        print(err)
    end,
    Call = function(self, fun, ...) 
        return ({xpcall(fun, self.ErrorHandler, ...)})[2]
    end
}

function CheckTableIsNil(t)
    if (not t) or type(t) ~= 'table' or #t == 0 then return true end
    for k,v in pairs(t) do
        if (not v) or v == '' then return true end
    end
    return false
end

function GetNameTableInGlobalSpace(table)
    for k,v in pairs(gs) do
        if v == table then return k end
    end
    return ""
end

function GetInfoFropApps()
    local data = gg.getRangesList('global-metadata.dat') 
    local il2cpp = gg.getRangesList('libil2cpp.so')
    local info = gg.getTargetInfo()
    if info then return info.x64, data end
    if #il2cpp ~= 0 then
        local check = string.gsub(il2cpp[1].internalName,'%/.-%/lib/','')
        check = switch(check,{
            ['arm64/libil2cpp.so'] = true,
            ['arm/libil2cpp.so'] = false
        })
        if check ~= nil then return data, check, il2cpp end
    end
    return nil, nil, nil
end

function GetAppData()
    local info = gg.getTargetInfo()
    if not info then 
        info = gg.alert(lang_main.ErrorData .. "\n" .. lang_main.ManualSK, 'OK', 'COPY LINK')
        if info == 2 then gg.copyText('http://crusher.ucoz.net/index/manual/0-6') end
        return GetInfoFropApps()
    end
    return gg.getRangesList('global-metadata.dat'), info.x64, gg.getRangesList('libil2cpp.so')
end

data, platform, libil = GetAppData()

if #libil == 0 then
    local splitconf = gg.getRangesList('split_config.')
    gg.setRanges(gg.REGION_CODE_APP)
    for k,v in ipairs(splitconf) do
        if (v.state == 'Xa') then
            gg.searchNumber(':il2cpp',gg.TYPE_BYTE,false,gg.SIGN_EQUAL,v.start,v['end'])
            if (gg.getResultsCount() > 0) then
                libil[#libil + 1] = v
            end
            gg.clearResults()
        end
    end
end

function setupValues(gf,gm,typeset)
    gg.setValues({{address = gf,flags = typeset and typeset or gg.TYPE_DWORD,value = gm:gsub('.', function (c) return string.format('%02X', string.byte(c)) end)..'r'}})
end

function Il2CppName(NameFucntion)
    local FinalMethods, name = {}, "00 " .. NameFucntion:gsub('.', function (c) return string.format('%02X', string.byte(c)) .. " " end) .. "00"
    gg.clearResults()
    gg.setRanges(gg.REGION_C_HEAP | gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_C_BSS | gg.REGION_C_DATA | gg.REGION_OTHER)
    gg.searchNumber('h ' .. name, gg.TYPE_BYTE, false, gg.SIGN_EQUAL, data[1].start, data[#data]['end'])
    if gg.getResultsCount() == 0 then error('the "' .. NameFucntion .. '" function was not found') end
    gg.searchNumber('h ' .. string.sub(name,4,5)) 
    local r = gg.getResults(gg.getResultsCount())
    gg.clearResults()
    for key, value in ipairs(r) do
        if gg.BUILD < 16126 then 
            gg.searchNumber(string.format("%8.8X", fixvalue32(value.address)) .. 'h', Unity.MainType)
        else 
            gg.loadResults({value})
            gg.searchPointer(0)
        end
        local MethodsInfo = gg.getResults(gg.getResultsCount())
        gg.clearResults()
        for k, v in ipairs(MethodsInfo) do
            v.address = v.address - Unity.MethodNameOffset
            local FinalAddress = fixvalue32(gg.getValues({v})[1].value)
            if (FinalAddress > libil[1].start and FinalAddress < libil[#libil]['end']) then 
                FinalMethods[#FinalMethods + 1] = {
                    AddressMethod = FinalAddress,
                    Address = v.address
                }
            end
        end
    end
    if (#FinalMethods == 0) then error('the "' .. NameFucntion .. '" function pointer was not found') end
    return FinalMethods
end

function addresspath(StartAddress, ...)
    args = {...}
    for i = 1,#args do
        StartAddress = i ~= 1 and StartAddress + 0x4 or StartAddress
        setupValues(StartAddress,args[i])
    end
end

function GetAddressMemory(startAddress, add)
    local localPageMemory = ((pageMemory == 0) or (((pageMemory & 0xFFF) + add) > 3500)) and gg.allocatePage(gg.PROT_READ | gg.PROT_WRITE, startAddress) or pageMemory
    pageMemory = localPageMemory + add
    return localPageMemory
end

function fixvalue32(value)
    return platform and value or value & 0xFFFFFFFF
end

function MyLenTable(t)
    local ret = 0
    for k,v in pairs(t) do ret = ret + 1 end
    return ret
end

Unity = {
    ClassNameOffset = platform and 0x10 or 0x8,
    StaticFieldsOffset = platform and 0xB8 or 0x5C,
    ParentOffset = platform and 0x58 or 0x2C,
    NumFields = platform and 0x120 or 0xA8,
    FieldsLink = platform and 0x80 or 0x40,
    FieldsStep = platform and 0x20 or 0x14,
    FieldsOffset = platform and 0x18 or 0xC, 
    MethodClassOffset = platform and 0x18 or 0xC, 
    MethodNameOffset = platform and 0x10 or 0x8,
    MainType = platform and gg.TYPE_QWORD or gg.TYPE_DWORD,
    GetClass = function(self, ClassName)
        gg.clearResults()
        gg.setRanges(0)
        gg.setRanges(gg.REGION_C_HEAP | gg.REGION_C_HEAP | gg.REGION_ANONYMOUS | gg.REGION_C_BSS | gg.REGION_C_DATA | gg.REGION_OTHER | gg.REGION_C_ALLOC)
        gg.searchNumber("Q 00 '" .. ClassName .. "' 00",gg.TYPE_BYTE,false,gg.SIGN_EQUAL,data[1].start,data[1]['end'])
        gg.searchNumber("Q '" .. ClassName .. "' ")
        gg.searchPointer(0)
        local res = gg.getResults(gg.getResultsCount())
        gg.clearResults()
        if (#res > 1) then
            for k,v in ipairs(res) do
                local assembly = gg.getValues({{address = v.address - Unity.ClassNameOffset,flags = v.flags}})[1].value
                if (self.Utf8ToString(gg.getValues({{address = assembly,flags = v.flags}})[1].value):find(".dll")) then res[1] = v end
            end
        end
        if not self.ClassLoad then self:SetFields(res[1].address - Unity.ClassNameOffset) end
        return res[1]
    end,
    GetStartLibAddress = function(Address)
        local start = 0
        for k,v in ipairs(libil) do
            if (fixvalue32(Address) > fixvalue32(v.start) and fixvalue32(Address) < fixvalue32(v['end'])) then start = v.start end
        end
        return start
    end,
    FilterObject = function (Instances)
        gg.clearResults()
        gg.loadResults(Instances)
        gg.searchPointer(0)
        local r, FilterInstances = gg.getResults(gg.getResultsCount()), {}
        for k,v in ipairs(gg.getValuesRange(r)) do
            FilterInstances[#FilterInstances + 1] = v == 'A' and {address = r[k].value, flags = r[k].flags} or nil
        end
        gg.clearResults()
        gg.loadResults(FilterInstances)
        FilterInstances = gg.getResults(gg.getResultsCount())
        gg.clearResults()
        return FilterInstances
    end,
    GetInstance = function(self)
        local Instances, ClassName = {}, GetNameTableInGlobalSpace(self)
        local MemClass = self:GetClass(ClassName)
        gg.loadResults({MemClass})
        gg.searchPointer(self.ClassNameOffset)
        local r = gg.getResults(gg.getResultsCount())
        for k,v in ipairs(gg.getValuesRange(r)) do
            Instances[#Instances + 1] = v == 'A' and r[k] or nil
        end
        Instances = self.FilterObject(Instances)
        gg.toast(lang_main[ClassName] or "")
        gg.clearResults()
        return Instances
    end,
    GetLocalInstance = function(self) 
        local Instances, ClassName = {}, GetNameTableInGlobalSpace(self)
        local MemClass = self:GetClass(ClassName)
        local tmp = gg.getValues({{address = MemClass.address - self.ClassNameOffset + self.StaticFieldsOffset,flags = MemClass.flags}})
        table.move(gg.getValues({{address = tmp[1].value,flags = tmp[1].flags}}),1,1,#Instances + 1,Instances)
        gg.toast(lang_main[ClassName] or "")
        gg.clearResults()
        return Instances
    end,
    GetParentLocalInstance = function(self) 
        local Instances, ClassName = {}, GetNameTableInGlobalSpace(self)
        local MemClass = self:GetClass(ClassName)
        local tmp = gg.getValues({{address = MemClass.address - self.ClassNameOffset + self.ParentOffset,flags = MemClass.flags}})[1].value
        tmp = gg.getValues({{address = tmp + self.StaticFieldsOffset,flags = MemClass.flags}})
        table.move(gg.getValues({{address = tmp[1].value,flags = tmp[1].flags}}),1,1,#Instances + 1,Instances)
        gg.toast(lang_main[ClassName] or "")
        gg.clearResults()
        return Instances
    end,
    Utf8ToString = function(Address)
        local bytes, char = {}, {address = fixvalue32(Address), flags = gg.TYPE_BYTE}
        while gg.getValues({char})[1].value > 0 do
            bytes[#bytes + 1] = {address = char.address, flags = char.flags}
            char.address = char.address + 0x1
        end
        return tostring(setmetatable(gg.getValues(bytes), {
            __tostring = function(self)
                for k,v in ipairs(self) do
                    self[k] = string.char(v.value) 
                end
                return table.concat(self)
            end
        }))
    end,
    Utf16ToString = function(Address)
        local bytes, strAddress = {}, fixvalue32(Address) + (platform and 0x10 or 0x8)
        local num = gg.getValues({{address = strAddress,flags = gg.TYPE_DWORD}})[1].value
        if num > 0 and num < 200 then
            for i = 1, num + 1 do
                bytes[#bytes + 1] = {address = strAddress + (i << 1), flags = gg.TYPE_WORD}
            end
        end
        return #bytes > 0 and tostring(setmetatable(gg.getValues(bytes), {
            __tostring = function(self)
                for k,v in ipairs(self) do
                    self[k] = v.value == 32 and " " or (Utf16[v.value] or "")
                end
                return table.concat(self)
            end
        })) or ""
    end,
    GetIl2cppFunc = function(...)
        local args, RetIl2CppFuncs = {...}, {}
        if args[1] == nil or args[1] == "" or args[1] == " " then return {},"you didn't enter the function" end 
        for keyname,namefucntion in ipairs(args) do
            local finaladdres = Il2CppName(namefucntion)
            for k,v in pairs(finaladdres) do
                if (k ~= 'Error') then
                    local AddressClass = fixvalue32(gg.getValues({{address = v.Address + Unity.MethodClassOffset,flags = Unity.MainType}})[1].value)
                    RetIl2CppFuncs[#RetIl2CppFuncs + 1] = {
                        NameFucntion = namefucntion,
                        Offset = string.format("%X",v.AddressMethod - Unity.GetStartLibAddress(v.AddressMethod)),
                        AddressInMemory = string.format("%X",v.AddressMethod),
                        AddressOffset = v.Address,
                        Class = Unity.Utf8ToString(gg.getValues({{address = AddressClass + Unity.ClassNameOffset,flags = Unity.MainType}})[1].value),
                        ClassAddress = string.format('%X', AddressClass)
                    }
                else
                    RetIl2CppFuncs[#RetIl2CppFuncs + 1] = {
                        NameFucntion = namefucntion,
                        Error = v
                    }
                end
            end
        end
        return RetIl2CppFuncs,'true'
    end,
    From = function (self, a)
        if not self.ClassLoad then self:SetFields(gg.getValues({{address = fixvalue32(a), flags = Unity.MainType}})[1].value) end
        return setmetatable({address = a, mClass = self}, {
            __index = function(self, key)
                local check = switch((self.address and self.mClass) and (self.mClass[key] and 1 or -1) or 0 , {[0] = 'Не все поля заполнены', [-1] = 'В таблице нет поля ' .. key})
                return check and error(check) or ((type(self.mClass[key]) == 'function') 
                    and (function(self, ...) return self.mClass[key](self.mClass, self.address, ...) end)
                    or self.mClass[key])
            end
        })
    end,
    GetNumFields = function(self, ClassAddress)
        return gg.getValues({{address = ClassAddress + self.NumFields, flags = gg.TYPE_WORD}})[1].value
    end,
    GetLinkFields = function(self, ClassAddress)
        return gg.getValues({{address = ClassAddress + self.FieldsLink, flags = Unity.MainType}})[1].value
    end,
    SetFields = function(self, AddressClass)
        AddressClass = fixvalue32(AddressClass)
        self.ClassLoad = true
        local FieldsCount, FieldsLink = self:GetNumFields(AddressClass), fixvalue32(self:GetLinkFields(AddressClass)) 
        for i = 0, FieldsCount - 1 do
            local field = FieldsLink + (i * self.FieldsStep)
            local fieldInfo = gg.getValues({
                {--NameField
                    address = field,
                    flags = Unity.MainType
                },
                {--Offset
                    address = field + self.FieldsOffset,
                    flags = gg.TYPE_WORD
                },
            })
            self.Fields[self.Utf8ToString(fixvalue32(fieldInfo[1].value))] = fieldInfo[2].value
        end
    end,
}

function SetUnityClass(t)
    t.ClassLoad = false
    t.Fields = {}
    return setmetatable(t,{__index = Unity})
end

function SetSubClass(SubClass, MainClass) 
    return setmetatable(SubClass, {__index = MainClass})
end

EnumClass = {
    From = function (self, a)
        return setmetatable({address = a, mClass = self}, {
            __index = function(self, key)
                local check = switch((self.address and self.mClass) and (self.mClass[key] and 1 or -1) or 0 , {[0] = 'Не все поля заполнены', [-1] = 'В таблице нет поля ' .. key})
                return check and error(check) or ((type(self.mClass[key]) == 'function') 
                    and (function(self, ...) return self.mClass[key](self.mClass, self.address, ...) end)
                    or self.mClass[key])
            end
        })
    end
}

function SetEnumClass(t)
    return setmetatable(t, {__index = EnumClass})
end

Dictionary = SetEnumClass({
    num = platform and 0x20 or 0x10,
    link = platform and 0x18 or 0xC,
    GetNum = function(self, dic)
        return gg.getValues({{address = dic + self.num, flags = gg.TYPE_DWORD}})[1].value
    end,
    GetLink = function(self, dic)
        return gg.getValues({{address = dic + self.link, flags = Unity.MainType}})[1].value
    end,
    int = {
        int = {
            firstStepKey = platform and 0x28 or 0x18,
            base = platform and 0x2C or 0x1C,
            SetAllItems = function(dic, val)
                local items, link, lenght = {}, fixvalue32(Dictionary:GetLink(dic)), Dictionary:GetNum(dic)
                for i = 0, lenght - 1 do
                    items[#items + 1] = {
                        address = link + Dictionary.int.int.base + (i << 4),
                        flags = gg.TYPE_DWORD,
                        value = val
                    }
                end
                gg.setValues(items)
            end,
            SetItem = function(dic, key, val)
                dic = fixvalue32(dic)
                local link, lenght = fixvalue32(Dictionary:GetLink(dic)), Dictionary:GetNum(dic)
                for i = 0, lenght - 1 do
                    local Element = gg.getValues({
                        {
                            address = link + Dictionary.int.int.firstStepKey + (i << 4),
                            flags = gg.TYPE_DWORD
                        }
                    })
                    if (Element[1].value == key) then 
                        gg.setValues({{
                            address = link + Dictionary.int.int.base + (i << 4),
                            flags = gg.TYPE_DWORD,
                            value = val
                        }}) 
                    end
                end
            end
        },
        object = {
            firstStepValue = platform and 0x30 or 0x1C,
            firstStepKey =  platform and 0x28 or 0x18,
            step = platform and 0x18 or 0x10,
            GetAllItems = function(dic)
                dic = fixvalue32(dic)
                local items, link, lenght = {}, fixvalue32(Dictionary:GetLink(dic)), Dictionary:GetNum(dic)
                for i = 0, lenght - 1 do
                    local Element = gg.getValues({
                        {
                            address = link + Dictionary.int.object.firstStepKey + (i * Dictionary.int.object.step),
                            flags = gg.TYPE_DWORD
                        },
                        {
                            address = link + Dictionary.int.object.firstStepValue + (i * Dictionary.int.object.step),
                            flags = Unity.MainType
                        }
                    })
                    items[Element[1].value] = fixvalue32(Element[2].value)
                end
                return items
            end
        },
        struct = {
            SetAllItems = function(dic, firstStep, step, typeValue, val)
                local items, link, lenght = {}, fixvalue32(Dictionary:GetLink(dic)), Dictionary:GetNum(dic)
                for i = 0, lenght - 1 do
                    items[#items + 1] = {
                        address = link + firstStep + (i << step),
                        flags = typeValue,
                        value = val
                    }
                end
                gg.setValues(items)
            end
        }
    },
    string = {
        object = {
            firstStepValue = platform and 0x30 or 0x1C,
            firstStepKey =  platform and 0x28 or 0x18,
            step = platform and 0x18 or 0x10,
            GetAllItems = function(dic)
                dic = fixvalue32(dic)
                local items, link, lenght = {}, fixvalue32(Dictionary:GetLink(dic)), Dictionary:GetNum(dic)
                for i = 0, lenght - 1 do
                    local Element = gg.getValues({
                        {
                            address = link + Dictionary.string.object.firstStepKey + (i * Dictionary.string.object.step),
                            flags = Unity.MainType
                        },
                        {
                            address = link + Dictionary.string.object.firstStepValue + (i * Dictionary.string.object.step),
                            flags = Unity.MainType
                        }
                    })
                    items[Unity.Utf16ToString(Element[1].value)] = fixvalue32(Element[2].value)
                end
                return items
            end
        },
        float = {
            firstStepValue = platform and 0x30 or 0x1C,
            firstStepKey =  platform and 0x28 or 0x18,
            step = platform and 0x18 or 0x10,
            SetItemKey = function(dic, key, val)
                dic = fixvalue32(dic)
                local link, lenght = fixvalue32(Dictionary:GetLink(dic)), Dictionary:GetNum(dic)
                for i = 0, lenght - 1 do
                    local Element = gg.getValues({
                        {
                            address = link + Dictionary.string.float.firstStepKey + (i * Dictionary.string.float.step),
                            flags = Unity.MainType
                        }
                    })
                    if (Unity.Utf16ToString(Element[1].value) == key) then 
                        gg.setValues({{
                            address = link + Dictionary.string.float.firstStepValue + (i * Dictionary.string.float.step),
                            flags = gg.TYPE_FLOAT,
                            value = val
                        }}) 
                    end
                end
            end
        },
        int = {
            firstStepValue = platform and 0x30 or 0x1C,
            step = platform and 0x18 or 0x10,
            MulItems = function(dic, mul)
                dic = fixvalue32(dic)
                local items, link, lenght = {}, fixvalue32(Dictionary:GetLink(dic)), Dictionary:GetNum(dic)
                for i = 0, lenght - 1 do
                    local Element = gg.getValues({
                        {
                            address = link + Dictionary.string.int.firstStepValue + (i * Dictionary.string.int.step),
                            flags = gg.TYPE_DWORD
                        }
                    })
                    items[#items + 1] = {
                        address = Element[1].address,
                        flags = gg.TYPE_DWORD,
                        value = Element[1].value * mul
                    }
                end
                if #items > 0 then gg.setValues(items) end
            end
        }
    }
})

List = SetEnumClass({
    num = platform and 0x18 or 0xC, 
    link = platform and 0x10 or 0x8,
    GetNum = function(self, list)
        return gg.getValues({{address = list + self.num, flags = gg.TYPE_DWORD}})[1].value
    end,
    GetLink = function(self, list)
        return gg.getValues({{address = list + self.link, flags = Unity.MainType}})[1].value
    end,
    object = {
        firstStep = platform and 0x20 or 0x10,
        step = platform and 3 or 2,
        GetAllItems = function(list)
            local items, link, lenght = {}, fixvalue32(List:GetLink(list)), List:GetNum(list)
            for i = 0, lenght - 1 do
                items[#items + 1] = {
                    address = link + List.object.firstStep + (i << List.object.step),
                    flags = Unity.MainType
                }
            end 
            return lenght > 0 and gg.getValues(items) or items
        end
    }
})

ProductPrice = SetUnityClass({
    FREEITEMS = function(self)
        local items = {}
        for k,v in ipairs(self:GetInstance()) do
            items[#items + 1] = {
                address = v.address + self.Fields.type,
                value = 1,
                flags = gg.TYPE_DWORD
            }
            items[#items + 1] = {
                address = v.address + self.Fields.gameResourcesPrice,
                value = 0,
                flags = gg.TYPE_FLOAT
            }
        end
        gg.setValues(items)
    end
})

MenuSkinUI = SetUnityClass({
    UnlockAllSkin = function(self)
        local items = {}
        for k, v in ipairs(self:GetLocalInstance()) do
            Dictionary.int.int.SetAllItems(gg.getValues({{address = v.value + self.Fields.allSkinState, flags = Unity.MainType}})[1].value, 0)
        end
    end
})

AchievementData = SetUnityClass({
    GetTableForComlite = function(self, add)
        return {address = add + self.Fields.isComplete, flags = gg.TYPE_BYTE, value = 1}
    end,
    GetTableForRecesive = function(self, add)
        return {address = add + self.Fields.hasReceiveAward, flags = gg.TYPE_BYTE, value = 0}
    end,
})

Manager = SetUnityClass({
    get_dataList = function(self, add)
        return fixvalue32(gg.getValues({{address = add + self.Fields._dataList, flags = Unity.MainType}})[1].value)
    end
})

AchievementManager = SetUnityClass({
    CompliteAllAchievement = function (self)
        local achiv = {}
        for k, v in pairs(self:GetLocalInstance()) do
            local manager = Manager:From(v.value)
            for key, value in pairs(List.object.GetAllItems(manager:get_dataList())) do
                achiv[#achiv + 1] = AchievementData:From(value.value):GetTableForComlite()
            end
        end
        gg.setValues(achiv)
    end,
    GetRewardAchievments = function(self)
        local achiv = {}
        for k, v in pairs(self:GetLocalInstance()) do
            local manager = Manager:From(v.value)
            for key, value in pairs(List.object.GetAllItems(manager:get_dataList())) do
                achiv[#achiv + 1] = AchievementData:From(value.value):GetTableForRecesive()
            end
        end
        gg.setValues(achiv)
    end
})

Properties = SetUnityClass({
    HackProp = function(self, add, key, val)
        Dictionary.string.float.SetItemKey(gg.getValues({{address = add + self.Fields.baseProperty, flags = Unity.MainType}})[1].value, key, val)
    end
})

Character = SetUnityClass({
    BlockDamage = function(self, add)
        gg.setValues({{address = add + self.Fields._isBlockDamage, flags = gg.TYPE_BYTE, value = 1}})
    end,
    HackDamage = function(self, add)
        Properties:From(gg.getValues({{address = add + self.Fields.properties, flags = Unity.MainType}})[1].value):HackProp('Damage', 100000)
    end
})

UnitSpawn = SetUnityClass({
    GodMode = function(self)
        for k, v in ipairs(self:GetLocalInstance()) do
            local dic = Dictionary.int.object.GetAllItems(gg.getValues({{address = v.value + self.Fields.unitDic, flags = Unity.MainType}})[1].value)
            if dic[1] then
                for key, value in ipairs(List.object.GetAllItems(dic[1])) do
                    Character:From(fixvalue32(value.value)):BlockDamage()
                end
            end
        end
    end,
    HackDamage = function(self)
        for k,v in ipairs(self:GetLocalInstance()) do
            local dic = Dictionary.int.object.GetAllItems(gg.getValues({{address = v.value + self.Fields.unitDic, flags = Unity.MainType}})[1].value)
            if (dic[1]) then 
                for key, value in ipairs(List.object.GetAllItems(dic[1])) do
                    Character:From(fixvalue32(value.value)):HackDamage()
                end
            end
        end
    end,
})

PropertiesSystemLib = SetUnityClass({
    HackCooldown = function(self)
        for k,v in ipairs(self:GetLocalInstance()) do
            local charDic = Dictionary.string.object.GetAllItems(v.value)
            for key, value in pairs(charDic) do
                if string.find(string.lower(key), 'hero') then
                    Dictionary.string.float.SetItemKey(value, 'Cooldown', 0)
                end
            end
        end
    end
})

HeroRunningData = SetUnityClass({
    SetCoin = function(self, add, num)
        Dictionary.int.int.SetItem(gg.getValues({{address = add + self.Fields.heroBackpack, flags = Unity.MainType}})[1].value, 0, num) -- coin_base
    end
})

GameProcess = SetUnityClass({
    SetCoin = function(self, num)
        for k, v in ipairs(self:GetLocalInstance()) do
            HeroRunningData:From(gg.getValues({{address = v.address + self.Fields['<heroRunningData>k__BackingField'], flags = Unity.MainType}})[1].value):SetCoin(num)
        end
    end
})

Weapon = SetUnityClass({
    MaxIdEffects = 201,
    ChangeWeapon = function(self)
        local weapons = {}
        for k,v in ipairs(self:GetInstance()) do
            local data = v.address + self.Fields['<data>k__BackingField']
            table.move({
                {
                    address = data + 0x4, -- quality
                    flags = gg.TYPE_DWORD,
                    value = 4
                },
                {
                    address = data + 0x18, -- characterEffect0
                    flags = gg.TYPE_DWORD,
                    value = math.random(0, self.MaxIdEffects)
                },
                {
                    address = data + 0x1C, -- characterEffect1
                    flags = gg.TYPE_DWORD,
                    value = math.random(0, self.MaxIdEffects)
                },
                {
                    address = data + 0x20, -- characterEffect2
                    flags = gg.TYPE_DWORD,
                    value = math.random(0, self.MaxIdEffects)
                },
                {
                    address = data + 0x24, -- characterEffect3
                    flags = gg.TYPE_DWORD,
                    value = math.random(0, self.MaxIdEffects)
                },
            }, 1, 5, #weapons + 1, weapons)
        end
        gg.setValues(weapons)
    end
})

DailyActivityView = SetUnityClass({
    x5Activity = function(self)
        for k, v in ipairs(self:GetLocalInstance()) do
            for key, val in ipairs(List.object.GetAllItems(fixvalue32(gg.getValues({{address = v.address + self.Fields.rewardContent, flags = Unity.MainType}})[1].value))) do
                Dictionary.string.int.MulItems(val.value, 5)
            end
        end
    end
})

DailyActivityComponent = SetUnityClass({
    CompliteActivity = function(self)
        for k, v in ipairs(self:GetLocalInstance()) do
            Dictionary.int.int.SetAllItems(fixvalue32(gg.getValues({{address = v.address + self.Fields.eventCompleteCount, flags = Unity.MainType}})[1].value), 400)
        end
    end
})

DataManager = SetUnityClass({
    FrendlyPets = function(self)
        for k, v in ipairs(self:GetLocalInstance()) do
            local dic = fixvalue32(gg.getValues({{address = v.address + self.Fields.PetConfigData, flags = Unity.MainType}})[1].value)
            Dictionary.int.struct.SetAllItems(dic, platform and 0x30 or 0x20, 6, gg.TYPE_DWORD, 0) -- <UnlockMode>k__BackingField
            Dictionary.int.struct.SetAllItems(dic, platform and 0x40 or 0x30, 6, gg.TYPE_FLOAT, 1000) -- <friendlinessPerSatiety_NotUnlock>k__BackingField
            Dictionary.int.struct.SetAllItems(dic, platform and 0x44 or 0x34, 6, gg.TYPE_FLOAT, 1000) -- <friendlinessPerSatiety_HasUnlock>k__BackingField
        end
    end,
})

EncryptValue = SetUnityClass({
    SetEncryptValue = function(self, add, num)
        local key = gg.getValues({{address = add + self.Fields.encryptKey, flags = gg.TYPE_DWORD}})[1].value
        return {
            {
                address = add + self.Fields._showValue,
                value = num,
                flags = gg.TYPE_DWORD
            },
            {
                address = add + self.Fields.mValue,
                value = num ~ key,
                flags = gg.TYPE_DWORD
            }
        }
    end
})

PlayerArchive = SetUnityClass({
    ChangeFloorCount = function(self)
        local floorItems = {}
        for k, v in ipairs(self:GetLocalInstance()) do
            local resursDic = gg.getValues({{address = v.address + self.Fields._resourceDic, flags = Unity.MainType}})[1].value
            local items = Dictionary.int.object.GetAllItems(resursDic)
            if (items[19]) then -- FloorSkinPiece
                for key, encVal in pairs(Dictionary.string.object.GetAllItems(items[19])) do
                    table.move(EncryptValue:From(encVal):SetEncryptValue(500), 1, 2, #floorItems + 1, floorItems)
                end
            end
        end
        gg.setValues(floorItems)
    end,
    ChangeAsuraPowerPoint = function(self, value)
        local powerTable = {}
        for k,v in ipairs(self:GetLocalInstance()) do
            local _exAsuraPowerPointMax = gg.getValues({{address = v.address + self.Fields._exAsuraPowerPointMax, flags = Unity.MainType}})[1].value
            table.move(EncryptValue:From(_exAsuraPowerPointMax):SetEncryptValue(value), 1, 2, #powerTable + 1, powerTable)
        end
        gg.setValues(powerTable)
    end
})

functions = {
    ['EXIT'] = function()
        if not pcall(dropboxfile,"MainMenu.lua") then os.exit() end
    end,
    ['BREAK ITEMS IN THE STORE'] = function()
        Protect:Call(ProductPrice.FREEITEMS, ProductPrice)
    end,
    ['UNLOCK ALL STYLE LOBBY'] = function()
        Protect:Call(MenuSkinUI.UnlockAllSkin, MenuSkinUI)
    end,
    ['COMPLETE ALL ACHIEVEMENTS'] = function()
        Protect:Call(AchievementManager.CompliteAllAchievement, AchievementManager)
    end,
    ['GET A REWARD FOR ACHIEVEMENTS'] = function()
        Protect:Call(AchievementManager.GetRewardAchievments, AchievementManager)
    end,
    ['IMMORTALITY'] = function()
        Protect:Call(UnitSpawn.GodMode, UnitSpawn)
    end,
    ['REMOVE SKILL COOLDOWN'] = function()
        Protect:Call(PropertiesSystemLib.HackCooldown, PropertiesSystemLib)
    end,
    ['HUGE DAMAGE'] = function()
        Protect:Call(UnitSpawn.HackDamage, UnitSpawn)
    end,
    ['CHANGE WEAPON'] = function()
        Protect:Call(Weapon.ChangeWeapon, Weapon)
    end,
    ['MAKE ALL PETS FRIENDLY'] = function()
        Protect:Call(DataManager.FrendlyPets, DataManager)
    end,
    ['COMPLETE ALL DAILY ERRANDS'] = function()
        Protect:Call(DailyActivityComponent.CompliteActivity, DailyActivityComponent)
    end,
    ['DAILY REWARDS X5'] = function()
        Protect:Call(DailyActivityView.x5Activity, DailyActivityView)
    end,
    ['(DANGEROUS) CHANGE THE NUMBER OF STYLE FRAGMENTS'] = function()
        local attemt = gg.alert("ФУНКЦИЯ 'ИЗМЕНИТЬ КОЛИЧЕСТВО ФРАГМЕНТОВ СТИЛЯ' ОПАСНА, ТАК КАК МОЖЕТ ВЫЗВАТЬ БЛОКИРОВКУ АККАУНТА, ВЫ СОГЛАСНЫ С ИСПОЛЬЗОВАНИЕМ ДАННОЙ ФУНКЦИИ ?\nTHE FUNCTION 'CHANGE THE NUMBER OF STYLE FRAGMENTS' IS DANGEROUS, AS IT CAN CAUSE ACCOUNT BLOCKING, DO YOU AGREE WITH THE USE OF THIS FUNCTION?", "YES", "NO")
        if (attemt == 1) then Protect:Call(PlayerArchive.ChangeFloorCount, PlayerArchive) end
    end,
    ['SET COIN COUNT'] = function(self)
        local num = gg.prompt({'ВВЕДИТЕ НУЖНОЕ КОЛИЧЕСТВО (ФУНКЦИЯ: УСТАНОВИТЬ КОЛИЧЕСТВО МОНЕТ)\nENTER THE REQUIRED AMOUNT (FUNCTION: SET COIN COUNT)'},{[1] = 5},{'number'})
        if CheckTableIsNil(num) then 
            gg.alert("ВЫ НЕ ВВЕЛИ КОЛИЧЕСТВО\nYOU DIDN'T ENTER THE QUANTITY") 
        else
            Protect:Call(GameProcess.SetCoin, GameProcess, num[1])
        end
    end,
    ['(DANGEROUS) SET ASURA POINTS'] = function(self)
        local attemt = gg.alert("ФУНКЦИЯ 'УСТАНОВИТЬ ОЧКИ АСУРЫ' ОПАСНА, ТАК КАК МОЖЕТ ВЫЗВАТЬ БЛОКИРОВКУ АККАУНТА, ВЫ СОГЛАСНЫ С ИСПОЛЬЗОВАНИЕМ ДАННОЙ ФУНКЦИИ ?\nTHE FUNCTION 'SET ASURA POINTS' IS DANGEROUS, AS IT CAN CAUSE ACCOUNT BLOCKING, DO YOU AGREE WITH THE USE OF THIS FUNCTION?", "YES", "NO")
        if (attemt == 1) then 
            local num = gg.prompt({'ВВЕДИТЕ НУЖНОЕ КОЛИЧЕСТВО (ФУНКЦИЯ: УСТАНОВИТЬ ОЧКИ АСУРЫ)\nENTER THE REQUIRED AMOUNT (FUNCTION: SET ASURA POINTS)'},{[1] = 5},{'number'})
            if CheckTableIsNil(num) then 
                gg.alert("ВЫ НЕ ВВЕЛИ КОЛИЧЕСТВО\nYOU DIDN'T ENTER THE QUANTITY") 
            else
                Protect:Call(PlayerArchive.ChangeAsuraPowerPoint, PlayerArchive, num[1])
            end
        end
    end
}

while true do
    if gg.isVisible() or ArrayX ~= nil then
        gg.setVisible(false)
        ArrayX = gg.multiChoice(lang_main, nil, "OTLScript")
        if ArrayX ~= nil then 
            for keyArray, valueArray in pairs(ArrayX) do
                if valueArray and functions[lang['en_US'][keyArray]] then functions[lang['en_US'][keyArray]]() end
            end
        end
    end
    gg.sleep(100)
end