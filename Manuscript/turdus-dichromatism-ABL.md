---
title: "Ecological conditions favoring species recognition and rapid mate pairing are associated with greater plumage sexual dichromatism in true thrushes (genus: *Turdus*)"
author: "Alec B. Luro^1^<sup>*</sup>, Mark E. Hauber^1^"
date: "^1^ Department of Evolution, Ecology and Behavior, School of Integrative Biology, University of Illinois at Urbana-Champaign <br> <sup>*</sup>alec.b.luro@mail.com </br>"
csl: Manuscript/proceedings-of-the-royal-society-b.csl
bibliography: Manuscript/Turdus-Dichromatism.bib
header-includes:
  - \usepackage[left]{lineno}
  - \linenumbers
  - \usepackage{graphicx}
  - \usepackage{booktabs}
link-citations: true
linkcolor: blue
output:
    pdf_document:
    word_document:
citecolor: blue
mainfont: Lato
---

# Abstract

## Keywords

# Background

# Methods

## *Plumage sexual dichromatism*


A total of N=77 *Turdus* thrush species were sampled for plumage spectral
reflectance using from bird skins at the American Museum of Natural History in
New York City and the Field Museum in Chicago. Reflectance measurements from
300-700nm were taken in triplicate for the belly, breast, throat, crown and
mantle plumage patches [@anderssonQuantifyingColors2006] of each individual bird
skin. N=3 male and N=3 female individuals were measured for most species
(exceptions: *Turdus lawrencii*, N=2 males and N=2 females; *Turdus swalesi*,
N=1 male and N=1 female). Reflectance spectra were measured using a 400 μm fiber
optic reflection probe fitted with a rubber stopper to maintain a consistent
measuring distance of 3 mm and area of 2 mm<sup>2</sup> at a 90° angle to the
surface of the feather patch. Measurements were taken using a JAZ spectrometer
with a pulsed-xenon light source (Ocean Optics, Dunedin, USA) and all
measurements were made relative to a diffuse reflectance white standard
(Spectralon WS-1-SL, Labsphere, North Sutton NH, USA).

We used a receptor-noise limited visual model
[@vorobyevReceptorNoiseDeterminant1998] of the European Blackbird (*Turdus
merula*) visual system [@hartVisualPigmentsOil2000] in the *pavo*
[@maiaPavoNewTools2019, p. 2]⁠ package in R v4.0.0
[@rcoreteamLanguageEnvironmentStatistical2020]⁠ to calculate avian-perceived
chromatic and achromatic visual contrast (in units of “Just-Noticeable
Differences”,or JNDs) of male vs. female plumage patches for all sampled
*Turdus* species. Chromatic and achromatic JNDs were calculated for male-female
pairs within each species (i.e., N=9 JND values calculated per patch for each
species where N=3 males and N=3 females sampled), and then JND values were
averaged for each species’ respective plumage patches. Under ideal laboratory
conditions, a JND value of 1 is generally considered to be the discriminable
threshold past which an observer is predicted to be able to perceive the two
colors as different. However, natural light environments vary both spatially and
temporally [@endlerColorLightForests1993]⁠, bringing into question the accuracy
of a JND=1 threshold for generalizing visual contrast under natural conditions.
Therefore, we calculated the total number of sexually-dichromatic plumage
patches per species (out of N=5 measured patches) as the number of plumage
patches with average JND values > 1, 2, or 3 to account for uncertainty in
visual discrimination thresholds due to variation in psychophysical and ambient
lighting conditions affecting the strength of between-sex plumage visual
contrast [@kempIntegrativeFrameworkAppraisal2015]⁠.

## *Life History Data*

### *Breeding Timing Model*

We collected data on migration behavior and breeding season length from
*Thrushes* [@clementThrushes2000] and the *Handbook of the Birds of the World*
[@delhoyoHandbookBirdsWorld2017]⁠. We assigned three different kinds of
migratory behavior: 1) *full migration* when a species description clearly
stated that a species "migrates", 2) *partial migration* when a species was
described to have "altitudinal migration", "latitudinal migration" or "movement
during non-breeding season", or 3) *sedentary* when when a species was described
as "resident" or "sedentary". Breeding season length was defined as the number
of months the species breeds.

### *Breeding Sympatry Model*

Species’ breeding ranges were acquired from *BirdLife International*
[@birdlifeinternationalandhandbookofthebirdsoftheworldBirdSpeciesDistribution2018]⁠.
We calculated congener breeding range overlaps (as percentages) using the
*letsR* package in R [@vilelaLetsRNewPackage2015]⁠. We then calculated the
number of sympatric species as the number of congeners with breeding ranges that
overlap >30% with the focal species’ breeding range
[@cooneySexualSelectionSpeciation2017].

### *Breeding Spacing Model*

Species’ breeding range sizes (in km<sup>2</sup>) were acquired using the
*BirdLife International* breeding range maps. Species’ island vs. mainland
residence was also determined using breeding ranges from *BirdLife
International*. Mainland residence was assigned if the species had a breeding
range on any continent and Japan. Island residence was assigned to species
having a breeding range limited to a non-continental landmass entirely
surrounded by an oceanic body of water.

## *Statistical Modeling*

