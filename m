From: Jan Blunck <jblunck@suse.de>
Subject: [PATCH 7/7] BKL: Remove BKL from ext2 filesystem
Date: Wed, 14 Apr 2010 14:38:39 +0200
Message-ID: <1271248719-21488-8-git-send-email-jblunck@suse.de>
References: <1271248719-21488-1-git-send-email-jblunck@suse.de>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Jan Blunck <jblunck@suse.de>,
	Jan Kara <jack@suse.cz>
To: Jan Kara <jack@suse.cz>, tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1271248719-21488-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The BKL is still used in ext2_put_super(), ext2_fill_super(), ext2_sync_fs()
ext2_remount() and ext2_write_inode(). From these calls ext2_put_super(),
ext2_fill_super() and ext2_remount() are protected against each other by
the struct super_block s_umount rw semaphore. The call in ext2_write_inode()
could only protect the modification of the ext2_sb_info through
ext2_update_dynamic_rev() against concurrent ext2_sync_fs() or ext2_remount().
ext2_fill_super() and ext2_put_super() can be left out because you need a
valid filesystem reference in all three cases, which you do not have when
you are one of these functions.

If the BKL is only protecting the modification of the ext2_sb_info it can
safely be removed since this is protected by the struct ext2_sb_info s_lock.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c |    3 ---
 fs/ext2/super.c |   13 -------------
 2 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 5d15442..b90c3bf 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -22,7 +22,6 @@
  *  Assorted race fixes, rewrite of ext2_get_block() by Al Viro, 2000
  */
 
-#include <linux/smp_lock.h>
 #include <linux/time.h>
 #include <linux/highuid.h>
 #include <linux/pagemap.h>
@@ -1406,13 +1405,11 @@ static int __ext2_write_inode(struct inode *inode, int do_sync)
 			       /* If this is the first large file
 				* created, add a flag to the superblock.
 				*/
-				lock_kernel();
 				spin_lock(&EXT2_SB(sb)->s_lock);
 				ext2_update_dynamic_rev(sb);
 				EXT2_SET_RO_COMPAT_FEATURE(sb,
 					EXT2_FEATURE_RO_COMPAT_LARGE_FILE);
 				spin_unlock(&EXT2_SB(sb)->s_lock);
-				unlock_kernel();
 				ext2_write_super(sb);
 			}
 		}
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 28f6560..71e9eb1 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -26,7 +26,6 @@
 #include <linux/random.h>
 #include <linux/buffer_head.h>
 #include <linux/exportfs.h>
-#include <linux/smp_lock.h>
 #include <linux/vfs.h>
 #include <linux/seq_file.h>
 #include <linux/mount.h>
@@ -120,8 +119,6 @@ static void ext2_put_super (struct super_block * sb)
 	int i;
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 
-	lock_kernel();
-
 	if (sb->s_dirt)
 		ext2_write_super(sb);
 
@@ -147,8 +144,6 @@ static void ext2_put_super (struct super_block * sb)
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
-
-	unlock_kernel();
 }
 
 static struct kmem_cache * ext2_inode_cachep;
@@ -1170,7 +1165,6 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 	struct ext2_super_block *es = EXT2_SB(sb)->s_es;
 
-	lock_kernel();
 	spin_lock(&sbi->s_lock);
 	if (es->s_state & cpu_to_le16(EXT2_VALID_FS)) {
 		ext2_debug("setting valid to 0\n");
@@ -1178,8 +1172,6 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
 	}
 	spin_unlock(&sbi->s_lock);
 	ext2_sync_super(sb, es, wait);
-	unlock_kernel();
-
 	return 0;
 }
 
@@ -1201,7 +1193,6 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 	unsigned long old_sb_flags;
 	int err;
 
-	lock_kernel();
 	spin_lock(&sbi->s_lock);
 
 	/* Store the old options */
@@ -1242,14 +1233,12 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 	}
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY)) {
 		spin_unlock(&sbi->s_lock);
-		unlock_kernel();
 		return 0;
 	}
 	if (*flags & MS_RDONLY) {
 		if (le16_to_cpu(es->s_state) & EXT2_VALID_FS ||
 		    !(sbi->s_mount_state & EXT2_VALID_FS)) {
 			spin_unlock(&sbi->s_lock);
-			unlock_kernel();
 			return 0;
 		}
 		/*
@@ -1282,7 +1271,6 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 		spin_unlock(&sbi->s_lock);
 		ext2_write_super(sb);
 	}
-	unlock_kernel();
 	return 0;
 restore_opts:
 	sbi->s_mount_opt = old_opts.s_mount_opt;
@@ -1290,7 +1278,6 @@ restore_opts:
 	sbi->s_resgid = old_opts.s_resgid;
 	sb->s_flags = old_sb_flags;
 	spin_unlock(&sbi->s_lock);
-	unlock_kernel();
 	return err;
 }
 
-- 
1.6.4.2
