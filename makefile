.PHONY: test docs

test:
	$(shell vessel bin)/moc -r $(shell mops sources) -wasi-system-api ./tests/*Test.mo

no-warn:
	find src -type f -name '*.mo' -print0 | xargs -0 $(shell vessel bin)/moc -r $(shell mops sources) -Werror -wasi-system-api

docs: 
	mv src/Utils tmp_utils
	$(shell vessel bin)/mo-doc
	$(shell vessel bin)/mo-doc --format plain
	mv tmp_utils src/Utils
	rm -rvf tmp_utils