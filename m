From: David Howells <dhowells@redhat.com>
Subject: [PATCH 23/59] CRED: Wrap task credential accesses in the Ext2
	filesystem
Date: Wed, 27 Aug 2008 14:47:40 +0100
Message-ID: <20080827134740.19980.64489.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-security-module@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Serge Hallyn <serue@us.ibm.com>, linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Wrap access to task credentials so that they can be separated more easily from
the task_struct during the introduction of COW creds.

Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these will be
addressed by later patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: linux-ext4@vger.kernel.org
---

 fs/ext2/balloc.c |    2 +-
 fs/ext2/ialloc.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 10bb02c..8c59a60 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -1193,7 +1193,7 @@ static int ext2_has_free_blocks(struct ext2_sb_info *sbi)
 	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
 	root_blocks = le32_to_cpu(sbi->s_es->s_r_blocks_count);
 	if (free_blocks < root_blocks + 1 && !capable(CAP_SYS_RESOURCE) &&
-		sbi->s_resuid != current->fsuid &&
+		sbi->s_resuid != current_fsuid() &&
 		(sbi->s_resgid == 0 || !in_group_p (sbi->s_resgid))) {
 		return 0;
 	}
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index f597413..8d0add6 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -550,7 +550,7 @@ got:
 
 	sb->s_dirt = 1;
 	mark_buffer_dirty(bh2);
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current_fsuid();
 	if (test_opt (sb, GRPID))
 		inode->i_gid = dir->i_gid;
 	else if (dir->i_mode & S_ISGID) {
@@ -558,7 +558,7 @@ got:
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else
-		inode->i_gid = current->fsgid;
+		inode->i_gid = current_fsgid();
 	inode->i_mode = mode;
 
 	inode->i_ino = ino;

