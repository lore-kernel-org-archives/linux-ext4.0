From: Giel de Nijs <giel@vectorwise.com>
Subject: Possible ext4 data corruption with large files and async I/O
Date: Fri, 29 Jan 2010 15:54:00 +0100
Message-ID: <4B62F688.70404@vectorwise.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------030205030403080303000604"
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exhub017-4.exch017.msoutlookonline.net ([64.78.22.19]:33751
	"EHLO EXHUB017-4.exch017.msoutlookonline.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755814Ab0A2PDs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Jan 2010 10:03:48 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--------------030205030403080303000604
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

Dear ext4 devs,

Today I hit a situation where seemingly blocks did not get written to 
disk. I've narrowed it down to the following test case.

Running Fedora Core 12 with kernel 2.6.31.9-174.fc12.x86_64, both on an 
i7 920 and a Core2 Q6600, I executed the following steps:

- create a file
- with kernel async i/o, write a 512kb (haven't tried other sizes) block 
to an offset >4GB, effectively creating a large sparse file
- again with async i/o, write a 512kb block to an offset smaller than 
the previous write, but >4GB
- wait for the kernel async i/o to tell you the writes have succeeded

Now, looking at the file, the second write never seems to have happened. 
When doing this on the same machines on ext3, the behavior is as expected.

As far as I can tell (from the bigger program that triggered this), all 
writes >4GB but < EOF to a sparse file with async i/o aren't executed. 
When creating a large file first (i.e., with dd), everything does work 
as expected.

Attached is some C code that triggers this bug for me.

If you need more information or want me to test some more things, please 
do ask.

Thanks,
Giel de Nijs
VectorWise

--------------030205030403080303000604
Content-Type: text/x-csrc; name="ext4_bug_2.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="ext4_bug_2.c"


/*
 Author: Giel de Nijs, VectorWise B.V. <giel@vectorwise.com>

 Running Fedora Core 12 kernel
 2.6.31.9-174.fc12.x86_64 #1 SMP Mon Dec 21 05:33:33 UTC 2009 x86_64 x86_64 x86_64 GNU/Linux

 When writing with kernel asynchronous I/O to an ext4 partition, to a sparse
 file at offsets >4GB which is not the end of the file, writes don't happen.

 Compile with -laio

 run ext4_bug_2 on a filesystem with >6GB free space
 it writes a 512KB block at 6GB, then one at 5GB

 dd if=ext4_bug.testfile bs=512k count=1 skip=12K|hexdump
 dd if=ext4_bug.testfile bs=512k count=1 skip=10K|hexdump

 should both give:
 0000000 ffff ffff ffff ffff ffff ffff ffff ffff
 *
 0080000

 on ext4, second one gives:
 0000000 0000 0000 0000 0000 0000 0000 0000 0000
 *
 0080000

 i.e.,: no data written
*/

#define _GNU_SOURCE
#define _LARGEFILE64_SOURCE
#define _FILE_OFFSET_BITS 64
#include <features.h>
#include <libaio.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <error.h>
#include <errno.h>
#include <unistd.h>
#include <stdlib.h>
#include <ctype.h>

int main(void)
{
	char *filename = "ext4_bug.testfile";

	size_t blocksize = (size_t)512 * 1024;
	off_t offset1 = (off_t)6 * 1024 * 1024 * 1024;
	off_t offset2 = (off_t)5 * 1024 * 1024 * 1024;

	int queue_depth = 8;

	int err;
	char *buf;
	io_context_t io_ctx;
	struct iocb iocb;
	struct iocb *iocblist[1];
	struct io_event events[1];
	int fd;

	/* allocate aligned memory (for direct i/o) */
	err = posix_memalign((void **)&buf, getpagesize(), blocksize);
	if (err) {
		printf("error allocating memory: %s\n", strerror(err));
		return(err);
	}
	memset(buf, 255, blocksize);


	/* initialize async i/o */
	err = io_queue_init(queue_depth, &io_ctx);
	if (err < 0) {
		printf("error initializing I/O queue: %s\n", strerror(-err));
		return(-err);
	}

	/* create file */
	printf("opening file %s\n", filename);
	fd = open(filename, O_DIRECT|O_RDWR|O_EXCL|O_LARGEFILE|O_CREAT, 0666);
	if (fd < 0) {
		perror("error opening file");
		return(errno);
	}

	/* write at offset 6GB, i.e., create a sparse file >4GB */
	io_prep_pwrite(&iocb, fd, buf, blocksize, offset1);
	iocblist[0] = &iocb;
	printf("submitting write of %zd bytes at offset %zd\n", blocksize, offset1);
	err = io_submit(io_ctx, 1, iocblist);
	if (err < 0) {
		printf("error submitting I/O requests: %s\n", strerror(-err));
		return(-err);
	}

	printf("waiting for write to be finished\n");
	err = io_getevents(io_ctx, 1, 1, events, NULL);
	if (err < 0) {
		printf("error getting I/O events: %s\n", strerror(-err));
		return(-err);
	}
	printf("got %d events\n", err);
	err = events[0].res;
	if (err < 0) {
		printf("error writing buffer: %s\n", strerror(-err));
		return(-err);
	}
	printf("written %ld bytes\n", events[0].res);

	/* write at offset 5GB, i.e., in sparse file >4GB but not at EOF */
	io_prep_pwrite(&iocb, fd, buf, blocksize, offset2);
	iocblist[0] = &iocb;
	printf("submitting write of %zd bytes at offset %zd\n", blocksize, offset2);
	err = io_submit(io_ctx, 1, iocblist);
	if (err < 0) {
		printf("error submitting I/O requests: %s\n", strerror(-err));
		return(-err);
	}

	printf("waiting for write to be finished\n");
	err = io_getevents(io_ctx, 1, 1, events, NULL);
	if (err < 0) {
		printf("error getting I/O events: %s\n", strerror(-err));
		return(-err);
	}
	printf("got %d events\n", err);
	err = events[0].res;
	if (err < 0) {
		printf("error writing buffer: %s\n", strerror(-err));
		return(-err);
	}
	printf("written %ld bytes\n", events[0].res);

	close(fd);
	io_destroy(io_ctx);

	/* You _should_ have a 6GB sparse file now with two 512KB blocks of 0xFF
	 * at 5GB and at 6GB.
	 */
	free(buf);
	return 0;
}

--------------030205030403080303000604--
