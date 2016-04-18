inteRsense
============
This R package was developed during my Bachelor's Thesis "Geostatistical Methods for the OpenSenseMap-Platform" in 2016. It was developed to give the [openSenseMap](http://opensensemap.org/#/) platform interpolation functionalities with the inverse-distance-weighted (IDW) and nearest-neighbour (NN) methods.
It was designed to be used with an [OpenCPU](https://www.opencpu.org/) cloud Server and consists of three functions, *imageBounds*, *inteRidwIdp* and *inteRtp*.

## Input

All functions expect an unnested JSON as input

```
{
        "value": "12",
        "latitude": 51.95663051646247,
        "longitude": 7.638084768987028
    }, {
        "value": "24",
        "latitude": 47.98904565179757,
        "longitude": 7.82081812614706
    }, <abbreviated>
```
Where value is the variable to be interpolated.

## Integration into openSenseMap
How *inteRsense* is integrated into openSenseMap can be found [here](https://github.com/sensebox/OpenSenseMap/blob/ui-router/app/scripts/controllers/sidebar.interpolation.js).

Code license: MIT License
