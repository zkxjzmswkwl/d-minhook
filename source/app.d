import std.stdio;
import core.runtime;
import core.sys.windows.windows;
import core.sys.windows.winuser;
import minhook;

/*------------------------*/
// Target function prototype
__gshared
typeof(ourHook)* funcOriginal;

/*------------------------*/
// Our hook
extern (Windows)
size_t ourHook(int i)
{
  writefln!"Called from hook";
  return funcOriginal(500);
}

void* go()
{
  // Not necessary to get output if the target process already has console allocated.
  AllocConsole();
  freopen("CON", "w", stdout.getFP);

  void* moduleBase = cast(void*) GetModuleHandleA(null);
  writefln!"Base: %X"(cast(size_t) moduleBase + 0xE700);

  enum testFunc = 0xE700;
  size_t testFuncRelative = cast(size_t)(moduleBase + testFunc);

  auto hook = MH_CreateHook(cast(LPVOID) testFuncRelative, &ourHook, &funcOriginal);
  if (hook != 0)
    MessageBoxA(null, "Hook was not placed.", "!", MB_OK);

  auto hookEnable = MH_EnableHook(cast(void*) hook);
  if (hookEnable != 0)
    MessageBoxA(null, "Hook was not enabled.", "!", MB_OK);

  for (;;)
  {
    if (GetAsyncKeyState(VK_UP) & 0x01)
    {
      writeln("\nExiting\n");
      break;
    }

    writeln("Loop");
    Sleep(100);
  }

  MH_DisableHook(cast(void*) hook);
  MH_RemoveHook(cast(void*) hook);
  MH_Uninitialize();

  // Not necessary to get output if the target process already has console allocated.
  FreeConsole();

  return null;
}

/*------------------------*/
// WINMAIN Entrypoint
extern (Windows)
BOOL DllMain(HMODULE module_, uint reason, void* aids)
{
  if (reason == DLL_PROCESS_ATTACH)
  {
    Runtime.initialize;
    MH_Initialize();
    CloseHandle(
      CreateThread(
        cast(SECURITY_ATTRIBUTES*) NULL,
        cast(ulong) 0,
        cast(LPTHREAD_START_ROUTINE) go(),
        cast(PVOID) module_,
        cast(uint) 0,
        cast(uint*) NULL
    )
    );
  }
  else if (reason == DLL_PROCESS_DETACH)
  {
    FreeLibraryAndExitThread(module_, 0);
    MessageBoxA(null, "Ejected.", "!", MB_OK);
    Runtime.terminate;
  }

  return false;
}
