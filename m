From: "Theodore Ts'o" <tytso@mit.edu>
Subject: fsync-tester.c
Date: Sat, 21 Mar 2009 23:31:20 -0400
Message-ID: <E1LlEPA-00046j-IZ@closure.thunk.org>
To: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39164 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbZCVDb0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 21 Mar 2009 23:31:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is the test program I've been using to test fsync() latency.

     	    	 	      	   - Ted

/*
 * fsync-tester.c
 *
 * Written by Theodore Ts'o, 3/21/09.
 *
 * This file may be redistributed under the terms of the GNU Public
 * License, version 2.
 */

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <time.h>
#include <fcntl.h>
#include <string.h>

#define SIZE (1024*1024)

static float timeval_subtract(struct timeval *tv1, struct timeval *tv2)
{
	return ((tv1->tv_sec - tv2->tv_sec) +
		((float) (tv1->tv_usec - tv2->tv_usec)) / 1000000);
}

int main(int argc, char **argv)
{
	int	fd;
	struct timeval tv, tv2;
	char buf[SIZE];

	fd = open("fsync-tester.tst-file", O_WRONLY|O_CREAT);
	if (fd < 0) {
		perror("open");
		exit(1);
	}
	memset(buf, 'a', SIZE);
	while (1) {
		pwrite(fd, buf, SIZE, 0);
		gettimeofday(&tv, NULL);
		fsync(fd);
		gettimeofday(&tv2, NULL);
		printf("fsync time: %5.4f\n", timeval_subtract(&tv2, &tv));
		sleep(1);
	}
}
	
