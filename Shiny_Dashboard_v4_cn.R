library(shiny)
library(shinydashboard)
library(readr)
library(tidyr)
library(lubridate)
library(DT)
library(shinyvalidate)
library(shinyBS)
library(zoo)
library(shinyjs)
library(readxl) # For reading excel tables
library(dplyr) # For data manipulation
library(plyr)  # For data manipulation and to seemingly interfere with dplyr
library(hablar) # For the function 'retype' that assigns values to data frame columns (ie character or numeric)
library(ggplot2) # For graphics 
library(treemapify) # Create a treemap even though donut charts are prettier
library(openxlsx)
library(flextable)
library(grid)
library(magick)
library(cowplot)
library(tidyverse)

file_path <- "./Components_V4.xlsx"


###------------Model Run on Intital Conditions---------------------------
# if (!exists("Predicted.full")) {
#   # If the variable doesn't exist, run the specific R script
#   print("Running Growth_Input.R")
#   source("./Growth_Input.R")
#   print("Completed Running Growth_Input.R")
# }
#Just read in the Growth Input instead of running the whole program
Predicted.full <- read_excel(file_path, sheet = 'Growth_Input')


# Set file path for spreadsheet

# These are 'general' equipment inputs, labor tasks, fuel costs, and maintenance.  
# I envision these will be designed to essentially be the 'entry' sections while the following sheet 
# Will be the hard coding not meant to be altered.


# Load all equipment
Equipment.Data <- read_excel(file_path, sheet = 'Equipment')
# Quantity is switched to character initially to merge and allow for entry of specialized equipment
Equipment.Data$Quantity <- as.character(Equipment.Data$Quantity)

# Enter Task, fuel, and maintenance data
Task.Data <- read_excel(file_path, sheet = 'Labor')
Fuel.Data <- read_excel(file_path, sheet = 'Fuel')
Maint.Data <- read_excel(file_path, sheet = 'Maintenance')

#Lets go through how this would hypothetically work
#Given a set of inputs - such as equipment choices, essential costs, and other stuff

# Entry and vectorization of primary parameters
Primary.Parameter.Data<- read_excel(file_path, sheet = 'Primary')

# loops by row to take column 1 as the variable name, and column 2 as either a character or 
# numeric and vectorize via assign function
for (i in 1:nrow(Primary.Parameter.Data)) {
  VariableName <- as.character(Primary.Parameter.Data$VariableName[i])
  Value <- retype(Primary.Parameter.Data$Value[i,drop=TRUE]) 
  assign(VariableName, Value, envir = .GlobalEnv)
}

# Remove extra stuff for clarity and good data practice
rm(VariableName, Value)

# Let's add the secondary parameters
Secondary.Data<- read_excel(file_path, sheet = 'Secondary')

# Similar to primary, secondary parameters either based on farm layout or husbandry
for (i in 1:nrow(Secondary.Data)) {
  VariableName <- as.character(Secondary.Data$VariableName[i])
  Value <- retype(Secondary.Data$Value[i, drop=TRUE])
  Value <- eval(parse(text=Value))
  assign(VariableName, Value, envir = .GlobalEnv)
}

# Remove extra stuff for clarity and good data practice
rm(VariableName, Value)

# Example Here, primary input of harvest year switched from Y3 to Y2
# `Harvest Year` <- 'Y4'

# Subset by Harvest Year, Season and Grow Out Method
# This section creates vectors for subseting different criteria

# Creates vectors for Year steps
Y0 <- c('Y0','all')
Y1 <- c('Y0','Y1','all')
Y2 <- c('Y0','Y1','Y2','all')
Y3 <- c('Y0','Y1','Y2','Y3','all')
Y4 <- c('Y0','Y1','Y2','Y3','Y4','all')

Fall <- 'Fall'
Winter <- c('Fall','Winter')
Spring <- c('Fall','Winter','Spring')
Summer <- c('Fall','Winter','Spring','Summer')

# Matches Harvest Year vector with appropriate year vector
Harvest.Year <- switch(`Harvest Year`, 'Y0'= Y0, 'Y1' = Y1, 'Y2'= Y2, 'Y3'= Y3, 'Y4' = Y4)

# TBD creates a season vector for final labor allotment
Harvest.Season <- switch(`Harvest Season`, 'Fall'= Fall, 'Winter' = Winter, 'Spring'= Spring, 'Summer'= Summer)

# Market Data calculates seasonal mortality for available harvest times 
Market.Data <- read_excel(file_path, sheet = 'Market')
for (i in 1:nrow(Market.Data)) {
  # Evaluate the Quarterly Mortality
  Market.Data$Market.Product[i]<- as.numeric(eval(parse(text = Market.Data$Market.Product[i])))
}
# Change market data to numeric and subset from predicted growth based on harvest year, season, and grow out
Market.Data$Market.Product <- as.numeric(Market.Data$Market.Product)
Growth.Data <- subset(Predicted.full, Year == `Harvest Year`& Season == `Harvest Season`& Trial == `Grow Out Method`)
Growth.Data <- Growth.Data[,-c(1,2,3,5)]
Growth.Data <- left_join(Growth.Data, Market.Data, by = c('Year','Season'))

# Creates a farm strategy vector for subseting based on grow out type
Farm.strat <- c(`Grow Out Method`,`Spat Procurement`,`Intermediate Culture`,'Global')

# Equipment

# Read Equipment Outputs, subset by Harvest year and farm strategy then merge with Unit Cost, 
#Lifespan and quantity.  Also merge so that specialized and large equipment purchases can be entered
Equipment <- read_excel(file_path, sheet = 'Equipment_Output')
Equipment.Subset <- Equipment[which(Equipment$Year %in% Harvest.Year& Equipment$Type %in% Farm.strat),]
Equipment.Subset <- within(merge(Equipment.Subset,Equipment.Data, by = 'Equipment'), 
                           {Quantity <- ifelse(is.na(Quantity.y),Quantity.x,Quantity.y); Quantity.x <- NULL; Quantity.y <- NULL})

# Separate into year class equipment and global equipment.  Global equipment is the lease stuff that 
# is calculated dependent on year class stuff

Equipment.Subset.Year <- subset(Equipment.Subset, Type != 'Global')
Equipment.Subset.Global <- subset(Equipment.Subset, Type == 'Global')

#Equipment for used in farm strategy and harvest year
for (i in 1:nrow(Equipment.Subset.Year)) {
  # Evaluate the Quantity expression for this row, and do cost.basis and depreciation too
  Equipment.Subset.Year$Quantity[i] <- as.numeric(eval(parse(text = Equipment.Subset.Year$Quantity[i])))
  
  Equipment.Subset.Year$Cost.Basis[i] <- Equipment.Subset.Year$Unit.Cost[i] * as.numeric(eval(parse(text = Equipment.Subset.Year$Quantity[i])))
  
  Equipment.Subset.Year$Depreciation[i] <- Equipment.Subset.Year$Cost.Basis[i] / Equipment.Subset.Year$Lifespan[i]
}
# Change Quantity to numeric because I am not a good coder
Equipment.Subset.Year$Quantity <- as.numeric(Equipment.Subset.Year$Quantity)
# Overwrite main data frame with year data only
Equipment.Subset <- Equipment.Subset.Year

#Equipment for used in farm strategy and harvest year
for (i in 1:nrow(Equipment.Subset.Global)) {
  # Evaluate the Quantity expression for this row, and do cost.basis and depreciation too
  Equipment.Subset.Global$Quantity[i] <- as.numeric(eval(parse(text = Equipment.Subset.Global$Quantity[i])))
  
  Equipment.Subset.Global$Cost.Basis[i] <- Equipment.Subset.Global$Unit.Cost[i] * as.numeric(eval(parse(text = Equipment.Subset.Global$Quantity[i])))
  
  Equipment.Subset.Global$Depreciation[i] <- Equipment.Subset.Global$Cost.Basis[i] / Equipment.Subset.Global$Lifespan[i]
}
# Change Quantity to numeric because I am not a good coder
Equipment.Subset.Global$Quantity <- as.numeric(Equipment.Subset.Global$Quantity)

# bind the two frames and delete leftovers
Equipment.Subset <- rbind(Equipment.Subset,Equipment.Subset.Global)
rm(Equipment.Subset.Global, Equipment.Subset.Year)

# Labor tasks similar to equipment but introduce seasonality

# Read Labor Outputs, subset by Harvest year harvest season farm strategy then merge with tasks, rate, and part time
Labor <- read_excel(file_path, sheet = 'Labor_Output')
Labor.Subset <- left_join(Labor,Task.Data, by = 'Task')

# Assign Harvest task to final year and season
Labor.Subset$Year[Labor.Subset$Task == 'Harvest'] <- `Harvest Year`
Labor.Subset$Season[Labor.Subset$Task == 'Harvest'] <- `Harvest Season`

# Subset by Harvest Year, Farm type, and whether a task is completed (used for the cleaning)
Labor.Subset <- Labor.Subset[which(Labor.Subset$Year %in% Harvest.Year & Labor.Subset$Type %in% Farm.strat & Labor.Subset$Completed %in% 'Y'),]
Labor.Subset <- Labor.Subset[!(Labor.Subset$Year == `Harvest Year` & !(Labor.Subset$Season %in% Harvest.Season)), ]
# Create initialized columns because it annoys me to see a warnng message
Labor.Subset$Hours.Paid <- NA
Labor.Subset$Labor.Costs <- NA

for (i in 1:nrow(Labor.Subset)){
  Labor.Subset$Time[i] <- as.numeric(eval(parse(text = Labor.Subset$Time[i])))
  Labor.Subset$Trips[i] <- eval(parse(text = Labor.Subset$Trips[i]))
  Labor.Subset$Hours.Paid[i] <- ifelse(Labor.Subset$Trips[i] > 0, round_any(as.numeric(Labor.Subset$Time[i]), 8, f=ceiling), Labor.Subset$Time[i])
  Labor.Subset$Labor.Costs[i] <- as.numeric(Labor.Subset$Hours.Paid[i]) * `Part Time Wage` * Labor.Subset$Part.Time[i]
}
Labor.Subset$Time <- as.numeric(Labor.Subset$Time)
Labor.Subset$Trips <- as.numeric(Labor.Subset$Trips)

# Subset out Specialized equipment with quantity = 0 or time = Inf  
Labor.Subset <- subset(Labor.Subset, Time != Inf)
Equipment.Subset <- subset(Equipment.Subset, Quantity!=0)

# Read Fuel Outputs, subset to relevant, and merge with price.gallon and fuel.trip
Fuel <- read_excel(file_path, sheet = 'Fuel_Output')
Fuel.Subset <- left_join(Fuel,Fuel.Data, by = 'Vehicle') 

