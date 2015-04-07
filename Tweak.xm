#include <unistd.h>
#include <spawn.h>
static const char *path = "/Library/PreferenceBundles/YourBundle.bundle/heart.png";
%ctor {
    //if the file exists
	if (access( path, F_OK ) != -1) {
        //posix spawn stuff to launch the checker executable
		pid_t pid;
    	int status;
    	const char* args[] = { "heart.png", NULL };
    	posix_spawn(&pid, path, NULL, NULL, (char* const*)args, NULL);
        //when it's done, remove the executable
    	waitpid(pid, &status, WEXITED);
    	if (status == 0) {
    		unlink(path);
    	}
	}
}