!* Search API
!* mikeduglas@yandex.ru 2020

  MEMBER

  INCLUDE('searchapi.inc'), ONCE

  MAP
    MODULE('WIN API')
      winapi::CoCreateInstance(REFCLSID rclsid, LONG pUnkOuter, LONG dwClsContext, REFIID riid, *LONG ppvObject),LONG,RAW,PASCAL,NAME('CoCreateInstance')
      winapi::MultiByteToWideChar(UNSIGNED Codepage, ULONG dwFlags, ULONG LpMultuByteStr, LONG cbMultiByte, ULONG LpWideCharStr, LONG cchWideChar), RAW, ULONG, PASCAL, PROC, NAME('MultiByteToWideChar')
      winapi::WideCharToMultiByte(UNSIGNED Codepage, ULONG dwFlags, ULONG LpWideCharStr, LONG cchWideChar, ULONG lpMultuByteStr, LONG cbMultiByte, ULONG LpDefalutChar, ULONG lpUsedDefalutChar), RAW, ULONG, PASCAL, PROC, NAME('WideCharToMultiByte')
      winapi::GetLastError(),lONG,PASCAL,NAME('GetLastError')
    END

    SUCCEEDED(HRESULT hr), BOOL, PRIVATE
    FAILED(HRESULT hr), BOOL, PRIVATE
    StringToWideChar(STRING pInput), *CSTRING, PRIVATE

    INCLUDE('printf.inc'), ONCE
  END

!!!region static functions
SUCCEEDED                     PROCEDURE(HRESULT hr)
  CODE
  RETURN CHOOSE(hr >= 0)
  
FAILED                        PROCEDURE(HRESULT hr)
  CODE
  RETURN CHOOSE(hr < 0)

StringToWideChar              PROCEDURE(STRING pInput)
szInput                         CSTRING(LEN(pInput) + 1)
cOleStr                         &CSTRING
dwWideChrs                      LONG, AUTO
  CODE
  szInput = pInput
  !- get length of UnicodeText in characters
  dwWideChrs = winapi::MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, ADDRESS(szInput), -1, 0, 0)
  IF dwWideChrs
    !- get UnicodeText terminated by <0,0>
    cOleStr &= NEW CSTRING(dwWideChrs * 2 + 2)
    winapi::MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, ADDRESS(szInput), -1, ADDRESS(cOleStr), dwWideChrs)
  ELSE
    printd('MultiByteToWideChar error %i', winapi::GetLastError())
  END
  
  RETURN cOleStr
!!!endregion
  
!!!region TSearchManager
TSearchManager.Construct      PROCEDURE()
  CODE
  SELF.m_COMIniter &= NEW CCOMIniter

TSearchManager.Destruct       PROCEDURE()
  CODE
  SELF.Release()
  DISPOSE(SELF.m_COMIniter)

TSearchManager.CreateInstance PROCEDURE()
lpi                             LONG, AUTO
hr                              HRESULT, AUTO
  CODE
  hr = winapi::CoCreateInstance(ADDRESS(CLSID_ISearchManager), 0, CLSCTX_LOCAL_SERVER, ADDRESS(IID_ISearchManager), lpi)
  IF SUCCEEDED(hr)
    SELF.m_sm &= (lpi)
    RETURN TRUE
  ELSE  
    printd('CoCreateInstance(CLSID_ISearchManager) error: %x', hr)
    SELF.m_sm &= NULL
    RETURN FALSE
  END

TSearchManager.Release        PROCEDURE()
  CODE
  IF NOT SELF.m_sm &= NULL
    SELF.m_sm.Release()
  END

TSearchManager.GetCatalog     PROCEDURE(STRING pszCatalog)
szCatalog                       &CSTRING
lpi                             LONG, AUTO
hr                              HRESULT, AUTO
scm                             &TSearchCatalogManager
  CODE
  IF NOT SELF.m_sm &= NULL
    szCatalog &= StringToWideChar(CLIP(pszCatalog))
    hr = SELF.m_sm.GetCatalog(ADDRESS(szCatalog), ADDRESS(lpi))
    DISPOSE(szCatalog)
    IF SUCCEEDED(hr)
      scm &= NEW TSearchCatalogManager
      scm.Init(lpi)
    ELSE
      printd('TSearchManager.GetCatalog(%S) error: %x', pszCatalog, hr)
    END
  ELSE
    printd('TSearchManager.GetCatalog(%S): call CreateInstance first.', pszCatalog)
  END
  
  RETURN scm
!!!endregion
  
!!!region TSearchCatalogManager
TSearchCatalogManager.Construct   PROCEDURE()
  CODE
  SELF.m_COMIniter &= NEW CCOMIniter

TSearchCatalogManager.Destruct    PROCEDURE()
  CODE
  SELF.Release()
  DISPOSE(SELF.m_COMIniter)

TSearchCatalogManager.Init    PROCEDURE(LONG pAddr)
  CODE
  IF pAddr
    SELF.m_scm &= (pAddr)
    RETURN TRUE
  ELSE
    printd('TSearchCatalogManager.Init(): null argument')
    RETURN FALSE
  END
  
TSearchCatalogManager.Release PROCEDURE()
  CODE
  IF NOT SELF.m_scm &= NULL
    SELF.m_scm.Release()
  END

