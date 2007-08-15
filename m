From: akpm@linux-foundation.org
Subject: + ext2-4-use-is_power_of_2.patch added to -mm tree
Date: Wed, 15 Aug 2007 16:24:41 -0700
Message-ID: <200708152324.l7FNOfgL020445@imap1.linux-foundation.org>
Cc: vignesh.babu@wipro.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55008 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755355AbXHOXaW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Aug 2007 19:30:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext2/4: use is_power_of_2()
has been added to the -mm tree.  Its filename is
     ext2-4-use-is_power_of_2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext2/4: use is_power_of_2()
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
@@ -804,7 +805,7 @@ static int ext2_fill_super(struct super_
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
@@ -1667,7 +1667,7 @@ static int ext4_fill_super (struct super
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_64BIT)) {
 		if (sbi->s_desc_size < EXT4_MIN_DESC_SIZE_64BIT ||
 		    sbi->s_desc_size > EXT4_MAX_DESC_SIZE ||
-		    sbi->s_desc_size & (sbi->s_desc_size - 1)) {
+		    !is_power_of_2(sbi->s_desc_size)) {
 			printk(KERN_ERR
 			       "EXT4-fs: unsupported descriptor size %lu\n",
 			       sbi->s_desc_size);
_

Patches currently in -mm which might be from vignesh.babu@wipro.com are

git-xfs.patch
ext2-4-use-is_power_of_2.patch
