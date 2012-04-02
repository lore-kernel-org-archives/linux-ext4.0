From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH v2 3/4] ext4: remove unnecessary superblock dirtying
Date: Mon,  2 Apr 2012 14:45:39 +0300
Message-ID: <1333367140-28370-5-git-send-email-artem.bityutskiy@linux.intel.com>
References: <1333367140-28370-1-git-send-email-artem.bityutskiy@linux.intel.com>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1333367140-28370-1-git-send-email-artem.bityutskiy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

This patch changes the '__ext4_handle_dirty_super()' function which is used
by ext4 to update the super-block via the journal in the following cases:

1. When creating the first large file on a file
   system without EXT4_FEATURE_RO_COMPAT_LARGE_FILE feature.
2. When re-sizing the file-system
3. When creating an xattr on a file-system without the
   EXT4_FEATURE_COMPAT_EXT_ATTR feature.

This function, however, falls back to just marking the superblock as dirty
if the file-system has no journal. But it is user really rarely and it does not
give any benefit to use the delayed superblock write (via the VFS's
'sync_supers()' kernel thread) in these cases. We can just write out the
superblock asynchronously instead.

This patch also removes 's_dirt' condition on the unmount path because we never
set it anymore, so we should not test it.

Tested using xfstests for both journalled and non-journalled ext4.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ext4/ext4.h      |    1 +
 fs/ext4/ext4_jbd2.c |    2 +-
 fs/ext4/super.c     |    5 ++---
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index aba3749..ba2cf3f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1953,6 +1953,7 @@ extern int ext4_group_extend(struct super_block *sb,
 extern int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count);
 
 /* super.c */
+int ext4_commit_super(struct super_block *sb, int sync);
 extern void *ext4_kvmalloc(size_t size, gfp_t flags);
 extern void *ext4_kvzalloc(size_t size, gfp_t flags);
 extern void ext4_kvfree(void *ptr);
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index aca1790..a85f46f 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -149,6 +149,6 @@ int __ext4_handle_dirty_super(const char *where, unsigned int line,
 			ext4_journal_abort_handle(where, line, __func__,
 						  bh, handle, err);
 	} else
-		sb->s_dirt = 1;
+		err = ext4_commit_super(sb, 0);
 	return err;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ceebaf8..6b45785 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -63,7 +63,6 @@ static struct ext4_features *ext4_feat;
 static int ext4_load_journal(struct super_block *, struct ext4_super_block *,
 			     unsigned long journal_devnum);
 static int ext4_show_options(struct seq_file *seq, struct dentry *root);
-static int ext4_commit_super(struct super_block *sb, int sync);
 static void ext4_mark_recovery_complete(struct super_block *sb,
 					struct ext4_super_block *es);
 static void ext4_clear_journal_err(struct super_block *sb,
@@ -853,7 +852,7 @@ static void ext4_put_super(struct super_block *sb)
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
 	}
-	if (sb->s_dirt || !(sb->s_flags & MS_RDONLY))
+	if (!(sb->s_flags & MS_RDONLY))
 		ext4_commit_super(sb, 1);
 
 	if (sbi->s_proc) {
@@ -3991,7 +3990,7 @@ static int ext4_load_journal(struct super_block *sb,
 	return 0;
 }
 
-static int ext4_commit_super(struct super_block *sb, int sync)
+int ext4_commit_super(struct super_block *sb, int sync)
 {
 	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
 	struct buffer_head *sbh = EXT4_SB(sb)->s_sbh;
-- 
1.7.7.6
