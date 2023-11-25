# Load libraries

library(tidyverse)
library(plyr)
library(dplyr)
library(ggplot2)
library(lubridate)
library(zoo)
library(reshape2)
library(cowplot)

####### Capital Expenditures ########
# One time expenditures that are not specific to a growth type


# ######### Make into Function ########

P.L.Season <- function(
    Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
    Longline.Quantity,        # Number of longlines on the farm                  
    Longline.Depth,           # Lease Depth (Feet) at low tide
    Longline.Suspended.Depth, # Projected Longline Depth at low tide  
    Product,                  # Number of individual scallop spat
    Year.Start,               # Year of projected farm operations start: Model begins August 1st
    Consumables,              # Includes general expenditures like Gear,coffee,misc
    Owner.salary,             # Predicted annual owner salary
    Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
    Full.Time.Employee,       # Number of full time employees
    Employee.Salary,          # Annual full time employee salary
    Part.Time.Wage,           # Hourly rate for part time wages
    Harvest.Season,             # Intended harvest Season, model can account for harvest in 
    # August (Summer), November(Fall), February(Winter) and May(Spring) of 1 and 2 years grow-out
    Harvest.Year,              #Can Harvest Year 1, Year 2, and Year 3
    Gear.Specification         # Ear Hanging versus Lantern Net
    
){
  
  Y1.Product <- Product * (1-Y0.Mortality)      # Product from total spat that survived until August 01 of Y1  
  Y2.Product <- Y1.Product * (1-Y1.Mortality)     # Product from total Y1 that survived until August 01 of Y2
  Y3.Product <- Y2.Product * (1-Y2.Mortality)     # Product from total Y2 that survived until August 01 of Y3
  Y4.Product <- Y3.Product * (1-Y3.Mortality)     # Product from total Y3 that survived until August 01 of Y4
  
  
  Y2.EH.Droppers <- ceiling((Y2.Product/Y2.EH.Dropper.Scallops.per))     # Total dropper lines for product rounded up to nearest whole dropper
  Y2.EH.Dropper.Length <- ((Y2.EH.Dropper.Scallops.per*Y2.EH.Scallop.Spacing)/2 + Y2.EH.Dropper.Margins)  # Dropper line length for rope cost
  
  ########## Y0 Nursery Culture from Wild Spat #######
  
  E.Wild.Spat.Collector <- Spat.Collector %>%
    mutate (Quantity = Product/Wild.Spat.Collector) %>%     
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Wild.Spat.Collector.Anchor <- Cement.Anchor %>%
    mutate (Quantity = E.Wild.Spat.Collector$Quantity/Collectors.Line) %>%
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Wild.Spat.Collector.Buoy <- Go.Deep.Buoy %>%
    mutate (Quantity = E.Wild.Spat.Collector.Anchor$Quantity) %>% 
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Wild.Spat.Collector.Rope <- Gangion.Line %>%
    mutate (Quantity = E.Wild.Spat.Collector.Anchor$Quantity * Spat.Site.Depth) %>%  
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Wild.Spat.Restock.LanternNets <- Lantern.Net %>% 
    mutate (Quantity = Product/(Seed.Net.Density*LN.Tiers)) %>%  
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Wild.Spat.Restock.Buoy <- Hard.Ball%>% 
    mutate (Quantity = E.Wild.Spat.Restock.LanternNets$Quantity/Hard.Ball.Spacing.LN) %>%
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Wild.Spat.Restock.Rope <- Gangion.Line%>% 
    mutate (Quantity = (E.Wild.Spat.Restock.LanternNets$Quantity * Gangion.Length) + (E.Wild.Spat.Restock.Buoy$Quantity*Gangion.Length)) %>%  
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Wild.Spat.Restock.Anchor <- Cement.Anchor %>% 
    mutate (Quantity = E.Wild.Spat.Restock.LanternNets$Quantity/Cement.Anchor.Net) %>%  
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Wild.Spat.Permits <- Spat.Coll.Permit %>% 
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  Equipment.Y0 <- rbind(E.Wild.Spat.Collector,E.Wild.Spat.Collector.Anchor,E.Wild.Spat.Collector.Buoy,
                        E.Wild.Spat.Collector.Rope,E.Wild.Spat.Permits,E.Wild.Spat.Restock.Anchor,
                        E.Wild.Spat.Restock.Buoy,E.Wild.Spat.Restock.LanternNets,E.Wild.Spat.Restock.Rope)
  
  Equipment.Y0$Type <- 'Wild Spat - Collected'
  Equipment.Y0$Year <- 'Y0'
  
  # Wild Spat Labor
  
  L.Wild.Spat.ssd <- Settlement.Device%>% 
    mutate(Time = Daily.Work * E.Wild.Spat.Collector$Quantity/Task.Rate) %>%      # All labor assumes a standard 8 hour day
    mutate(Trips = ceiling(E.Wild.Spat.Collector$Quantity/Task.Rate)) %>%
    mutate(Hours.Worked = ifelse(Trips>0,round_any(Time,Daily.Work,f=ceiling),Time)) %>%     # Assumes that all boat days are paid full 8 hours
    mutate(Labor.Cost = Hours.Worked*Part.Time.Wage*Part.Time)
  
  L.Wild.Spat.CSD <- Collect.Settlement.Device %>% 
    mutate(Time = Daily.Work * E.Wild.Spat.Collector$Quantity/Task.Rate) %>% 
    mutate(Trips = ceiling(E.Wild.Spat.Collector$Quantity/Task.Rate)) %>%
    mutate(Hours.Worked = ifelse(Trips>0,round_any(Time,Daily.Work,f=ceiling),Time)) %>%
    mutate(Labor.Cost = Hours.Worked*Part.Time.Wage*Part.Time)
  
  L.Wild.Spat.PSD <- Process.Settlement.Device %>% 
    mutate(Time = Daily.Work * E.Wild.Spat.Collector$Quantity/Task.Rate) %>% 
    mutate(Trips = ceiling(E.Wild.Spat.Collector$Quantity/Task.Rate)) %>%
    mutate(Hours.Worked = ifelse(Trips>0,round_any(Time,Daily.Work,f=ceiling),Time)) %>%
    mutate(Labor.Cost = Hours.Worked*Part.Time.Wage*Part.Time)
  
  L.Wild.Spat.SS <- Spat.Stocking %>% 
    mutate(Time = Daily.Work * Product/Task.Rate) %>% 
    mutate(Trips = ceiling(Product/Task.Rate)) %>%
    mutate(Hours.Worked = ifelse(Trips>0,round_any(Time,Daily.Work,f=ceiling),Time)) %>%
    mutate(Labor.Cost = Hours.Worked*Part.Time.Wage*Part.Time)
  
  Labor.Wild.Spat <- rbind(L.Wild.Spat.CSD,L.Wild.Spat.PSD,L.Wild.Spat.SS,
                           L.Wild.Spat.ssd)
  Labor.Wild.Spat$Type <- 'Wild Spat - Collected'
  Labor.Wild.Spat$Year <- 'Y0'
  
  ####### Intermediary Culture - Seed #######
  
  # Intermediary Culture - Equipment  
  E.Y1.LanternNets <- Lantern.Net %>% 
    mutate (Quantity = Y1.Product/(Y1.Stocking.Density*LN.Tiers)) %>% 
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Y1.Rope <- Gangion.Line%>% 
    mutate (Quantity = E.Y1.LanternNets$Quantity * Gangion.Length) %>%  # Assumes Length of 1.2 meters
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Y1.Buoy <- Hard.Ball %>% 
    mutate (Quantity = E.Y1.LanternNets$Quantity/Hard.Ball.Spacing.LN) %>%  # Assumes 1 flotation buoy/10 lantern nets
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Y1.Anchor <- Cement.Anchor%>% 
    mutate (Quantity = E.Y1.LanternNets$Quantity/Cement.Anchor.Net) %>%  # Assumes 1 anchor per 25 lantern nets
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  Equipment.Y1 <- rbind(E.Y1.Anchor,E.Y1.Buoy,E.Y1.LanternNets,E.Y1.Rope)
  Equipment.Y1$Type <- 'Lantern Net'
  Equipment.Y1$Year <- 'Y1'
  
  # Labor - Intermediary Culture
  
  L.Y1.Restock <- Restock %>% 
    mutate(Time = Daily.Work * E.Y1.LanternNets$Quantity/Task.Rate) %>% 
    mutate(Trips = ceiling(E.Y1.LanternNets$Quantity/Task.Rate)) %>%
    mutate(Hours.Worked = ifelse(Trips>0,round_any(Time,Daily.Work,f=ceiling),Time)) %>%
    mutate(Labor.Cost = Hours.Worked*Part.Time.Wage*Part.Time)
  
  L.Y1.Cleaning.Spring <- Cleaning.Spring.LN %>% 
    mutate(Time = Daily.Work * E.Y1.LanternNets$Quantity/Task.Rate) %>% 
    mutate(Trips = ceiling(E.Y1.LanternNets$Quantity/Task.Rate)) %>%
    mutate(Hours.Worked = ifelse(Trips>0,round_any(Time,Daily.Work,f=ceiling),Time)) %>%
    mutate(Labor.Cost = Hours.Worked*Part.Time.Wage*Part.Time)
  
  L.Y1.Cleaning.Fall <- Cleaning.Fall.LN %>% 
    mutate(Time = Daily.Work * E.Y1.LanternNets$Quantity/Task.Rate) %>% 
    mutate(Trips = ceiling(E.Y1.LanternNets$Quantity/Task.Rate)) %>%
    mutate(Hours.Worked = ifelse(Trips>0,round_any(Time,Daily.Work,f=ceiling),Time)) %>%
    mutate(Labor.Cost = Hours.Worked*Part.Time.Wage*Part.Time)
  
  L.Y1.Y0Cleaning <- Cleaning.Prev.Year %>% 
    mutate(Trips = 0) %>%      # Trips set to 0 for non-vessel tasks
    mutate(Time = Daily.Work * E.Wild.Spat.Restock.LanternNets$Quantity/Task.Rate) %>% 
    mutate(Hours.Worked = Time) %>%
    mutate(Labor.Cost = Hours.Worked*Part.Time.Wage*Part.Time)
  
  Labor.Y1 <- rbind(L.Y1.Cleaning.Fall,L.Y1.Cleaning.Spring,L.Y1.Restock,
                    L.Y1.Y0Cleaning)
  
  Labor.Y1$Type <- 'Lantern Net'
  Labor.Y1$Year <- 'Y1'
  
  ##### Y2 Lantern Net Culture #######
  
  # Y2 Equipment # 
  
  E.Y2.LN.LanternNets <- Lantern.Net %>% 
    mutate (Quantity = Y2.Product/(Y2.LN.Stocking.Density*LN.Tiers)) %>%  
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Y2.LN.Rope <- Gangion.Line%>% 
    mutate (Quantity = E.Y2.LN.LanternNets$Quantity * Gangion.Length) %>%
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Y2.LN.Buoy <- Hard.Ball %>% 
    mutate (Quantity = E.Y2.LN.LanternNets$Quantity/Hard.Ball.Spacing.LN) %>%  
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Y2.LN.Anchor <- Cement.Anchor%>% 
    mutate (Quantity = E.Y2.LN.LanternNets$Quantity/Cement.Anchor.Net) %>%  
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Y2.LN.SW <- Scallop.Washer %>% 
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Y2.LN.SG <- Scallop.Grader %>% 
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  
  E.Y2.LN.PP <- Power.Pack %>% 
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  Equipment.Y2.LN <- rbind(E.Y2.LN.Anchor, E.Y2.LN.Buoy, E.Y2.LN.LanternNets,
                           E.Y2.LN.PP, E.Y2.LN.Rope, E.Y2.LN.SG,
                           E.Y2.LN.SW)
  Equipment.Y2.LN$Type <- 'Lantern Net'
  Equipment.Y2.LN$Year <- 'Y2'
  
  # Y2 Lantern Net Labor
  L.Y2.LN.Restock <- Restock %>% 
    mutate(Time = Daily.Work * E.Y2.LN.LanternNets$Quantity/Task.Rate) %>% 
    mutate(Trips = ceiling(E.Y2.LN.LanternNets$Quantity/Task.Rate)) %>%
    mutate(Hours.Worked = ifelse(Trips>0,round_any(Time,Daily.Work,f=ceiling),Time)) %>%
    mutate(Labor.Cost = Hours.Worked*Part.Time.Wage*Part.Time)
  
  L.Y2.LN.Cleaning.Spring <- Cleaning.Spring.LN %>% 
    mutate(Time = Daily.Work * E.Y2.LN.LanternNets$Quantity/Task.Rate) %>% 
    mutate(Trips = ceiling(E.Y2.LN.LanternNets$Quantity/Task.Rate)) %>%
    mutate(Hours.Worked = ifelse(Trips>0,round_any(Time,Daily.Work,f=ceiling),Time)) %>%
    mutate(Labor.Cost = Hours.Worked*Part.Time.Wage*Part.Time)
  
  L.Y2.LN.Cleaning.Fall <- Cleaning.Fall.LN %>% 
    mutate(Time = Daily.Work * E.Y2.LN.LanternNets$Quantity/Task.Rate) %>% 
    mutate(Trips = ceiling(E.Y2.LN.LanternNets$Quantity/Task.Rate)) %>%
    mutate(Hours.Worked = ifelse(Trips>0,round_any(Time,Daily.Work,f=ceiling),Time)) %>%
    mutate(Labor.Cost = Hours.Worked*Part.Time.Wage*Part.Time)
  
  L.Y2.LN.Y1Cleaning <- Cleaning.Prev.Year %>% 
    mutate(Trips = 0) %>%      # Trips set to 0 for non-vessel tasks
    mutate(Time = Daily.Work * E.Y1.LanternNets$Quantity/Task.Rate) %>% 
    mutate(Hours.Worked = Time) %>%
    mutate(Labor.Cost = Hours.Worked*Part.Time.Wage*Part.Time)
  
  Labor.Y2.LN <- rbind(L.Y2.LN.Cleaning.Fall,L.Y2.LN.Cleaning.Spring,L.Y2.LN.Restock,
                       L.Y2.LN.Y1Cleaning)
  
  Labor.Y2.LN$Type <- 'Lantern Net'
  Labor.Y2.LN$Year <- 'Y2'
  
  ##### Y3 Lantern Net Culture #######
  
  # Y3 Equipment # 
  
  E.Y3.LN.LanternNets <- E.Y2.LN.LanternNets
  
  E.Y3.LN.Rope <- E.Y2.LN.Rope
  
  E.Y3.LN.Buoy <- E.Y2.LN.Buoy
  
  E.Y3.LN.Anchor <- E.Y2.LN.Anchor
  
  Equipment.Y3.LN <- rbind(E.Y3.LN.Anchor, E.Y3.LN.Buoy, E.Y3.LN.LanternNets,
                           E.Y3.LN.Rope)
  Equipment.Y3.LN$Type <- 'Lantern Net'
  Equipment.Y3.LN$Year <- 'Y3'
  # Y3 Lantern Net Labor
  
  L.Y3.LN.Cleaning.Spring <- Cleaning.Spring.LN %>% 
    mutate(Time = Daily.Work * E.Y2.LN.LanternNets$Quantity/Task.Rate) %>% 
    mutate(Trips = ceiling(E.Y2.LN.LanternNets$Quantity/Task.Rate)) %>%
    mutate(Hours.Worked = ifelse(Trips>0,round_any(Time,Daily.Work,f=ceiling),Time)) %>%
    mutate(Labor.Cost = Hours.Worked*Part.Time.Wage*Part.Time)
  
  L.Y3.LN.Cleaning.Fall <- Cleaning.Fall.LN %>% 
    mutate(Time = Daily.Work * E.Y2.LN.LanternNets$Quantity/Task.Rate) %>% 
    mutate(Trips = ceiling(E.Y2.LN.LanternNets$Quantity/Task.Rate)) %>%
    mutate(Hours.Worked = ifelse(Trips>0,round_any(Time,Daily.Work,f=ceiling),Time)) %>%
    mutate(Labor.Cost = Hours.Worked*Part.Time.Wage*Part.Time)
  
  Labor.Y3.LN <- rbind(L.Y3.LN.Cleaning.Fall,L.Y3.LN.Cleaning.Spring)
  Labor.Y3.LN$Type <- 'Lantern Net'
  Labor.Y3.LN$Year <- 'Y3'
  
  ##### Y2 Ear Hanging Culture #######
  # Y2 Equipment  Ear Hanging
  E.Y2.EH.Dropper.lines <- Dropper.Line %>% 
    mutate (Quantity = (Y2.EH.Droppers*Y2.EH.Dropper.Length)) %>%  
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Y2.EH.Age.Pins <- Age.Pins %>% 
    mutate (Quantity = Y2.Product/2) %>%       #Paired scallops on droppers
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Y2.EH.Buoy <- Hard.Ball %>% 
    mutate (Quantity = Y2.EH.Droppers/Hard.Ball.Spacing.EH) %>%  
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Y2.EH.Anchor <- Brick.Anchor %>% 
    mutate (Quantity = Y2.EH.Droppers) %>%  # Assumes 1 brick per dropper line
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Y2.EH.Anchor <- Cement.Anchor%>% 
    mutate (Quantity = E.Y2.LN.LanternNets$Quantity/Cement.Anchor.EH) %>%  
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Y2.EH.SW <- Scallop.Washer %>% 
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Y2.EH.SG <- Scallop.Grader %>% 
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Y2.EH.PP <- Power.Pack %>% 
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Y2.EH.Drill.D <- Drill.Dremmel %>% 
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Y2.EH.Drill.Auto <- Drill.Automated %>% 
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Y2.EH.Drill.Pin <- Drill.Pin %>% 
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Y2.EH.Pinning <- Pinning %>% 
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Y2.EH.DPM <- depinning %>% 
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  Equipment.Y2.EH <- rbind(E.Y2.EH.Anchor, E.Y2.EH.Buoy, E.Y2.EH.Age.Pins,
                           E.Y2.EH.DPM, E.Y2.EH.Drill.Auto, E.Y2.EH.Drill.D,
                           E.Y2.EH.Drill.Pin,E.Y2.EH.Dropper.lines,E.Y2.EH.PP,
                           E.Y2.EH.SG, E.Y2.EH.SW, E.Y2.EH.Pinning)
  
  Equipment.Y2.EH$Type <- 'Ear Hanging'
  Equipment.Y2.EH$Year <- 'Y2'
  
  # Y2 Ear Hanging Labor
  
  L.Y2.EH.DP.Dremmel <- Labor.Dremmel %>%
    mutate(Task.Rate = Task.Rate*E.Y2.EH.Drill.D$Quantity) %>%
    mutate(Part.Time = Part.Time*E.Y2.EH.Drill.D$Quantity) %>%
    mutate(Time = Daily.Work * Y2.Product/Task.Rate) %>% 
    mutate(Trips = ceiling(Y2.Product/Task.Rate)) %>%
    mutate(Hours.Worked = ifelse(Trips>0,round_any(Time,Daily.Work,f=ceiling),Time)) %>%
    mutate(Labor.Cost = Hours.Worked*Part.Time.Wage*Part.Time)
  
  L.Y2.EH.DP.Auto <- Labor.Auto.Drill %>% 
    mutate(Task.Rate = Task.Rate*E.Y2.EH.Drill.Auto$Quantity) %>%
    mutate(Part.Time = Part.Time*E.Y2.EH.Drill.Auto$Quantity) %>%
    mutate(Time = Daily.Work * Y2.Product/Task.Rate) %>% 
    mutate(Trips = ceiling(Y2.Product/Task.Rate)) %>%
    mutate(Hours.Worked = ifelse(Trips>0,round_any(Time,Daily.Work,f=ceiling),Time)) %>%
    mutate(Labor.Cost = Hours.Worked*Part.Time.Wage*Part.Time)
  
  L.Y2.EH.DP.Auto.Full <- Labor.Auto.Full %>%
    mutate(Task.Rate = Task.Rate*E.Y2.EH.Drill.Pin$Quantity) %>%
    mutate(Time = Daily.Work * Y2.Product/Task.Rate) %>% 
    mutate(Trips = ceiling(Y2.Product/Task.Rate)) %>%
    mutate(Hours.Worked = ifelse(Trips>0,round_any(Time,8,f=ceiling),Time)) %>%
    mutate(Labor.Cost = Hours.Worked*Part.Time.Wage*Part.Time)
  
  L.Y2.EH.Cleaning.Spring <- Cleaning.Spring.EH %>% 
    mutate(Time = Daily.Work * Y2.EH.Droppers/Task.Rate) %>% 
    mutate(Trips = ceiling(Y2.EH.Droppers/Task.Rate)) %>%
    mutate(Hours.Worked = ifelse(Trips>0,round_any(Time,Daily.Work,f=ceiling),Time)) %>%
    mutate(Labor.Cost = Hours.Worked*Part.Time.Wage*Part.Time)
  
  L.Y2.EH.Cleaning.Fall <- Cleaning.Fall.EH %>% 
    mutate(Time = Daily.Work * Y2.EH.Droppers/Task.Rate) %>% 
    mutate(Trips = ceiling(Y2.EH.Droppers/Task.Rate)) %>%
    mutate(Hours.Worked = ifelse(Trips>0,round_any(Time,Daily.Work,f=ceiling),Time)) %>%
    mutate(Labor.Cost = Hours.Worked*Part.Time.Wage*Part.Time)
  
  L.Y2.EH.Y1Cleaning <- Cleaning.Prev.Year %>% 
    mutate(Trips = 0) %>%      # Trips set to 0 for non-vessel tasks
    mutate(Time = Daily.Work * E.Y1.LanternNets$Quantity/Task.Rate) %>% 
    mutate(Hours.Worked = Time) %>%
    mutate(Labor.Cost = Hours.Worked*Part.Time.Wage*Part.Time)
  
  
  L.Y2.EH.DLC <- Dropper.Line.Construction %>% 
    mutate(Trips = 0) %>%      # Trips set to 0 for non-vessel tasks
    mutate(Time = Daily.Work * Y2.EH.Droppers/Task.Rate) %>% 
    mutate(Hours.Worked = Time) %>%
    mutate(Labor.Cost = Hours.Worked*Part.Time.Wage*Part.Time)
  
  Labor.Y2.EH <- rbind(L.Y2.EH.Cleaning.Fall,L.Y2.EH.Cleaning.Spring,L.Y2.EH.DP.Auto,
                       L.Y2.EH.DP.Auto.Full, L.Y2.EH.DP.Dremmel,L.Y2.EH.Y1Cleaning,
                       L.Y2.EH.DLC)
  
  Labor.Y2.EH[sapply(Labor.Y2.EH,is.infinite)]<-NA
  Labor.Y2.EH$Type <- 'Ear Hanging'
  Labor.Y2.EH$Year <- 'Y2'
  
  
  ##### Y3 Ear Hanging Culture #######
  # Dropper Lines remain the same since mortality is not 
  
  # Y2 Equipment  Ear Hanging
  E.Y3.EH.Dropper.lines <- E.Y2.EH.Dropper.lines
  
  E.Y3.EH.Age.Pins <- E.Y2.EH.Age.Pins
  
  E.Y3.EH.Buoy <- E.Y2.EH.Buoy
  
  E.Y3.EH.Anchor <- E.Y2.EH.Anchor 
  
  
  Equipment.Y3.EH <- rbind(E.Y3.EH.Anchor, E.Y3.EH.Buoy, E.Y3.EH.Age.Pins, E.Y3.EH.Dropper.lines)
  
  Equipment.Y3.EH$Type <- 'Ear Hanging'
  Equipment.Y3.EH$Year <- 'Y3'
  # Y3 Ear Hanging Labor
  
  L.Y3.EH.Cleaning.Spring <- Cleaning.Spring.EH %>% 
    mutate(Time = Daily.Work * Y2.EH.Droppers/Task.Rate) %>% 
    mutate(Trips = ceiling(Y2.EH.Droppers/Task.Rate)) %>%
    mutate(Hours.Worked = ifelse(Trips>0,round_any(Time,Daily.Work,f=ceiling),Time)) %>%
    mutate(Labor.Cost = Hours.Worked*Part.Time.Wage*Part.Time)
  
  L.Y3.EH.Cleaning.Fall <- Cleaning.Fall.EH %>% 
    mutate(Time = Daily.Work * Y2.EH.Droppers/Task.Rate) %>% 
    mutate(Trips = ceiling(Y2.EH.Droppers/Task.Rate)) %>%
    mutate(Hours.Worked = ifelse(Trips>0,round_any(Time,Daily.Work,f=ceiling),Time)) %>%
    mutate(Labor.Cost = Hours.Worked*Part.Time.Wage*Part.Time)
  
  Labor.Y3.EH <- rbind(L.Y3.EH.Cleaning.Fall,L.Y3.EH.Cleaning.Spring)
  Labor.Y3.EH[sapply(Labor.Y3.EH,is.infinite)]<-NA
  Labor.Y3.EH$Type <- 'Ear Hanging'
  Labor.Y3.EH$Year <- 'Y3'
  
  
  
  
  # Equipment rbind for lease footprint and cap-ex calculation 
  Equipment <- rbind(Equipment.Y2.LN,Equipment.Y2.EH,
                     Equipment.Y3.LN,Equipment.Y3.EH)
  
  # Subset by Grow-Out type
  Equipment <- subset(Equipment,
                      Type == Gear.Specification)
  
  Equipment <- rbind(Equipment,
                     Equipment.Y0,
                     Equipment.Y1)
  
  if(Harvest.Year == 'Y1'){
    Equipment <- subset(Equipment,Year == 'Y0'| Year == 'Y1')
  }
  
  if(Harvest.Year == 'Y2'){
    Equipment<- subset(Equipment, Year == 'Y0'| Year == 'Y1' | Year == 'Y2')
  }
  
  
  Lease.Footprint <- subset(Equipment, Equipment == 'Lantern Net' | Equipment == 'Dropper Line')
  Lease.Footprint$Total.Length <- ifelse(Lease.Footprint$Equipment == 'Lantern Net', Lease.Footprint$Quantity*LN.Spacing,
                                         Y2.EH.Droppers*EH.Spacing)
  Lease.Footprint.feet <- sum(Lease.Footprint$Total.Length)
  Lease.Footprint.Acres <- (Lease.Footprint.feet*40)*.0000229568
  
  # Cap-ex including longline setup setup, vehicles, and miscellaneous initial expenses
  
  E.Longline.Head.Rope <- Rope.2inch %>%     #  Calculated outputs based on primary and secondary inputs  
    mutate (Quantity = Lease.Footprint.feet) %>%    #  Total quantity of units
    mutate (Cost.Basis = Unit.Cost*Quantity) %>%      # Total cost of units at initial purchase
    mutate (Depreciation = Cost.Basis/Lifespan)     # Theoretical cost per year based on life span of the asset
  
  E.Longline.Main.Anchor <- Mooring.Anchor %>%
    mutate (Quantity = Longline.Quantity*2) %>% 
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Longline.Mooring.Line <- Rope.2inch %>%
    mutate (Quantity = Longline.Quantity*Longline.Depth*2*Mooring.Length) %>%     # Estimating at 4 times length of depth at low tide
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Longline.Corner.Tension.Float <- Corner.Tension.Float %>%
    mutate (Quantity = Longline.Quantity*2) %>% 
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Longline.Surface.Float <- Surface.Float %>%
    mutate (Quantity = (Lease.Footprint.feet/Surface.Float.Spacing)*Longline.Quantity) %>%     # spaced along head rope in feet
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Longline.Surface.Float.Dropper <- Gangion.Line %>%
    mutate (Quantity = E.Longline.Surface.Float$Quantity*Longline.Suspended.Depth) %>% 
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Longline.Lease.Marker <- Lease.Marker %>%
    mutate (Quantity = 4) %>% 
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  E.Vehicles.Vessel <- Vessel %>%
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = ifelse(Quantity == 0, Unit.Cost*1/Lifespan, Unit.Cost/Lifespan))
  
  E.Vehicles.Truck <- Truck %>%
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = ifelse(Quantity == 0, Unit.Cost*1/Lifespan, Unit.Cost/Lifespan))
  
  E.Misc <- Misc %>%
    mutate (Cost.Basis = Unit.Cost*Quantity) %>% 
    mutate (Depreciation = Cost.Basis/Lifespan)
  
  # Capital Expenditures prior to Growing start date on August 1
  Equipment.cap <- rbind(E.Longline.Corner.Tension.Float,E.Longline.Head.Rope,E.Longline.Lease.Marker,
                         E.Longline.Main.Anchor,E.Longline.Mooring.Line,E.Longline.Surface.Float,
                         E.Longline.Surface.Float.Dropper,E.Vehicles.Truck,E.Vehicles.Vessel,
                         E.Misc)
  
  Equipment.cap$Type <- 'Cap-Ex'
  Equipment.cap$Year <- 'Initial'
  
  # Equipment
  
  Equipment <- rbind(Equipment, Equipment.cap)
  
  # Labor
  Labor <- rbind (Labor.Y2.LN,Labor.Y2.EH,
                  Labor.Y3.LN,Labor.Y3.EH)
  Labor <- subset(Labor,
                  Type == Gear.Specification)
  
  Labor <- rbind(Labor,
                 Labor.Wild.Spat,
                 Labor.Y1)
  
  if(Harvest.Year == 'Y1'){
    Labor <- subset(Labor,Year == 'Y0'| Year == 'Y1')
  }
  
  if(Harvest.Year == 'Y2'){
    Labor<- subset(Labor, Year == 'Y0'| Year == 'Y1' | Year == 'Y2')
  }
  
  
  Labor.Season <- Labor[Labor$Year == Harvest.Year,]
  Labor <- Labor[Labor$Year != Harvest.Year,]
  
  if (Harvest.Season == 'Summer'){
    Labor.Season <- subset (Labor.Season, Timing == 'Summer'| Timing == 'Spring'| 
                              Timing == 'Winter'| Timing == 'Fall')
  }  
  
  if (Harvest.Season == 'Fall'){
    Labor.Season <- subset (Labor.Season, Timing == 'Fall')
  }  
  
  if (Harvest.Season == 'Winter'){
    Labor.Season <- subset (Labor.Season, Timing == 'Fall'| Timing == 'Winter')
  }  
  
  if (Harvest.Season == 'Spring'){
    Labor.Season <- subset (Labor.Season, Timing == 'Fall' | Timing == 'Winter'|
                              Timing == 'Spring')
  }  
  
  Labor <- rbind(Labor,
                 Labor.Season)
  
  
  # Wild Spat - Fuel
  
  F.Wild.Spat.Vessel <- Fuel.Vessel %>%
    mutate(Additional.Trips = Wild.Spat.Collected.Add.V.Trips) %>%
    mutate(Fuel.Cost = Price.Gallon * Usage.Trip * (sum(as.data.frame(subset(Labor, Year == 'Y0')$Trips),na.rm = TRUE)+Additional.Trips))
  
  F.Wild.Spat.Truck<- Fuel.Truck %>%
    mutate(Additional.Trips = Wild.Spat.Collected.Add.T.Trips) %>%
    mutate(Fuel.Cost = Price.Gallon * Usage.Trip * (sum(as.data.frame(subset(Labor, Year == 'Y0')$Trips),na.rm = TRUE)+Additional.Trips))
  
  Fuel.Wild.Spat <- rbind(F.Wild.Spat.Truck,F.Wild.Spat.Vessel)
  Fuel.Wild.Spat$Type <- 'Wild Spat - Collected'
  Fuel.Wild.Spat$Year <- 'Y0'
  
  # Intermediary Culture - Fuel
  
  F.Y1.Vessel<- Fuel.Vessel %>% 
    mutate(Additional.Trips = Y1.LN.Add.V.Trip) %>%
    mutate(Fuel.Cost = Price.Gallon * Usage.Trip * (sum(as.data.frame(subset(Labor, Year == 'Y1')$Trips),na.rm = TRUE)+Additional.Trips))
  
  F.Y1.Truck<- Fuel.Truck %>% 
    mutate(Additional.Trips = Y1.LN.Add.T.Trip) %>%
    mutate(Fuel.Cost = Price.Gallon * Usage.Trip * (sum(as.data.frame(subset(Labor, Year == 'Y1')$Trips),na.rm = TRUE)+Additional.Trips))
  
  Fuel.Y1 <- rbind(F.Y1.Truck,F.Y1.Vessel)
  Fuel.Y1$Type <- 'Lantern Net'
  Fuel.Y1$Year <- 'Y1'
  
  # Y2 Lantern Net - Fuel
  
  F.Y2.LN.Vessel<- Fuel.Vessel %>%
    mutate(Additional.Trips = Y2.LN.Add.V.Trip) %>%
    mutate(Fuel.Cost = Price.Gallon * Usage.Trip * (sum(as.data.frame(subset(Labor, Year == 'Y2')$Trips),na.rm = TRUE)+Additional.Trips))
  
  F.Y2.LN.Truck<- Fuel.Truck %>% 
    mutate(Additional.Trips = Y2.LN.Add.T.Trip) %>%
    mutate(Fuel.Cost = Price.Gallon * Usage.Trip * (sum(as.data.frame(subset(Labor, Year == 'Y2')$Trips),na.rm = TRUE)+Additional.Trips))
  
  Fuel.Y2.LN <- rbind(F.Y2.LN.Truck,F.Y2.LN.Vessel)
  Fuel.Y2.LN$Type <- 'Lantern Net'
  Fuel.Y2.LN$Year <- 'Y2'
  
  # Y3 Lantern Net - Fuel
  
  F.Y3.LN.Vessel<- Fuel.Vessel %>% 
    mutate(Additional.Trips = Y3.LN.Add.V.Trip) %>%
    mutate(Fuel.Cost = Price.Gallon * Usage.Trip * (sum(as.data.frame(subset(Labor, Year == 'Y3')$Trips),na.rm = TRUE)+Additional.Trips))
  
  F.Y3.LN.Truck <- Fuel.Truck %>% 
    mutate(Additional.Trips = Y3.LN.Add.T.Trip) %>%
    mutate(Fuel.Cost = Price.Gallon * Usage.Trip * (sum(as.data.frame(subset(Labor, Year == 'Y3')$Trips),na.rm = TRUE)+Additional.Trips))
  
  Fuel.Y3.LN <- rbind(F.Y3.LN.Truck,F.Y3.LN.Vessel)
  Fuel.Y3.LN$Type <- 'Lantern Net'
  Fuel.Y3.LN$Year <- 'Y3'
  
  # Y2 Ear Hanging - Fuel
  
  F.Y2.EH.Vessel<- Fuel.Vessel %>% 
    mutate(Additional.Trips = Y2.EH.Add.V.Trip) %>%
    mutate(Fuel.Cost = Price.Gallon * Usage.Trip * (sum(as.data.frame(subset(Labor, Year == 'Y2')$Trips),na.rm = TRUE)+Additional.Trips))
  
  F.Y2.EH.Truck<- Fuel.Truck %>% 
    mutate(Additional.Trips = Y2.EH.Add.T.Trip) %>%
    mutate(Fuel.Cost = Price.Gallon * Usage.Trip * (sum(as.data.frame(subset(Labor, Year == 'Y2')$Trips),na.rm = TRUE)+Additional.Trips))
  
  Fuel.Y2.EH <- rbind(F.Y2.EH.Truck,F.Y2.EH.Vessel)
  Fuel.Y2.EH$Type <- 'Ear Hanging'
  Fuel.Y2.EH$Year <- 'Y2'
  
  
  # Y3 Ear Hanging - Fuel
  
  F.Y3.EH.Vessel<- Fuel.Vessel %>% 
    mutate(Additional.Trips = Y3.EH.Add.V.Trip) %>%
    mutate(Fuel.Cost = Price.Gallon * Usage.Trip * (sum(as.data.frame(subset(Labor, Year == 'Y3')$Trips),na.rm = TRUE)+Additional.Trips))
  
  F.Y3.EH.Truck<- Fuel.Truck %>% 
    mutate(Additional.Trips = Y3.EH.Add.T.Trip) %>%
    mutate(Fuel.Cost = Price.Gallon * Usage.Trip * (sum(as.data.frame(subset(Labor, Year == 'Y3')$Trips),na.rm = TRUE)+Additional.Trips))
  
  Fuel.Y3.EH <- rbind(F.Y3.EH.Truck,F.Y3.EH.Vessel)
  Fuel.Y3.EH$Type <- 'Ear Hanging'
  Fuel.Y3.EH$Year <- 'Y3'
  
  Fuel <- rbind (Fuel.Y2.LN,Fuel.Y2.EH,
                 Fuel.Y3.LN,Fuel.Y3.EH)
  Fuel <- subset(Fuel,
                 Type == Gear.Specification)
  
  Fuel <- rbind(Fuel,
                Fuel.Wild.Spat,
                Fuel.Y1)
  
  if(Harvest.Year == 'Y1'){
    Fuel <- subset(Fuel,Year == 'Y0'| Year == 'Y1')
  }
  
  if(Harvest.Year == 'Y2'){
    Fuel<- subset(Fuel, Year == 'Y0'| Year == 'Y1' | Year == 'Y2')
  }
  
  # Maintenance - Wild Spat
  
  
  M.Wild.Spat.Vessel <- Maint.Vessel %>% 
    mutate(Units = sum(as.data.frame(subset(Labor, Year=='Y0')$Trips),na.rm = TRUE)) %>% 
    mutate(Maintenance.Costs = Cost*Units)
  
  
  M.Wild.Spat.Truck <- Maint.Truck %>% 
    mutate(Units = sum(as.data.frame(subset(Labor, Year=='Y0')$Trips),na.rm = TRUE)) %>% 
    mutate(Maintenance.Costs = Cost*Units)  
  
  Maintenance.Wild.Spat <- rbind(M.Wild.Spat.Vessel,M.Wild.Spat.Truck)
  Maintenance.Wild.Spat$Type <- 'Wild Spat - Collected'
  Maintenance.Wild.Spat$Year <- 'Y0'
  
  # Maintenance - Intermediary Culture
  
  M.Y1.Vessel <- Maint.Vessel %>% 
    mutate(Units = sum(as.data.frame(subset(Labor, Year=='Y1')$Trips),na.rm = TRUE)) %>% 
    mutate(Maintenance.Costs = Cost*Units)
  
  M.Y1.Truck <- Maint.Truck %>% 
    mutate(Units = sum(as.data.frame(subset(Labor, Year=='Y1')$Trips),na.rm = TRUE)) %>%
    mutate(Maintenance.Costs = Cost*Units)  
  
  Maintenance.Y1 <- rbind(M.Y1.Vessel,M.Y1.Truck)
  Maintenance.Y1$Type <- 'Lantern Net'
  Maintenance.Y1$Year <- 'Y1'
  
  # Maintenance - Y2
  
  M.Y2.LN.Vessel <- Maint.Vessel %>% 
    mutate(Units = sum(as.data.frame(subset(Labor, Year=='Y2')$Trips),na.rm = TRUE)) %>% 
    mutate(Maintenance.Costs = Cost*Units)
  
  M.Y2.LN.Truck <- Maint.Truck %>% 
    mutate(Units = sum(as.data.frame(subset(Labor, Year=='Y2')$Trips),na.rm = TRUE)) %>%
    mutate(Maintenance.Costs = Cost*Units)
  
  M.Y2.LN.SE <- Specialized.Equipment %>% 
    mutate(Units = Y2.Product) %>%
    mutate(Maintenance.Costs = Cost*Units *(sum(as.data.frame(subset(Equipment, Equipment == 'Power Pack' |
                                                                       Equipment == 'Scallop Grader'| Equipment == 'Scallop Washer')$Quantity),na.rm = TRUE)))  
  
  Maintenance.Y2.LN <- rbind(M.Y2.LN.Vessel,M.Y2.LN.Truck,M.Y2.LN.SE)
  Maintenance.Y2.LN$Type <- 'Lantern Net'
  Maintenance.Y2.LN$Year <- 'Y2'
  
  # Maintenance - Year 3 Lantern Net
  
  M.Y3.LN.Vessel <- Maint.Vessel %>% 
    mutate(Units = sum(as.data.frame(subset(Labor, Year=='Y3')$Trips),na.rm = TRUE)) %>% 
    mutate(Maintenance.Costs = Cost*Units)
  
  
  M.Y3.LN.Truck <- Maint.Truck %>% 
    mutate(Units = sum(as.data.frame(subset(Labor, Year=='Y3')$Trips),na.rm = TRUE)) %>%
    mutate(Maintenance.Costs = Cost*Units) 
  
  M.Y3.LN.SE <- Specialized.Equipment %>% 
    mutate(Units = Y3.Product) %>%
    mutate(Maintenance.Costs = Cost*Units *(sum(as.data.frame(subset(Equipment, Equipment == 'Power Pack' |
                                                                       Equipment == 'Scallop Grader'| Equipment == 'Scallop Washer')$Quantity),na.rm = TRUE)))  
  
  Maintenance.Y3.LN <- rbind(M.Y3.LN.Vessel,M.Y3.LN.Truck,M.Y3.LN.SE)
  Maintenance.Y3.LN$Type <- 'Lantern Net'
  Maintenance.Y3.LN$Year <- 'Y3'
  
  # Maintenance - Wild Spat
  
  
  M.Y2.EH.Vessel <- Maint.Vessel %>% 
    mutate(Units = sum(as.data.frame(subset(Labor, Year=='Y2')$Trips),na.rm = TRUE)) %>% 
    mutate(Maintenance.Costs = Cost*Units)
  
  M.Y2.EH.Truck <- Maint.Truck %>% 
    mutate(Units = sum(as.data.frame(subset(Labor, Year=='Y2')$Trips),na.rm = TRUE)) %>% 
    mutate(Maintenance.Costs = Cost*Units)
  
  M.Y2.EH.SE <- Specialized.Equipment %>% 
    mutate(Units = Y2.Product) %>%
    mutate(Maintenance.Costs = Cost*Units *(sum(as.data.frame(subset(Equipment, Equipment == 'Power Pack' |
                                                                       Equipment == 'Scallop Grader'| Equipment == 'Scallop Washer'| Equipment == 'De-Pining Machine'|
                                                                       Equipment == 'Drill (Automated)' | Equipment == 'Drill (Dremmel)' | Equipment == 'Drill and Pin'|
                                                                       Equipment == 'Pining Machine')$Quantity),na.rm = TRUE)))  
  
  Maintenance.Y2.EH <- rbind(M.Y2.EH.Vessel,M.Y2.EH.Truck,M.Y2.EH.SE)
  Maintenance.Y2.EH$Type <- 'Ear Hanging'
  Maintenance.Y2.EH$Year <- 'Y2'
  
  # Maintenance - Wild Spat
  
  M.Y3.EH.Vessel <- Maint.Vessel %>% 
    mutate(Units = sum(as.data.frame(subset(Labor, Year=='Y3')$Trips),na.rm = TRUE)) %>% 
    mutate(Maintenance.Costs = Cost*Units)
  
  M.Y3.EH.Truck <- Maint.Truck %>% 
    mutate(Units = sum(as.data.frame(subset(Labor, Year=='Y3')$Trips),na.rm = TRUE)) %>%  
    mutate(Maintenance.Costs = Cost*Units)
  
  
  M.Y3.EH.SE <- Specialized.Equipment %>%
    mutate(Units = Y3.Product) %>%
    mutate(Maintenance.Costs = Cost*Units *(sum(as.data.frame(subset(Equipment, Equipment == 'Power Pack' |
                                                                       Equipment == 'Scallop Grader'| Equipment == 'Scallop Washer'| Equipment == 'De-Pining Machine'|
                                                                       Equipment == 'Drill (Automated)' | Equipment == 'Drill (Dremmel)' | Equipment == 'Drill and Pin'|
                                                                       Equipment == 'Pining Machine')$Quantity),na.rm = TRUE)))  
  
  
  Maintenance.Y3.EH <- rbind(M.Y3.EH.Vessel,M.Y3.EH.Truck,M.Y3.EH.SE)
  Maintenance.Y3.EH$Type <- 'Ear Hanging'
  Maintenance.Y3.EH$Year <- 'Y3'
  
  Maintenance <- rbind (Maintenance.Y2.LN,Maintenance.Y2.EH,
                        Maintenance.Y3.LN,Maintenance.Y3.EH)
  Maintenance <- subset(Maintenance,
                        Type == Gear.Specification)
  
  Maintenance <- rbind(Maintenance,
                       Maintenance.Wild.Spat,
                       Maintenance.Y1)
  
  if(Harvest.Year == 'Y1'){
    Maintenance <- subset(Maintenance,Year == 'Y0'| Year == 'Y1')
  }
  
  if(Harvest.Year == 'Y2'){
    Maintenance<- subset(Maintenance, Year == 'Y0'| Year == 'Y1' | Year == 'Y2')
  }
  
  ###### Cost of Goods Sold 
  
  # Set year start to August 1, Year and create an annual date matrix
  Year.Start <- ymd(Year.Start,truncated=2L) + 212
  Date.Frame <- data.frame(Year = seq(0,10,by=1), 
                           Date = seq(ymd(Year.Start),ymd(Year.Start %m+% years(10)),by = 'year'))
  Date.Frame$Date<- as.yearmon(Date.Frame$Date)
  
  
  Labor.COG <- Date.Frame
  # Calculate Costs for labor as the sum of part time and full time employee labor costs
  Labor.COG$Cost <- ifelse(Labor.COG$Year == 0, sum(subset(Labor, Year == 'Y0')$Labor.Cost,na.rm = TRUE) + (Employee.Salary*Full.Time.Employee),
                           ifelse(Labor.COG$Year == 1, sum(subset(Labor,Year != 'Y2'& Year != 'Y3')$Labor.Cost,na.rm = TRUE)+(Employee.Salary*Full.Time.Employee),
                                  ifelse(Labor.COG$Year == 2, sum(subset(Labor,  Year != 'Y3')$Labor.Cost,na.rm = TRUE)+(Employee.Salary*Full.Time.Employee),
                                         sum(Labor$Labor.Cost,na.rm = TRUE)+(Employee.Salary*Full.Time.Employee))))
  
  # Hours paid represents only part time employees as full time employees are considered paid annually
  Labor.COG$Hours <- ifelse(Labor.COG$Year == 0, sum(subset(Labor, Year == 'Y0')$Hours.Worked,na.rm = TRUE),
                            ifelse(Labor.COG$Year == 1, sum(subset(Labor,Year != 'Y2'& Year != 'Y3')$Hours.Worked,na.rm = TRUE),
                                   ifelse(Labor.COG$Year == 2, sum(subset(Labor,  Year != 'Y3')$Hours.Worked,na.rm = TRUE),
                                          sum(Labor$Hours.Worked,na.rm = TRUE))))
  # Cost of Goods Category
  Labor.COG$COG <- 'Labor'
  
  # Fuel 
  
  Fuel.COG <- Date.Frame
  # Calculate Fuel costs for truck and vessel, currently no accounting for additional fuel
  Fuel.COG$Cost <- ifelse(Fuel.COG$Year == 0, sum(subset(Fuel, Year == 'Y0')$Fuel.Cost,na.rm = TRUE),
                          ifelse(Fuel.COG$Year == 1, sum(subset(Fuel,Year != 'Y2'& Year != 'Y3')$Fuel.Cost,na.rm = TRUE),
                                 ifelse(Fuel.COG$Year == 2, sum(subset(Fuel,  Year != 'Y3')$Fuel.Cost,na.rm = TRUE),
                                        sum(Fuel$Fuel.Cost,na.rm = TRUE))))
  
  Fuel.COG$COG <- 'Fuel'
  
  # Maintenance
  
  Maintenance.COG <- Date.Frame
  # Calculate sum of all maintenance costs
  Maintenance.COG$Cost <- ifelse(Maintenance.COG$Year == 0, sum(subset(Maintenance, Year == 'Y0')$Maintenance.Cost,na.rm = TRUE),
                                 ifelse(Maintenance.COG$Year == 1, sum(subset(Maintenance,Year != 'Y2'& Year != 'Y3')$Maintenance.Cost,na.rm = TRUE),
                                        ifelse(Maintenance.COG$Year == 2, sum(subset(Maintenance,  Year != 'Y3')$Maintenance.Cost,na.rm = TRUE),
                                               sum(Maintenance$Maintenance.Cost,na.rm = TRUE))))
  
  Maintenance.COG$COG <- 'Maintenance'
  
  #Equipment
  
  Equipment.COG  <- Date.Frame
  # Calculate Equipment costs, initial purchases will be handled here while depreciation will be accounted for later
  Equipment.COG$Cost <- ifelse(Equipment.COG$Year == 0, sum(subset(Equipment, Year == 'Y0')$Cost.Basis,na.rm = TRUE) + sum(subset(Equipment, Year == 'Initial')$Cost.Basis,na.rm=TRUE),
                               ifelse(Equipment.COG$Year == 1, sum(subset(Equipment,Year == 'Y1')$Cost.Basis,na.rm = TRUE),
                                      ifelse(Equipment.COG$Year == 2, sum(subset(Equipment,  Year == 'Y2')$Cost.Basis,na.rm = TRUE),
                                             ifelse(Equipment.COG$Year == 3, sum(subset(Equipment,  Year == 'Y3')$Cost.Basis,na.rm = TRUE),
                                                    0))))
  
  Equipment.COG$COG <- 'Equipment'
  
  Consumables.COG <- Date.Frame
  Consumables.COG$Cost = Consumables
  Consumables.COG$COG = 'Consumables'
  
  COG <- bind_rows (Labor.COG,Equipment.COG,Fuel.COG,Maintenance.COG,Consumables.COG)
  COG <- dcast (COG, Year+Date ~ COG, value.var="Cost")
  
  
  # Calculate fixed overhead costs  
  
  # Insurance (summed in presets)  
  Insurance.FOC <- Date.Frame
  Insurance.FOC$Cost = Insurance
  Insurance.FOC$FOC = 'Insurance'
  # Annual Shellfish Aquaculture license fee
  SH.license.FOC <- Date.Frame
  SH.license.FOC$Cost = SH.License
  SH.license.FOC$FOC = 'Shellfish/AQ License'
  
  # Leasing fees, from DMR and updated annually with lease type, Application fee, and annual fixed fee
  Lease.Type.M <- data.frame(     # DMR lease type
    Type = c('Experimental Lease','LPA','Standard Lease'),     # DMR lease types
    App.Fee = c(0,100,1500),     # Application fee (1 time)
    Annual.Fee = c(50,100,100)     # Annual lease fee charged by the acre
  )
  
  # Set lease type from Preset
  Lease.Type.M <- subset(Lease.Type.M, Type == Lease.Type)
  
  LeaseRent.FOC <- Date.Frame
  LeaseRent.FOC$FOC = 'Lease Rent'
  LeaseRent.FOC$Cost <- ifelse(LeaseRent.FOC$Year == 0, Lease.Type.M$App.Fee + (Lease.Type.M$Annual.Fee*Lease.Footprint.Acres),
                               Lease.Type.M$Annual.Fee*Lease.Footprint.Acres)
  
  Owner.salary.FOC <- Date.Frame
  Owner.salary.FOC$Cost = Owner.salary
  Owner.salary.FOC$FOC = 'Owner Salary'
  
  # Depreciation information (rate of equipment replacement based on lifespan)
  Depreciation.FOC  <- Date.Frame
  Depreciation.FOC$Cost <- ifelse(Depreciation.FOC$Year == 0, sum(subset(Equipment, Year == 'Y0'|Year == 'Initial')$Depreciation,na.rm = TRUE),
                                  ifelse(Depreciation.FOC$Year == 1, sum(subset(Equipment, Year == 'Y0' | Year == 'Initial' | Year == 'Y1')$Depreciation,na.rm = TRUE),
                                         ifelse(Depreciation.FOC$Year == 2, sum(subset(Equipment, Year == 'Y0' | Year == 'Initial' | Year == 'Y1' | Year == 'Y2')$Depreciation,na.rm = TRUE),
                                                sum(Equipment$Depreciation,na.rm = TRUE))))
  Depreciation.FOC$FOC <- 'Depreciation'
  FOC <- bind_rows(Insurance.FOC,SH.license.FOC,LeaseRent.FOC,Owner.salary.FOC,Depreciation.FOC)
  FOC <- dcast (FOC, Year+Date~ FOC, value.var="Cost")
  
  # Calculate the total product sold based upon grow-out scenario (for now)
  Product.Sold  <- Date.Frame

  
  Y1.Mort.Q <- data.frame(Year = 'Y1', 
                          Season = c('Summer'),
                          Mortality = c(0), Ann.Mortality = Y1.Mortality,
                          Year.End = Y2.Product)
  Y1.Mort.Q <- Y1.Mort.Q %>% 
    mutate(Quarterly.Product = (1-Mortality*Ann.Mortality)*Year.End)
  
  Y2.Mort.Q <- data.frame(Year = 'Y2', 
                          Season = c('Fall','Winter','Spring','Summer'),
                          Mortality = c(.25,.5,.75,1.0), Ann.Mortality = Y2.Mortality,
                          Year.End = Y2.Product)
  Y2.Mort.Q <- Y2.Mort.Q %>% 
    mutate(Quarterly.Product = (1-Mortality*Ann.Mortality)*Year.End)
  
  Y3.Mort.Q <- data.frame(Year = 'Y3', 
                          Season = c('Fall','Winter','Spring','Summer'),
                          Mortality = c(.25,.5,.75,1.0), Ann.Mortality = Y3.Mortality,
                          Year.End = Y3.Product)
  Y3.Mort.Q <- Y3.Mort.Q %>% 
    mutate(Quarterly.Product = (1-Mortality*Ann.Mortality)*Year.End)
  
  Quarterly.Mortality <- rbind(Y1.Mort.Q,Y2.Mort.Q,Y3.Mort.Q)
  
  # Input model growth predictions
  
  Predicted.Full.Model <- subset(Predicted.full, Harvest.Time == Harvest.Season & Harvest.Y == Harvest.Year)
  
  #   Create if else statements for scenarios based on product for Lantern nets vs ear hanging
  #   And harvest in Y2 vs Y3
  
  Scenario.Y1 <- ifelse(Product.Sold$Year == 0, 0, # Yes
                        ifelse(Product.Sold$Year == 1, 0,
                               subset(Quarterly.Mortality, Year == Harvest.Year & Season == Harvest.Season)$Quarterly.Product))
  
  Scenario.Y2 <- ifelse(Product.Sold$Year == 0, 0,
                        ifelse(Product.Sold$Year == 1, 0,
                               ifelse(Product.Sold$Year == 2, 0,
                                      subset(Quarterly.Mortality, Year == Harvest.Year & Season == Harvest.Season)$Quarterly.Product)))
  
  Scenario.Y3 <- ifelse(Product.Sold$Year == 0, 0,
                        ifelse(Product.Sold$Year == 1, 0,
                               ifelse(Product.Sold$Year == 2, 0,
                                      ifelse(Product.Sold$Year == 3, 0,    
                                             subset(Quarterly.Mortality, Year == Harvest.Year & Season == Harvest.Season)$Quarterly.Product))))
  
  # Run ifelse statement to choose which scenario for total individuals harvested
  # Model assumes all harvest at a specific interval
  # if looking to harvest mutiple times, suggest running multiple scenarios on subsets of operation
  
  if (Harvest.Year == 'Y1'){ 
    Individuals = Scenario.Y1
    
  }
  
  if (Harvest.Year == 'Y2'){ 
    Individuals = Scenario.Y2
    
  }
  
  if (Harvest.Year == 'Y3'){ 
    Individuals = Scenario.Y3
    
  }
  
  # Assign to Product.Sold as whole individuals sold
  
  Product.Sold$Individuals <- Individuals
  
  
  # Calculate Shell Height in Inches
  
  
  Size <- subset(Predicted.Full.Model, Trial == Gear.Specification)$Sh_Height
  Product.Sold$Size <- Size
  # Add in predicted Adductor weight and shell height
  
  Weight.Adductor <- subset(Predicted.Full.Model, Trial == Gear.Specification)$Adductor.lbs
  Product.Sold$Weight.Adductor <- Weight.Adductor
  Product.Sold$Count.lbs <- 1/Product.Sold$Weight.Adductor
  
  # Merge costs by date year
  TE <- merge(COG,FOC, by = c('Date','Year'))
  # Sum up Total annual costs for FOC and COG
  TE$Total.Annual.Costs <- rowSums(TE[,3:12])
  # Merge with Product Sold
  TE <- merge(TE,Product.Sold, by = c('Date','Year'))
  # Calculate annual debt accrual 
  TE$Debt <- cumsum(TE$Total.Annual.Costs)
  # Calculate total individuals sold for farm
  TE$TotalScallop <- cumsum(TE$Individuals)
  # Calculates minimum price of sale to break even for whole scallop market
  TE$MinPrice.WholeScallop <- ifelse(TE$Individuals == 0, 0, TE$Total.Annual.Costs/TE$Individuals)
  # Calculates the annual break even sale price by year to immediately erase debt, asymptotes at minimum price of sale 
  TE$MaxPrice.WholeScallop <- ifelse(TE$Individuals == 0, 0, TE$Debt/TE$TotalScallop)
  # Calculate total lbs of scallops sold annually
  TE$AnnualScallop.AdductorWeight <- TE$Individuals*TE$Weight.Adductor
  # Calculate total individuals sold for farm
  TE$TotalScallop.AdductorWeight <- cumsum(TE$AnnualScallop.AdductorWeight)
  # Calculates minimum price of sale to break even for whole scallop market
  TE$MinPrice.AdductorWeight <- ifelse(TE$Individuals == 0, 0, TE$Total.Annual.Costs/TE$AnnualScallop.AdductorWeight)
  # Calculates the annual break even sale price by year to immediately erase debt, asymptotes at minimum price of sale 
  TE$MaxPrice.AdductorWeight <- ifelse(TE$Individuals == 0, 0, TE$Debt/TE$TotalScallop.AdductorWeight)
  # 
  TE$Lease.Footprint.Feet <- Lease.Footprint.feet
  TE$Lease.Footprint.Acres <- Lease.Footprint.Acres
  
  
  
  return(TE)
  
  # Calculate Total lease size
  
}
