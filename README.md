# mrpath: Analysis of Path-Specific Effects using Parametric Multiply Robust Methods

## Overview

**mrpath** is a Stata module designed to estimate path-specific effects using parametric multiply robust methods. It provides estimates for the total effect and path-specific effects operating through multiple mediators in a causal sequence.

## Syntax

```stata
mrpath depvar mvars [if] [in], dvar(varname) d(real) dstar(real) cvars(varlist) [options]
```

### Required Arguments

- `depvar`: Specifies the outcome variable.
- `mvars`: Specifies the mediators in causal order, starting with the first in the hypothesized causal sequence and ending with the last. Up to 5 causally ordered mediators are allowed.
- `dvar(varname)`: Specifies the treatment (exposure) variable, which must be binary (0/1).
- `d(real)`: Specifies the reference level of treatment.
- `dstar(real)`: Specifies the alternative level of treatment. Together, (d - dstar) defines the treatment contrast of interest.

### Options

- `cvars(varlist)`: Specifies the list of baseline covariates to be included in the analysis. Categorical variables must be coded as dummy variables.
- `nointeraction`: Specifies whether treatment-mediator interactions are excluded from the outcome models. By default, interactions are included.
- `cxd`: Includes all two-way interactions between the treatment and baseline covariates in the outcome models.
- `cxm`: Includes all two-way interactions between the mediator(s) and baseline covariates in the outcome models.
- `censor`: Specifies that the inverse probability weights are censored at the 1st and 99th percentiles.
- `reps(integer)`: Specifies the number of bootstrap replications (default is 200).
- `seed(passthru)`: Specifies the seed for bootstrap resampling. If omitted, a random seed is used, and results cannot be replicated.
- `bootstrap_options`: All `bootstrap` options are available.

## Description

`mrpath` estimates path-specific effects using the type mr2 multiply robust estimator described in Chapter 6, Section 6.4, of Wodtke and Zhou's *Causal Mediation Analysis*.

If there are K causally ordered mediators, `mrpath` provides estimates for the total effect and then for K+1 path-specific effects: the direct effect of the exposure on the outcome that does not operate through any of the mediators, and then a separate path-specific effect operating through each of the K mediators, net of the mediators that precede it in causal order. If only a single mediator is specified, `mrpath` computes and reports multiply robust estimates of conventional natural direct and indirect effects through a univariate mediator.

## Examples

### Example 1: Percentile bootstrap CIs with K=2 causally ordered mediators and censored weights

```stata
. use nlsy79.dta
. mrpath std_cesd_age40 ever_unemp_age3539 log_faminc_adj_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) censor reps(1000)
```

### Example 2: Percentile bootstrap CIs with K=3 causally ordered mediators and censored weights

```stata
. mrpath std_cesd_age40 cesd_1992 ever_unemp_age3539 log_faminc_adj_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) censor reps(1000)
```

### Example 3: Percentile bootstrap CIs with K=2 causally ordered mediators and all two-way interactions

```stata
. mrpath std_cesd_age40 ever_unemp_age3539 log_faminc_adj_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) cxd cxm censor reps(1000)
```

## Saved Results

The following results are saved in `e()`:

- **Matrices:**
  - `e(b)`: Matrix containing the total and path-specific effect estimates.

## Author

**Geoffrey T. Wodtke**  
Department of Sociology  
University of Chicago  
Email: [wodtke@uchicago.edu](mailto:wodtke@uchicago.edu)

## References

- Wodtke, GT and X Zhou. *Causal Mediation Analysis*. In preparation.

## See Also

- Stata manual: [regress](https://www.stata.com/manuals/rregress.pdf), [logit](https://www.stata.com/manuals/rlogit.pdf), [bootstrap](https://www.stata.com/manuals/rbootstrap.pdf)
