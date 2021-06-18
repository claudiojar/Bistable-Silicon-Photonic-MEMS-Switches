# Bistable-Silicon-Photonic-MEMS-Switches

*A certain amount of material such as design files, simulation files and results, files developed by other contributors, etc. were left out of this repository for copyright reasons.*

## Abstract and scope of the project
Photonics, and photonic integrated systems are devices that use electromagnetic waves (light) as a communication medium. Photonic integrated circuits provide functions such as amplification, routing, modulation, for signals carrying information, and typically operate at optical wavelengths in the near visible spectrum or near infrared : 850 nm - 1650 nm.

To that extent, optical switches are a crucial element of an optical system. An optical switch is a device that enables switching a given signal between different channels. These switches are usually characterized by the input/output port count, and were often fabricated using mirrors, or reflective coatings. 

However, it is becoming increasingly feasible to use micro-electromechanical systems (MEMS) as optical switches, to be able to benefit from their high integration capabilities, reliability, robustness, and low power consumption. To ensure that these new technologies are viable economically and fabrication-wise, photonic MEMS-based circuits are built based on the well known and understood silicon fabrication methods used in the electronics industry for the past decades. 

By exploiting the mechanical properties of MEMS, we can create a system that exhibits buckling under compressive stress, and therefore creates 2 buckled stable states : we have created a non-volatile latching switch that requires power only to switch from ON to OFF (or vice-versa).

The scope of the project is therefore to investigate different designs for optical MEMS switches, operating in the [1460, 1580] nm range, and to draft the corresponding photonic chip layouts in an actual microfabrication design framework. We will attempt to optimize these MEMS switches' design based on certain optimization criteria that will be further explained later in this paper, and we will simulate the switches using finite element modeling techniques (FEM) to explore their buckling mode shapes. 

In this project we present 3 optimized optical MEMS switch architectures, their design philosophies and decisions, as well as their possible implementations in switch array grids for applications in data centers, telecommunication infrastructure or aerospace telecommunications.

## Getting Started
This project repo contains the design files in GDSII format of the final version of all 3 designs developed, deliverable files such as a technical report, as well as the MATLAB files that were used to create certain GDSII geometries.

### Dependencies

* **KLayout**: KLayout is the recommended software to open GDSII files. It is open-source and well maintained. Can be downloaded by clicking [here.](https://www.klayout.de/build.html) 
* **MATLAB** : MATLAB or Octave are required to open and execute the scripts developed. Octave can work but has not been tested with other dependencies.
  * **Raith GDSII MATLAB Toolbox** : the Raith GDSII MATLAB Toolbox is required to create ceratin structuresthat are built using MATLAB. This toolbox is included in this repository. 

### Installing

* It is recommended to add the folder : ```...\Bistable-Silicon-Photonic-MEMS-Switches\Reference Material``` to the MATLAB Path. It contains the Raith GDSII MATLAB Toolbox, as well as the developped path creation routines.

### Executing program

To run the path creation routines, make sure that the installation requirements are met. 
* ```...\Bistable-Silicon-Photonic-MEMS-Switches\Matlab Files\Source files\20_Component Libraries``` contains all the MATLAB files used to generate paths. 
* ```...\Bistable-Silicon-Photonic-MEMS-Switches\Matlab Files\Source files\MLX Files``` contains certain MLX files that contain additional documentation on the project. 
* ```...\Bistable-Silicon-Photonic-MEMS-Switches\Matlab Files\Source files\Other files``` contains file sused for computing certain characterisation aspects of the design, such as optical losses. 

## Help
Please refer to the technical report in ```...\Bistable-Silicon-Photonic-MEMS-Switches\Deliverables\Report``` for more information and technical data on these designs.

For any problem, issue or comment please email me at : 
<claudio.jaramilloconcha@epfl.ch>


## Authors
* Author : Claudio Jaramillo, BSc. Microengineering, EPFL 
  * email : <claudio.jaramilloconcha@epfl.ch>
  * LinkedIn : <https://www.linkedin.com/in/claudio-jaramillo>

## Version History

* 1.0
    * Clean up for public release
* 0.1
    * Initial Release

## License

This project is licensed under the GNU AFFERO GENERAL PUBLIC LICENSE License - see the LICENSE.md file for details.

## Acknowledgments
* Dr. Hernán Furci, EPFL
* Prof. Dr Niels Quack, EPFL
