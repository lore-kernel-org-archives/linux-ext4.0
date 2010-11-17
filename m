From: Vamsi Krishna B <vamsikrishna.brahmajosyula@gmail.com>
Subject: [PATCH] fs : ext4 : super.c 	fixed coding style violations
Date: Wed, 17 Nov 2010 21:32:23 +0530
Message-ID: <1290009743-2600-1-git-send-email-vamsikrishna.brahmajosyula@gmail.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Vamsi Krishna B <vamsikrishna.brahmajosyula@gmail.com>
To: tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 61182fe..11a46dc 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -38,7 +38,7 @@
 #include <linux/ctype.h>
 #include <linux/log2.h>
 #include <linux/crc16.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include <linux/kthread.h>
 #include <linux/freezer.h>
@@ -543,7 +543,7 @@ void __ext4_abort(struct super_block *sb, const char *function,
 		panic("EXT4-fs panic from previous error\n");
 }
 
-void ext4_msg (struct super_block * sb, const char *prefix,
+void ext4_msg(struct super_block *sb, const char *prefix,
 		   const char *fmt, ...)
 {
 	va_list args;
@@ -1138,7 +1138,7 @@ static int bdev_try_to_free_page(struct super_block *sb, struct page *page,
 
 #ifdef CONFIG_QUOTA
 #define QTYPE2NAME(t) ((t) == USRQUOTA ? "user" : "group")
-#define QTYPE2MOPT(on, t) ((t) == USRQUOTA?((on)##USRJQUOTA):((on)##GRPJQUOTA))
+#define QTYPE2MOPT(on, t) ((t) == USRQUOTA ? ((on)##USRJQUOTA) : ((on)##GRPJQUOTA))
 
 static int ext4_write_dquot(struct dquot *dquot);
 static int ext4_acquire_dquot(struct dquot *dquot);
-- 
1.7.3.2
