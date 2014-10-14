From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: BLKZEROOUT + pread should return zeroes, right?
Date: Mon, 13 Oct 2014 20:01:32 -0700
Message-ID: <20141014030132.GA12013@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46417 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbaJNDBj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Oct 2014 23:01:39 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi everyone,

What's the intended behavior if I issue BLKZEROOUT against a range of disk
sectors and immediately re-read the sectors into a buffer?

I've been trying to modify e2fsprogs to use BLKZEROOUT, and I noticed today
that if I run mke2fs and e2fsck -fn enough times in a tight loop, that
eventually e2fsck complains about corruption in blocks that ought to contain
zeroes.  If I dd the block in question after the failure, I get zeroes as I'd
expect.

This feels incorrect -- if I pwrite a block, then blkzeroout the block, then
re-read it, I ought to see zeroes, right?  Or is BLKZEROOUT some sort of
hint that isn't perfectly reliable, a la BLKDISCARD?  Or maybe I'm just doing
it incorrectly?  I looked at block/blk-num.c, this seems like it ought to be
ok.

I boiled the whole thing down into the attached test program, which can
reproduce the symptoms in a few loop iterations.  If I insert "sleep(1);"
before the pread64, I pread zeroes every time; otherwise, I only pread zeroes
part of the time.  If I call "ioctl(fd, BLKFLSBUF);" before the BLKZEROOUT, the
chances of preading zeroes increases dramatically, but is still not 100%.

So, uh, is this a bug?  Or is that just how BLKZEROOUT works?  Or did I fubar
the ioctl call?

$ gcc -Wall -g -o test test.c
$ sudo ./test /dev/sda
6: ERR 0 (0xffffffff)

--D

/* silly test program */
#define _XOPEN_SOURCE 600
#define _DARWIN_C_SOURCE
#define _FILE_OFFSET_BITS 64
#define _LARGEFILE_SOURCE
#define _LARGEFILE64_SOURCE
#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif

#include <sys/types.h>
#include <string.h>
#include <sys/ioctl.h>
#include <stdio.h>
#include <stdint.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <linux/fs.h>
#include <unistd.h>
#include <assert.h>

#define BUFSZ 4096

static int run(int iteration, const char *fname)
{
	char buf[BUFSZ];
	ssize_t sz;
	uint64_t range[2];
	int fd, ret, i;

	printf("%d\r", iteration);
	fflush(stdout);

	fd = open(fname, O_RDWR);
	if (fd < 0)
		return 1;

	memset(buf, 0xFF, BUFSZ);

	sz = pwrite64(fd, buf, BUFSZ, 0);
	if (sz != BUFSZ)
		return 2;

	range[0] = 0;
	range[1] = 4096;
	ret = ioctl(fd, BLKZEROOUT, range);
	if (ret)
		return 5;

	sz = pread64(fd, buf, BUFSZ, 0);
	if (sz != BUFSZ)
		return 7;

	for (i = 0; i < BUFSZ; i++) {
		if (buf[i]) {
			printf("%d: ERR %d (0x%x)\n", iteration, i, buf[i]);
			return 8;
		}
	}

	close(fd);
	return 0;
}

int main(int argc, char *argv[])
{
	int iter = 0;
	int ret;

	if (argc != 2) {
		printf("Usage: %s blkdev\n", argv[0]);
		return 0;
	}

	do {
		ret = run(iter++, argv[1]);
	} while (!ret);

	return ret;
}

