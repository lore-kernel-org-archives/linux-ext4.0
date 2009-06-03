From: Denis Karpov <ext-denis.2.karpov@nokia.com>
Subject: [PATCH 4/4] EXT2: add 'notify' mount option
Date: Wed,  3 Jun 2009 18:05:18 +0300
Message-ID: <60607de38c1ebbd1ba1cb33d85f1dcdec77f3c61.1244049681.git.ext-denis.2.karpov@nokia.com>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com>
 <e7005f79dd6b8f25fef78ddbfedcef54f6b40bd5.1244049680.git.ext-denis.2.karpov@nokia.com>
 <c3bf79be4fd40b767a94d915e0f7e0cdc8f4cc92.1244049681.git.ext-denis.2.karpov@nokia.com>
 <22541fc77e43d85acb74cecebdac7523de5cfd72.1244049681.git.ext-denis.2.karpov@nokia.com>
Cc: akpm@linux-foundation.org, hirofumi@mail.parknet.co.jp,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, adrian.hunter@nokia.com,
	artem.bityutskiy@nokia.com
To: axboe@kernel.dk
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <22541fc77e43d85acb74cecebdac7523de5cfd72.1244049681.git.ext-denis.2.karpov@nokia.com>
In-Reply-To: <e7005f79dd6b8f25fef78ddbfedcef54f6b40bd5.1244049680.git.ext-denis.2.karpov@nokia.com>
References: <e7005f79dd6b8f25fef78ddbfedcef54f6b40bd5.1244049680.git.ext-denis.2.karpov@nokia.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Implement EXT2 fs mount option 'notify'. The effect of this option
is that a notification is sent to userspace on errors that indicate
filesystem damage/inconsistency. Generic filesystem corruption
notification mechnism is used.

Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
---
 fs/ext2/super.c         |   15 ++++++++++++++-
 include/linux/ext2_fs.h |    2 +-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 5c4afe6..04802cd 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -32,6 +32,7 @@
 #include <linux/mount.h>
 #include <linux/log2.h>
 #include <linux/quotaops.h>
+#include <linux/genhd.h>
 #include <asm/uaccess.h>
 #include "ext2.h"
 #include "xattr.h"
@@ -68,6 +69,8 @@ void ext2_error (struct super_block * sb, const char * function,
 		printk("Remounting filesystem read-only\n");
 		sb->s_flags |= MS_RDONLY;
 	}
+	if (test_opt(sb, ERR_NOTIFY))
+		notify_part_fs_unclean(part_to_dev(sb->s_bdev->bd_part), 1);
 }
 
 void ext2_warning (struct super_block * sb, const char * function,
@@ -81,6 +84,8 @@ void ext2_warning (struct super_block * sb, const char * function,
 	vprintk(fmt, args);
 	printk("\n");
 	va_end(args);
+	if (test_opt(sb, ERR_NOTIFY))
+		notify_part_fs_unclean(part_to_dev(sb->s_bdev->bd_part), 1);
 }
 
 void ext2_update_dynamic_rev(struct super_block *sb)
@@ -289,6 +294,9 @@ static int ext2_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (!test_opt(sb, RESERVATION))
 		seq_puts(seq, ",noreservation");
 
+	if (!test_opt(sb, ERR_NOTIFY))
+		seq_puts(seq, ",notify");
+
 	return 0;
 }
 
@@ -391,7 +399,8 @@ enum {
 	Opt_err_ro, Opt_nouid32, Opt_nocheck, Opt_debug,
 	Opt_oldalloc, Opt_orlov, Opt_nobh, Opt_user_xattr, Opt_nouser_xattr,
 	Opt_acl, Opt_noacl, Opt_xip, Opt_ignore, Opt_err, Opt_quota,
-	Opt_usrquota, Opt_grpquota, Opt_reservation, Opt_noreservation
+	Opt_usrquota, Opt_grpquota, Opt_reservation, Opt_noreservation,
+	Opt_err_notify,
 };
 
 static const match_table_t tokens = {
@@ -425,6 +434,7 @@ static const match_table_t tokens = {
 	{Opt_usrquota, "usrquota"},
 	{Opt_reservation, "reservation"},
 	{Opt_noreservation, "noreservation"},
+	{Opt_err_notify, "notify"},
 	{Opt_err, NULL}
 };
 
@@ -565,6 +575,9 @@ static int parse_options (char * options,
 			clear_opt(sbi->s_mount_opt, RESERVATION);
 			printk("reservations OFF\n");
 			break;
+		case Opt_err_notify:
+			set_opt(sbi->s_mount_opt, ERR_NOTIFY);
+			break;
 		case Opt_ignore:
 			break;
 		default:
diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index 121720d..ecec20b 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -347,7 +347,7 @@ struct ext2_inode {
 #define EXT2_MOUNT_USRQUOTA		0x020000  /* user quota */
 #define EXT2_MOUNT_GRPQUOTA		0x040000  /* group quota */
 #define EXT2_MOUNT_RESERVATION		0x080000  /* Preallocation */
-
+#define EXT2_MOUNT_ERR_NOTIFY		0x100000  /* Error notifications */
 
 #define clear_opt(o, opt)		o &= ~EXT2_MOUNT_##opt
 #define set_opt(o, opt)			o |= EXT2_MOUNT_##opt
-- 
1.6.3.1

