
test:
	$(shell vessel bin)/moc -r $(shell vessel sources) -wasi-system-api ./tests/*Test.mo

doc: 
	mv src/Utils tmp_utils
	$(shell vessel bin)/mo-doc
	mv tmp_utils src/Utils
	rm -rvf tmp_utils