We used phylogenetically-corrected Bayesian multilevel logistic regression
models using the *brms* v2.13.0 package [@burknerBrmsPackageBayesian2017] in R
v4.0.0 [@rcoreteamLanguageEnvironmentStatistical2020]⁠ where responses, the
number of sexually-dichromatic patches >1, 2, and 3 chromatic and achromatic
JNDs, were modeled as binomial trials (N=5 plumage patch “trials”) to test for
associations with breeding timing, breeding sympatry and breeding spacing. For
all phylogenetically-corrected models, we used the *Turdus* phylogeny from
Nylander et al. (2008) [@nylanderAccountingPhylogeneticUncertainty2008]to create
a covariance matrix of species’ phylogenetic relationships. All models used a
dataset of N=67 *Turdus* species for which all data were available.

Our *breeding timing* models included the following predictors: z-scores of
breeding season length (mean centered and divided by one standard deviation),
migratory behavior (full migration as the reference category versus partial
migration or sedentary), and their interaction. *Breeding sympatry* models
included the number of sympatric species with greater than 30% breeding range
overlap as the only predictor of the number of sexually-dichromatic plumage
patches. *Breeding spacing* models included log<sub>e</sub> transformed breeding
range size (km<sup>2</sup>) and breeding landmass (mainland as the reference
category versus island). We also ran null models (intercept only) for all
responses. All models’ intercepts and response standard deviations were assigned
a weak prior (Student T: df = 3, location = 0, scale = 10), and predictor
coefficients were assigned flat priors. We ran each model for 6,000 iterations
across 6 chains and assessed Markov Chain Monte Carlo (MCMC) convergence using
the Gelman-Rubin diagnostic (Rhat) [@gelmanBayesianDataAnalysis2013]. We then
performed k-fold cross-validation [@vehtariPracticalBayesianModel2017] to refit
each model *K*=16 times. For each k-fold, the training dataset included a
randomly selected set of(N - N cdot left( frac{1}{K} right))or N≈63 species, and
the testing dataset included (N cdot frac{1}{K}) or N≈4 species not included in
the training dataset. Finally, we compared differences between the models’
expected log pointwise predictive densities (ELPD) to assess which model(s) best
predicted the number of sexually-dichromatic plumage patches
[@vehtariPracticalBayesianModel2017]⁠.

# Results

We obtained N ≥ 4000 effective samples for each model parameter and all models’
Markov Chains (MCMC) successfully converged (Rhat = 1 for all models’
parameters).

*Table 1: Expected log pointwise predictive densities (ELPD) differences and
kfold information criterion values of models.*

\begin{table}
\centering\begingroup\fontsize{18}{20}\selectfont

\resizebox{\linewidth}{!}{
\begin{tabular}{llllll}
\toprule
\multicolumn{1}{l}{} & \multicolumn{1}{l}{} & \multicolumn{4}{l}{Model} \\
\cmidrule(l{3pt}r{3pt}){3-6}
\textbf{Plumage Metric} & \textbf{JND Threshold} & \textbf{Breeding Sympatry} & \textbf{Breeding Timing} & \textbf{Breeding Spacing} & \textbf{Intercept Only}\\
\midrule
\addlinespace[0.3em]
\multicolumn{6}{l}{\textbf{Achromatic}}\\
\hspace{1em} & 1 JND & 0 ± 0 (-122.17 ± 0.67) & -2.51 ± 2.49 (-124.68 ± 2.38) & -2.59 ± 1.01 (-124.76 ± 1.04) & -21.69 ± 7.36 (-143.87 ± 7.51)\\
\hspace{1em} & 2 JND & 0 ± 0 (-98.94 ± 7.56) & -1.19 ± 3.95 (-100.13 ± 9.22) & -0.7 ± 1.34 (-99.64 ± 7.92) & -52.42 ± 12.67 (-151.36 ± 13.4)\\
\hspace{1em} & 3 JND & -0.04 ± 1.4 (-85.4 ± 8.91) & -1.7 ± 4.41 (-87.07 ± 10.71) & 0 ± 0 (-85.37 ± 8.76) & -28.54 ± 10.02 (-113.91 ± 13.65)\\
\midrule
\addlinespace[0.3em]
\multicolumn{6}{l}{\textbf{Chromatic}}\\
\hspace{1em} & 1 JND & 0 ± 0 (-115.75 ± 2.95) & -5.67 ± 3.55 (-121.42 ± 2.28) & -2.73 ± 3.4 (-118.49 ± 2.67) & -14.8 ± 7.22 (-130.55 ± 7.05)\\
\hspace{1em} & 2 JND & 0 ± 0 (-88.47 ± 8.77) & -3.8 ± 4.46 (-92.27 ± 10.01) & -3.32 ± 5.29 (-91.79 ± 10.91) & -50.53 ± 14.49 (-139 ± 16.77)\\
\hspace{1em} & 3 JND & 0 ± 0 (-62.77 ± 10.41) & -8 ± 4.32 (-70.77 ± 12.29) & -4.43 ± 3.9 (-67.2 ± 11.72) & -47.63 ± 15.34 (-110.4 ± 20.01)\\
\bottomrule
\end{tabular}}
\endgroup{}
\end{table}

*Table 2: Model predictor effect estimates (posterior median log-odds) on the
number of achromatic and chromatic plumage patches with visual contrast values >
1, 2, and 3 JND. Model effects with a probability of direction (pd) value ≥*

*0.90 are bolded in red for a negative effect and blue for a positive effect on
plumage dichromatism.*

# Discussion

# Conclusions

# Acknowledgements

# References
