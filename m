From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.27 01/24] ext4: fix ext4_free_inode() vs. ext4_claim_inode() race
Date: Tue,  2 Jun 2009 08:09:13 -0400
Message-ID: <1243944576-20915-1-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59246 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbZFBMJn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:09:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

I was seeing fsck errors on inode bitmaps after a 4 thread
dbench run on a 4 cpu machine:

Inode bitmap differences: -50736 -(50752--50753) etc...

I believe that this is because ext4_free_inode() uses atomic
bitops, and although ext4_new_inode() *used* to also use atomic
bitops for synchronization, commit
393418676a7602e1d7d3f6e560159c65c8cbd50e changed this to use
the sb_bgl_lock, so that we could also synchronize against
read_inode_bitmap and initialization of uninit inode tables.

However, that change left ext4_free_inode using atomic bitops,
which I think leaves no synchronization between setting &
unsetting bits in the inode table.

The below patch fixes it for me, although I wonder if we're
getting at all heavy-handed with this spinlock...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 7ce9d5d1f3c8736511daa413c64985a05b2feee3)
---
 fs/ext4/ialloc.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index cce841f..f9b9fad 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -188,7 +188,7 @@ void ext4_free_inode (handle_t *handle, struct inode * inode)
 	struct ext4_group_desc * gdp;
 	struct ext4_super_block * es;
 	struct ext4_sb_info *sbi;
-	int fatal = 0, err;
+	int fatal = 0, err, cleared;
 	ext4_group_t flex_group;
 
 	if (atomic_read(&inode->i_count) > 1) {
@@ -242,10 +242,12 @@ void ext4_free_inode (handle_t *handle, struct inode * inode)
 		goto error_return;
 
 	/* Ok, now we can actually update the inode bitmaps.. */
-	if (!ext4_clear_bit_atomic(sb_bgl_lock(sbi, block_group),
-					bit, bitmap_bh->b_data))
-		ext4_error (sb, "ext4_free_inode",
-			      "bit already cleared for inode %lu", ino);
+	spin_lock(sb_bgl_lock(sbi, block_group));
+	cleared = ext4_clear_bit(bit, bitmap_bh->b_data);
+	spin_unlock(sb_bgl_lock(sbi, block_group));
+	if (!cleared)
+		ext4_error(sb, "ext4_free_inode",
+			   "bit already cleared for inode %lu", ino);
 	else {
 		gdp = ext4_get_group_desc (sb, block_group, &bh2);
 
-- 
1.6.3.1.1.g75fc.dirty

