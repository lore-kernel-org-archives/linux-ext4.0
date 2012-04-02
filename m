From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH v2 4/4] ext4: weed out ext4_write_super
Date: Mon,  2 Apr 2012 14:45:40 +0300
Message-ID: <1333367140-28370-6-git-send-email-artem.bityutskiy@linux.intel.com>
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

We do not depend on VFS's '->write_super()' anymore and do not need the
's_dirt' flag anymore. This patch weeds out 'ext4_write_super()' and the
's_dirt' usage in VFS.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ext4/super.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6b45785..0818eef 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -73,7 +73,6 @@ static const char *ext4_decode_error(struct super_block *sb, int errno,
 static int ext4_remount(struct super_block *sb, int *flags, char *data);
 static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf);
 static int ext4_unfreeze(struct super_block *sb);
-static void ext4_write_super(struct super_block *sb);
 static int ext4_freeze(struct super_block *sb);
 static struct dentry *ext4_mount(struct file_system_type *fs_type, int flags,
 		       const char *dev_name, void *data);
@@ -1148,7 +1147,6 @@ static const struct super_operations ext4_nojournal_sops = {
 	.dirty_inode	= ext4_dirty_inode,
 	.drop_inode	= ext4_drop_inode,
 	.evict_inode	= ext4_evict_inode,
-	.write_super	= ext4_write_super,
 	.put_super	= ext4_put_super,
 	.statfs		= ext4_statfs,
 	.remount_fs	= ext4_remount,
@@ -4038,7 +4036,6 @@ int ext4_commit_super(struct super_block *sb, int sync)
 	es->s_free_inodes_count =
 		cpu_to_le32(percpu_counter_sum_positive(
 				&EXT4_SB(sb)->s_freeinodes_counter));
-	sb->s_dirt = 0;
 	BUFFER_TRACE(sbh, "marking dirty");
 	mark_buffer_dirty(sbh);
 	if (sync) {
@@ -4144,13 +4141,6 @@ int ext4_force_commit(struct super_block *sb)
 	return ret;
 }
 
-static void ext4_write_super(struct super_block *sb)
-{
-	lock_super(sb);
-	ext4_commit_super(sb, 1);
-	unlock_super(sb);
-}
-
 static int ext4_sync_fs(struct super_block *sb, int wait)
 {
 	int ret = 0;
-- 
1.7.7.6
