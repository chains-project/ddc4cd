static const char target[]               = "x86_64-unknown-linux-gnu";
static const char *const startfiles[]    = {"-l", ":crt1.o", "-l", ":crti.o", "-l", ":crtbegin.o"};
static const char *const endfiles[]      = {"-l", "c", "-l", ":crtend.o", "-l", ":crtn.o"};
static const char *const preprocesscmd[] = {
	"cpp",

	/* clear preprocessor GNU C version */
	"-U", "__GNUC__",
	"-U", "__GNUC_MINOR__",

	/* we don't yet support these optional features */
	"-D", "__STDC_NO_ATOMICS__",
	"-D", "__STDC_NO_COMPLEX__",
	"-U", "__SIZEOF_INT128__",

	/* we don't generate position-independent code */
	"-U", "__PIC__",

	/* ignore extension markers */
	"-D", "__extension__=",
};
static const char *const codegencmd[]    = {"qbe"};
static const char *const assemblecmd[]   = {"as"};
static const char *const linkcmd[]       = {"ld", "-L", "/usr/lib/gcc/x86_64-linux-gnu/11", "--dynamic-linker", "/lib64/ld-linux-x86-64.so.2"};
