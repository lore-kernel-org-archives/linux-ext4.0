From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: open-code ext4_mb_update_group_info
Date: Sun, 16 Aug 2009 14:13:10 -0500
Message-ID: <4A885A46.7040208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51020 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbZHPTNL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Aug 2009 15:13:11 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n7GJDChw012221
	for <linux-ext4@vger.kernel.org>; Sun, 16 Aug 2009 15:13:12 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7GJDBiT029470
	for <linux-ext4@vger.kernel.org>; Sun, 16 Aug 2009 15:13:12 -0400
Received: from Liberator.lan (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n7GJDA1s005026
	for <linux-ext4@vger.kernel.org>; Sun, 16 Aug 2009 15:13:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_mb_update_group_info is only called in one place, and it's
extremely simple.  There's no reason to have it in a separate
function in a separate file as far as I can tell, it just
obfuscates what's really going on.

Perhaps it was intended to keep the grp->bb_* manipulation
local to mballoc.c but we're already accessing other grp->
fields in balloc.c directly so this seems ok.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

 balloc.c  |    2 +-
 ext4.h    |    2 --
 mballoc.c |    9 ---------
 3 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index e2126d7..1d04189 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -478,7 +478,7 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 	 * new bitmap information
 	 */
 	set_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &(grp->bb_state));
-	ext4_mb_update_group_info(grp, blocks_freed);
+	grp->bb_free += blocks_freed;
 	up_write(&grp->alloc_sem);
 
 	/* We dirtied the bitmap block */
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9714db3..80cd0f7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1340,8 +1340,6 @@ extern void ext4_mb_free_blocks(handle_t *, struct inode *,
 		ext4_fsblk_t, unsigned long, int, unsigned long *);
 extern int ext4_mb_add_groupinfo(struct super_block *sb,
 		ext4_group_t i, struct ext4_group_desc *desc);
-extern void ext4_mb_update_group_info(struct ext4_group_info *grp,
-		ext4_grpblk_t add);
 extern int ext4_mb_get_buddy_cache_lock(struct super_block *, ext4_group_t);
 extern void ext4_mb_put_buddy_cache_lock(struct super_block *,
 						ext4_group_t, int);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index cd25846..2741b11 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2558,15 +2558,6 @@ exit_meta_group_info:
 	return -ENOMEM;
 } /* ext4_mb_add_groupinfo */
 
-/*
- * Update an existing group.
- * This function is used for online resize
- */
-void ext4_mb_update_group_info(struct ext4_group_info *grp, ext4_grpblk_t add)
-{
-	grp->bb_free += add;
-}