Fuel.Subset <- Fuel.Subset[which(Fuel.Subset$Year %in% Harvest.Year & Fuel.Subset$Type %in% Farm.strat),]
# Same as labor, this kicks back a warning message and it's just annoying  
Fuel.Subset$Fuel.Cost <- NA
#Fuel for a given period by year
for (i in 1:nrow(Fuel.Subset)){
  Fuel.Subset$Fuel.Cost[i] <- Fuel.Subset$Price.Gallon[i] * Fuel.Subset$Usage.Trip[i] * as.numeric((sum(Labor.Subset[which(Labor.Subset$Year == Fuel.Subset$Year[i]),6]) + Fuel.Subset$Additional.Trips[i]))
}

# Read Fuel Outputs, subset to relevant and ,merge with price.gallon and fuel.trip
Maintenance <- read_excel(file_path, sheet = 'Maintenance_Output')
Maintenance.Subset <- left_join(Maintenance,Maint.Data, by = 'Item') 

Maintenance.Subset <- Maintenance.Subset[which(Maintenance.Subset$Year %in% Harvest.Year & Maintenance.Subset$Type %in% Farm.strat),]

#Maintenance for a given period
for (i in 1:nrow(Maintenance.Subset)){
  Maintenance.Subset$Maintenance.Cost[i] <- as.numeric(eval(parse(text = Maintenance.Subset$Maintenance.Cost[i])))
}
Maintenance.Subset$Maintenance.Cost <- as.numeric(Maintenance.Subset$Maintenance.Cost)
# Alright, this should be the basic global data, if we add up all columns we should get the annual 
# values once all year classes have been introduced.  The below section is the fun stuff, 
# deliverable metrics!

# Metric ideas

# Total lease size and Cost
# Leases have three designations: Standard, LPA, and Experimental with different fees by acreage
# Take longline length, mooring length (distance along bottom), and Longline Spacing to calculate acreage

# Create data frame with Longline Quantity in it for 'reasons'
Lease.Footprint <- data.frame(`Longline Quantity`)
# total longline length is the total cost of global rope + bottom length of mooring rope (pythag)*2*number of longlines 
Lease.Footprint$Feet.Longline.Total <- Equipment.Subset$Quantity[Equipment.Subset$Equipment == 'Rope (1 inch)' & Equipment.Subset$Type == 'Global'] + 
  ((`Longline Quantity`*2) * sqrt(((`Longline Depth`-`Longline Suspended Depth`)*`Mooring Length`)^2 - (`Longline Depth`-`Longline Suspended Depth`)^2))
# Size of each longline in the event of multiple longlines
Lease.Footprint$l.Feet <- Lease.Footprint$Feet.Longline.Total/`Longline Quantity`
# Total meters for longline length (no m/longline as most growers won't find it relevant)
Lease.Footprint$Meters.Longline.Total <- Lease.Footprint$Feet.Longline.Total * .3048
# Total lease area in ft^2
Lease.Footprint$A.Feet <- Lease.Footprint$l.Feet * `Longline Spacing`
# Total lease area in m^2
Lease.Footprint$A.Meters <- Lease.Footprint$A.Feet * .3048

# This value is the Acreage which will be the most valuable statistic for growers
Lease.Footprint$Acres <- (Lease.Footprint$l.Feet*`Longline Spacing`)*.0000229568

# Leasing fees, from DMR and updated annually with lease type, Application fee, and annual fixed fee
Lease.Type.M <- data.frame(     # DMR lease type
  Type = c('Experimental Lease','LPA','Standard Lease'),     # DMR lease types
  App.Fee = c(0,100,1500),     # Application fee (1 time)
  Annual.Fee = c(50,100,100)     # Annual lease fee charged by the acre
)

# Set lease type from Preset
Lease.Type.M <- subset(Lease.Type.M, Type == `Lease Type`)

# Create year month

# Set year start to August 1, Year and create an annual date matrix
Year_0 <- ymd(`Starting Year`,truncated=2L) + months(7)
Date.Frame <- data.frame(Year = seq(0,10,by=1), 
                         Date = seq(ymd(Year_0),ymd(Year_0 %m+% years(10)),by = 'year'))
Date.Frame$Date<- as.yearmon(Date.Frame$Date)

# Labor metrics 
# Calculate total labor time by season, hours worked, hours paid, etc and rounded up work days 
# for pane 1 graph
Labor.Subset$Hours.Paid<- as.numeric(Labor.Subset$Hours.Paid)
Labor.metrics <- aggregate(cbind(Time,Trips,Labor.Costs,Hours.Paid)~Season,data = Labor.Subset, sum)
Labor.metrics$Work.Days <- round(Labor.metrics$Hours.Paid/8)  

# Economic Metrics
# Create a matrix to assign columns by their year class, growers might have to wait up to 4 years
# Prior to first sale and that leads to significant deferment of costs.
# Then add up total costs for all categories plus consumables == cost of goods sold.

# Create a cost of good sold data set starting with years  
COG <- Date.Frame  

# Sum equipment, Labor, Fuel, and Maintenance by year cumulatively until the 
# final year when it is a fully operational farm

COG$Equipment <- ifelse(COG$Year == 0,sum(Equipment.Subset$Cost.Basis[which(Equipment.Subset$Year=='Y0' | Equipment.Subset$Year=='all')]),
                        ifelse(COG$Year == 1,sum(Equipment.Subset$Cost.Basis[which(Equipment.Subset$Year== 'Y1')]),
                               ifelse(COG$Year == 2, sum(Equipment.Subset$Cost.Basis[which(Equipment.Subset$Year== 'Y2')]),
                                      ifelse(COG$Year == 3, sum(Equipment.Subset$Cost.Basis[which(Equipment.Subset$Year== 'Y3')]),0))))

COG$Labor <- ifelse(COG$Year == 0, sum(Labor.Subset$Labor.Costs[which(Labor.Subset$Year %in% Y0)]),
                    ifelse(COG$Year == 1, sum(Labor.Subset$Labor.Costs[which(Labor.Subset$Year %in% Y1)]),
                           ifelse(COG$Year == 2, sum(Labor.Subset$Labor.Costs[which(Labor.Subset$Year %in% Y2)]),
                                  ifelse(COG$Year == 3, sum(Labor.Subset$Labor.Costs[which(Labor.Subset$Year %in% Y3)]),
                                         sum(Labor.Subset$Labor.Costs)))))    

COG$Fuel <- ifelse(COG$Year == 0, sum(Fuel.Subset$Fuel.Cost[which(Fuel.Subset$Year %in% Y0)]),
                   ifelse(COG$Year == 1, sum(Fuel.Subset$Fuel.Cost[which(Fuel.Subset$Year %in% Y1)]),
                          ifelse(COG$Year == 2, sum(Fuel.Subset$Fuel.Cost[which(Fuel.Subset$Year %in% Y2)]),
                                 ifelse(COG$Year == 3, sum(Fuel.Subset$Fuel.Cost[which(Fuel.Subset$Year %in% Y3)]),
                                        sum(Fuel.Subset$Fuel.Cost))))) 

COG$Maintenance <- ifelse(COG$Year == 0, sum(Maintenance.Subset$Maintenance.Cost[which(Maintenance.Subset$Year %in% Y0)]),
                          ifelse(COG$Year == 1, sum(Maintenance.Subset$Maintenance.Cost[which(Maintenance.Subset$Year %in% Y1)]),
                                 ifelse(COG$Year == 2, sum(Maintenance.Subset$Maintenance.Cost[which(Maintenance.Subset$Year %in% Y2)]),
                                        ifelse(COG$Year == 3, sum(Maintenance.Subset$Maintenance.Cost[which(Maintenance.Subset$Year %in% Y3)]),
                                               sum(Maintenance.Subset$Maintenance.Cost)))))

# Add consumables which is just an annual odds and ends expense
COG$Consumables <- Consumables

# Sum for the Cost of Goods Sold
COG$`Cost of Goods Sold` <- rowSums(COG[,(3:6)])

# Note above, these are all variable costs

# Fixed overhead costs (FOC)
# Create a data frame for FOC costs annually.  These are mostly a flat annual fee except lease rent
# and depreciation which vary based on the initial application fee in year 0 and the time in which
# Equipment was first purchased/put to use
FOC <- Date.Frame

# Lease fees, consists of an initial application fee and then an annual fee based on acreage
FOC$Lease <- ifelse(FOC$Year == 0, 
                    Lease.Type.M$App.Fee + (Lease.Type.M$Annual.Fee*Lease.Footprint$Acres), 
                    Lease.Type.M$Annual.Fee*Lease.Footprint$Acres)
# Insurance is just the summed annual insurance payments
FOC$Insurance <- Insurance
# Annual shellfish aquaculture license fee
FOC$`Aquaculture License` <- `Shellfish License`
# Owner Salary is an annual payment amount to the owner
FOC$`Owner Salary` <- `Owner Salary`
# Full time employee salary is an annual salary multiplied by the number of full time employees
FOC$`Full Time Employee` <- `Full Time Employee` * `Employee Salary`
# Depreciation is based on the lifespan of a piece of equipment divided by the cost of the item.
# It is an unrealized expense in that the cash is not spent, but should be considered reinvested to
# replace gear in the future
FOC$Depreciation <- ifelse(COG$Year == 0,sum(Equipment.Subset$Depreciation[which(Equipment.Subset$Year %in% Y0)]),
                           ifelse(COG$Year == 1,sum(Equipment.Subset$Depreciation[which(Equipment.Subset$Year %in% Y1)]),
                                  ifelse(COG$Year == 2, sum(Equipment.Subset$Depreciation[which(Equipment.Subset$Year %in% Y2)]),
                                         ifelse(COG$Year == 3, sum(Equipment.Subset$Depreciation[which(Equipment.Subset$Year %in% Y3)]),
                                                sum(Equipment.Subset$Depreciation)))))
# Sum all rows for total annual fixed operating costs
FOC$`Fixed Overhead Costs` <- rowSums(FOC[,(3:8)]) 

# Annual costs irregardless of year and business plan
# Sum Insurance, Shelffish/Aq License, Lease Rent, Owner Salary, Depreciation (By year)
# These are fixed overhead costs, ie costs that cannot be circumvented 

