import std.stdio;
import core.sys.windows.windows;
import core.sys.windows.winuser;
import minhook;

/*------------------------*/
// Target function prototype
alias func = extern (C) int function(int);
func funcOriginal = NULL;

/*------------------------*/
extern (Windows) func ourHook(int i)
{
  return cast(func) 500;
}

/*------------------------*/
// Setup/Place hook
void go()
{
  MH_Initialize();

  auto hook = MH_CreateHook(cast(LPVOID) 0x7FF72411E700, &ourHook, &funcOriginal);
  if (hook != 0)
    MessageBoxA(null, "Hook was not placed.", "!", MB_OK);

  auto hookEnable = MH_EnableHook(cast(void*) hook);
  if (hookEnable != 0)
    MessageBoxA(null, "Hook was not enabled.", "!", MB_OK);

  for (;;)
  {
    if (GetAsyncKeyState(0x5) & 1)
    {
      writeln("Exit");
      break;
    }
  }

  // MH_DisableHook(cast(void*)hook);
  // MH_Uninitialize();
}

/*------------------------*/
extern (Windows)
BOOL DllMain(HMODULE module_, uint reason, void * aids)
{
  if (reason == DLL_PROCESS_ATTACH)
  {
    go();
  }
  else if (reason == DLL_PROCESS_DETACH)
  {
    MessageBoxA(null, "Ejected.", "!", MB_OK);
  }

  return true;
}
