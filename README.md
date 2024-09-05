# linmed: A Stata Module for Causal Mediation Analysis using Linear Models

`linmed` is a Stata module to perform causal mediation analysis using linear models for the mediator(s) and the outcome. 

## Syntax

```stata
linmed depvar mvars [if] [in] [pweight], dvar(varname) d(real) dstar(real) [options]
```

### Required Arguments

- `depvar`: Specifies the outcome variable.
- `mvars`: Specifies the the mediator(s), which may be a single variable or multivariate.
- `dvar(varname)`: Specifies the treatment variable.
- `d(real)`: Specifies the reference level of treatment.
- `dstar(real)`: Specifies the alternative level of treatment, defining the treatment contrast of interest (d - dstar).

### Options

- `cvars(varlist)`: List of baseline covariates to include in the analysis. Categorical variables must be coded as dummy variables.
- `nointeraction`: Specifies whether treatment-mediator interactions are not to be included in the outcome model (the default includes the interactions).
- `cxd`: Includes all two-way interactions between the treatment and baseline covariates in the mediator and outcome models.
- `cxm`: Includes all two-way interactions between the mediator(s) and baseline covariates in the outcome model.
- `reps(integer)`: Number of replications for bootstrap resampling (default is 200).
- `strata(varname)`: Identifies resampling strata for bootstrap samples.
- `cluster(varname)`: Identifies resampling clusters for bootstrap sampling.
- `level(cilevel)`: Confidence level for constructing bootstrap confidence intervals (default is 95%).
- `seed(passthru)`: Seed for bootstrap resampling to enable replicable results.
- `detail`: Prints the fitted models used to construct the effect estimates.

## Description

This command performs causal mediation analysis using linear models for both the mediator(s) and outcome.

When a single mediator is specified, it estimates total, natural direct, and natural indirect effects using two linear models: a model for the mediator conditional on treatment and baseline covariates after centering them around their sample means, and a model for the outcome conditional on treatment, the mediator, and the baseline covariates after centering them around their sample means.

When multiple mediators are specified, it provides estimates for the total effect and then for the multivariate natural direct and indirect effects operating through the entire set of mediators considered together. To this end, it fits separate models for each mediator conditional on treatment and the baseline covariates after centering them around their sample means, and then a model for the outcome conditional on treatment, all the mediators, and the baseline covariates after centering them around their sample means.

## Examples

```stata
// Load data
use nlsy79.dta

// Single mediator, no treatment-mediator interaction, percentile bootstrap CIs with default settings
linmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) nointer reps(1000)

// Single mediator, treatment-mediator interaction, percentile bootstrap CIs with default settings
linmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) reps(1000)

// Single mediator, all two-way interactions with treatment and the mediator, percentile bootstrap CIs
linmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) cxd cxm reps(1000)

// Multiple mediators, treatment-mediator interactions, percentile bootstrap CIs with default settings
linmed std_cesd_age40 ever_unemp_age3539 log_faminc_adj_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) reps(1000)

```

## Saved Results

`linmed` saves the following results in `e()`:

- **Matrices**:
  - `e(b)`: Matrix containing total, direct, and indirect effect estimates.

## Author

Geoffrey T. Wodtke  
Department of Sociology  
University of Chicago

Email: [wodtke@uchicago.edu](mailto:wodtke@uchicago.edu)

## References

- Wodtke, Geoffrey T. and Xiang Zhou. Causal Mediation Analysis. In preparation.

## Also See

- Help: regress, bootstrap

```