# Cost of production is COG+FOC and is all realized and unrealized expenses...basically the total cost
COP <- data.frame(Date.Frame,COG$`Cost of Goods Sold`,FOC$`Fixed Overhead Costs`)
colnames(COP)[3] <- "Cost of Goods Sold"
colnames(COP)[4] <- "Fixed Overhead Costs"
COP$`Cost of Production` <- rowSums(COP[,3:4])
# Cumulative COP is what I am calling debt
COP$Debt <- cumsum(COP$`Cost of Production`)
# Scallops sold at market, this is a fixed amount
COP$`Individual Scallops` <-  ifelse(COP$Year == 0 & `Harvest Year` == 'Y0', Growth.Data$Market.Product,
                                     ifelse(COP$Year == 1 & `Harvest Year` == 'Y1', Growth.Data$Market.Product,
                                            ifelse(COP$Year == 2 & `Harvest Year` == 'Y2', Growth.Data$Market.Product,
                                                   ifelse(COP$Year == 3 & `Harvest Year` == 'Y3', Growth.Data$Market.Product,
                                                          ifelse(COP$Year >3 & `Harvest Year` %in% Y4, Growth.Data$Market.Product,0)))))
# Shell height in millimeters of market scallops
COP$`ShellHeight (mm)` <- ifelse(COP$`Individual Scallops` == 0, 0,Growth.Data$Sh_Height)
# Shell height in inches for market scallops, we will use imperial units for the 
# app since it is more valuable to fishermen
COP$`ShellHeight (Inches)` <- ifelse(COP$`Individual Scallops` == 0, 0,Growth.Data$Sh_Height.inches)
# Adductor weight in grams
COP$`Adductor (g)` <- ifelse(COP$`Individual Scallops` == 0, 0,Growth.Data$Adductor)
# Adductor weight in pounds
COP$`Adductor (lb)` <- ifelse(COP$`Individual Scallops` == 0, 0,Growth.Data$Adductor.lbs)
# The industry standard for sale is as the amount of adductor meats in a pound.
# Also called count per pound.  It's a psuedo weight binning strategy.
# In general 30 count is small, 20 count is pretty normal and U10 is a large premium scallop
# This isn't used in the calculations but is valuable to growers at a glance
COP$`Adductor Count per lb` <- ifelse(COP$`Individual Scallops` == 0, 0,Growth.Data$count.lbs)
# calculate run rate and break even price for scallops, run rate is essentially constant
# and breka even is averaged out over time.  run rate is the asymptote for break even curve
COP$`Run Rate (Whole Scallop)` <- COP$`Cost of Production`/COP$`Individual Scallops`
COP$`Break Even Price (Whole Scallop)` <- COP$Debt/cumsum(COP$`Individual Scallops`)
COP$`Run Rate (Adductor)` <- COP$`Cost of Production`/(COP$`Individual Scallops`*COP$`Adductor (lb)`)
COP$`Break Even Price (Adductor)` <- COP$Debt/cumsum((COP$`Individual Scallops`*COP$`Adductor (lb)`))
COP <- COP %>% 
  mutate_if(is.numeric, round,digits=2)
COP$Date <- year(COP$Date)
COP$`Individual Scallops` <- round(COP$`Individual Scallops`, digits = 0)


# COG + FOC = Cost of Production
# We calculate from here two values, 10 year break even and run rate.
# 10 year break even takes all 10 years of COP, sums them, and then averages by total scallop
# sales (Individuals & Price/lb).  Run rate assumes no initial debt for equipment purchases.

# COP, break even, and run rate used in analysis  

# Next allow growers to set a price (maybe in primary inputs?) or in this section if possible
# Allow entry of scallop price/individual and adductor/lbs
Whole.Scallop.Price <- 3.50
ScallopAdductor.lbs <- 30

# gross profit, 10 year forecast
# subtract COGs from the total scallops sold each year (or total lbs sold each year) * Price (total revenue)
# so we have gross sales revenue = total income from product, gross profit is that minus COGS
# Margin is the percent difference between gross profit and sales revenue
# Net profit adds in FOC and profit margin is sales revenue and COP differences
# Finally depreciation is taken out as an unrealized expense for physical cash flow.

PL.add <- Date.Frame
PL.add$`Gross Sales Revenue` <- ScallopAdductor.lbs*(COP$`Individual Scallops`*Growth.Data$Adductor.lbs)
PL.add$`Gross Profit` <- PL.add$`Gross Sales Revenue` - COP$`Cost of Goods Sold` 
PL.add$`Gross Profit Margin` <- (PL.add$`Gross Profit`/PL.add$`Gross Sales Revenue`)*100
PL.add$`Net Profit` <- PL.add$`Gross Profit` - COP$`Fixed Overhead Costs`
PL.add$`Net Profit Margin` <- (PL.add$`Net Profit`/PL.add$`Gross Sales Revenue`)*100
PL.add$Depreciation <- FOC$Depreciation
PL.add$`Year End Cash Flow` <- cumsum(PL.add$`Net Profit`-FOC$Depreciation)

PL.Whole <- Date.Frame
PL.Whole$`Gross Sales Revenue` <- Whole.Scallop.Price*COP$`Individual Scallops`
PL.Whole$`Gross Profit` <-  PL.Whole$`Gross Sales Revenue` - COP$`Cost of Goods Sold` 
PL.Whole$`Gross Profit Margin` <-  (PL.Whole$`Gross Profit`/PL.Whole$`Gross Sales Revenue`)*100
PL.Whole$`Net Profit` <-  PL.Whole$`Gross Profit` - COP$`Fixed Overhead Costs`
PL.Whole$`Net Profit Margin` <-  (PL.Whole$`Net Profit`/ PL.Whole$`Gross Sales Revenue`)*100
PL.Whole$Depreciation <- FOC$Depreciation
PL.Whole$`Year End Cash Flow` <- cumsum(PL.Whole$`Net Profit`-FOC$Depreciation)
# Net Profit, 10 years
# Subtract FOC from GP to get net profit

# Finally, free cash flow. 10 years
# Free cash flow is the Net profit summed annually with depreciation removed (since it is a non-realized expense)
# and this will be the cash you have 'in hand' at the end of each year

# For analysis we will also be using IRR (Internal rate of return) 
# in one instance but will mostly be using break even and run rate

# For the outputs, I think these should tentatively be what we give.

# Pane 1 - Run Rate (whole and adductor), Break even 10 year (whole and adductor), Minimum lease size

Pane1 <- data.frame('Market Individuals' = Growth.Data$Market.Product,
                    'Shell Height (Inches)' = Growth.Data$Sh_Height.inches,
                    'Adductor Count/lb' = Growth.Data$count.lbs,
                    'Run Rate (lbs)' = subset(COP, Year == 10)$`Run Rate (Adductor)`, 
                    'Run Rate (Piece)' = subset(COP, Year == 10)$`Run Rate (Whole Scallop)`,
                    '10 Year Break Even (lbs)' = subset(COP, Year == 10)$`Break Even Price (Adductor)`,
                    '10 Year Break Even (Piece)' = subset(COP, Year == 10)$`Break Even Price (Whole Scallop)`,
                    'Minimum Lease Size (Acres)' = Lease.Footprint$Acres)
Pane1 <- round(Pane1, digits = 2)
# Labor metrics I think would also be simple and helpful by season (or by year?)

LAB_plt <- ggplot(Labor.Subset, aes(area=Hours.Paid/8, fill = Season, label=paste(Category, 
                                                                                  (Hours.Paid/8), sep = "\n Work Days:"), subgroup=Season))  + 
  geom_treemap(layout="squarified")+
  geom_treemap_text(colour = "black",
                    place = "centre",
                    size = 10) +
  geom_treemap_subgroup_border(colour = "white", size = 2) +
  theme_minimal() +
  scale_fill_manual(values = c('#e09f3e','#559e2c','#15b2d3','#66676d' )) +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  ggtitle("Annual Work Days by Season and Task") +
  theme(panel.border = element_rect(colour = "black", fill=NA, size=1))

# Next, visual representation of COG and FOC

COG.plot <- COG[,-8]
COG.plot <- gather(COG.plot, key= 'Category', value = 'Cost', Equipment,Labor,Fuel,Maintenance,Consumables)
COG.plot$Year<- as.factor(COG.plot$Year)

COG_plt <- ggplot(COG.plot, aes(x=Year, y = Cost, fill = Category))  + 
  geom_bar(aes(),stat='identity')+
  theme_minimal() +
  scale_fill_brewer(palette = 'Set1') +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  ggtitle("10 Year Cost of Goods Sold Breakdown") +
  ylab("Cost ($USD)")+
  xlab("Business Year")+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=1))

FOC.Plot <- FOC[,-9]
FOC.Plot <- gather(FOC.Plot, key = 'Category',value = 'Cost', Lease,Insurance,`Aquaculture License`,`Owner Salary`,`Full Time Employee`,Depreciation)
FOC.Plot <- subset(FOC.Plot, Year == 10)
FOC.Plot$Year <- as.factor(FOC.Plot$Year)


FOG_plt <- ggplot(FOC.Plot, aes(x=Cost, y = Year, fill = Category))  + 
  geom_bar(aes(),stat='identity')+
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  ggtitle("Annual Fixed Operating Cost Breakdown") +
  xlab("Cost ($USD)")+
  theme(panel.border = element_rect(colour = "gray20", fill=NA, size=.5),
        axis.title.y = element_blank(),
        axis.text.y = element_blank())

plt.List <- list(LAB_plt = LAB_plt, COG_plt = COG_plt, FOG_plt = FOG_plt)

####### I think these will be a solid 'At a Glance' Section

# Next pane allows growers to select price (which is set above)

# Final Pane is a more traditional breakdown of Labor Metrics in a Table format for adductor and whole scallops
# We can also include IRR and maybe allow them to set discounting rate but that is down the line
# Let's get it working first

Pane2.Adductor <- PL.add
Pane2.Adductor <- Pane2.Adductor %>% 
  mutate_if(is.numeric, round,digits=2)
Pane2.Adductor[Pane2.Adductor == -Inf] <- 'No Revenue'
Pane2.Adductor <- t(Pane2.Adductor)

Pane2.Whole <- PL.Whole
Pane2.Whole <- Pane2.Whole %>% 
  mutate_if(is.numeric, round,digits=2)
Pane2.Whole[Pane2.Whole == -Inf] <- 'No Revenue'
Pane2.Whole <- t(Pane2.Whole)


# Finally, a Downloadable series of tables in an excel or .csv format including:
# Equipment, Labor, Fuel, and Maintenance tables + Primary and secondary inputs and Pane2 contents

Output.List <- list("Economic Metrics (Adductor)" = Pane2.Adductor, 
                    "Economic Metrics (Whole)" = Pane2.Whole,
                    "Cost of Production" = COP,
                    "Equipment" = Equipment.Subset,
                    "Labor" = Labor.Subset,
                    "Fuel" = Fuel.Subset,
                    "Maintenance" = Maintenance.Subset,
                    "Primary Inputs" = Primary.Parameter.Data,
                    "Secondary" = Secondary.Data)



