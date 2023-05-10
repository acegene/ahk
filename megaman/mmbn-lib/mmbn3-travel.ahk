#include "%A_ScriptDir%\mmbn-lib\mmbn3-misc.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbnx-battle.ahk"

#include <keypress-utils>
#include <timer-utils>

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
        } else if (to_stn = "yoka") {
            keys.Push("d")
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

TravelRunnableDuration(w_win, h_win, keys, duration, next_area_delay_duration := 1000) {
    static battle_detect_duration := 100

    battle_ready_duration := Max(4500, next_area_delay_duration)
    battle_ready_duration_phase_1 := battle_ready_duration - next_area_delay_duration
    battle_ready_duration_phase_2 := battle_ready_duration - battle_ready_duration_phase_1

    timer_run := Timer()

    KeysDownE(keys)
    timer_run.Reset()
    while (timer_run.ElapsedMilliSec() < duration) {
        if (!mmbn3_ratio_rgbs_health_bar_net.DoesWindowMatchRatioRgbs(w_win, h_win)) {
            battle_start := timer_run.ElapsedMilliSec()
            KeysUpE(keys)
            Sleep(battle_ready_duration_phase_1)
            if (mmbn3_ratio_rgbs_health_bar_net.DoesWindowMatchRatioRgbs(w_win, h_win)) {
                return
            }
            Sleep(battle_ready_duration_phase_2)
            RunFromBattle()
            duration += battle_detect_duration + timer_run.ElapsedMilliSec() - battle_start
            KeysDownE(keys)
        }
    }
    KeysUpE(keys)

    duration_extended := duration + (2.0 * battle_detect_duration)
    while (timer_run.ElapsedMilliSec() < duration_extended) {
        if (!mmbn3_ratio_rgbs_health_bar_net.DoesWindowMatchRatioRgbs(w_win, h_win)) {
            Sleep(battle_ready_duration)
            RunFromBattle()
        }
    }
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

TravelHigsbysAtShopToAcdc() {
    HoldKeysE(["s", "d", "k"], 100)
    HoldKeysE(["s", "a", "k"], 1500)
    Sleep(1000)
}

TravelHigsbysAtTraderToAcdc() {
    HoldKeysE(["a", "k"], 1200)
    Sleep(1000)
}

TravelHigsbysAtAcdcToHigsbysAtShop() {
    HoldKeysE(["w", "a", "k"], 100)
    HoldKeysE(["d", "w", "k"], 1300)
}

TravelHigsbysAtAcdcToHigsbysAtTrader() {
    HoldKeysE(["d", "s", "k"], 650)
    HoldKeysE(["d", "w", "k"], 400)
    HoldKeyE("a", 50)
    Sleep(1000)
}

TravelHigsbysAtShopToHigsbysAtTrader() {
    TravelHigsbysAtShopToAcdc()
    HoldKeysE(["w", "k"], 100)
    Sleep(1000)
    TravelHigsbysAtAcdcToHigsbysAtTrader()
}

TravelHigsbysAtTraderToHigsbysAtShop() {
    TravelHigsbysAtTraderToAcdc()
    HoldKeysE(["w", "k"], 100)
    Sleep(1000)
    TravelHigsbysAtAcdcToHigsbysAtShop()
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

TravelHotelFrontAtTamakosHPToFrontOfZoo() {
    HoldKeysE(["a", "k"], 100)
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

TravelHotelFrontAtFrontOfZooToHoteelFrontAtTamakosHP() {
    HoldKeysE(["a", "k"], 4000)
    HoldKeysE(["w", "k"], 400)
    Sleep(100)
}

TravelHotelFrontAtHotelLobbyToHotelFrontAtTamakosHP() {
    HoldKeysE(["a", "k"], 1000)
    HoldKeysE(["w", "k"], 400)
    Sleep(100)
}

TravelHotelFrontAtTamakosHPToBeachSquare() {
    JackIn()
    TravelTamakosHPAtHotelFrontToBeachSquare()
}

TravelHotelFrontAtTamakosHPToHotelLobby() {
    HoldKeysE(["a", "k"], 400)
    HoldKeysE(["d", "k"], 1500)
    HoldKeysE(["w", "k"], 300)
    Sleep(1000)
}

TravelTamakosHPAtHotelFrontToBeachSquare() {
    HoldKeysE(["s", "a", "k"], 500)
    HoldKeysE(["s", "d", "k"], 2200)
    HoldKeysE(["s", "k"], 1600)
    HoldKeysE(["a", "k"], 2500)
    HoldKeysE(["w", "k"], 2400)
    HoldKeysE(["a", "k"], 1300)
    Sleep(3000)
}

TravelArmorCompToHotelFront() {
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

TravelHotelLobbyAtHallToHotelFront() {
    HoldKeysE(["s", "d", "k"], 400)
    HoldKeysE(["s", "a", "k"], 2400)
    Sleep(1000)
}

TravelHotelLobbyAtHotelFrontToHall() {
    HoldKeysE(["w", "k"], 2500)
    Sleep(1000)
}

TravelHallAtOutdoorBathToHotelLobby() {
    HoldKeysE(["s", "k"], 5800)
    Sleep(1000)
}

TravelHallAtHotelLobbyToOutdoorBath() {
    HoldKeysE(["d", "k"], 5500)
    HoldKeysE(["w", "k"], 400)
    Sleep(1000)
}

TravelOutdoorBathAtHallToSecretArea1() {
    ;; TravelOutdoorBathAtHallToSecretCave
    HoldKeysE(["d", "k"], 2100)
    HoldKeysE(["w", "k"], 1700)
    RepeatHoldKeyForDurationE("j", 50, 3000)
    ;; TravelSecretCaveAtOutdoorBathToUndernetSquare
    HoldKeysE(["s", "a", "k"], 1600)
    HoldKeysE(["w", "a", "k"], 2000)
    Sleep(100)
    JackIn()
    ;; TravelUndernetSquareAtSecretCaveToSecretArea1
    HoldKeysE(["w", "a", "k"], 1300)
    HoldKeysE(["j"], 50)
    Sleep(12000)
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

TravelHospLobbyAtTraderToShoreline() {
    HoldKeysE(["s", "d", "k"], 1400)
    Sleep(1000)
}

TravelHospLobbyAtShorelineToHospLobbyAtTrader() {
    HoldKeysE(["w", "k"], 1600)
    HoldKeysE(["a", "k"], 200)
    HoldKeysE(["s", "k"], 50)
    Sleep(1000)
}

TravelHospLobbyAtTraderToVendingCompAtGambler(w_win, h_win) {
    TravelHospLobbyAtTraderToHospLobbyAtVendingComp()
    TravelHospLobbyAtVendingCompToVendingCompAtGambler(w_win, h_win)
}

TravelHospLobbyAtTraderToHospLobbyAtVendingComp() {
    HoldKeysE(["w", "k"], 200)
    HoldKeysE(["d", "k"], 50)
    Sleep(1000)
}

TravelHospLobbyAtVendingCompToHospLobbyAtTrader() {
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
        if (mmbn3_ratio_rgbs_megaman_side_foot.DoesWindowMatchRatioRgbs(w_win, h_win)) {
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

TravelVendingCompAtGamblerToHospLobbyAtTrader() {
    JackOut()
    TravelHospLobbyAtVendingCompToHospLobbyAtTrader()
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

TravelTVStnHallAtTraderToTVStnLobby() {
    HoldKeysE(["d", "k"], 500)
    HoldKeysE(["w", "k"], 500)
    HoldKeysE(["d", "k"], 600)
    HoldKeysE(["s", "k"], 200)
    HoldKeysE(["d", "k"], 4400)
    Sleep(1000)
}

TravelTVStnHallAtTVStnLobbyToTVStnHallAtTrader() {
    HoldKeysE(["a", "k"], 1600)
    HoldKeysE(["a", "s", "k"], 200)
    HoldKeysE(["a", "k"], 1300)
    HoldKeysE(["w", "k"], 1500)
    HoldKeysE(["a", "s", "k"], 700)
    HoldKeysE(["w", "k"], 200)
    HoldKeysE(["d"], 50)
    Sleep(1000)
}

;; beach net
TravelBeachSquareAtTamakosHPToBeach2() {
    HoldKeysE(["w", "a", "k"], 1200)
    HoldKeysE(["d", "k"], 200)
    HoldKeysE(["w", "d", "k"], 1400)
    Sleep(3000)
}

TravelBeach2AtBeachSquareToUndernet1() {
    ;; TravelBeach2AtBeachSquareToHadesIsle
    HoldKeysE(["d", "k"], 400)
    HoldKeysE(["s", "d", "k"], 1000)
    Sleep(3000)
    HoldKeysE(["s", "k"], 600)
    HoldKeysE(["a", "k"], 1100)
    HoldKeysE(["s", "a", "k"], 1000)
    HoldKeysE(["s", "k"], 1500)
    HoldKeysE(["w", "d", "k"], 1000)
    Sleep(3000)
    ;; TravelHadesIsleAtBeach2ToUndernet1
    HoldKeysE(["w", "d", "k"], 4600)
    Sleep(1000)
}

;; undernet
TravelUndernet1AtHadesIsleToUndernet2A() {
    HoldKeysE(["w", "d", "k"], 3000)
    HoldKeysE(["s", "k"], 3500)
    HoldKeysE(["a", "k"], 4000)
    HoldKeysE(["w", "k"], 1500)
    Sleep(3000)
    HoldKeysE(["w", "k"], 700)
    Sleep(1000)
}

TravelUndernet2AToUndernet1B() {
    HoldKeysE(["w", "d", "k"], 1500)
    HoldKeysE(["w", "a", "k"], 800)
    HoldKeysE(["w", "d", "k"], 2700)
    HoldKeysE(["w", "a", "k"], 2400)
    HoldKeysE(["w", "d", "k"], 1000)
    Sleep(3000)
    HoldKeysE(["a", "k"], 400)
    HoldKeysE(["w", "d", "k"], 1500)
    HoldKeysE(["w", "a", "k"], 1500)
    Sleep(3000)
    HoldKeysE(["s", "a", "k"], 2300)
    Sleep(1000)
}

TravelUndernet1BToUndernet2C() {
    HoldKeysE(["s", "k"], 2500)
    HoldKeysE(["d", "k"], 3000)
    Sleep(1000)
}

TravelUndernet2CToUndernet3() {
    HoldKeysE(["w", "k"], 6000)
    Sleep(1000)
}

TravelUndernet3AtUndernet2ToUndernetSquare() {
    HoldKeysE(["a", "k"], 1500)
    HoldKeysE(["s", "k"], 1000)
    HoldKeysE(["w", "a", "k"], 2000)
    HoldKeysE(["w", "d", "k"], 200)
    HoldKeysE(["d", "k"], 2200)
    HoldKeysE(["w", "k"], 1500)
    HoldKeysE(["a", "k"], 1000)
    HoldKeysE(["w", "k"], 3200)
    HoldKeysE(["w", "d", "k"], 1800)
    HoldKeysE(["w", "k"], 1200)
    HoldKeysE(["a", "k"], 1100)
    HoldKeysE(["s", "d", "k"], 600)
    HoldKeysE(["w", "d", "k"], 1300)
    Sleep(3000)
}

TravelUnderSquareAtUndernet3ToUndernetSquareAtSimon() {
    HoldKeysE(["w", "a", "k"], 200)
    HoldKeysE(["a", "k"], 2200)
    HoldKeysE(["s", "k"], 300)
    HoldKeysE(["d", "k"], 1900)
    HoldKeysE(["s"], 50)
    Sleep(1000)
}

;; secret area
TravelSecretArea1AtSecretArea2ToHall(w_win, h_win) {
    ;; TravelSecretArea1AtSecretArea2ToUndernetSquare
    TravelRunnableDuration(w_win, h_win, ["s", "a", "k"], 100)
    TravelRunnableDuration(w_win, h_win, ["s", "d", "k"], 1700)
    TravelRunnableDuration(w_win, h_win, ["w", "d", "k"], 1700)
    TravelRunnableDuration(w_win, h_win, ["s", "d", "k"], 1700)
    TravelRunnableDuration(w_win, h_win, ["w", "d", "k"], 1700)
    TravelRunnableDuration(w_win, h_win, ["s", "d", "k"], 2200)
    TravelRunnableDuration(w_win, h_win, ["s", "a", "k"], 2200)
    TravelRunnableDuration(w_win, h_win, ["s", "d", "k"], 2200)
    TravelRunnableDuration(w_win, h_win, ["s", "a", "k"], 3200)
    TravelRunnableDuration(w_win, h_win, ["w", "a", "k"], 2200)
    TravelRunnableDuration(w_win, h_win, ["w", "d", "k"], 400)
    Sleep(7000)
    ;; TravelUndernetSquareAtSecretArea1ToSecretCave
    JackOut()
    ;; TravelSecretCaveAtUndernetSquareToOutdoorBath
    HoldKeysE(["d", "k"], 3000)
    HoldKeysE(["w", "k"], 400)
    RepeatHoldKeyForDurationE("j", 50, 1500)
    Sleep(1000)
    ;; TravelOutdoorBathAtSecretCaveToHall
    HoldKeysE(["s", "k"], 1000)
    HoldKeysE(["a", "k"], 2800)
    Sleep(1000)
}

TravelSecretArea1AtSecretCaveToSecretArea2(w_win, h_win) {
    TravelRunnableDuration(w_win, h_win, ["s", "a", "k"], 100)
    TravelRunnableDuration(w_win, h_win, ["s", "d", "k"], 2300)
    TravelRunnableDuration(w_win, h_win, ["w", "d", "k"], 3200)
    TravelRunnableDuration(w_win, h_win, ["w", "a", "k"], 2200)
    TravelRunnableDuration(w_win, h_win, ["w", "d", "k"], 2200)
    TravelRunnableDuration(w_win, h_win, ["w", "a", "k"], 2200)
    TravelRunnableDuration(w_win, h_win, ["s", "a", "k"], 1700)
    TravelRunnableDuration(w_win, h_win, ["w", "a", "k"], 1700)
    TravelRunnableDuration(w_win, h_win, ["s", "a", "k"], 1700)
    TravelRunnableDuration(w_win, h_win, ["w", "a", "k"], 1700)
    Sleep(1000)
}

TravelSecretArea2AtSecretArea3ToSecretArea1(w_win, h_win) {
    TravelRunnableDuration(w_win, h_win, ["s", "a", "k"], 200)
    TravelRunnableDuration(w_win, h_win, ["s", "d", "k"], 3000)
    TravelRunnableDuration(w_win, h_win, ["d", "k"], 2500)
    TravelRunnableDuration(w_win, h_win, ["s", "d", "k"], 1000)
    Sleep(3000)
    TravelRunnableDuration(w_win, h_win, ["w", "d", "k"], 2000)
    TravelRunnableDuration(w_win, h_win, ["w", "k"], 2700)
    TravelRunnableDuration(w_win, h_win, ["s", "k"], 500)
    Sleep(3000)
    TravelRunnableDuration(w_win, h_win, ["w", "a", "k"], 700)
    TravelRunnableDuration(w_win, h_win, ["w", "k"], 1500)
    TravelRunnableDuration(w_win, h_win, ["a", "k"], 3100)
    TravelRunnableDuration(w_win, h_win, ["w", "d", "k"], 1200)
    TravelRunnableDuration(w_win, h_win, ["s", "k"], 1500)
    TravelRunnableDuration(w_win, h_win, ["s", "d", "k"], 4200)
}

TravelSecretArea2AtSecretArea1ToSecretArea3(w_win, h_win) {
    TravelRunnableDuration(w_win, h_win, ["w", "a", "k"], 4000)
    TravelRunnableDuration(w_win, h_win, ["a", "k"], 1500)
    TravelRunnableDuration(w_win, h_win, ["s", "k"], 2500)
    TravelRunnableDuration(w_win, h_win, ["s", "d", "k"], 2300)
    TravelRunnableDuration(w_win, h_win, ["s", "k"], 1500)
    TravelRunnableDuration(w_win, h_win, ["w", "k"], 600)
    Sleep(3000)
    TravelRunnableDuration(w_win, h_win, ["s", "k"], 3000)
    TravelRunnableDuration(w_win, h_win, ["s", "a", "k"], 2000)
    Sleep(3000)
    TravelRunnableDuration(w_win, h_win, ["w", "a", "k"], 1000)
    TravelRunnableDuration(w_win, h_win, ["a", "k"], 1500)
    TravelRunnableDuration(w_win, h_win, ["w", "a", "k"], 4000)
}

TravelSecretArea3AtTraderToSecretArea2(w_win, h_win) {
    TravelRunnableDuration(w_win, h_win, ["s", "k"], 2900)
    TravelRunnableDuration(w_win, h_win, ["d", "k"], 1500)
    TravelRunnableDuration(w_win, h_win, ["w", "k"], 2000)
    TravelRunnableDuration(w_win, h_win, ["d", "k"], 2000)
    TravelRunnableDuration(w_win, h_win, ["s", "k"], 1000)
    TravelRunnableDuration(w_win, h_win, ["s", "a", "k"], 1500)
    TravelRunnableDuration(w_win, h_win, ["s", "d", "k"], 2000)
    TravelRunnableDuration(w_win, h_win, ["s", "k"], 2500)
    TravelRunnableDuration(w_win, h_win, ["s", "d", "k"], 800)
}

TravelSecretArea3AtSecretArea2ToSecretArea3AtTrader(w_win, h_win) {
    TravelRunnableDuration(w_win, h_win, ["w", "k"], 1300)
    TravelRunnableDuration(w_win, h_win, ["d", "k"], 500)
    TravelRunnableDuration(w_win, h_win, ["w", "k"], 4700)
    TravelRunnableDuration(w_win, h_win, ["a", "k"], 2000)
    TravelRunnableDuration(w_win, h_win, ["s", "k"], 2500)
    TravelRunnableDuration(w_win, h_win, ["a", "k"], 2100)
    TravelRunnableDuration(w_win, h_win, ["w", "d", "k"], 2700)
    TravelRunnableDuration(w_win, h_win, ["w", "a", "k"], 600)
}

;; combination to stn
TravelHigsbysAtShopToStn(to_stn) {
    TravelHigsbysAtShopToAcdc()
    TravelAcdcAtHisbysToAcdcStn()
    TravelAcdcStnAtAcdcToStn(to_stn)
}

TravelHigsbysAtTraderToStn(to_stn) {
    TravelHigsbysAtTraderToAcdc()
    TravelAcdcAtHisbysToAcdcStn()
    TravelAcdcStnAtAcdcToStn(to_stn)
}

TravelHotelFrontAtTamakosHPToStn(to_stn) {
    TravelHotelFrontAtTamakosHPToFrontOfZoo()
    TravelFrontOfZooAtHotelFrontToYokaStn()
    TravelYokaStnAtFrontOfZooToStn(to_stn)
}

TravelArmorCompToStn(to_stn) {
    TravelArmorCompToHotelFront()
    TravelHotelFrontAtHotelLobbyToFrontOfZoo()
    TravelFrontOfZooAtHotelFrontToYokaStn()
    TravelYokaStnAtFrontOfZooToStn(to_stn)
}

TravelHospLobbyAtTraderToStn(to_stn) {
    TravelHospLobbyAtTraderToShoreline()
    TravelShorelineAtHospLobbyToBeachSt()
    TravelBeachStAtShorelineToBeachStn()
    TravelBeachStnAtBeachStToStn(to_stn)
}

TravelTVStnHallAtTraderToStn(to_stn) {
    TravelTVStnHallAtTraderToTVStnLobby()
    TravelTVStnLobbyAtTVStnHallToBeachSt()
    TravelBeachStAtTVStnLobbyToBeachStn()
    TravelBeachStnAtBeachStToStn(to_stn)
}

;; combination from stn
TravelAcdcStnAtGateToHigsbysAtShop() {
    TravelAcdcStnAtGateToAcdc()
    TravelAcdcAtAcdcStnToHisbys()
    TravelHigsbysAtAcdcToHigsbysAtShop()
}

TravelAcdcStnAtGateToHigsbysAtTrader() {
    TravelAcdcStnAtGateToAcdc()
    TravelAcdcAtAcdcStnToHisbys()
    TravelHigsbysAtAcdcToHigsbysAtTrader()
}

TravelYokaStnAtGateToHotelFrontAtTamakosHP() {
    TravelYokaStnAtGateToFrontOfZoo()
    TravelFrontOfZooAtYokaStnToHotelFront()
    TravelHotelFrontAtFrontOfZooToHoteelFrontAtTamakosHP()
}

TravelYokaStnAtGateToArmorComp() {
    TravelYokaStnAtGateToFrontOfZoo()
    TravelFrontOfZooAtYokaStnToHotelFront()
    TravelHotelFrontAtFrontOfZooToHotelLobby()
    TravelHotelLobbyAtHotelFrontToArmorComp()
}

TravelBeachStnAtGateToHospLobbyAtTrader() {
    TravelBeachStnAtGateToBeachSt()
    TravelBeachStAtBeachStnToShoreline()
    TravelShorelineAtBeachStToHospLobby()
    TravelHospLobbyAtShorelineToHospLobbyAtTrader()
}

TravelBeachStnAtGateToTVStnHallAtTrader() {
    TravelBeachStnAtGateToBeachSt()
    TravelBeachStAtBeachStnToTVStnLobby()
    TravelTVStnLobbyAtBeachStToTVStnHall()
    TravelTVStnHallAtTVStnLobbyToTVStnHallAtTrader()
}

TravelBeachStnAtGateToVendingCompAtGambler(w_win, h_win) {
    TravelBeachStnAtGateToHospLobbyAtTrader()
    TravelHospLobbyAtTraderToVendingCompAtGambler(w_win, h_win)
}

;; combination
TravelHigsbysAtShopToHospLobbyAtTrader() {
    TravelHigsbysAtShopToStn("beach")
    TravelBeachStnAtGateToHospLobbyAtTrader()
}

TravelHigsbysAtShopToTVStnHallAtTrader() {
    TravelHigsbysAtShopToStn("beach")
    TravelBeachStnAtGateToTVStnHallAtTrader()
}

TravelHigsbysAtTraderToHotelFrontAtTamakosHP() {
    TravelHigsbysAtTraderToStn("yoka")
    TravelYokaStnAtGateToHotelFrontAtTamakosHP()
}

TravelHigsbysAtTraderToVendingCompAtGambler(w_win, h_win) {
    TravelHigsbysAtTraderToStn("beach")
    TravelBeachStnAtGateToVendingCompAtGambler(w_win, h_win)
}

TravelHigsbysAtTraderToArmorComp() {
    TravelHigsbysAtTraderToStn("yoka")
    TravelYokaStnAtGateToArmorComp()
}

TravelHotelFrontAtTamakosHPToUnderSquareAtSimon() {
    TravelHotelFrontAtTamakosHPToBeachSquare()
    TravelBeachSquareAtTamakosHPToBeach2()
    TravelBeach2AtBeachSquareToUndernet1()
    TravelUndernet1AtHadesIsleToUndernet2A()
    TravelUndernet2AToUndernet1B()
    TravelUndernet1BToUndernet2C()
    TravelUndernet2CToUndernet3()
    TravelUndernet3AtUndernet2ToUndernetSquare()
    TravelUnderSquareAtUndernet3ToUndernetSquareAtSimon()
}

TravelHotelFrontAtTamakosHPToSecretArea3AtTrader(w_win, h_win) {
    TravelHotelFrontAtTamakosHPToHotelLobby()
    TravelHotelLobbyAtHotelFrontToHall()
    TravelHallAtHotelLobbyToOutdoorBath()
    TravelOutdoorBathAtHallToSecretArea1()
    TravelSecretArea1AtSecretCaveToSecretArea2(w_win, h_win)
    TravelSecretArea2AtSecretArea1ToSecretArea3(w_win, h_win)
    TravelSecretArea3AtSecretArea2ToSecretArea3AtTrader(w_win, h_win)
}

TravelHotelFrontAtTamakosHPToHigsbysAtTrader() {
    TravelHotelFrontAtTamakosHPToStn("acdc")
    TravelAcdcStnAtGateToHigsbysAtTrader()
}

TravelHotelFrontAtTamakosHPToHospLobbyAtTrader() {
    TravelHotelFrontAtTamakosHPToStn("beach")
    TravelBeachStnAtGateToHospLobbyAtTrader()
}

TravelHotelFrontAtTamakosHPToTVStnHallAtTrader() {
    TravelHotelFrontAtTamakosHPToStn("beach")
    TravelBeachStnAtGateToTVStnHallAtTrader()
}

TravelArmorCompToHospLobbyAtTrader() {
    TravelArmorCompToStn("beach")
    TravelBeachStnAtGateToHospLobbyAtTrader()
}

TravelArmorCompToHigsbysAtShop() {
    TravelArmorCompToStn("acdc")
    TravelAcdcStnAtGateToHigsbysAtShop()
}

TravelHospLobbyAtTraderToHigsbysAtShop() {
    TravelHospLobbyAtTraderToStn("acdc")
    TravelAcdcStnAtGateToHigsbysAtShop()
}

TravelHospLobbyAtTraderToHotelFrontAtTamakosHP() {
    TravelHospLobbyAtTraderToStn("yoka")
    TravelYokaStnAtGateToHotelFrontAtTamakosHP()
}

TravelHospLobbyAtTraderToArmorComp() {
    TravelHospLobbyAtTraderToStn("yoka")
    TravelYokaStnAtGateToArmorComp()
}

TravelVendingCompAtGamblerToHigsbysAtShop() {
    TravelVendingCompAtGamblerToHospLobbyAtTrader()
    TravelHospLobbyAtTraderToHigsbysAtShop()
}

TravelTVStnHallAtTraderToHigsbysAtShop() {
    TravelTVStnHallAtTraderToStn("acdc")
    TravelAcdcStnAtGateToHigsbysAtShop()
}

TravelTVStnHallAtTraderToHotelFrontAtTamakosHP() {
    TravelTVStnHallAtTraderToStn("yoka")
    TravelYokaStnAtGateToHotelFrontAtTamakosHP()
}

TravelTVStnHallAtTraderToVendingCompAtGambler(w_win, h_win) {
    TravelTVStnHallAtTraderToTVStnLobby()
    TravelTVStnLobbyAtTVStnHallToBeachSt()
    TravelBeachStAtTVStnLobbyToShoreline()
    TravelShorelineAtBeachStToHospLobby()
    TravelHospLobbyAtShorelineToHospLobbyAtTrader()
    TravelHospLobbyAtTraderToVendingCompAtGambler(w_win, h_win)
}

TravelTVStnHallAtTraderToArmorComp() {
    TravelTVStnHallAtTraderToStn("yoka")
    TravelYokaStnAtGateToArmorComp()
}

TravelUnderSquareAtSimonToSecretArea3AtTrader(w_win, h_win) {
    JackOut()
    TravelHotelFrontAtTamakosHPToSecretArea3AtTrader(w_win, h_win)
}

TravelSecretArea3AtTraderToUnderSquareAtSimon(w_win, h_win) {
    TravelSecretArea3AtTraderToSecretArea2(w_win, h_win)
    TravelSecretArea2AtSecretArea3ToSecretArea1(w_win, h_win)
    TravelSecretArea1AtSecretArea2ToHall(w_win, h_win)
    TravelHallAtOutdoorBathToHotelLobby()
    TravelHotelLobbyAtHallToHotelFront()
    TravelHotelFrontAtHotelLobbyToHotelFrontAtTamakosHP()
    TravelHotelFrontAtTamakosHPToUnderSquareAtSimon()
}
