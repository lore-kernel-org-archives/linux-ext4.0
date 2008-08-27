From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/4] Create the journal in the middle of the filesystem
Date: Wed, 27 Aug 2008 17:14:34 -0400
Message-ID: <1219871676-18456-2-git-send-email-tytso@mit.edu>
References: <20080827210636.GC26987@mit.edu>
 <1219871676-18456-1-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Boh=C3=A9?= <frederic.bohe@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51444 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752506AbYH0VOi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Aug 2008 17:14:38 -0400
In-Reply-To: <1219871676-18456-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This speeds up access to the journal by eliminating worst-case seeks
from one end of the disk to another, which can be quite common in very
fsync-intensive workloads if the file is located near the end of the
disk, and the journal is located the beginning of the disk.

In addition, this can help eliminate journal fragmentation when
flex_bg is enabled, since the first block group has a large amount of
metadata.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/mkjournal.c |   28 +++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index 3cae874..cd3df07 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -198,6 +198,7 @@ errcode_t ext2fs_zero_blocks(ext2_filsys fs, blk_t blk, int num,
 struct mkjournal_struct {
 	int		num_blocks;
 	int		newblocks;
+	blk_t		goal;
 	blk_t		blk_to_zero;
 	int		zero_count;
 	char		*buf;
@@ -213,14 +214,13 @@ static int mkjournal_proc(ext2_filsys	fs,
 {
 	struct mkjournal_struct *es = (struct mkjournal_struct *) priv_data;
 	blk_t	new_blk;
-	static blk_t	last_blk = 0;
 	errcode_t	retval;
 	
 	if (*blocknr) {
-		last_blk = *blocknr;
+		es->goal = *blocknr;
 		return 0;
 	}
-	retval = ext2fs_new_block(fs, last_blk, 0, &new_blk);
+	retval = ext2fs_new_block(fs, es->goal, 0, &new_blk);
 	if (retval) {
 		es->err = retval;
 		return BLOCK_ABORT;
@@ -258,8 +258,7 @@ static int mkjournal_proc(ext2_filsys	fs,
 		es->err = retval;
 		return BLOCK_ABORT;
 	}
-	*blocknr = new_blk;
-	last_blk = new_blk;
+	*blocknr = es->goal = new_blk;
 	ext2fs_block_alloc_stats(fs, new_blk, +1);
 
 	if (es->num_blocks == 0)
@@ -276,6 +275,7 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 				     blk_t size, int flags)
 {
 	char			*buf;
+	dgrp_t			group, start, end, i;
 	errcode_t		retval;
 	struct ext2_inode	inode;
 	struct mkjournal_struct	es;
@@ -298,6 +298,24 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 	es.err = 0;
 	es.zero_count = 0;
 
+	/*
+	 * Set the initial goal block to be roughly at the middle of
+	 * the filesystem.  Pick a group that has the largest number
+	 * of free blocks.
+	 */
+	group = ext2fs_group_of_blk(fs, (fs->super->s_blocks_count - 
+					 fs->super->s_first_data_block) / 2);
+	start = (group > 0) ? group-1 : group;
+	end = ((group+1) < fs->group_desc_count) ? group+1 : group;
+	group = start;
+	for (i=start+1; i <= end; i++)
+		if (fs->group_desc[i].bg_free_blocks_count >
+		    fs->group_desc[group].bg_free_blocks_count)
+			group = i;
+
+	es.goal = (fs->super->s_blocks_per_group * group) +
+		fs->super->s_first_data_block;
+
 	retval = ext2fs_block_iterate2(fs, journal_ino, BLOCK_FLAG_APPEND,
 				       0, mkjournal_proc, &es);
 	if (es.err) {
-- 
1.5.6.1.205.ge2c7.dirty

