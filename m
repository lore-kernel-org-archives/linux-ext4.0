From: Andreas Dilger <adilger@sun.com>
Subject: Re: Patch on algorithm of place allocation for inode tables in mke2fs
Date: Fri, 16 Oct 2009 12:05:45 -0600
Message-ID: <D4FA24ED-76E6-48FF-87F7-DF07BE458C8C@sun.com>
References: <41BA663C8B2F72499F48B0EF991C188E04770A2C74@RU-EXSTRCL1.ru.corp.acronis.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@acronis.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:64113 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbZJPSFv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Oct 2009 14:05:51 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n9GI5qqF005502
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2009 11:05:52 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KRM00M00CR67K00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 16 Oct 2009 11:05:52 -0700 (PDT)
In-reply-to: <41BA663C8B2F72499F48B0EF991C188E04770A2C74@RU-EXSTRCL1.ru.corp.acronis.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 16-Oct-09, at 08:45, Vyacheslav Dubeyko wrote:
> Let's try to make raw partition with 8 Gb size by fdisk and then to  
> format it (for example, mkfs.ext4 -b 4096 -L ext4_4K_8G /dev/sdb1).  
> If we have 2098482 block count on volume with 4 Kb block size and  
> flex block group size as 16 then we will have 65 groups on volume.  
> The last group (that has 1329 blocks) will be the first and sole  
> group in last flex group. Current mke2fs code makes such allocation  
> scheme in last group: Block bitmap at 2097152 (+0), Inode bitmap at  
> 2097168 (+16), Inode table at 8626 - 9130. The inode table of the  
> last group will be placed at the volume begin because of we can't  
> allocate sufficient block count for all inode tables in flex group.  
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

