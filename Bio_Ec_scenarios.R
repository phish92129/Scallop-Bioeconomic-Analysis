###### Write a function to create a matrix for iterative functioning

# Sub scenario breakdown

# a) whole scallop - vessel and truck already obtained
# b) adductor only - vessel and truck already obtained
# c) whole scallop - vessel and truck as cap-ex
# d) adductor only - vessel and truck as cap-ex

# Scenario 1abcd: Ear Hanging sold after 1 year of grow out at 10,000 : 250000 by 10,000 
# Ear Hanging assumes an automated drilling maching is selected for these scenarios

Product <- seq(10000,1000000,by=10000)
output = data.frame()
Y2 <- 'Year 2: Ear Hanging'
Y3 <- 'NULL'

# Scenario A/B

# Vessel for aquaculture site operations, price should incude skiff
Vessel <- data.frame(
  Equipment = 'Vessel',    
  Unit.Cost = c(150000),
  Lifespan = c(15),
  Quantity = 0      # Must enter quantity for different scenarios
)

# Work vehicle for transport to vessel and other tasks
Truck <- data.frame(
  Equipment = 'Work Truck', 
  Unit.Cost = c(25000),
  Lifespan = c(10),
  Quantity = 0     # Must enter quantity for different scenarios
)

for (i in 1:length(Product)) {
  
  test <- P.L( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
               Longline.Quantity,        # Number of longlines on the farm                  
               Longline.Depth,           # Lease Depth (Feet) at low tide
               Longline.Suspended.Depth, # Projected Longline Depth at low tide  
               Product[i],                  # Number of individual scallop spat
               Year.Start,               # Year of projected farm operations start: Model begins August 1st
               Consumables,              # Includes general expenditures like Gear,coffee,misc
               Owner.salary,             # Predicted annual owner salary
               Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
               Full.Time.Employee,       # Number of full time employees
               Employee.Salary,          # Annual full time employee salary
               Part.Time.Wage,           # Hourly rate for part time wages
               Y0,                       # Spat procurement type, only option is 'Year 0: Wild Spat - Collected' 
               # currently
               Y1,                       # Intermediate culture type, only option is 'Year 1: Lantern Net' 
               # currently
               Y2,                       # One year grow-out culture, options are 'Year 2: Lantern Net' 
               # 'Year 2: Ear Hanging'
               Y3,                       # Two year grow-out culture, options are 'Year 3: Lantern Net' 
               # 'Year 3: Ear Hanging' or 'NULL' to opt for a single year grow-out
               Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
               Spat.Site.Depth,          # Depth at which spat collection lines are set
               Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
               Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
               Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
               Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
               Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
               Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
               Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
               Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
               Y1.Mortality,             # Mortality from August Y1 till August Y2
               Y2.Mortality,             # Mortality from August Y2 till August Y3
               Y3.Mortality             # Mortality from August Y3 till August Y4
               
  )            # Mortality from August Y3 till August Y4

  test$Product <- Product[i]
  # 
 output =  rbind(output,test)
  
  
}

S1.AB.PL <- output
S1.AB.PL$Scenario <- 'Scenario 1'
S1.AB.PL$Sub <- 'A/B'


# Scenario D/C 


output = data.frame()
Y2 <- 'Year 2: Ear Hanging'
Y3 <- 'NULL'

# Scenario A/B

# Vessel for aquaculture site operations, price should incude skiff
Vessel <- data.frame(
  Equipment = 'Vessel',    
  Unit.Cost = c(150000),
  Lifespan = c(15),
  Quantity = 1      # Must enter quantity for different scenarios
)

# Work vehicle for transport to vessel and other tasks
Truck <- data.frame(
  Equipment = 'Work Truck', 
  Unit.Cost = c(25000),
  Lifespan = c(10),
  Quantity = 1     # Must enter quantity for different scenarios
)

