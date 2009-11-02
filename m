From: Jan Blunck <jblunck@suse.de>
Subject: [PATCH 08/27] BKL: Remove BKL from ext4 filesystem
Date: Mon,  2 Nov 2009 11:04:48 +0100
Message-ID: <1257156307-24175-9-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
	Jan Blunck <jblunck@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@sun.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The BKL is still used in ext4_put_super(), ext4_fill_super() and
ext4_remount(). All three calles are protected against concurrent calls by
the s_umount rw semaphore of struct super_block.

Therefore the BKL is protecting nothing in this case.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/ext4/super.c |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9db81d2..328e9dc 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -26,7 +26,6 @@
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/parser.h>
-#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/exportfs.h>
 #include <linux/vfs.h>
@@ -599,7 +598,6 @@ static void ext4_put_super(struct super_block *sb)
 	destroy_workqueue(sbi->dio_unwritten_wq);
 
 	lock_super(sb);
-	lock_kernel();
 	if (sb->s_dirt)
 		ext4_commit_super(sb, 1);
 
@@ -665,7 +663,6 @@ static void ext4_put_super(struct super_block *sb)
 	 * Now that we are completely done shutting down the
 	 * superblock, we need to actually destroy the kobject.
 	 */
-	unlock_kernel();
 	unlock_super(sb);
 	kobject_put(&sbi->s_kobj);
 	wait_for_completion(&sbi->s_kobj_unregister);
@@ -2328,19 +2325,14 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	int err;
 	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
 
-	lock_kernel();
-
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
-	if (!sbi) {
-		unlock_kernel();
+	if (!sbi)
 		return -ENOMEM;
-	}
 
 	sbi->s_blockgroup_lock =
 		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
 	if (!sbi->s_blockgroup_lock) {
 		kfree(sbi);
-		unlock_kernel();
 		return -ENOMEM;
 	}
 	sb->s_fs_info = sbi;
@@ -2352,8 +2344,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_sectors_written_start = part_stat_read(sb->s_bdev->bd_part,
 						      sectors[1]);
 
-	unlock_kernel();
-
 	/* Cleanup superblock name */
 	for (cp = sb->s_id; (cp = strchr(cp, '/'));)
 		*cp = '!';
@@ -3456,8 +3446,6 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	int i;
 #endif
 
-	lock_kernel();
-
 	/* Store the original options */
 	lock_super(sb);
 	old_sb_flags = sb->s_flags;
@@ -3587,7 +3575,6 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 			kfree(old_opts.s_qf_names[i]);
 #endif
 	unlock_super(sb);
-	unlock_kernel();
 	return 0;
 
 restore_opts:
@@ -3608,7 +3595,6 @@ restore_opts:
 	}
 #endif
 	unlock_super(sb);
-	unlock_kernel();
 	return err;
 }
 
-- 
1.6.4.2

