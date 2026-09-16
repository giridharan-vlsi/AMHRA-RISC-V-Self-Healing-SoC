# AMHRA complete development flow

Architecture
  -> RTL
  -> RTL simulation/fault injection
  -> VCS/Verdi
  -> Design Compiler
  -> PrimeTime
  -> Fusion Compiler
  -> IC Validator
  -> GDSII

Core decision rule:

1. Observe global health.
2. Analyze temporal behavior and severity.
3. Generate recovery candidates.
4. Reject candidates that do not exceed the baseline reliability requirement.
5. Calculate recovery disruption cost.
6. Select the minimum-cost eligible action.
7. Execute.
8. Verify.
9. Escalate if verification fails.

The reliability percentages in the RTL are placeholders for architectural modeling.
For a paper/presentation, replace them with measured values obtained from the same
fault-injection campaign used for the baseline comparison.
