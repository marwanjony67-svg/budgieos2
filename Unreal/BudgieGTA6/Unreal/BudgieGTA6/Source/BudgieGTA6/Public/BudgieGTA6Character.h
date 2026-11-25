#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Character.h"
#include "BudgieGTA6Character.generated.h"

class UCameraComponent;
class USpringArmComponent;

UCLASS()
class BUDGIEGTA6_API ABudgieGTA6Character : public ACharacter
{
    GENERATED_BODY()

public:
    ABudgieGTA6Character();

protected:
    virtual void SetupPlayerInputComponent(UInputComponent* PlayerInputComponent) override;

    void MoveForward(float Value);
    void MoveRight(float Value);
    void Turn(float Value);
    void LookUp(float Value);

    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category = "Camera")
    TObjectPtr<USpringArmComponent> CameraBoom;

    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category = "Camera")
    TObjectPtr<UCameraComponent> FollowCamera;
};
