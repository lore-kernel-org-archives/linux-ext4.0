From: zwu.kernel@gmail.com
Subject: [RFC v3 01/13] btrfs: add one new mount option '-o hot_track'
Date: Wed, 10 Oct 2012 18:07:23 +0800
Message-ID: <1349863655-29320-2-git-send-email-zwu.kernel@gmail.com>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, dave@jikos.cz,
	tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
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
 fs/btrfs/super.c |    7 ++++++-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9821b67..094bec6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1726,6 +1726,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_CHECK_INTEGRITY	(1 << 20)
 #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
 #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
+#define BTRFS_MOUNT_HOT_TRACK		(1 << 23)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 83d6f9f..00be9e3 100644
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
@@ -303,7 +304,7 @@ enum {
 	Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_discard,
 	Opt_space_cache, Opt_clear_cache, Opt_user_subvol_rm_allowed,
 	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag, Opt_inode_cache,
-	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
+	Opt_no_space_cache, Opt_recovery, Opt_skip_balance, Opt_hot_track,
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
 	Opt_check_integrity_print_mask, Opt_fatal_errors,
 	Opt_err,
@@ -342,6 +343,7 @@ static match_table_t tokens = {
 	{Opt_no_space_cache, "nospace_cache"},
 	{Opt_recovery, "recovery"},
 	{Opt_skip_balance, "skip_balance"},
+	{Opt_hot_track, "hot_track"},
 	{Opt_check_integrity, "check_int"},
 	{Opt_check_integrity_including_extent_data, "check_int_data"},
 	{Opt_check_integrity_print_mask, "check_int_print_mask=%d"},
@@ -553,6 +555,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_skip_balance:
 			btrfs_set_opt(info->mount_opt, SKIP_BALANCE);
 			break;
+		case Opt_hot_track:
+			btrfs_set_opt(info->mount_opt, HOT_TRACK);
+			break;
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 		case Opt_check_integrity_including_extent_data:
 			printk(KERN_INFO "btrfs: enabling check integrity"
-- 
1.7.6.5
