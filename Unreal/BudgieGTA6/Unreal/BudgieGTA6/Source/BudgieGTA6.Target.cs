using UnrealBuildTool;
using System.Collections.Generic;

public class BudgieGTA6Target : TargetRules
{
    public BudgieGTA6Target(TargetInfo Target) : base(Target)
    {
        Type = TargetType.Game;
        DefaultBuildSettings = BuildSettingsVersion.V5;
        IncludeOrderVersion = EngineIncludeOrderVersion.Unreal5_4;
        ExtraModuleNames.Add("BudgieGTA6");
    }
}