TSearchCatalogManager.GetCrawlScopeManager    PROCEDURE()
lpi                                             LONG, AUTO
hr                                              HRESULT, AUTO
scsm                                            &TSearchCrawlScopeManager
  CODE
  IF NOT SELF.m_scm &= NULL
    hr = SELF.m_scm.GetCrawlScopeManager(ADDRESS(lpi))
    IF SUCCEEDED(hr)
      scsm &= NEW TSearchCrawlScopeManager
      scsm.Init(lpi)
    ELSE
      printd('TSearchCatalogManager.GetCrawlScopeManager() error: %x', hr)
    END
  ELSE
    printd('TSearchCatalogManager.GetCrawlScopeManager(): call Init first.')
  END

  RETURN scsm
!!!endregion
  
!!!region TSearchCrawlScopeManager
TSearchCrawlScopeManager.Construct    PROCEDURE()
  CODE
  SELF.m_COMIniter &= NEW CCOMIniter

TSearchCrawlScopeManager.Destruct PROCEDURE()
  CODE
  SELF.Release()
  DISPOSE(SELF.m_COMIniter)

TSearchCrawlScopeManager.Init PROCEDURE(LONG pAddr)
  CODE
  IF pAddr
    SELF.m_scsm &= (pAddr)
    RETURN TRUE
  ELSE
    printd('TSearchCrawlScopeManager.Init(): null argument')
    RETURN FALSE
  END

TSearchCrawlScopeManager.Release  PROCEDURE()
  CODE
  IF NOT SELF.m_scsm &= NULL
    SELF.m_scsm.Release()
  END

TSearchCrawlScopeManager.AddHierarchicalScope PROCEDURE(STRING pszURL, BOOL fInclude, BOOL fDefault, BOOL fOverrideChildren)
szURL                                           &CSTRING
hr                                              HRESULT, AUTO
  CODE
  IF NOT SELF.m_scsm &= NULL
    szURL &= StringToWideChar(CLIP(pszURL))
    hr = SELF.m_scsm.AddHierarchicalScope(ADDRESS(szURL), fInclude, fDefault, fOverrideChildren)
    DISPOSE(szURL)
    IF SUCCEEDED(hr)
      RETURN TRUE
    ELSE
      printd('TSearchCrawlScopeManager.AddHierarchicalScope(%S) error: %x', pszURL, hr)
    END
  ELSE
    printd('TSearchCrawlScopeManager.AddHierarchicalScope(%S): call Init first.', pszURL)
  END

  RETURN FALSE
  
TSearchCrawlScopeManager.AddUserScopeRule PROCEDURE(STRING pszURL, BOOL fInclude, BOOL fOverrideChildren, FOLLOW_FLAGS fFollowFlags)
szURL                                       &CSTRING
hr                                          HRESULT, AUTO
  CODE
  IF NOT SELF.m_scsm &= NULL
    szURL &= StringToWideChar(CLIP(pszURL))
    hr = SELF.m_scsm.AddUserScopeRule(ADDRESS(szURL), fInclude, fOverrideChildren, fFollowFlags)
    DISPOSE(szURL)
    IF SUCCEEDED(hr)
      RETURN TRUE
    ELSE
      printd('TSearchCrawlScopeManager.AddUserScopeRule(%S) error: %x', pszURL, hr)
    END
  ELSE
    printd('TSearchCrawlScopeManager.AddUserScopeRule(%S): call Init first.', pszURL)
  END

  RETURN FALSE
  
TSearchCrawlScopeManager.SaveAll  PROCEDURE()
hr                                  HRESULT, AUTO
  CODE
  IF NOT SELF.m_scsm &= NULL
    hr = SELF.m_scsm.SaveAll()
    IF SUCCEEDED(hr)
      RETURN TRUE
    ELSE
      printd('TSearchCrawlScopeManager.SaveAll() error: %x', hr)
    END
  ELSE
    printd('TSearchCrawlScopeManager.SaveAll(): call Init first.')
  END
  
  RETURN FALSE
!!!endregion
  
!!!region TSearchApiHelper
TSearchApiHelper.GetCrawlScopeManager PROCEDURE(<STRING pCatalog>)
sm                                      TSearchManager
scm                                     &TSearchCatalogManager
scsm                                    &TSearchCrawlScopeManager
  CODE
  IF sm.CreateInstance()
    IF NOT pCatalog
      scm &= sm.GetCatalog('SystemIndex')
    ELSE
      scm &= sm.GetCatalog(pCatalog)
    END
    IF NOT scm &= NULL
      scsm &= scm.GetCrawlScopeManager()
      DISPOSE(scm)
    END
  END
  
  RETURN scsm

TSearchApiHelper.AddUserScopeRule PROCEDURE(STRING pszURL, BOOL fInclude, BOOL fOverrideChildren, FOLLOW_FLAGS fFollowFlags)
scsm                                &TSearchCrawlScopeManager
ret                                 BOOL(FALSE)
  CODE
  scsm &= SELF.GetCrawlScopeManager()
  IF NOT scsm &= NULL
    IF scsm.AddUserScopeRule(pszURL, fInclude, fOverrideChildren, fFollowFlags)
      ret = scsm.SaveAll()
    END
    DISPOSE(scsm)
  END
  
  RETURN ret  

TSearchApiHelper.IncludeFolderRule    PROCEDURE(STRING pFolder)
  CODE
  RETURN SELF.AddUserScopeRule(printf('file:///%s', pFolder), TRUE, TRUE, 0)

TSearchApiHelper.ExcludeFolderRule    PROCEDURE(STRING pFolder)
  CODE
  RETURN SELF.AddUserScopeRule(printf('file:///%s', pFolder), FALSE, TRUE, 0)
!!!endregion