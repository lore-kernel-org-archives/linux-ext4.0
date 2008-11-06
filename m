From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: calculate journal credits correctly
Date: Thu,  6 Nov 2008 14:51:15 -0500
Message-ID: <1226001075-16457-1-git-send-email-tytso@mit.edu>
References: <20081103033920.GC29102@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51722 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751007AbYKFTvT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 14:51:19 -0500
In-Reply-To: <20081103033920.GC29102@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This fixes a 2.6.27 regression which was introduced in commit a02908f1.

We weren't passing the chunk parameter down to the two subections,
ext4_indirect_trans_blocks() and ext4_ext_index_trans_blocks(), with
the result that massively overestimate the amount of credits needed by
ext4_da_writepages, especially in the non-extents case.  This causes
failures especially on /boot partitions, which tend to be small and
non-extent using since GRUB doesn't handle extents.

Thanks to Joseph Fannin for reporting this bug.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8dbf695..5a130b5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4580,9 +4580,10 @@ static int ext4_indirect_trans_blocks(struct inode *inode, int nrblocks,
 static int ext4_index_trans_blocks(struct inode *inode, int nrblocks, int chunk)
 {
 	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
-		return ext4_indirect_trans_blocks(inode, nrblocks, 0);
-	return ext4_ext_index_trans_blocks(inode, nrblocks, 0);
+		return ext4_indirect_trans_blocks(inode, nrblocks, chunk);
+	return ext4_ext_index_trans_blocks(inode, nrblocks, chunk);
 }
+
 /*
  * Account for index blocks, block groups bitmaps and block group
  * descriptor blocks if modify datablocks and index blocks
-- 
1.5.6.1.205.ge2c7.dirty

