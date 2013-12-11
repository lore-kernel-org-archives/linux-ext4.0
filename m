From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 17/74] debugfs: don't leak mmp_s memory
Date: Tue, 10 Dec 2013 17:20:14 -0800
Message-ID: <20131211012014.30655.58647.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26257 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab3LKBUU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:20:20 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2fs_free_mem() takes a pointer to a pointer, similar to
ext2fs_get_mem().  Improve the documentation, and fix debugfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/set_fields.c |    2 +-
 lib/ext2fs/ext2fs.h  |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index aad1cd8..1e57277 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -805,7 +805,7 @@ void do_set_mmp_value(int argc, char *argv[])
 		if (retval) {
 			com_err(argv[0], retval, "reading MMP block %llu.\n",
 				(long long)current_fs->super->s_mmp_block);
-			ext2fs_free_mem(mmp_s);
+			ext2fs_free_mem(&mmp_s);
 			return;
 		}
 		current_fs->mmp_buf = mmp_s;
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 64e498f..0624350 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1608,7 +1608,7 @@ _INLINE_ void ext2fs_init_csum_seed(ext2_filsys fs)
 #ifndef EXT2_CUSTOM_MEMORY_ROUTINES
 #include <string.h>
 /*
- *  Allocate memory
+ *  Allocate memory.  The 'ptr' arg must point to a pointer.
  */
 _INLINE_ errcode_t ext2fs_get_mem(unsigned long size, void *ptr)
 {
@@ -1655,7 +1655,7 @@ _INLINE_ errcode_t ext2fs_get_arrayzero(unsigned long count,
 }
 
 /*
- * Free memory
+ * Free memory.  The 'ptr' arg must point to a pointer.
  */
 _INLINE_ errcode_t ext2fs_free_mem(void *ptr)
 {
@@ -1669,7 +1669,7 @@ _INLINE_ errcode_t ext2fs_free_mem(void *ptr)
 }
 
 /*
- *  Resize memory
+ *  Resize memory.  The 'ptr' arg must point to a pointer.
  */
 _INLINE_ errcode_t ext2fs_resize_mem(unsigned long EXT2FS_ATTR((unused)) old_size,
 				     unsigned long size, void *ptr)