for (i in 1:length(Product)) {
  
  test <- P.L( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
               Longline.Quantity,        # Number of longlines on the farm                  
               Longline.Depth,           # Lease Depth (Feet) at low tide
               Longline.Suspended.Depth, # Projected Longline Depth at low tide  
               Product[i],                  # Number of individual scallop spat
               Year.Start,               # Year of projected farm operations start: Model begins August 1st
               Consumables,              # Includes general expenditures like Gear,coffee,misc
               Owner.salary,             # Predicted annual owner salary
               Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
               Full.Time.Employee,       # Number of full time employees
               Employee.Salary,          # Annual full time employee salary
               Part.Time.Wage,           # Hourly rate for part time wages
               Y0,                       # Spat procurement type, only option is 'Year 0: Wild Spat - Collected' 
               # currently
               Y1,                       # Intermediate culture type, only option is 'Year 1: Lantern Net' 
               # currently
               Y2,                       # One year grow-out culture, options are 'Year 2: Lantern Net' 
               # 'Year 2: Ear Hanging'
               Y3,                       # Two year grow-out culture, options are 'Year 3: Lantern Net' 
               # 'Year 3: Ear Hanging' or 'NULL' to opt for a single year grow-out
               Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
               Spat.Site.Depth,          # Depth at which spat collection lines are set
               Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
               Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
               Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
               Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
               Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
               Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
               Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
               Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
               Y1.Mortality,             # Mortality from August Y1 till August Y2
               Y2.Mortality,             # Mortality from August Y2 till August Y3
               Y3.Mortality             # Mortality from August Y3 till August Y4
               
  )            # Mortality from August Y3 till August Y4
  
  test$Product <- Product[i]
  # 
  output =  rbind(output,test)
  
  
}

S1.DC.PL <- output
S1.DC.PL$Scenario <- 'Scenario 1'
S1.DC.PL$Sub <- 'C/D'

# Costs for 100000 scallop farm



# Scenario 2abcd: Ear Hanging sold after 2 years of grow out at 10,000 : 250000 by 10,000 
# Ear Hanging assumes an automated drilling machine is selected for these scenarios


output = data.frame()
Y2 <- 'Year 2: Ear Hanging'
Y3 <- 'Year 3: Ear Hanging'

# Scenario A/B

# Vessel for aquaculture site operations, price should incude skiff
Vessel <- data.frame(
  Equipment = 'Vessel',    
  Unit.Cost = c(150000),
  Lifespan = c(15),
  Quantity = 0      # Must enter quantity for different scenarios
)

# Work vehicle for transport to vessel and other tasks
Truck <- data.frame(
  Equipment = 'Work Truck', 
  Unit.Cost = c(25000),
  Lifespan = c(10),
  Quantity = 0     # Must enter quantity for different scenarios
)

for (i in 1:length(Product)) {
  
  test <- P.L( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
               Longline.Quantity,        # Number of longlines on the farm                  
               Longline.Depth,           # Lease Depth (Feet) at low tide
               Longline.Suspended.Depth, # Projected Longline Depth at low tide  
               Product[i],                  # Number of individual scallop spat
               Year.Start,               # Year of projected farm operations start: Model begins August 1st
               Consumables,              # Includes general expenditures like Gear,coffee,misc
               Owner.salary,             # Predicted annual owner salary
               Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
               Full.Time.Employee,       # Number of full time employees
               Employee.Salary,          # Annual full time employee salary
               Part.Time.Wage,           # Hourly rate for part time wages
               Y0,                       # Spat procurement type, only option is 'Year 0: Wild Spat - Collected' 
               # currently
               Y1,                       # Intermediate culture type, only option is 'Year 1: Lantern Net' 
               # currently
               Y2,                       # One year grow-out culture, options are 'Year 2: Lantern Net' 
               # 'Year 2: Ear Hanging'
               Y3,                       # Two year grow-out culture, options are 'Year 3: Lantern Net' 
               # 'Year 3: Ear Hanging' or 'NULL' to opt for a single year grow-out
               Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
               Spat.Site.Depth,          # Depth at which spat collection lines are set
               Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
               Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
               Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
               Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
               Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
               Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
               Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
               Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
               Y1.Mortality,             # Mortality from August Y1 till August Y2
               Y2.Mortality,             # Mortality from August Y2 till August Y3
               Y3.Mortality             # Mortality from August Y3 till August Y4
               
  )            # Mortality from August Y3 till August Y4
  
  test$Product <- Product[i]
  # 
  output =  rbind(output,test)
  
  
}

S2.AB.PL <- output
S2.AB.PL$Scenario <- 'Scenario 2'
S2.AB.PL$Sub <- 'A/B'

