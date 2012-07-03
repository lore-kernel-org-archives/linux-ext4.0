From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: [PATCHv3 3/4] ext4: remove unnecessary superblock dirtying
Date: Tue,  3 Jul 2012 15:00:09 +0300
Message-ID: <1341316810-22598-4-git-send-email-dedekind1@gmail.com>
References: <1341316810-22598-1-git-send-email-dedekind1@gmail.com>
Cc: Jan Kara <jack@suse.cz>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1341316810-22598-1-git-send-email-dedekind1@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
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
index 0c4042e..b2439d5 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2041,6 +2041,7 @@ extern int ext4_superblock_csum_verify(struct super_block *sb,
 				       struct ext4_super_block *es);
 extern void ext4_superblock_csum_set(struct super_block *sb,
 				     struct ext4_super_block *es);
+extern int ext4_commit_super(struct super_block *sb, int sync);
 extern void *ext4_kvmalloc(size_t size, gfp_t flags);
 extern void *ext4_kvzalloc(size_t size, gfp_t flags);
 extern void ext4_kvfree(void *ptr);
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 90f7c2e..27354df 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -156,6 +156,6 @@ int __ext4_handle_dirty_super(const char *where, unsigned int line,
 				(struct ext4_super_block *)bh->b_data);
 		mark_buffer_dirty(bh);
 	} else
-		sb->s_dirt = 1;
+		err = ext4_commit_super(sb, 0);
 	return err;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index eb7aa3e..9b26ba0 100644
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
@@ -896,7 +895,7 @@ static void ext4_put_super(struct super_block *sb)
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
 	}
-	if (sb->s_dirt || !(sb->s_flags & MS_RDONLY))
+	if (!(sb->s_flags & MS_RDONLY))
 		ext4_commit_super(sb, 1);
 
 	if (sbi->s_proc) {
@@ -4155,7 +4154,7 @@ static int ext4_load_journal(struct super_block *sb,
 	return 0;
 }
 
-static int ext4_commit_super(struct super_block *sb, int sync)
+int ext4_commit_super(struct super_block *sb, int sync)
 {
 	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
 	struct buffer_head *sbh = EXT4_SB(sb)->s_sbh;
-- 
1.7.7.6

