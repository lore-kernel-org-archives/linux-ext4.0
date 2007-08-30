From: Valerie Clement <valerie.clement@bull.net>
Subject: [PATCH 1/8][e2fsprogs] use existing function
	ext2fs_group_first_block()
Date: Thu, 30 Aug 2007 17:31:36 +0200
Message-ID: <1188487896.15770.39.camel@ext1.frec.bull.fr>
References: <1188487715.15770.35.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43708 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbXH3N0h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Aug 2007 09:26:37 -0400
In-Reply-To: <1188487715.15770.35.camel@ext1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


From: Valerie Clement <valerie.clement@bull.net>

Replace piece of code by call to the existing function,
i.e. ext2fs_group_first_block().

Signed-off-by: Valerie Clement <valerie.clement@bull.net>
---

 lib/ext2fs/closefs.c |    3 +--
 lib/ext2fs/openfs.c  |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 474e00e..f780e80 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -57,8 +57,7 @@ int ext2fs_super_and_bgd_loc(ext2_filsys fs,
 	int	numblocks, has_super;
 	int	old_desc_blocks;
 
-	group_block = fs->super->s_first_data_block +
-		(group * fs->super->s_blocks_per_group);
+	group_block = ext2fs_group_first_block(fs, group);
 
 	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
 		old_desc_blocks = fs->super->s_first_meta_bg;
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 55cc077..8a369c3 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -42,8 +42,7 @@ blk_t ext2fs_descriptor_block_loc(ext2_filsys fs, blk_t group_block, dgrp_t i)
 	bg = (fs->blocksize / sizeof (struct ext2_group_desc)) * i;
 	if (ext2fs_bg_has_super(fs, bg))
 		has_super = 1;
-	ret_blk = (fs->super->s_first_data_block + has_super + 
-		   (bg * fs->super->s_blocks_per_group));
+	ret_blk = ext2fs_group_first_block(fs, bg) + has_super;
 	/*
 	 * If group_block is not the normal value, we're trying to use
 	 * the backup group descriptors and superblock --- so use the