# Costs for 100000 scallop farm


# Scenario D/C 

output = data.frame()
Y2 <- 'Year 2: Ear Hanging'
Y3 <- 'Year 3: Ear Hanging'

# Scenario A/B

# Vessel for aquaculture site operations, price should incude skiff
Vessel <- data.frame(
  Equipment = 'Vessel',    
  Unit.Cost = c(150000),
  Lifespan = c(15),
  Quantity = 1      # Must enter quantity for different scenarios
)

# Work vehicle for transport to vessel and other tasks
Truck <- data.frame(
  Equipment = 'Work Truck', 
  Unit.Cost = c(25000),
  Lifespan = c(10),
  Quantity = 1     # Must enter quantity for different scenarios
)

for (i in 1:length(Product)) {
  
  test <- P.L( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
               Longline.Quantity,        # Number of longlines on the farm                  
               Longline.Depth,           # Lease Depth (Feet) at low tide
               Longline.Suspended.Depth, # Projected Longline Depth at low tide  
               Product[i],                  # Number of individual scallop spat
               Year.Start,               # Year of projected farm operations start: Model begins August 1st
               Consumables,              # Includes general expenditures like Gear,coffee,misc
               Owner.salary,             # Predicted annual owner salary
               Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
               Full.Time.Employee,       # Number of full time employees
               Employee.Salary,          # Annual full time employee salary
               Part.Time.Wage,           # Hourly rate for part time wages
               Y0,                       # Spat procurement type, only option is 'Year 0: Wild Spat - Collected' 
               # currently
               Y1,                       # Intermediate culture type, only option is 'Year 1: Lantern Net' 
               # currently
               Y2,                       # One year grow-out culture, options are 'Year 2: Lantern Net' 
               # 'Year 2: Ear Hanging'
               Y3,                       # Two year grow-out culture, options are 'Year 3: Lantern Net' 
               # 'Year 3: Ear Hanging' or 'NULL' to opt for a single year grow-out
               Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
               Spat.Site.Depth,          # Depth at which spat collection lines are set
               Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
               Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
               Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
               Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
               Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
               Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
               Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
               Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
               Y1.Mortality,             # Mortality from August Y1 till August Y2
               Y2.Mortality,             # Mortality from August Y2 till August Y3
               Y3.Mortality             # Mortality from August Y3 till August Y4
               
  )            # Mortality from August Y3 till August Y4
  
  test$Product <- Product[i]
  # 
  output =  rbind(output,test)
  
  
}

S2.DC.PL <- output
S2.DC.PL$Scenario <- 'Scenario 2'
S2.DC.PL$Sub <- 'C/D'

# Costs for 100000 scallop farm



# Scenario 3abcd: Lantern Net sold after 1 year of grow out at 10,000 : 250000 by 10,000 
# Ear Hanging assumes an automated drilling maching is selected for these scenarios

output = data.frame()
Y2 <- 'Year 2: Lantern Net'
Y3 <- 'NULL'

# Scenario A/B

# Vessel for aquaculture site operations, price should incude skiff
Vessel <- data.frame(
  Equipment = 'Vessel',    
  Unit.Cost = c(150000),
  Lifespan = c(15),
  Quantity = 0      # Must enter quantity for different scenarios
)

# Work vehicle for transport to vessel and other tasks
Truck <- data.frame(
  Equipment = 'Work Truck', 
  Unit.Cost = c(25000),
  Lifespan = c(10),
  Quantity = 0     # Must enter quantity for different scenarios
)

for (i in 1:length(Product)) {
  
  test <- P.L( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
               Longline.Quantity,        # Number of longlines on the farm                  
               Longline.Depth,           # Lease Depth (Feet) at low tide
               Longline.Suspended.Depth, # Projected Longline Depth at low tide  
               Product[i],                  # Number of individual scallop spat
               Year.Start,               # Year of projected farm operations start: Model begins August 1st
               Consumables,              # Includes general expenditures like Gear,coffee,misc
               Owner.salary,             # Predicted annual owner salary
               Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
               Full.Time.Employee,       # Number of full time employees
               Employee.Salary,          # Annual full time employee salary
               Part.Time.Wage,           # Hourly rate for part time wages
               Y0,                       # Spat procurement type, only option is 'Year 0: Wild Spat - Collected' 
               # currently
               Y1,                       # Intermediate culture type, only option is 'Year 1: Lantern Net' 
               # currently
               Y2,                       # One year grow-out culture, options are 'Year 2: Lantern Net' 
               # 'Year 2: Ear Hanging'
               Y3,                       # Two year grow-out culture, options are 'Year 3: Lantern Net' 
               # 'Year 3: Ear Hanging' or 'NULL' to opt for a single year grow-out
               Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
               Spat.Site.Depth,          # Depth at which spat collection lines are set
               Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
               Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
               Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
               Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
               Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
               Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
               Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
               Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
               Y1.Mortality,             # Mortality from August Y1 till August Y2
               Y2.Mortality,             # Mortality from August Y2 till August Y3
               Y3.Mortality             # Mortality from August Y3 till August Y4
               
  )            # Mortality from August Y3 till August Y4
  
  test$Product <- Product[i]
  # 
  output =  rbind(output,test)
  
  
}

S3.AB.PL <- output
S3.AB.PL$Scenario <- 'Scenario 3'
S3.AB.PL$Sub <- 'A/B'

# Costs for 100000 scallop farm



# Scenario D/C 


output = data.frame()
Y2 <- 'Year 2: Lantern Net'
Y3 <- 'NULL'

# Scenario A/B

# Vessel for aquaculture site operations, price should incude skiff
Vessel <- data.frame(
  Equipment = 'Vessel',    
  Unit.Cost = c(150000),
  Lifespan = c(15),
  Quantity = 1      # Must enter quantity for different scenarios
)

# Work vehicle for transport to vessel and other tasks
Truck <- data.frame(
  Equipment = 'Work Truck', 
  Unit.Cost = c(25000),
  Lifespan = c(10),
  Quantity = 1     # Must enter quantity for different scenarios
)

for (i in 1:length(Product)) {
  
  test <- P.L( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
               Longline.Quantity,        # Number of longlines on the farm                  
               Longline.Depth,           # Lease Depth (Feet) at low tide
               Longline.Suspended.Depth, # Projected Longline Depth at low tide  
               Product[i],                  # Number of individual scallop spat
               Year.Start,               # Year of projected farm operations start: Model begins August 1st
               Consumables,              # Includes general expenditures like Gear,coffee,misc
               Owner.salary,             # Predicted annual owner salary
               Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
               Full.Time.Employee,       # Number of full time employees
               Employee.Salary,          # Annual full time employee salary
               Part.Time.Wage,           # Hourly rate for part time wages
               Y0,                       # Spat procurement type, only option is 'Year 0: Wild Spat - Collected' 
               # currently
               Y1,                       # Intermediate culture type, only option is 'Year 1: Lantern Net' 
               # currently
               Y2,                       # One year grow-out culture, options are 'Year 2: Lantern Net' 
               # 'Year 2: Ear Hanging'
               Y3,                       # Two year grow-out culture, options are 'Year 3: Lantern Net' 
               # 'Year 3: Ear Hanging' or 'NULL' to opt for a single year grow-out
               Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
               Spat.Site.Depth,          # Depth at which spat collection lines are set
               Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
               Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
               Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
               Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
               Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
               Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
               Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
               Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
               Y1.Mortality,             # Mortality from August Y1 till August Y2
               Y2.Mortality,             # Mortality from August Y2 till August Y3
               Y3.Mortality             # Mortality from August Y3 till August Y4
               
  )            # Mortality from August Y3 till August Y4
  
  test$Product <- Product[i]
  # 
  output =  rbind(output,test)
  
  
}

S3.DC.PL <- output
S3.DC.PL$Scenario <- 'Scenario 3'
S3.DC.PL$Sub <- 'C/D'

# Costs for 100000 scallop farm



# Scenario 4abcd: Lantern Net sold after 2 years of grow out at 10,000 : 250000 by 10,000 
# Ear Hanging assumes an automated drilling maching is selected for these scenarios


output = data.frame()
Y2 <- 'Year 2: Lantern Net'
Y3 <- 'Year 3: Lantern Net'

# Scenario A/B

# Vessel for aquaculture site operations, price should incude skiff
Vessel <- data.frame(
  Equipment = 'Vessel',    
  Unit.Cost = c(150000),
  Lifespan = c(15),
  Quantity = 0      # Must enter quantity for different scenarios
)

# Work vehicle for transport to vessel and other tasks
Truck <- data.frame(
  Equipment = 'Work Truck', 
  Unit.Cost = c(25000),
  Lifespan = c(10),
  Quantity = 0     # Must enter quantity for different scenarios
)

for (i in 1:length(Product)) {
  
  test <- P.L( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
               Longline.Quantity,        # Number of longlines on the farm                  
               Longline.Depth,           # Lease Depth (Feet) at low tide
               Longline.Suspended.Depth, # Projected Longline Depth at low tide  
               Product[i],                  # Number of individual scallop spat
               Year.Start,               # Year of projected farm operations start: Model begins August 1st
               Consumables,              # Includes general expenditures like Gear,coffee,misc
               Owner.salary,             # Predicted annual owner salary
               Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
               Full.Time.Employee,       # Number of full time employees
               Employee.Salary,          # Annual full time employee salary
               Part.Time.Wage,           # Hourly rate for part time wages
               Y0,                       # Spat procurement type, only option is 'Year 0: Wild Spat - Collected' 
               # currently
               Y1,                       # Intermediate culture type, only option is 'Year 1: Lantern Net' 
               # currently
               Y2,                       # One year grow-out culture, options are 'Year 2: Lantern Net' 
               # 'Year 2: Ear Hanging'
               Y3,                       # Two year grow-out culture, options are 'Year 3: Lantern Net' 
               # 'Year 3: Ear Hanging' or 'NULL' to opt for a single year grow-out
               Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
               Spat.Site.Depth,          # Depth at which spat collection lines are set
               Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
               Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
               Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
               Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
               Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
               Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
               Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
               Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
               Y1.Mortality,             # Mortality from August Y1 till August Y2
               Y2.Mortality,             # Mortality from August Y2 till August Y3
               Y3.Mortality             # Mortality from August Y3 till August Y4
               
  )            # Mortality from August Y3 till August Y4
  
  test$Product <- Product[i]
  # 
  output =  rbind(output,test)
  
  
}

S4.AB.PL <- output
S4.AB.PL$Scenario <- 'Scenario 4'
S4.AB.PL$Sub <- 'A/B'

# Costs for 100000 scallop farm



# Scenario D/C 

output = data.frame()
Y2 <- 'Year 2: Lantern Net'
Y3 <- 'Year 3: Lantern Net'

# Scenario A/B

# Vessel for aquaculture site operations, price should incude skiff
Vessel <- data.frame(
  Equipment = 'Vessel',    
  Unit.Cost = c(150000),
  Lifespan = c(15),
  Quantity = 1      # Must enter quantity for different scenarios
)

# Work vehicle for transport to vessel and other tasks
Truck <- data.frame(
  Equipment = 'Work Truck', 
  Unit.Cost = c(25000),
  Lifespan = c(10),
  Quantity = 1     # Must enter quantity for different scenarios
)

for (i in 1:length(Product)) {
  
  test <- P.L( Lease.Type,               # Can select from 'Standard Lease' 'LPA' or 'Experimental Lease'
               Longline.Quantity,        # Number of longlines on the farm                  
               Longline.Depth,           # Lease Depth (Feet) at low tide
               Longline.Suspended.Depth, # Projected Longline Depth at low tide  
               Product[i],                  # Number of individual scallop spat
               Year.Start,               # Year of projected farm operations start: Model begins August 1st
               Consumables,              # Includes general expenditures like Gear,coffee,misc
               Owner.salary,             # Predicted annual owner salary
               Insurance,                # Annual Insurance Costs for vehicles, personnel, etc
               Full.Time.Employee,       # Number of full time employees
               Employee.Salary,          # Annual full time employee salary
               Part.Time.Wage,           # Hourly rate for part time wages
               Y0,                       # Spat procurement type, only option is 'Year 0: Wild Spat - Collected' 
               # currently
               Y1,                       # Intermediate culture type, only option is 'Year 1: Lantern Net' 
               # currently
               Y2,                       # One year grow-out culture, options are 'Year 2: Lantern Net' 
               # 'Year 2: Ear Hanging'
               Y3,                       # Two year grow-out culture, options are 'Year 3: Lantern Net' 
               # 'Year 3: Ear Hanging' or 'NULL' to opt for a single year grow-out
               Wild.Spat.Collector,      # Number of Wild Spat estimated/collector
               Spat.Site.Depth,          # Depth at which spat collection lines are set
               Seed.Net.Density,         # Growth Assumes 250/tier initial stocking density
               Y1.Stocking.Density,      # Intermediary Culture stocking density (recommended 45-25)
               Y2.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 15-10)
               Y3.LN.Stocking.Density,   # Grow-Out Culture Stocking density (recommended 10-5)
               Y2.EH.Dropper.Scallops.per,     # Total scallops per dropper (assumes paired setup)
               Y2.EH.Scallop.Spacing,    # Spacing between scallops in feet
               Y2.EH.Dropper.Margins,    # Margin is the total space on either end rope without scallops in feet
               Y0.Mortality,             # Estimated Wild Spat from Y0 August 01 Start Date - August 01 Y1
               Y1.Mortality,             # Mortality from August Y1 till August Y2
               Y2.Mortality,             # Mortality from August Y2 till August Y3
               Y3.Mortality             # Mortality from August Y3 till August Y4
               
  )            # Mortality from August Y3 till August Y4
  
  test$Product <- Product[i]
  # 
  output =  rbind(output,test)
  
  
}

S4.DC.PL <- output
S4.DC.PL$Scenario <- 'Scenario 4'
S4.DC.PL$Sub <- 'C/D'

# Costs for 100000 scallop farm




Scaling <- rbind(S1.AB.PL,S1.DC.PL,S2.AB.PL,S2.DC.PL,S3.AB.PL,S3.DC.PL,S4.AB.PL,S4.DC.PL)

Scaling$Growout <- ifelse(Scaling$Scenario == "Scenario 1" | Scaling$Scenario == "Scenario 2", 'Ear Hanging', 'Lantern Net')
Scaling$Harvest.Year <- ifelse(Scaling$Scenario == "Scenario 1" | Scaling$Scenario == "Scenario 3", '1 Year Grow-Out', 
                               '2 Years Grow-Out')

Scaling$offset.Year <- ifelse(Scaling$Sub == 'A/B', Scaling$Year+.1, Scaling$Year-.1)

Scaling <- subset(Scaling, Product >50000 & Product <200000)
Scaling <- subset(Scaling, Growout == 'Ear Hanging'& Harvest.Year == '2 Years Grow-Out')

# Visualization 

library(viridis)

P1 <-ggplot(Scaling, aes(x = offset.Year))  + 
  geom_point(aes(y = MaxPrice.AdductorWeight, shape = Sub), size = 1.2)+
  geom_point (data = subset(Scaling, Product == 100000), aes(x=offset.Year, y=MaxPrice.AdductorWeight,shape=Sub), color = 'green',size=1.5,pch=21) +
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  ggtitle("Break Even Price for Scaled Production 50000-200000 Seed in Ear Hanging Harvesting after 2 years") +
  ylab("Annual Yearly Break Even Sales Price")+
  labs(color = "Projected Starting Seed")+
  xlab("Business Year")+
  theme(plot.title = element_text(size=14, face="bold"),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "right",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1)) 


Scaling.sub <- subset(Scaling, Year == 10)
P2 <- ggplot(Scaling.sub, aes(x = Product, y = MinPrice.AdductorWeight))  + 
  geom_line( size = 1.2)+
  geom_point(data=subset(Scaling.sub, Product == 100000), aes(x=Product,y=MinPrice.AdductorWeight), size=2,fill='gold',pch=21) +
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  ggtitle("Run Rate Price for Scaled Production 50000-200000 Seed in Ear Hanging Harvesting after 2 years") +
  ylab("Run Rate")+
  labs(color = "Grow-Out Type", linetype = "Harvest")+
  xlab("Total Seed Goal")+
  theme(plot.title = element_text(size=14, face="bold"),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1)) 
  
  P3 <- ggplot(data = subset(Scaling, Product == 100000), aes(x=offset.Year, y=MaxPrice.AdductorWeight,shape=Sub))  + 
    geom_point(size=3, fill = 'green',pch=21) +
    geom_hline(data=subset(Scaling.sub, Product == 100000), aes(yintercept=MinPrice.AdductorWeight),size=1.2, color='gold',linetype='dashed') +
    theme_minimal() +
    theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
    theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
    ggtitle("Single Production Scenario for 100,000 Seed Farm")+
  ylab("Cost per lbs to Break Even (Green) and Run Rate(Gold)")+ 
    labs(color = "Grow-Out Type", linetype = "Harvest")+
    xlab("Business Year")+
    theme(plot.title = element_text(size=14, face="bold"),
          strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
          strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
          legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
          axis.title.y = element_text(face="bold", size=8,
                                      margin = margin(t = 0, r = 10, b = 0, l = 0)), 
          axis.text.y = element_text(size=12),
          axis.text.x = element_text(size=12, angle = 35, hjust = .85),
          panel.border = element_rect(colour = "black", fill=NA, size=1)) 
  
  plot_grid(P1,P2,P3,ncol=1)

