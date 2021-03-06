#######################################################################
# data in json generation for D3 for examples from:
# https://pbiecek.github.io/ceterisParibus/articles/ceteris_paribus.html (Ceteris Paribus Plots)


library("DALEX")
library("randomForest")
library("ceterisParibus")
library(dplyr)
library(jsonlite)
set.seed(59)

path <- 'C:\\Users\\Ewa\\Desktop\\INTERACTIVE XAI FOR DALEX\\3. (October) - adding more layers\\pakiet JS dla ceterisParibus\\ceterisParibusExt\\ceterisParibusD3\\examples\\'

createJSONsWithData <- function(numer, dfl){
  
  all_profiles <- do.call(rbind, dfl)
  class(all_profiles) <- "data.frame"
  
  all_observations <- lapply(dfl, function(tmp) {
    attr(tmp, "observations")$`_ids_` <- rownames(attr(tmp, "observations"))
    attr(tmp, "observations")
  })
  
  all_observations <- do.call(rbind, all_observations)
  
  # saving ceteris_paribus output dataframe as JS object to js file
  write(x = paste0('example' , numer, ' = ', as.character(toJSON(all_profiles, pretty = TRUE, factor = 'string', null ='null', na = 'null'))),
        file = paste0(path, 'example', numer, '.js'))
  
  
  write(x = paste0('example_obs', numer, ' = ', as.character(toJSON( all_observations, pretty = TRUE, factor = 'string', null ='null', na = 'null'))),
        file = paste0(path, 'example_obs', numer, '.js'))
}

# set default theme
theme_set(theme_bw() + theme(text = element_text(size = 18)))


############### example 1

numer <- 1

### A) in R

apartments_rf_model <- randomForest(m2.price ~ construction.year + surface + floor +
                                      no.rooms + district, 
                                    data = apartments)


explainer_rf <- explain(apartments_rf_model,
                        data = apartmentsTest[,2:6], 
                        y = apartmentsTest$m2.price)

apartments_A <- apartmentsTest[958,]

cp_rf_A <- ceteris_paribus(explainer_rf, apartments_A, y = apartments_A$m2.price)


plot(cp_rf_A, show_profiles = TRUE, show_observations = TRUE, 
     selected_variables = c("surface","construction.year"))

### B) prepare data as JSONs

dfl <- c(list(cp_rf_A))     #c(list(cp_rf), list(cp_lm))
createJSONsWithData(numer = numer, dfl = dfl)


############### example 2

numer <- 2

### A) in R

apartments_B <- select_neighbours(apartmentsTest, apartmentsTest[958,], n = 15)
cp_rf_B <- ceteris_paribus(explainer_rf, apartments_B, y = apartments_B$m2.price)

plot(cp_rf_B, 
     show_profiles = TRUE, show_observations = TRUE, show_rugs = TRUE,
     selected_variables = c("surface","construction.year"))

### B) prepare data as JSONs
dfl <- c(list(cp_rf_B))
createJSONsWithData(numer = numer, dfl = dfl)

############### example 3

numer <- 3

### A) in R

apartments_C <- select_sample(apartmentsTest, n = 15)
cp_rf_C <- ceteris_paribus(explainer_rf, apartments_C, y = apartments_C$m2.price)

plot(cp_rf_C, 
     show_profiles = FALSE, 
     selected_variables = c("surface","construction.year"))

### B) prepare data as JSONs
dfl <- c(list(cp_rf_C))
createJSONsWithData(numer = numer, dfl = dfl)


############### example 4

numer <- 4

### A) in R

apartments_C <- select_sample(apartmentsTest, n = 15)
cp_rf_C <- ceteris_paribus(explainer_rf, apartments_C, y = apartments_C$m2.price)

plot(cp_rf_C, 
     show_profiles = FALSE, show_observations = FALSE, show_rugs = TRUE, 
     selected_variables = c("surface","construction.year"))

### B) prepare data as JSONs
dfl <- c(list(cp_rf_C))
createJSONsWithData(numer = numer, dfl = dfl)

############### example 5

numer <- 5

### A) in R

apartments_C <- select_sample(apartmentsTest, n = 15)
cp_rf_C <- ceteris_paribus(explainer_rf, apartments_C, y = apartments_C$m2.price)

