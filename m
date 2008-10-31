From: David Howells <dhowells@redhat.com>
Subject: Wrapping Ext4 credential accesses
Date: Fri, 31 Oct 2008 10:47:16 +0000
Message-ID: <11242.1225450036@redhat.com>
Cc: dhowells@redhat.com, adilger@sun.com, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55924 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbYJaKrk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 Oct 2008 06:47:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi Ted,

Can you add the attached patch into the ext4 tree please?  It wraps credential
accesses (current->fsuid -> current_fsuid() for example) so that moving to a
detached cred structure is easier.  The prerequisite patch has been upstream
for a while.  Hopefully we can get Linus to take the rest of the patches in
the next merge window.

This'll make it easier for Stephen Rothwell to maintain linux-next.

Thanks,
David
---
From: David Howells <dhowells@redhat.com>

CRED: Wrap task credential accesses in the Ext4 filesystem

Wrap access to task credentials so that they can be separated more easily from
the task_struct during the introduction of COW creds.

Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these will be
addressed by later patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Stephen Tweedie <sct@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: adilger@sun.com
Cc: linux-ext4@vger.kernel.org
---

 fs/ext4/balloc.c |    5 ++---
 fs/ext4/ialloc.c |    4 ++--
 2 files changed, 4 insertions(+), 5 deletions(-)


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index b9821be..5ede818 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -601,7 +601,7 @@ int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
 	dirty_blocks = percpu_counter_read_positive(dbc);
 
 	if (!capable(CAP_SYS_RESOURCE) &&
-		sbi->s_resuid != current->fsuid &&
+		sbi->s_resuid != current_fsuid() &&
 		(sbi->s_resgid == 0 || !in_group_p(sbi->s_resgid)))
 		root_blocks = ext4_r_blocks_count(sbi->s_es);
 
@@ -648,7 +648,7 @@ ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
 	dirty_blocks = percpu_counter_read_positive(dbc);
 
 	if (!capable(CAP_SYS_RESOURCE) &&
-		sbi->s_resuid != current->fsuid &&
+		sbi->s_resuid != current_fsuid() &&
 		(sbi->s_resgid == 0 || !in_group_p(sbi->s_resgid)))
 		root_blocks = ext4_r_blocks_count(sbi->s_es);
 
@@ -666,7 +666,6 @@ ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
 	return nblocks;
 }
 
-
 /**
  * ext4_should_retry_alloc()
  * @sb:			super block
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index fe34d74..c8ea50e 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -785,7 +785,7 @@ got:
 		spin_unlock(sb_bgl_lock(sbi, flex_group));
 	}
 
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current_fsuid();
 	if (test_opt(sb, GRPID))
 		inode->i_gid = dir->i_gid;
 	else if (dir->i_mode & S_ISGID) {
@@ -793,7 +793,7 @@ got:
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else
-		inode->i_gid = current->fsgid;
+		inode->i_gid = current_fsgid();
 	inode->i_mode = mode;
 
 	inode->i_ino = ino + group * EXT4_INODES_PER_GROUP(sb);
