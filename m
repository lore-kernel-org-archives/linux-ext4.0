From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [RFC PATCH 9/9][e2fsprogs] Add 64-bit openfs interface.
Date: Fri, 09 May 2008 11:40:26 -0500
Message-ID: <20080509164026.15484.32017.stgit@gara>
References: <20080509163928.15484.22146.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Jose R. Santos" <jrs@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51314 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765609AbYEIQj5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 May 2008 12:39:57 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m49Gdvdo020252
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 12:39:57 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m49GdvQD106592
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 12:39:57 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m49GducB008726
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 12:39:56 -0400
In-Reply-To: <20080509163928.15484.22146.stgit@gara>
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

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index f06581c..3ab8bb7 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1060,6 +1060,8 @@ extern errcode_t ext2fs_open2(const char *name, const char *io_options,
 			      int flags, int superblock, 
 			      unsigned int block_size, io_manager manager,
 			      ext2_filsys *ret_fs);
+extern blk64_t ext2fs_descriptor_block_loc2(ext2_filsys fs,
+					blk64_t group_block, dgrp_t i);
 extern blk_t ext2fs_descriptor_block_loc(ext2_filsys fs, blk_t group_block, 
 					 dgrp_t i);
 errcode_t ext2fs_get_data_io(ext2_filsys fs, io_channel *old_io);
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index fc54afe..6b365b7 100644
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

