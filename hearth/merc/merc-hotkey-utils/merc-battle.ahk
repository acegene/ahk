#SingleInstance Force
#NoEnv

#include <ahk-v1\general-utils>
#include <ahk-v1\mouse-utils>

SendMode Input
SetWorkingDir %A_ScriptDir%

MouseClickWindowHuman(x_window_ratio, y_window_ratio, x_range, y_range) {
    global mouse_navigator
    mouse_navigator.MouseClickWindowHuman(x_window_ratio, y_window_ratio, x_range, y_range)
}

GetAbilityX(Index) {
    switch Index {
        case 1: return 0.397177
        case 2: return 0.495565
        case 3: return 0.597177
        case 4: return 0.697177
        default: MsgBox, ERROR: GetAbilityX: unexpected input: Index = '%Index%'.
    }
}

GetAbilityXTolerance() {
    return 0.03
}

GetAbilityYTolerance() {
    return 0.03
}

GetAbilityY() {
    return 0.451658
}

GetHandX(Size, Index) {
    switch Size {
        case 1: GetHandX(5, Index + 2)
        case 2: GetHandX(4, Index + 1)
        case 3: GetHandX(5, Index + 1)
        case 4:
            switch Index {
                case 1: return 0.396635
                case 2: return 0.468349
                case 3: return 0.542869
                case 4: return 0.608173
            }
        case 5:
            switch Index {
                case 1: return 0.387097
                case 2: return 0.440323
                case 3: return 0.488710
                case 4: return 0.542339
                case 5: return 0.608871
                default: MsgBox, ERROR: GetHandX: unexpected input: Index = '%Index%'.
            }
        case 6:
            switch Index {
                case 1: return 0.389516
                case 2: return 0.431452
                case 3: return 0.465726
                case 4: return 0.518145
                case 5: return 0.553226
                case 6: return 0.610887
                default: MsgBox, ERROR: GetHandX: unexpected input: Index = '%Index%'.
            }
        default: MsgBox, ERROR: GetHandX: unexpected input: Size = '%Size%'.
    }
}

GetHandY() {
    return 0.912775
}

GetMinionX(Size, Index) {
    switch Size {
        case 1: return GetMinionX(5, Index + 2)
        case 2: return GetMinionX(6, Index + 2)
        case 3: return GetMinionX(5, Index + 1)
        case 4: return GetMinionX(6, Index + 1)
        case 5:
            switch Index {
                case 1: return 0.340000
                case 2: return 0.410000
                case 3: return 0.500000
                case 4: return 0.584000
                case 5: return 0.677000
                default: MsgBox, ERROR: GetMinionX: unexpected input: Index = '%Index%'.
            }
        case 6:
            switch Index {
                case 1: return 0.287904
                case 2: return 0.373290
                case 3: return 0.457581
                case 4: return 0.544609
                case 5: return 0.627805
                case 6: return 0.712644
                default: MsgBox, ERROR: GetMinionX: unexpected input: Index = '%Index%'.
            }
        default: MsgBox, ERROR: GetMinionX: unexpected input: Size = '%Size%'.
    }
}

GetMinionXTolerance() {
    return 0.01
}

GetMinionYTolerance() {
    return 0.05
}

GetFriendlyX(Size, Index) {
    return GetMinionX(Size, Index)
}

GetFriendlyXTolerance() {
    return GetMinionXTolerance()
}

GetFriendlyY() {
    return 0.688
}

GetFriendlyYTolerance() {
    return GetMinionYTolerance()
}

GetEnemyX(Size, Index) {
    return GetMinionX(Size, Index) + 0.02 ; TODO: offset to handle when between minions
}

GetEnemyXTolerance() {
    return GetMinionXTolerance()
}


GetEnemyY() {
    return 0.282876
}

GetEnemyYTolerance() {
    return GetMinionYTolerance()
}

GetChoiceX(Index) {
    switch Index {
        case 1: return 0.42
        case 2: return 0.58
        default: MsgBox, ERROR: GetChoiceX: unexpected input: Index = '%Index%'.
    }
}

GetChoiceY() {
    return 0.451658
}

GetChoiceXTolerance() {
    return 0.03
}

GetChoiceYTolerance() {
    return 0.03
}

ClickFriendlyTarget(Index, Size) {
    MouseClickWindowHuman(GetFriendlyX(Size, Index), GetFriendlyY(), GetFriendlyXTolerance(), GetFriendlyYTolerance())
}

ClickEnemyTarget(Index, Size) {
    MouseClickWindowHuman(GetEnemyX(Size, Index), GetEnemyY(), GetEnemyXTolerance(), GetEnemyYTolerance())
}

