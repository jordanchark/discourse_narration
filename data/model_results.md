# Model results

  ## Decrease in tail-linking

> summary(model2)
Generalized linear mixed model fit by maximum likelihood (Laplace Approximation) ['glmerMod']
 Family: binomial  ( logit )
Formula: cbind(successes, failures) ~ scaled_Year + Genre + (1 | Text)
   Data: filtered_data
Control: glmerControl(optimizer = "bobyqa")

     AIC      BIC   logLik deviance df.resid 
   245.2    253.0   -116.6    233.2       21 

Scaled residuals: 
     Min       1Q   Median       3Q      Max 
-0.90819 -0.25253 -0.01639  0.12613  0.88548 

Random effects:
 Groups Name        Variance Std.Dev.
 Text   (Intercept) 0.1545   0.3931  
Number of obs: 27, groups:  Text, 27

Fixed effects:
            Estimate Std. Error z value Pr(>|z|)  
(Intercept)  -0.2083     0.2135  -0.976   0.3293  
scaled_Year  -0.3640     0.2336  -1.558   0.1192  
Genrenar     -0.4921     0.2452  -2.007   0.0448 *
Genrerel     -0.1728     0.2556  -0.676   0.4990  
Genresci      0.4472     0.5654   0.791   0.4291  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Correlation of Fixed Effects:
            (Intr) scld_Y Genrnr Genrrl
scaled_Year -0.389                     
Genrenar    -0.593 -0.375              
Genrerel    -0.772  0.161  0.557       
Genresci    -0.225 -0.246  0.371  0.228


  ## Increase in temporal subordinate clauses

model_rf <- lm(relative_frequency ~ scaled_Year, 
+                data = filtered_ts_nar2)
> model_rf

Call:
lm(formula = relative_frequency ~ scaled_Year, data = filtered_ts_nar2)

Coefficients:
(Intercept)  scaled_Year  
     25.215        8.181  

> model_rf_int <- lm(relative_frequency ~ 1, 
+                    data = filtered_ts_nar2)
> model_rf_int

Call:
lm(formula = relative_frequency ~ 1, data = filtered_ts_nar2)

Coefficients:
(Intercept)  
      25.21  

> anova(model_rf_int, model_rf)
Analysis of Variance Table

Model 1: relative_frequency ~ 1
Model 2: relative_frequency ~ scaled_Year
  Res.Df   RSS Df Sum of Sq      F  Pr(>F)  
1     39 18105                              
2     38 15495  1    2610.1 6.4009 0.01567 *
