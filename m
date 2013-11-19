From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [BUG] ext2/3/4: dio reads stale data when we do some append dio
 writes
Date: Tue, 19 Nov 2013 19:51:22 +0800
Message-ID: <20131119115122.GC4782@gmail.com>
References: <20131119095302.GA4534@gmail.com>
 <20131119102235.GA5010@infradead.org>
 <20131119104508.GA4630@gmail.com>
 <20131119110147.GA3323@infradead.org>
 <20131119111947.GA4782@gmail.com>
 <20131119111826.GA20485@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:51343 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab3KSLsq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Nov 2013 06:48:46 -0500
Content-Disposition: inline
In-Reply-To: <20131119111826.GA20485@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 19, 2013 at 03:18:26AM -0800, Christoph Hellwig wrote:
> On Tue, Nov 19, 2013 at 07:19:47PM +0800, Zheng Liu wrote:
> > Yes, I know that XFS has a shared/exclusive lock.  I guess that is why
> > it can pass the test.  But another question is why xfs fails when we do
> > some append dio writes with doing buffered read.
> 
> Can you provide a test case for that issue?

Simple.  Reader just need to open this file without O_DIRECT flag.  I
paste the full code snippet below.  Please take care of this line:
	readfd = open(argv[1], /*O_DIRECT|*/O_RDONLY, S_IRWXU);

The result of this program on my own sand box looks like below:
        encounter an error: offset 0

                                                - Zheng

#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <memory.h>

#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>

#include <pthread.h>

#define BUF_ALIGN	1024

struct writer_data {
	int fd;
	size_t blksize;
	char *buf;
};

static void *writer(void *arg)
{
	struct writer_data *data = (struct writer_data *)arg;
	int ret;

	ret = write(data->fd, data->buf, data->blksize);
	if (ret < 0)
		fprintf(stderr, "write file failed: %s\n", strerror(errno));

	return NULL;
}

int main(int argc, char *argv[])
{
	pthread_t tid;
	struct writer_data wdata;
	size_t max_blocks = 10 * 1024;
	size_t blksize = 1 * 1024 * 1024;
	char *rbuf, *wbuf;
	int readfd, writefd;
	int i, j;

	if (argc < 2) {
		fprintf(stderr, "usage: %s [filename]\n", argv[0]);
		exit(1);
	}

	writefd = open(argv[1], O_CREAT|O_DIRECT|O_WRONLY|O_APPEND|O_TRUNC, S_IRWXU);
	if (writefd < 0) {
		fprintf(stderr, "failed to open wfile: %s\n", strerror(errno));
		exit(1);
	}
	readfd = open(argv[1], /*O_DIRECT|*/O_RDONLY, S_IRWXU);
	if (readfd < 0) {
		fprintf(stderr, "failed to open rfile: %s\n", strerror(errno));
		exit(1);
	}

	if (posix_memalign((void **)&wbuf, BUF_ALIGN, blksize)) {
		fprintf(stderr, "failed to alloc memory: %s\n", strerror(errno));
		exit(1);
	}

	if (posix_memalign((void **)&rbuf, 4096, blksize)) {
		fprintf(stderr, "failed to alloc memory: %s\n", strerror(errno));
		exit(1);
	}

	memset(wbuf, 'a', blksize);

	wdata.fd = writefd;
	wdata.blksize = blksize;
	wdata.buf = wbuf;

	for (i = 0; i < max_blocks; i++) {
		void *retval;
		int ret;

		ret = pthread_create(&tid, NULL, writer, &wdata);
		if (ret) {
			fprintf(stderr, "create thread failed: %s\n", strerror(errno));
			exit(1);
		}

		memset(rbuf, 'b', blksize);
		do {
			ret = pread(readfd, rbuf, blksize, i * blksize);
		} while (ret <= 0);

		if (ret < 0) {
			fprintf(stderr, "read file failed: %s\n", strerror(errno));
			exit(1);
		}

		if (pthread_join(tid, &retval)) {
			fprintf(stderr, "pthread join failed: %s\n", strerror(errno));
			exit(1);
		}

		if (ret >= 0) {
			for (j = 0; j < ret; j++) {
				if (rbuf[i] != 'a') {
					fprintf(stderr, "encounter an error: offset %ld\n",
						i);
					goto err;
				}
			}
		}
	}

err:
	free(wbuf);
	free(rbuf);

	return 0;
}
