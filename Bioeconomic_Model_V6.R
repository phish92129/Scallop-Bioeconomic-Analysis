library(readxl)
library(dplyr)
library(plyr)
library(hablar)
file_path <- "./Components_V2.xlsx"

# These are 'general' equipment inputs, labor tasks, fuel costs, and maintenance.  
# I envision these will be deisigned to essentially be the 'entry' sections while the following sheet 
# Will be the hard coding not meant to be altered.

Equipment.Data <- read_excel(file_path, sheet = 'Equipment')
Task.Data <- read_excel(file_path, sheet = 'Labor')
Fuel.Data <- read_excel(file_path, sheet = 'Fuel')
Maint.Data <- read_excel(file_path, sheet = 'Maintenance')

#Lets go through how this would hypothetically work
#Given a set of inputs - such as equiptment choices, essential costs, and other stuff
Primary.Parameter.Data<- read_excel(file_path, sheet = 'Primary')

for (i in 1:nrow(Primary.Parameter.Data)) {
  VariableName <- as.character(Primary.Parameter.Data[i, 1])
  Value <- retype(Primary.Parameter.Data[i, 2,drop=TRUE]) 
  assign(VariableName, Value, envir = .GlobalEnv)
}
rm(VariableName, Value, Primary.Parameter.Data)

# Let's add the secondary parameters
Secondary.Data<- read_excel(file_path, sheet = 'Secondary')

for (i in 1:nrow(Secondary.Data)) {
  VariableName <- as.character(Secondary.Data[i, 1])
  Value <- retype(Secondary.Data[i, 2,drop=TRUE])
  Value <- eval(parse(text=Value))
  assign(VariableName, Value, envir = .GlobalEnv)
}
rm(VariableName, Value, Secondary.Data)

#This is where the looping would go---------------------------------------------------------
#-------------------------------------------------------------------------------------------

# Alright, I think I get it, so we can change the model assumptions for the analysis here
Year = "Y0"         #c("Initial", "Y0", "Y1", "Y2", "Y3")

#Equipment for a given period
if (any(c(Year, 'all') %in% Task.Data$Year)){
  Equipment.Subset <- Equipment.Data[which(Equipment.Data$Year == Year) ,]
  for (i in 1:nrow(Equipment.Subset)) {
    # Evaluate the Quantity expression for this row, and do cost.basis and depreciation too
    Equipment.Subset$Quantity[i] <- eval(parse(text = Equipment.Subset$Quantity[i]))
    
    Equipment.Subset$Cost.Basis[i] <- Equipment.Subset$Unit.Cost[i] * eval(parse(text = Equipment.Subset$Quantity[i]))
    
    Equipment.Subset$Depreciation[i] <- Equipment.Subset$Cost.Basis[i] / Equipment.Subset$Lifespan[i]
  }
  Equipment.Subset$Quantity <- as.numeric(Equipment.Subset$Quantity)
}else{
  Equipment.Subset <- data.frame(matrix(ncol = length(Equipment.Data), nrow = 0))
  colnames(Equipment.Subset) <- colnames(Equipment.Data)
}

#Tasks for a given period
if (any(c(Year, 'all') %in% Task.Data$Year)){
  Task.Subset <- Task.Data[which(Task.Data$Year == Year), ] 
  for (i in 1:nrow(Task.Subset)){
    Task.Subset$Time[i] <- eval(parse(text = Task.Subset$Time[i]))
    Task.Subset$Trips[i] <- eval(parse(text = Task.Subset$Trips[i]))
    Task.Subset$Hours.Paid[i] <- ifelse(Task.Subset$Trips[i] > 0, round_any(as.numeric(Task.Subset$Time[i]), 8, f=ceiling), Task.Subset$Time[i])
    Task.Subset$Labor.Costs[i] <- Task.Subset$Hours.Paid[i] * Part.Time.Wage
  }
  Task.Subset$Time <- as.numeric(Task.Subset$Time)
  Task.Subset$Trips <- as.numeric(Task.Subset$Trips)
}else{
  Task.Subset <- data.frame(matrix(ncol = length(Task.Data), nrow = 0))
  colnames(Task.Subset) <- colnames(Task.Data)
}

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

