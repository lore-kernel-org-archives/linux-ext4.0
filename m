From: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@acronis.com>
Subject: RE: Patch on algorithm of place allocation for inode tables in
 mke2fs
Date: Mon, 19 Oct 2009 11:12:41 +0400
Message-ID: <41BA663C8B2F72499F48B0EF991C188E04770A2EB3@RU-EXSTRCL1.ru.corp.acronis.com>
References: <41BA663C8B2F72499F48B0EF991C188E04770A2C74@RU-EXSTRCL1.ru.corp.acronis.com>
 <D4FA24ED-76E6-48FF-87F7-DF07BE458C8C@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from edge1.acronis.com ([91.195.23.132]:25718 "EHLO acronis.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753154AbZJSHMr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Oct 2009 03:12:47 -0400
In-Reply-To: <D4FA24ED-76E6-48FF-87F7-DF07BE458C8C@sun.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

 Hello all,

I correct the patch:

[root@localhost ext2fs]# git diff alloc_tables.c
diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 8547ad6..8ef4b05 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -84,7 +84,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
        errcode_t       retval;
        blk_t           group_blk, start_blk, last_blk, new_blk, blk;
        dgrp_t          last_grp = 0;
-       int             j, rem_grps = 0, flexbg_size = 0;
+       int             j, rem_grps = 0, flexbg_size = 0, inode_table_size = 0;

        group_blk = ext2fs_group_first_block(fs, group);
        last_blk = ext2fs_group_last_block(fs, group);
@@ -181,10 +181,14 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
                blk_t prev_block = 0;
                if (group && fs->group_desc[group-1].bg_inode_table)
                        prev_block = fs->group_desc[group-1].bg_inode_table;
+               if ((group+1) == fs->group_desc_count &&
+                               (fs->group_desc_count % flexbg_size) == 1)
+                       inode_table_size = fs->inode_blocks_per_group;
+               else
+                       inode_table_size = fs->inode_blocks_per_group * rem_grps;
                group_blk = flexbg_offset(fs, group, prev_block, bmap,
                                                 flexbg_size * 2,
-                                                fs->inode_blocks_per_group *
-                                                rem_grps,
+                                                inode_table_size,
                                                 fs->inode_blocks_per_group);
                last_blk = ext2fs_group_last_block(fs, last_grp);
        }

-- 
Vyacheslav Dubeyko <Vyacheslav.Dubeyko@acronis.com>
Acronis

-----Original Message-----
From: Andreas.Dilger@sun.com [mailto:Andreas.Dilger@sun.com] On Behalf Of Andreas Dilger
Sent: Friday, October 16, 2009 10:06 PM
To: Dubeyko, Vyacheslav
Cc: linux-ext4@vger.kernel.org
Subject: Re: Patch on algorithm of place allocation for inode tables in mke2fs

On 16-Oct-09, at 08:45, Vyacheslav Dubeyko wrote:
> Let's try to make raw partition with 8 Gb size by fdisk and then to 
> format it (for example, mkfs.ext4 -b 4096 -L ext4_4K_8G /dev/sdb1).
> If we have 2098482 block count on volume with 4 Kb block size and flex 
> block group size as 16 then we will have 65 groups on volume.
> The last group (that has 1329 blocks) will be the first and sole group 
> in last flex group. Current mke2fs code makes such allocation scheme 
> in last group: Block bitmap at 2097152 (+0), Inode bitmap at
> 2097168 (+16), Inode table at 8626 - 9130. The inode table of the last 
> group will be placed at the volume begin because of we can't allocate 
> sufficient block count for all inode tables in flex group.
> I offer the patch for mke2fs utility:
>
> diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c 
> index 8547ad6..4639527 100644
> --- a/lib/ext2fs/alloc_tables.c
> +++ b/lib/ext2fs/alloc_tables.c
> @@ -181,10 +181,15 @@ errcode_t
> ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
> 		blk_t prev_block = 0;
> 		if (group && fs->group_desc[group-1].bg_inode_table)
> 			prev_block = fs->group_desc[group-1].bg_inode_table;
> +		int requsted_size = 0;

This C++ style declaration needs to go at the beginning of the function.

> +		if ((group+1) == fs->group_desc_count &&
> +				(fs->group_desc_count % flexbg_size) == 1)
> +			requsted_size = fs->inode_blocks_per_group;
> +		else
> +			requsted_size = fs->inode_blocks_per_group * rem_grps;
> 		group_blk = flexbg_offset(fs, group, prev_block, bmap,
> 						 flexbg_size * 2,
> -						 fs->inode_blocks_per_group *
> -						 rem_grps,
> +						 requsted_size,
> 						 fs->inode_blocks_per_group);
> 		last_blk = ext2fs_group_last_block(fs, last_grp);
> 	}


I think the rest of this looks reasonable.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