ggplot(Scaling.sub, aes(x = Product, y = MinPrice.AdductorWeight))  + 
  geom_line(aes(color = Growout, linetype = Harvest.Year), size = 1.2)+
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  ylab("Run Rate")+
  labs(color = "Grow-Out Type", linetype = "Harvest")+
  xlab("Total Seed Goal")+
  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1)) 

Scaling.sub.4 <- subset(Scaling, Year == 4)

ggplot(Scaling.sub.4, aes(x = Product, y = MaxPrice.AdductorWeight))  + 
  geom_line(aes(color = Growout, linetype = Harvest.Year), size = 1.2)+
  theme_minimal() +
  facet_grid(~Sub) +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  ylab("4 Year Price to Debt Fulfillment")+
  labs(color = "Grow-Out Type", linetype = "Harvest")+
  xlab("Total Seed Goal")+
  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1)) 

ggplot(Scaling.sub, aes(x = Product, y = MaxPrice.WholeScallop))  + 
  geom_line(aes(color = Growout, linetype = Harvest.Year), size = 1.2)+
  theme_minimal() +
  facet_grid(~Sub) +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  ylab("10 Year Price to Debt Fulfillment")+
  labs(color = "Grow-Out Type", linetype = "Harvest")+
  xlab("Total Seed Goal")+
  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1)) 




ggplot(Scaling, aes(x = Product, y = Lease.Footprint.Acres))  + 
  geom_line(aes(color = Growout, linetype = Harvest.Year), size = 1.2)+
  geom_hline(aes(yintercept = 3.9), color = 'blue') +
  annotate("text", x=900000, y=5.2, label="Median Maine Lease Size = 3.9 acres") +
  geom_hline(aes(yintercept = 8.04), color = 'blue') +
  annotate("text", x=900000, y=9.3, label="Mean Maine Lease Size = 8.04 acres") +
  geom_hline(aes(yintercept = 22.028), color = 'blue') +
  annotate("text", x=250000, y=23.3, label="90th Percentile Maine Lease Size = 22 acres") +
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  ylab("Lease Size (Acres)")+
  labs(color = "Grow-Out Type", linetype = "Harvest")+
  xlab("Total Seed Goal")+
  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1)) 


library(treemapify)

scaling.costs <- gather(Scaling.sub,'Category','Cost', Fuel:Depreciation)
scaling.costs <- subset (scaling.costs, Product == 50000 | Product == 150000 | Product == 250000)
scaling.costs <- subset(scaling.costs, Sub == 'C/D'&Harvest.Year == '2 Years Grow-Out')

ggplot(scaling.costs, aes(area =Cost, fill = Category,
                          label = paste(Category, Cost, sep = "\n")))  + 
  geom_treemap() +
  geom_treemap_text(colour = "white",
                    place = "centre",
                    size = 15) +
  facet_grid(Product~Growout) +
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
 
  labs(fill = "Annual Cost Category")+

  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1)) 

scaling.costs.2 <- gather(Scaling.sub,'Category','Cost', c(Fuel:Depreciation,Total.Annual.Costs))
scaling.costs.2 <- subset(scaling.costs.2, Category == 'Total.Annual.Costs')
scaling.costs.2 <- subset (scaling.costs.2, Product == 50000 | Product == 150000 | Product == 250000)
scaling.costs.2 <- subset(scaling.costs.2, Sub == 'C/D')   

