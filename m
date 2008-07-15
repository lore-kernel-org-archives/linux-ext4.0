From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 13/15][e2fsprogs] Add 64-bit getsize interface.
Date: Tue, 15 Jul 2008 11:51:18 -0500
Message-ID: <20080715165118.28567.87417.stgit@ichigo>
References: <20080715164332.28567.27913.stgit@ichigo>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Jose R. Santos" <jrs@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60531 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754930AbYGOQvU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jul 2008 12:51:20 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6FGpJq2031528
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 12:51:19 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6FGpJk6196734
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 12:51:19 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6FGpJnp001390
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 12:51:19 -0400
In-Reply-To: <20080715164332.28567.27913.stgit@ichigo>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Add 64-bit getsize interface.

Added interface capable of opening 64-bit block device.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/ext2fs.h  |    2 ++
 lib/ext2fs/getsize.c |   15 +++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 3bc866e..6881c8a 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -979,6 +979,8 @@ extern errcode_t ext2fs_set_generic_bitmap_range(ext2fs_generic_bitmap bmap,
 /* getsize.c */
 extern errcode_t ext2fs_get_device_size(const char *file, int blocksize,
 					blk_t *retblocks);
+extern errcode_t ext2fs_get_device_size2(const char *file, int blocksize,
+					blk64_t *retblocks);
 
 /* getsectsize.c */
 errcode_t ext2fs_get_device_sectsize(const char *file, int *sectsize);
diff --git a/lib/ext2fs/getsize.c b/lib/ext2fs/getsize.c
index 7f6ef71..48b9eaf 100644
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
@@ -293,6 +293,17 @@ out:
 	return rc;
 }
 
+errcode_t ext2fs_get_device_size(const char *file, int blocksize,
+				 blk_t *retblocks)
+{
+	errcode_t retval;
+	blk64_t	blocks;
+	retval = ext2fs_get_device_size2(file, blocksize, &blocks);
+	if (!retval)
+		*retblocks = (blk_t) blocks;
+	return retval;
+}
+
 #endif /* WIN32 */
 
 #ifdef DEBUG

