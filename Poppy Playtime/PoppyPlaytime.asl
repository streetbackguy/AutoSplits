state("Poppy_Playtime-Win64-Shipping")
{
    int IsPaused: 0x67E37E4;
}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    vars.Helper.Settings.CreateFromXml("Components/LiveSplit.PoppyPlaytime.Settings.xml");

    vars.CompletedSplits = new HashSet<string>();
}

onStart
{
    vars.CompletedSplits.Clear();
}

init
{
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

    IntPtr gEngine = vars.Helper.ScanRel(3, "48 8B 0D ???????? 66 0F 5A C9 E8");
    IntPtr namePoolData = vars.Helper.ScanRel(7, "8B D9 74 ?? 48 8D 15 ???????? EB");
    IntPtr gSyncLoadCount = vars.Helper.ScanRel(21, "33 C0 0F 57 C0 F2 0F 11 05");

    if (gEngine == IntPtr.Zero || namePoolData == IntPtr.Zero || gSyncLoadCount == IntPtr.Zero)
    {
        throw new InvalidOperationException(
            "Not all required addresses found. Retrying.");
    }

    vars.Helper["IsLoading"] = vars.Helper.Make<bool>(gSyncLoadCount);

    vars.Helper["Level"] = vars.Helper.MakeString(ReadStringType.UTF16, gEngine, 0xAF8, 0x0);

    vars.Helper["LocalPlayer"] = vars.Helper.Make<ulong>(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x18);
    vars.Helper["LocalPlayer"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;

    vars.Helper["AcknowledgedPawn"] = vars.Helper.Make<ulong>(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x18);
    vars.Helper["AcknowledgedPawn"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;

    vars.Helper["GameReady"] = vars.Helper.Make<byte>(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x8A0); // bool?

    vars.Helper["X"] = vars.Helper.Make<int>(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x328, 0x128); // DOUBLE!
    vars.Helper["Y"] = vars.Helper.Make<int>(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x328, 0x130); // DOUBLE!
    vars.Helper["Z"] = vars.Helper.Make<int>(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x328, 0x138); // DOUBLE!
    vars.Helper["Yaw"] = vars.Helper.Make<int>(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x328, 0x148); // DOUBLE!

    vars.Helper["HasLeftHand"] = vars.Helper.Make<bool>(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x921);
    vars.Helper["HasRightHand"] = vars.Helper.Make<bool>(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x920);

    vars.GetInventory = (Func<string[]>)(() =>
    {
        var size = vars.Helper.Read<int>(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908 + 0x8);
        var slots = new string[size];
        for (int i = 0; i < size; i++)
        {
            int length = vars.Helper.Read<int>(gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908 + 0x0, 0x28 * i + 0x8 + 0x8, 0x0);
            slots[i] = vars.Helper.ReadString(length, ReadStringType.UTF16, gEngine, 0xFC0, 0x38, 0x0, 0x30, 0x2E0, 0x908, 0x28 * i + 0x8 + 0x0, 0x0);
        }

        return slots;
    });

    var fNameCache = new Dictionary<ulong, string>();
    vars.FNameToString = (Func<ulong, bool, string>)((fName, withNumber) =>
    {
        string cachedName;
        if (fNameCache.TryGetValue(fName, out cachedName))
        {
            if (!withNumber)
            {
                int i = cachedName.LastIndexOf('_');
                if (i != -1)
                {
                    cachedName = cachedName.Substring(0, i);
                }
            }

            return cachedName;
        }

        var nameIdx  = (fName & 0x000000000000FFFF) >> 0x00;
        var chunkIdx = (fName & 0x00000000FFFF0000) >> 0x10;
        var number   = (fName & 0xFFFFFFFF00000000) >> 0x20;

        IntPtr chunk = vars.Helper.Read<IntPtr>(namePoolData + 0x10 + (int)chunkIdx * 0x8);
        IntPtr entry = chunk + (int)nameIdx * sizeof(short);

        var length = vars.Helper.Read<short>(entry) >> 6;
        var name = vars.Helper.ReadString(length, ReadStringType.UTF8, entry + sizeof(short));
        var nameWithNumber = name + "_" + number;

        fNameCache[fName] = nameWithNumber;
        return withNumber ? nameWithNumber : name;
    });

    vars.FNameToShortString = (Func<ulong, string>)(fName =>
    {
        string name = vars.FNameToString(fName);

        int dot = name.LastIndexOf('.');
        int slash = name.LastIndexOf('/');

        return name.Substring(Math.Max(dot, slash) + 1);
    });
}

update
{
    vars.Helper.Update();
    vars.Helper.MapPointers();

    current.Inventory = vars.GetInventory();

    // vars.Log("Localplayer?: " + vars.FNameToString(current.LocalPlayer));
    // vars.Log("Localplayer?: " + vars.FNameToString(current.AcknowledgedPawn));
}

start
{
    return old.X == -1073741824 && current.X != -1073741824
        || current.GameReady == 1 && old.Y == -536870912 && current.Y != -536870912
        || current.GameReady == 1 && old.Z == -1850441728 && current.Z != -1850441728
        || current.GameReady == 1 && old.Yaw == 0 && current.Yaw != 0;
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
}

reset
{
    return current.Level == "/Game/Levels/MainMenu";
}

isLoading
{
    return vars.FNameToString(current.LocalPlayer, false) != "BP_PoppyPlayerController_C"
        || vars.FNameToString(current.AcknowledgedPawn, false) != "PlayerBP"
        || current.GameReady != 1
        || current.IsLoading
        || current.IsPaused == 3;
}
