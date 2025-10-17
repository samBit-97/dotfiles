local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Error handling with function call
  s("iferr", {
    t("if err := "), i(1, "function()"), t("; err != nil {"),
    t({"", "\t"}), i(2, "return err"),
    t({"", "}"}), i(0)
  }),

  -- Simple error check
  s("ife", {
    t("if err != nil {"),
    t({"", "\t"}), i(1, "return err"),
    t({"", "}"}), i(0)
  }),

  -- Struct method with pointer receiver
  s("meth", fmt([[
func ({} *{}) {}({}) {} {{
	{}
}}]], {
    i(1, "s"),
    i(2, "StructName"),
    i(3, "MethodName"),
    i(4, ""),
    i(5, "returnType"),
    i(0, "// TODO: implement"),
  })),

  -- Struct method with value receiver
  s("methv", fmt([[
func ({} {}) {}({}) {} {{
	{}
}}]], {
    i(1, "s"),
    i(2, "StructName"),
    i(3, "MethodName"),
    i(4, ""),
    i(5, "returnType"),
    i(0, "// TODO: implement"),
  })),

  -- Struct method with pointer receiver and error return
  s("methe", fmt([[
func ({} *{}) {}({}) ({}, error) {{
	{}
	return {}, nil
}}]], {
    i(1, "s"),
    i(2, "StructName"),
    i(3, "MethodName"),
    i(4, ""),
    i(5, "returnType"),
    i(6, "// TODO: implement"),
    i(0, "result"),
  })),

  -- Struct method with no return
  s("methn", fmt([[
func ({} *{}) {}({}) {{
	{}
}}]], {
    i(1, "s"),
    i(2, "StructName"),
    i(3, "MethodName"),
    i(4, ""),
    i(0, "// TODO: implement"),
  })),

  -- Constructor function (New pattern)
  s("new", fmt([[
func New{}({}) *{} {{
	return &{} {{
		{}
	}}
}}]], {
    i(1, "StructName"),
    i(2, ""),
    f(function(args) return args[1][1] end, {1}),
    f(function(args) return args[1][1] end, {1}),
    i(0, "// initialize fields"),
  })),
}
