# Spatio-Temporal River Estimation using AI and Mechanistic constraints (stream)
River water quality emerges from complex, nonlinear interactions among hydrology, climate, biogeochemistry, land use, and human activities. STREAM (Spatio-Temporal River Estimation using AI and Mechanistic constraints) is a physics-informed Geospatial AI framework designed to estimate daily and monthly nitrogen (N) and phosphorus (P) concentrations across U.S. river networks by fusing heterogeneous data sources, including in situ measurements, remote sensing products, hydrological model outputs, and spatial datasets. 

Leveraging Long Short-Term Memory (LSTM) models and Graph Neural Networks (GNNs), STREAM captures spatio-temporal dependencies, long-term trends, and regime shifts along river channels while generating continuous nutrient time series. Physical knowledge such as mass balance, N/P ratios, and geomorphological characteristics—is embedded as mechanistic constraints to guide learning and improve interpretability. By enabling probabilistic forecasting and lead-time prediction before regulatory thresholds are exceeded, STREAM supports proactive river water quality assessment and early-warning decision making..

Methodology
==============
Here the transfer learning approach implemented in the study (see `Figure 1`). 

#### Figure 1 Proposed Method.
<p align="center">
  <img src="/docs/method_box.jpg" />
</p>

Results
=======
`Figure 2` shows the data to be used for GNN-LSTM model.
#### Figure 2 CONUS river data to be used in the model.
<p align="center">
  <img src="/docs/combined_plots.png" />
</p>

## Background and funding

**stream** has been developed by researchers at the **Digital futures** and Civil and Environmental Engineering Department at University of Cincinnati. 

The authors would like to thank the Department of Geography and Geographic Information Science department at the University of Cincinnati for funding this work. 

## Required Data
[1]	“Training images,” zenodo repository. https://www.worldpop.org/ (accessed October 17, 2025).