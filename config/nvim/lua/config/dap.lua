-- lua/config/dap.lua

local dap = require("dap")

-- DAP for C/C++ (using LLDB or GDB)
dap.adapters.lldb = {
  type = "server",
  port = 13000,
  executable = {
    command = "/usr/bin/lldb-vscode",
    args = { "--server" },
  },
}
dap.configurations.cpp = {
  { name = "C++ Debug", type = "lldb", request = "launch", program = "${workspaceFolder}/a.out", cwd = "${workspaceFolder}" },
}

-- DAP for Fortran (using LLDB)
dap.configurations.fortran = {
  { name = "Fortran Debug", type = "lldb", request = "launch", program = "${workspaceFolder}/a.out", cwd = "${workspaceFolder}" },
}
