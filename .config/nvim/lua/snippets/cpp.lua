local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Basic method (void return type)
  s("meth", fmt([[
void {}({}) {{
	{}
}}]], {
    i(1, "methodName"),
    i(2, ""),
    i(0, "// TODO: implement"),
  })),

  -- Method with return type
  s("methret", fmt([[
{} {}({}) {{
	{}
	return {};
}}]], {
    i(1, "returnType"),
    i(2, "methodName"),
    i(3, ""),
    i(4, "// TODO: implement"),
    i(0, "defaultValue"),
  })),

  -- Class method (with this pointer context)
  s("methc", fmt([[
void {}::{}({}) {{
	{}
}}]], {
    i(1, "ClassName"),
    i(2, "methodName"),
    i(3, ""),
    i(0, "// TODO: implement"),
  })),

  -- Const method
  s("methconst", fmt([[
void {}({}) const {{
	{}
}}]], {
    i(1, "methodName"),
    i(2, ""),
    i(0, "// TODO: implement"),
  })),

  -- Constructor
  s("ctor", fmt([[
{}::{}({}) {{
	{}
}}]], {
    i(1, "ClassName"),
    i(2, "ClassName"),
    i(3, ""),
    i(0, "// TODO: initialize"),
  })),

  -- Destructor
  s("dtor", fmt([[
{}::~{}() {{
	{}
}}]], {
    i(1, "ClassName"),
    i(2, "ClassName"),
    i(0, "// TODO: cleanup"),
  })),

  -- Getter method
  s("getter", fmt([[
{} get{}() const {{
	return {};
}}]], {
    i(1, "Type"),
    i(2, "PropertyName"),
    i(0, "member"),
  })),

  -- Setter method
  s("setter", fmt([[
void set{}({} value) {{
	this->{}_ = value;
}}]], {
    i(1, "PropertyName"),
    i(2, "Type"),
    i(0, "member"),
  })),

  -- Operator overload
  s("op", fmt([[
{} operator{}({}) {{
	{}
}}]], {
    i(1, "returnType"),
    i(2, "=="),
    i(3, "const ClassName& other"),
    i(0, "// TODO: implement"),
  })),
}
