state("Playtime_Prototype4-Win64-Shipping")
{
    // PlayerBP_C pointer location : 0x426E5C8, 0x238, 0x240;
    // UWorld pointer location : 0x42FEBD8, 0x018, 0x010, 0x068, 0x020;

    bool hasLeftHand                : 0x0426E5C8, 0x238, 0x240, 0x70A;  // The hasLeftHand flag is set when the left hand is picked up
    bool hasRightHand               : 0x0426E5C8, 0x238, 0x240, 0x709;  // The hasRightHand flag is set when the right hand is picked up
    bool isGameReady                : 0x0426E5C8, 0x238, 0x240, 0x870;  // The isGameReady flag is set as soon as the player actor is controllable

    int inventorySize               : 0x0426E5C8, 0x238, 0x240, 0x868;  // The current size of the players inventory

    // I couldn't find a valid item id, so instead each inventory slot is checked using it's display name
    string32 slot1DisplayName       : 0x0426E5C8, 0x238, 0x240, 0x860, 0x008, 0x0;
    string32 slot2DisplayName       : 0x0426E5C8, 0x238, 0x240, 0x860, 0x030, 0x0;
    string32 slot3DisplayName       : 0x0426E5C8, 0x238, 0x240, 0x860, 0x058, 0x0;
    string32 slot4DisplayName       : 0x0426E5C8, 0x238, 0x240, 0x860, 0x080, 0x0;
    string32 slot5DisplayName       : 0x0426E5C8, 0x238, 0x240, 0x860, 0x0A8, 0x0;
    string32 slot6DisplayName       : 0x0426E5C8, 0x238, 0x240, 0x860, 0x0D0, 0x0;
    string32 slot7DisplayName       : 0x0426E5C8, 0x238, 0x240, 0x860, 0x0F8, 0x0;
    string32 slot8DisplayName       : 0x0426E5C8, 0x238, 0x240, 0x860, 0x118, 0x0;
    string32 slot9DisplayName       : 0x0426E5C8, 0x238, 0x240, 0x860, 0x148, 0x0;
    string32 slot10DisplayName      : 0x0426E5C8, 0x238, 0x240, 0x860, 0x170, 0x0;
    string32 slot11DisplayName      : 0x0426E5C8, 0x238, 0x240, 0x860, 0x198, 0x0;

    bool isHuggyRevealed            : 0x04303360, 0x030, 0x0A8, 0x320, 0x020, 0x508;

    // PoppyDoorCase_C pointer location : 0x04303360, 0x580, 0x018, 0x020, 0x098, 0x780;

    /*
     * I also could find a bool anywhere in any anim_graphs or timelines that was being set when the flickering timeline started to play
     * But the timeline completion percentage updates from 0 to 1 so we use that instead
     */ 
    int isDoorOpened               : 0x04303360, 0x580, 0x018, 0x020, 0x098, 0x780, 0x278, 0x0BC;
}

