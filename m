From: "Theodore Ts'o" <tytso@mit.edu>
Subject: buggy EOFBLOCKS_FL handling
Date: Wed, 18 Aug 2010 23:01:30 -0400
Message-ID: <E1OlvNi-00063m-09@tytso-glaptop>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34816 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab0HSDBc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Aug 2010 23:01:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


It looks like how we handle the EOFBLOCKS_FL flag is buggy.  This means
that when we fallocate a file to have 128k using the KEEP_SIZE flag, and
then write exactly 128k, the EOFBLOCKS_FL isn't getting cleared
correctly.

This is bad, because e2fsck will then complain about that inode.  If you
have a large number of inodes that are written with fallocate using
KEEP_SIZE, and then fill them up to their expected size, e2fsck will
potentially complain about a _huge_ number of inodes.

A proposed patch to fix this is forthcoming....

						- Ted

/*
 * Testcase for Google Bug 2928259
 *
 * Run this program while the current directory is in an ext4 filesystem,
 * then umount the file system and do a forced fsck (i.e., fsck -f /dev/XXX).
 *
 * If you get a e2fsck reported corruption, then the kernel is buggy:
 *
 * Inode 12 should not have EOFBLOCKS_FL set (size 40960, lblk 9)
 * Clear<y>? yes
 */

#define _GNU_SOURCE

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/syscall.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <getopt.h>
#include <errno.h>

#define FALLOC_FL_KEEP_SIZE     0x01

#ifndef SYS_fallocate
#ifdef __i386__
/* 32-bits */
#define SYS_fallocate 324
#elif __amd64__
/* 64-bits */
#define SYS_fallocate 285
#endif
#endif

int main(int argc, char **argv)
{
	int fd, ret, c;
	char *buf, *tmp;
	unsigned long fsize = 40960;
	unsigned long wsize = 40960;
	struct stat st;
	int flags = O_CREAT|O_TRUNC|O_RDWR;

	while ((c = getopt(argc, argv, "df:w:")) != EOF) {
		switch (c) {
		case 'd':
			flags |= O_DIRECT;
			break;
		case 'f':
			fsize = strtoul(optarg, &tmp, 0);
			if (*tmp) {
				fprintf(stderr, "Bad fsize - %s\n", optarg);
				exit(1);
			}
			break;
		case 'w':
			wsize = strtoul(optarg, &tmp, 0);
			if (*tmp) {
				fprintf(stderr, "Bad wsize - %s\n", optarg);
				exit(1);
			}
			break;
		default:
			fprintf(stderr, "Usage: testcase [-d] "
				"-f fallocate_size -w write_size\n");
		}
	}

	fd = open("test-file", flags, 0644);
	if (fd < 0) {
		perror("open");
		exit(1);
	}
	ret = syscall(SYS_fallocate, fd, FALLOC_FL_KEEP_SIZE, 0ULL,
		      (unsigned long long) fsize);
	if (ret) {
		perror("fallocate");
		exit(1);
	}
	if ((ret = posix_memalign((void **) &buf, 4096, wsize)) != 0) {
		errno = ret;
		perror("posix_memalign");
	}
	memset(buf, 0, wsize);
	ret = write(fd, buf, wsize);
	if (ret < 0) {
		perror("write");
		exit(1);
	} else if (ret != wsize) {
		fprintf(stderr, "Short write: actual %d, expected %lu\n",
			ret, wsize);
		exit(1);
	}
	if (fstat(fd, &st) < 0) {
		perror("fstat");
		exit(1);
	}
	printf("test-file has inode number %lu\n", (unsigned long) st.st_ino);
	printf("size is %lu, blocks*512 is %lu\n", (unsigned long) st.st_size,
	       (unsigned long) st.st_blocks*512);
	close(fd);
	exit(0);
}
