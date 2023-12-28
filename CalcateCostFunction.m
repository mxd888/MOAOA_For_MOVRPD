function Y = CalcateCostFunction(data,VehiclePath,DronePath)

Y(1) = CalcateCostF1(data,VehiclePath,DronePath);

Y(2) = CalcateCostF2(data,VehiclePath,DronePath);

Y(3) = CalcateCostF3(data,VehiclePath,DronePath);

Y = Y';
end