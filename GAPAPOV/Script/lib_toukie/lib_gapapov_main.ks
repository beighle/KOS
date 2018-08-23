@lazyglobal off.

{

global T_GAPAPOV is lexicon(
  "GAPAPOV", GAPAPOV@
  ).

  Function GAPAPOV {
    Parameter GivenParameterList.

    local CurBodyIsPlanet   is "?".
    local TarBodyIsPlanet   is "?".
    local RendezvousNeeded  is "?".
    local TargetVessel      is "?".
    local TargetBody        is "?".
    local TargetPeriapsis   is "?".
    local TargetInclination is "?".
    local FinishProcedure   is false.

    if GivenParameterList:length = 1 {
      set RendezvousNeeded  to true.
      set TargetVessel      to vessel(GivenParameterList[0]).
      set TargetBody        to TargetVessel:body.
      set TargetPeriapsis   to TargetVessel:orbit:periapsis.
      set TargetInclination to TargetVessel:orbit:inclination.
    } else if GivenParameterList:length = 3 {
      set RendezvousNeeded  to false.
      set TargetBody        to GivenParameterList[0].
      set TargetPeriapsis   to GivenParameterList[1].
      set TargetInclination to GivenParameterList[2].
    }

    if TargetInclination = 0 {
      set TargetInclination to 0.001.
    }

    if ship:body = TargetBody and RendezvousNeeded = false {
      T_Transfer["ChangeOrbit"](TargetPeriapsis, TargetInclination).
      set FinishProcedure to true.
    }

    if ship:body:body:name <> "Sun" {
      set CurBodyIsPlanet to false.
    } else {
      set CurBodyIsPlanet to true.
    }

    if TargetBody:body:name <> "Sun" {
      set TarBodyIsPlanet to false.
    } else {
      set TarBodyIsPlanet to true.
    }

    if FinishProcedure = false {
      if CurBodyIsPlanet  = false {
        if ship:body:body = TargetBody:body {
          HUDtext("Going from a moon to another moon is not available at the moment.", 5, 2, 30, red, true).
		  HUDtext("Rebooting...", 5, 2, 30, red, true).
          reboot.
        } else {
          T_Transfer["MoonTransfer"](TargetBody, TargetPeriapsis, TargetInclination).
          if ship:body = TargetBody {
            set FinishProcedure to true.
          }
        }
      }
    }

    if FinishProcedure = false {
      local TemporaryDestination is TargetBody.
      if TarBodyIsPlanet = false {
        set TemporaryDestination to TargetBody:body.
      }
      if TemporaryDestination <> ship:body {
        T_Transfer["InterplanetaryTransfer"](TemporaryDestination, TargetPeriapsis, TargetInclination).
      }

      if TarBodyIsPlanet = false {
        T_Transfer["MoonTransfer"](TargetBody, TargetPeriapsis, TargetInclination).
      }
    }

    if RendezvousNeeded = true {
      HUDtext("Rendezvous is go", 5, 2, 30, red, true).
      T_Rendezvous["CompleteRendezvous"](TargetVessel).
      HUDtext("Rendezvous cleared, docking...", 5, 2, 30, red, true).
      T_Docking["Dock"](TargetVessel).
    }
  }


}
