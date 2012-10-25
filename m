From: zwu.kernel@gmail.com
Subject: [RFC v4 13/15] btrfs: add hot tracking support
Date: Thu, 25 Oct 2012 23:09:05 +0800
Message-ID: <1351177747-19389-14-git-send-email-zwu.kernel@gmail.com>
References: <1351177747-19389-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, tytso@mit.edu,
	cmm@us.ibm.com, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351177747-19389-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Introduce one new mount option '-o hot_track',
and add its parsing support.
  Its usage looks like:
   mount -o hot_track
   mount -o nouser,hot_track
   mount -o nouser,hot_track,loop
   mount -o hot_track,nouser

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/btrfs/ctree.h |    1 +
 fs/btrfs/super.c |   22 +++++++++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 926c9ff..c3d28f0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1756,6 +1756,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_CHECK_INTEGRITY	(1 << 20)
 #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
 #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
+#define BTRFS_MOUNT_HOT_TRACK		(1 << 23)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 915ac14..0bcc62b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -41,6 +41,7 @@
 #include <linux/slab.h>
 #include <linux/cleancache.h>
 #include <linux/ratelimit.h>
+#include <linux/hot_tracking.h>
 #include "compat.h"
 #include "delayed-inode.h"
 #include "ctree.h"
@@ -299,6 +300,10 @@ static void btrfs_put_super(struct super_block *sb)
 	 * last process that kept it busy.  Or segfault in the aforementioned
 	 * process...  Whom would you report that to?
 	 */
+
+	/* Hot data tracking */
+	if (btrfs_test_opt(btrfs_sb(sb)->tree_root, HOT_TRACK))
+		hot_track_exit(sb);
 }
 
 enum {
@@ -311,7 +316,7 @@ enum {
 	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag, Opt_inode_cache,
 	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
-	Opt_check_integrity_print_mask, Opt_fatal_errors,
+	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_hot_track,
 	Opt_err,
 };
 
@@ -352,6 +357,7 @@ static match_table_t tokens = {
 	{Opt_check_integrity_including_extent_data, "check_int_data"},
 	{Opt_check_integrity_print_mask, "check_int_print_mask=%d"},
 	{Opt_fatal_errors, "fatal_errors=%s"},
+	{Opt_hot_track, "hot_track"},
 	{Opt_err, NULL},
 };
 
@@ -614,6 +620,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				goto out;
 			}
 			break;
+		case Opt_hot_track:
+			btrfs_set_opt(info->mount_opt, HOT_TRACK);
+			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
 			       "'%s'\n", p);
@@ -841,11 +850,20 @@ static int btrfs_fill_super(struct super_block *sb,
 		goto fail_close;
 	}
 
+	if (btrfs_test_opt(fs_info->tree_root, HOT_TRACK)) {
+		err = hot_track_init(sb);
+		if (err)
+			goto fail_hot;
+	}
+
 	save_mount_options(sb, data);
 	cleancache_init_fs(sb);
 	sb->s_flags |= MS_ACTIVE;
 	return 0;
 
+fail_hot:
+	dput(sb->s_root);
+	sb->s_root = NULL;
 fail_close:
 	close_ctree(fs_info->tree_root);
 	return err;
@@ -941,6 +959,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",skip_balance");
 	if (btrfs_test_opt(root, PANIC_ON_FATAL_ERROR))
 		seq_puts(seq, ",fatal_errors=panic");
+	if (btrfs_test_opt(root, HOT_TRACK))
+		seq_puts(seq, ",hot_track");
 	return 0;
 }
 
-- 
1.7.6.5
