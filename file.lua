

File = {};

--
function find_key_string(str, key_string)
    local found_b = 0;
	local found_e = 0;
    if str == nil then 
        return nil
    end
    found_b,found_e = string.find(str, key_string);
    return found_b, found_e;
end


function sub_string(str, beginIndex, endIndex)
    return string.sub(str, beginIndex, endIndex);
end

function File.new(cls,...)
    this={};
    setmetatable(this,cls);
    cls.__index=cls;
    cls.init(this,...);
    return this;
end

-- TODO 添加自定义路径
function File.init(self,file_name)
    self.name=file_name;
    self.file_info = io.open(file_name, "r+");
    if self.file_info then
        print( "open file success");
    else
        print( "open file error");
    end
    -- 读取所有文件的所有行 方便后续操作
    
    -- 按行的文件数据
    self.file_info_line = {};
    -- 总行数
    self.line_index = 0;

    for r in self.file_info:lines() do
        self.line_index = self.line_index + 1;
        self.file_info_line[self.line_index] = r;
    end

    -- 置为开头
    self.file_info:seek("set");

    print( "all line: " .. self.line_index);
    -- TODO: 脏数据行,支持仅修改部分 
    self.dirty_line = {};

end

-- 重载文件
function File.reload_file(self, file_name)

    self.name=file_name;
    self.file_info:close();

    self.file_info = io.open(file_name, "r");
    if self.file_info then
        print( "open file success");
    else
        print( "open file error");
    end
    
    -- 按行的文件数据
    self.file_info_line = {};
    -- 总行数
    self.line_index = 0;

    for r in self.file_info:lines() do
        print("reload r " .. r)
        self.line_index = self.line_index + 1;
        print("reload self.line_index " .. self.line_index)
        self.file_info_line[self.line_index] = r;
    end
    
    print( "reload file success all line: " .. self.line_index);
end

function File.dump_cache_info(self, message)
    print("dump message --> " .. message);
    print("self.line_index --> " .. self.line_index);
    for i = 1, self.line_index  do
        print(self.file_info_line[i]);
    end

    print("-----------------------------");
end

function File.save_all(self)
    local saveStr = ""
    print("save --> " .. self.line_index)
    for i = 0, self.line_index - 1 do
        print("save --> " .. i)
        i = i + 1;
        -- saveStr = saveStr .. self.file_info_line[i] .. "--> new";
        -- TODO： if self.file_info_line[i] == nil will error
        saveStr = saveStr .. self.file_info_line[i];
        
        if i == self.line_index then
        else
            saveStr = saveStr .. "\n";
        end
    end

	local f = io.open(self.name, "w")
		if f then
			f:write(saveStr);
			f:flush();
			f:close();
		end
    print( "save all line: " .. self.line_index);
end


function File.get_file_name(self)
    return self.name;
end

function File.get_file(self)
    return self.file_info;
end

function File.get_file_text(self)
    local temp_file = self:get_file();
    local str = "";
    str = temp_file:read("*a");
    return str;
end

-- 输出某一行  
-- lua begin with 1 shit
function File.get_text_by_line_count(self, line_count)
    if(self.file_info_line[line_count] == nil) then

    print(
        "line count--> " .. line_count .. "not find"
    );
    else
        print(self.file_info_line[line_count]);
    end
end

-- 输出某内容位置(这里的具体的位置, 仅查找第一个)
-- TODO: 可修改成按行查找(但是考虑到find效率 算了)
function File.get_text_by_key_string(self, key_string)
    local temp_file = self:get_file();
    local str = "";
    str = temp_file:read("*a");

    local found_b = 0;
    local found_e = 0;
    found_b,found_e = find_key_string(str, key_string);

    return found_b, found_e;
end

-- 输出某内容行号
function File.get_line_count_by_key_string(self, key_string)
    local temp_file = self:get_file();
    -- lua begin with 1 shit
    local now_line = 1;
    
    for line in temp_file:lines() do

        local found_b = 0;
        local found_e = 0;
        found_b,found_e = find_key_string(line, key_string);
    
        if found_b == nil then
        else
            return now_line;
        end 
        now_line = now_line + 1;
    end 

    print(
        "key_string " .. key_string .. " not find"
    );
