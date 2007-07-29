From: akpm@linux-foundation.org
Subject: - fix-inode_table-test-in-ext234_check_descriptors.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:12:05 -0700
Message-ID: <200707290612.l6T6C5oY011100@imap1.linux-foundation.org>
To: sandeen@redhat.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37176 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758476AbXG2GXq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 Jul 2007 02:23:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     fix inode_table test in ext234_check_descriptors
has been removed from the -mm tree.  Its filename was
     fix-inode_table-test-in-ext234_check_descriptors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix inode_table test in ext234_check_descriptors
From: Eric Sandeen <sandeen@redhat.com>

ext[234]_check_descriptors sanity checks block group descriptor geometry at
mount time, testing whether the block bitmap, inode bitmap, and inode table
reside wholly within the blockgroup.  However, the inode table test is off
by one so that if the last block in the inode table resides on the last
block of the block group, the test incorrectly fails.  This is because it
tests the last block as (start + length) rather than (start + length - 1).

This can be seen by trying to mount a filesystem made such as:

 mkfs.ext2 -F -b 1024 -m 0 -g 256 -N 3744 fsfile 1024

which yields:

 EXT2-fs error (device loop0): ext2_check_descriptors: Inode table for group 0 not in group (block 101)!
 EXT2-fs: group descriptors corrupted!

There is a similar bug in e2fsprogs, patch already sent for that.

(I wonder if inside(), outside(), and/or in_range() should someday be
used in this and other tests throughout the ext filesystems...)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/super.c |    2 +-
 fs/ext3/super.c |    2 +-
 fs/ext4/super.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ext2/super.c~fix-inode_table-test-in-ext234_check_descriptors fs/ext2/super.c
--- a/fs/ext2/super.c~fix-inode_table-test-in-ext234_check_descriptors
+++ a/fs/ext2/super.c
@@ -580,7 +580,7 @@ static int ext2_check_descriptors (struc
 			return 0;
 		}
 		if (le32_to_cpu(gdp->bg_inode_table) < first_block ||
-		    le32_to_cpu(gdp->bg_inode_table) + sbi->s_itb_per_group >
+		    le32_to_cpu(gdp->bg_inode_table) + sbi->s_itb_per_group - 1 >
 		    last_block)
 		{
 			ext2_error (sb, "ext2_check_descriptors",
diff -puN fs/ext3/super.c~fix-inode_table-test-in-ext234_check_descriptors fs/ext3/super.c
--- a/fs/ext3/super.c~fix-inode_table-test-in-ext234_check_descriptors
+++ a/fs/ext3/super.c
@@ -1221,7 +1221,7 @@ static int ext3_check_descriptors (struc
 			return 0;
 		}
 		if (le32_to_cpu(gdp->bg_inode_table) < first_block ||
-		    le32_to_cpu(gdp->bg_inode_table) + sbi->s_itb_per_group >
+		    le32_to_cpu(gdp->bg_inode_table) + sbi->s_itb_per_group - 1 >
 		    last_block)
 		{
 			ext3_error (sb, "ext3_check_descriptors",
diff -puN fs/ext4/super.c~fix-inode_table-test-in-ext234_check_descriptors fs/ext4/super.c
--- a/fs/ext4/super.c~fix-inode_table-test-in-ext234_check_descriptors
+++ a/fs/ext4/super.c
@@ -1283,7 +1283,7 @@ static int ext4_check_descriptors (struc
 		}
 		inode_table = ext4_inode_table(sb, gdp);
 		if (inode_table < first_block ||
-		    inode_table + sbi->s_itb_per_group > last_block)
+		    inode_table + sbi->s_itb_per_group - 1 > last_block)
 		{
 			ext4_error (sb, "ext4_check_descriptors",
 				    "Inode table for group %d"
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
udf-fix-uid-and-gid-mount-option-ignorance.patch
remove-unused-bh-in-calls-to-ext234_get_group_desc.patch
