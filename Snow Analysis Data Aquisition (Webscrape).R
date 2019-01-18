ID <- c("BMW", "WWC", "UBC", "MTM", "STL", "BCB", "CRL", "BSH")
Name <- c("Big Meadows", "West Woodchuck Meadow", "Upper Burnt Corral", "Mitchell Meadow", "State Lakes", "BlackCap Basin", "Charlotte Lake", "Bishop Pass")
local_stations <- data.frame(Name,ID)
local_stations$Date_Start <- paste(Sys.Date()-30)
local_stations$Date_End <- paste(Sys.Date())
local_stations$URL <- paste("https://cdec.water.ca.gov/dynamicapp/QueryDaily?s=",local_stations$ID,"&end=",local_stations$Date_End,sep = "")

mainDir <- "Y:\\Share\\Water Conditions\\Snow Analysis"
subDir <- paste(Sys.Date())

if (file.exists(subDir)){
  setwd(file.path(mainDir, subDir))
} else {
  dir.create(file.path(mainDir, subDir))
  setwd(file.path(mainDir, subDir))
  
}

subpath <- getwd()


library(RSelenium)
eCaps <- list(
  chromeOptions = 
    list(prefs = list(
      "profile.default_content_settings.popups" = 0L,
      "download.prompt_for_download" = FALSE,
      "download.default_directory" = subpath
      
    )
    )
)
rD <- rsDriver(extraCapabilities = eCaps)
remDr <- rD$client


for (i in local_stations$URL) {
  remDr$navigate(i)
  elem <- remDr$findElement(using="css selector", value=".buttons-csv span")
  elem$clickElement()
}

