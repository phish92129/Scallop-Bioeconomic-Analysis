# Load packages
library(readxl) # For reading excel tables
library(dplyr) # For data manipulation
library(plyr)  # For data manipulation and to seemingly interfere with dplyr
library(hablar) # For the function 'retype' that assigns values to data frame columns (ie character or numeric)

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
#Given a set of inputs - such as equiptment choices, essential costs, and other stuff

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
rm(VariableName, Value, Primary.Parameter.Data)

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
rm(VariableName, Value, Secondary.Data)

#This is where the looping would go---------------------------------------------------------
#-------------------------------------------------------------------------------------------

# Alright, I think I get it, so we can change the model assumptions for the analysis here
# Year = "Y0"         #c("Initial", "Y0", "Y1", "Y2", "Y3")

# Example Here, primary input of harvest year switched from Y3 to Y2
`Harvest Year` <- 'Y3'

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
if(`Harvest Year` == 'Y0'){
  Harvest.Year <- Y0
} else if(`Harvest Year` == 'Y1'){
  Harvest.Year <- Y1
} else if(`Harvest Year` == 'Y2'){
  Harvest.Year <- Y2
} else if(`Harvest Year` == 'Y3'){
  Harvest.Year <- Y3
}else{
  Harvest.Year <- Y4
}

# TBD creates a season vector for final labor allotment
if(`Harvest Season` == 'Fall'){
  Harvest.Season <- Fall
} else if(`Harvest Season` == 'Winter'){
  Harvest.Season <- Winter
} else if(`Harvest Season` == 'Spring'){
  Harvest.Season <- Spring
} else {
  Harvest.Season <- Summer}

# Create a product to market amount (currently placeholder)

Market.Data <- read_excel(file_path, sheet = 'Market')
for (i in 1:nrow(Market.Data)) {
  # Evaluate the Quarterly Mortality
  Market.Data$Market.Product[i]<- as.numeric(eval(parse(text = Market.Data$Market.Product[i])))
}
Market.Data$Market.Product <- as.numeric(Market.Data$Market.Product)
Growth.Data <- subset(Predicted.full, Year == `Harvest Year`& Season == `Harvest Season`& Trial == `Grow Out Method`)
Growth.Data <- Growth.Data[,-c(1,2,3,5)]
Growth.Data <- left_join(Growth.Data, Market.Data, by = c('Year','Season'))

# Creates a farm strategy vector for subseting based on grow out type
Farm.strat <- c(`Grow Out Method`,`Spat Procurement`,`Intermediate Culture`,'Global')

# Equipment

# Read Equipment Outputs, subset by Harvest year and farm strategy then merge with Unit Cost, Lifespan and quantity
Equipment <- read_excel(file_path, sheet = 'Equipment_Output')
Equipment.Subset <- Equipment[which(Equipment$Year %in% Harvest.Year& Equipment$Type %in% Farm.strat),]
Equipment.Subset <- within(merge(Equipment.Subset,Equipment.Data, by = 'Equipment'), 
                        {Quantity <- ifelse(is.na(Quantity.y),Quantity.x,Quantity.y); Quantity.x <- NULL; Quantity.y <- NULL})

# Created an issue here getting equipment to parse correctly with other data
# The issue comes with the Global category, which uses the total quantity of lantern nets and dropper lines
# to calculate longline length for the cost basis.  Since it is using data in the quantity column
# while it is iterating it can't force numeric since there is character data below it.
# To quickly get around this I separated the two data sets and ran the code twice on both, referencing
# the year class equipment for the global data set.  Then did a column bind of both data sets
 
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
  Lease.Footprint$l.Feet <- Lease.Footprint$Feet.Longline.Total/`Longline Quantity`
  Lease.Footprint$Meters.Longline.Total <- Lease.Footprint$Feet.Longline.Total * .3048
  Lease.Footprint$A.Feet <- Lease.Footprint$l.Feet * `Longline Spacing`
  Lease.Footprint$A.Meters <- Lease.Footprint$A.Feet * .3048
  Lease.Footprint$Acres <- (Lease.Footprint$l.Feet*`Longline Spacing`)*.0000229568
  
  # Leasing fees, from DMR and updated annually with lease type, Application fee, and annual fixed fee
  Lease.Type.M <- data.frame(     # DMR lease type
    Type = c('Experimental Lease','LPA','Standard Lease'),     # DMR lease types
    App.Fee = c(0,100,1500),     # Application fee (1 time)
    Annual.Fee = c(50,100,100)     # Annual lease fee charged by the acre
  )
  
  # Set lease type from Preset
  Lease.Type.M <- subset(Lease.Type.M, Type == `Lease Type`) 
    
  
# Labor metrics 
  # Calculate total labor time by season, hours worked, hours paid, etc
  
# Economic Metrics
  # Create a matrix to assign columns by their year class, growers might have to wait up to 4 years
  # Prior to first sale and that leads to significant deferment of costs.
  # Then add up total costs for all categories plus consumables == cost of goods sold.
  
  # Note, these are all variable costs
  
  # Fixed overhead costs
  
  # Annual costs irregardless of year and business plan
  # Sum Insurance, Shelffish/Aq License, Lease Rent, Owner Salary, Depreciation (By year)
  # These are fixed overhead costs, ie costs that cannot be circumvented 
  
  # COG + FOC = Cost of Production
  # We calculate from here two values, 10 year break even and run rate.
  # 10 year break even takes all 10 years of COP, sums them, and then averages by total scallop
  # sales (Individuals & Price/lb).  Run rate assumes no initial debt for equipment purchases.
  
  # COP, break even, and run rate used in analysis  
  
  # Next allow growers to set a price (maybe in primary inputs?) or in this section if possible
  
  # gross profit, 10 year forecast
  # subtract COGs from the total scallops sold each year (or total lbs sold each year) * Price (total revenue)
  
  # Net Profit, 10 years
  # Subtract FOC from GP to get net profit
  
  # Finally, free cash flow. 10 years
  # Free cash flow is the Net profit summed annually with depreciation removed (since it is a non-realized expense)
  # and this will be the cash you have 'in hand' at the end of each year
  
# For analysis we will also be using IRR (Internal rate of return) in one instance but will mostly be using break even and run rate
  
  
  
  
  
  
  
  
  
  