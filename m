From: akpm@linux-foundation.org
Subject: [patch 135/327] ext2/4: use is_power_of_2()
Date: Tue, 16 Oct 2007 23:27:14 -0700
Message-ID: <200710170627.l9H6REIh006872@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, vignesh.babu@wipro.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43889 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753293AbXJQGka (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Oct 2007 02:40:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: vignesh babu <vignesh.babu@wipro.com>

Replace n & (n - 1) with is_power_of_2(n)

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/super.c |    3 ++-
 fs/ext4/super.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/ext2/super.c~ext2-4-use-is_power_of_2 fs/ext2/super.c
--- a/fs/ext2/super.c~ext2-4-use-is_power_of_2
+++ a/fs/ext2/super.c
@@ -30,6 +30,7 @@
 #include <linux/vfs.h>
 #include <linux/seq_file.h>
 #include <linux/mount.h>
+#include <linux/log2.h>
 #include <asm/uaccess.h>
 #include "ext2.h"
 #include "xattr.h"
@@ -862,7 +863,7 @@ static int ext2_fill_super(struct super_
 		sbi->s_inode_size = le16_to_cpu(es->s_inode_size);
 		sbi->s_first_ino = le32_to_cpu(es->s_first_ino);
 		if ((sbi->s_inode_size < EXT2_GOOD_OLD_INODE_SIZE) ||
-		    (sbi->s_inode_size & (sbi->s_inode_size - 1)) ||
+		    !is_power_of_2(sbi->s_inode_size) ||
 		    (sbi->s_inode_size > blocksize)) {
 			printk ("EXT2-fs: unsupported inode size: %d\n",
 				sbi->s_inode_size);
diff -puN fs/ext4/super.c~ext2-4-use-is_power_of_2 fs/ext4/super.c
--- a/fs/ext4/super.c~ext2-4-use-is_power_of_2
+++ a/fs/ext4/super.c
@@ -1738,7 +1738,7 @@ static int ext4_fill_super (struct super
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_64BIT)) {
 		if (sbi->s_desc_size < EXT4_MIN_DESC_SIZE_64BIT ||
 		    sbi->s_desc_size > EXT4_MAX_DESC_SIZE ||
-		    sbi->s_desc_size & (sbi->s_desc_size - 1)) {
+		    !is_power_of_2(sbi->s_desc_size)) {
 			printk(KERN_ERR
 			       "EXT4-fs: unsupported descriptor size %lu\n",
 			       sbi->s_desc_size);
_
