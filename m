From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: fix race condition when loading block or inode bitmaps
Date: Thu, 24 Nov 2011 20:08:20 -0500
Message-ID: <1322183300-12962-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42470 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890Ab1KYBIX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Nov 2011 20:08:23 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We use an separate flag in buffer head to determine whether the bitmap
has been valid.  This is distinct from it being uptodate, due to the
uninit_bg feature.  More details about the rationale for this flag can
be found in commit 2ccb5fb9f1.  We set this bitmap_uptodate bit before
issuing the read request, so if another CPU attempts to load the same
block or inode bitmap, since ext4_read_{block,inode}_bitmap() checks
the bitmap_uptodate flag without locking the buffer head, hilarity
ensues.

This result of this bug is that occasionally a block or inode gets
allocated twice, which gets noticed when the second user of the block
gets deleted, or when an directory suddenly becomes a regular file or
a symlink.  I'm *really* surprised this doesn't happen more often; but
in actual practice the fact that we tend to search for a zero bit in
the bitmap without taking a lock, and then taking the block group lock
and double checking to see if we actually got the allocation tends to
protect us.

This bug was introduced in commit 2ccb5fb9f1, which dates back to
January 2009 and 2.6.29.  So this bug has been around for a *long*
time.  (We've seen it for over a year, but rarely enough that it we
could never find a repro case so we could study it in controlled
circumstances.)

Google-Bug-Id: 2828254
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
---
 fs/ext4/balloc.c |   12 ++++++------
 fs/ext4/ialloc.c |   12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 12ccacd..4501aab 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -372,7 +372,7 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
 	ext4_unlock_group(sb, block_group);
 	if (buffer_uptodate(bh)) {
 		/*
-		 * if not uninit if bh is uptodate,
+		 * if not uninit && bh is uptodate,
 		 * bitmap is also uptodate
 		 */
 		set_bitmap_uptodate(bh);
@@ -380,13 +380,12 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
 		return bh;
 	}
 	/*
-	 * submit the buffer_head for read. We can
-	 * safely mark the bitmap as uptodate now.
-	 * We do it here so the bitmap uptodate bit
-	 * get set with buffer lock held.
+	 * submit the buffer_head for read.  It's important that we
+	 * *not* mark the bitmap up to date until the read is
+	 * completed, since we check bitmap_update() above without
+	 * locking the buffer for speed reasons.
 	 */
 	trace_ext4_read_block_bitmap_load(sb, block_group);
-	set_bitmap_uptodate(bh);
 	if (bh_submit_read(bh) < 0) {
 		put_bh(bh);
 		ext4_error(sb, "Cannot read block bitmap - "
@@ -394,6 +393,7 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
 			    block_group, bitmap_blk);
 		return NULL;
 	}
+	set_bitmap_uptodate(bh);
 	ext4_valid_block_bitmap(sb, desc, block_group, bh);
 	/*
 	 * file system mounted not to panic on error,
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 00beb4f..6fbae6d 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -139,7 +139,7 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 
 	if (buffer_uptodate(bh)) {
 		/*
-		 * if not uninit if bh is uptodate,
+		 * if not uninit && bh is uptodate,
 		 * bitmap is also uptodate
 		 */
 		set_bitmap_uptodate(bh);
@@ -147,13 +147,12 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 		return bh;
 	}
 	/*
-	 * submit the buffer_head for read. We can
-	 * safely mark the bitmap as uptodate now.
-	 * We do it here so the bitmap uptodate bit
-	 * get set with buffer lock held.
+	 * submit the buffer_head for read.  It's important that we
+	 * *not* mark the bitmap up to date until the read is
+	 * completed, since we check bitmap_update() above without
+	 * locking the buffer for speed reasons.
 	 */
 	trace_ext4_load_inode_bitmap(sb, block_group);
-	set_bitmap_uptodate(bh);
 	if (bh_submit_read(bh) < 0) {
 		put_bh(bh);
 		ext4_error(sb, "Cannot read inode bitmap - "
@@ -161,6 +160,7 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 			    block_group, bitmap_blk);
 		return NULL;
 	}
+	set_bitmap_uptodate(bh);
 	return bh;
 }
 
-- 
1.7.4.1.22.gec8e1.dirty

