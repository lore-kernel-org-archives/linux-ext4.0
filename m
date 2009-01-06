From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix null pointer deref on mount
Date: Mon, 5 Jan 2009 23:12:30 -0500
Message-ID: <20090106041230.GA21733@mit.edu>
References: <4961603B.5020505@ph.tum.de> <20090105170259.GB8939@mit.edu> <49627285.8060407@ph.tum.de> <20090105213938.GG8939@mit.edu> <49628EBF.2040805@ph.tum.de> <20090105234411.GD14500@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57496 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbZAFEMb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Jan 2009 23:12:31 -0500
Content-Disposition: inline
In-Reply-To: <20090105234411.GD14500@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is what I've ended up adding to the ext4 patch queue.

     	     	  	   	     	      - Ted

>From 7439e5386e381e6727ff156fb891175ed96775e9 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Mon, 5 Jan 2009 23:11:36 -0500
Subject: [PATCH] ext4: Add sanity checks for the superblock before mounting the filesystem

This avoids insane superblock configurations that could lead to kernel
oops due to null pointer derefences.

Signed-off-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |   30 ++++++++++++++++++++----------
 1 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 57a3ccc..bf6a81d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2048,8 +2048,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	const char *descr;
 	int ret = -EINVAL;
 	int blocksize;
-	int db_count;
-	int i;
+	unsigned int db_count;
+	unsigned int i;
 	int needs_recovery, has_huge_files;
 	int features;
 	__u64 blocks_count;
@@ -2338,20 +2338,30 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (EXT4_BLOCKS_PER_GROUP(sb) == 0)
 		goto cantfind_ext4;
 
-	/* ensure blocks_count calculation below doesn't sign-extend */
-	if (ext4_blocks_count(es) + EXT4_BLOCKS_PER_GROUP(sb) <
-	    le32_to_cpu(es->s_first_data_block) + 1) {
-		printk(KERN_WARNING "EXT4-fs: bad geometry: block count %llu, "
-		       "first data block %u, blocks per group %lu\n",
-			ext4_blocks_count(es),
-			le32_to_cpu(es->s_first_data_block),
-			EXT4_BLOCKS_PER_GROUP(sb));
+        /*
+         * It makes no sense for the first data block to be beyond the end
+         * of the filesystem.
+         */
+        if (le32_to_cpu(es->s_first_data_block) >= ext4_blocks_count(es)) {
+                printk(KERN_WARNING "EXT4-fs: bad geometry: first data"
+		       "block %u is beyond end of filesystem (%llu)\n",
+		       le32_to_cpu(es->s_first_data_block),
+		       ext4_blocks_count(es));
 		goto failed_mount;
 	}
 	blocks_count = (ext4_blocks_count(es) -
 			le32_to_cpu(es->s_first_data_block) +
 			EXT4_BLOCKS_PER_GROUP(sb) - 1);
 	do_div(blocks_count, EXT4_BLOCKS_PER_GROUP(sb));
+	if (blocks_count > ((uint64_t)1<<32) - EXT4_DESC_PER_BLOCK(sb)) {
+		printk(KERN_WARNING "EXT4-fs: groups count too large: %u "
+		       "(block count %llu, first data block %u, "
+		       "blocks per group %lu)\n", sbi->s_groups_count,
+		       ext4_blocks_count(es),
+		       le32_to_cpu(es->s_first_data_block),
+		       EXT4_BLOCKS_PER_GROUP(sb));
+		goto failed_mount;
+	}
 	sbi->s_groups_count = blocks_count;
 	db_count = (sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) - 1) /
 		   EXT4_DESC_PER_BLOCK(sb);
-- 
1.6.0.4.8.g36f27.dirty

