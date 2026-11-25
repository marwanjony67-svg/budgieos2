using UnrealBuildTool;
using System.Collections.Generic;

public class BudgieGTA6EditorTarget : TargetRules
{
    public BudgieGTA6EditorTarget(TargetInfo Target) : base(Target)
    {
        Type = TargetType.Editor;
        DefaultBuildSettings = BuildSettingsVersion.V5;
        IncludeOrderVersion = EngineIncludeOrderVersion.Unreal5_4;
        ExtraModuleNames.Add("BudgieGTA6");
    }
}
