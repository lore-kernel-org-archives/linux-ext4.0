From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 11/15][e2fsprogs] Add 64-bit openfs interface.
Date: Tue, 15 Jul 2008 11:51:07 -0500
Message-ID: <20080715165107.28567.40657.stgit@ichigo>
References: <20080715164332.28567.27913.stgit@ichigo>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Jose R. Santos" <jrs@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:36771 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbYGOQvS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jul 2008 12:51:18 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6FGpFEA017668
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 12:51:16 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6FGp81j154920
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 10:51:11 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6FGp8NK009284
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 10:51:08 -0600
In-Reply-To: <20080715164332.28567.27913.stgit@ichigo>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Add 64-bit openfs interface.

Add new ext2fs_descriptor_block_loc2() routine that takes blk64_t as
an input.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/ext2fs.h |    2 ++
 lib/ext2fs/openfs.c |   12 +++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
--

 lib/ext2fs/ext2fs.h |    2 ++
 lib/ext2fs/openfs.c |   12 +++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 464d323..0ca978b 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1119,6 +1119,8 @@ extern errcode_t ext2fs_open2(const char *name, const char *io_options,
 			      int flags, int superblock, 
 			      unsigned int block_size, io_manager manager,
 			      ext2_filsys *ret_fs);
+extern blk64_t ext2fs_descriptor_block_loc2(ext2_filsys fs,
+					blk64_t group_block, dgrp_t i);
 extern blk_t ext2fs_descriptor_block_loc(ext2_filsys fs, blk_t group_block, 
 					 dgrp_t i);
 errcode_t ext2fs_get_data_io(ext2_filsys fs, io_channel *old_io);
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 525693e..77f6442 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -29,11 +29,12 @@
 #include "ext2fs.h"
 #include "e2image.h"
 
-blk_t ext2fs_descriptor_block_loc(ext2_filsys fs, blk_t group_block, dgrp_t i)
+blk64_t ext2fs_descriptor_block_loc2(ext2_filsys fs, blk64_t group_block,
+				     dgrp_t i)
 {
 	int	bg;
 	int	has_super = 0;
-	int	ret_blk;
+	blk64_t	ret_blk;
 
 	if (!(fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) ||
 	    (i < fs->super->s_first_meta_bg))
@@ -42,7 +43,7 @@ blk_t ext2fs_descriptor_block_loc(ext2_filsys fs, blk_t group_block, dgrp_t i)
 	bg = EXT2_DESC_PER_BLOCK(fs->super) * i;
 	if (ext2fs_bg_has_super(fs, bg))
 		has_super = 1;
-	ret_blk = ext2fs_group_first_block(fs, bg) + has_super;
+	ret_blk = ext2fs_group_first_block2(fs, bg) + has_super;
 	/*
 	 * If group_block is not the normal value, we're trying to use
 	 * the backup group descriptors and superblock --- so use the
@@ -58,6 +59,11 @@ blk_t ext2fs_descriptor_block_loc(ext2_filsys fs, blk_t group_block, dgrp_t i)
 	return ret_blk;
 }
 
+blk_t ext2fs_descriptor_block_loc(ext2_filsys fs, blk_t group_block, dgrp_t i)
+{
+	return ext2fs_descriptor_block_loc2(fs, group_block, i);
+}
+
 errcode_t ext2fs_open(const char *name, int flags, int superblock,
 		      unsigned int block_size, io_manager manager, 
 		      ext2_filsys *ret_fs)

