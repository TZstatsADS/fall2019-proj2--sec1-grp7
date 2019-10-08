download.file(
  # I saved a version on my server so this script should work
  
  # even if the NYC planning department changes things around
  
  "http://www.rob-barry.com/assets/data/mapping/nypp_15b.zip",
  destfile = "nypp_15b.zip"
)
unzip(zipfile = "nypp_15b.zip")

# Now, load package to read the shapefile

library("rgdal")

# Read it into an sp object:

nypp <- readOGR("nypp_15b", "nypp")
