: # General utility passthrough script
: # Used to pick between Windows and Unix
:; if [ -z 0 ]; then
	@echo off
	goto :WINDOWS
fi

./pack.sh "$@"

exit

:WINDOWS

shift
pack.bat %*
