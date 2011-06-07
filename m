From: amir73il@users.sourceforge.net
Subject: [PATCH v1 24/36] ext4: snapshot journaled - bypass to save credits
Date: Tue,  7 Jun 2011 18:07:51 +0300
Message-ID: <1307459283-22130-25-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60303 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab1FGPKD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:10:03 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so3629480wya.19
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:10:02 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Don't journal COW bitmap indirect blocks to save journal credits.
On very few COW operations (i.e., first block group access after
snapshot take), there may be up to 3 extra blocks allocated for the
active snapshot (i.e., COW bitmap block and up to 2 indirect blocks).
Taking these 2 indorect blocks into account on every COW operation
would further increase the transaction's COW credits factor.
Instead, we choose to pay a small performance penalty on these few
COW bitmap operations and wait until they are synced to disk.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/inode.c |   31 +++++++++++++++++++++++++++----
 1 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d703a55..de40993 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -835,7 +835,8 @@ static int ext4_alloc_branch_cow(handle_t *handle, struct inode *inode,
 		branch[n].bh = bh;
 		lock_buffer(bh);
 		BUFFER_TRACE(bh, "call get_create_access");
-		err = ext4_journal_get_create_access(handle, bh);
+		if (!SNAPMAP_ISSYNC(flags))
+			err = ext4_journal_get_create_access(handle, bh);
 		if (err) {
 			/* Don't brelse(bh) here; it's done in
 			 * ext4_journal_forget() below */
@@ -862,7 +863,21 @@ static int ext4_alloc_branch_cow(handle_t *handle, struct inode *inode,
 		unlock_buffer(bh);
 
 		BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
-		err = ext4_handle_dirty_metadata(handle, inode, bh);
+		/*
+		 * When accessing a block group for the first time, the
+		 * block bitmap is the first block to be copied to the
+		 * snapshot.  We don't want to reserve journal credits for
+		 * the indirect blocks that map the bitmap copy (the COW
+		 * bitmap), so instead of writing through the journal, we
+		 * sync the indirect blocks directly to disk.  Of course,
+		 * this is not good for performance but it only happens once
+		 * per snapshot/blockgroup.
+		 */
+		if (SNAPMAP_ISSYNC(flags)) {
+			mark_buffer_dirty(bh);
+			sync_dirty_buffer(bh);
+		} else
+			err = ext4_handle_dirty_metadata(handle, inode, bh);
 		if (err)
 			goto failed;
 	}
@@ -871,6 +886,9 @@ static int ext4_alloc_branch_cow(handle_t *handle, struct inode *inode,
 failed:
 	/* Allocation failed, free what we already allocated */
 	ext4_free_blocks(handle, inode, NULL, new_blocks[0], 1, 0);
+	/* If we bypassed journal, we don't need to forget any block */
+	if (SNAPMAP_ISSYNC(flags))
+		n = 1;
 	for (i = 1; i <= n ; i++) {
 		/*
 		 * branch[i].bh is newly allocated, so there is no
@@ -966,13 +984,18 @@ static int ext4_splice_branch_cow(handle_t *handle, struct inode *inode,
 
 err_out:
 	for (i = 1; i <= num; i++) {
+		int forget = EXT4_FREE_BLOCKS_FORGET;
+
+		/* If we bypassed journal, we don't need to forget */
+		if (SNAPMAP_ISSYNC(flags))
+			forget = 0;
+
 		/*
 		 * branch[i].bh is newly allocated, so there is no
 		 * need to revoke the block, which is why we don't
 		 * need to set EXT4_FREE_BLOCKS_METADATA.
 		 */
-		ext4_free_blocks(handle, inode, where[i].bh, 0, 1,
-				 EXT4_FREE_BLOCKS_FORGET);
+		ext4_free_blocks(handle, inode, where[i].bh, 0, 1, forget);
 	}
 	if (SNAPMAP_ISMOVE(flags))
 		/* don't charge snapshot file owner if move failed */
-- 
1.7.4.1

