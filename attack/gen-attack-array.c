// src: https://github.com/skywardpixel/trusting-trust-hack/blob/main/code/step3/generate-attack-array.c
#include <stdio.h>

int main(void) {
	printf("static char compile_attack[] = {\n");
	int c;
	while ((c = fgetc(stdin)) != EOF) {
		printf("\t%d,\n", c);
	}
	printf("\t0\n};\n\n");
	return 0;
}
