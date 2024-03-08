# Final Project ----
# EDA

# load packages ----
library(tidyverse)
library(here)
library(skimr)
library(naniar)
library(janitor)


#load data
load(here("data/clean_qol.rda"))
load(here("results/estate_split.rda"))
load(here("results/training_sample.rda"))

#interaction between price and environment -------
#shows difference in satisfaction by price levels for different environmental ranking ranges
training_sample |> 
  mutate(
    environment = case_when(
      environment >= 66 & environment <= 99 ~ "66-99",
      environment >= 35 & environment <= 66 ~ "35-66",
      environment >= 4 & environment <= 35 ~ "4-35",
      NA ~ "unknown"
    ), 
    environment = factor(environment, levels = c("4-35", "35-66", "66-99"))) |> 
  ggplot(aes(x = satisfaction, y = log10(price), fill = satisfaction))+
  geom_col(show.legend = FALSE)+
  scale_fill_brewer(palette = "Pastel2")+
  facet_wrap(~environment)+
  theme_linedraw()+
  labs(x = "Satisfaction", y = "Price (Log 10 Scale)", 
       title = "Satisfaction and Price for different Environmental Ranking Ranges") +
  theme(plot.title = element_text(hjust = 0.5, size = 10, face = "bold"), 
        axis.text.x = element_text(hjust = 0.5, size = 8), 
        axis.title.x = element_text(hjust = 0.5, size = 10, face = "bold"), 
        axis.title.y = element_text(hjust = 0.5, size = 10, face = "bold"))




#interaction between price and relax ------
training_sample |> 
  mutate(
    relax = case_when(
      relax >= 64 & relax <= 95 ~ "64-95",
      relax >= 33 & relax <= 64 ~ "33-64",
      relax >= 2 & relax <= 33 ~ "2-33",
      NA ~ "unknown"
    ), 
    relax = factor(relax)) |> 
  ggplot(aes(x = satisfaction, y = log10(price), fill = satisfaction))+
  scale_fill_brewer(palette = "Pastel2")+
  geom_col(show.legend = FALSE)+
  facet_wrap(~relax)+
  theme_linedraw()+
  labs(x = "Satisfaction", y = "Price (Log 10 Scale)", 
       title = "Satisfaction and Price for different Relaxation Ranking Ranges") +
  theme(plot.title = element_text(hjust = 0.5, size = 10, face = "bold"), 
        axis.text.x = element_text(hjust = 0.5, size = 8), 
        axis.title.x = element_text(hjust = 0.5, size = 10, face = "bold"), 
        axis.title.y = element_text(hjust = 0.5, size = 10, face = "bold"))



#interaction between price and services ------
training_sample |> 
  mutate(
    services = case_when(
      services >= 66 & services <= 99 ~ "66-99",
      services >= 34 & services <= 66 ~ "34-66",
      services >= 2 & services <= 34 ~ "2-34",
      NA ~ "unknown"
    ), 
    services = factor(services)) |> 
  ggplot(aes(x = satisfaction, y = log10(price), fill = satisfaction))+
  scale_fill_brewer(palette = "Pastel2")+
  geom_col(show.legend = FALSE)+
  facet_wrap(~services)+
  theme_linedraw()+
  labs(x = "Satisfaction", y = "Price (Log 10 Scale)", 
       title = "Satisfaction and Price for different Services Ranking Ranges") +
  theme(plot.title = element_text(hjust = 0.5, size = 10, face = "bold"), 
        axis.text.x = element_text(hjust = 0.5, size = 8), 
        axis.title.x = element_text(hjust = 0.5, size = 10, face = "bold"), 
        axis.title.y = element_text(hjust = 0.5, size = 10, face = "bold"))





#interaction between services and transport ------
training_sample |> 
  mutate(
    transport = case_when(
      transport >= 66 & transport <= 98 ~ "66-98",
      transport >= 34 & transport <= 66 ~ "34-66",
      transport >= 2 & transport <= 34 ~ "2-34",
      NA ~ "unknown"
    ), 
    transport = factor(transport)) |> 
  ggplot(aes(x = satisfaction, y = services, fill = satisfaction))+
  geom_col(show.legend = FALSE)+
  scale_fill_brewer(palette = "Pastel2")+
  facet_wrap(~transport)+
  theme_linedraw()+
  labs(x = "Satisfaction", y = "Services", 
       title = "Services by Satisfaction for different Transportation Range Rankings") +
  theme(plot.title = element_text(hjust = 0.5, size = 10, face = "bold"), 
        axis.text.x = element_text(hjust = 0.5, size = 8), 
        axis.title.x = element_text(hjust = 0.5, size = 10, face = "bold"), 
        axis.title.y = element_text(hjust = 0.5, size = 10, face = "bold"))






#interaction between environment and safety -----
#distribution of safety by environment range ranking is different for people who were satisfied versus not
training_sample |> 
  mutate(
    environment = case_when(
      environment >= 80 & environment <= 99 ~ "80-99",
      environment >= 61 & environment <= 80 ~ "61-80",
      environment >= 42 & environment <= 61 ~ "42-61",
      environment >= 23 & environment <= 42 ~ "23-42",
      environment >= 4 & environment <= 23 ~ "4-23",
      NA ~ "unknown"
    ), 
    environment = factor(environment, levels = c("4-23", "23-42", "42-61", "61-80", "80-99"))) |>  
  ggplot(aes(x = environment, y = safety, fill = satisfaction))+
  geom_boxplot(show.legend = FALSE, alpha = 0.5)+
  scale_fill_brewer(palette = "Pastel2")+
  facet_wrap(~satisfaction)+
  theme_linedraw()+
  labs(x = "Environment", y = "Safety", 
       title = "Safety by Environmental Ranking Ranges by Satisfaction") +
  theme(plot.title = element_text(hjust = 0.5, size = 10, face = "bold"), 
        axis.text.x = element_text(hjust = 0.5, size = 8), 
        axis.title.x = element_text(hjust = 0.5, size = 10, face = "bold"), 
        axis.title.y = element_text(hjust = 0.5, size = 10, face = "bold"))






#interaction between price and area ------
training_sample |> 
  mutate(
    area = case_when(
      area >= 4000 & area <= 5000 ~ "4000-5000",
      area >= 3000 & area <= 4000 ~ "3000-4000",
      area >= 2000 & area <= 3000 ~ "2000-3000",
      area >= 1000 & area <= 2000 ~ "1000-2000",
      area >= 1 & area <= 1000 ~ "1-1000"), 
    area = factor(area)) |> 
  ggplot(aes(x = satisfaction, y = log10(price), fill = satisfaction))+
  geom_col(show.legend = FALSE)+
  scale_fill_brewer(palette = "Pastel2")+
  facet_wrap(~area)+
  labs(x = "Satisfaction", y = "Price (Log 10 Scale)", 
       title = "Satisfaction and Price for different Area Ranges in Square Meters")+
  theme_linedraw()+
  theme(plot.title = element_text(hjust = 0.5, size = 10, face = "bold"), 
        axis.text.x = element_text(hjust = 0.5, size = 8), 
        axis.title.x = element_text(hjust = 0.5, size = 10, face = "bold"), 
        axis.title.y = element_text(hjust = 0.5, size = 10, face = "bold"))


