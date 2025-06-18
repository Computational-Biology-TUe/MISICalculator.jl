# MISICalculator.jl
This is a Julia package for calculating the Muscle Insulin Sensitivity Index (MISI) from glucose and insulin data from an oral glucose tolerance test (OGTT).

> [!CAUTION]
> This package is still fully under construction and not all features are implemented yet. The API is not stable and may change drastically in the future. Please use with caution. 

## Instructions
To use the MISI calculator, you need to have Julia installed on your system. You can download Julia from [the official website](https://julialang.org/downloads/).

Once you have Julia installed, you need to install visual studio code. You can find instructions on how to do this [here](https://code.visualstudio.com/download).

Then you need the Julia extension for visual studio code. You can find instructions on how to do this [here](https://www.julia-vscode.org/docs/stable/gettingstarted/).

Finally, you can download this GitHub repository and open it in Visual Studio Code. Open the `calaculate_misi.jl` file and edit the `INPUT_FILE_NAME` and `OUTPUT_FILE_NAME` variables to match your desired files. Then, run the file by pressing `F5` or by clicking on the "Run" button in the top right corner of the editor.

Make sure your input file is an Excel file that is formatted in the same way as the example file: `sample.xlsx`.
