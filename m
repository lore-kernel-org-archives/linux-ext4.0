From: Joe Perches <joe@perches.com>
Subject: [PATCH] fs/ext2/super.c: Use printf extension %pV
Date: Tue, 09 Nov 2010 10:16:03 -0800
Message-ID: <1289326563.1823.85.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Using %pV reduces the number of printk calls and
eliminates any possible message interleaving from
other printk calls.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ext2/super.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index d89e0b6..27822b9 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -43,9 +43,10 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data);
 static int ext2_statfs (struct dentry * dentry, struct kstatfs * buf);
 static int ext2_sync_fs(struct super_block *sb, int wait);
 
-void ext2_error (struct super_block * sb, const char * function,
-		 const char * fmt, ...)
+void ext2_error(struct super_block *sb, const char *function,
+		const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 	struct ext2_super_block *es = sbi->s_es;
@@ -59,9 +60,13 @@ void ext2_error (struct super_block * sb, const char * function,
 	}
 
 	va_start(args, fmt);
-	printk(KERN_CRIT "EXT2-fs (%s): error: %s: ", sb->s_id, function);
-	vprintk(fmt, args);
-	printk("\n");
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk(KERN_CRIT "EXT2-fs (%s): error: %s: %pV\n",
+	       sb->s_id, function, &vaf);
+
 	va_end(args);
 
 	if (test_opt(sb, ERRORS_PANIC))
@@ -76,12 +81,16 @@ void ext2_error (struct super_block * sb, const char * function,
 void ext2_msg(struct super_block *sb, const char *prefix,
 		const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
 	va_start(args, fmt);
-	printk("%sEXT2-fs (%s): ", prefix, sb->s_id);
-	vprintk(fmt, args);
-	printk("\n");
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk("%sEXT2-fs (%s): %pV\n", prefix, sb->s_id, &vaf);
+
 	va_end(args);
 }
 
