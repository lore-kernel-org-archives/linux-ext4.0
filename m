From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] mke2fs: Inform user about ongoing discard
Date: Wed, 15 Sep 2010 16:32:28 +0200
Message-ID: <1284561148-22242-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, sandeen@redhat.com, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab0IOOce (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Sep 2010 10:32:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since there are some slow SSD's out there and big thinly provisioned
storages on which it takes quite long to issue discard through whole
device, it would be nice to provide user the information about what is
going on and how long it will take (approximately).

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 misc/mke2fs.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index add7c0c..4062507 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1901,6 +1901,55 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 #define BLKDISCARD	_IO(0x12,119)
 #endif
 
+/* On how big chunk of disk do we test discard (in percentage) */
+#define DISCARD_TEST_RANGE_PERC		1
+#define DISCARD_TEST_RANGE(x, y)	\
+	((((x) / 100) *			\
+	DISCARD_TEST_RANGE_PERC +	\
+	(y)-1 / (y)) * (y))
+#define DISCARD_TEST_COUNT		5
+
+static int check_discard_support(int fd, int blocksize, __u64 blocks,
+				 double *time)
+{
+	int ret = 0, i;
+	double tmp_time = 0;
+	__uint64_t range[2];
+	struct timeval tv_start, tv_stop;
+
+	range[0] = 0;
+	range[1] = DISCARD_TEST_RANGE(blocks, blocksize);
+
+	for (i = 0; i < DISCARD_TEST_COUNT; i++) {
+
+		if (gettimeofday(&tv_start, (struct timezone *) NULL) == -1)
+			perror("gettimeofday");
+
+		ret = ioctl(fd, BLKDISCARD, &range);
+		if (ret)
+			return ret;
+
+		if (gettimeofday(&tv_stop, (struct timezone *) NULL) == -1) {
+			perror("gettimeofday");
+			return ret;
+		}
+
+		if (0 == i)
+			printf(_("Discarding all blocks on device "));
+
+		/* time diff */
+		tmp_time += ((double) tv_stop.tv_sec +
+			(((double) tv_stop.tv_usec) * 0.000001)) -
+			((double) tv_start.tv_sec +
+			(((double) tv_start.tv_usec) * 0.000001));
+	}
+
+	*time = (tmp_time / DISCARD_TEST_COUNT) *
+		(100 / DISCARD_TEST_RANGE_PERC);
+
+	return ret;
+}
+
 static void mke2fs_discard_blocks(ext2_filsys fs)
 {
 	int fd;
@@ -1908,6 +1957,7 @@ static void mke2fs_discard_blocks(ext2_filsys fs)
 	int blocksize;
 	__u64 blocks;
 	__uint64_t range[2];
+	double time = 0;
 
 	blocks = ext2fs_blocks_count(fs->super);
 	blocksize = EXT2_BLOCK_SIZE(fs->super);
@@ -1921,6 +1971,11 @@ static void mke2fs_discard_blocks(ext2_filsys fs)
 	 * optmization for SSDs or sparse storage.
 	 */
 	if (fd > 0) {
+		ret = check_discard_support(fd, blocksize, blocks, &time);
+		if (ret)
+			return;
+		printf(_("(Estimated time: %.2lfs).\n"), time);
+
 		ret = ioctl(fd, BLKDISCARD, &range);
 		if (verbose) {
 			printf(_("Calling BLKDISCARD from %llu to %llu "),
-- 
1.7.2.2

