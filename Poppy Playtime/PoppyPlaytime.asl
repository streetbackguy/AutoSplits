state("Poppy_Playtime-Win64-Shipping", "Current Patch")
{
    bool Loads: 0x45867C8;
    byte PauseMenu: 0x4A7DF74;
    byte Start: 0x4A308F0, 0x9F0, 0x760, 0xFB8, 0x72C;
    int MainMenu: 0x4939918;
}

isLoading
{
    return !current.Loads || current.PauseMenu == 3;
}

start 
{
    return current.Start == 0 && old.Start == 1;
}

reset
{
    return current.MainMenu == 452 && old.MainMenu != 452;
}
