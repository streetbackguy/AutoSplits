state("Poppy_Playtime-Win64-Shipping", "Current Patch")
{
    bool Loads: 0x45867C8;
    byte PauseMenu: 0x4A7DF74;
    float Start: 0x4A803C0, 0x70;
    string30 MainMenu: 0x4A7DFA8, 0x8B0, 0x18;
    //int CaseOpen: 0x4517370, 0x910, 0xC0, 0xF8, 0x18, 0xA8, 0x188, 0x530;
}

startup
{
    //vars.Splits = new HashSet<string>();

    //settings.Add("PP", true, "Poppy Playtime Chapter 1");
        //settings.Add("CASE", true, "Split on opening Poppy's Case", "PP");

    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | Poppy Playtime Chapter 1",
            MessageBoxButtons.YesNo, MessageBoxIcon.Question
        );

        if (timingMessage == DialogResult.Yes)
            timer.CurrentTimingMethod = TimingMethod.GameTime;
    }
}

isLoading
{
    return !current.Loads || current.PauseMenu == 3;
}

start 
{
    return current.Start != 0;
}

split
{
    //Currently not figured out. Work in Progress.
    
    //if (current.CaseOpen == 0 && old.CaseOpen == 1065353216 && !vars.Splits.Contains("CASE"))
    //{
        //vars.Splits.Add("CASE");
        //return settings["CASE"];
    //}
}

reset
{
    return current.MainMenu == "/MainMenu" && old.MainMenu == "/PP_FinalLevel";
}