ClickChoice(Index) {
    MouseClickWindowHuman(GetChoiceX(Index), GetChoiceY(), GetChoiceXTolerance(), GetChoiceYTolerance())
}


UseUntargetingAbility(Index) {
    MouseClickWindowHuman(GetAbilityX(Index), GetAbilityY(), GetAbilityXTolerance(), GetAbilityYTolerance())
    SleepRandom(1500)
}

UseEnemyTargetingAbility(IndexAbility, IndexEnemy, Size := 3) {
    MouseClickWindowHuman(GetAbilityX(IndexAbility), GetAbilityY(), GetAbilityXTolerance(), GetAbilityYTolerance())
    SleepRandom(500)
    ClickEnemyTarget(IndexEnemy, Size)
    SleepRandom(1000)
}

UseFriendlyTargetingAbility(IndexAbility, IndexFriendly, Size := 3) {
    MouseClickWindowHuman(GetAbilityX(IndexAbility), GetAbilityY(), GetAbilityXTolerance(), GetAbilityYTolerance())
    SleepRandom(500)
    ClickFriendlyTarget(IndexFriendly, Size)
    SleepRandom(1000)
}

UseChooseOneAbility(IndexAbility, IndexChoice) {
    MouseClickWindowHuman(GetAbilityX(IndexAbility), GetAbilityY(), GetAbilityXTolerance(), GetAbilityYTolerance())
    SleepRandom(500)
    ClickChoice(IndexChoice)
    SleepRandom(1000)
}

PressReady() {
    MouseClickWindowHuman(0.824194, 0.454481, 0.01, 0.02)
    SleepRandom(500)
    MouseClickWindowHuman(0.824194, 0.454481, 0.01, 0.02)
}

SpeedupAnimations(loops) {
    Loop, %loops%{
        SleepRandom(300)
        MouseClickWindowHuman(0.217949, 0.364011, 0.05, 0.05)
    }
}

PlayFromHand(Index, Size) {
    ;; TODO: handle position > Size
    MouseClickWindowHuman(GetHandX(Size, Index), GetHandY(), 0.01, 0.05)
    SleepRandom(300)
    MouseClickWindowHuman(0.217949, 0.364011, 0.1, 0.1) ; play on board to left of minions
    SleepRandom(300)
}

PlayFromHandPhase(Index1, Index2, Index3, Size := 6) {
    ;; TODO: handle throw if inputs equal
    Index2Adjusted := Index3 < Index2 ? Index2 - 1 : Index2
    if (Index3 < Index1) {
        Index1Adjusted := Index2 < Index1 ? Index1 - 2 : Index1 - 1
    } else {
        Index1Adjusted := Index2 < Index1 ? Index1 - 1 : Index1
    }
    PlayFromHand(Index3, Size)
    PlayFromHand(Index2Adjusted, Size - 1)
    PlayFromHand(Index1Adjusted, Size - 2)
    SleepRandom(1000)
    PressReady()
    SleepRandom(10000)
}

FarmFire() {
    ; UseUnTargetingAbility(2)
    UseUntargetingAbility(2) ;; rag
    UseUntargetingAbility(2) ;; baron
    UseEnemyTargetingAbility(1, 2, 3) ;; anton/balinda
    UseEnemyTargetingAbility(1, 2, 3) ;; balinda elemental
}

FarmFrost() {
    UseUntargetingAbility(1)
    UseEnemyTargetingAbility(1, 2, 3)
    UseEnemyTargetingAbility(1, 2, 3)
    UseEnemyTargetingAbility(2, 2, 3)
}

Farm1() {
    Loop 38 {
        UseFriendlyTargetingAbility(2, 1, 3)
        UseFriendlyTargetingAbility(1, 1, 3)
        PressReady()
        SleepRandom(8000)
    }
}

Farm2() {
    UseEnemyTargetingAbility(1, 2, 3)
}

FarmCookie(num_summons := 5) {
    ;; assumes cookie is first merc
    Loop, %num_summons%{
        UseUntargetingAbility(3)
        PressReady()
        SleepRandom(6000)
        PressReady()
        SleepRandom(3000)
    }
}

