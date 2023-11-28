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
`Harvest Year` <- 'Y2'

# Subset by Harvest Year, Season and Grow Out Method
# This section creates vectors for subseting different criteria

# Creates vectors for Year steps
Y0 <- c('Y0','all')
Y1 <- c('Y0','Y1','all')
Y2 <- c('Y0','Y1','Y2','all')
Y3 <- c('Y0','Y1','Y2','Y3','all')

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
} else {
  Harvest.Year <- Y3}

# TBD creates a season vector for final labor allotment
if(`Harvest Season` == 'Fall'){
  Harvest.Season <- Fall
} else if(`Harvest Season` == 'Winter'){
  Harvest.Season <- Winter
} else if(`Harvest Season` == 'Spring'){
  Harvest.Season <- Spring
} else {
  Harvest.Season <- Summer}

# Creates a farm strategy vector for subseting based on grow out type
Farm.strat <- c(`Grow Out Method`,`Spat Procurement`,`Intermediate Culture`,'Global')

# Equipment

# Read Equipment Outputs, subset by Harvest year and farm strategy then merge with Unit Cost, Lifespan and quantity
Equipment <- read_excel(file_path, sheet = 'Equipment_Output')
Equipment.Subset <- Equipment[which(Equipment$Year %in% Harvest.Year& Equipment$Type %in% Farm.strat),]
Equipment.Subset <- within(merge(Equipment.Subset,Equipment.Data, by = 'Equipment'), 
                        {Quantity <- ifelse(is.na(Quantity.y),Quantity.x,Quantity.y); Quantity.x <- NULL; Quantity.y <- NULL})



#Equipment for used in farm strategy and harvest year
  for (i in 1:nrow(Equipment.Subset)) {
    # Evaluate the Quantity expression for this row, and do cost.basis and depreciation too
    Equipment.Subset$Quantity[i] <- as.numeric(eval(parse(text = Equipment.Subset$Quantity[i])))
    
    Equipment.Subset$Cost.Basis[i] <- Equipment.Subset$Unit.Cost[i] * as.numeric(eval(parse(text = Equipment.Subset$Quantity[i])))
    
    Equipment.Subset$Depreciation[i] <- Equipment.Subset$Cost.Basis[i] / Equipment.Subset$Lifespan[i]
  }
# Change Quantity to numeric because I am not a good coder
Equipment.Subset$Quantity <- as.numeric(Equipment.Subset$Quantity)

# Labor tasks similar to equipment but introduce seasonality

# Read Equipment Outputs, subset by Harvest year and farm strategy then merge with Unit Cost, Lifespan and quantity
Labor <- read_excel(file_path, sheet = 'Labor_Output')
Labor.Subset <- left_join(Labor,Task.Data, by = 'Task')
                           
Labor.Subset <- Labor.Subset[which(Labor.Subset$Year %in% Harvest.Year & Labor.Subset$Type %in% Farm.strat & Labor.Subset$Completed %in% 'Y'),]
Labor.Subset <- Labor.Subset[!(Labor.Subset$Year == `Harvest Year` & Labor.Subset$Season != Harvest.Season), ]

  for (i in 1:nrow(Task.Subset)){
    Task.Subset$Time[i] <- eval(parse(text = Task.Subset$Time[i]))
    Task.Subset$Trips[i] <- eval(parse(text = Task.Subset$Trips[i]))
    Task.Subset$Hours.Paid[i] <- ifelse(Task.Subset$Trips[i] > 0, round_any(as.numeric(Task.Subset$Time[i]), 8, f=ceiling), Task.Subset$Time[i])
    Task.Subset$Labor.Costs[i] <- Task.Subset$Hours.Paid[i] * Part.Time.Wage
  }
  Task.Subset$Time <- as.numeric(Task.Subset$Time)
  Task.Subset$Trips <- as.numeric(Task.Subset$Trips)

#Fuel for a given period
if (any(c(Year, 'all') %in% Fuel.Data$Year)){
  Fuel.Subset <- Fuel.Data[which(Fuel.Data$Year == Year| Fuel.Data$Year == 'all'),]
  for (i in 1:nrow(Fuel.Subset)){
    Fuel.Subset$Fuel.Cost[i] <- Fuel.Subset$Price.Gallon[i] * Fuel.Subset$Usage.Trip[i] * (sum(Task.Subset$Trips) + Fuel.Subset$Additional.Trips[i])
  }
}else{
  Fuel.Subset <- data.frame(matrix(ncol = length(Fuel.Data), nrow = 0))
  colnames(Fuel.Subset) <- colnames(Fuel.Data)
}

#Maintenance for a given period
if (any(c(Year, 'all') %in% Maint.Data$Year)){
  Maint.Subset <- Maint.Data[which(Maint.Data$Year == Year | Maint.Data$Year == 'all'),]
  for (i in 1:nrow(Maint.Subset)){
    Maint.Subset$Units[i] <- eval(parse(text = Maint.Subset$Units[i]))
    Maint.Subset$Maintenance.Costs[i] <- Maint.Subset$Cost[i] * as.numeric(Maint.Subset$Units[i])
  }
  Maint.Subset$Units <- as.numeric(Maint.Subset$Units)
}else{
  Maint.Subset <- data.frame(matrix(ncol = length(Maint.Data), nrow = 0))
  colnames(Maint.Subset) <- colnames(Maint.Data)
}

