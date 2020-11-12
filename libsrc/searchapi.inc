!* Search API
!* mikeduglas@yandex.ru 2020

  INCLUDE('searchapi.int')

TSearchManager                CLASS, TYPE, MODULE('searchapi.clw'), LINK('searchapi.clw')
m_COMIniter                     &CCOMIniter, PRIVATE
m_sm                            &ISearchManager, PRIVATE

Construct                       PROCEDURE()
Destruct                        PROCEDURE(), VIRTUAL
CreateInstance                  PROCEDURE(), BOOL, PROC
Release                         PROCEDURE()
GetCatalog                      PROCEDURE(STRING pszCatalog),*TSearchCatalogManager
                              END

TSearchCatalogManager         CLASS, TYPE, MODULE('searchapi.clw'), LINK('searchapi.clw')
m_scm                           &ISearchCatalogManager, PRIVATE

Construct                       PROCEDURE()
Destruct                        PROCEDURE(), VIRTUAL
Init                            PROCEDURE(LONG pAddr), BOOL, PROC
Release                         PROCEDURE()
!GetName                         PROCEDURE(), STRING
!GetParameter                    PROCEDURE(STRING pszName), ?
!SetParameter                    PROCEDURE(STRING pszName, ? pValue), BOOL, PROC
!GetCatalogStatus                PROCEDURE(*CatalogStatus pStatus, *CatalogPausedReason pPausedReason), BOOL, PROC
!Reset                           PROCEDURE(), BOOL, PROC
!Reindex                         PROCEDURE(), BOOL, PROC
!ReindexMatchingURLs             PROCEDURE(STRING pszPattern), BOOL, PROC
!ReindexSearchRoot               PROCEDURE(STRING pszRootURL), BOOL, PROC
!ConnectTimeout                  PROCEDURE(LONG dwConnectTimeout), BOOL, PROC
!ConnectTimeout                  PROCEDURE(), LONG
!DataTimeout                     PROCEDURE(LONG dwDataTimeout), BOOL, PROC
!DataTimeout                     PROCEDURE(), LONG
!NumberOfItems                   PROCEDURE(), LONG
!NumberOfItemsToIndex            PROCEDURE(*LONG plIncrementalCount, *LONG plNotificationQueue, *LONG plHighPriorityQueue), BOOL, PROC
!URLBeingIndexed                 PROCEDURE(), STRING
!GetURLIndexingState             PROCEDURE(STRING pszURL), LONG
!SetExtensionClusion             PROCEDURE(STRING pszExtension, BOOL fExclude), BOOL, PROC
GetCrawlScopeManager            PROCEDURE(),*TSearchCrawlScopeManager
                              END

TSearchCrawlScopeManager      CLASS, TYPE, MODULE('searchapi.clw'), LINK('searchapi.clw')
m_scsm                          &ISearchCrawlScopeManager, PRIVATE

Construct                       PROCEDURE()
Destruct                        PROCEDURE(), VIRTUAL
Init                            PROCEDURE(LONG pAddr), BOOL, PROC
Release                         PROCEDURE()
!AddDefaultScopeRule             PROCEDURE(STRING pszURL, BOOL fInclude, LONG fFollowFlags), BOOL, PROC
!AddRoot                         PROCEDURE(LONG pSearchRoot), BOOL, PROC
!RemoveRoot                      PROCEDURE(STRING pszURL), BOOL, PROC
!EnumerateRoots                  PROCEDURE(LONG ppSearchRoots), BOOL, PROC
AddHierarchicalScope            PROCEDURE(STRING pszURL, BOOL fInclude, BOOL fDefault, BOOL fOverrideChildren), BOOL, PROC
AddUserScopeRule                PROCEDURE(STRING pszURL, BOOL fInclude, BOOL fOverrideChildren, FOLLOW_FLAGS fFollowFlags), BOOL, PROC
!RemoveScopeRule                 PROCEDURE(STRING pszRule), BOOL, PROC
!EnumerateScopeRules             PROCEDURE(LONG ppSearchScopeRules), BOOL, PROC
!HasParentScopeRule              PROCEDURE(STRING pszURL), BOOL
!HasChildScopeRule               PROCEDURE(STRING pszURL), BOOL
!IncludedInCrawlScope            PROCEDURE(STRING pszURL), BOOL
!IncludedInCrawlScopeEx          PROCEDURE(STRING pszURL, *BOOL pfIsIncluded, *CLUSION_REASON pReason), BOOL, PROC
!RevertToDefaultScopes           PROCEDURE(), BOOL, PROC
SaveAll                         PROCEDURE(), BOOL, PROC
!GetParentScopeVersionId         PROCEDURE(STRING pszURL), LONG
!RemoveDefaultScopeRule          PROCEDURE(STRING pszURL), BOOL, PROC
                              END

TSearchApiHelper              CLASS, TYPE, MODULE('searchapi.clw'), LINK('searchapi.clw')
m_COMIniter                     &CCOMIniter, PRIVATE

Construct                       PROCEDURE()
Destruct                        PROCEDURE(), VIRTUAL
GetCrawlScopeManager            PROCEDURE(<STRING pCatalog>), *TSearchCrawlScopeManager
AddUserScopeRule                PROCEDURE(STRING pszURL, BOOL fInclude, BOOL fOverrideChildren, FOLLOW_FLAGS fFollowFlags), BOOL, PROC
IncludeFolderRule               PROCEDURE(STRING pFolder), BOOL, PROC
ExcludeFolderRule               PROCEDURE(STRING pFolder), BOOL, PROC
                              END
