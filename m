From: akpm@linux-foundation.org
Subject: - ext-cleanup-ext_bg_num_gdb.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:30:50 -0800
Message-ID: <200802070030.m170UV0p007398@imap1.linux-foundation.org>
To: akinobu.mita@gmail.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52919 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764471AbYBGAni (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Feb 2008 19:43:38 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext[234]: cleanup ext[234]_bg_num_gdb()
has been removed from the -mm tree.  Its filename was
     ext-cleanup-ext_bg_num_gdb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext[234]: cleanup ext[234]_bg_num_gdb()
From: Akinobu Mita <akinobu.mita@gmail.com>

Use ext[234]_bg_has_super() to remove duplicate code.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/balloc.c |    5 +----
 fs/ext3/balloc.c |    6 +-----
 fs/ext4/balloc.c |    6 +-----
 3 files changed, 3 insertions(+), 14 deletions(-)

diff -puN fs/ext2/balloc.c~ext-cleanup-ext_bg_num_gdb fs/ext2/balloc.c
--- a/fs/ext2/balloc.c~ext-cleanup-ext_bg_num_gdb
+++ a/fs/ext2/balloc.c
@@ -1533,9 +1533,6 @@ int ext2_bg_has_super(struct super_block
  */
 unsigned long ext2_bg_num_gdb(struct super_block *sb, int group)
 {
-	if (EXT2_HAS_RO_COMPAT_FEATURE(sb,EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER)&&
-	    !ext2_group_sparse(group))
-		return 0;
-	return EXT2_SB(sb)->s_gdb_count;
+	return ext2_bg_has_super(sb, group) ? EXT2_SB(sb)->s_gdb_count : 0;
 }
 
diff -puN fs/ext3/balloc.c~ext-cleanup-ext_bg_num_gdb fs/ext3/balloc.c
--- a/fs/ext3/balloc.c~ext-cleanup-ext_bg_num_gdb
+++ a/fs/ext3/balloc.c
@@ -1848,11 +1848,7 @@ static unsigned long ext3_bg_num_gdb_met
 
 static unsigned long ext3_bg_num_gdb_nometa(struct super_block *sb, int group)
 {
-	if (EXT3_HAS_RO_COMPAT_FEATURE(sb,
-				EXT3_FEATURE_RO_COMPAT_SPARSE_SUPER) &&
-			!ext3_group_sparse(group))
-		return 0;
-	return EXT3_SB(sb)->s_gdb_count;
+	return ext3_bg_has_super(sb, group) ? EXT3_SB(sb)->s_gdb_count : 0;
 }
 
 /**
diff -puN fs/ext4/balloc.c~ext-cleanup-ext_bg_num_gdb fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~ext-cleanup-ext_bg_num_gdb
+++ a/fs/ext4/balloc.c
@@ -2011,11 +2011,7 @@ static unsigned long ext4_bg_num_gdb_met
 static unsigned long ext4_bg_num_gdb_nometa(struct super_block *sb,
 					ext4_group_t group)
 {
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
-				EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER) &&
-			!ext4_group_sparse(group))
-		return 0;
-	return EXT4_SB(sb)->s_gdb_count;
+	return ext4_bg_has_super(sb, group) ? EXT4_SB(sb)->s_gdb_count : 0;
 }
 
 /**
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
git-dvb.patch
modules-handle-symbols-that-have-a-zero-value-fix.patch
