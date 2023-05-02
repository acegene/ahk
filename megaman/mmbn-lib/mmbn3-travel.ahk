#include "%A_ScriptDir%\mmbn-lib\mmbn3-misc.ahk"

#include <keypress-utils>

;; helper functions
PurchaseTicketFromStnToStn(from_stn, to_stn) {
    ;; initial prompt to enter ticket selection
    HoldKeyE("j", 50)
    Sleep(100)
    HoldKeyE("j", 50)
    Sleep(500)
    ;; get unique keys for each stn combination
    keys := []
    if (from_stn = "acdc") {
        if (to_stn = "beach") {
            keys.Push("s")
            keys.Push("j")
        }
    } else if (from_stn = "yoka") {
        if (to_stn = "acdc") {
            keys.Push("j")
        } else if (to_stn = "beach") {
            keys.Push("s")
            keys.Push("j")
        }
    } else if (from_stn = "beach") {
        if (to_stn = "acdc") {
            keys.Push("j")
        } else if (to_stn = "yoka") {
            keys.Push("s")
            keys.Push("j")
        }
    }
    if (keys.Length = 0) {
        MsgBox("FATAL: unhandled stn choices; from_stn=" . from_stn . ", to_stn=" . to_stn)
        ExitApp(1)
    }
    ;; purchase ticket
    for (key in keys) {
        HoldKeyE(key, 50)
        Sleep(100)
    }
    ;; finish dialog after ticket purchase and close menu
    RepeatHoldKeyForDurationE("k", 50, 1000)
}

TravelHospLobbyAtChipTraderToHospLobbyAtVendingComp() {
    HoldKeysE(["w", "k"], 200)
    HoldKeysE(["d", "k"], 50)
    Sleep(1000)
}

TravelHospLobbyAtVendingCompToHospLobbyAtChipTrader() {
    HoldKeysE(["a", "k"], 200)
    HoldKeysE(["s", "k"], 50)
    Sleep(1000)
}

TravelHospLobbyAtVendingCompToVendingCompAtGambler(w_win, h_win) {
    SaveProgress()
    while (true) {
        JackIn()
        HoldKeysE(["d", "k"], 3000)
        HoldKeysE(["a", "k"], 1000)
        Sleep(300)
        if (ratio_rgbs_megaman_side_foot.DoesWindowMatchRatioRgbs(w_win, h_win)) {
            Sleep(1000)
            break
        } else {
            ResetGame()
        }
    }
    HoldKeyE("s", 200)
    Sleep(100)
    HoldKeyE("a", 200)
    Sleep(100)
    HoldKeyE("w", 200)
    Sleep(1000)
}

;; acdc
TravelAcdcStnAtAcdcToStn(to_stn) {
    HoldKeysE(["w", "a", "k"], 500)
    HoldKeysE(["w", "k"], 2000)
    Sleep(100)
    HoldKeyE("d", 50)
    Sleep(100)
    PurchaseTicketFromStnToStn("acdc", to_stn)
    HoldKeysE(["a", "k"], 1500)
    HoldKeysE(["s", "k"], 1000)
    HoldKeysE(["d", "k"], 3500)
    Sleep(100)
    HoldKeyE("j", 50)
    Sleep(500)
    HoldKeyE("j", 50)
    Sleep(1000)
}

TravelAcdcStnAtGateToAcdc() {
    HoldKeysE(["s", "k"], 1000)
    Sleep(1000)
}

TravelAcdcAtHisbysToAcdcStn() {
    HoldKeysE(["s", "d", "k"], 400)
    HoldKeysE(["s", "a", "k"], 4300)
    HoldKeysE(["s", "d", "k"], 2500)
    HoldKeysE(["w", "d", "k"], 400)
    HoldKeysE(["w", "a", "k"], 300)
    Sleep(1000)
}

TravelAcdcAtAcdcStnToHisbys() {
    HoldKeysE(["s", "a", "k"], 300)
    HoldKeysE(["w", "a", "k"], 2500)
    HoldKeysE(["w", "d", "k"], 4300)
    HoldKeysE(["w", "a", "k"], 600)
    Sleep(1000)
}

