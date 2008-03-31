From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [PATCH, E2FSPROGS] ext2fs_set_gdt_csum(): Force the last block group to have a valid block bitmap
Date: Mon, 31 Mar 2008 19:36:26 -0400
Message-ID: <1207006592-13980-5-git-send-email-tytso@mit.edu>
References: <20080325084039.GA10804@webber.adilger.int>
 <1207006592-13980-1-git-send-email-tytso@mit.edu>
 <1207006592-13980-2-git-send-email-tytso@mit.edu>
 <1207006592-13980-3-git-send-email-tytso@mit.edu>
 <1207006592-13980-4-git-send-email-tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61489 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751395AbYCaXjW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2008 19:39:22 -0400
In-Reply-To: <1207006592-13980-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Andreas Dilger <adilger@dilger.ca>

Never set the UNINIT_BLOCKS flag for the last group since the kernel
doesn't handle the case graefully if there is a full set of blocks in
each blockgroup marked UNINIT_BLOCKS.  The kernel should be fixed up,
but in the meantime this avoids hitting the problem, and is more
consistent with lazy_bg not marking the last group UNINIT.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/csum.c       |    2 +-
 tests/m_uninit/expect.1 |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index a385d76..70deaa9 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -133,7 +133,7 @@ void ext2fs_set_gdt_csum(ext2_filsys fs)
 
 		/* skip first and last groups, or groups with GDT backups
 		 * because the resize inode has blocks allocated in them. */
-		if (i == 0 || (i == fs->group_desc_count - 1 && !csum_flag) ||
+		if (i == 0 || i == fs->group_desc_count - 1 ||
 		    (ext2fs_bg_has_super(fs, i) && sb->s_reserved_gdt_blocks))
 			goto checksum;
 
diff --git a/tests/m_uninit/expect.1 b/tests/m_uninit/expect.1
index c6c32b9..8d19a40 100644
--- a/tests/m_uninit/expect.1
+++ b/tests/m_uninit/expect.1
@@ -158,9 +158,9 @@ Group 14: (Blocks 114689-122880) [Inode not init, Block not init]
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
   Free blocks: 
   Free inodes: 
-Group 15: (Blocks 122881-131071) [Inode not init, Block not init]
+Group 15: (Blocks 122881-131071) [Inode not init]
   Block bitmap at 122881 (+0), Inode bitmap at 122882 (+1)
   Inode table at 122883-123138 (+2)
   7933 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 
+  Free blocks: 123139-131071
   Free inodes: 
-- 
1.5.4.1.144.gdfee-dirty

