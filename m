From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] ext2/3/4: delete unneeded includes of module.h
Date: Wed,  4 Jan 2012 15:59:47 -0500
Message-ID: <1325710787-32576-1-git-send-email-paul.gortmaker@windriver.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca, akpm@linux-foundation.org,
	jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:47125 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab2ADVAR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jan 2012 16:00:17 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Delete any instances of include module.h that were not strictly
required.  In the case of ext2, the declaration of MODULE_LICENSE
etc. were in inode.c but the module_init/exit were in super.c, so
relocate the MODULE_LICENCE/AUTHOR block to super.c which makes it
consistent with ext3 and ext4 at the same time.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 91a6945..740cad8 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -26,7 +26,6 @@
 #include <linux/highuid.h>
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
-#include <linux/module.h>
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>
 #include <linux/mpage.h>
@@ -36,10 +35,6 @@
 #include "acl.h"
 #include "xip.h"
 
-MODULE_AUTHOR("Remy Card and others");
-MODULE_DESCRIPTION("Second Extended Filesystem");
-MODULE_LICENSE("GPL");
-
 static int __ext2_write_inode(struct inode *inode, int do_sync);
 
 /*
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index bd8ac16..9e7e203 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1521,5 +1521,8 @@ static void __exit exit_ext2_fs(void)
 	exit_ext2_xattr();
 }
 
+MODULE_AUTHOR("Remy Card and others");
+MODULE_DESCRIPTION("Second Extended Filesystem");
+MODULE_LICENSE("GPL");
 module_init(init_ext2_fs)
 module_exit(exit_ext2_fs)
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index d27b71f..6dcafc7 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -54,7 +54,6 @@
  */
 
 #include <linux/buffer_head.h>
-#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/mbcache.h>
diff --git a/fs/ext2/xattr_security.c b/fs/ext2/xattr_security.c
index c922adc..be7a8d0 100644
--- a/fs/ext2/xattr_security.c
+++ b/fs/ext2/xattr_security.c
@@ -3,7 +3,6 @@
  * Handler for storing security labels as extended attributes.
  */
 
-#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/fs.h>
diff --git a/fs/ext2/xattr_trusted.c b/fs/ext2/xattr_trusted.c
index 667e46a..2989467 100644
--- a/fs/ext2/xattr_trusted.c
+++ b/fs/ext2/xattr_trusted.c
@@ -5,7 +5,6 @@
  * Copyright (C) 2003 by Andreas Gruenbacher, <a.gruenbacher@computer.org>
  */
 
-#include <linux/module.h>
 #include <linux/string.h>
 #include <linux/capability.h>
 #include <linux/fs.h>
diff --git a/fs/ext2/xattr_user.c b/fs/ext2/xattr_user.c
index 099d20f..f470e44 100644
--- a/fs/ext2/xattr_user.c
+++ b/fs/ext2/xattr_user.c
@@ -6,7 +6,6 @@
  */
 
 #include <linux/init.h>
-#include <linux/module.h>
 #include <linux/string.h>
 #include "ext2.h"
 #include "xattr.h"
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 85fe655..779c8de 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -22,7 +22,6 @@
  *  Assorted race fixes, rewrite of ext3_get_block() by Al Viro, 2000
  */
 
-#include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/time.h>
 #include <linux/ext3_jbd.h>
diff --git a/fs/ext3/xattr_security.c b/fs/ext3/xattr_security.c
index 3c218b8..ea26f2a 100644
--- a/fs/ext3/xattr_security.c
+++ b/fs/ext3/xattr_security.c
@@ -3,7 +3,6 @@
  * Handler for storing security labels as extended attributes.
  */
 
-#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/fs.h>
diff --git a/fs/ext3/xattr_trusted.c b/fs/ext3/xattr_trusted.c
index dc8edda..2526a88 100644
--- a/fs/ext3/xattr_trusted.c
+++ b/fs/ext3/xattr_trusted.c
@@ -5,7 +5,6 @@
  * Copyright (C) 2003 by Andreas Gruenbacher, <a.gruenbacher@computer.org>
  */
 
-#include <linux/module.h>
 #include <linux/string.h>
 #include <linux/capability.h>
 #include <linux/fs.h>
diff --git a/fs/ext3/xattr_user.c b/fs/ext3/xattr_user.c
index 7a32197..b32e473 100644
--- a/fs/ext3/xattr_user.c
+++ b/fs/ext3/xattr_user.c
@@ -5,7 +5,6 @@
  * Copyright (C) 2001 by Andreas Gruenbacher, <a.gruenbacher@computer.org>
  */
 
-#include <linux/module.h>
 #include <linux/string.h>
 #include <linux/fs.h>
 #include <linux/ext3_jbd.h>
diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index 8efb2f0..3f11656 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -13,7 +13,6 @@
 #include <linux/namei.h>
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
-#include <linux/module.h>
 #include <linux/swap.h>
 #include <linux/pagemap.h>
 #include <linux/blkdev.h>
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 607b155..841faf5 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -29,7 +29,6 @@
  *   - smart tree reduction
  */
 
-#include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/time.h>
 #include <linux/jbd2.h>
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 3cfc73f..830e1b2 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -20,7 +20,6 @@
  *	(sct@redhat.com), 1993, 1998
  */
 
-#include <linux/module.h>
 #include "ext4_jbd2.h"
 #include "truncate.h"
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 92655fd..7ea726f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -18,7 +18,6 @@
  *  Assorted race fixes, rewrite of ext4_get_block() by Al Viro, 2000
  */
 
-#include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/time.h>
 #include <linux/jbd2.h>
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 16ac228..e7d6bb0 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -12,7 +12,6 @@
  *
  */
 
-#include <linux/module.h>
 #include <linux/slab.h>
 #include "ext4_jbd2.h"
 
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 7e106c8..4758518 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -6,7 +6,6 @@
  * Written by Theodore Ts'o, 2010.
  */
 
-#include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/time.h>
 #include <linux/jbd2.h>
diff --git a/fs/ext4/xattr_security.c b/fs/ext4/xattr_security.c
index 34e4350..b60f9f8 100644
--- a/fs/ext4/xattr_security.c
+++ b/fs/ext4/xattr_security.c
@@ -3,7 +3,6 @@
  * Handler for storing security labels as extended attributes.
  */
 
-#include <linux/module.h>
 #include <linux/string.h>
 #include <linux/fs.h>
 #include <linux/security.h>
diff --git a/fs/ext4/xattr_trusted.c b/fs/ext4/xattr_trusted.c
index 37e6ebc..95f1f4a 100644
--- a/fs/ext4/xattr_trusted.c
+++ b/fs/ext4/xattr_trusted.c
@@ -5,7 +5,6 @@
  * Copyright (C) 2003 by Andreas Gruenbacher, <a.gruenbacher@computer.org>
  */
 
-#include <linux/module.h>
 #include <linux/string.h>
 #include <linux/capability.h>
 #include <linux/fs.h>
diff --git a/fs/ext4/xattr_user.c b/fs/ext4/xattr_user.c
index 98c3753..0edb7611 100644
--- a/fs/ext4/xattr_user.c
+++ b/fs/ext4/xattr_user.c
@@ -5,7 +5,6 @@
  * Copyright (C) 2001 by Andreas Gruenbacher, <a.gruenbacher@computer.org>
  */
 
-#include <linux/module.h>
 #include <linux/string.h>
 #include <linux/fs.h>
 #include "ext4_jbd2.h"
-- 
1.7.7