TravelHigsbysAtHigsbysChipShopToAcdc() {
    HoldKeysE(["s", "d", "k"], 100)
    HoldKeysE(["s", "a", "k"], 1500)
    Sleep(1000)
}

TravelHigsbysAtAcdcToHigsbysChipShop() {
    HoldKeysE(["w", "a", "k"], 100)
    HoldKeysE(["d", "w", "k"], 1300)
}

;; yoka
TravelYokaStnAtFrontOfZooToStn(to_stn) {
    HoldKeysE(["w", "a", "k"], 500)
    HoldKeysE(["w", "k"], 2000)
    Sleep(100)
    HoldKeyE("d", 50)
    Sleep(100)
    PurchaseTicketFromStnToStn("yoka", to_stn)
    HoldKeysE(["a", "k"], 1500)
    HoldKeysE(["s", "k"], 1000)
    HoldKeysE(["d", "k"], 3500)
    Sleep(100)
    HoldKeyE("j", 50)
    Sleep(500)
    HoldKeyE("j", 50)
    Sleep(1000)
}

TravelYokaStnAtGateToFrontOfZoo() {
    HoldKeysE(["s", "k"], 1000)
    Sleep(1000)
}

TravelFrontOfZooAtHotelFrontToYokaStn() {
    HoldKeysE(["d", "k"], 1500)
    HoldKeysE(["w", "k"], 200)
    HoldKeysE(["w", "d", "k"], 1500)
    HoldKeysE(["a", "k"], 500)
    Sleep(1000)
}

TravelFrontOfZooAtYokaStnToHotelFront() {
    HoldKeysE(["s", "k"], 300)
    HoldKeysE(["a", "k"], 3400)
    Sleep(1000)
}

TravelHotelFrontAtHotelLobbyToFrontOfZoo() {
    HoldKeysE(["s", "k"], 3200)
    HoldKeysE(["d", "k"], 1200)
    Sleep(1000)
}

TravelHotelFrontAtFrontOfZooToHotelLobby() {
    HoldKeysE(["a", "k"], 4000)
    HoldKeysE(["d", "k"], 1500)
    HoldKeysE(["w", "k"], 300)
    Sleep(1000)
}

TravelHotelLobbyAtArmorCompToHotelFront() {
    JackOut()
    HoldKeysE(["s", "k"], 2000)
    HoldKeysE(["a", "k"], 1200)
    Sleep(1000)
}

TravelHotelLobbyAtHotelFrontToArmorComp() {
    HoldKeysE(["w", "k"], 1600)
    RepeatHoldKeysForDurationE(["w", "e", "k"], 50, 4000)
    Sleep(5000)
}

;; beach
TravelBeachStnAtBeachStToStn(to_stn) {
    HoldKeysE(["w", "k"], 1200)
    PurchaseTicketFromStnToStn("beach", to_stn)
    HoldKeysE(["s", "k"], 400)
    HoldKeysE(["d", "k"], 1400)
    Sleep(100)
    HoldKeyE("j", 50)
    Sleep(500)
    HoldKeyE("j", 50)
    Sleep(1500)
}

TravelBeachStnAtGateToBeachSt() {
    HoldKeysE(["s", "k"], 1500)
    Sleep(1000)
}

TravelBeachStAtShorelineToBeachStn() {
    HoldKeysE(["w", "k"], 3000)
    Sleep(1000)
}

TravelBeachStAtTVStnLobbyToBeachStn() {
    HoldKeysE(["s", "k"], 1000)
    HoldKeysE(["a", "k"], 1000)
    HoldKeysE(["w", "k"], 1000)
    HoldKeysE(["a", "k"], 1400)
    HoldKeysE(["s", "a", "k"], 900)
    HoldKeysE(["w", "a", "k"], 1300)
    HoldKeysE(["w", "k"], 900)
    Sleep(1000)
}

TravelBeachStAtTVStnLobbyToShoreline() {
    HoldKeysE(["s", "k"], 1000)
    HoldKeysE(["a", "k"], 1000)
    HoldKeysE(["w", "k"], 1000)
    HoldKeysE(["a", "k"], 1400)
    HoldKeysE(["s", "a", "k"], 1800)
    HoldKeysE(["a", "k"], 1300)
    Sleep(1000)
}

