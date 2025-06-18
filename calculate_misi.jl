using Pkg
Pkg.activate(".")
Pkg.instantiate()

INPUT_FILE_NAME = "sample.xlsx"
OUTPUT_FILE_NAME = "misi_results.xlsx"

include("src/misi.jl")
misi(INPUT_FILE_NAME, OUTPUT_FILE_NAME)
