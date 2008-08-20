From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 13/15][e2fsprogs] Add 64-bit getsize interface.
Date: Wed, 20 Aug 2008 12:34:07 -0500
Message-ID: <20080820173406.23412.49918.stgit@gara>
References: <20080820173210.23412.46020.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54231 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbYHTRdE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Aug 2008 13:33:04 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7KHX3xU026006
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 13:33:03 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7KHX3CN151980
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 13:33:03 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7KHX376032302
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 13:33:03 -0400
In-Reply-To: <20080820173210.23412.46020.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Add 64-bit getsize interface.

Added interface capable of opening 64-bit block device.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/ext2fs.h  |    2 ++
 lib/ext2fs/getsize.c |   38 ++++++++++++++++----------------------
 2 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 99c2c5f..8703b79 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -985,6 +985,8 @@ extern errcode_t ext2fs_set_generic_bitmap_range(ext2fs_generic_bitmap bmap,
 /* getsize.c */
 extern errcode_t ext2fs_get_device_size(const char *file, int blocksize,
 					blk_t *retblocks);
+extern errcode_t ext2fs_get_device_size2(const char *file, int blocksize,
+					blk64_t *retblocks);
 
 /* getsectsize.c */
 errcode_t ext2fs_get_device_sectsize(const char *file, int *sectsize);
diff --git a/lib/ext2fs/getsize.c b/lib/ext2fs/getsize.c
index 7f6ef71..dd460a1 100644
--- a/lib/ext2fs/getsize.c
+++ b/lib/ext2fs/getsize.c
@@ -138,8 +138,8 @@ static int valid_offset (int fd, ext2_loff_t offset)
 /*
  * Returns the number of blocks in a partition
  */
-errcode_t ext2fs_get_device_size(const char *file, int blocksize,
-				 blk_t *retblocks)
+errcode_t ext2fs_get_device_size2(const char *file, int blocksize,
+				 blk64_t *retblocks)
 {
 	int	fd, rc = 0;
 	int valid_blkgetsize64 = 1;
@@ -169,11 +169,6 @@ errcode_t ext2fs_get_device_size(const char *file, int blocksize,
 
 #ifdef DKIOCGETBLOCKCOUNT	/* For Apple Darwin */
 	if (ioctl(fd, DKIOCGETBLOCKCOUNT, &size64) >= 0) {
-		if ((sizeof(*retblocks) < sizeof(unsigned long long))
-		    && ((size64 / (blocksize / 512)) > 0xFFFFFFFF)) {
-			rc = EFBIG;
-			goto out;
-		}
 		*retblocks = size64 / (blocksize / 512);
 		goto out;
 	}
@@ -188,11 +183,6 @@ errcode_t ext2fs_get_device_size(const char *file, int blocksize,
 #endif
 	if (valid_blkgetsize64 &&
 	    ioctl(fd, BLKGETSIZE64, &size64) >= 0) {
-		if ((sizeof(*retblocks) < sizeof(unsigned long long)) &&
-		    ((size64 / blocksize) > 0xFFFFFFFF)) {
-			rc = EFBIG;
-			goto out;
-		}
 		*retblocks = size64 / blocksize;
 		goto out;
 	}
@@ -253,11 +243,6 @@ errcode_t ext2fs_get_device_size(const char *file, int blocksize,
 		if (fstat(fd, &st) == 0)
 #endif
 			if (S_ISREG(st.st_mode)) {
-				if ((sizeof(*retblocks) < sizeof(unsigned long long)) &&
-				    ((st.st_size / blocksize) > 0xFFFFFFFF)) {
-					rc = EFBIG;
-					goto out;
-				}
 				*retblocks = st.st_size / blocksize;
 				goto out;
 			}
@@ -282,17 +267,26 @@ errcode_t ext2fs_get_device_size(const char *file, int blocksize,
 	}
 	valid_offset (fd, 0);
 	size64 = low + 1;
-	if ((sizeof(*retblocks) < sizeof(unsigned long long))
-	    && ((size64 / blocksize) > 0xFFFFFFFF)) {
-		rc = EFBIG;
-		goto out;
-	}
 	*retblocks = size64 / blocksize;
 out:
 	close(fd);
 	return rc;
 }
 
+errcode_t ext2fs_get_device_size(const char *file, int blocksize,
+				 blk_t *retblocks)
+{
+	errcode_t retval;
+	blk64_t	blocks;
+	retval = ext2fs_get_device_size2(file, blocksize, &blocks);
+
+	if (!retval && blocks < (1ULL << 32)) {
+		*retblocks = (blk_t) blocks;
+		return retval;
+	}
+	return EFBIG;
+}
+
 #endif /* WIN32 */
 
 #ifdef DEBUG

