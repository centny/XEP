------------------------------------------------------
------------------value define------------------------
------------------------------------------------------
--pattern and index define.
XEP_METHOD_IDX=1
XEP_METHOD_PTN="^[%+%-]%s*%([^%)]*%)[^:]*:?[^%{]*$"
XEP_CLS_IDX=2
XEP_INTERFACE_PTN="^%s*%@interface[^%@]*$"
XEP_IMPL_PTN="^%s*%@implementation[^%@]*$"
XEP_PROTOCOL_PTN="^%s*%@protocol[^%@]*$"
XEP_PRO_IDX=3
XEP_PROPERTY_PTN="^%s*%@property[^%@]*$"
XEP_ENUM_IDX=4
XEP_ENUM_PTH="^%s*typedef%s+enum%s+[^%{]*%{[^%}]+%}[^%{%}]*$"
XEP_STRUCT_IDX=5
XEP_STRUCT_PTH="^%s*struct%s+[^%{]*%{[^}]+;[%s]*$"
XEP_DEFINE_IDX=6
XEP_DEFINE_PTH="^%s*%#define%s+.*$"


------------------------------------------------------
-----------------normal method------------------------
------------------------------------------------------
--tools methods.
function split(str, split_char)
    local sub_str_tab = {};
    while (true) do
        local pos = string.find(str, split_char);
        if (not pos) then
            sub_str_tab[#sub_str_tab + 1] = str;
            break;
        end
        local sub_str = string.sub(str, 1, pos - 1);
        sub_str_tab[#sub_str_tab + 1] = sub_str;
        str = string.sub(str, pos + 1, #str);
    end
    return sub_str_tab;
end
function logTable(arg)
	for i,v in ipairs(arg)do
		print(string.format("%d\t %s",i,v))
	end
end

--create the method comment
function ocMethodComment(block)
	local bary=split(block,":")
	local params={}
	for i,v in ipairs(bary)do
		local execute=function()
			if i==1 then return end
			local pn=string.gsub(string.gsub(string.gsub(v,"^[^%)]+%)",""),"%s+[^%s]+$",""),"\n","")
			params[#params+1]=pn
		end
		execute()
	end
--	logTable(params)
	local rparam=string.gsub(string.sub(bary[1],string.find(bary[1],"%([^%)]+%)")),"[%(%)]","")
--	print(rparam)
	local rstr="/**\n	<#Old Description#>\n"
	for i,v in ipairs(params)do
		rstr=string.format("%s	@param %s <#%s description#>\n",rstr,v,v)
	end
	if not (rparam=="void" or rparam=="IBAction") then
		rstr=string.format("%s	@returns <#return value description#>\n",rstr)
	end
	rstr=string.format("%s */\n",rstr)
--	print(rstr)
	return rstr
end
--create property comment
function ocProComment(block)
	return "/**\n	<#Old Description#>\n */\n"
end
--create class comment
function ocClsComment(block)
    if(VERSION)then
	     return string.format("/**\n	<#Old Description#>\n	@author %s\n	@since %s\n */\n",FULLUSERNAME,VERSION)
	else
		 return string.format("/**\n	<#Old Description#>\n	@author %s\n */\n",FULLUSERNAME)
	end
end
--create enum or struct comment
function ocEnumComment(block)
    local optstr=string.gsub(string.sub(block,string.find(block,"%{[^%}]*%}")),"[%s%{%}]+","")
    local options=split(optstr,",")
    local comment=""
    for i,v in ipairs(options)do
        if(i==#options)then
            comment=string.format("%s	%s	/** <#Description#> */\n",comment,v)
        else
            comment=string.format("%s	%s,	/** <#Description#> */\n",comment,v)
        end
    end
    comment=string.format("{\n%s}",comment)
    comment=string.gsub(block,"%{[^%}]*%}",comment)
    comment=string.format("/**\n	<#Old Description#>\n */\n%s",comment)
    return comment
end
function ocStructComment(block)
    local optstr=string.gsub(string.sub(block,string.find(block,"%{[^%}]*")),"[\n%{]+","")
    local options=split(optstr,";")
    local comment=""
    for i,v in ipairs(options)do
        v=string.gsub(string.gsub(v,"^%s*",""),"%s*$","")
        if string.len(v)>0 then
			comment=string.format("%s	%s;	/** <#Description#> */\n",comment,v)
		end
    end
    comment=string.format("{\n%s",comment)
    comment=string.gsub(block,"%{[^%}]*",comment)
    comment=string.format("/**\n	<#Old Description#>\n */\n%s",comment)
    return comment
end
--create the define comment.
function ocDefineComment(block)
    local nstr=string.gsub(block,"\\\n","")
    if string.find(nstr,"^%s*#define%s+[^(%s]+%([^%)]*%)%s*") then
        local pstr=string.sub(nstr,string.find(nstr,"^%s*#define%s+[^(%s]+%([^%)]*%)%s*"))
        local param=string.gsub(string.gsub(string.gsub(pstr,"^[^(]*%(",""),"%).*$",""),"%s+","")
        local pars=split(param,",")
        local comment="/**\n	<#Old Description#>\n"
        for i,v in ipairs(pars)do
            comment=string.format("%s	@param %s <#Description#>\n",comment,v)
        end
        comment=string.format("%s	@returns <#Description#>\n",comment)
        comment=string.format("%s */\n",comment)
        return comment
    end
    if string.find(nstr,"^%s*#define%s+[^(%s]+%s*") then
        return "/**\n	<#Old Description#>\n	@returns <#Description#>\n */\n"
    end
end
------------------------------------------------------
--------------call back method------------------------
------------------------------------------------------
--create the block index if it mathed.
function blockIdx(bundle,block)
--  print(FULLUSERNAME)
--	print(USERNAME)
--	print("abc---",block)
--  print(string.sub(block,string.find(block,XEP_METHOD_PTN)))
	if string.find(block,XEP_METHOD_PTN) then return XEP_METHOD_IDX end
	if string.find(block,XEP_INTERFACE_PTN) then return XEP_CLS_IDX end
	if string.find(block,XEP_IMPL_PTN) then return XEP_CLS_IDX end
	if string.find(block,XEP_PROPERTY_PTN) then return XEP_PRO_IDX end
	if string.find(block,XEP_PROTOCOL_PTN) then return XEP_CLS_IDX end
	if string.find(block,XEP_ENUM_PTH) then return XEP_ENUM_IDX end
	if string.find(block,XEP_STRUCT_PTH) then return XEP_STRUCT_IDX end
	if string.find(block,XEP_DEFINE_PTH) then return XEP_DEFINE_IDX end
	return 0
end
--check if replace the old code
function isReplaceOld(bundle,block,idx)
    if idx==XEP_ENUM_IDX or idx==XEP_STRUCT_IDX then return 1 end
    return 0
end
--create the block comment by block and block index.
function blockComment(bundle,block,idx)
--	print("idx:",idx)
	if(idx==XEP_METHOD_IDX)then return ocMethodComment(block) end
	if(idx==XEP_CLS_IDX)then return ocClsComment(block) end
	if(idx==XEP_PRO_IDX)then return ocProComment(block) end
	if(idx==XEP_ENUM_IDX)then return ocEnumComment(block) end
	if(idx==XEP_STRUCT_IDX)then return ocStructComment(block) end
	if(idx==XEP_DEFINE_IDX)then return ocDefineComment(block) end
	return ""
end
--create the insert line for the comment.it will relative by mathed start line.
function commentInsertLine(bundle,block,idx)
	return 0
end
--create the cursor postion after insert text.
function cursorPosition(bundle,insertloc,textlen)
	return insertloc+textlen-1
end

------------------------------------------------------
--------------------Test code-------------------------
------------------------------------------------------
--print(blockIdx("/tmp","- (void)\nsfds"))
--print(blockIdx("/tmp","	@param s s <#s s description#>"))
--print(blockIdx("/tmp","	@--end"))
--print(blockIdx("/tmp","	@interface"))
--print(blockIdx("/tmp","	@implementation"))
--print(blockIdx("/tmp","	@property"))
--print(string.find("@interface","^%s*%@interface[^%@]*$"))
--ocMethodComment("- (void)\nsfds:(nss*)ab\nc")
--print(blockComment("/tmp","- (void)\nsfds:(nss*)ab\nc",XEP_ME--THOD_IDX))
--print(blockComment("/tmp","- (int)\nsfds:(nss*)ab\nc",XEP_METHOD_IDX))
--print(blockComment("/tmp","- (int)\nsfds:(nss*)ab\nc a:(ss*)s",XEP_METHOD_IDX))
--print(ocEnumStrComment("typedef enum ab{a,b,c}ab"))
--print(ocStructComment("struct SSS{\n    CGRect s;\n"))
--print(ocDefineComment("#define ab(a,\\\nc) a+c"))
--print(ocDefineComment("#define ab \\\na+c"))
--print(userName())