plot(cp_rf_C, 
     show_profiles = TRUE, show_observations = FALSE, 
     selected_variables = c("surface","construction.year")) 

### B) prepare data as JSONs
dfl <- c(list(cp_rf_C))
createJSONsWithData(numer = numer, dfl = dfl)

############### example 6

numer <- 6

### A) in R

apartments_C <- select_sample(apartmentsTest, n = 15)
cp_rf_C <- ceteris_paribus(explainer_rf, apartments_C, y = apartments_C$m2.price)

plot(cp_rf_C, 
     show_profiles = FALSE, show_observations = FALSE, show_residuals = TRUE, 
     selected_variables = c("surface","construction.year"))

### B) prepare data as JSONs
dfl <- c(list(cp_rf_C))
createJSONsWithData(numer = numer, dfl = dfl)

############### example 7

numer <- 7

### A) in R

apartments_C <- select_sample(apartmentsTest, n = 15)
cp_rf_C <- ceteris_paribus(explainer_rf, apartments_C, y = apartments_C$m2.price)

plot(cp_rf_C, 
     show_profiles = TRUE, show_observations = FALSE, 
     aggregate_profiles = mean, size = 2,
     selected_variables = c("surface","construction.year"))

### B) prepare data as JSONs
dfl <- c(list(cp_rf_C))
createJSONsWithData(numer = numer, dfl = dfl)

############### example 8

numer <- 8

### A) in R

apartments_C <- select_sample(apartmentsTest, n = 15)
cp_rf_C <- ceteris_paribus(explainer_rf, apartments_C, y = apartments_C$m2.price)

plot(cp_rf_C, 
     show_profiles = TRUE, show_observations = FALSE, 
     color = "district", alpha = 1,
     selected_variables = c("surface","construction.year", "district", 'no.rooms', 'floor')) 

unique(cp_rf_C$`_vname_`)

### B) prepare data as JSONs
dfl <- c(list(cp_rf_C))
createJSONsWithData(numer = numer, dfl = dfl)


############### example 9

numer <- 9

### A) in R

apartments_C <- select_sample(apartmentsTest, n = 15)
cp_rf_C <- ceteris_paribus(explainer_rf, apartments_C, y = apartments_C$m2.price)

plot(cp_rf_C, 
     show_profiles = TRUE, show_observations = TRUE, 
     color = "surface", alpha = 1, 
     selected_variables = c("surface","construction.year")) 

### B) prepare data as JSONs
dfl <- c(list(cp_rf_C))
createJSONsWithData(numer = numer, dfl = dfl)

############### example 10

numer <- 10

### A) in R

apartments_C <- select_sample(apartmentsTest, n = 15)
cp_rf_C <- ceteris_paribus(explainer_rf, apartments_C, y = apartments_C$m2.price)

plot(cp_rf_C, 
     show_profiles = TRUE, show_observations = TRUE, 
     selected_variables = c("surface","construction.year"))

### B) prepare data as JSONs
dfl <- c(list(cp_rf_C))
createJSONsWithData(numer = numer, dfl = dfl)

############### example 11

numer <- 11

### A) in R

apartments_C <- select_sample(apartmentsTest, n = 15)
cp_rf_C <- ceteris_paribus(explainer_rf, apartments_C, y = apartments_C$m2.price)

plot(cp_rf_C, 
     show_profiles = TRUE, show_observations = TRUE, show_rugs = TRUE,
     show_residuals = TRUE, 
     color = "blue", color_points = "orange", color_residuals = "red", color_rugs = "green",
     alpha = 0.3, alpha_points = 0.3, alpha_residuals = 0.5, alpha_rugs = 1,
     size_points = 4, size_rugs = 0.5,
     selected_variables = c("surface","construction.year"))

### B) prepare data as JSONs
dfl <- c(list(cp_rf_C))
createJSONsWithData(numer = numer, dfl = dfl)

############### example 12

numer <- 12

### A) in R

apartments_C <- select_sample(apartmentsTest, n = 15)
cp_rf_C <- ceteris_paribus(explainer_rf, apartments_C, y = apartments_C$m2.price)

