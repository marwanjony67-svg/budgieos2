#include "BudgieGTA6GameMode.h"
#include "BudgieGTA6Character.h"

ABudgieGTA6GameMode::ABudgieGTA6GameMode()
{
    DefaultPawnClass = ABudgieGTA6Character::StaticClass();
}
