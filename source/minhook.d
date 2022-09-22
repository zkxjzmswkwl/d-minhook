import core.sys.windows.windows;
import core.sys.windows.winuser;

extern (Windows)
{
  // Initialize the MinHook library. You must call this function EXACTLY ONCE
  // at the beginning of your program.
  size_t MH_Initialize();

  // Uninitialize the MinHook library. You must call this function EXACTLY
  // ONCE at the end of your program.
  size_t MH_Uninitialize();

  // Creates a hook for the specified target function, in disabled state.
  // Parameters:
  //   pTarget     [in]  A pointer to the target function, which will be
  //                     overridden by the detour function.
  //   pDetour     [in]  A pointer to the detour function, which will override
  //                     the target function.
  //   ppOriginal  [out] A pointer to the trampoline function, which will be
  //                     used to call the original target function.
  //                     This parameter can be NULL.
  size_t MH_CreateHook(void* pTarget, const(void)* pDetour, void* ppOriginal);

  // Creates a hook for the specified API function, in disabled state.
  // Parameters:
  //   pszModule   [in]  A pointer to the loaded module name which contains the
  //                     target function.
  //   pszProcName [in]  A pointer to the target function name, which will be
  //                     overridden by the detour function.
  //   pDetour     [in]  A pointer to the detour function, which will override
  //                     the target function.
  //   ppOriginal  [out] A pointer to the trampoline function, which will be
  //                     used to call the original target function.
  //                     This parameter can be NULL.
  size_t MH_CreateHookApi(
    const(wchar)* pszModule, const(char)* pszProcName, const(void)* pDetour, void* ppOriginal);

  // Creates a hook for the specified API function, in disabled state.
  // Parameters:
  //   pszModule   [in]  A pointer to the loaded module name which contains the
  //                     target function.
  //   pszProcName [in]  A pointer to the target function name, which will be
  //                     overridden by the detour function.
  //   pDetour     [in]  A pointer to the detour function, which will override
  //                     the target function.
  //   ppOriginal  [out] A pointer to the trampoline function, which will be
  //                     used to call the original target function.
  //                     This parameter can be NULL.
  //   ppTarget    [out] A pointer to the target function, which will be used
  //                     with other functions.
  //                     This parameter can be NULL.
  size_t MH_CreateHookApiEx(
    const(wchar)* pszModule, const(char)* pszProcName, const(void)* pDetour, void* ppOriginal, void* ppTarget);

  // Removes an already created hook.
  // Parameters:
  //   pTarget [in] A pointer to the target function.
  size_t MH_RemoveHook(void* pTarget);

  // Enables an already created hook.
  // Parameters:
  //   pTarget [in] A pointer to the target function.
  //                If this parameter is MH_ALL_HOOKS, all created hooks are
  //                enabled in one go.
  size_t MH_EnableHook(void* pTarget);

  // Disables an already created hook.
  // Parameters:
  //   pTarget [in] A pointer to the target function.
  //                If this parameter is MH_ALL_HOOKS, all created hooks are
  //                disabled in one go.
  size_t MH_DisableHook(void* pTarget);

  // Queues to enable an already created hook.
  // Parameters:
  //   pTarget [in] A pointer to the target function.
  //                If this parameter is MH_ALL_HOOKS, all created hooks are
  //                queued to be enabled.
  size_t MH_QueueEnableHook(void* pTarget);

  // Queues to disable an already created hook.
  // Parameters:
  //   pTarget [in] A pointer to the target function.
  //                If this parameter is MH_ALL_HOOKS, all created hooks are
  //                queued to be disabled.
  size_t MH_QueueDisableHook(void* pTarget);

  // Applies all queued changes in one go.
  size_t MH_ApplyQueued(void*);

  // Translates the size_t to its name as a string.
  // This won't work I'm 99% sure.
  string MH_StatusToString(size_t status);
}
