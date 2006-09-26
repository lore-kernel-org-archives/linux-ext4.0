From: Alexandre Ratchov <alexandre.ratchov@bull.net>
Subject: [patch 05/12] rfc: 2fsprogs update
Date: Tue, 26 Sep 2006 16:47:44 +0200
Message-ID: <20060926144744.GE25755@openx1.frec.bull.fr>
References: <20060926143343.GA20020@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:904 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S932100AbWIZOrv
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Sep 2006 10:47:51 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 54B6B19D915
	for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2006 16:47:48 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 12488-01 for <linux-ext4@vger.kernel.org>;
 Tue, 26 Sep 2006 16:47:45 +0200 (CEST)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 68B4919D90C
	for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2006 16:47:45 +0200 (CEST)
To: linux-ext4@vger.kernel.org
In-Reply-To: <20060926143343.GA20020@openx1.frec.bull.fr>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Allow htree directories to be extent mapped.

Index: e2fsprogs/e2fsck/pass1.c
===================================================================
--- e2fsprogs.orig/e2fsck/pass1.c	2006-07-10 03:45:19.000000000 -0600
+++ e2fsprogs/e2fsck/pass1.c	2006-07-10 03:47:55.000000000 -0600
@@ -1364,10 +1364,23 @@ clear_extattr:
 	return 0;
 }
 
+static int htree_blk_iter_cb(ext2_filsys fs EXT2FS_ATTR((unused)),
+			     blk_t *blocknr,
+			     e2_blkcnt_t blockcnt EXT2FS_ATTR((unused)),
+			     blk_t ref_blk EXT2FS_ATTR((unused)),
+			     int ref_offset EXT2FS_ATTR((unused)),
+			     void *priv_data)
+{
+	blk_t *blk = priv_data;
+
+	*blk = *blocknr;
+
+	return BLOCK_ABORT;
+}
+
 /* Returns 1 if bad htree, 0 if OK */
 static int handle_htree(e2fsck_t ctx, struct problem_context *pctx,
-			ext2_ino_t ino EXT2FS_ATTR((unused)),
-			struct ext2_inode *inode,
+			ext2_ino_t ino, struct ext2_inode *inode,
 			char *block_buf)
 {
 	struct ext2_dx_root_info	*root;
@@ -1381,7 +1394,8 @@ static int handle_htree(e2fsck_t ctx, st
 	     fix_problem(ctx, PR_1_HTREE_SET, pctx)))
 		return 1;
 
-	blk = inode->i_block[0];
+	ext2fs_block_iterate2(fs, ino, BLOCK_FLAG_DATA_ONLY | BLOCK_FLAG_HOLE,
+			      block_buf, htree_blk_iter_cb, &blk);
 	if (((blk == 0) ||
 	     (blk < fs->super->s_first_data_block) ||
 	     (blk >= fs->super->s_blocks_count)) &&

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
