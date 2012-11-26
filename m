From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 50981] ext4 : DATA CORRUPTION read and write on same 4096 page
 range
Date: Mon, 26 Nov 2012 05:55:56 +0000 (UTC)
Message-ID: <20121126055556.C695911FB81@bugzilla.kernel.org>
References: <bug-50981-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58251 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab2KZF4A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 00:56:00 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 26207201BD
	for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2012 05:55:59 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 25139201B5
	for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2012 05:55:57 +0000 (UTC)
In-Reply-To: <bug-50981-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=50981





--- Comment #1 from Yongqiang Yang <xiaoqiangnk@gmail.com>  2012-11-26 05:55:56 ---
which block size does the filesystem use, 1K or 4K?

Yongqiang


On Mon, Nov 26, 2012 at 12:31 AM, <bugzilla-daemon@bugzilla.kernel.org>wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=50981
>
>            Summary: ext4 : DATA CORRUPTION read and write on same 4096
>                     page  range
>            Product: File System
>            Version: 2.5
>     Kernel Version: 2.6.32 Red Hat Enterprise Linux Workstation release
>                     6.2 (Santiago)
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: ext4
>         AssignedTo: fs_ext4@kernel-bugs.osdl.org
>         ReportedBy: meetmehiro@gmail.com
>         Regression: No
>
>
> Kernal version and Red hat
>
> 2.6.32 , Red Hat Enterprise Linux Workstation release 6.2 (Santiago)
>
>
> I have one scientific application, that is running on ext4 , after three to
> fours days, I have started to seen that data is not correct.. then i tried
> to
> find simple reproducer for the same.
>
> Pl. find the reproducer for the same with this issue is hitting easily.
>
> Logs :
>
> ./sim ext4_write
> creating the threads
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> reader thread has opened the file, fd : 4
> reader..checking data integrity
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> reader..checking data integrity
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> reader..checking data integrity
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> reader..checking data integrity
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> reader..checking data integrity
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> reader..checking data integrity
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> reader..checking data integrity
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> reader..checking data integrity
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> reader..checking data integrity
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> reader..checking data integrity
> writing B at offset 0...
> writing A at offset 0...
> reader..checking data integrity
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> reader..checking data integrity
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> reader..checking data integrity
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> reader..checking data integrity
> writing A at offset 0...
> writing B at offset 0...
> writing A at offset 0...
> writing B at offset 0...
> reader..checking data integrity
> writing A at offset 0...
> reader.. corrupted data, at offset : 511
> writing B at offset 0...
>
>
>
> C program :
> #include <stdio.h>
> #include <fcntl.h>
> #include <pthread.h>
> #include <assert.h>
> #include <errno.h>
>        #include <sys/types.h>
>        #include <sys/stat.h>
>        #include <fcntl.h>
>        #include <unistd.h>
> #include <sys/mman.h>
>
> pthread_t reader_id, writer_id;
>
> char write_buf [4096] = {0,};
> char read_buf[4096] = {0,};
>
> char  datafile[256] = {0,};
> int stop_write = 0;
>
>
>
> void * writer (void * arg)
> {
>
>         int fd = -1;
>         int count = 0;
>         /* this thread will open the file and write 4k data to it
> alternatively
>          * of a different data set to the same offset
>          */
>         /* opening the file */
>         assert((fd = open(datafile, O_CREAT|O_RDWR, 0777)) != -1);
>
>         while (1) {
>
>                 if (stop_write)
>                 {
>                         close(fd);
>                         printf("write stopped\n");
>                         return NULL;
>                 }
>                 if (count % 2 == 0)
>                         memset(write_buf, 'A', sizeof(write_buf));
>                 else
>                         memset(write_buf, 'B', sizeof(write_buf));
>
>
>                 assert(lseek(fd, 0, SEEK_SET) == 0);
>                 printf("writing %c at offset 0...\n", write_buf[0]);
>                 assert(write(fd, write_buf, 4096) == 4096);
>                 count ++;
>
>         }
>         //pthread_exit((void *)0);
>         close(fd);
>         return NULL;
> }
>
> void * reader(void * arg)
> {
>
>         int fd = -1;
>         int count = 0;
>         /* this thread will open the file and write 4k data to it
> alternatively
>          * of a different data set to the same offset
>          */
>         /* opening the file */
>         assert((fd = open(datafile, O_CREAT|O_RDWR, 0777)) != -1);
>         printf("reader thread has opened the file, fd : %d\n", fd);
>         while (1) {
>
>                 memset(read_buf, '\0', 4096);
>                 assert(lseek(fd, 0, SEEK_SET) == 0);
>                 assert(read(fd, read_buf, 4096) == 4096);
>                 count ++;
>                 printf("reader..checking data integrity\n");
>                 int i=0;
>                 for (i=0; i < 4095; i++)
>                 {
>                         int prev_char = read_buf[i];
>                         int next_char = read_buf[i+1];
>                         if (prev_char != next_char)
>                         {
>                                 printf("reader.. corrupted data, at offset
> :
> %d\n", i);
>                                 stop_write = 1;
>                                 int output_fd = open("res.txt",
> O_CREAT|O_RDWR,
> 0777);
>
>                                 assert(write(output_fd, read_buf, 4096) ==
> 4096);
>                                 close(output_fd);
>                                 close(fd);
>                                 return NULL;
>                         }
>                 }
>
>
>         }
>         //pthread_exit((void *)0);
>         close(fd);
>         return NULL;
> }
> int main (int argc, char *argv[])
> {
>         pthread_attr_t attr;
>         void * arg = NULL;
>         int *status;
>         int err = 0;
>
>         if (argc != 2) {
>                 printf("usage : ./reader_writer <file pathname>\n");
>                 exit(1);
>         }
>
>
>         memset(datafile, '\0', sizeof(datafile));
>         strcpy(datafile, argv[1]);
>
>         pthread_attr_init(&attr);
>         pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
>
>         /* create the reader and writer thread */
>         printf("creating the threads\n");
>         if ((err = pthread_create(&writer_id, &attr, writer, (void *)arg))
> !=
> 0) {
>                 printf ("pthread_create failed err no :%d\n", err);
>         }
>         if ((err = pthread_create(&reader_id, &attr, reader, (void *)arg))
> !=
> 0) {
>                 printf ("pthread_create failed err no :%d\n", err);
>         }
>         pthread_attr_destroy(&attr);
>
>         /* Wait on the other threads */
>         assert(pthread_join(writer_id, (void *)&status) == 0);
>         assert(pthread_join(reader_id, (void *)&status) == 0);
>
>         pthread_exit(NULL);
> }
>
> How to run
> gcc program.c -o ext4_program -lpthread
> ./ext4_program ext4_write
>
> --
> Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
> ------- You are receiving this mail because: -------
> You are watching the assignee of the bug.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
