From: amir73il@users.sourceforge.net
Subject: [PATCH v1 29/36] ext4: snapshot race conditions - concurrent COW bitmap operations
Date: Tue,  7 Jun 2011 18:07:56 +0300
Message-ID: <1307459283-22130-30-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41767 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab1FGPKQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:10:16 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so5035787wwa.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:10:16 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Wait for pending COW bitmap creations to complete.
When concurrent tasks try to COW buffers from the same block group
for the first time, the first task to reset the COW bitmap cache
is elected to create the new COW bitmap block.  The rest of the tasks
wait (in msleep(1) loop), until the COW bitmap cache is uptodate.
The COWing task copies the bitmap block into the new COW bitmap block
and updates the COW bitmap cache with the new block number.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/snapshot.c |   45 ++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/snapshot.c b/fs/ext4/snapshot.c
index 2724381..000e655 100644
--- a/fs/ext4/snapshot.c
+++ b/fs/ext4/snapshot.c
@@ -248,9 +248,48 @@ ext4_snapshot_read_cow_bitmap(handle_t *handle, struct inode *snapshot,
 
 	bitmap_blk = ext4_block_bitmap(sb, desc);
 
-	ext4_lock_group(sb, block_group);
-	cow_bitmap_blk = grp->bg_cow_bitmap;
-	ext4_unlock_group(sb, block_group);
+	/*
+	 * Handle concurrent COW bitmap operations.
+	 * bg_cow_bitmap has 3 states:
+	 * = 0 - uninitialized (after mount and after snapshot take).
+	 * = bg_block_bitmap - marks pending COW of block bitmap.
+	 * other - location of initialized COW bitmap block.
+	 *
+	 * The first task to access block group after mount or snapshot take,
+	 * will read the uninitialized state, mark pending COW state, initialize
+	 * the COW bitmap block and update COW bitmap cache.  Other tasks will
+	 * busy wait until the COW bitmap cache is in initialized state, before
+	 * reading the COW bitmap block.
+	 */
+	do {
+		ext4_lock_group(sb, block_group);
+		cow_bitmap_blk = grp->bg_cow_bitmap;
+		if (cow_bitmap_blk == 0)
+			/* mark pending COW of bitmap block */
+			grp->bg_cow_bitmap = bitmap_blk;
+		ext4_unlock_group(sb, block_group);
+
+		if (cow_bitmap_blk == 0) {
+			snapshot_debug(3, "initializing COW bitmap #%u "
+					"of snapshot (%u)...\n",
+					block_group, snapshot->i_generation);
+			/* sleep 1 tunable delay unit */
+			snapshot_test_delay(SNAPTEST_BITMAP);
+			break;
+		}
+		if (cow_bitmap_blk == bitmap_blk) {
+			/* wait for another task to COW bitmap block */
+			snapshot_debug_once(2, "waiting for pending COW "
+					    "bitmap #%d...\n", block_group);
+			/*
+			 * This is an unlikely event that can happen only once
+			 * per block_group/snapshot, so msleep(1) is sufficient
+			 * and there is no need for a wait queue.
+			 */
+			msleep(1);
+		}
+		/* XXX: Should we fail after N retries? */
+	} while (cow_bitmap_blk == 0 || cow_bitmap_blk == bitmap_blk);
 	if (cow_bitmap_blk)
 		return sb_bread(sb, cow_bitmap_blk);
 
-- 
1.7.4.1