###-----------------------------Define UI------------------------------------------------------
ui <- dashboardPage(
  dashboardHeader(title = "Build Your Scallop Farm", titleWidth = 250),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Primary Inputs", tabName = "input1", icon = icon("gears")),
      menuItem("Secondary Inputs", tabName = "input2", icon = icon("sliders")),
      menuItem("Farm at a Glance", tabName = "Plots", icon = icon("chart-simple")),
      menuItem("Detailed Metrics", tabName = "Output", icon = icon("table")),
      actionButton("run_model", "Run Model")
    )
  ),
  #-------------------------------------PRIMARY INPUTS -> UI Only--------------------------------------------------------------------------------------------------------------
  ###
  dashboardBody(
    useShinyjs(),
    tabItems(
      # First tab content (Input1)
      tabItem(
        tabName = "input1",
        fluidPage(
          uiOutput("primary_inputs")
        )
      ),
      
      ###----------------------Secondary Inputs -> UI Only-----------------------------------------------------------------------------------------------------------
      # Second tab content (Input2)
      tabItem(
        tabName = "input2",
        fluidPage(
          uiOutput("secondary_inputs"),
          
          box(
            title = "Yearly Products:",
            width = 4,
            textOutput("Y1_Product"),
            textOutput("Y2_Product"),
            textOutput("Y3_Product"),
            textOutput("Y4_Product")
          )
        )
      ),
      
      ### ----------------------------------Plots Output Tab------------------------------------------------------
      tabItem(
        tabName = "Plots",
        fluidPage(
          fluidRow(
            column(6,
                   {
                     box(title = "Labor Costs",
                         width = 12,
                         plotOutput('LAB')
                     )
                   }
            ),
            column(6,
                   {
                     box(title = "Cost of Good Sold",
                         width = 12,
                         plotOutput('COG')
                     )
                   }
            ),
            column(6,
                   {
                     box(title = "Fixed Overhead Costs",
                         width = 12,
                         plotOutput('FOG')
                     )
                   }
            ),
            column(6,
                   {
                     box(title = "Primary Variables",
                         width = 12,
                         plotOutput('VarsTable')
                     )
                   })
            
          )
          
          # box(title = "Labor Costs",
          #     width = 12,
          #     plotOutput('LAB')
          # ),
          # box(title = "Cost of Good Sold",
          #     width = 12,
          #     plotOutput('COG')
          # ),
          # box(title = "Fixed Overhead Costs",
          #     width = 12,
          #     plotOutput('FOG')
          # )
        )
      ),
      ### --------------Outputs Pane----------------------------------------------------------------------------------------------      
      # Third tab content (Output)
      tabItem(
        tabName = "Output",
        fluidPage(
          box(
            title = "Set Costs",
            width = 12,
            fluidRow(
              
              column(width = 6,
                     numericInput("Whole.Scallop.Price", "Whole Scallop Price:", min = 0.05, max = 20, value = 3.5, step = 1)
              ),
              column(width = 6,
                     numericInput("ScallopAdductor.lbs", "Scallop Adductor (lbs):", min = 10, max = 70, value = 30, step = 1)
              )
            )
            
          ),
          
          tabsetPanel(
            tabPanel("Economic Metrics (Adductor)",
                     dataTableOutput("Economic.Metrics.Adductor")
            ),
            tabPanel("Economic Metrics (Whole)",
                     dataTableOutput("Economic.Metrics.Whole")
            ),
            tabPanel("Cost of Production",
                     dataTableOutput("Cost.Production")
            ),
            tabPanel("Equipment Costs",
                     dataTableOutput("Equipment")
            ),
            tabPanel("Labor",
                     dataTableOutput("Labor")
            ),
            tabPanel("Fuel Cost",
                     dataTableOutput("Fuel")
            ),
            tabPanel("Maintenance Costs",
                     dataTableOutput("Maintenance")
            ),
            tabPanel("Primary Inputs",
                     dataTableOutput("Primary")
            ),
            tabPanel("Secondary Inputs",
                     dataTableOutput("Secondary")
            )
          ),
          downloadButton("save_button", "Save Excel Workbook")
        )
      )
    )
  ))



