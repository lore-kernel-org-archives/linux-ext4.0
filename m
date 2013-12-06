From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 17/30] debugfs: handle inline_data feature in bmap command
Date: Fri,  6 Dec 2013 17:58:04 +0800
Message-ID: <1386323897-2354-18-git-send-email-wenqing.lz@taobao.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:32898 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607Ab3LFJ4D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 04:56:03 -0500
Received: by mail-pd0-f173.google.com with SMTP id p10so750969pdj.32
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 01:56:03 -0800 (PST)
In-Reply-To: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

No physical block mapping if an inode has inline data.

Meanwhile this commit fixes a minor bug in bmap command when it prints
an error.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/debugfs.c         |    2 +-
 lib/ext2fs/bmap.c         |    7 +++++++
 lib/ext2fs/ext2_err.et.in |    3 +++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index ef5f201..bc8413d 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -2135,7 +2135,7 @@ void do_bmap(int argc, char *argv[])
 
 	errcode = ext2fs_bmap2(current_fs, ino, 0, 0, 0, blk, 0, &pblk);
 	if (errcode) {
-		com_err("argv[0]", errcode,
+		com_err(argv[0], errcode,
 			"while mapping logical block %llu\n", blk);
 		return;
 	}
diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
index 5074587..e148dba 100644
--- a/lib/ext2fs/bmap.c
+++ b/lib/ext2fs/bmap.c
@@ -266,6 +266,13 @@ errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
 	}
 	addr_per_block = (blk_t) fs->blocksize >> 2;
 
+	/*
+	 * If an inode has inline data, that means that it doesn't have
+	 * any blocks and we shouldn't map any blocks for it.
+	 */
+	if (inode->i_flags & EXT4_INLINE_DATA_FL)
+		return EXT2_ET_INLINE_DATA_NO_BLOCK;
+
 	if (!block_buf) {
 		retval = ext2fs_get_array(2, fs->blocksize, &buf);
 		if (retval)
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index 0781145..f93f0e8 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -503,4 +503,7 @@ ec	EXT2_ET_EA_NO_SPACE,
 ec	EXT2_ET_NO_INLINE_DATA,
 	"Inode doesn't have inline data"
 
+ec	EXT2_ET_INLINE_DATA_NO_BLOCK,
+	"No block for an inode with inline data"
+
 	end
-- 
1.7.9.7

