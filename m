From: David Howells <dhowells@redhat.com>
Subject: [PATCH 25/59] CRED: Wrap task credential accesses in the Ext4
	filesystem
Date: Wed, 27 Aug 2008 14:47:51 +0100
Message-ID: <20080827134751.19980.21808.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-security-module@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Serge Hallyn <serue@us.ibm.com>,
	Stephen Tweedie <sct@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758031AbYH0NzG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Aug 2008 09:55:06 -0400
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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

 fs/ext4/balloc.c |    3 +--
 fs/ext4/ialloc.c |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index e9fa960..448cd59 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1618,7 +1618,7 @@ ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
 	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
 
 	if (!capable(CAP_SYS_RESOURCE) &&
-		sbi->s_resuid != current->fsuid &&
+		sbi->s_resuid != current_fsuid() &&
 		(sbi->s_resgid == 0 || !in_group_p(sbi->s_resgid)))
 		root_blocks = ext4_r_blocks_count(sbi->s_es);
 #ifdef CONFIG_SMP
@@ -1634,7 +1634,6 @@ ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
 	return nblocks;
  }
 
-
 /**
  * ext4_should_retry_alloc()
  * @sb:			super block
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index f344834..97ed523 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -782,7 +782,7 @@ got:
 		spin_unlock(sb_bgl_lock(sbi, flex_group));
 	}
 
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current_fsuid();
 	if (test_opt (sb, GRPID))
 		inode->i_gid = dir->i_gid;
 	else if (dir->i_mode & S_ISGID) {
@@ -790,7 +790,7 @@ got:
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else
-		inode->i_gid = current->fsgid;
+		inode->i_gid = current_fsgid();
 	inode->i_mode = mode;
 
 	inode->i_ino = ino + group * EXT4_INODES_PER_GROUP(sb);