end

-- 获取某内容的一整行
function File.get_line_text_by_key_string(self, key_string)
    local lineCount = self:get_line_count_by_key_string(key_string);
    
    if lineCount == nil then
        -- message already print in get_line_count_by_key_string
    else
        print(key_string .." in line " .. lineCount .. " " .. self.file_info_line[lineCount]);
    end
end


-- 在某行前插入
function File.insert_txt_before_line_count(self, line_count, txt)
    
    local lineData = self.file_info_line[line_count];
    if(lineData == nil) then
        print("line count--> " .. line_count .. "not find");
        return
    end

    table.insert(self.file_info_line, line_count - 1 ,txt);
    self.line_index = self.line_index + 1;
end

-- 在某行后插入
function File.insert_txt_after_line_count(self, line_count, txt)
    
    local lineData = self.file_info_line[line_count];
    if(lineData == nil) then
        print("line count--> " .. line_count .. "not find");
        return;
    end

    table.insert (self.file_info_line, line_count + 1 ,txt);

    self.line_index = self.line_index + 1;
end

-- 在内容前插入
function File.insert_txt_begin_key_string(self, key_string, txt)
    local lineCount = self:get_line_count_by_key_string(key_string);
    local lineData = self.file_info_line[lineCount];

    local found_b = 0;
    local found_e = 0;
    found_b,found_e = find_key_string(lineData, key_string);
    if found_b == nil then
        return 
    end 
    
    local str1 = sub_string(lineData, 1, found_b - 1);
	local str2 = sub_string(lineData, found_b, #lineData);
	self.file_info_line[lineCount] = str1 .. txt .. str2;
    print(self.file_info_line[lineCount]);
end

-- 在内容前插入
function File.insert_txt_after_key_string(self, key_string, txt)
    local lineCount = self:get_line_count_by_key_string(key_string);
    local lineData = self.file_info_line[lineCount];

    local found_b = 0;
    local found_e = 0;
    found_b,found_e = find_key_string(lineData, key_string);
    if found_b == nil then
        return 
    end 
    
    local str1 = sub_string(lineData, 1, found_e);
	local str2 = sub_string(lineData, found_e + 1, #lineData);
	self.file_info_line[lineCount] = str1 .. txt .. str2;
    print(self.file_info_line[lineCount]);
end

-- 删除某行
function File.delete_line_by_line_count(self, line_count)
    local lineData = self.file_info_line[line_count];
    if(lineData == nil) then
        print("line count--> " .. line_count .. "not find");
        return;
    end
    
    table.remove(self.file_info_line, line_count);
    self.line_index = self.line_index - 1;  
end

-- 删除某内容
function File.delete_line_by_key_string(self, key_string)
    local lineCount = self:get_line_count_by_key_string(key_string);
    local lineData = self.file_info_line[lineCount];

    local found_b = 0;
    local found_e = 0;
    found_b,found_e = find_key_string(lineData, key_string);
    if found_b == nil then
        return 
    end 


    local str1 = sub_string(lineData, 1, found_b - 1);
	local str2 = sub_string(lineData, found_e + 1, #lineData + 1);
	self.file_info_line[lineCount] = str1 .. str2; 
end

-- 检查对应行是否有对应内容
function File.check_line_have_key_string(self, line_count, key_string)
    local lineData = self.file_info_line[line_count];
    if(lineData == nil) then
        print("line count--> " .. line_count .. "not find");
        return nil;
    end

    local found_b = 0;
    local found_e = 0;
    found_b,found_e = find_key_string(lineData, key_string);

    if found_b == nil then
        print("key_string not find in " .. line_count)
    else
        print("key_string find in " .. line_count .. "pos [" .. found_b .. "," .. found_e .. "]");
    end
end