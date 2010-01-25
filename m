From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] resize2fs: fix uninit group test accessing invalid memory
Date: Mon, 25 Jan 2010 15:13:10 -0600
Message-ID: <4B5E0966.3040704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab0AYVNM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jan 2010 16:13:12 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0PLDBqK025530
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 25 Jan 2010 16:13:11 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o0PLDBBB013202
	for <linux-ext4@vger.kernel.org>; Mon, 25 Jan 2010 16:13:11 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 74128f8d7e93fe633aa87951319a4afd252a4494 added tests
for uninit groups, but did it after the group counter
increment in 2 loops, so we were testing past the end
of the ->group_desc[] array:

==19668== Invalid read of size 2
==19668==    at 0x40518C: resize_fs (resize2fs.c:1824)
==19668==    by 0x405A46: main (main.c:451)
==19668==  Address 0x5a0d002 is not stack'd, malloc'd or (recently) free'd
==19668== 
==19668== Invalid read of size 2
==19668==    at 0x405391: resize_fs (resize2fs.c:1864)
==19668==    by 0x405A46: main (main.c:451)
==19668==  Address 0x5a0d002 is not stack'd, malloc'd or (recently) free'd
==19668== 

Found this running the regression suite through valgrind.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 1984442..b706dd7 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1818,9 +1818,6 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 		    (blk == ext2fs_blocks_count(fs->super)-1)) {
 			ext2fs_bg_free_blocks_count_set(fs, group, group_free);
 			ext2fs_group_desc_csum_set(fs, group);
-			group++;
-			count = 0;
-			group_free = 0;
 			uninit = (ext2fs_bg_flags_test(fs, group, EXT2_BG_BLOCK_UNINIT)
 				  );
 			ext2fs_super_and_bgd_loc(fs, group, &super_blk,
@@ -1832,6 +1829,9 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 			else
 				old_desc_blocks = fs->desc_blocks +
 					fs->super->s_reserved_gdt_blocks;
+			group++;
+			count = 0;
+			group_free = 0;
 		}
 	}
 	ext2fs_free_blocks_count_set(fs->super, total_free);
@@ -1857,10 +1857,10 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 		    (ino == fs->super->s_inodes_count)) {
 			ext2fs_bg_free_inodes_count_set(fs, group, group_free);
 			ext2fs_group_desc_csum_set(fs, group);
+			uninit = ext2fs_bg_flags_test(fs, group, EXT2_BG_INODE_UNINIT);
 			group++;
 			count = 0;
 			group_free = 0;
-			uninit = ext2fs_bg_flags_test(fs, group, EXT2_BG_INODE_UNINIT);
 		}
 	}
 	fs->super->s_free_inodes_count = total_free;