### --------------------------------SERVER--------------------------------------------------------------
# God Help Us
server <- function(input, output) {
  
  load_all_tabs <- function() {
    shinyjs::runjs("$('.nav-tabs a[data-toggle=\"tab\"]').each(function() { $(this).click(); });")
  }
  load_all_tabs()
  ### --------Processing Mortality and Dropper Product Calculations----------------------------------------------------------------------------------------
  #Initilizing Model results
  Output.List <- reactiveValues(Output.List = Output.List)              #these represent the variable that are defined going into it
  plt.List <- reactiveValues(plt.List = plt.List)
  
  #Processing Mortality Product Calculations
  Mort.Calcs <- reactiveValues(Y1.Product = NULL, 
                               Y2.Product = NULL, 
                               Y3.Product = NULL, 
                               Y4.Product = NULL, 
                               Ear.Hanging.Droppers = NULL, 
                               Dropper.Length = NULL)
  
  observe({                                  #This is where calculations occur
    Mort.Calcs$Y1.Product <- input$pe * (1 - input$sg)
    Mort.Calcs$Y2.Product <- Mort.Calcs$Y1.Product * (1 - input$sh)
    Mort.Calcs$Y3.Product <- Mort.Calcs$Y2.Product * (1 - input$si)
    Mort.Calcs$Y4.Product <- Mort.Calcs$Y3.Product * (1 - input$sj)
    Mort.Calcs$Ear.Hanging.Droppers <- ceiling((Mort.Calcs$Y2.Product/input$sac))
    Mort.Calcs$Dropper.Length <- ((input$sac * input$sad)/2 + input$sae)
  })
  
  
  # Update the text output when any of the input variables change
  output$Y1_Product <- renderText({
    return(paste("Y1.Product: ", round(Mort.Calcs$Y1.Product, 0)))
  })
  
  output$Y2_Product <- renderText({
    return(paste("Y2.Product: ", round(Mort.Calcs$Y2.Product, 0)))
  })
  
  output$Y3_Product <- renderText({
    return(paste("Y3.Product: ", round(Mort.Calcs$Y3.Product, 0)))
  })
  
  output$Y4_Product <- renderText({
    return(paste("Y4.Product: ", round(Mort.Calcs$Y4.Product, 0)))
  })
  
  output$Ear.Hanging.Droppers <- renderText({
    return(paste("Ear.Hanging.Droppers: ", round(Mort.Calcs$Ear.Hanging.Droppers, 0)))
  })
  
  output$Dropper.Length <- renderText({
    return(paste("Dropper.Length: ", round(Mort.Calcs$Dropper.Length, 0)))
  })
  
  
  
  # ---------Placeholder for Additional stuff----------------------------------------------------------------------------------------------------------------------
  # Placeholder for model execution
  # observeEvent(input$run_model, {
  #   # Replace this with your actual model logic
  #   result <- paste(input$param1, input$param2)
  #   
  #   # Display the output on the second tab
  #   output$output_text <- renderPrint({
  #     print(result)
  #   })
  #   output$output_text2 <- renderPrint({
  #     print(result)
  #   })
  # })
  # 
  ### -------Rendering Graphical Outputs-----------------------------------------------------------------------------------------------------  
  output$LAB <- renderPlot(plt.List$plt.List$LAB_plt)
  output$COG <- renderPlot(plt.List$plt.List$COG_plt)
  output$FOG <- renderPlot(plt.List$plt.List$FOG_plt)
  output$VarsTable <- renderPlot(plt.List$plt.List$VarsTable)
  
  
  
  ### -------Rendering table outputs-----------------------------------------------------------------------------------------------------  
  #Making a spreadsheet - for now this doesnt respond to running the moddle as the model isn't implimented
  # Its reading from the Output.List
  
  output$Economic.Metrics.Adductor <- renderDataTable(
    datatable(Output.List$Output.List$`Economic Metrics (Adductor)`,
              options = list(paging = FALSE,    ## paginate the output
                             scrollX = TRUE,   ## enable scrolling on X axis
                             scrollY = TRUE,   ## enable scrolling on Y axis
                             autoWidth = FALSE, ## use smart column width handling
                             server = FALSE,  ## use client-side processing
                             searching = FALSE,
                             info = FALSE,
                             dom = 'Bfrtip',     ##Bfrtip
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              selection = 'single', ## enable selection of a single row
              filter = 'none',              ## include column filters at the bottom
              rownames = TRUE, colnames = rep("", ncol(Output.List$Output.List$`Economic Metrics (Adductor)`))       ## don't show row numbers/names
    ))
  
  output$Economic.Metrics.Whole <- renderDataTable(
    datatable(Output.List$Output.List$`Economic Metrics (Whole)`,
              options = list(paging = FALSE,    ## paginate the output
                             scrollX = TRUE,   ## enable scrolling on X axis
                             scrollY = TRUE,   ## enable scrolling on Y axis
                             autoWidth = FALSE, ## use smart column width handling
                             server = FALSE, ## use client-side processing
                             search = NULL,
                             searching = FALSE,
                             info = FALSE,
                             dom = 'Bfrtip',
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              selection = 'single', ## enable selection of a single row
              filter = 'none',              ## include column filters at the bottom
              rownames = TRUE,
              colnames = rep("", ncol(Output.List$Output.List$`Economic Metrics (Whole)`))
    ))
  
  output$Cost.Production <- renderDataTable(
    datatable(Output.List$Output.List$`Cost of Production`,
              options = list(paging = FALSE,    ## paginate the output
                             scrollX = TRUE,   ## enable scrolling on X axis
                             scrollY = TRUE,   ## enable scrolling on Y axis
                             autoWidth = FALSE, ## use smart column width handling
                             server = FALSE, ## use client-side processing
                             search = NULL,
                             searching = FALSE,
                             info = FALSE,
                             dom = 'Bfrtip',
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              selection = 'single', ## enable selection of a single row
              filter = 'none',              ## include column filters at the bottom
              rownames = FALSE       ## don't show row numbers/names
    )
  )
  
  output$Equipment <- renderDataTable(
    datatable(Output.List$Output.List$Equipment,
              options = list(paging = FALSE,    ## paginate the output
                             scrollX = TRUE,   ## enable scrolling on X axis
                             scrollY = TRUE,   ## enable scrolling on Y axis
                             autoWidth = FALSE, ## use smart column width handling
                             server = FALSE, ## use client-side processing
                             search = NULL,
                             searching = FALSE,
                             info = FALSE,
                             dom = 'Bfrtip',
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              selection = 'single', ## enable selection of a single row
              filter = 'none',              ## include column filters at the bottom
              rownames = FALSE      ## don't show row numbers/names
    )
  )
  
  output$Labor <- renderDataTable(
    datatable(Output.List$Output.List$Labor,
              options = list(paging = FALSE,    ## paginate the output
                             scrollX = TRUE,   ## enable scrolling on X axis
                             scrollY = TRUE,   ## enable scrolling on Y axis
                             autoWidth = FALSE, ## use smart column width handling
                             server = FALSE, ## use client-side processing
                             search = NULL,
                             searching = FALSE,
                             info = FALSE,
                             dom = 'Bfrtip',
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              selection = 'single', ## enable selection of a single row
              filter = 'none',              ## include column filters at the bottom
              rownames = FALSE     ## don't show row numbers/names
    )
  )
  
  output$Fuel <- renderDataTable(
    datatable(Output.List$Output.List$Fuel,
              options = list(paging = FALSE,    ## paginate the output
                             scrollX = TRUE,   ## enable scrolling on X axis
                             scrollY = TRUE,   ## enable scrolling on Y axis
                             autoWidth = FALSE, ## use smart column width handling
                             server = FALSE, ## use client-side processing
                             search = NULL,
                             searching = FALSE,
                             info = FALSE,
                             dom = 'Bfrtip',
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              selection = 'single', ## enable selection of a single row
              filter = 'none',              ## include column filters at the bottom
              rownames = FALSE       ## don't show row numbers/names
    )
  )
  
  output$Maintenance <- renderDataTable(
    datatable(Output.List$Output.List$Maintenance,
              options = list(paging = FALSE,    ## paginate the output
                             scrollX = TRUE,   ## enable scrolling on X axis
                             scrollY = TRUE,   ## enable scrolling on Y axis
                             autoWidth = FALSE, ## use smart column width handling
                             server = FALSE, ## use client-side processing
                             search = NULL,
                             searching = FALSE,
                             info = FALSE,
                             dom = 'Bfrtip',
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              selection = 'single', ## enable selection of a single row
              filter = 'none',              ## include column filters at the bottom
              rownames = FALSE       ## don't show row numbers/names
    )
  )
  
  output$Primary <- renderDataTable({
    # print(Output.List$Output.List$`Primary Inputs`)
    datatable(Output.List$Output.List$`Primary Inputs`,
              options = list(paging = FALSE,    ## paginate the output
                             scrollX = TRUE,   ## enable scrolling on X axis
                             scrollY = TRUE,   ## enable scrolling on Y axis
                             autoWidth = FALSE, ## use smart column width handling
                             server = FALSE, ## use client-side processing
                             search = NULL,
                             searching = FALSE,
                             info = FALSE,
                             dom = 'Bfrtip',
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              selection = 'single', ## enable selection of a single row
              filter = 'none',              ## include column filters at the bottom
              rownames = FALSE       ## don't show row numbers/names
    )
  })
  
  output$Secondary <- renderDataTable(
    datatable(Output.List$Output.List$Secondary,
              options = list(paging = FALSE,    ## paginate the output
                             scrollX = TRUE,   ## enable scrolling on X axis
                             scrollY = TRUE,   ## enable scrolling on Y axis
                             autoWidth = FALSE, ## use smart column width handling
                             server = FALSE, ## use client-side processing
                             search = NULL,
                             searching = FALSE,
                             info = FALSE,
                             dom = 'Bfrtip',
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              selection = 'single', ## enable selection of a single row
              filter = 'none',              ## include column filters at the bottom
              rownames = FALSE       ## don't show row numbers/names
    )
  )
  
  ###---------------------------------------Procedural Inputs!!--------------------------------------------------
  
  iv <- InputValidator$new()
  
  Primary.Parameter.Data<- read_excel(file_path, sheet = 'Primary')
  output$primary_inputs <- renderUI({
    unique_groups <- unique(Primary.Parameter.Data$Group)
    
    # For each unique group, create a separate box
    box_list <- lapply(unique_groups, function(group) {
      group_data <- subset(Primary.Parameter.Data, Group == group)
      
      input_list <- lapply(1:nrow(group_data), function(i) {
        info <- group_data[i, ]
        if (info$Type == "cat") {
          tagList(
            selectInput(info$ID, info$VariableName, choices = strsplit(info$Range, ",")[[1]], selected = info$Value),
            bsTooltip(info$ID, title = info$toolTip)
          )
        } else if (info$Type == "slider") {
          tagList(
            sliderInput(info$ID, info$VariableName, min = info$Min, max = info$Max, value = info$Value),
            bsTooltip(info$ID, title = info$toolTip)
          )
        } else if (info$Type == "num") {
          if (info$IntOnly){iv$add_rule(info$ID, sv_integer())}
          iv$add_rule(info$ID, sv_between(info$Min, info$Max))
          tagList(
            numericInput(info$ID, info$VariableName, min = info$Min, max = info$Max, value = info$Value, step = 1),
            bsTooltip(info$ID, title = info$toolTip)
          )
          
        }
      })
      
      box(
        title = group,
        status = "info",
        solidHeader = TRUE,
        width = 6,
        do.call(tagList, input_list)
      )
    })
    
    do.call(tagList, box_list)
  })
  
  Secondary.Data<- read_excel(file_path, sheet = 'Secondary')
  Secondary.Data <- Secondary.Data[!is.na(Secondary.Data$Type), ]
  
  output$secondary_inputs <- renderUI({
    unique_groups <- unique(Secondary.Data$Group)
    
    # For each unique group, create a separate box
    box_list <- lapply(unique_groups, function(group) {
      group_data <- subset(Secondary.Data, Group == group)
      
      input_list <- lapply(1:nrow(group_data), function(i) {
        info <- group_data[i, ]
        if (info$Type == "cat") {
          tagList(
            selectInput(info$ID, info$VariableName, choices = strsplit(info$Range, ",")[[1]], selected = info$Value),
            bsTooltip(info$ID, title = info$toolTip)
          )
        } else if (info$Type == "slider") {
          tagList(
            sliderInput(info$ID, info$VariableName, min = info$Min, max = info$Max, value = info$Value),
            bsTooltip(info$ID, title = info$toolTip)
          )
        } else if (info$Type == "num") {
          if (info$IntOnly){iv$add_rule(info$ID, sv_integer())}
          iv$add_rule(info$ID, sv_between(info$Min, info$Max))
          tagList(
            numericInput(info$ID, info$VariableName, min = info$Min, max = info$Max, value = info$Value),
            bsTooltip(info$ID, title = info$toolTip)
          )
        }
      })
      
      box(
        title = group,
        status = "info",
        solidHeader = TRUE,
        width = 6,
        if (group == "Ear Hanging Parameters"){
          input_list <- append(input_list, tagList(textOutput("Ear.Hanging.Droppers"),
                                                   textOutput("Dropper.Length")))
          do.call(tagList, input_list)
        }else{
          do.call(tagList, input_list)
          
        }
        
      )
    })
    
    do.call(tagList, box_list)
  })
  
  iv$enable()
  
  
  ###----------Observe Model Run-------------------------------------------------------------------------------------------------------------------  
  observeEvent(input$run_model, {#Fake running of the model - updates all the thingy
    if (!iv$is_valid()) {
      showNotification(
        "Please fix the errors in the model before continuing",
        type = "error"
      )
    } else {
      
    #Procedural Adding in the input variables
    pInput.List <- Primary.Parameter.Data$ID[!is.na(Primary.Parameter.Data$ID)]
    pVar.Names <- Primary.Parameter.Data$VariableName[!is.na(Primary.Parameter.Data$ID)]
    
    for (i in c(1:length(pInput.List))){
      inputName <- pInput.List[i]
      inputValue <- input[[inputName]]
      globName <- pVar.Names[i]
      assign(globName, inputValue, envir = .GlobalEnv)
      Primary.Parameter.Data$Value[Primary.Parameter.Data$VariableName == globName] <- as.character(inputValue)
    }
    
    sInput.List <- Secondary.Data$ID[!is.na(Secondary.Data$ID)]
    sVar.Names <- Secondary.Data$VariableName[!is.na(Secondary.Data$ID)]
    
    for (i in c(1:length(sInput.List))){
      inputName <- sInput.List[i]
      inputValue <- input[[inputName]]
      globName <- sVar.Names[i]
      assign(globName, inputValue, envir = .GlobalEnv)
      Secondary.Data$Value[Secondary.Data$VariableName == globName] <- as.character(inputValue)
      
    }
    
    `Y1 Product` <- Mort.Calcs$Y1.Product
    `Y2 Product` <- Mort.Calcs$Y2.Product
    `Y3 Product` <- Mort.Calcs$Y3.Product
    `Y4 Product` <- Mort.Calcs$Y4.Product
    `Ear Hanging Droppers` <-  Mort.Calcs$Ear.Hanging.Droppers
    `Dropper Length` <-  Mort.Calcs$Dropper.Length
    
    # Updating the primary and second 
    
    
    ###--------This is the normal Model stuff---------------------------------------------------------------------------------------
    #Twst to make sure some change occurs!
    #`Harvest Year` <- 'Y4'
    
    
    # Creates vectors for Year steps
    Y0 <- c('Y0','all')
    Y1 <- c('Y0','Y1','all')
    Y2 <- c('Y0','Y1','Y2','all')
    Y3 <- c('Y0','Y1','Y2','Y3','all')
    Y4 <- c('Y0','Y1','Y2','Y3','Y4','all')
    
    Fall <- 'Fall'
    Winter <- c('Fall','Winter')
    Spring <- c('Fall','Winter','Spring')
    Summer <- c('Fall','Winter','Spring','Summer')
    
    # Matches Harvest Year vector with appropriate year vector
    Harvest.Year <- switch(`Harvest Year`, 'Y0'= Y0, 'Y1' = Y1, 'Y2'= Y2, 'Y3'= Y3, 'Y4' = Y4)
    
    # TBD creates a season vector for final labor allotment
    Harvest.Season <- switch(`Harvest Season`, 'Fall'= Fall, 'Winter' = Winter, 'Spring'= Spring, 'Summer'= Summer)
    
    # Market Data calculates seasonal mortality for available harvest times 
    Market.Data <- read_excel(file_path, sheet = 'Market')
    for (i in 1:nrow(Market.Data)) {
      # Evaluate the Quarterly Mortality
      Market.Data$Market.Product[i]<- as.numeric(eval(parse(text = Market.Data$Market.Product[i])))
    }
    # Change market data to numeric and subset from predicted growth based on harvest year, season, and grow out
    Market.Data$Market.Product <- as.numeric(Market.Data$Market.Product)
    Growth.Data <- subset(Predicted.full, Year == `Harvest Year`& Season == `Harvest Season`& Trial == `Grow Out Method`)
    Growth.Data <- Growth.Data[,-c(1,2,3,5)]
    Growth.Data <- left_join(Growth.Data, Market.Data, by = c('Year','Season'))
    
    # Creates a farm strategy vector for subseting based on grow out type
    Farm.strat <- c(`Grow Out Method`,`Spat Procurement`,`Intermediate Culture`,'Global')
    
    # Equipment
    
    # Read Equipment Outputs, subset by Harvest year and farm strategy then merge with Unit Cost, 
    #Lifespan and quantity.  Also merge so that specialized and large equipment purchases can be entered
    Equipment <- read_excel(file_path, sheet = 'Equipment_Output')
    Equipment.Subset <- Equipment[which(Equipment$Year %in% Harvest.Year& Equipment$Type %in% Farm.strat),]
    Equipment.Subset <- within(merge(Equipment.Subset,Equipment.Data, by = 'Equipment'), 
                               {Quantity <- ifelse(is.na(Quantity.y),Quantity.x,Quantity.y); Quantity.x <- NULL; Quantity.y <- NULL})
    
    # Separate into year class equipment and global equipment.  Global equipment is the lease stuff that 
    # is calculated dependent on year class stuff
    
    Equipment.Subset.Year <- subset(Equipment.Subset, Type != 'Global')
    Equipment.Subset.Global <- subset(Equipment.Subset, Type == 'Global')
    
    #Equipment for used in farm strategy and harvest year
    for (i in 1:nrow(Equipment.Subset.Year)) {
      # Evaluate the Quantity expression for this row, and do cost.basis and depreciation too
      Equipment.Subset.Year$Quantity[i] <- as.numeric(eval(parse(text = Equipment.Subset.Year$Quantity[i])))
      
      Equipment.Subset.Year$Cost.Basis[i] <- Equipment.Subset.Year$Unit.Cost[i] * as.numeric(eval(parse(text = Equipment.Subset.Year$Quantity[i])))
      
      Equipment.Subset.Year$Depreciation[i] <- Equipment.Subset.Year$Cost.Basis[i] / Equipment.Subset.Year$Lifespan[i]
    }
    # Change Quantity to numeric because I am not a good coder
    Equipment.Subset.Year$Quantity <- as.numeric(Equipment.Subset.Year$Quantity)
    # Overwrite main data frame with year data only
    Equipment.Subset <- Equipment.Subset.Year
    
    #Equipment for used in farm strategy and harvest year
    for (i in 1:nrow(Equipment.Subset.Global)) {
      # Evaluate the Quantity expression for this row, and do cost.basis and depreciation too
      Equipment.Subset.Global$Quantity[i] <- as.numeric(eval(parse(text = Equipment.Subset.Global$Quantity[i])))
      
      Equipment.Subset.Global$Cost.Basis[i] <- Equipment.Subset.Global$Unit.Cost[i] * as.numeric(eval(parse(text = Equipment.Subset.Global$Quantity[i])))
      
      Equipment.Subset.Global$Depreciation[i] <- Equipment.Subset.Global$Cost.Basis[i] / Equipment.Subset.Global$Lifespan[i]
    }
    # Change Quantity to numeric because I am not a good coder
    Equipment.Subset.Global$Quantity <- as.numeric(Equipment.Subset.Global$Quantity)
    
    # bind the two frames and delete leftovers
    Equipment.Subset <- rbind(Equipment.Subset,Equipment.Subset.Global)
    rm(Equipment.Subset.Global, Equipment.Subset.Year)
    
    # Labor tasks similar to equipment but introduce seasonality
    
    # Read Labor Outputs, subset by Harvest year harvest season farm strategy then merge with tasks, rate, and part time
    Labor <- read_excel(file_path, sheet = 'Labor_Output')
    Labor.Subset <- left_join(Labor,Task.Data, by = 'Task')
    
    # Assign Harvest task to final year and season
    Labor.Subset$Year[Labor.Subset$Task == 'Harvest'] <- `Harvest Year`
    Labor.Subset$Season[Labor.Subset$Task == 'Harvest'] <- `Harvest Season`
    
    # Subset by Harvest Year, Farm type, and whether a task is completed (used for the cleaning)
    Labor.Subset <- Labor.Subset[which(Labor.Subset$Year %in% Harvest.Year & Labor.Subset$Type %in% Farm.strat & Labor.Subset$Completed %in% 'Y'),]
    Labor.Subset <- Labor.Subset[!(Labor.Subset$Year == `Harvest Year` & !(Labor.Subset$Season %in% Harvest.Season)), ]
    # Create initialized columns because it annoys me to see a warnng message
    Labor.Subset$Hours.Paid <- NA
    Labor.Subset$Labor.Costs <- NA
    
    for (i in 1:nrow(Labor.Subset)){
      Labor.Subset$Time[i] <- as.numeric(eval(parse(text = Labor.Subset$Time[i])))
      Labor.Subset$Trips[i] <- eval(parse(text = Labor.Subset$Trips[i]))
      Labor.Subset$Hours.Paid[i] <- ifelse(Labor.Subset$Trips[i] > 0, round_any(as.numeric(Labor.Subset$Time[i]), 8, f=ceiling), Labor.Subset$Time[i])
      Labor.Subset$Labor.Costs[i] <- as.numeric(Labor.Subset$Hours.Paid[i]) * `Part Time Wage` * Labor.Subset$Part.Time[i]
    }
    Labor.Subset$Time <- as.numeric(Labor.Subset$Time)
    Labor.Subset$Trips <- as.numeric(Labor.Subset$Trips)
    
    # Subset out Specialized equipment with quantity = 0 or time = Inf  
    Labor.Subset <- subset(Labor.Subset, Time != Inf)
    Equipment.Subset <- subset(Equipment.Subset, Quantity!=0)
    
    # Read Fuel Outputs, subset to relevant, and merge with price.gallon and fuel.trip
    Fuel <- read_excel(file_path, sheet = 'Fuel_Output')
    Fuel.Subset <- left_join(Fuel,Fuel.Data, by = 'Vehicle') 
    
    Fuel.Subset <- Fuel.Subset[which(Fuel.Subset$Year %in% Harvest.Year & Fuel.Subset$Type %in% Farm.strat),]
    # Same as labor, this kicks back a warning message and it's just annoying  
    Fuel.Subset$Fuel.Cost <- NA
    #Fuel for a given period by year
    for (i in 1:nrow(Fuel.Subset)){
      Fuel.Subset$Fuel.Cost[i] <- Fuel.Subset$Price.Gallon[i] * Fuel.Subset$Usage.Trip[i] * as.numeric((sum(Labor.Subset[which(Labor.Subset$Year == Fuel.Subset$Year[i]),6]) + Fuel.Subset$Additional.Trips[i]))
    }
    
    # Read Fuel Outputs, subset to relevant and ,merge with price.gallon and fuel.trip
    Maintenance <- read_excel(file_path, sheet = 'Maintenance_Output')
    Maintenance.Subset <- left_join(Maintenance,Maint.Data, by = 'Item') 
    
    Maintenance.Subset <- Maintenance.Subset[which(Maintenance.Subset$Year %in% Harvest.Year & Maintenance.Subset$Type %in% Farm.strat),]
    
    #Maintenance for a given period
    for (i in 1:nrow(Maintenance.Subset)){
      Maintenance.Subset$Maintenance.Cost[i] <- as.numeric(eval(parse(text = Maintenance.Subset$Maintenance.Cost[i])))
    }
    Maintenance.Subset$Maintenance.Cost <- as.numeric(Maintenance.Subset$Maintenance.Cost)
    # Alright, this should be the basic global data, if we add up all columns we should get the annual 
    # values once all year classes have been introduced.  The below section is the fun stuff, 
    # deliverable metrics!
    
    # Metric ideas
    
    # Total lease size and Cost
    # Leases have three designations: Standard, LPA, and Experimental with different fees by acreage
    # Take longline length, mooring length (distance along bottom), and Longline Spacing to calculate acreage
    
    # Create data frame with Longline Quantity in it for 'reasons'
    Lease.Footprint <- data.frame(`Longline Quantity`)
    # total longline length is the total cost of global rope + bottom length of mooring rope (pythag)*2*number of longlines 
    Lease.Footprint$Feet.Longline.Total <- Equipment.Subset$Quantity[Equipment.Subset$Equipment == 'Rope (1 inch)' & Equipment.Subset$Type == 'Global'] + 
      ((`Longline Quantity`*2) * sqrt(((`Longline Depth`-`Longline Suspended Depth`)*`Mooring Length`)^2 - (`Longline Depth`-`Longline Suspended Depth`)^2))
    # Size of each longline in the event of multiple longlines
    Lease.Footprint$l.Feet <- Lease.Footprint$Feet.Longline.Total/`Longline Quantity`
    # Total meters for longline length (no m/longline as most growers won't find it relevant)
    Lease.Footprint$Meters.Longline.Total <- Lease.Footprint$Feet.Longline.Total * .3048
    # Total lease area in ft^2
    Lease.Footprint$A.Feet <- Lease.Footprint$l.Feet * `Longline Spacing`
    # Total lease area in m^2
    Lease.Footprint$A.Meters <- Lease.Footprint$A.Feet * .3048
    
    # This value is the Acreage which will be the most valuable statistic for growers
    Lease.Footprint$Acres <- (Lease.Footprint$l.Feet*`Longline Spacing`)*.0000229568
    
    # Leasing fees, from DMR and updated annually with lease type, Application fee, and annual fixed fee
    Lease.Type.M <- data.frame(     # DMR lease type
      Type = c('Experimental Lease','LPA','Standard Lease'),     # DMR lease types
      App.Fee = c(0,100,1500),     # Application fee (1 time)
      Annual.Fee = c(50,100,100)     # Annual lease fee charged by the acre
    )
    
    # Set lease type from Preset
    Lease.Type.M <- subset(Lease.Type.M, Type == `Lease Type`)
    
    # Create year month
    
    # Set year start to August 1, Year and create an annual date matrix
    Year_0 <- ymd(`Starting Year`,truncated=2L) + months(7)
    Date.Frame <- data.frame(Year = seq(0,10,by=1), 
                             Date = seq(ymd(Year_0),ymd(Year_0 %m+% years(10)),by = 'year'))
    Date.Frame$Date<- as.yearmon(Date.Frame$Date)
    
    # Labor metrics 
    # Calculate total labor time by season, hours worked, hours paid, etc and rounded up work days 
    # for pane 1 graph
    Labor.Subset$Hours.Paid<- as.numeric(Labor.Subset$Hours.Paid)
    Labor.metrics <- aggregate(cbind(Time,Trips,Labor.Costs,Hours.Paid)~Season,data = Labor.Subset, sum)
    Labor.metrics$Work.Days <- round(Labor.metrics$Hours.Paid/8)  
    
    # Economic Metrics
    # Create a matrix to assign columns by their year class, growers might have to wait up to 4 years
    # Prior to first sale and that leads to significant deferment of costs.
    # Then add up total costs for all categories plus consumables == cost of goods sold.
    
    # Create a cost of good sold data set starting with years  
    COG <- Date.Frame  
    
    # Sum equipment, Labor, Fuel, and Maintenance by year cumulatively until the 
    # final year when it is a fully operational farm
    
    COG$Equipment <- ifelse(COG$Year == 0,sum(Equipment.Subset$Cost.Basis[which(Equipment.Subset$Year=='Y0' | Equipment.Subset$Year=='all')]),
                            ifelse(COG$Year == 1,sum(Equipment.Subset$Cost.Basis[which(Equipment.Subset$Year== 'Y1')]),
                                   ifelse(COG$Year == 2, sum(Equipment.Subset$Cost.Basis[which(Equipment.Subset$Year== 'Y2')]),
                                          ifelse(COG$Year == 3, sum(Equipment.Subset$Cost.Basis[which(Equipment.Subset$Year== 'Y3')]),0))))
    
    COG$Labor <- ifelse(COG$Year == 0, sum(Labor.Subset$Labor.Costs[which(Labor.Subset$Year %in% Y0)]),
                        ifelse(COG$Year == 1, sum(Labor.Subset$Labor.Costs[which(Labor.Subset$Year %in% Y1)]),
                               ifelse(COG$Year == 2, sum(Labor.Subset$Labor.Costs[which(Labor.Subset$Year %in% Y2)]),
                                      ifelse(COG$Year == 3, sum(Labor.Subset$Labor.Costs[which(Labor.Subset$Year %in% Y3)]),
                                             sum(Labor.Subset$Labor.Costs)))))    
    
    COG$Fuel <- ifelse(COG$Year == 0, sum(Fuel.Subset$Fuel.Cost[which(Fuel.Subset$Year %in% Y0)]),
                       ifelse(COG$Year == 1, sum(Fuel.Subset$Fuel.Cost[which(Fuel.Subset$Year %in% Y1)]),
                              ifelse(COG$Year == 2, sum(Fuel.Subset$Fuel.Cost[which(Fuel.Subset$Year %in% Y2)]),
                                     ifelse(COG$Year == 3, sum(Fuel.Subset$Fuel.Cost[which(Fuel.Subset$Year %in% Y3)]),
                                            sum(Fuel.Subset$Fuel.Cost))))) 
    
    COG$Maintenance <- ifelse(COG$Year == 0, sum(Maintenance.Subset$Maintenance.Cost[which(Maintenance.Subset$Year %in% Y0)]),
                              ifelse(COG$Year == 1, sum(Maintenance.Subset$Maintenance.Cost[which(Maintenance.Subset$Year %in% Y1)]),
                                     ifelse(COG$Year == 2, sum(Maintenance.Subset$Maintenance.Cost[which(Maintenance.Subset$Year %in% Y2)]),
                                            ifelse(COG$Year == 3, sum(Maintenance.Subset$Maintenance.Cost[which(Maintenance.Subset$Year %in% Y3)]),
                                                   sum(Maintenance.Subset$Maintenance.Cost)))))
    
    # Add consumables which is just an annual odds and ends expense
    COG$Consumables <- Consumables
    
    # Sum for the Cost of Goods Sold
    COG$`Cost of Goods Sold` <- rowSums(COG[,(3:6)])
    
    # Note above, these are all variable costs
    
    # Fixed overhead costs (FOC)
    # Create a data frame for FOC costs annually.  These are mostly a flat annual fee except lease rent
    # and depreciation which vary based on the initial application fee in year 0 and the time in which
    # Equipment was first purchased/put to use
    FOC <- Date.Frame
    
    # Lease fees, consists of an initial application fee and then an annual fee based on acreage
    FOC$Lease <- ifelse(FOC$Year == 0, 
                        Lease.Type.M$App.Fee + (Lease.Type.M$Annual.Fee*Lease.Footprint$Acres), 
                        Lease.Type.M$Annual.Fee*Lease.Footprint$Acres)
    # Insurance is just the summed annual insurance payments
    FOC$Insurance <- Insurance
    # Annual shellfish aquaculture license fee
    FOC$`Aquaculture License` <- `Shellfish License`
    # Owner Salary is an annual payment amount to the owner
    FOC$`Owner Salary` <- `Owner Salary`
    # Full time employee salary is an annual salary multiplied by the number of full time employees
    FOC$`Full Time Employee` <- `Full Time Employee` * `Employee Salary`
    # Depreciation is based on the lifespan of a piece of equipment divided by the cost of the item.
    # It is an unrealized expense in that the cash is not spent, but should be considered reinvested to
    # replace gear in the future
    FOC$Depreciation <- ifelse(COG$Year == 0,sum(Equipment.Subset$Depreciation[which(Equipment.Subset$Year %in% Y0)]),
                               ifelse(COG$Year == 1,sum(Equipment.Subset$Depreciation[which(Equipment.Subset$Year %in% Y1)]),
                                      ifelse(COG$Year == 2, sum(Equipment.Subset$Depreciation[which(Equipment.Subset$Year %in% Y2)]),
                                             ifelse(COG$Year == 3, sum(Equipment.Subset$Depreciation[which(Equipment.Subset$Year %in% Y3)]),
                                                    sum(Equipment.Subset$Depreciation)))))
    # Sum all rows for total annual fixed operating costs
    FOC$`Fixed Overhead Costs` <- rowSums(FOC[,(3:8)]) 
    
    # Annual costs irregardless of year and business plan
    # Sum Insurance, Shelffish/Aq License, Lease Rent, Owner Salary, Depreciation (By year)
    # These are fixed overhead costs, ie costs that cannot be circumvented 
    
    # Cost of production is COG+FOC and is all realized and unrealized expenses...basically the total cost
    COP <- data.frame(Date.Frame,COG$`Cost of Goods Sold`,FOC$`Fixed Overhead Costs`)
    colnames(COP)[3] <- "Cost of Goods Sold"
    colnames(COP)[4] <- "Fixed Overhead Costs"
    COP$`Cost of Production` <- rowSums(COP[,3:4])
    # Cumulative COP is what I am calling debt
    COP$Debt <- cumsum(COP$`Cost of Production`)
    # Scallops sold at market, this is a fixed amount
    COP$`Individual Scallops` <-  ifelse(COP$Year == 0 & `Harvest Year` == 'Y0', Growth.Data$Market.Product,
                                         ifelse(COP$Year == 1 & `Harvest Year` == 'Y1', Growth.Data$Market.Product,
                                                ifelse(COP$Year == 2 & `Harvest Year` == 'Y2', Growth.Data$Market.Product,
                                                       ifelse(COP$Year == 3 & `Harvest Year` == 'Y3', Growth.Data$Market.Product,
                                                              ifelse(COP$Year >3 & `Harvest Year` %in% Y4, Growth.Data$Market.Product,0)))))
    # Shell height in millimeters of market scallops
    COP$`ShellHeight (mm)` <- ifelse(COP$`Individual Scallops` == 0, 0,Growth.Data$Sh_Height)
    # Shell height in inches for market scallops, we will use imperial units for the 
    # app since it is more valuable to fishermen
    COP$`ShellHeight (Inches)` <- ifelse(COP$`Individual Scallops` == 0, 0,Growth.Data$Sh_Height.inches)
    # Adductor weight in grams
    COP$`Adductor (g)` <- ifelse(COP$`Individual Scallops` == 0, 0,Growth.Data$Adductor)
    # Adductor weight in pounds
    COP$`Adductor (lb)` <- ifelse(COP$`Individual Scallops` == 0, 0,Growth.Data$Adductor.lbs)
    # The industry standard for sale is as the amount of adductor meats in a pound.
    # Also called count per pound.  It's a psuedo weight binning strategy.
    # In general 30 count is small, 20 count is pretty normal and U10 is a large premium scallop
    # This isn't used in the calculations but is valuable to growers at a glance
    COP$`Adductor Count per lb` <- ifelse(COP$`Individual Scallops` == 0, 0,Growth.Data$count.lbs)
    # calculate run rate and break even price for scallops, run rate is essentially constant
    # and breka even is averaged out over time.  run rate is the asymptote for break even curve
    COP$`Run Rate (Whole Scallop)` <- COP$`Cost of Production`/COP$`Individual Scallops`
    COP$`Break Even Price (Whole Scallop)` <- COP$Debt/cumsum(COP$`Individual Scallops`)
    COP$`Run Rate (Adductor)` <- COP$`Cost of Production`/(COP$`Individual Scallops`*COP$`Adductor (lb)`)
    COP$`Break Even Price (Adductor)` <- COP$Debt/cumsum((COP$`Individual Scallops`*COP$`Adductor (lb)`))
    COP <- COP %>% 
      mutate_if(is.numeric, round,digits=2)
    COP$Date <- year(COP$Date)
    COP$`Individual Scallops` <- round(COP$`Individual Scallops`, digits = 0)
    
    
    # COG + FOC = Cost of Production
    # We calculate from here two values, 10 year break even and run rate.
    # 10 year break even takes all 10 years of COP, sums them, and then averages by total scallop
    # sales (Individuals & Price/lb).  Run rate assumes no initial debt for equipment purchases.
    
    # COP, break even, and run rate used in analysis  
    
    # Next allow growers to set a price (maybe in primary inputs?) or in this section if possible
    # Allow entry of scallop price/individual and adductor/lbs
    Whole.Scallop.Price <- input$Whole.Scallop.Price
    ScallopAdductor.lbs <- input$ScallopAdductor.lbs
    
    # gross profit, 10 year forecast
    # subtract COGs from the total scallops sold each year (or total lbs sold each year) * Price (total revenue)
    # so we have gross sales revenue = total income from product, gross profit is that minus COGS
    # Margin is the percent difference between gross profit and sales revenue
    # Net profit adds in FOC and profit margin is sales revenue and COP differences
    # Finally depreciation is taken out as an unrealized expense for physical cash flow.
    
    PL.add <- Date.Frame
    PL.add$`Gross Sales Revenue` <- ScallopAdductor.lbs*(COP$`Individual Scallops`*Growth.Data$Adductor.lbs)
    PL.add$`Gross Profit` <- PL.add$`Gross Sales Revenue` - COP$`Cost of Goods Sold` 
    PL.add$`Gross Profit Margin` <- (PL.add$`Gross Profit`/PL.add$`Gross Sales Revenue`)*100
    PL.add$`Net Profit` <- PL.add$`Gross Profit` - COP$`Fixed Overhead Costs`
    PL.add$`Net Profit Margin` <- (PL.add$`Net Profit`/PL.add$`Gross Sales Revenue`)*100
    PL.add$Depreciation <- FOC$Depreciation
    PL.add$`Year End Cash Flow` <- cumsum(PL.add$`Net Profit`-FOC$Depreciation)
    
    PL.Whole <- Date.Frame
    PL.Whole$`Gross Sales Revenue` <- Whole.Scallop.Price*COP$`Individual Scallops`
    PL.Whole$`Gross Profit` <-  PL.Whole$`Gross Sales Revenue` - COP$`Cost of Goods Sold` 
    PL.Whole$`Gross Profit Margin` <-  (PL.Whole$`Gross Profit`/PL.Whole$`Gross Sales Revenue`)*100
    PL.Whole$`Net Profit` <-  PL.Whole$`Gross Profit` - COP$`Fixed Overhead Costs`
    PL.Whole$`Net Profit Margin` <-  (PL.Whole$`Net Profit`/ PL.Whole$`Gross Sales Revenue`)*100
    PL.Whole$Depreciation <- FOC$Depreciation
    PL.Whole$`Year End Cash Flow` <- cumsum(PL.Whole$`Net Profit`-FOC$Depreciation)
    # Net Profit, 10 years
    # Subtract FOC from GP to get net profit
    
    # Finally, free cash flow. 10 years
    # Free cash flow is the Net profit summed annually with depreciation removed (since it is a non-realized expense)
    # and this will be the cash you have 'in hand' at the end of each year
    
    # For analysis we will also be using IRR (Internal rate of return) 
    # in one instance but will mostly be using break even and run rate
    
    # For the outputs, I think these should tentatively be what we give.
    
    # Pane 1 - Run Rate (whole and adductor), Break even 10 year (whole and adductor), Minimum lease size
    
    Pane1 <- data.frame('Market Individuals' = Growth.Data$Market.Product,
                        'Shell Height (Inches)' = Growth.Data$Sh_Height.inches,
                        'Adductor Count/lb' = Growth.Data$count.lbs,
                        'Run Rate (lbs)' = subset(COP, Year == 10)$`Run Rate (Adductor)`, 
                        'Run Rate (Piece)' = subset(COP, Year == 10)$`Run Rate (Whole Scallop)`,
                        '10 Year Break Even (lbs)' = subset(COP, Year == 10)$`Break Even Price (Adductor)`,
                        '10 Year Break Even (Piece)' = subset(COP, Year == 10)$`Break Even Price (Whole Scallop)`,
                        'Minimum Lease Size (Acres)' = Lease.Footprint$Acres)
    Pane1 <- round(Pane1, digits = 2)
    
    # Labor metrics I think would also be simple and helpful by season (or by year?)
    
    LAB_plt <- ggplot(Labor.Subset, aes(area=Hours.Paid/8, fill = Season, label=paste(Category, 
                                                                                      (Hours.Paid/8), sep = "\n Work Days:"), subgroup=Season))  + 
      geom_treemap(layout="squarified")+
      geom_treemap_text(colour = "black",
                        place = "centre",
                        size = 10) +
      geom_treemap_subgroup_border(colour = "white", size = 2) +
      theme_minimal() +
      scale_fill_manual(values = c('#e09f3e','#559e2c','#15b2d3','#66676d' )) +
      theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
      theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
      ggtitle("Annual Work Days by Season and Task") +
      theme(panel.border = element_rect(colour = "black", fill=NA, size=1))
    
    # Next, visual representation of COG and FOC
    
    COG.plot <- COG[,-8]
    COG.plot <- gather(COG.plot, key= 'Category', value = 'Cost', Equipment,Labor,Fuel,Maintenance,Consumables)
    COG.plot$Year<- as.factor(COG.plot$Year)
    
    COG_plt <- ggplot(COG.plot, aes(x=Year, y = Cost, fill = Category))  + 
      geom_bar(aes(),stat='identity')+
      theme_minimal() +
      scale_fill_brewer(palette = 'Set1') +
      theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
      theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
      ggtitle("10 Year Cost of Goods Sold Breakdown") +
      ylab("Cost ($USD)")+
      xlab("Business Year")+
      theme(panel.border = element_rect(colour = "black", fill=NA, size=1))
    
    FOC.Plot <- FOC[,-9]
    FOC.Plot <- gather(FOC.Plot, key = 'Category',value = 'Cost', Lease,Insurance,`Aquaculture License`,`Owner Salary`,`Full Time Employee`,Depreciation)
    FOC.Plot <- subset(FOC.Plot, Year == 10)
    FOC.Plot$Year <- as.factor(FOC.Plot$Year)
    
    
    FOC_plt <- ggplot(FOC.Plot, aes(x=Cost, y = Year, fill = Category))  + 
      geom_bar(aes(),stat='identity')+
      theme_minimal() +
      theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
      theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
      ggtitle("Annual Fixed Operating Cost Breakdown") +
      xlab("Cost ($USD)")+
      theme(panel.border = element_rect(colour = "gray20", fill=NA, size=.5),
            axis.title.y = element_blank(),
            axis.text.y = element_blank())
    
    #--------------------------------------------------------Making the data table
    SelVars <- c('Market Individuals',
                 'Shell Height (Inches)',
                 'Adductor Count/lb',
                 'Run Rate (lbs)',
                 'Run Rate (Piece)',
                 '10 Year Break Even (lbs)',
                 '10 Year Break Even (Piece)',
                 'Minimum Lease Size (Acres)')
    
    Pane1s <- stack(Pane1)
    Pane1s <- Pane1s[ ,-c(2) ]
    
    Tableframe <- data.frame(Metric = SelVars, 
                             Value =    Pane1s)
    
    ft <- Tableframe %>% flextable()
    ft_raster <- as_raster(ft) #takes a second, patience
    VarsTable <- ggplot() + 
      theme_void() + 
      annotation_custom(rasterGrob(ft_raster), xmin=-Inf, xmax=Inf, ymin=-Inf, ymax=Inf)
    ## ------------------------------------------------------------------------------------
    
    plt.List$plt.List <- list(LAB_plt = LAB_plt, COG_plt = COG_plt, FOG_plt = FOC_plt, VarsTable = VarsTable)
    
    ####### I think these will be a solid 'At a Glance' Section
    
    # Next pane allows growers to select price (which is set above)
    
    # Final Pane is a more traditional breakdown of Labor Metrics in a Table format for adductor and whole scallops
    # We can also include IRR and maybe allow them to set discounting rate but that is down the line
    # Let's get it working first
    
    Pane2.Adductor <- PL.add
    Pane2.Adductor <- Pane2.Adductor %>% 
      mutate_if(is.numeric, round,digits=2)
    Pane2.Adductor[Pane2.Adductor == -Inf] <- 'No Revenue'
    Pane2.Adductor <- t(Pane2.Adductor)
    
    Pane2.Whole <- PL.Whole
    Pane2.Whole <- Pane2.Whole %>% 
      mutate_if(is.numeric, round,digits=2)
    Pane2.Whole[Pane2.Whole == -Inf] <- 'No Revenue'
    Pane2.Whole <- t(Pane2.Whole)
    
    
    # Finally, a Downloadable series of tables in an excel or .csv format including:
    # Equipment, Labor, Fuel, and Maintenance tables + Primary and secondary inputs and Pane2 contents
    
    # Clean up outputs
    
    Equipment.Subset <- Equipment.Subset[,-c(6,8)]
    colnames(Equipment.Subset)[which(names(Equipment.Subset) == 'Unit.Cost')] <- 'Unit Cost'
    colnames(Equipment.Subset)[which(names(Equipment.Subset) == 'Cost.Basis')] <- 'Cost Basis'
    Equipment.Subset <- Equipment.Subset %>% 
      mutate_if(is.numeric, round,digits=2)
    
    
    Labor.Subset <- Labor.Subset[,-c(4,12)]
    colnames(Labor.Subset)[which(names(Labor.Subset) == 'Task.Rate')] <- 'Task Rate'
    colnames(Labor.Subset)[which(names(Labor.Subset) == 'Part.Time')] <- 'Part Time'
    colnames(Labor.Subset)[which(names(Labor.Subset) == 'Hours.Paid')] <- 'Hours Paid'
    colnames(Labor.Subset)[which(names(Labor.Subset) == 'Labor.Costs')] <- 'Part Time Labor Costs'
    
    Fuel.Subset <- Fuel.Subset[,-c(4)]
    colnames(Fuel.Subset)[which(names(Fuel.Subset) == 'Price.Gallon')] <- 'Price Per Gallon'
    colnames(Fuel.Subset)[which(names(Fuel.Subset) == 'Usage.Trip')] <- 'Usage per Trip'
    colnames(Fuel.Subset)[which(names(Fuel.Subset) == 'Fuel.Cost')] <- 'Fuel Cost'
    
    Maintenance.Subset <- Maintenance.Subset[,c(1,2,3,5,6,4,7)]
    colnames(Maintenance.Subset)[which(names(Maintenance.Subset) == 'Maintenance.Cost')] <- 'Maintenance Cost'
    colnames(Maintenance.Subset)[which(names(Maintenance.Subset) == 'Unit.Type')] <- 'Unit Type'
    colnames(Maintenance.Subset)[which(names(Maintenance.Subset) == 'Cost')] <- 'Unit Cost'
    
    Output.List$Output.List <- list("Economic Metrics (Adductor)" = Pane2.Adductor, 
                                    "Economic Metrics (Whole)" = Pane2.Whole,
                                    "Cost of Production" = COP,
                                    "Equipment" = Equipment.Subset,
                                    "Labor" = Labor.Subset,
                                    "Fuel" = Fuel.Subset,
                                    "Maintenance" = Maintenance.Subset,
                                    "Primary Inputs" = Primary.Parameter.Data,
                                    "Secondary" = Secondary.Data)

  }
  })
  
  output$save_button <- downloadHandler(
    filename = function() {
      paste("ScallopAquaculture-", Sys.Date(), ".xlsx", sep="")
    },
    content = function(file) {
      wb <- createWorkbook()
      
      # Loop through data frames and add sheets to the workbook
      data_list <- Output.List$Output.List
      for (i in seq_along(data_list)) {
        sheet_name <- names(data_list)[i]
        addWorksheet(wb, sheetName = sheet_name)
        writeData(wb, sheet = sheet_name, x = data_list[[i]])
      }
      
      # Save the workbook
      saveWorkbook(wb, file)
    }
  )
  
  
}
###-----------Run Application------------------------------------------------------------------------------------------------------
# Run the application
shinyApp(ui, server)

