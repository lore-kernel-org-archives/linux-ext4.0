From: Joe Perches <joe@perches.com>
Subject: [PATCH] fs/ext4/super.c: Use printf extension %pV
Date: Tue, 09 Nov 2010 10:01:16 -0800
Message-ID: <1289325676.1823.78.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:4748 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887Ab0KISBR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Nov 2010 13:01:17 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Using %pV reduces the number of printk calls and
eliminates any possible message interleaving from
other printk calls.

In function __ext4_grp_locked_error also added
KERN_CONT to some printks.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ext4/super.c |   51 ++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 40131b7..48ef60e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -388,13 +388,17 @@ static void ext4_handle_error(struct super_block *sb)
 void __ext4_error(struct super_block *sb, const char *function,
 		  unsigned int line, const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
 	va_start(args, fmt);
-	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: comm %s: ",
-	       sb->s_id, function, line, current->comm);
-	vprintk(fmt, args);
-	printk("\n");
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: comm %s: %pV\n",
+	       sb->s_id, function, line, current->comm, &vaf);
+
 	va_end(args);
 
 	ext4_handle_error(sb);
@@ -543,28 +547,35 @@ void __ext4_abort(struct super_block *sb, const char *function,
 		panic("EXT4-fs panic from previous error\n");
 }
 
-void ext4_msg (struct super_block * sb, const char *prefix,
-		   const char *fmt, ...)
+void ext4_msg(struct super_block *sb, const char *prefix, const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
 	va_start(args, fmt);
-	printk("%sEXT4-fs (%s): ", prefix, sb->s_id);
-	vprintk(fmt, args);
-	printk("\n");
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk("%sEXT4-fs (%s): %pV\n", prefix, sb->s_id, &vaf);
+
 	va_end(args);
 }
 
 void __ext4_warning(struct super_block *sb, const char *function,
 		    unsigned int line, const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
 	va_start(args, fmt);
-	printk(KERN_WARNING "EXT4-fs warning (device %s): %s:%d: ",
-	       sb->s_id, function, line);
-	vprintk(fmt, args);
-	printk("\n");
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk(KERN_WARNING "EXT4-fs warning (device %s): %s:%d: %pV\n",
+	       sb->s_id, function, line, &vaf);
+
 	va_end(args);
 }
 
@@ -575,21 +586,27 @@ void __ext4_grp_locked_error(const char *function, unsigned int line,
 __releases(bitlock)
 __acquires(bitlock)
 {
+	struct va_format vaf;
 	va_list args;
 	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
 
 	es->s_last_error_ino = cpu_to_le32(ino);
 	es->s_last_error_block = cpu_to_le64(block);
 	__save_error_info(sb, function, line);
+
 	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
 	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: group %u",
 	       sb->s_id, function, line, grp);
 	if (ino)
-		printk("inode %lu: ", ino);
+		printk(KERN_CONT "inode %lu: ", ino);
 	if (block)
-		printk("block %llu:", (unsigned long long) block);
-	vprintk(fmt, args);
-	printk("\n");
+		printk(KERN_CONT "block %llu:", (unsigned long long) block);
+	printk(KERN_CONT "%pV\n", &vaf);
+
 	va_end(args);
 
 	if (test_opt(sb, ERRORS_CONT)) {