TravelBeachStAtBeachStnToShoreline() {
    HoldKeysE(["s", "a", "k"], 900)
    HoldKeysE(["s", "k"], 3200)
    Sleep(1000)
}

TravelBeachStAtBeachStnToTVStnLobby() {
    HoldKeysE(["s", "d", "k"], 2000)
    HoldKeysE(["d", "k"], 3300)
    HoldKeysE(["w", "k"], 2100)
    HoldKeysE(["a", "k"], 200)
    Sleep(1000)
}

TravelShorelineAtHospLobbyToBeachSt() {
    HoldKeysE(["d", "k"], 3500)
    Sleep(1000)
}

TravelShorelineAtBeachStToHospLobby() {
    HoldKeysE(["a", "k"], 3200)
    Sleep(1000)
}

TravelHospLobbyAtChipTraderToShoreline() {
    HoldKeysE(["s", "d", "k"], 1400)
    Sleep(1000)
}

TravelHospLobbyAtShorelineToHospLobbyAtChipTrader() {
    HoldKeysE(["w", "k"], 1600)
    HoldKeysE(["a", "k"], 200)
    HoldKeysE(["s", "k"], 50)
    Sleep(1000)
}

TravelHospLobbyAtChipTraderToVendingCompAtGambler(w_win, h_win) {
    TravelHospLobbyAtChipTraderToHospLobbyAtVendingComp()
    TravelHospLobbyAtVendingCompToVendingCompAtGambler(w_win, h_win)
}

TravelVendingCompAtGamblerToHospLobbyAtChipTrader() {
    JackOut()
    TravelHospLobbyAtVendingCompToHospLobbyAtChipTrader()
}

TravelTVStnLobbyAtTVStnHallToBeachSt() {
    HoldKeysE(["s", "k"], 1800)
    HoldKeysE(["d", "k"], 700)
    HoldKeysE(["s", "k"], 1100)
    Sleep(1000)
}

TravelTVStnLobbyAtBeachStToTVStnHall() {
    HoldKeysE(["a", "k"], 3600)
    Sleep(1000)
}

TravelTVStnHallAtChipTraderToTVStnLobby() {
    HoldKeysE(["d", "k"], 500)
    HoldKeysE(["w", "k"], 500)
    HoldKeysE(["d", "k"], 600)
    HoldKeysE(["s", "k"], 200)
    HoldKeysE(["d", "k"], 4400)
    Sleep(1000)
}

TravelTVStnHallAtTVStnLobbyToTVStnHallAtChipTrader() {
    HoldKeysE(["a", "k"], 1600)
    HoldKeysE(["a", "s", "k"], 200)
    HoldKeysE(["a", "k"], 1300)
    HoldKeysE(["w", "k"], 1500)
    HoldKeysE(["a", "s", "k"], 700)
    HoldKeysE(["w", "k"], 200)
    HoldKeysE(["d"], 50)
    Sleep(1000)
}

;; combination
TravelHigsbysAtHigsbysChipShopToHospLobbyAtChipTrader() {
    TravelHigsbysAtHigsbysChipShopToAcdc()
    TravelAcdcAtHisbysToAcdcStn()
    TravelAcdcStnAtAcdcToStn("beach")
    TravelBeachStnAtGateToBeachSt()
    TravelBeachStAtBeachStnToShoreline()
    TravelShorelineAtBeachStToHospLobby()
    TravelHospLobbyAtShorelineToHospLobbyAtChipTrader()
}

TravelHigsbysAtHigsbysChipShopToTVStnHallAtChipTrader() {
    TravelHigsbysAtHigsbysChipShopToAcdc()
    TravelAcdcAtHisbysToAcdcStn()
    TravelAcdcStnAtAcdcToStn("beach")
    TravelBeachStnAtGateToBeachSt()
    TravelBeachStAtBeachStnToTVStnLobby()
    TravelTVStnLobbyAtBeachStToTVStnHall()
    TravelTVStnHallAtTVStnLobbyToTVStnHallAtChipTrader()
}