plot(cp_rf_C, 
     show_observations = FALSE, show_rugs = TRUE,
     show_residuals = TRUE, color_residuals = "red", size_residuals = 2,
     selected_variables = c("surface","construction.year")) +
  ceteris_paribus_layer(cp_rf_C, 
                        show_observations = FALSE, show_rugs = FALSE,
                        aggregate_profiles = mean, size = 2, alpha = 1,
                        selected_variables = c("surface","construction.year")) 

### B) prepare data as JSONs
dfl <- c(list(cp_rf_C))
createJSONsWithData(numer = numer, dfl = dfl)

############### example 13

numer <- 13

### A) in R

apartments_D <- select_neighbours(apartmentsTest, apartmentsTest[348,], n = 15)
cp_rf_D <- ceteris_paribus(explainer_rf, apartments_D, y = apartments_D$m2.price)

plot(cp_rf_B, 
     show_observations = FALSE, show_residuals = TRUE, 
     color_residuals = "blue",
     selected_variables = c("surface","construction.year")) +
  ceteris_paribus_layer(cp_rf_D, 
                        show_observations = FALSE, show_residuals = TRUE, 
                        color = "orange", color_residuals = "red",
                        selected_variables = c("surface","construction.year")) 

### B) prepare data as JSONs
dfl <- c(list(cp_rf_B), list(cp_rf_D))
createJSONsWithData(numer = numer, dfl = dfl)


############### example 14

numer <- 14

### A) in R

library("rpart")
library("e1071")
apartments_svm_model <- svm(m2.price ~ construction.year + surface + floor + 
                              no.rooms + district, data = apartments)

apartments_rpart_model <- best.rpart(m2.price ~ construction.year + surface + floor + no.rooms + district, data = apartments)

explainer_svm <- explain(apartments_svm_model, 
                         data = apartmentsTest[,2:6], y = apartmentsTest$m2.price)

explainer_rpart <- explain(apartments_rpart_model, 
                           data = apartmentsTest[,2:6], y = apartmentsTest$m2.price)

apartments_E <- apartmentsTest[958,]
cp_rf_E <- ceteris_paribus(explainer_svm, apartments_E, y = apartments_E$m2.price)

apartments_F <- apartmentsTest[958,]
cp_rpart_F <- ceteris_paribus(explainer_rpart, apartments_F, y = apartments_F$m2.price)

plot(cp_rf_A, 
     show_observations = FALSE, show_rugs = TRUE, show_residuals = TRUE, 
     color_residuals = "blue",
     selected_variables = c("surface","construction.year")) +
  ceteris_paribus_layer(cp_rf_E, 
                        show_observations = FALSE, show_rugs = TRUE, show_residuals = TRUE, 
                        color = "orange", color_residuals = "red",
                        selected_variables = c("surface","construction.year"))

### B) prepare data as JSONs
dfl <- c(list(cp_rf_A), list(cp_rf_E))
createJSONsWithData(numer = numer, dfl = dfl)


############### example 15

numer <- 15

### A) in R

plot(cp_rf_A, cp_rf_E, cp_rpart_F,
     color = "_label_", 
     selected_variables = c("surface","construction.year"))

### B) prepare data as JSONs
dfl <- c(list(cp_rf_A), list(cp_rf_E), list(cp_rpart_F))
createJSONsWithData(numer = numer, dfl = dfl)

############### example 16

numer <- 16

### A) in R

apartments_A <- apartmentsTest[2,]
cp_rf_A <- ceteris_paribus(explainer_rf, apartments_A, y = apartments_A$m2.price)

plot(cp_rf_A,
     alpha = 0.5, size_points = 4, 
     selected_variables = "surface", 
     as.gg = TRUE) + xlab("") + ylab("price [EUR]") + theme_light()

### B) prepare data as JSONs
dfl <- c(list(cp_rf_A))
createJSONsWithData(numer = numer, dfl = dfl)

############### example 17

numer <- 17

### A) in R

apartments_B <- select_neighbours(apartmentsTest, apartments[1,], n = 10)
cp_rf_B <- ceteris_paribus(explainer_rf, apartments_B, y = apartments_B$m2.price)

plot(cp_rf_B, 
     show_rugs = TRUE, show_residuals = TRUE,
     selected_variables = "surface", color_residuals = "red", size = 0.5,
     as.gg = TRUE) + xlab("") + ylab("price [EUR]") + theme_light() 

