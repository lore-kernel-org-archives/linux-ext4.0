From: Ted Ts'o <tytso@mit.edu>
Subject: Updated test case
Date: Sat, 21 Aug 2010 16:11:46 -0400
Message-ID: <20100821201146.GF10450@thunk.org>
References: <E1OlvNi-00063m-09@tytso-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:50114 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab0HUUL4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 21 Aug 2010 16:11:56 -0400
Content-Disposition: inline
In-Reply-To: <E1OlvNi-00063m-09@tytso-glaptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an updated of my test program, with a new option that allows
us to seek to the middle of the unitialized extent.  This allows us to
test more cases.  Suggested test cases:

./testcase
./testcase -w 8192
./testcase -s 8192 -w 8192
./testcase -s 8192
./testcase -s 409600
./testcase -d
./testcase -d -w 8192
./testcase -d -s 8192
./testcase -d -s 8192 -w 8192
./testcase -d -s 409600

What I normally do is run it something like this:

mount /scratch ; pushd /scratch; ~/testcase <opts>; popd ; umount /scratch ; debugfs /dev/sdc1 -R "stat test-file"

What to look for is whether the flags field is either 0x480000 or
0x80000.  The 0x400000 flag is the EOFBLOCKS_FL flag.  If last extent
is uninitialized, then the EOFBLOCKS_FL flag should be set.  If the
last extent does not have the "uninit" flag, then the EOFBLOCKS_FL
should be clear.

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
	off_t offset = 0;
	struct stat st;
	int flags = O_CREAT|O_TRUNC|O_RDWR;

	while ((c = getopt(argc, argv, "df:s:w:")) != EOF) {
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
		case 's':
			offset = strtol(optarg, &tmp, 0);
			if (*tmp) {
				fprintf(stderr, "Bad offset - %s\n", optarg);
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
	if (lseek(fd, offset, SEEK_SET) < 0) {
		perror("lseek");
		exit(1);
	}
	memset(buf, 255, wsize);
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