TravelArmorCompToHospLobbyAtChipTrader() {
    TravelHotelLobbyAtArmorCompToHotelFront()
    TravelHotelFrontAtHotelLobbyToFrontOfZoo()
    TravelFrontOfZooAtHotelFrontToYokaStn()
    TravelYokaStnAtFrontOfZooToStn("beach")
    TravelBeachStnAtGateToBeachSt()
    TravelBeachStAtBeachStnToShoreline()
    TravelShorelineAtBeachStToHospLobby()
    TravelHospLobbyAtShorelineToHospLobbyAtChipTrader()
}

TravelArmorCompToHigsbysAtHigsbysChipShop() {
    TravelHotelLobbyAtArmorCompToHotelFront()
    TravelHotelFrontAtHotelLobbyToFrontOfZoo()
    TravelFrontOfZooAtHotelFrontToYokaStn()
    TravelYokaStnAtFrontOfZooToStn("acdc")
    TravelAcdcStnAtGateToAcdc()
    TravelAcdcAtAcdcStnToHisbys()
    TravelHigsbysAtAcdcToHigsbysChipShop()
}

TravelHospLobbyAtChipTraderToHigsbysAtHigsbysChipShop() {
    TravelHospLobbyAtChipTraderToShoreline()
    TravelShorelineAtHospLobbyToBeachSt()
    TravelBeachStAtShorelineToBeachStn()
    TravelBeachStnAtBeachStToStn("acdc")
    TravelAcdcStnAtGateToAcdc()
    TravelAcdcAtAcdcStnToHisbys()
    TravelHigsbysAtAcdcToHigsbysChipShop()
}

TravelHospLobbyAtChipTraderToArmorComp() {
    TravelHospLobbyAtChipTraderToShoreline()
    TravelShorelineAtHospLobbyToBeachSt()
    TravelBeachStAtShorelineToBeachStn()
    TravelBeachStnAtBeachStToStn("yoka")
    TravelYokaStnAtGateToFrontOfZoo()
    TravelFrontOfZooAtYokaStnToHotelFront()
    TravelHotelFrontAtFrontOfZooToHotelLobby()
    TravelHotelLobbyAtHotelFrontToArmorComp()
}

TravelVendingCompAtGamblerToHigsbysAtHigsbysChipShop() {
    TravelVendingCompAtGamblerToHospLobbyAtChipTrader()
    TravelHospLobbyAtChipTraderToHigsbysAtHigsbysChipShop()
}

TravelTVStnHallAtChipTraderToVendingCompAtGambler(w_win, h_win) {
    TravelTVStnHallAtChipTraderToTVStnLobby()
    TravelTVStnLobbyAtTVStnHallToBeachSt()
    TravelBeachStAtTVStnLobbyToShoreline()
    TravelShorelineAtBeachStToHospLobby()
    TravelHospLobbyAtShorelineToHospLobbyAtChipTrader()
    TravelHospLobbyAtChipTraderToVendingCompAtGambler(w_win, h_win)
}

TravelTVStnHallAtChipTraderToHigsbysAtHigsbysChipShop() {
    TravelTVStnHallAtChipTraderToTVStnLobby()
    TravelTVStnLobbyAtTVStnHallToBeachSt()
    TravelBeachStAtTVStnLobbyToBeachStn()
    TravelBeachStnAtBeachStToStn("acdc")
    TravelAcdcStnAtGateToAcdc()
    TravelAcdcAtAcdcStnToHisbys()
    TravelHigsbysAtAcdcToHigsbysChipShop()
}

TravelTVStnHallAtChipTraderToArmorComp() {
    TravelTVStnHallAtChipTraderToTVStnLobby()
    TravelTVStnLobbyAtTVStnHallToBeachSt()
    TravelBeachStAtTVStnLobbyToBeachStn()
    TravelBeachStnAtBeachStToStn("yoka")
    TravelYokaStnAtGateToFrontOfZoo()
    TravelFrontOfZooAtYokaStnToHotelFront()
    TravelHotelFrontAtFrontOfZooToHotelLobby()
    TravelHotelLobbyAtHotelFrontToArmorComp()
}
