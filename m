From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: [PATCHv5 3/4] ext4: remove unnecessary superblock dirtying
Date: Tue, 10 Jul 2012 15:17:52 +0300
Message-ID: <1341922673-14147-4-git-send-email-dedekind1@gmail.com>
References: <1341922673-14147-1-git-send-email-dedekind1@gmail.com>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:38748 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775Ab2GJMQW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jul 2012 08:16:22 -0400
In-Reply-To: <1341922673-14147-1-git-send-email-dedekind1@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

This patch changes the '__ext4_handle_dirty_super()' function which is used
by ext4 to update the superblock via the journal in the following cases:

1. When creating the first large file on a file system without
   EXT4_FEATURE_RO_COMPAT_LARGE_FILE feature.
2. When re-sizing the file-system.
3. When creating an xattr on a file-system without the
   EXT4_FEATURE_COMPAT_EXT_ATTR feature.
4. When adding or deleting an orphan (because we update the 's_last_orphan'
   superblock field). This happens actually on every delete operation.

This function, however, falls back to just marking the superblock as dirty
if the file-system has no journal. This means that we delay the actual
superblock I/O submission by 5 seconds (roughly speaking). Namely, the
'sync_supers()' kernel thread will call 'ext4_write_super()' later, where
we actually will submit the superblock down to the media.

However:
1. For cases 1-3 it does not add any value to delay the I/O submission. These
   events are rare and we may just commit submit the superblock for
   asynchronous I/O right away.
2. But case N4 is a bit less obvious.
   a) If checksumming is disabled, then it is probably all-right to just mark
      the superblock buffer as dirty right away.
   b) If checksumming is enabled, then we'll end up doing more work on deletion
      because we'll end up with re-calculating checksum on every deletion.
      But I think that the right way to solve this issue is to calculate
      checksum at the time when the buffer is actually sent to the I/O queue.
      If the checksum is a function of the buffer plus some seed data, we
      should be able to implement some kind of call-back which will be called
      for the buffer just before it is sent to the I/O queue.

      So it looks like my change in the b) case is exposing an existing flaw,
      not introducing a new one. And this is why I think it is OK.

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

