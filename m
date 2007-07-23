From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] fix inode_table test in ext234_check_descriptors
Date: Mon, 23 Jul 2007 12:16:04 -0500
Message-ID: <46A4E254.3010606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758746AbXGWRWT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jul 2007 13:22:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext[234]_check_descriptors sanity checks block group descriptor geometry
at mount time, testing whether the block bitmap, inode bitmap, and
inode table reside wholly within the blockgroup.  However, the inode
table test is off by one so that if the last block in the inode table
resides on the last block of the block group, the test incorrectly 
fails.  This is because it tests the last block as (start + length)
rather than (start + length - 1).

This can be seen by trying to mount a filesystem made such as:
 mkfs.ext2 -F -b 1024 -m 0 -g 256 -N 3744 fsfile 1024
which yields:
 EXT2-fs error (device loop0): ext2_check_descriptors: Inode table for group 0 not in group (block 101)!
 EXT2-fs: group descriptors corrupted!

There is a similar bug in e2fsprogs, patch already sent for that.

(I wonder if inside(), outside(), and/or in_range() should someday be
used in this and other tests throughout the ext filesystems...)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: linux-2.6.22-rc4/fs/ext2/super.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/ext2/super.c
+++ linux-2.6.22-rc4/fs/ext2/super.c
@@ -579,7 +579,7 @@ static int ext2_check_descriptors (struc
 			return 0;
 		}
 		if (le32_to_cpu(gdp->bg_inode_table) < first_block ||
-		    le32_to_cpu(gdp->bg_inode_table) + sbi->s_itb_per_group >
+		    le32_to_cpu(gdp->bg_inode_table) + sbi->s_itb_per_group - 1 >
 		    last_block)
 		{
 			ext2_error (sb, "ext2_check_descriptors",
Index: linux-2.6.22-rc4/fs/ext3/super.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/ext3/super.c
+++ linux-2.6.22-rc4/fs/ext3/super.c
@@ -1211,7 +1211,7 @@ static int ext3_check_descriptors (struc
 			return 0;
 		}
 		if (le32_to_cpu(gdp->bg_inode_table) < first_block ||
-		    le32_to_cpu(gdp->bg_inode_table) + sbi->s_itb_per_group >
+		    le32_to_cpu(gdp->bg_inode_table) + sbi->s_itb_per_group - 1 >
 		    last_block)
 		{
 			ext3_error (sb, "ext3_check_descriptors",
Index: linux-2.6.22-rc4/fs/ext4/super.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/ext4/super.c
+++ linux-2.6.22-rc4/fs/ext4/super.c
@@ -1269,7 +1269,7 @@ static int ext4_check_descriptors (struc
 		}
 		inode_table = ext4_inode_table(sb, gdp);
 		if (inode_table < first_block ||
-		    inode_table + sbi->s_itb_per_group > last_block)
+		    inode_table + sbi->s_itb_per_group - 1 > last_block)
 		{
 			ext4_error (sb, "ext4_check_descriptors",
 				    "Inode table for group %d"
