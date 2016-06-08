FINEGRAINED_SUPPORTED=yes
NAMEEXTRA=

run_bench() {
	PARALLELDD_WRITEFILES_COMMAND=
	if [ "$PARALLELDD_WRITEFILES" = "yes" ]; then
		PARALLELDD_WRITEFILES_COMMAND=--write-files
	fi

	PARALLELDD_SPLITINPUT_COMMAND=
	if [ "$PARALLELDD_SPLITINPUT" = "yes" ]; then
		PARALLELDD_SPLITINPUT_COMMAND=--split-input
	fi

	$SHELLPACK_INCLUDE/shellpack-bench-paralleldd $PARALLELDD_WRITEFILES_COMMAND $PARALLELDD_SPLITINPUT_COMMAND \
		--sourcesize  $PARALLELDD_SOURCESIZE	\
		--min-threads $PARALLELDD_MIN_THREADS	\
		--max-threads $PARALLELDD_MAX_THREADS	\
		--iterations  $PARALLELDD_ITERATIONS
	return $?
}