From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/3] Ext3 latency improvement patches
Date: Fri, 27 Mar 2009 16:50:31 -0400
Message-ID: <1238187031.27455.212.camel@think.oraclecorp.com>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-+oZmrcHLBv9JsxpkoHLR"
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jack@suse.cz
To: "Theodore Ts'o" <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:30380 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbZC0UvG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Mar 2009 16:51:06 -0400
In-Reply-To: <1238185471-31152-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-+oZmrcHLBv9JsxpkoHLR
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2009-03-27 at 16:24 -0400, Theodore Ts'o wrote:
> The following patches have been posted as providing at least some
> partial improvement to the ext3 latency problem that has been
> discussed on the 2.6.29 mongo-LKML-thread-that-would-not-die.

Ric had asked me about a test program that would show the worst case
ext3 behavior.  So I've modified your ext3 program a little.  It now
creates a 8G file and forks off another proc to do random IO to that
file.

Then it runs one fsync every 4 seconds and times how long they take.
After the program has been running for 60 seconds, it tries to stop.

On my sata drive with barriers on, even btrfs and xfs saw some
multi-second fsyncs, but ext3 came in at 414s for a single fsync.

Warning: don't run this on a laptop drive, you'll still be waiting for
it next year.  This is probably full of little errors, I cut it together
pretty quickly.

-chris


--=-+oZmrcHLBv9JsxpkoHLR
Content-Disposition: attachment; filename="fsync-tester.c"
Content-Type: text/x-csrc; name="fsync-tester.c"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

/*
 * fsync-tester.c
 *
 * Written by Theodore Ts'o, 3/21/09.  Updated by Chris Mason to include
 * the random writer thread
 *
 * This file may be redistributed under the terms of the GNU Public
 * License, version 2.
 */
#define _FILE_OFFSET_BITS 64
#define _XOPEN_SOURCE 500
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <signal.h>
#include <time.h>
#include <fcntl.h>
#include <string.h>

#define SIZE (32768*32)
static char bigbuf[4096];

static float timeval_subtract(struct timeval *tv1, struct timeval *tv2)
{
	return ((tv1->tv_sec - tv2->tv_sec) +
		((float) (tv1->tv_usec - tv2->tv_usec)) / 1000000);
}

static void random_io(int fd, loff_t total)
{
	loff_t cur = 0;
	int ret;

	/* just some constant so our runs are always the same */
	srand(4096);
	while(1) {
		/*
		 * we want a random offset into the file,
		 * but rand only returns max in.  So we make
		 * it a random block number instead, and multiply
		 * by 4096.
		 */
		cur = rand();
		cur = (cur * 4096) % (total - 4096);

		/* align our offset  to 4k */
		cur = cur / 4096;
		cur = cur * 4096;
		ret = pwrite(fd, bigbuf, 4096, cur);
		if (ret < 4096) {
			fprintf(stderr, "short write ret %d cur %llu\n",
				ret, (unsigned long long)cur);
			exit(1);
		}
	}
}

int main(int argc, char **argv)
{
	int	fd;
	struct timeval tv, tv2, start;
	char buf[SIZE];
	pid_t pid;
	loff_t total = ((loff_t)8) * 1024 * 1024 * 1024;
	loff_t cur = 0;
	int rand_fd;
	int ret;
	int i;
	int status;
	struct stat st;

	memset(bigbuf, 0, 4096);

	rand_fd = open("fsync-tester.rnd-file", O_WRONLY|O_CREAT);
	if (rand_fd < 0) {
		perror("open");
		exit(1);
	}

	ret = fstat(rand_fd, &st);
	if (ret < 0) {
		perror("fstat");
		exit(1);
	}

	if (st.st_size < total) {
		printf("setting up random write file\n");
		while(cur < total) {
			ret = write(rand_fd, bigbuf, 4096);
			if (ret <= 0) {
				fprintf(stderr, "short write\n");
				exit(1);
			}
			cur += ret;
		}
		printf("done setting up random write file\n");
	}

	fd = open("fsync-tester.tst-file", O_WRONLY|O_CREAT);
	if (fd < 0) {
		perror("open");
		exit(1);
	}
	memset(buf, 'a', SIZE);

	pid = fork();
	if (pid == 0) {
		printf("starting random io!\n");
		random_io(rand_fd, total);
		exit(0);
	}

	close(rand_fd);

	gettimeofday(&start, NULL);
	printf("starting fsync run\n");
	for(i = 0; i < 60; i++) {
		pwrite(fd, buf, SIZE, 0);
		gettimeofday(&tv, NULL);
		fsync(fd);
		gettimeofday(&tv2, NULL);
		printf("fsync time: %5.4fs\n", timeval_subtract(&tv2, &tv));
		if (timeval_subtract(&tv2, &start) > 60)
			break;
		sleep(4);
	}
	printf("run done %d fsyncs total, killing random writer\n", i + 1);
	fflush(stdout);
	kill(pid, SIGTERM);
	wait(&status);

	return 0;
}





--=-+oZmrcHLBv9JsxpkoHLR--

