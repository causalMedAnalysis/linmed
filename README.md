# linmed: A Stata Module for Causal Mediation Analysis using Linear Models

`linmed` is a Stata module to perform causal mediation analysis using linear models for both the mediator and the outcome. 

## Syntax

```stata
linmed varname [if] [in] [pw=weight] , dvar(varname) mvar(varname) d(real) dstar(real) m(real) [options]
```

### Required Arguments

- `dvar(varname)`: Specifies the treatment variable.
- `mvar(varname)`: Specifies the mediator variable.
- `d(real)`: Specifies the reference level of treatment.
- `dstar(real)`: Specifies the alternative level of treatment, defining the treatment contrast of interest (d - dstar).
- `m(real)`: Specifies the level of the mediator at which the controlled direct effect is evaluated.

### Options

- `cvars(varlist)`: List of baseline covariates to include in the analysis. Categorical variables must be coded as dummy variables.
- `nointeraction`: Specifies that a treatment-mediator interaction is not included in the outcome model (default assumes interaction is present).
- `cxd`: Includes all two-way interactions between the treatment and baseline covariates in the mediator and outcome models.
- `cxm`: Includes all two-way interactions between the mediator and baseline covariates in the outcome model.
- `reps(integer)`: Number of replications for bootstrap resampling (default is 200).
- `strata(varname)`: Identifies resampling strata for bootstrap samples.
- `cluster(varname)`: Identifies resampling clusters for bootstrap sampling.
- `level(cilevel)`: Confidence level for constructing bootstrap confidence intervals (default is 95%).
- `seed(passthru)`: Seed for bootstrap resampling to enable replicable results.
- `detail`: Prints the fitted models used to construct the effect estimates.

## Description

This command estimates two linear regression models:

1. **Mediator Model**: for the conditional mean of the mediator variable given the treatment and baseline covariates, after centering them around their sample means.
2. **Outcome Model**: for the conditional mean of the outcome variable given the treatment, the mediator, and baseline covariates, again centering them around their sample means.

`linmed` uses the coefficients from these models to construct estimates of:

- **Controlled Direct Effect**: The effect of treatment on the outcome intervening to set the mediator to m for everyone.
- **Natural Direct Effect**: The effect of treatment on the outcome not transmitted through the mediator.
- **Natural Indirect Effect**: The effect of treatment on the outcome that operates through the mediator.
- **Average Total Effect**: The total effect of treatment on the outcome.

## Examples

```stata
// Load data
use nlsy79.dta

// No interaction between treatment and mediator, percentile bootstrap CIs with default settings
linmed std_cesd_age40, dvar(att22) mvar(ever_unemp_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) m(0) nointer

// Treatment-mediator interaction, percentile bootstrap CIs with default settings
linmed std_cesd_age40, dvar(att22) mvar(ever_unemp_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) m(0)

//Treatment-mediator interaction, all two-way interactions between baseline covariates and treatment, percentile bootstrap CIs with 1000 replications
linmed std_cesd_age40, dvar(att22) mvar(ever_unemp_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) m(0) cxd reps(1000)
```

## Saved Results

`linmed` saves the following results in `e()`:

- **Matrices**:
  - `e(b)`: Matrix containing direct, indirect, and total effect estimates.

## Author

Geoffrey T. Wodtke  
Department of Sociology  
University of Chicago

Email: [wodtke@uchicago.edu](mailto:wodtke@uchicago.edu)

## References

- Wodtke, Geoffrey T. and Xiang Zhou. Causal Mediation Analysis. In preparation.

## Also See

- Help: [regress R](#), [bootstrap R](#)

```
