From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 11/34] dumpe2fs: output cleanup
Date: Sat, 13 Sep 2014 15:12:26 -0700
Message-ID: <20140913221226.13646.37351.stgit@birch.djwong.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, TR Reardon <thomas_reardon@hotmail.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32233 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbaIMWMd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Sep 2014 18:12:33 -0400
In-Reply-To: <20140913221112.13646.3873.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don't display unused inodes twice, and make it clear that we're
printing a descriptor checksum.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: TR Reardon <thomas_reardon@hotmail.com>
---
 misc/dumpe2fs.c  |    8 +++-----
 tests/filter.sed |    3 ++-
 2 files changed, 5 insertions(+), 6 deletions(-)


diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 05dc3c5..39505a8 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -217,20 +217,18 @@ static void list_desc(ext2_filsys fs, int grp_only)
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

