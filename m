Return-Path: <SRS0=J55O=OU=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57064 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726069AbeLKIYC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 11 Dec 2018 03:24:02 -0500
From: Nikolay Borisov <nborisov@suse.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] ext4: Replace opencoded i_writecount usage with inode_is_open_for_write
Date: Tue, 11 Dec 2018 10:23:55 +0200
Message-Id: <20181211082355.19841-1-nborisov@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is a function which clearly conveys the objective of checking
i_writecount. Additionally the usage in ext4_mb_initialize_context was
wrong, since a node would have wrongfully been reported as writable if
i_writecount had a negative value (MMAP_DENY_WRITE).

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/ext4/inode.c   | 2 +-
 fs/ext4/mballoc.c | 7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 22a9d8159720..04e5bc0b5c8d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -391,7 +391,7 @@ void ext4_da_update_reserve_space(struct inode *inode,
 	 * inode's preallocations.
 	 */
 	if ((ei->i_reserved_data_blocks == 0) &&
-	    (atomic_read(&inode->i_writecount) == 0))
+	    !inode_is_open_for_write(inode))
 		ext4_discard_preallocations(inode);
 }
 
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e2248083cdca..6fb76d408093 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4176,9 +4176,8 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 	isize = (i_size_read(ac->ac_inode) + ac->ac_sb->s_blocksize - 1)
 		>> bsbits;
 
-	if ((size == isize) &&
-	    !ext4_fs_is_busy(sbi) &&
-	    (atomic_read(&ac->ac_inode->i_writecount) == 0)) {
+	if ((size == isize) && !ext4_fs_is_busy(sbi) &&
+	    !inode_is_open_for_write(ac->ac_inode)) {
 		ac->ac_flags |= EXT4_MB_HINT_NOPREALLOC;
 		return;
 	}
@@ -4258,7 +4257,7 @@ ext4_mb_initialize_context(struct ext4_allocation_context *ac,
 			(unsigned) ar->goal, ac->ac_flags, ac->ac_2order,
 			(unsigned) ar->lleft, (unsigned) ar->pleft,
 			(unsigned) ar->lright, (unsigned) ar->pright,
-			atomic_read(&ar->inode->i_writecount) ? "" : "non-");
+			inode_is_open_for_write(ar->inode) ? "" : "non-");
 	return 0;
 
 }
-- 
2.17.1
