local M = {}

local PYTHON_PATH = '$HOME/.pyenv/versions/nvim-env/bin/python3'

local function safe_python_check()
  -- Check 1: Verify Python executable exists
  if vim.fn.executable(PYTHON_PATH) ~= 1 then
    return false, {
      type = 'PATH_NOT_FOUND',
      message = string.format("Python executable not found at: %s", PYTHON_PATH)
    }
  end

  -- Check 2: Basic Python version validation
  local version_output = vim.fn.system({ PYTHON_PATH, '--version' })
  if vim.v.shell_error ~= 0 then
    return false, {
      type = 'INVALID_PYTHON',
      message = string.format("Invalid Python executable: %s", PYTHON_PATH)
    }
  end

  -- Check 3: Verify pynvim installation
  local pynvim_check = vim.fn.system({
    PYTHON_PATH,
    '-c',
    'import pynvim; print(pynvim.__version__)'
  })

  if vim.v.shell_error ~= 0 then
    return true, {  -- Success but with warning
      type = 'MISSING_PYNVIM',
      message = "pynvim package not installed in Python environment"
    }
  end

  return true
end

function M.setup()
  -- Always set the host prog first
  vim.g.python3_host_prog = PYTHON_PATH

  -- Run safety checks without pcall
  local success, err = safe_python_check()

  -- Handle errors and warnings
  if not success then
    vim.notify(err.message, vim.log.levels.ERROR, { title = "Python Setup Error" })
    return
  end

  if err and err.type == 'MISSING_PYNVIM' then
    vim.notify(err.message, vim.log.levels.WARN, { title = "Python Setup Warning" })
  end
end

return M
