From: Denis Karpov <ext-denis.2.karpov@nokia.com>
Subject: [PATCH 3/4] FAT: add 'notify' mount option
Date: Wed,  3 Jun 2009 18:05:17 +0300
Message-ID: <22541fc77e43d85acb74cecebdac7523de5cfd72.1244049681.git.ext-denis.2.karpov@nokia.com>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com>
 <e7005f79dd6b8f25fef78ddbfedcef54f6b40bd5.1244049680.git.ext-denis.2.karpov@nokia.com>
 <c3bf79be4fd40b767a94d915e0f7e0cdc8f4cc92.1244049681.git.ext-denis.2.karpov@nokia.com>
Cc: akpm@linux-foundation.org, hirofumi@mail.parknet.co.jp,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, adrian.hunter@nokia.com,
	artem.bityutskiy@nokia.com
To: axboe@kernel.dk
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:60095 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbZFCPFq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Jun 2009 11:05:46 -0400
In-Reply-To: <c3bf79be4fd40b767a94d915e0f7e0cdc8f4cc92.1244049681.git.ext-denis.2.karpov@nokia.com>
In-Reply-To: <e7005f79dd6b8f25fef78ddbfedcef54f6b40bd5.1244049680.git.ext-denis.2.karpov@nokia.com>
References: <e7005f79dd6b8f25fef78ddbfedcef54f6b40bd5.1244049680.git.ext-denis.2.karpov@nokia.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Implement FAT fs mount option 'notify'. The effect of this option
is that a notification is sent to userspace on errors that indicate
filesystem damage/inconsistency. Generic filesystem corruption
notification mechnism is used.

Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
---
 fs/fat/fat.h   |    3 ++-
 fs/fat/inode.c |    9 ++++++++-
 fs/fat/misc.c  |    7 +++++++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index a811ac0..4b7a394 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -39,7 +39,8 @@ struct fat_mount_options {
 		 nocase:1,	  /* Does this need case conversion? 0=need case conversion*/
 		 usefree:1,	  /* Use free_clusters for FAT32 */
 		 tz_utc:1,	  /* Filesystem timestamps are in UTC */
-		 rodir:1;	  /* allow ATTR_RO for directory */
+		 rodir:1,	  /* allow ATTR_RO for directory */
+		 err_notify:1;	  /* Notify userspace on fs errors */
 };
 
 #define FAT_HASH_BITS	8
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 2762145..cc299fc 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -835,6 +835,8 @@ static int fat_show_options(struct seq_file *m, struct vfsmount *mnt)
 		seq_puts(m, ",flush");
 	if (opts->tz_utc)
 		seq_puts(m, ",tz=UTC");
+	if (opts->err_notify)
+		seq_puts(m, ",notify");
 
 	return 0;
 }
@@ -847,7 +849,7 @@ enum {
 	Opt_charset, Opt_shortname_lower, Opt_shortname_win95,
 	Opt_shortname_winnt, Opt_shortname_mixed, Opt_utf8_no, Opt_utf8_yes,
 	Opt_uni_xl_no, Opt_uni_xl_yes, Opt_nonumtail_no, Opt_nonumtail_yes,
-	Opt_obsolate, Opt_flush, Opt_tz_utc, Opt_rodir, Opt_err,
+	Opt_obsolate, Opt_flush, Opt_tz_utc, Opt_rodir, Opt_err_notify, Opt_err,
 };
 
 static const match_table_t fat_tokens = {
@@ -883,6 +885,7 @@ static const match_table_t fat_tokens = {
 	{Opt_obsolate, "posix"},
 	{Opt_flush, "flush"},
 	{Opt_tz_utc, "tz=UTC"},
+	{Opt_err_notify, "notify"},
 	{Opt_err, NULL},
 };
 static const match_table_t msdos_tokens = {
@@ -952,6 +955,7 @@ static int parse_options(char *options, int is_vfat, int silent, int *debug,
 	opts->numtail = 1;
 	opts->usefree = opts->nocase = 0;
 	opts->tz_utc = 0;
+	opts->err_notify = 0;
 	*debug = 0;
 
 	if (!options)
@@ -1044,6 +1048,9 @@ static int parse_options(char *options, int is_vfat, int silent, int *debug,
 		case Opt_tz_utc:
 			opts->tz_utc = 1;
 			break;
+		case Opt_err_notify:
+			opts->err_notify = 1;
+			break;
 
 		/* msdos specific */
 		case Opt_dots:
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index dca1b97..1d6ed41 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
+#include <linux/genhd.h>
 #include "fat.h"
 
 /*
@@ -20,6 +21,7 @@ void fat_fs_error(struct super_block *s, const char *function,
 		const char *fmt, ...)
 {
 	va_list args;
+	struct msdos_sb_info *sbi = MSDOS_SB(s);
 
 	printk(KERN_ERR "FAT: Filesystem error (dev %s): %s:\n", s->s_id,
 		function);
@@ -34,6 +36,8 @@ void fat_fs_error(struct super_block *s, const char *function,
 		s->s_flags |= MS_RDONLY;
 		printk(KERN_ERR "    File system has been set read-only\n");
 	}
+	if (sbi->options.err_notify)
+		notify_part_fs_unclean(part_to_dev(s->s_bdev->bd_part), 1);
 }
 EXPORT_SYMBOL_GPL(fat_fs_error);
 
@@ -45,6 +49,7 @@ void fat_fs_warning(struct super_block *s, const char * function,
 		const char *fmt, ...)
 {
 	va_list args;
+	struct msdos_sb_info *sbi = MSDOS_SB(s);
 
 	printk(KERN_ERR "FAT: Filesystem warning (dev %s): %s:\n", s->s_id,
 		function);
@@ -54,6 +59,8 @@ void fat_fs_warning(struct super_block *s, const char * function,
 	vprintk(fmt, args);
 	printk("\n");
 	va_end(args);
+	if (sbi->options.err_notify)
+		notify_part_fs_unclean(part_to_dev(s->s_bdev->bd_part), 1);
 }
 EXPORT_SYMBOL_GPL(fat_fs_warning);
 
-- 
1.6.3.1

