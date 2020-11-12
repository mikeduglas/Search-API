  PROGRAM
  
  !- enable SVCOM classes
  PRAGMA('project(#pragma define(_SVDllMode_ => 0))')
  PRAGMA('project(#pragma define(_SVLinkMode_ => 1))')

  INCLUDE('searchapi.inc'), ONCE

  MAP
  END

sahlp                         TSearchApiHelper
ret                           BOOL, AUTO

  CODE
  ret = sahlp.IncludeFolderRule(LONGPATH()) !- include current path (and subdirectories) to search index.
!  ret = sahlp.ExcludeFolderRule(LONGPATH()) !- exclude current path (and subdirectories) from search index.

  IF ret
    MESSAGE('Complete!')
  ELSE
    MESSAGE('Failed!')
  END
  