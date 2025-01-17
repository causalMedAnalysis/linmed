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
- `detail`: Prints the fitted models used to construct the effect estimates.
- `bootstrap_options`: All `bootstrap` options are available.

## Description

`linmed` performs causal mediation analysis using linear models for both the mediator(s) and outcome, and it
computes inferential statistics using the nonparametric bootstrap.

When a single mediator is specified, `linmed` estimates total, natural direct, and natural indirect effects using two linear models: a model for the mediator conditional on treatment and baseline covariates after centering them around their sample means, and a model for the outcome conditional on treatment, the mediator, and the baseline covariates after centering them around their sample means.

When multiple mediators are specified, `linmed` provides estimates for the total effect and then for the multivariate natural direct and indirect effects operating through the entire set of mediators considered together. To this end, it fits separate models for each mediator conditional on treatment and the baseline covariates after centering them around their sample means, and then a model for the outcome conditional on treatment, all the mediators, and the baseline covariates after centering them around their sample means.

`linmed` allows pweights, but it does not internally rescale them for use with the bootstrap. If using weights from a complex sample design that require rescaling to produce valid boostrap estimates, the user must be sure to appropriately specify the `strata`, `cluster`, and `size` options from the `bootstrap` command so that Nc-1 clusters are sampled within from each stratum, where Nc denotes the number of clusters per stratum. Failure to properly adjust the bootstrap sampling to account for a complex sample design that requires `pweights` could lead to invalid inferential statistics.

## Examples

```stata
// Load data
use nlsy79.dta

// Single mediator, no treatment-mediator interaction, percentile bootstrap CIs with default settings
linmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) nointer

// Single mediator, treatment-mediator interaction, percentile bootstrap CIs with 1000 replications
linmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) reps(1000)

// Single mediator, all two-way interactions with treatment and the mediator, percentile bootstrap CIs
linmed std_cesd_age40 ever_unemp_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) cxd cxm reps(1000)

// Multiple mediators, treatment-mediator interactions, percentile bootstrap CIs
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
