state("Playtime_Prototype4-Win64-Shipping", "1.0")
{
}

state("Poppy_Playtime-Win64-Shipping", "1.1")
{
}

state("Poppy_Playtime-Win64-Shipping", "1.2")
{
}

state("Poppy_Playtime-Win64-Shipping", "1.3")
{
    int Paused: 0x67E37E4;
}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    vars.Helper.Settings.CreateFromXml("Components/LiveSplit.PoppyPlaytime.Settings.xml");
    vars.Helper.GameName = "Poppy Playtime Chapter 1";

    vars.CompletedSplits = new HashSet<string>();
}

init
{
    string MD5Hash;
    using (var md5 = System.Security.Cryptography.MD5.Create())
    using (var s = File.Open(modules.First().FileName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
    MD5Hash = md5.ComputeHash(s).Select(x => x.ToString("X2")).Aggregate((a, b) => a + b);
    print("Hash is: " + MD5Hash);

    switch (MD5Hash)
        {
            case "9B2AF956205EE1FB7813D2783AA231CA":
                version = "1.0";
                break;

            case "DA5C6FB9F593E1988B444AA6E712150B":
                version = "1.1";
                break;

            case "590B539C8833454F89BBEAA1621B74B5":
                version = "1.2";
                break;

            case "0543129E53C580044DA7AC9F95521726":
                version = "1.3";
                break;

            default:
                version = "Unknown";
                break;
        }

    vars.CheckForSplit = (Func<string, bool>)(key =>
    {
        if (!settings[key] || !vars.CompletedSplits.Add(key))
        {
            return false;
        }

        if (settings["dbg"])
        {
            vars.Log("Completed split: " + key);
        }

        return true;
    });

    
        IntPtr gWorldUE4 = vars.Helper.ScanRel(3, "48 8B 05 ???????? 48 3B C? 48 0F 44 C? 48 89 05 ???????? E8");
        IntPtr gEngineUE4 = vars.Helper.ScanRel(3, "48 89 05 ???????? 48 85 C9 74 ?? E8 ???????? 48 8D 4D");
        IntPtr fNamesUE4 = vars.Helper.ScanRel(3, "48 8D 05 ???????? EB ?? 48 8D 0D ???????? E8 ???????? C6 05");
        IntPtr gSyncLoadCountUE4 = vars.Helper.ScanRel(5, "89 43 60 8B 05 ?? ?? ?? ??");
        IntPtr gEngineUE5 = vars.Helper.ScanRel(3, "48 8B 0D ???????? 66 0F 5A C9 E8");
        IntPtr fNamesUE5 = vars.Helper.ScanRel(7, "8B D9 74 ?? 48 8D 15 ???????? EB");
        IntPtr gSyncLoadCountUE5 = vars.Helper.ScanRel(21, "33 C0 0F 57 C0 F2 0F 11 05");

    if(version == "1.0")
    {
        vars.Helper["IsLoading"] = vars.Helper.Make<bool>(gSyncLoadCountUE4);

        vars.Helper["Level"] = vars.Helper.MakeString(ReadStringType.UTF16, gEngineUE4, 0x8B0, 0x0);

        vars.Helper["LocalPlayer"] = vars.Helper.Make<ulong>(gEngineUE4, 0xDE8, 0x38, 0x0, 0x30, 0x18);
        vars.Helper["LocalPlayer"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;

        vars.Helper["AcknowledgedPawn"] = vars.Helper.Make<ulong>(gEngineUE4, 0xDE8, 0x38, 0x0, 0x30, 0x260, 0x18);
        vars.Helper["AcknowledgedPawn"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;

        vars.Helper["GameReady"] = vars.Helper.Make<byte>(gEngineUE4, 0xDE8, 0x38, 0x0, 0x30, 0x260, 0x870);

        vars.Helper["X"] = vars.Helper.Make<float>(gEngineUE4, 0xDE8, 0x38, 0x0, 0x30, 0x260, 0x290, 0x11C);
        vars.Helper["Y"] = vars.Helper.Make<float>(gEngineUE4, 0xDE8, 0x38, 0x0, 0x30, 0x260, 0x290, 0x120);
        vars.Helper["Z"] = vars.Helper.Make<float>(gEngineUE4, 0xDE8, 0x38, 0x0, 0x30, 0x260, 0x290, 0x124);
        vars.Helper["Yaw"] = vars.Helper.Make<float>(gEngineUE4, 0xDE8, 0x38, 0x0, 0x30, 0x260, 0x290, 0x12C);

        vars.Helper["HasLeftHand"] = vars.Helper.Make<bool>(gEngineUE4, 0xDE8, 0x38, 0x0, 0x30, 0x260, 0x70A);
        vars.Helper["HasRightHand"] = vars.Helper.Make<bool>(gEngineUE4, 0xDE8, 0x38, 0x0, 0x30, 0x260, 0x709);

        // GEngine.GameViewport.World.PersistentLevel.WorldSettings.PauserPlayerState.Name
        vars.Helper["PauseMenu"] = vars.Helper.Make<bool>(gEngineUE4, 0x780, 0x78, 0x30, 0x258, 0x370);

        // GWorld.StreamingLevels[1].LoadedLevel.
        vars.Helper["isEndCaseDoorOpening"] = vars.Helper.Make<int>(gWorldUE4, 0x88, 0x8, 0x128, 0x98, 0x760, 0x278, 0xB1);

        vars.GetInventory = (Func<string[]>)(() =>
        {
            var size = vars.Helper.Read<int>(gEngineUE4, 0xDE8, 0x38, 0x0, 0x30, 0x260, 0x860 + 0x8);
            var slots = new string[size];
            for (int i = 0; i < size; i++)
            {
                int length = vars.Helper.Read<int>(gEngineUE4, 0xDE8, 0x38, 0x0, 0x30, 0x260, 0x860 + 0x0, 0x28 * i + 0x8 + 0x8, 0x0);
                slots[i] = vars.Helper.ReadString(length, ReadStringType.UTF16, gEngineUE4, 0xDE8, 0x38, 0x0, 0x30, 0x260, 0x860, 0x28 * i + 0x8 + 0x0, 0x0);
            }

            return slots;
        });
    } else if(version == "1.1")
    {
        vars.Helper["IsLoading"] = vars.Helper.Make<bool>(gSyncLoadCountUE4);

        vars.Helper["Level"] = vars.Helper.MakeString(ReadStringType.UTF16, gEngineUE4, 0x8B0, 0x0);

        vars.Helper["LocalPlayer"] = vars.Helper.Make<ulong>(gEngineUE4, 0xDE8, 0x38, 0x0, 0x30, 0x18);
        vars.Helper["LocalPlayer"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;

        vars.Helper["AcknowledgedPawn"] = vars.Helper.Make<ulong>(gEngineUE4, 0xDE8, 0x38, 0x0, 0x30, 0x260, 0x18);
        vars.Helper["AcknowledgedPawn"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;

        vars.Helper["GameReady"] = vars.Helper.Make<byte>(gEngineUE4, 0xDE8, 0x38, 0x0, 0x30, 0x260, 0x870);

        vars.Helper["X"] = vars.Helper.Make<float>(gEngineUE4, 0xDE8, 0x38, 0x0, 0x30, 0x260, 0x290, 0x11C);
        vars.Helper["Y"] = vars.Helper.Make<float>(gEngineUE4, 0xDE8, 0x38, 0x0, 0x30, 0x260, 0x290, 0x120);
        vars.Helper["Z"] = vars.Helper.Make<float>(gEngineUE4, 0xDE8, 0x38, 0x0, 0x30, 0x260, 0x290, 0x124);
        vars.Helper["Yaw"] = vars.Helper.Make<float>(gEngineUE4, 0xDE8, 0x38, 0x0, 0x30, 0x260, 0x290, 0x12C);

        vars.Helper["HasLeftHand"] = vars.Helper.Make<bool>(gEngineUE4, 0xDE8, 0x38, 0x0, 0x30, 0x260, 0x70A);
        vars.Helper["HasRightHand"] = vars.Helper.Make<bool>(gEngineUE4, 0xDE8, 0x38, 0x0, 0x30, 0x260, 0x709);

        vars.Helper["PauseMenu"] = vars.Helper.Make<bool>(gEngineUE4, 0x780, 0x78, 0x30, 0x258, 0x370);

        vars.Helper["isEndCaseDoorOpening"] = vars.Helper.Make<int>(gWorldUE4, 0x88, 0x8, 0x128, 0x98, 0x760, 0x278, 0xB1);

        vars.GetInventory = (Func<string[]>)(() =>
        {
            var size = vars.Helper.Read<int>(gEngineUE4, 0xDE8, 0x38, 0x0, 0x30, 0x260, 0x860 + 0x8);
            var slots = new string[size];
            for (int i = 0; i < size; i++)
            {
                int length = vars.Helper.Read<int>(gEngineUE4, 0xDE8, 0x38, 0x0, 0x30, 0x260, 0x860 + 0x0, 0x28 * i + 0x8 + 0x8, 0x0);
                slots[i] = vars.Helper.ReadString(length, ReadStringType.UTF16, gEngineUE4, 0xDE8, 0x38, 0x0, 0x30, 0x260, 0x860, 0x28 * i + 0x8 + 0x0, 0x0);
            }

            return slots;
        });
    } else if(version == "1.2")
    {
        vars.Helper["IsLoading"] = vars.Helper.Make<bool>(gSyncLoadCountUE4);

        vars.Helper["Level"] = vars.Helper.MakeString(ReadStringType.UTF16, gEngineUE4, 0x8B0, 0x0);

        vars.Helper["LocalPlayer"] = vars.Helper.Make<ulong>(gEngineUE4, 0xD28, 0x38, 0x0, 0x30, 0x18);
        vars.Helper["LocalPlayer"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;

        vars.Helper["AcknowledgedPawn"] = vars.Helper.Make<ulong>(gEngineUE4, 0xD28, 0x38, 0x0, 0x30, 0x260, 0x18);
        vars.Helper["AcknowledgedPawn"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;

        vars.Helper["GameReady"] = vars.Helper.Make<byte>(gEngineUE4, 0xD28, 0x38, 0x0, 0x30, 0x260, 0x870);

        vars.Helper["X"] = vars.Helper.Make<float>(gEngineUE4, 0xD28, 0x38, 0x0, 0x30, 0x260, 0x290, 0x11C);
        vars.Helper["Y"] = vars.Helper.Make<float>(gEngineUE4, 0xD28, 0x38, 0x0, 0x30, 0x260, 0x290, 0x120);
        vars.Helper["Z"] = vars.Helper.Make<float>(gEngineUE4, 0xD28, 0x38, 0x0, 0x30, 0x260, 0x290, 0x124);
        vars.Helper["Yaw"] = vars.Helper.Make<float>(gEngineUE4, 0xD28, 0x38, 0x0, 0x30, 0x260, 0x290, 0x12C);

        vars.Helper["HasLeftHand"] = vars.Helper.Make<bool>(gEngineUE4, 0xD28, 0x38, 0x0, 0x30, 0x260, 0x70A);
        vars.Helper["HasRightHand"] = vars.Helper.Make<bool>(gEngineUE4, 0xD28, 0x38, 0x0, 0x30, 0x260, 0x709);

        vars.Helper["PauseMenu"] = vars.Helper.Make<bool>(gEngineUE4, 0x780, 0x78, 0x30, 0x258, 0x370);

        vars.Helper["isEndCaseDoorOpening"] = vars.Helper.Make<int>(gWorldUE4, 0x88, 0x8, 0x128, 0x98, 0x760, 0x278, 0xB1);

        vars.GetInventory = (Func<string[]>)(() =>
        {
            var size = vars.Helper.Read<int>(gEngineUE4, 0xD28, 0x38, 0x0, 0x30, 0x260, 0x860 + 0x8);
            var slots = new string[size];
            for (int i = 0; i < size; i++)
            {
                int length = vars.Helper.Read<int>(gEngineUE4, 0xD28, 0x38, 0x0, 0x30, 0x260, 0x860 + 0x0, 0x28 * i + 0x8 + 0x8, 0x0);
                slots[i] = vars.Helper.ReadString(length, ReadStringType.UTF16, gEngineUE4, 0xD28, 0x38, 0x0, 0x30, 0x260, 0x860, 0x28 * i + 0x8 + 0x0, 0x0);
            }

            return slots;
        });
    } else if(version == "1.3")
    {
        vars.Helper["IsLoading"] = vars.Helper.Make<bool>(gSyncLoadCountUE5);

        // GEngine.TransitionDescripton
        vars.Helper["Level"] = vars.Helper.MakeString(ReadStringType.UTF16, gEngineUE5, 0xAF8, 0x0);

        // GEngine.GameInstance.LocalPlayers[0].PlayerController.Name
        vars.Helper["LocalPlayer"] = vars.Helper.Make<ulong>(gEngineUE5, 0xFC0, 0x38, 0x0, 0x30, 0x18);
        vars.Helper["LocalPlayer"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;

        // GEngine.GameInstance.LocalPlayers[0].PlayerController.Character.Name
        vars.Helper["AcknowledgedPawn"] = vars.Helper.Make<ulong>(gEngineUE5, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x18);
        vars.Helper["AcknowledgedPawn"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;

        // GEngine.GameInstance.LocalPlayers[0].PlayerController.Character.CapsuleComponent.Game Rwady To Play?
        vars.Helper["GameReady"] = vars.Helper.Make<byte>(gEngineUE5, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x8A0);

        // GEngine.GameInstance.LocalPlayers[0].PlayerController.Character.CapsuleComponent.RelativeLocation
        vars.Helper["X"] = vars.Helper.Make<double>(gEngineUE5, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x328, 0x128);
        vars.Helper["Y"] = vars.Helper.Make<double>(gEngineUE5, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x328, 0x130);
        vars.Helper["Z"] = vars.Helper.Make<double>(gEngineUE5, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x328, 0x138);
        vars.Helper["Yaw"] = vars.Helper.Make<double>(gEngineUE5, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x328, 0x148);

        // GEngine.GameInstance.LocalPlayers[0].PlayerController.Character.hasLeftHand?
        vars.Helper["HasLeftHand"] = vars.Helper.Make<bool>(gEngineUE5, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x921);
        // GEngine.GameInstance.LocalPlayers[0].PlayerController.Character.hasRightHand?
        vars.Helper["HasRightHand"] = vars.Helper.Make<bool>(gEngineUE5, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x920);

        // GEngine.GameViewport.World.PersistentLevel.WorldSettings.PauserPlayerState.Name
        vars.Helper["PauseMenu"] = vars.Helper.Make<bool>(gEngineUE5, 0x9B8, 0x78, 0x30, 0x298, 0x488);

        // GEngine.GameInstance.LocalPlayers[0].PlayerController.Character.Stored Inventory
        vars.GetInventory = (Func<string[]>)(() =>
        {
            var size = vars.Helper.Read<int>(gEngineUE5, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908 + 0x8);
            var slots = new string[size];
            for (int i = 0; i < size; i++)
            {
                int length = vars.Helper.Read<int>(gEngineUE5, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908 + 0x0, 0x28 * i + 0x8 + 0x8, 0x0);
                slots[i] = vars.Helper.ReadString(length, ReadStringType.UTF16, gEngineUE5, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908, 0x28 * i + 0x8 + 0x0, 0x0);
            }

            return slots;
        });
    }

    vars.FNameToString = (Func<ulong, string>)(fName =>
	{
		var nameIdx = (fName & 0x000000000000FFFF) >> 0x00;
		var chunkIdx = (fName & 0x00000000FFFF0000) >> 0x10;
		var number = (fName & 0xFFFFFFFF00000000) >> 0x20;

		IntPtr chunk = vars.Helper.Read<IntPtr>(fNamesUE4 + 0x10 + (int)chunkIdx * 0x8);
		IntPtr entry = chunk + (int)nameIdx * sizeof(short);

		int length = vars.Helper.Read<short>(entry) >> 6;
		string name = vars.Helper.ReadString(length, ReadStringType.UTF8, entry + sizeof(short));

		return number == 0 ? name : name;
	});

    vars.FNameToString2 = (Func<ulong, string>)(fName =>
	{
		var nameIdx = (fName & 0x000000000000FFFF) >> 0x00;
		var chunkIdx = (fName & 0x00000000FFFF0000) >> 0x10;
		var number = (fName & 0xFFFFFFFF00000000) >> 0x20;

		IntPtr chunk = vars.Helper.Read<IntPtr>(fNamesUE5 + 0x10 + (int)chunkIdx * 0x8);
		IntPtr entry = chunk + (int)nameIdx * sizeof(short);

		int length = vars.Helper.Read<short>(entry) >> 6;
		string name = vars.Helper.ReadString(length, ReadStringType.UTF8, entry + sizeof(short));

		return number == 0 ? name : name;
	});

    vars.FNameToShortString = (Func<ulong, string>)(fName =>
    {
        string name = vars.FNameToString(fName);

        int dot = name.LastIndexOf('.');
        int slash = name.LastIndexOf('/');

        return name.Substring(Math.Max(dot, slash) + 1);
    });

    current.Checkpoint = "";
}

update
{
    vars.Helper.Update();
    vars.Helper.MapPointers();

    current.Inventory = vars.GetInventory();

    // vars.Log("LocalPlayer?: " + vars.FNameToString(current.LocalPlayer));
    // vars.Log("Checkpoint?: " + current.C1Checkpoint);
    // vars.Log("LocalPlayer?: " + vars.FNameToString2(current.LocalPlayer));
    // vars.Log("Pawn?: " + vars.FNameToString2(current.AcknowledgedPawn));
    // vars.Log("Level?: " + current.Level);
}

start
{
    return current.GameReady == 1 && current.X != -3975.86669921875 && old.X == -3975.86669921875
        || current.GameReady == 1 && current.Y != -0.171082004904747 && old.Y == -0.171082004904747
        || current.GameReady == 1 && current.Z != 90.1499981177039 && old.Z == 90.1499981177039
        || current.GameReady == 1 && current.Yaw != 0 && old.Yaw == 0;
}

onStart
{
    vars.CompletedSplits.Clear();
}

split
{
    if (current.IsLoading)
    {
        return false;
    }

    if (old.Inventory.Length < current.Inventory.Length)
    {
        for (int i = old.Inventory.Length; i < current.Inventory.Length; i++)
        {
            string key = "+ " + current.Inventory[i];
            if (vars.CheckForSplit(key))
            {
                return true;
            }
        }
    }
    else if (old.Inventory.Length > current.Inventory.Length)
    {
        for (int i = current.Inventory.Length; i < old.Inventory.Length; i++)
        {
            string key = "- " + old.Inventory[i];
            if (vars.CheckForSplit(key))
            {
                return true;
            }
        }
    }

    return !old.HasLeftHand && current.HasLeftHand && vars.CheckForSplit("+ Left Hand")
        || !old.HasRightHand && current.HasRightHand && vars.CheckForSplit("+ Right Hand");

    if(current.version == "1.0")
    {
        return current.isEndCaseDoorOpening == 0 && old.isEndCaseDoorOpening == 4;
    }
}

reset
{
    return current.Level == "/Game/Levels/MainMenu";
}

isLoading
{
    if(version == "1.3")
    {
        return vars.FNameToString2(current.LocalPlayer) != "BP_PoppyPlayerController_C"
            || vars.FNameToString2(current.AcknowledgedPawn) != "PlayerBP"
            || current.GameReady != 1
            || current.IsLoading
            || current.Paused == 3;
    } else {
        return vars.FNameToString(current.LocalPlayer) != "PlayerController"
            || vars.FNameToString(current.AcknowledgedPawn) != "PlayerBP"
            || current.GameReady != 1
            || current.IsLoading
            || current.PauseMenu;
    }
}
