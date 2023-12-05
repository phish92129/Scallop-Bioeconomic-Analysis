library(shiny)
library(shinydashboard)
library(readr)
library(DT)
library(shinyjs)
library(readxl) # For reading excel tables
library(dplyr) # For data manipulation
library(plyr)  # For data manipulation and to seemingly interfere with dplyr
library(hablar) # For the function 'retype' that assigns values to data frame columns (ie character or numeric)
library(ggplot2) # For graphics 
library(treemapify) # Create a treemap even though donut charts are prettier
library(openxlsx)


###------------Model Run on Intital Conditions---------------------------
if (!exists("Predicted.full")) {
  # If the variable doesn't exist, run the specific R script
  print("Running Growth_Input.R")
  source("./Growth_Input.R")
  print("Completed Running Growth_Input.R")
}

# Set file path for spreadsheet
file_path <- "./Components_V2.xlsx"

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
  VariableName <- as.character(Primary.Parameter.Data[i, 1])
  Value <- retype(Primary.Parameter.Data[i, 2,drop=TRUE]) 
  assign(VariableName, Value, envir = .GlobalEnv)
}

# Remove extra stuff for clarity and good data practice
rm(VariableName, Value)

# Let's add the secondary parameters
Secondary.Data<- read_excel(file_path, sheet = 'Secondary')

# Similar to primary, secondary parameters either based on farm layout or husbandry
for (i in 1:nrow(Secondary.Data)) {
  VariableName <- as.character(Secondary.Data[i, 1])
  Value <- retype(Secondary.Data[i, 2,drop=TRUE])
  Value <- eval(parse(text=Value))
  assign(VariableName, Value, envir = .GlobalEnv)
}

# Remove extra stuff for clarity and good data practice
rm(VariableName, Value)


# Alright, I think I get it, so we can change the model assumptions for the analysis here
# Year = "Y0"         #c("Initial", "Y0", "Y1", "Y2", "Y3")

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

# Subset by Harvest Year, Farm type, and whether a task is completed (used for the cleaning)
Labor.Subset <- Labor.Subset[which(Labor.Subset$Year %in% Harvest.Year & Labor.Subset$Type %in% Farm.strat & Labor.Subset$Completed %in% 'Y'),]
Labor.Subset <- Labor.Subset[!(Labor.Subset$Year == `Harvest Year` & Labor.Subset$Season != Harvest.Season), ]
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

