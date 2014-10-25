From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 16/39] dumpe2fs: output cleanup
Date: Sat, 25 Oct 2014 13:58:06 -0700
Message-ID: <20141025205806.532.96949.stgit@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, TR Reardon <thomas_reardon@hotmail.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44004 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbaJYU6k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Oct 2014 16:58:40 -0400
In-Reply-To: <20141025205623.532.12119.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don't display unused inodes twice, and make it clear that we're
printing a descriptor checksum.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: TR Reardon <thomas_reardon@hotmail.com>
---
 misc/dumpe2fs.c                 |    8 +++-----
 tests/filter.sed                |    3 ++-
 tests/r_fixup_lastbg_big/expect |    2 ++
 3 files changed, 7 insertions(+), 6 deletions(-)


diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index f39cb3c..6751bff 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -218,20 +218,18 @@ static void list_desc(ext2_filsys fs, int grp_only)
 			continue;
 		}
 
-		printf (_("Group %lu: (Blocks "), i);
+		printf(_("Group %lu: (Blocks "), i);
 		print_range(first_block, last_block);
 		fputs(")", stdout);
-		print_bg_opts(fs, i);
 		if (ext2fs_has_group_desc_csum(fs)) {
 			unsigned csum = ext2fs_bg_checksum(fs, i);
 			unsigned exp_csum = ext2fs_group_desc_csum(fs, i);
 
-			printf(_("  Checksum 0x%04x"), csum);
+			printf(_(" csum 0x%04x"), csum);
 			if (csum != exp_csum)
 				printf(_(" (EXPECTED 0x%04x)"), exp_csum);
-			printf(_(", unused inodes %u\n"),
-			       ext2fs_bg_itable_unused(fs, i));
 		}
+		print_bg_opts(fs, i);
 		has_super = ((i==0) || super_blk);
 		if (has_super) {
 			printf (_("  %s superblock at "),
diff --git a/tests/filter.sed b/tests/filter.sed
index 59fad4e..d9a336c 100644
--- a/tests/filter.sed
+++ b/tests/filter.sed
@@ -21,4 +21,5 @@ s/\\015//g
 /Reserved blocks uid:/s/ (user .*)//
 /Reserved blocks gid:/s/ (group .*)//
 /whichever comes first/d
-/^  Checksum /d
+s/, csum 0x\([0-9a-f]*\)//g
+s/ csum 0x\([0-9a-f]*\)//g
diff --git a/tests/r_fixup_lastbg_big/expect b/tests/r_fixup_lastbg_big/expect
index badf6cf..8f302a3 100644
--- a/tests/r_fixup_lastbg_big/expect
+++ b/tests/r_fixup_lastbg_big/expect
@@ -33,6 +33,8 @@ Group 2: (Blocks 16385-24576) [INODE_UNINIT, BLOCK_UNINIT]
   Free inodes: 833-1248
 Group 3: (Blocks 24577-32768) [INODE_UNINIT]
   Backup superblock at 24577, Group descriptors at 24578-24578
+  Reserved GDT blocks at 24579-24656
+  Block bitmap at 413 (bg #0 + 412)
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity

