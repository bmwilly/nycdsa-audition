.PHONY: all

DATA=../data/daily-show-guests
OUTPUT=./output

run-analysis:
	Rscript ./daily-show-analysis.R $(DATA) $(OUTPUT)