FarmVelen(num_loops := 8, enemy_turn_duration := 5000, number_of_velens_blessing := 0) {
    ;; dmg(n) = (splitting_light+velen_boost*(n(n+1)/2)))*(n+1)
    ;; given: velen_boost=+3dmg; splitting_light=15dmg
    ;; dmg(3) =  (15+(3*6))*4 =  33*4 =  132
    ;; dmg(4) = (15+(3*10))*5 =  45*5 =  225
    ;; dmg(5) = (15+(3*15))*6 =  60*6 =  360
    ;; dmg(6) = (15+(3*21))*7 =  77*7 =  546
    ;; dmg(7) = (15+(3*28))*8 =  99*6 =  792
    ;; dmg(8) = (15+(3*36))*9 = 123*9 = 1107

    turn_minimum_duration = 3500
    duration_turn_without_velen := enemy_turn_duration + turn_minimum_duration
    duration_velens_blessing = 1600
    number_of_velens_blessing = 1

    Loop, %num_loops%{
        ;; turn 1
        UseUntargetingAbility(3)
        PressReady()
        number_of_velens_blessing := number_of_velens_blessing + 1
        duration_turn := duration_turn_without_velen + (duration_velens_blessing * number_of_velens_blessing)
        SleepRandom(duration_turn)

        ;; turn 2
        PressReady()
        SleepRandom(turn_minimum_duration + enemy_turn_duration)
    }
}

FarmLoop() {
    Loop, 15 {
        PressReady()
        SleepRandom(4000)
        UseFriendlyTargetingAbility(3, 1, 3)
        PressReady()
        SleepRandom(6000)
    }
}

FarmNMinions(num_minions := 40) {
    Loop, %num_minions%{
        UseEnemyTargetingAbility(2, 1, 1)
        UseUntargetingAbility(3)
        PressReady()
        SleepRandom(8000)
        UseEnemyTargetingAbility(1, 2, 2)
        PressReady()
        SleepRandom(7000)
    }
}

FarmMonkey(num_monkeys := 3, enemy_turn_duration := 5000) {
    ;; NOTE: can do 'deal X TYPE dmg with a team ...' by attacking friendlies
    ;; nature: guff
    ;; wrathion: dragon/fel multihit
    turn_minimum_duration = 3500
    duration_elise_guiding_path := enemy_turn_duration + turn_minimum_duration + 3000
    duration_elise_step_1 := enemy_turn_duration + turn_minimum_duration + 2000
    duration_elise_step_3 := enemy_turn_duration + turn_minimum_duration + 9000
    duration_elise_step_5 := enemy_turn_duration + turn_minimum_duration + 3000
    Loop, %num_monkeys%{
        UseUnTargetingAbility(3)
        PressReady()
        SleepRandom(duration_elise_step_1)
        UseUnTargetingAbility(2)
        PressReady()
        SleepRandom(duration_elise_guiding_path)
        UseUnTargetingAbility(3)
        PressReady()
        SleepRandom(duration_elise_step_3)
        UseUnTargetingAbility(2)
        PressReady()
        SleepRandom(duration_elise_guiding_path)
        UseUnTargetingAbility(3)
        PressReady()
        SleepRandom(duration_elise_step_5)
    }
}

FarmKurtrus17() {
    Loop, 100 {
        ; UseEnemyTargetingAbility(2, 2, 3)
        PressReady()
        SleepRandom(3300)
        UseEnemyTargetingAbility(2, 2, 3)
        UseUnTargetingAbility(2)
        UseUnTargetingAbility(3)
        PressReady()
        SleepRandom(12000)
    }
}

;;;; cmd line parsing
args_allowable := ["--play", "--attack"]
play := FALSE
attack := FALSE

for n, cmd_args in A_Args {
    if ( not HasVal(args_allowable, cmd_args)) {
        MsgBox ERROR: illegal cmd arg '%cmd_args%'.
        ExitApp 1
    }
    if (cmd_args = "--play") {
        play := TRUE
    }
    if (cmd_args = "--attack") {
        attack := TRUE
    }
}

;;;; locate hearthstone and bring it to the foreground
SetTitleMatchMode, 2
CoordMode, Mouse, Screen
tt = Hearthstone ahk_class UnityWndClass
WinWait, %tt%
IfWinNotActive, %tt%, , WinActivate, %tt%

;;;; store dimensions of hearthstone in mouse navigator object
WinGetPos, x_window_ratio, y_window_ratio, x_range, y_range, Hearthstone
mouse_navigator := new MouseWindowNavigator(x_window_ratio, y_window_ratio, x_range, y_range)

if (play) {
    ; PlayFromHandPhase(2, 1, 3) ; fire
    ; PlayFromHandPhase(1, 2, 3)
    PressReady()
    SleepRandom(12000)
}

if (attack) {
    ; FarmMonkey(2, 0)
    ; FarmVelen(2, 5000, 2)
    FarmNMinions(20)
    ; FarmCookie()
    ; Farm2()
    ; FarmFire()

    PressReady()
    SpeedupAnimations(40)
}

RButton:: ExitApp
Esc:: ExitApp