COG$Equipment <- ifelse(COG$Year == 0,sum(Equipment.Subset$Cost.Basis[which(Equipment.Subset$Year== Y0)]),
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
COG$Cost.of.Goods.Sold <- rowSums(COG[,(3:6)])

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
FOC$Aquaculture.License <- `Shellfish License`
# Owner Salary is an annual payment amount to the owner
FOC$Owner.Salary <- `Owner Salary`
# Full time employee salary is an annual salary multiplied by the number of full time employees
FOC$Full.Time.Employee <- `Full Time Employee` * `Employee Salary`
# Depreciation is based on the lifespan of a piece of equipment divided by the cost of the item.
# It is an unrealized expense in that the cash is not spent, but should be considered reinvested to
# replace gear in the future
FOC$Depreciation <- ifelse(COG$Year == 0,sum(Equipment.Subset$Depreciation[which(Equipment.Subset$Year %in% Y0)]),
                           ifelse(COG$Year == 1,sum(Equipment.Subset$Depreciation[which(Equipment.Subset$Year %in% Y1)]),
                                  ifelse(COG$Year == 2, sum(Equipment.Subset$Depreciation[which(Equipment.Subset$Year %in% Y2)]),
                                         ifelse(COG$Year == 3, sum(Equipment.Subset$Depreciation[which(Equipment.Subset$Year %in% Y3)]),
                                                sum(Equipment.Subset$Depreciation)))))
# Sum all rows for total annual fixed operating costs
FOC$Fixed.Overhead.Costs <- rowSums(FOC[,(3:8)]) 

# Annual costs irregardless of year and business plan
# Sum Insurance, Shelffish/Aq License, Lease Rent, Owner Salary, Depreciation (By year)
# These are fixed overhead costs, ie costs that cannot be circumvented 

# Cost of production is COG+FOC and is all realized and unrealized expenses...basically the total cost
COP <- data.frame(Date.Frame,COG$Cost.of.Goods.Sold,FOC$Fixed.Overhead.Costs)
COP$Cost.of.Production <- rowSums(COP[,3:4])
# Cumulative COP is what I am calling debt
COP$Debt <- cumsum(COP$Cost.of.Production)
# Scallops sold at market, this is a fixed amount
COP$Ind.Scallops <-  ifelse(COP$Year == 0 & `Harvest Year` == 'Y0', Growth.Data$Market.Product,
                            ifelse(COP$Year == 1 & `Harvest Year` == 'Y1', Growth.Data$Market.Product,
                                   ifelse(COP$Year == 2 & `Harvest Year` == 'Y2', Growth.Data$Market.Product,
                                          ifelse(COP$Year == 3 & `Harvest Year` == 'Y3', Growth.Data$Market.Product,
                                                 ifelse(COP$Year >3 & `Harvest Year` %in% Y4, Growth.Data$Market.Product,0)))))
# Shell height in millimeters of market scallops
COP$ShellHeight.mm <- ifelse(COP$Ind.Scallops == 0, 0,Growth.Data$Sh_Height)
# Shell height in inches for market scallops, we will use imperial units for the 
# app since it is more valuable to fishermen
COP$ShellHeight.Inches <- ifelse(COP$Ind.Scallops == 0, 0,Growth.Data$Sh_Height.inches)
# Adductor weight in grams
COP$Adductor <- ifelse(COP$Ind.Scallops == 0, 0,Growth.Data$Adductor)
# Adductor weight in pounds
COP$Adductor.lbs <- ifelse(COP$Ind.Scallops == 0, 0,Growth.Data$Adductor.lbs)
# The industry standard for sale is as the amount of adductor meats in a pound.
# Also called count per pound.  It's a psuedo weight binning strategy.
# In general 30 count is small, 20 count is pretty normal and U10 is a large premium scallop
# This isn't used in the calculations but is valuable to growers at a glance
COP$count.lbs <- ifelse(COP$Ind.Scallops == 0, 0,Growth.Data$count.lbs)
# calculate run rate and break even price for scallops, run rate is essentially constant
# and breka even is averaged out over time.  run rate is the asymptote for break even curve
COP$Run.Rate.Whole.Scallop <- COP$Cost.of.Production/COP$Ind.Scallops
COP$Break.Even.Whole.Scallop <- COP$Debt/cumsum(COP$Ind.Scallops)
COP$Run.Rate.Adductor <- COP$Cost.of.Production/(COP$Ind.Scallops*COP$Adductor.lbs)
COP$Break.Even.Adductor <- COP$Debt/cumsum((COP$Ind.Scallops*COP$Adductor.lbs))

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
PL.add$Gross.Sales.Revenue <- ScallopAdductor.lbs*(COP$Ind.Scallops*Growth.Data$Adductor.lbs)
PL.add$Gross.Profit <- PL.add$Gross.Sales.Revenue - COP$COG.Cost.of.Goods.Sold 
PL.add$Gross.Profit.Margin <- (PL.add$Gross.Profit/PL.add$Gross.Sales.Revenue)*100
PL.add$Net.Profit <- PL.add$Gross.Profit - COP$FOC.Fixed.Overhead.Costs
PL.add$Net.Profit.Margin <- (PL.add$Net.Profit/PL.add$Gross.Sales.Revenue)*100
PL.add$Depreciation <- FOC$Depreciation
PL.add$Cash.Flow.YE <- cumsum(PL.add$Net.Profit-FOC$Depreciation)

PL.Whole <- Date.Frame
PL.Whole$Gross.Sales.Revenue <- Whole.Scallop.Price*COP$Ind.Scallops
PL.Whole$Gross.Profit <-  PL.Whole$Gross.Sales.Revenue - COP$COG.Cost.of.Goods.Sold 
PL.Whole$Gross.Profit.Margin <-  (PL.Whole$Gross.Profit/PL.Whole$Gross.Sales.Revenue)*100
PL.Whole$Net.Profit <-  PL.Whole$Gross.Profit - COP$FOC.Fixed.Overhead.Costs
PL.Whole$Net.Profit.Margin <-  (PL.Whole$Net.Profit/ PL.Whole$Gross.Sales.Revenue)*100
PL.Whole$Depreciation <- FOC$Depreciation
PL.Whole$Cash.Flow.YE <- cumsum(PL.Whole$Net.Profit-FOC$Depreciation)
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
                    'Run Rate (lbs)' = subset(COP, Year == 10)$Run.Rate.Adductor, 
                    'Run Rate (Piece)' = subset(COP, Year == 10)$Run.Rate.Whole.Scallop,
                    '10 Year Break Even (lbs)' = subset(COP, Year == 10)$Break.Even.Adductor,
                    '10 Year Break Even (Piece)' = subset(COP, Year == 10)$Break.Even.Whole.Scallop,
                    'Minimum Lease Size (Acres)' = Lease.Footprint$Acres)
Pane1 <- round(Pane1, digits = 2) 

# Labor metrics I think would also be simple and helpful by season (or by year?)

LAB_plt <- ggplot(Labor.metrics, aes(area=Work.Days, fill = Season, label=Work.Days))  + 
  geom_treemap(layout="squarified")+
  geom_treemap_text(colour = "black",
                    place = "centre",
                    size = 15) +
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  ggtitle("Annual Work Days") +
  theme(panel.border = element_rect(colour = "black", fill=NA, size=1))

# Next, visual representation of COG and FOC

COG.plot <- COG[,-8]
COG.plot <- gather(COG.plot, key= 'Category', value = 'Cost', Equipment,Labor,Fuel,Maintenance,Consumables)
COG.plot$Year<- as.factor(COG.plot$Year)