ggplot(scaling.costs.2, aes(area =Cost, fill = Growout,
                          label = paste(Category, Cost, sep = "\n")))  + 
  geom_treemap() +
  geom_treemap_text(colour = "white",
                    place = "centre",
                    size = 15) +
  facet_grid (Product~Harvest.Year) +
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  
  labs(fill = "Annual Cost Category")+
  
  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1))


scaling.costs.3 <- scaling.costs
scaling.costs.3$Costs <- ifelse(scaling.costs.3$Category == 'Labor', scaling.costs.3$Cost-50000, scaling.costs.3$Cost)

ggplot(scaling.costs.3, aes(area =Costs, fill = Category,
                          label = paste(Category, Costs, sep = "\n")))  + 
  geom_treemap() +
  geom_treemap_text(colour = "white",
                    place = "centre",
                    size = 15) +
  facet_grid(Product~Growout) +
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  
  labs(fill = "Annual Cost Category")+
  
  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1)) 

# Let's try a bump chart

x <- seq(0,1000000, by=50000)

library(ggbump)
scaling.costs.3 <- gather(Scaling.sub,'Category','Cost', Fuel:Depreciation)
scaling.costs.3 <- subset(scaling.costs.3, Sub == 'C/D'&Harvest.Year == '2 Years Grow-Out')
scaling.costs.3 <- subset(scaling.costs.3, Product == 10000 |Product == 150000 |Product == 300000 |Product == 450000 |Product == 600000 |Product == 750000 |Product == 900000 |Product == 1000000 )
scaling.costs.3$Costs <- ifelse(scaling.costs.3$Category == 'Labor', scaling.costs.3$Cost-50000, scaling.costs.3$Cost)
scaling.costs.3$Total.Annual.Costs<- scaling.costs.3$Total.Annual.Costs-50000
scaling.costs.3$Prop.cost <- scaling.costs.3$Costs/scaling.costs.3$Total.Annual.Costs

P2 <- ggplot(scaling.costs.3, aes( x=Product, y = Prop.cost, color = Category))  + 
  geom_bump(size=1.5) +
  geom_point(size=3)+
  facet_grid (~Growout) +
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  
  labs(fill = "Annual Cost Category")+
  
  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1))

library(cowplot)
plot_grid(P1,P2, ncol=1)

scaling.costs.3$Product <- as.factor(scaling.costs.3$Product)
 ggplot(scaling.costs.3, aes(y = Costs,x = Product, fill = Category))  + 
  geom_bar(stat = 'identity') +
  facet_grid (~Growout) +
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  
  labs(fill = "Annual Cost Category")+
  
  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1))
 
 Scaling.Hours <- Scaling
 Scaling.Hours <- aggregate(data = Scaling.Hours, Hours.Worked ~ Product+Growout+Harvest.Year,sum,na.rm=TRUE) 
Scaling.Hours$Days <- Scaling.Hours$Hours.Worked/8 

Scaling.Hours.Sub <- subset(Scaling.Hours, Product<200000)
ggplot(Scaling.Hours.Sub, aes(x = Product, y = Days))  + 
  geom_line(aes(color = Growout, linetype = Harvest.Year), size = 1.2)+
  theme_minimal() +
  theme(panel.grid.major.x=element_blank(), panel.grid.major.y=element_blank()) + #remove gridlines
  theme(panel.grid.minor.x=element_blank(), panel.grid.minor.y=element_blank()) + #remove gridlines
  ylab("Days Worked (Based on 8 Hour Day)")+
  labs(color = "Grow-Out Type", linetype = "Harvest")+
  xlab("Total Seed Goal")+
  theme(plot.title = element_blank (),
        strip.text.x = element_text(size=12, face="bold"), legend.position = "bottom",
        strip.text.y = element_text(size=12, face="bold"),axis.title.x = element_text(face="bold", size=12),
        legend.title = element_text(size=12, face="bold"), legend.text = element_text(size = 12),
        axis.title.y = element_text(face="bold", size=12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)), 
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=12, angle = 35, hjust = .85),
        panel.border = element_rect(colour = "black", fill=NA, size=1)) 


