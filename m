From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [BUG] ext2/3/4: dio reads stale data when we do some append dio
 writes
Date: Tue, 19 Nov 2013 17:53:03 +0800
Message-ID: <20131119095302.GA4534@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:43528 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab3KSJuZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Nov 2013 04:50:25 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Currently we check i_size in buffered read path after we know the page
is updated.  But it could return some zero-filled pages to the userspace
when we do some append dio writes meanwhile we do some dio reads.  We
could use the following code snippet to reproduce this problem in a
ext2/3/4 filesystem.  In the mean time, I run this code snippet against
xfs and btrfs, and they can survive.  Furthermore, if we do some buffered
read, xfs also has the same problem.  So I guess that this might be a
generic problem.

code snippet:
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
  	readfd = open(argv[1], O_DIRECT|O_RDONLY, S_IRWXU);
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

build & run:
  $ gcc code.c -o code -lpthread # build
  $ ./code ${filename} # run

As we expected, we should read nothing or data with 'a'.  But now we
read data with '0'.  I take a closer look at the code and it seems that
there is a bug in vfs.  Let me describe my found here.

  reader					writer
                                                generic_file_aio_write()
                                                ->__generic_file_aio_write()
                                                  ->generic_file_direct_write()
  generic_file_aio_read()
  ->do_generic_file_read()
    [fallback to buffered read]

    ->find_get_page()
    ->page_cache_sync_readahead()
    ->find_get_page()
    [in find_page label, we couldn't find a
     page before and after calling
     page_cache_sync_readahead().  So go to
     no_cached_page label]

    ->page_cache_alloc_cold()
    ->add_to_page_cache_lru()
    [in no_cached_page label, we alloc a page
     and goto readpage label.]

    ->aops->readpage()
    [in readpage label, readpage() callback
     is called and mpage_readpage() return a
     zero-filled page (e.g. ext3/4), and go
     to page_ok label]

                                                  ->a_ops->direct_IO()
                                                  ->i_size_write()
                                                  [we enlarge the i_size]

    Here we check i_size
    [in page_ok label, we check i_size but
     it has been enlarged.  Thus, we pass
     the check and return a zero-filled page]

I attach a patch below to fix this problem in vfs.  However, to be honest, the
fix is very dirty.  But frankly I haven't had a good solution until now.  So I
send this mail to talk about this problem.  Please let me know if I miss
something.

Any comment and idea are always welcome.

Thanks,
						- Zheng

From: Zheng Liu <wenqing.lz@taobao.com>

Subject: [PATCH] vfs: check i_size at the beginning of do_generic_file_read()

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 mm/filemap.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 1e6aec4..9de2ad8 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1107,6 +1107,8 @@ static void do_generic_file_read(struct file *filp, loff_t *ppos,
 	pgoff_t index;
 	pgoff_t last_index;
 	pgoff_t prev_index;
+	pgoff_t end_index;
+	loff_t isize;
 	unsigned long offset;      /* offset into pagecache page */
 	unsigned int prev_offset;
 	int error;
@@ -1117,10 +1119,17 @@ static void do_generic_file_read(struct file *filp, loff_t *ppos,
 	last_index = (*ppos + desc->count + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
 	offset = *ppos & ~PAGE_CACHE_MASK;
 
+	/*
+	 * We must check i_size at the beginning of this function to avoid to return
+	 * zero-filled page to userspace when the application does append dio writes.
+	 */
+	isize = i_size_read(inode);
+	end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
+	if (unlikely(!isize || index > end_index))
+		goto out;
+
 	for (;;) {
 		struct page *page;
-		pgoff_t end_index;
-		loff_t isize;
 		unsigned long nr, ret;
 
 		cond_resched();
-- 
1.7.9.7

