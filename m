From: akpm@linux-foundation.org
Subject: - is_power_of_2-ext4-superc.patch removed from -mm tree
Date: Wed, 18 Jul 2007 11:52:54 -0700
Message-ID: <200707181852.l6IIqsFH023722@imap1.linux-foundation.org>
To: vignesh.babu@wipro.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48544 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752936AbXGRSzD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Jul 2007 14:55:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     is_power_of_2: ext3/super.c
has been removed from the -mm tree.  Its filename was
     is_power_of_2-ext4-superc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: is_power_of_2: ext3/super.c
From: vignesh babu <vignesh.babu@wipro.com>

Replace (n & (n-1)) in the context of power of 2 checks with is_power_of_2()

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/ext4/super.c~is_power_of_2-ext4-superc fs/ext4/super.c
--- a/fs/ext4/super.c~is_power_of_2-ext4-superc
+++ a/fs/ext4/super.c
@@ -36,6 +36,7 @@
 #include <linux/namei.h>
 #include <linux/quotaops.h>
 #include <linux/seq_file.h>
+#include <linux/log2.h>
 
 #include <asm/uaccess.h>
 
@@ -1662,7 +1663,7 @@ static int ext4_fill_super (struct super
 		sbi->s_inode_size = le16_to_cpu(es->s_inode_size);
 		sbi->s_first_ino = le32_to_cpu(es->s_first_ino);
 		if ((sbi->s_inode_size < EXT4_GOOD_OLD_INODE_SIZE) ||
-		    (sbi->s_inode_size & (sbi->s_inode_size - 1)) ||
+		    (!is_power_of_2(sbi->s_inode_size)) ||
 		    (sbi->s_inode_size > blocksize)) {
 			printk (KERN_ERR
 				"EXT4-fs: unsupported inode size: %d\n",
_

Patches currently in -mm which might be from vignesh.babu@wipro.com are

origin.patch
git-xfs.patch
