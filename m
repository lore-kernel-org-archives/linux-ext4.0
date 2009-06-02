From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.27 05/24] ext4: fix bb_prealloc_list corruption due to wrong group locking
Date: Tue,  2 Jun 2009 08:09:17 -0400
Message-ID: <1243944576-20915-5-git-send-email-tytso@mit.edu>
References: <1243944576-20915-1-git-send-email-tytso@mit.edu>
 <1243944576-20915-2-git-send-email-tytso@mit.edu>
 <1243944576-20915-3-git-send-email-tytso@mit.edu>
 <1243944576-20915-4-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59253 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbZFBMJo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:09:44 -0400
In-Reply-To: <1243944576-20915-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

This is for Red Hat bug 490026: EXT4 panic, list corruption in
ext4_mb_new_inode_pa

ext4_lock_group(sb, group) is supposed to protect this list for
each group, and a common code flow to remove an album is like
this:

    ext4_get_group_no_and_offset(sb, pa->pa_pstart, &grp, NULL);
    ext4_lock_group(sb, grp);
    list_del(&pa->pa_group_list);
    ext4_unlock_group(sb, grp);

so it's critical that we get the right group number back for
this prealloc context, to lock the right group (the one
associated with this pa) and prevent concurrent list manipulation.

however, ext4_mb_put_pa() passes in (pa->pa_pstart - 1) with a
comment, "-1 is to protect from crossing allocation group".

This makes sense for the group_pa, where pa_pstart is advanced
by the length which has been used (in ext4_mb_release_context()),
and when the entire length has been used, pa_pstart has been
advanced to the first block of the next group.

However, for inode_pa, pa_pstart is never advanced; it's just
set once to the first block in the group and not moved after
that.  So in this case, if we subtract one in ext4_mb_put_pa(),
we are actually locking the *previous* group, and opening the
race with the other threads which do not subtract off the extra
block.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry-picked from commit d33a1976fbee1ee321d6f014333d8f03a39d526c)
---
 fs/ext4/mballoc.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ceb68db..f34dada 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3698,6 +3698,7 @@ static void ext4_mb_put_pa(struct ext4_allocation_context *ac,
 			struct super_block *sb, struct ext4_prealloc_space *pa)
 {
 	unsigned long grp;
+	ext4_fsblk_t grp_blk;
 
 	if (!atomic_dec_and_test(&pa->pa_count) || pa->pa_free != 0)
 		return;
@@ -3712,8 +3713,12 @@ static void ext4_mb_put_pa(struct ext4_allocation_context *ac,
 	pa->pa_deleted = 1;
 	spin_unlock(&pa->pa_lock);
 
-	/* -1 is to protect from crossing allocation group */
-	ext4_get_group_no_and_offset(sb, pa->pa_pstart - 1, &grp, NULL);
+	grp_blk = pa->pa_pstart;
+	/* If linear, pa_pstart may be in the next group when pa is used up */
+	if (pa->pa_linear)
+		grp_blk--;
+
+	ext4_get_group_no_and_offset(sb, grp_blk, &grp, NULL);
 
 	/*
 	 * possible race:
-- 
1.6.3.1.1.g75fc.dirty