init
{
    // Set to true to get debug messages on splits, false otherwise
    vars.debugSplits = true;

    /*
     * While moving around the level the hand flags are flipped at certain places. 
     * I believe this is due to the level streaming and possibly a bug with the PlayerBP prefab.
     * To avoid incorrect splits we keep a persistent flag which is reset with every run start
     */
    vars.hasPickedUpLeftHand = false;
    vars.hasPickedUpRightHand = false;

    Dictionary<string, Tuple<string, string>> itemNames = new Dictionary<string, Tuple<string, string>>() {
        // Vhs tapes
        { "vhslobby", Tuple.Create("Lobby VHS", "Insert Lobby VHS") },
        { "vhssecurity", Tuple.Create("Security VHS", "Insert Security VHS") },
        { "vhsstorage", Tuple.Create("Storage VHS", "Insert Storage VHS") },
        { "vhsmachine", Tuple.Create("Machine VHS", "Insert Machine VHS") },
        { "vhssilo", Tuple.Create("Silo VHS", "Insert Silo VHS") },

        // Key to the power room
        { "simonroomkey", Tuple.Create("Simon Room Key", "") },
        
        // Keys which start the right hand crane in the storage area
        { "blue", Tuple.Create("Blue Key", "") },
        { "red", Tuple.Create("Red Key", "" },
        { "green", Tuple.Create("Green Key", "") },
        { "yellow", Tuple.Create("Yellow Key", "") },

        // The doll that is created in the machine room
        { "scannerdoll", Tuple.Create("Scanner Doll", "Insert Scanner Doll") },
    };

    // Story references to all inventory slots
    vars.inventorySlots = new object[] {
        current.slot1DisplayName,
        current.slot2DisplayName,
        current.slot3DisplayName,
        current.slot4DisplayName,
        current.slot5DisplayName,
        current.slot6DisplayName,
        current.slot7DisplayName,
        current.slot8DisplayName,
        current.slot9DisplayName,
        current.slot10DisplayName,
        current.slot11DisplayName,
    };

    // We need to keep track of the current inventory state due to a level streaming player prefab bug
    vars.currentInventory = new List<string>();

    vars.SplitOnInventoryPickup = (Func<string, bool>) ( (displayName) =>  {
        Tuple<string, string> itemSettingsKeys;
        if (!itemNames.TryGetValue(displayName.ToLower(), out itemSettingsKeys) || !settings[itemSettingsKeys.Item1]) {
            // Don't split if the item doesn't exist in the splittable items, or isn't enabled in the settings 
            return false;
        }

        if (vars.debugSplits) {
            print(itemSettingsKeys.Item1);
        }

        return true;
    });
}

startup
{
    // Any% Settings
    settings.Add("Chapter 1", true);
    settings.Add("Any%", true, "General Any% settings.", "Chapter 1");
    settings.CurrentDefaultParent = "Any%";
    settings.Add("Security VHS", true);
    settings.Add("Insert Security VHS", true);
    settings.Add("Left Hand", true);
    settings.Add("Simon Room Key", true, "Power Room Key");
    settings.Add("Right Hand", true);
    settings.Add("Scanner Doll", true);
    settings.Add("Insert Scanner Doll", true);
    settings.Add("Huggy Wuggy Chase", true);


    // All Tapes Settings
    settings.Add("All Tapes", false, "All Tapes Category Settings.", "Chapter 1");
    settings.CurrentDefaultParent = "All Tapes";
    settings.Add("Lobby VHS", false);
    settings.Add("Insert Lobby VHS", false);
    settings.Add("Storage VHS", false);
    settings.Add("Insert Storage VHS", false);
    settings.Add("Machine VHS", false);
    settings.Add("Insert Machine VHS", false);
    settings.Add("Silo VHS", false);
    settings.Add("Insert Silo VHS", false);
}

start
{
    if (current.isGameReady && current.isGameReady != old.isGameReady) {
        vars.hasPickedUpLeftHand = false;
        vars.hasPickedUpRightHand = false;
        return true;
    }
}

split
{
    if (settings["Left Hand"] && !vars.hasPickedUpLeftHand && current.hasLeftHand) {
        if (vars.debugSplits) {
            print("Left Hand Split");
        }
        
        vars.hasPickedUpLeftHand = true;
        return true;
    }

    if (settings["Right Hand"] && !vars.hasPickedUpRightHand && current.hasRightHand) {
        if (vars.debugSplits) {
            print("Right Hand Split");
        }

        vars.hasPickedUpRightHand = true;
        return true;
    }

    if (settings["Huggy Wuggy Chase"] && !old.isHuggyRevealed && current.isHuggyRevealed) {
        if (vars.debugSplits) {
            print("Huggy Wuggy Chase");
        }

        return true;
    }

    if (old.isDoorOpened < current.isDoorOpened) {
        if (vars.debugSplits) {
            print("Poppy Case Door Opened");
        }

        return true;
    }

    if (current.inventorySize > old.inventorySize) {
        // Add the item to the player inventory
        string newItemName = (string) vars.inventorySlots[current.inventorySize - 1];
        vars.currentInventory.Add(newItemName)

        // The player has picked something up, find out what it is and split based on display name
        if (vars.SplitOnInventoryPickup(newItemName)) {
            return true;
        }
    } else if (currentInventory.inventorySize < old.inventorySize) {
        // This is dumb, but I couldn't find valid fields for when the item placements happen so we just need to find what item was removed from inventory by name
        for (int currentInventoryIndex = 0; currentInventoryIndex < vars.currentInventory.Length; currentInventoryIndex++) {
            string currentInventorySlotName = vars.currentInventory[currentInventoryIndex];

            for (int checkSlotIndex = 0; checkSlotIndex < vars.inventorySlots.Length; checkSlotIndex++) {
                if (currentInventorySlotName == vars.inventorySlots[currentInventorySlotName]) {
                    // This item is still in the inventory
                    continue;
                }

                // Clean up the removed item
                vars.currentInventory.RemoveAtIndex(currentInventoryIndex);

                Tuple<string, string> itemSettingsKeys;
                if (!itemNames.TryGetValue(currentInventorySlotName.ToLower(), out itemSettingsKeys) || !settings[itemSettingsKeys.Item2]) {
                    // Don't split if the item doesn't exist in the splittable items, or isn't enabled in the settings 
                    return false;
                }

                if (vars.debugSplits) {
                    print(itemSettingsKeys.Item2);
                }

                return true;
            }
        }
    }
}

reset
{
    // TODO: Reset when going back to menu
}