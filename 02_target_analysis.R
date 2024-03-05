# Final Project ----
# Target Variable Analysis

# load packages ----
library(tidyverse)
library(here)
library(skimr)
library(naniar)
library(janitor)


#load data
load(here("data/clean_qol.rda"))
load(here("results/estate_split.rda"))


#missingness qol
miss_table1 <- miss_var_summary(clean_qol)

miss_names1 <- miss_table1 |> 
  pull(variable)

clean_qol |> 
  select(miss_names1) |> 
  gg_miss_var()

#missingness qol - WITH TRAINING SET
miss_table2 <- miss_var_summary(estate_train) |> 
  filter(n_miss > 0)

miss_names2 <- miss_table2 |> 
  pull(variable)

estate_train |> 
  select(miss_names2) |> 
  gg_miss_var()

#mention these options in final report as potential other/future work
# PREVIOUS PLAN - USING quality_of_living AS TARGET VARIABLE ------
#density plot
realestate |> 
  filter(!is.na(quality_of_living)) |> 
  ggplot(aes(x = quality_of_living))+
  geom_density(color = "pink", fill = "pink", alpha = 0.5)+
  theme_minimal()+
  labs(title = "Density Plot of Quality of Living", x = "Quality of Living", y = NULL)+
  theme(plot.title = element_text(hjust = 0.5, size = 15, face = "bold"))

#barplot
clean_qol |> 
  ggplot(aes(x = quality_of_living))+
  geom_bar()+
  theme_minimal()+
  labs(x = "Quality of Living", y = "Number of Houses")

#barplot w ordered levels
clean_qol_lvls <- clean_qol |> 
  mutate(quality_of_living = fct_collapse(quality_of_living, 
                                          "4-10" = c("4", "5", "6", "7", "8", "9", "10"), 
                                          "27-51" = c("27", "37", "38", "44", "49", "51"), 
                                          "53-61" = c("53", "55", "57", "58", "59", "61"), 
                                          "62-69" = c("62", "63", "64", "65", "66", "67", '68', "69"), 
                                          "71-79" = c("71", "72", "73", "74", "75", "76", '77', '78', "79"), 
                                          "81-89" = c("81", "82", "83", "84", "85", "86", '87', '88', "89"), 
                                          "91-99" = c("91", "92", "93", "94", "95", "96", '97', '98', "99")))

qol_levels = c("4-10", "27-51", "53-61", "62-69", "71-79", "81-89", "91-99")

ggplot(clean_qol_lvls) +
  geom_bar(aes(x = factor(quality_of_living, levels = qol_levels)), 
           fill = "lightseagreen") +
  theme_minimal()+
  labs(x = "Quality of Living (on Index from 0-100)", y = "Number of Houses")




# NEW PLAN GOING FORWARD - using satisfaction AS TARGET VARIABLE------

#barplot of satisfaction

estate_train |> 
  ggplot(aes(x = satisfaction, fill = satisfaction))+
  geom_bar(show.legend = FALSE)+
  scale_fill_brewer(palette = "Pastel2")+
  theme_minimal()+
  labs(x = "Quality of Living", y = "Number of Apartments", 
       title = "Satisfaction with Apartments in Slovakia") +
  theme(plot.title = element_text(hjust = 0.5, size = 13, face = "bold"), 
        axis.text.x = element_text(hjust = 0.5, size = 10), 
        axis.title.x = element_text(hjust = 0.5, size = 11, face = "bold"), 
        axis.title.y = element_text(hjust = 0.5, size = 11, face = "bold"))

#80% of Training Dataset
training_sample <- estate_train |> 
  slice_sample(prop = 0.8)

training_sample |> 
  ggplot(aes(x = satisfaction, fill = satisfaction))+
  geom_bar(show.legend = FALSE)+
  scale_fill_brewer(palette = "Pastel2")+
  theme_minimal()+
  labs(x = "Quality of Living", y = "Number of Apartments", 
       title = "Satisfaction with Apartments in Slovakia") +
  theme(plot.title = element_text(hjust = 0.5, size = 13, face = "bold"), 
        axis.text.x = element_text(hjust = 0.5, size = 10), 
        axis.title.x = element_text(hjust = 0.5, size = 11, face = "bold"), 
        axis.title.y = element_text(hjust = 0.5, size = 11, face = "bold"))

