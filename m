From: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@acronis.com>
Subject: Patch on algorithm of place allocation for inode tables in mke2fs
Date: Fri, 16 Oct 2009 18:45:39 +0400
Message-ID: <41BA663C8B2F72499F48B0EF991C188E04770A2C74@RU-EXSTRCL1.ru.corp.acronis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from edge1.acronis.com ([91.195.23.132]:33289 "EHLO acronis.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758431AbZJPOq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Oct 2009 10:46:29 -0400
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all:

Let's try to make raw partition with 8 Gb size by fdisk and then to format it (for example, mkfs.ext4 -b 4096 -L ext4_4K_8G /dev/sdb1). If we have 2098482 block count on volume with 4 Kb block size and flex block group size as 16 then we will have 65 groups on volume. The last group (that has 1329 blocks) will be the first and sole group in last flex group. Current mke2fs code makes such allocation scheme in last group: Block bitmap at 2097152 (+0), Inode bitmap at 2097168 (+16), Inode table at 8626 - 9130. The inode table of the last group will be placed at the volume begin because of we can't allocate sufficient block count for all inode tables in flex group. I offer the patch for mke2fs utility:

diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 8547ad6..4639527 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -181,10 +181,15 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 		blk_t prev_block = 0;
 		if (group && fs->group_desc[group-1].bg_inode_table)
 			prev_block = fs->group_desc[group-1].bg_inode_table;
+		int requsted_size = 0;
+		if ((group+1) == fs->group_desc_count &&
+				(fs->group_desc_count % flexbg_size) == 1)
+			requsted_size = fs->inode_blocks_per_group;
+		else
+			requsted_size = fs->inode_blocks_per_group * rem_grps;
 		group_blk = flexbg_offset(fs, group, prev_block, bmap,
 						 flexbg_size * 2,
-						 fs->inode_blocks_per_group *
-						 rem_grps,
+						 requsted_size,
 						 fs->inode_blocks_per_group);
 		last_blk = ext2fs_group_last_block(fs, last_grp);
 	}

The patch resolves problem with allocation of inode table in last group in such situation.

-- 

Vyacheslav Dubeyko <Vyacheslav.Dubeyko@acronis.com>
Acronis
