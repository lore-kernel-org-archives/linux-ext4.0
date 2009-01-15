From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [RESEND] [PATCH] lseek: change i_mutex usage.
Date: Thu, 15 Jan 2009 16:42:19 +0900
Message-ID: <6.0.0.20.2.20090115163853.07056ed0@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I changed i_mutex usage on generic_file_llseek.
This function is inside i_mutex, but I think there is room for optimization in some cases.
When SEEK_END is specified from caller, in this case we should handle
inode->i_size so i_mutex is needed. But in other cases such as SEEK_CUR or
SEEK_SET, i_mutex is not needed because just changing file->f_pos value without
touching i_size.

I did some test to measure i_mutex contention.
This test do:
	1. make an 128MB file.
	2. fork 100 processes. repeat 10000000 times lseeking randomly on each process to this file.
	3, gauge seconds between start and end of this test.

The result was:

	-2.6.29-rc1
	# time ./lseek_test
	315 sec

	real    5m15.407s
	user    1m19.128s
	sys     5m38.884s

	-2.6.29-rc1-patched
	# time ./lseek_test
	13 sec

	real    0m13.039s
	user    1m14.730s
	sys     2m9.633s 

Hardware environment:
CPU　2.4GHz(Quad Core) *4
Memory 64GB

This improvement is derived from just removal of lseek's i_mutex contention.
There is i_mutex contention not only around lseek, but also fsync or write.
So,  I think we also can mitigate i_mutex contention between fsync and lseek.

Thanks.

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.29-rc1.org/fs/read_write.c linux-2.6.29-rc1.lseek/fs/read_write.c
--- linux-2.6.29-rc1.org/fs/read_write.c	2009-01-15 15:37:35.000000000 +0900
+++ linux-2.6.29-rc1.lseek/fs/read_write.c	2009-01-15 16:12:17.000000000 +0900
@@ -89,9 +89,12 @@ loff_t generic_file_llseek(struct file *
 {
 	loff_t rval;
 
-	mutex_lock(&file->f_dentry->d_inode->i_mutex);
-	rval = generic_file_llseek_unlocked(file, offset, origin);
-	mutex_unlock(&file->f_dentry->d_inode->i_mutex);
+	if (origin == SEEK_END) {
+		mutex_lock(&file->f_dentry->d_inode->i_mutex);
+		rval = generic_file_llseek_unlocked(file, offset, origin);
+		mutex_unlock(&file->f_dentry->d_inode->i_mutex);
+	} else
+		rval = generic_file_llseek_unlocked(file, offset, origin);
 
 	return rval;
 }




Following is the test program "lseek_test.c".

#include <stdio.h>
#include <sched.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <signal.h>
#define NUM 100
#define LEN 4096
#define LOOP 32*1024

int num;

void catch_SIGCHLD(int signo)
{
	pid_t child_pid = 0;
	do {
		int child_ret;
		child_pid = waitpid(-1, &child_ret, WNOHANG);
		if (child_pid > 0)
			num++;
	} while (child_pid > 0);
}
main()
{
        int  i, pid;
	char buf[LEN];
	unsigned long offset, filesize;
	time_t t1, t2;
	struct sigaction act;
	memset(buf, 0, LEN);
	memset(&act, 0, sizeof(act));
	act.sa_handler = catch_SIGCHLD;
	act.sa_flags = SA_NOCLDSTOP|SA_RESTART;
	sigemptyset(&act.sa_mask);
	sigaction(SIGCHLD, &act, NULL);	

	filesize = LEN * LOOP;
	int fd = open("targetfile1",O_RDWR|O_CREAT);	

	/* create a 128MB file */
	for(i = 0; i < LOOP; i++)
		write(fd, buf, LEN);
	fsync(fd);
	close(fd);
	
	time(&t1);	
	for (i = 0; i < NUM; i++) {	
		pid = fork();
		if(pid == 0){
		/* child */
			int fd = open("targetfile1", O_RDWR);	
			int j;
			for (j = 0; j < 10000000; j++) {
				offset = (random() % filesize);
				lseek(fd, offset, SEEK_SET);
			}
			close(fd);
			exit(0);
		}
	}
	while(num < NUM)
		sleep(1);
	time(&t2);	
	printf("%d sec\n",t2-t1);
}


