From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/3] 285: Test offsets over 4GB
Date: Thu, 30 May 2013 14:45:39 +0200
Message-ID: <1369917939-22660-3-git-send-email-jack@suse.cz>
References: <1369917939-22660-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab3E3Mps (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 May 2013 08:45:48 -0400
In-Reply-To: <1369917939-22660-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Test whether SEEK_HOLE and SEEK_DATA works correctly with offsets over
4GB.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 src/seek_sanity_test.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
index 7d5868b..55e7ed6 100644
--- a/src/seek_sanity_test.c
+++ b/src/seek_sanity_test.c
@@ -18,6 +18,7 @@
  */
 
 #define _XOPEN_SOURCE 500
+#define _FILE_OFFSET_BITS 64
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/vfs.h>
@@ -191,6 +192,42 @@ static int do_lseek(int testnum, int subtest, int fd, int filsz, int origin,
 	return ret;
 }
 
+/* test a huge file to check for 4G overflows */
+static int test10(int fd, int testnum)
+{
+	char *buf = NULL;
+	int bufsz = alloc_size;
+	off_t filsz = 8ULL << 30;	/* 8G */
+	off_t off = filsz - 2*bufsz;
+	int ret = -1;
+
+	buf = do_malloc(bufsz);
+	if (!buf)
+		goto out;
+	memset(buf, 'a', bufsz);
+
+	ret = do_pwrite(fd, buf, bufsz, 0);
+	if (ret)
+		goto out;
+	ret = do_pwrite(fd, buf, bufsz, off);
+	if (ret)
+		goto out;
+
+	/* offset at the beginning */
+	ret += do_lseek(testnum,  1, fd, filsz, SEEK_HOLE, 0, bufsz);
+	ret += do_lseek(testnum,  2, fd, filsz, SEEK_HOLE, 1, bufsz);
+	ret += do_lseek(testnum,  3, fd, filsz, SEEK_DATA, 0, 0);
+	ret += do_lseek(testnum,  4, fd, filsz, SEEK_DATA, 1, 1);
+
+	/* offset around eof */
+	ret += do_lseek(testnum,  5, fd, filsz, SEEK_HOLE, off, off + bufsz);
+	ret += do_lseek(testnum,  6, fd, filsz, SEEK_DATA, off, off);
+	ret += do_lseek(testnum,  7, fd, filsz, SEEK_DATA, off + 1, off + 1);
+
+out:
+	do_free(buf);
+	return ret;
+}
 /*
  * test file with unwritten extents, have both dirty and
  * writeback pages in page cache.
@@ -577,6 +614,7 @@ struct testrec seek_tests[] = {
        {  7, test07, "Test file with unwritten extents, only have dirty pages" },
        {  8, test08, "Test file with unwritten extents, only have unwritten pages" },
        {  9, test09, "Test file with unwritten extents, have both dirty && unwritten pages" },
+       { 10, test10, "Test a huge file" },
 };
 
 static int run_test(struct testrec *tr)
-- 
1.8.1.4

