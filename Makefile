.PHONY: all

DATA=./data
OUTPUT=./output

run-analysis:
	Rscript ./daily-show-analysis.R $(DATA) $(OUTPUT)
