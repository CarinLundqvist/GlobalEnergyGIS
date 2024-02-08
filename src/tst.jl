include("GlobalEnergyGIS.jl")
import .GlobalEnergyGIS

GlobalEnergyGIS.GISwind(gisregion="Sweden",savetodisk=false)

#lonrange = [1 2 3 4]
#latrange = [18000]
#res = 0.01                                          # resolution of auxiliary datasets like GlobalWindAtlas
#lons = (-180+res/2:res:180-res/2)[lonrange]         # longitude values (pixel center)
#lats = (90-res/2:-res:-90+res/2)[latrange]          # latitude values (pixel center)
#rastercellarea(lat, res) = cosd(lat) * (2*6371*π/(360/res))^2
#cellarea=rastercellarea.(lats,res)
#println("\nlatrange: ",latrange," lats: ",lats," area: ",cellarea)

#include("tst.jl")