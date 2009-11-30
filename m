From: tytso@mit.edu
Subject: Re: Patch on algorithm of place allocation for inode tables in
 mke2fs
Date: Mon, 30 Nov 2009 12:32:00 -0500
Message-ID: <20091130173200.GA4719@thunk.org>
References: <41BA663C8B2F72499F48B0EF991C188E04770A2C74@RU-EXSTRCL1.ru.corp.acronis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@acronis.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54765 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbZK3Sc2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Nov 2009 13:32:28 -0500
Content-Disposition: inline
In-Reply-To: <41BA663C8B2F72499F48B0EF991C188E04770A2C74@RU-EXSTRCL1.ru.corp.acronis.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 16, 2009 at 06:45:39PM +0400, Vyacheslav Dubeyko wrote:
> Hi all:
> 
> Let's try to make raw partition with 8 Gb size by fdisk and then to
> format it (for example, mkfs.ext4 -b 4096 -L ext4_4K_8G
> /dev/sdb1). If we have 2098482 block count on volume with 4 Kb block
> size and flex block group size as 16 then we will have 65 groups on
> volume. The last group (that has 1329 blocks) will be the first and
> sole group in last flex group. Current mke2fs code makes such
> allocation scheme in last group: Block bitmap at 2097152 (+0), Inode
> bitmap at 2097168 (+16), Inode table at 8626 - 9130. The inode table
> of the last group will be placed at the volume begin because of we
> can't allocate sufficient block count for all inode tables in flex
> group.

Hi Vyacheslav,

My apologies for the delay in getting back to you; I've had a very
intense travel schedule in October and November, and some things had
fallen through the cracks.

Thanks for pointing this out!  I've decided to use the following patch
as a cleaner and simpler fix for the problem.  What it does is to use
the true size for the inode table, instead of the expected size of the
inode table should the file system get resized, to avoid the problem
you've pointed out.

Best regards,

						- Ted

commit bbb60e4fefdd404d8d696369804b556b404bb0c1
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Nov 30 12:24:59 2009 -0500

    libext2fs: Improve flex_bg inode table placement algorithm
    
    When trying to find the best place for the inode table in the last
    flex block group, use the true size for the flex_bg's portion of the
    inode table instead of the worst case required size of the inode table
    fragment if the file system is resized.  This fixes a corner case
    where if the size of the filesystem is just big enough that there is
    only room for a single block group in the last flex_bg, and that
    partial block group is too small for the full portion of the inode
    table, the inode table is placed in the very first block group:
    
    Group 64: (Blocks 2097152-2099199) [INODE_UNINIT, ITABLE_ZEROED]
      Checksum 0xd305, unused inodes 8080
      Block bitmap at 2097152 (+0), Inode bitmap at 2097168 (+16)
      Inode table at 8626-9130 (+4292878770)
                     ^^^^^^^^^
    
    Thanks to Vyacheslav Dubeyko for pointing this out.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 8547ad6..55e6174 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -181,6 +181,8 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 		blk_t prev_block = 0;
 		if (group && fs->group_desc[group-1].bg_inode_table)
 			prev_block = fs->group_desc[group-1].bg_inode_table;
+		if (last_grp == fs->group_desc_count)
+			rem_grps = last_grp - group;
 		group_blk = flexbg_offset(fs, group, prev_block, bmap,
 						 flexbg_size * 2,
 						 fs->inode_blocks_per_group *
