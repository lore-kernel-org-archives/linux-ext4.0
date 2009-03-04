From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] fix ext4_free_inode vs. ext4_claim_inode race
Date: Tue, 03 Mar 2009 22:38:41 -0600
Message-ID: <49AE05D1.9050607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37459 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbZCDEis (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Mar 2009 23:38:48 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
---

Index: linux-2.6/fs/ext4/ialloc.c
===================================================================
--- linux-2.6.orig/fs/ext4/ialloc.c
+++ linux-2.6/fs/ext4/ialloc.c
@@ -188,7 +188,7 @@ void ext4_free_inode(handle_t *handle, s
 	struct ext4_group_desc *gdp;
 	struct ext4_super_block *es;
 	struct ext4_sb_info *sbi;
-	int fatal = 0, err, count;
+	int fatal = 0, err, count, cleared;
 	ext4_group_t flex_group;
 
 	if (atomic_read(&inode->i_count) > 1) {
@@ -248,8 +248,10 @@ void ext4_free_inode(handle_t *handle, s
 		goto error_return;
 
 	/* Ok, now we can actually update the inode bitmaps.. */
-	if (!ext4_clear_bit_atomic(sb_bgl_lock(sbi, block_group),
-					bit, bitmap_bh->b_data))
+	spin_lock(sb_bgl_lock(sbi, block_group));
+	cleared = ext4_clear_bit(bit, bitmap_bh->b_data);
+	spin_unlock(sb_bgl_lock(sbi, block_group));
+	if (!cleared)
 		ext4_error(sb, "ext4_free_inode",
 			   "bit already cleared for inode %lu", ino);
 	else {

