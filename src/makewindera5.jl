export makewindera5, makemonthlywindera5

# Can optionally zero cells that are zero in the Global Wind Atlas to save a lot of disk space.
function makewindera5(; year=2018, windatlas_only=true)
    hours = 24*Dates.daysinyear(year)
    gridsize = (1280,640)

    datafolder = getconfig("datafolder")
    downloadsfolder = joinpath(datafolder, "downloads")
    
    filename = joinpath(datafolder, "era5wind$year.h5")
    isfile(filename) && error("File $filename exists in $datafolder, please delete or rename manually.")

    windatlas = reshape(imresize(getwindatlas(), gridsize), (1,gridsize...))

    println("Creating HDF5 file:  $filename")
    h5open(filename, "w") do file 
        group = file["/"]
        dataset_wind = d_create(group, "wind", datatype(Float32), dataspace(hours,gridsize...), "chunk", (hours,16,16), "blosc", 3)
        dataset_meanwind = d_create(group, "meanwind", datatype(Float32), dataspace(gridsize...), "chunk", gridsize, "blosc", 3)

        totalwind = zeros(gridsize)
        hour = 1

        count = 0
        for month = 1:12, monthhalf = 1:2
            if monthhalf == 1
                firstday, lastday = "01", "15"
            else
                firstday = "16"
                lastday = Dates.daysinmonth(Date("$year-$month"))
            end
            monthstr = lpad(month,2,'0')
            date = "$year-$monthstr-$firstday/$year-$monthstr-$lastday"
            erafile = joinpath(downloadsfolder, "wind$year-$monthstr$firstday-$monthstr$lastday.nc")

            count += 1
            println("\nFile $count of 24:")
            println("Reading wind components from $erafile...")
            # Permute dimensions to get hours as dimension 1 (for efficient iteration in GISwind())
            ncdataset = Dataset(erafile)
            u100 = permutedims(ncdataset["u100"][:,:,:], [3,1,2])
            v100 = permutedims(ncdataset["v100"][:,:,:], [3,1,2])

            println("Calculating absolute speed...")
            wind = replace(sqrt.(u100.^2 + v100.^2), missing => 0.0) .* (windatlas .> 0)

            totalwind = totalwind + sumdrop(wind, dims=1)
            len = size(wind,1)
            println("Writing to $filename...")
            dataset_wind[hour:hour+len-1,:,:] = wind
            hour += len
        end
        println("\nWriting meanwind to $filename...")
        dataset_meanwind[:,:] = totalwind/hours
    end
    nothing
end

function makemonthlywindera5(; windatlas_only=true)
    years = 1979:2019
    nyears = length(years)
    nmonths = nyears*12
    gridsize = (1280,640)

    datafolder = getconfig("datafolder")
    downloadsfolder = joinpath(datafolder, "downloads")
    
    filename = joinpath(datafolder, "era5monthlywind.h5")
    isfile(filename) && error("File $filename exists in $datafolder, please delete or rename manually.")

    windatlas = reshape(imresize(getwindatlas(), gridsize), (1,gridsize...))

    println("Creating HDF5 file:  $filename")
    h5open(filename, "w") do file 
        group = file["/"]
        monthlywind = d_create(group, "monthlywind", datatype(Float32), dataspace(nmonths,gridsize...), "chunk", (nmonths,16,16), "blosc", 3)
        annualwind = d_create(group, "annualwind", datatype(Float32), dataspace(nyears,gridsize...), "chunk", (nyears,16,16), "blosc", 3)
        erafile = in_datafolder("downloads", "monthlywind_$(years[1])-$(years[end]).nc")

        println("Reading wind components from $erafile...")
        # Permute dimensions to get hours as dimension 1 (for efficient iteration in GISwind())
        ncdataset = Dataset(erafile)
        u100 = permutedims(ncdataset["u100"][:,:,:], [3,1,2])
        v100 = permutedims(ncdataset["v100"][:,:,:], [3,1,2])

        println("Calculating absolute speed...")
        wind = replace(sqrt.(u100.^2 + v100.^2), missing => 0.0) .* (windatlas .> 0)

        println("Writing to $filename...")
        monthlywind[:,:,:] = wind
        for y = 1:nyears
            annualwind[y,:,:] = sum(wind[12*(y-1) .+ (1:12),:,:], dims=1) ./ 12
        end
    end
    nothing
end