COG_plt <- ggplot(COG.plot, aes(x=Year, y = Cost, fill = Category))  + 
  geom_bar(aes(),stat='identity')+
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  ggtitle("10 Year Cost of Goods Sold Breakdown") +
  ylab("Cost ($USD)")+
  xlab("Business Year")+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=1))

FOC.Plot <- FOC[,-9]
FOC.Plot <- gather(FOC.Plot, key = 'Category',value = 'Cost', Lease,Insurance,Aquaculture.License,Owner.Salary,Full.Time.Employee,Depreciation)
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
  dashboardHeader(title = "BioEconomic Model"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Primary Inputs", tabName = "input1", icon = icon("gears")),
      menuItem("Secondary Inputs", tabName = "input2", icon = icon("sliders")),
      menuItem("Graph Outputs", tabName = "Plots", icon = icon("chart-simple")),
      menuItem("Table Outputs", tabName = "Output", icon = icon("table"))
      )
    ),
#-------------------------------------PRIMARY INPUTS -> UI Only--------------------------------------------------------------------------------------------------------------
###
  dashboardBody(
    tabItems(
      # First tab content (Input1)
      tabItem(
        tabName = "input1",
        fluidPage(
          box(
            title = "Primary Parameters",
            width = 10,
            selectInput("Lease.Type", "Lease Type:",
                        choices = c("Standard Lease", "LPA", "Experimental Lease")),
            
            numericInput("Longline.Quantity", label = tags$div("Long Line Quantity:", 
                                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Number of Longlines.</i>"))),
                         value = 1, min = 1, max = 20),
            
            numericInput("Longline.Depth", label = tags$div("Long Line Depth:", 
                                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Lease site depth at low tide.</i>"))),
                         value = 60, min = 1),
            
            numericInput("Longline.SusDepth", label = tags$div("Long Suspended Depth:", 
                                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Depth of head rope (main line) below surface.</i>"))),
                         value = 15, min = 1),
            
            numericInput("Product", label = tags$div("Product:", 
                                                               helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Projected Spat.</i>"))),
                         value = 100000, min = 10000),
            
            numericInput("Starting.Year", label = tags$div("Starting Year:"),
                         value = 2024, min = 2023),
            
            numericInput("Consumables", label = tags$div("Consumables:", 
                                                     helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Miscellaneous Annual Gear Ex: gloves, knifes, coffee, rain gear.</i>"))),
                         value = 1000, min = 1),
            
            numericInput("Owner.Salary", label = tags$div("Owner Salary:", 
                                                     helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Projected annual owner salary.</i>"))),
                         value = 35000, min = 1),
            
            numericInput("Insurance", label = tags$div("Insurance Cost:", 
                                                          helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Annual Insurance Costs (Combined).</i>"))),
                         value = 5000, min = 1),
            
            numericInput("Employee.Number", label = tags$div("Full Time Employees:", 
                                                       helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Salaried employees are paid an annual salary and are a fixed operating cost whereas part time employees are a variable cost of labor.</i>"))),
                         value = 1, min = 0),
            
            numericInput("Employee.Salary", label = tags$div("Full Time Employee Salary:", 
                                                               helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Annual employee wage per employee.</i>"))),
                         value = 35000, min = 1),
            
            numericInput("Part.Time.Wage", label = tags$div("Part Time Wage:", 
                                                               helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Minimum is based on federal minimum wage.</i>"))),
                         value = 15, min = 7.5),
            
            selectInput("Harvest.Season", label = tags$div("Harvest Season:", 
                                                           helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Harvest Quarter:<br>Winter: November - January<br>Spring: February - April<br>Summer: May - July<br>Fall: August - October.</i>"))),
                        choices = c('Fall', 'Winter','Spring','Summer')),
            
            selectInput("Harvest.Year", label = tags$div("Harvest Year:", 
                                                           helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Y2: Starts Fall after 2 years<br>Y3: Starts Fall after 3 years<br>Y4: Only Fall after 4 years.</i>"))),
                        choices = c('Y2', 'Y3','Y4')),
            
            selectInput("Spat.Procurement", label = tags$div("Spat Procurement:", 
                                                         helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Two current methods of scallop seed (ie spat):<br>To collect, growers place spat collectors in Y0 Fall and collect in Y0 Spring.  Requires labor and time.<br>The other option is purchase from a third party, more expensive/scallop as scale increases.  Grower would start lease work in Y0 spring with stocking lantern nets with spat at 150-250/tier.</i>"))),
                        choices = c('Wild Spat - Collected', 'Wild Spat - Purchased')),
            
            selectInput("Intermediate.Culture", label = tags$div("Intermediate Culture:", 
                                                             helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Currently the model only supports  lantern net culture the other option is pearl nets.  In this stage growers restock seed in Fall to 25-35/tier.</i>"))),
                        choices = c('Intermediate - Lantern Net')),
            
            selectInput("Grow.Out", label = tags$div("Grow Out Method:", 
                                                                 helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Grow out is the final and potentially longest phase. For lantern net growers would restock to ~10 per tier but in the second year of grow out (3-4 years) they would not need to restock.  Ear hanging requires pinning initially but then only requires cleaning after.</i>"))),
                        choices = c('Ear Hanging', 'Lantern Net')),
            
            
            actionButton("run_model", "Run Model")
          )
        )
      ),
###----------------------Secondary Inputs -> UI Only-----------------------------------------------------------------------------------------------------------
      # Second tab content (Input2)
      tabItem(
        tabName = "input2",
        fluidPage(
          box(
            title = "Wild Spat Collection",
            width = 4,
            numericInput("Wild.Spat.Collector", label = tags$div("Wild Spat Collector:", 
                                                            helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Predicted number of scallop spat/collector.</i>"))),
                         value = 4000, min = 1),
            numericInput("Spat.Site.Depth", label = tags$div("Spat Site Depth:", 
                                                                 helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Depth of spat collector placement.</i>"))),
                         value = 100, min = 1)
            ),
          
          box(
            title = "Stocking Densities",
            width = 4,
            numericInput("Seed.Net.Density", label = tags$div("Seed Net Density:", 
                                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Stocking density of 0-1 year old scallops.</i>"))),
                         value = 250, min = 1),
            numericInput("Y1.Stocking.Density", label = tags$div("Y1 Stocking Density:", 
                                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Stocking density of 1-2 year old scallops.</i>"))),
                         value = 25, min = 1),
            numericInput("Y2.Stocking.Density", label = tags$div("Y2 Stocking Density:", 
                                                                 helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Stocking density of 2-3 year old scallops.</i>"))),
                         value = 10, min = 1),
            numericInput("Y3.Stocking.Density", label = tags$div("Y3 Stocking Density:", 
                                                                 helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Stocking density of 3-4 year old scallops.</i>"))),
                         value = 10, min = 1),
           ),
          
          box(
            title = "Mortality Parameters",
            width = 4,
            numericInput("Y0.Mortality", label = tags$div("Y0 Mortality:", 
                                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Annual Mortality of 0-1 year old seed scallops.</i>"))),
                         value = 0.125, min = 0, max = 1),
            numericInput("Y1.Mortality", label = tags$div("Y1 Mortality:", 
                                                                 helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Annual Mortality of 1-2 year old scallops.</i>"))),
                         value = 0.125, min = 0, max = 1),
            numericInput("Y2.Mortality", label = tags$div("Y2 Mortality:", 
                                                                 helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Annual Mortality of 2-3 year old scallops.</i>"))),
                         value = 0.125, min = 0, max = 1),
            numericInput("Y3.Mortality", label = tags$div("Y3 Mortality:", 
                                                                 helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Annual Mortality of 3-4 year old scallops.</i>"))),
                         value = 0.125, min = 0, max = 1),
            
          ),
          
          box(
            title = "More Parameters",
            width = 4,
            numericInput("Seed.Purchace.Cost", label = tags$div("Seed Purchase Cost:", 
                                                          helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>How much scallop seed costs.  Often sold in batches of price/1000 scallops but that varies so growers will just have to divide.</i>"))),
                         value = 0.01, min = 0, max = 1),
            
            numericInput("Mooring.Length", label = tags$div("Mooring Length:", 
                                                                helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>This is the mooring length as a function of longline suspended depth.  Literature recommends a mooring length of 3-4 times the depth..</i>"))),
                         value = 0.01, min = 4, max = 8),
            
            numericInput("Surface.Float.Spacing", label = tags$div("Surface Float Spacing (feet):", 
                                                                helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>space between surface buoys attached to longline meant for general visibility.</i>"))),
                         value = 100, min = 0),
            
            numericInput("Longline.Spacing", label = tags$div("Longline Spacing:", 
                                                            helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Margin between longline and lease boundary which will afect total lease area.</i>"))),
                         value = 120, min = 0),
            
            numericInput("Shellfish.License", label = tags$div("Shellfish License Cost:", 
                                                            helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>All growers require an annual shellfish license that is a fixed operating cost.</i>"))),
                         value = 1200, min = 0),
            
            numericInput("Collectors.Line", label = tags$div("Collectors.Line:", 
                                                            helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Each anchor line for spat collection has several collectors attached.</i>"))),
                         value = 10, min = 0),
            
            numericInput("Gangion.Length", label = tags$div("Gangion Length:", 
                                                            helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Gangions or rope lengths used to attach gear such as lantern nets and sub surface buoys to longline.</i>"))),
                         value = 4, min = 0),
            
            numericInput("Daily.Work.Hours", label = tags$div("Daily Work Hours:", 
                                                            helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Daily work paid for part time help.</i>"))),
                         value = 8, min = 0, max = 24)
            
            ),
          
          box(
            title = "Latern Net Parameters",
            width = 4,
            numericInput("Lantern.Net.Tiers", label = tags$div("Lantern Net Tiers:",
                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Standard is 7 or 10 but there can be 20 or more.</i>"))),
                         value = 10, min = 0),
            numericInput("Lantern.Net.Hardball.Spacing", label = tags$div("Lantern Net Hardball Spacing:", 
                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>hard balls or compression resistant buoys used below the surface to keep gear off the bottom.  .</i>"))),
                         value = 10, min = 0),
            numericInput("Lantern.Net.Anchor.Spacing", label = tags$div("Lantern Net Anchor Spacing:", 
                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Anchors are placed along longline to keep drift from current to a minimum.</i>"))),
                         value = 25, min = 0),
            numericInput("Lantern.Net.Spacing", label = tags$div("Lantern Net Spacing:", 
                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Will affect total longline length.</i>"))),
                         value = 3, min = 0),
          ),
          
          box(
            title = "Ear Hanging Parameters",
            width = 4,
            numericInput("Ear.Hanging.Hardball.Spacing", label = tags$div("Ear Hanging Hardball Spacing:", 
                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Similar to lantern nets but less for dropper lines due to lower surface area.</i>"))),
                         value = 40, min = 0),
            numericInput("Ear.Hanging.Anchor.Spacing", label = tags$div("Ear Hanging Anchor Spacing:", 
                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Same but for anchors.</i>"))),
                         value = 10, min = 0)
          ),
          
          box(
            title = "Dropper Parameters",
            width = 4,
            numericInput("Dropper.Line.Spacing", label = tags$div("Dropper Line Spacing:", 
                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Spacing between dropper lines.</i>"))),
                         value = 1, min = 0),
            
            numericInput("Scallops.Per.Dropper", label = tags$div("Scallops Per Dropper:", 
                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Total scallops on each dropper line scallops are hung in pairs.</i>"))),
                         value = 140, min = 0),
            
            numericInput("Scallop.Spacing", label = tags$div("Scallop Spacing:", 
                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Spacing between each scallop couplet.</i>"))),
                         value = 0.5, min = 0),
            
            numericInput("Dropper.Margins", label = tags$div("Dropper Margins:", 
                                              helpText(HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Margin on either end, growers want a margin near the top to avoid scallops being out of the water when working the line.</i>"))),
                         value = 10, min = 0),
            textOutput("Ear.Hanging.Droppers"),
            textOutput("Dropper.Length")
            
          ),
          
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
          box(title = "Labor Costs",
              width = 12,
              plotOutput('LAB')
              ),
          box(title = "Cost of Good Sold",
              width = 12,
              plotOutput('COG')
          ),
          box(title = "Fixed Overhead Costs",
            width = 12,
            plotOutput('FOG')
          )
        )
        ),
### --------------Outputs Pane----------------------------------------------------------------------------------------------      
# Third tab content (Output)
      tabItem(
        tabName = "Output",
        fluidPage(
          box(
            #collapsible = TRUE,
            width = 14,
            headerPanel("Economic Metrics (Abductor)"),
            dataTableOutput("Economic.Metrics.Abductor"),
            headerPanel("Economic Metrics (Whole)"),
            dataTableOutput("Economic.Metrics.Whole") ,
            headerPanel("Cost of Production"),
            dataTableOutput("Cost.Production"),
            headerPanel("Equipment Costs"),
            dataTableOutput("Equipment"),
            headerPanel("Labor"),
            dataTableOutput("Labor"),
            headerPanel("Fuel Cost"),
            dataTableOutput("Fuel"),
            headerPanel("Maintenance Costs"),
            dataTableOutput("Maintenance"),
            headerPanel("Primary Inputs"),
            dataTableOutput("Primary"),
            headerPanel("Secondary Inputs"),
            dataTableOutput("Secondary")
            )
          )
        )
)
)
)


### --------------------------------SERVER--------------------------------------------------------------
# God Help Us
server <- function(input, output) {
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
    Mort.Calcs$Y1.Product <- input$Product * (1 - input$Y0.Mortality)
    Mort.Calcs$Y2.Product <- Mort.Calcs$Y1.Product * (1 - input$Y1.Mortality)
    Mort.Calcs$Y3.Product <- Mort.Calcs$Y2.Product * (1 - input$Y2.Mortality)
    Mort.Calcs$Y4.Product <- Mort.Calcs$Y3.Product * (1 - input$Y3.Mortality)
    Mort.Calcs$Ear.Hanging.Droppers <- ceiling((Mort.Calcs$Y2.Product/input$Scallops.Per.Dropper))
    Mort.Calcs$Dropper.Length <- ((input$Scallops.Per.Dropper * input$Scallop.Spacing)/2 + input$Dropper.Margins)
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
  
  
  
### -------Rendering table outputs-----------------------------------------------------------------------------------------------------  
  #Making a spreadsheet - for now this doesnt respond to running the moddle as the model isn't implimented
  # Its reading from the Output.List
  
  output$Economic.Metrics.Abductor <- renderDataTable(
  datatable(Output.List$Output.List$`Economic Metrics (Adductor)`,
            options = list(paging = FALSE,    ## paginate the output
                           scrollX = TRUE,   ## enable scrolling on X axis
                           scrollY = TRUE,   ## enable scrolling on Y axis
                           autoWidth = FALSE, ## use smart column width handling
                           server = FALSE,  ## use client-side processing
                           searching = FALSE,
                           info = FALSE,
                           dom = 'Bfrtip',     ##Bfrtip
                           buttons = c('csv', 'excel'),
                           columnDefs = list(list(targets = "_all", orderable  = FALSE))
            ),
            extensions = 'Buttons',
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
                             buttons = c('csv', 'excel'),
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              extensions = 'Buttons',
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
                             buttons = c('csv', 'excel'),
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              extensions = 'Buttons',
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
                             buttons = c('csv', 'excel'),
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              extensions = 'Buttons',
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
                             buttons = c('csv', 'excel'),
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              extensions = 'Buttons',
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
                             buttons = c('csv', 'excel'),
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              extensions = 'Buttons',
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
                             buttons = c('csv', 'excel'),
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              extensions = 'Buttons',
              selection = 'single', ## enable selection of a single row
              filter = 'none',              ## include column filters at the bottom
              rownames = FALSE       ## don't show row numbers/names
    )
  )
  
  output$Primary <- renderDataTable(
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
                             buttons = c('csv', 'excel'),
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              extensions = 'Buttons',
              selection = 'single', ## enable selection of a single row
              filter = 'none',              ## include column filters at the bottom
              rownames = FALSE       ## don't show row numbers/names
    )
  )
  
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
                             buttons = c('csv', 'excel'),
                             columnDefs = list(list(targets = "_all", orderable  = FALSE))
              ),
              extensions = 'Buttons',
              selection = 'single', ## enable selection of a single row
              filter = 'none',              ## include column filters at the bottom
              rownames = FALSE       ## don't show row numbers/names
    )
  )
  
###----------Observe Model Run-------------------------------------------------------------------------------------------------------------------  
  observeEvent(input$run_model, {#Fake running of the model - updates all the thingy
    
    #Procedural Adding in the input variables
    pInput.List <- c("Lease.Type","Longline.Quantity","Longline.Depth","Longline.SusDepth","Product","Starting.Year","Consumables","Owner.Salary","Insurance","Employee.Number","Employee.Salary","Part.Time.Wage","Harvest.Season","Harvest.Year","Spat.Procurement","Intermediate.Culture","Grow.Out")
    pVar.Names <- Primary.Parameter.Data$VariableName
  
    for (i in c(1:length(pInput.List))){
      inputName <- pInput.List[i]
      inputValue <- input[[inputName]]
      globName <- pVar.Names[i]
      
      assign(globName, inputValue, envir = .GlobalEnv)
    }
    
    sInput.List <- c( "Wild.Spat.Collector", "Spat.Site.Depth", "Seed.Net.Density", "Y1.Stocking.Density", "Y2.Stocking.Density", "Y3.Stocking.Density", "Y0.Mortality", "Y1.Mortality", "Y2.Mortality", "Y3.Mortality", "Seed.Purchace.Cost", "Mooring.Length", "Surface.Float.Spacing", "Longline.Spacing", "Shellfish.License", "Collectors.Line", "Gangion.Length", "Daily.Work.Hours", "Lantern.Net.Tiers", "Lantern.Net.Hardball.Spacing", "Lantern.Net.Anchor.Spacing", "Lantern.Net.Spacing", "Ear.Hanging.Hardball.Spacing", "Ear.Hanging.Anchor.Spacing", "Dropper.Line.Spacing", "Scallops.Per.Dropper", "Scallop.Spacing", "Dropper.Margins")
    sVar.Names <- c( "Wild Spat Collector", "Spat Site Depth", "Seed Net Density", "Y1 Stocking Density", "Y2 Stocking Density", "Y3 Stocking Density", "Y0 Mortality", "Y1 Mortality", "Y2 Mortality", "Y3 Mortality", "Seed Purchase Cost", "Mooring Length", "Surface Float Spacing", "Longline Spacing", "Shellfish License", "Collectors Line", "Gangion Length", "Daily Work Hours", "Lantern Net Tiers", "Lantern Net Hardball Spacing", "Lantern Net Anchor Spacing", "Lantern Net Spacing", "Ear Hanging Hardball Spacing", "Ear Hanging Anchor Spacing", "Dropper Line Spacing", "Scallops Per Dropper", "Scallop Spacing", "Dropper Margins")
    
    for (i in c(1:length(sInput.List))){
      inputName <- sInput.List[i]
      inputValue <- input[[inputName]]
      globName <- sVar.Names[i]
      
      assign(globName, inputValue, envir = .GlobalEnv)
    }
    
    `Y1 Product` <- Mort.Calcs$Y1.Product
    `Y2 Product` <- Mort.Calcs$Y2.Product
    `Y3 Product` <- Mort.Calcs$Y3.Product
    `Y4 Product` <- Mort.Calcs$Y4.Product
    `Ear Hanging Droppers` <-  Mort.Calcs$Ear.Hanging.Droppers
    `Dropper Length` <-  Mort.Calcs$Dropper.Length
    
    
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
    
    # Subset by Harvest Year, Farm type, and whether a task is completed (used for the cleaning)
    Labor.Subset <- Labor.Subset[which(Labor.Subset$Year %in% Harvest.Year & Labor.Subset$Type %in% Farm.strat & Labor.Subset$Completed %in% 'Y'),]
    Labor.Subset <- Labor.Subset[!(Labor.Subset$Year == `Harvest Year` & Labor.Subset$Season != Harvest.Season), ]
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
    
    COG$Equipment <- ifelse(COG$Year == 0,sum(Equipment.Subset$Cost.Basis[which(Equipment.Subset$Year== Y0)]),
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
    COG$Cost.of.Goods.Sold <- rowSums(COG[,(3:6)])
    
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
    FOC$Aquaculture.License <- `Shellfish License`
    # Owner Salary is an annual payment amount to the owner
    FOC$Owner.Salary <- `Owner Salary`
    # Full time employee salary is an annual salary multiplied by the number of full time employees
    FOC$Full.Time.Employee <- `Full Time Employee` * `Employee Salary`
    # Depreciation is based on the lifespan of a piece of equipment divided by the cost of the item.
    # It is an unrealized expense in that the cash is not spent, but should be considered reinvested to
    # replace gear in the future
    FOC$Depreciation <- ifelse(COG$Year == 0,sum(Equipment.Subset$Depreciation[which(Equipment.Subset$Year %in% Y0)]),
                               ifelse(COG$Year == 1,sum(Equipment.Subset$Depreciation[which(Equipment.Subset$Year %in% Y1)]),
                                      ifelse(COG$Year == 2, sum(Equipment.Subset$Depreciation[which(Equipment.Subset$Year %in% Y2)]),
                                             ifelse(COG$Year == 3, sum(Equipment.Subset$Depreciation[which(Equipment.Subset$Year %in% Y3)]),
                                                    sum(Equipment.Subset$Depreciation)))))
    # Sum all rows for total annual fixed operating costs
    FOC$Fixed.Overhead.Costs <- rowSums(FOC[,(3:8)]) 
    
    # Annual costs irregardless of year and business plan
    # Sum Insurance, Shelffish/Aq License, Lease Rent, Owner Salary, Depreciation (By year)
    # These are fixed overhead costs, ie costs that cannot be circumvented 
    
    # Cost of production is COG+FOC and is all realized and unrealized expenses...basically the total cost
    COP <- data.frame(Date.Frame,COG$Cost.of.Goods.Sold,FOC$Fixed.Overhead.Costs)
    COP$Cost.of.Production <- rowSums(COP[,3:4])
    # Cumulative COP is what I am calling debt
    COP$Debt <- cumsum(COP$Cost.of.Production)
    # Scallops sold at market, this is a fixed amount
    COP$Ind.Scallops <-  ifelse(COP$Year == 0 & `Harvest Year` == 'Y0', Growth.Data$Market.Product,
                                ifelse(COP$Year == 1 & `Harvest Year` == 'Y1', Growth.Data$Market.Product,
                                       ifelse(COP$Year == 2 & `Harvest Year` == 'Y2', Growth.Data$Market.Product,
                                              ifelse(COP$Year == 3 & `Harvest Year` == 'Y3', Growth.Data$Market.Product,
                                                     ifelse(COP$Year >3 & `Harvest Year` %in% Y4, Growth.Data$Market.Product,0)))))
    # Shell height in millimeters of market scallops
    COP$ShellHeight.mm <- ifelse(COP$Ind.Scallops == 0, 0,Growth.Data$Sh_Height)
    # Shell height in inches for market scallops, we will use imperial units for the 
    # app since it is more valuable to fishermen
    COP$ShellHeight.Inches <- ifelse(COP$Ind.Scallops == 0, 0,Growth.Data$Sh_Height.inches)
    # Adductor weight in grams
    COP$Adductor <- ifelse(COP$Ind.Scallops == 0, 0,Growth.Data$Adductor)
    # Adductor weight in pounds
    COP$Adductor.lbs <- ifelse(COP$Ind.Scallops == 0, 0,Growth.Data$Adductor.lbs)
    # The industry standard for sale is as the amount of adductor meats in a pound.
    # Also called count per pound.  It's a psuedo weight binning strategy.
    # In general 30 count is small, 20 count is pretty normal and U10 is a large premium scallop
    # This isn't used in the calculations but is valuable to growers at a glance
    COP$count.lbs <- ifelse(COP$Ind.Scallops == 0, 0,Growth.Data$count.lbs)
    # calculate run rate and break even price for scallops, run rate is essentially constant
    # and breka even is averaged out over time.  run rate is the asymptote for break even curve
    COP$Run.Rate.Whole.Scallop <- COP$Cost.of.Production/COP$Ind.Scallops
    COP$Break.Even.Whole.Scallop <- COP$Debt/cumsum(COP$Ind.Scallops)
    COP$Run.Rate.Adductor <- COP$Cost.of.Production/(COP$Ind.Scallops*COP$Adductor.lbs)
    COP$Break.Even.Adductor <- COP$Debt/cumsum((COP$Ind.Scallops*COP$Adductor.lbs))
    
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
    PL.add$Gross.Sales.Revenue <- ScallopAdductor.lbs*(COP$Ind.Scallops*Growth.Data$Adductor.lbs)
    PL.add$Gross.Profit <- PL.add$Gross.Sales.Revenue - COP$COG.Cost.of.Goods.Sold 
    PL.add$Gross.Profit.Margin <- (PL.add$Gross.Profit/PL.add$Gross.Sales.Revenue)*100
    PL.add$Net.Profit <- PL.add$Gross.Profit - COP$FOC.Fixed.Overhead.Costs
    PL.add$Net.Profit.Margin <- (PL.add$Net.Profit/PL.add$Gross.Sales.Revenue)*100
    PL.add$Depreciation <- FOC$Depreciation
    PL.add$Cash.Flow.YE <- cumsum(PL.add$Net.Profit-FOC$Depreciation)
    
    PL.Whole <- Date.Frame
    PL.Whole$Gross.Sales.Revenue <- Whole.Scallop.Price*COP$Ind.Scallops
    PL.Whole$Gross.Profit <-  PL.Whole$Gross.Sales.Revenue - COP$COG.Cost.of.Goods.Sold 
    PL.Whole$Gross.Profit.Margin <-  (PL.Whole$Gross.Profit/PL.Whole$Gross.Sales.Revenue)*100
    PL.Whole$Net.Profit <-  PL.Whole$Gross.Profit - COP$FOC.Fixed.Overhead.Costs
    PL.Whole$Net.Profit.Margin <-  (PL.Whole$Net.Profit/ PL.Whole$Gross.Sales.Revenue)*100
    PL.Whole$Depreciation <- FOC$Depreciation
    PL.Whole$Cash.Flow.YE <- cumsum(PL.Whole$Net.Profit-FOC$Depreciation)
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
                        'Run Rate (lbs)' = subset(COP, Year == 10)$Run.Rate.Adductor, 
                        'Run Rate (Piece)' = subset(COP, Year == 10)$Run.Rate.Whole.Scallop,
                        '10 Year Break Even (lbs)' = subset(COP, Year == 10)$Break.Even.Adductor,
                        '10 Year Break Even (Piece)' = subset(COP, Year == 10)$Break.Even.Whole.Scallop,
                        'Minimum Lease Size (Acres)' = Lease.Footprint$Acres)
    Pane1 <- round(Pane1, digits = 2) 
    
    # Labor metrics I think would also be simple and helpful by season (or by year?)
    
    LAB_plt <- ggplot(Labor.metrics, aes(area=Work.Days, fill = Season, label=Work.Days))  + 
      geom_treemap(layout="squarified")+
      geom_treemap_text(colour = "black",
                        place = "centre",
                        size = 15) +
      theme_minimal() +
      theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
      theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
      ggtitle("Annual Work Days") +
      theme(panel.border = element_rect(colour = "black", fill=NA, size=1))
    
    # Next, visual representation of COG and FOC
    
    COG.plot <- COG[,-8]
    COG.plot <- gather(COG.plot, key= 'Category', value = 'Cost', Equipment,Labor,Fuel,Maintenance,Consumables)
    COG.plot$Year<- as.factor(COG.plot$Year)
    
    COG_plt <- ggplot(COG.plot, aes(x=Year, y = Cost, fill = Category))  + 
      geom_bar(aes(),stat='identity')+
      theme_minimal() +
      theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
      theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
      ggtitle("10 Year Cost of Goods Sold Breakdown") +
      ylab("Cost ($USD)")+
      xlab("Business Year")+
      theme(panel.border = element_rect(colour = "black", fill=NA, size=1))
    
    FOC.Plot <- FOC[,-9]
    FOC.Plot <- gather(FOC.Plot, key = 'Category',value = 'Cost', Lease,Insurance,Aquaculture.License,Owner.Salary,Full.Time.Employee,Depreciation)
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
    
    plt.List$plt.List <- list(LAB_plt = LAB_plt, COG_plt = COG_plt, FOG_plt = FOG_plt)
    
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
    
    Output.List$Output.List <- list("Economic Metrics (Adductor)" = Pane2.Adductor, 
                        "Economic Metrics (Whole)" = Pane2.Whole,
                        "Cost of Production" = COP,
                        "Equipment" = Equipment.Subset,
                        "Labor" = Labor.Subset,
                        "Fuel" = Fuel.Subset,
                        "Maintenance" = Maintenance.Subset,
                        "Primary Inputs" = Primary.Parameter.Data,
                        "Secondary" = Secondary.Data)
    
  })

}
###-----------Run Application------------------------------------------------------------------------------------------------------
# Run the application
shinyApp(ui, server)


































