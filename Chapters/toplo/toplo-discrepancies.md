### Discrepancies with the code: Toplo widget, the high-level view

Checked on 2026-11-06 against a Pharo 15 image (Bloc, Toplo and Alexandrie from their `dev` branches)
with `BCCChapterChecker` (package `BookCodeChecker`) followed by a manual review.
Line numbers refer to `toplo.md` before the `Diff with Code` notes were added.

This chapter is mostly working notes about an earlier Toplo design (skins, looks, dressers). Most of its vocabulary is gone.

| Line | Book | Current code |
| --- | --- | --- |
| 6 | `github://plantec/Toplo/src` | `github://pharo-graphics/Toplo/src` (`dev` branch in the checked image) |
| 35 | `ToButton >> defaultSkin` | Widgets answer their skin with `newRawSkin` (e.g. `ToCheckbox>>#newRawSkin` answers `ToCheckboxSkin new`). |
| 37-43 | `ToButtonSkin` `type:`; `ToButtonDefaultType`, `ToButtonLinkType`, `ToButtonTextType` | Removed; `ToButtonSkin` does not understand `type:`. |
| 63 | `ToWidgetSkin` | `ToSkin` (still a subclass of `BlCustomEventHandler`). |
| 66, 106-135 | `ToCheckBox`, `ToCheckBoxSkin` | `ToCheckbox`, `ToCheckboxSkin` |
| 69, 83-93 | `childSkinsToHandle`, `skinnablePropertyChangedEvent:`, `ToChildSkinBuilder` | Removed. |
| 72-77 | `defaultDresser`, `ToCheckableButtonDresser`, `TToCheckboxSkin`, `ToCheckableSkin >> onSkinInstalledIn:`, `ToCheckLook` | Removed (no dressers nor looks any more). |
| 79 | `ToAbstractTheme` | `ToTheme` (`ToRawTheme`, `ToRawDarkTheme`, `ToBeeTheme`, `ToBeeDarkTheme`, `ToStyleSheetTheme`, ...). |
| 81 | `ToSkinnablePropertyChangedEvent` | Removed. |
| 98-102 | `whenAddedToSpace:in:`, `checkSpaceFrameSkinInstallationPhase`, `ToSpaceFrameSkinInstallationPhase` | Removed; Toplo spaces use `ToSpaceSkinInstallerPhase`, `ToSpaceSkinStateApplicationPhase`, `ToSpaceConfigurationPhase`. |
| 104-150 | `checkSkinInstallation`, `launchSkinInstallationIn:`, `switchToSkinState:`, `ToInitialState`, `ToElementStateChangedEvent`, `ToElementLookEvent`, `TToSkinable`, `withSkin:`, `privateUpdateChildren`, `ToClickableType` | Removed. Skins now handle `ToSkinEvent` subclasses (`ToInstallSkinEvent`, `ToHoveredSkinEvent`, `ToPressedSkinEvent`, `ToCheckedSkinEvent`, ...) generated with `ToSkinStateGenerator`. |
| 157 | `ToSandbox` | `ToSandBox` (package `Toplo-Examples`) |
| 164-167 | `requestInstallStyle`, `installLookEvent` | Removed; `installRawStyle` still exists. |

Recommendation: rewrite this chapter from the current skinning model (skins, skin events, themes and stylesheets), as presented in the skinning and stylesheet chapters.