### B) prepare data as JSONs
dfl <- c(list(cp_rf_B))
createJSONsWithData(numer = numer, dfl = dfl)

############### example 18

numer <- 18

### A) in R

apartments_C <- select_sample(apartmentsTest, n = 15)
cp_rf_C <- ceteris_paribus(explainer_rf, apartments_C, y = apartments_C$m2.price)

plot(cp_rf_C, 
     show_observations = TRUE, show_rugs = TRUE, size = 0.3, size_points = 0.5,
     selected_variables = "surface") +
  ceteris_paribus_layer(cp_rf_C, 
                        show_observations = FALSE, 
                        aggregate_profiles = mean, size = 2, alpha = 1,
                        selected_variables = "surface",
                        as.gg = TRUE) + xlab("") + ylab("price [EUR]") + theme_light() 

### B) prepare data as JSONs
dfl <- c(list(cp_rf_C))
createJSONsWithData(numer = numer, dfl = dfl)

############### example 19

numer <- 19

### A) in R
 
apartments_D <- select_neighbours(apartmentsTest, apartmentsTest[348,], n = 15)
cp_rf_D <- ceteris_paribus(explainer_rf, apartments_D, y = apartments_D$m2.price)

plot(cp_rf_B, 
     show_observations = FALSE, show_residuals = TRUE, 
     color_residuals = "blue", alpha = 0.5, size = 0.5, 
     selected_variables = "surface") +
  ceteris_paribus_layer(cp_rf_D, 
                        show_observations = FALSE, show_residuals = TRUE, 
                        color = "orange", color_residuals = "red", alpha = 0.5, size = 0.5,
                        selected_variables = "surface", 
                        as.gg = TRUE) + xlab("") +  theme_light() + ylab("price [EUR]")

### B) prepare data as JSONs
dfl <- c(list(cp_rf_B), list(cp_rf_D))
createJSONsWithData(numer = numer, dfl = dfl)

############### example 20

numer <- 20

### A) in R

plot(cp_rf_A, cp_rf_E, cp_rpart_F,
     color = "_label_", alpha = 0.5, size_points = 4, 
     selected_variables = "surface", 
     as.gg = TRUE) + xlab("") + ylab("price [EUR]") + theme_light() + scale_color_discrete(name="")

### B) prepare data as JSONs
dfl <- c(list(cp_rf_A), list(cp_rf_E), list(cp_rpart_F))
createJSONsWithData(numer = numer, dfl = dfl)

############### example 21

numer <- 21

### A) in R

cp_rf_C_part <- cp_rf_C[as.numeric(cp_rf_C$district) < 8,]

plot(cp_rf_C_part, 
     show_profiles = TRUE, show_observations = FALSE, 
     color = "district", alpha = 1,
     selected_variables = c("surface", "district"), 
     as.gg = TRUE) + xlab("") + ylab("price [EUR]") + theme_light() 

### B) prepare data as JSONs
dfl <- c(list(cp_rf_C_part))
createJSONsWithData(numer = numer, dfl = dfl)

############### example 22

numer <- 22

### A) in R

plot(cp_rf_A,
     alpha = 0.5, size_points = 4, 
     as.gg = TRUE) + xlab("") + ylab("price [EUR]") + theme_light()

### B) prepare data as JSONs
dfl <- c(list(cp_rf_A))
createJSONsWithData(numer = numer, dfl = dfl)


############## example 23 (mine) categorical

apartments$floor <- as.factor(apartments$floor)
apartments$no.rooms <- as.factor(apartments$no.rooms)

apartmentsTest$floor <- as.factor(apartmentsTest$floor)
apartmentsTest$no.rooms <- as.factor(apartmentsTest$no.rooms)

apartments_rf_model <- randomForest(m2.price ~ construction.year + surface + floor +
                                      no.rooms + district, 
                                    data = apartments)


explainer_rf <- explain(apartments_rf_model,
                        data = apartmentsTest[,2:6], 
                        y = apartmentsTest$m2.price)

apartments_A <- apartmentsTest[c(948),]


cp_rf_A <- ceteris_paribus(explainer_rf, apartments_A, y = apartments_A$m2.price)


plot(cp_rf_A, show_profiles = T, show_residuals = F, aggregate_profiles = 'mean', only_numerical = F, show_observations = F)

cp_rf_A

unique(apartments$district)







