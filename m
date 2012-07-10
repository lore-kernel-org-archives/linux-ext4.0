From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: [PATCHv5 4/4] ext4: weed out ext4_write_super
Date: Tue, 10 Jul 2012 15:17:53 +0300
Message-ID: <1341922673-14147-5-git-send-email-dedekind1@gmail.com>
References: <1341922673-14147-1-git-send-email-dedekind1@gmail.com>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1341922673-14147-1-git-send-email-dedekind1@gmail.com>
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
index 9b26ba0..546c6ed 100644
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
@@ -1193,7 +1192,6 @@ static const struct super_operations ext4_nojournal_sops = {
 	.dirty_inode	= ext4_dirty_inode,
 	.drop_inode	= ext4_drop_inode,
 	.evict_inode	= ext4_evict_inode,
-	.write_super	= ext4_write_super,
 	.put_super	= ext4_put_super,
 	.statfs		= ext4_statfs,
 	.remount_fs	= ext4_remount,
@@ -4202,7 +4200,6 @@ int ext4_commit_super(struct super_block *sb, int sync)
 	es->s_free_inodes_count =
 		cpu_to_le32(percpu_counter_sum_positive(
 				&EXT4_SB(sb)->s_freeinodes_counter));
-	sb->s_dirt = 0;
 	BUFFER_TRACE(sbh, "marking dirty");
 	ext4_superblock_csum_set(sb, es);
 	mark_buffer_dirty(sbh);
@@ -4309,13 +4306,6 @@ int ext4_force_commit(struct super_block *sb)
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
