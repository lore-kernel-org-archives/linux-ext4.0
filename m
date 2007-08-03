From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/4][e2fsprogs] New bitmap and inode table allocation
 for FLEX_BG
Date: Fri, 03 Aug 2007 12:01:20 +0530
Message-ID: <46B2CBB8.8070007@linux.vnet.ibm.com>
References: <20070803040041.29456.31454.stgit@gara> <20070803040105.29456.1467.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:48686 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbXHCGdL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Aug 2007 02:33:11 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp06.au.ibm.com (8.13.8/8.13.8) with ESMTP id l736ZUIa5173364
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 16:35:32 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.250.242])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l736YxqO167740
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 16:35:05 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l736VNKT001337
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 16:31:23 +1000
In-Reply-To: <20070803040105.29456.1467.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Jose R. Santos wrote:
> From: Jose R. Santos <jrs@us.ibm.com>
> 
> Ne
> +	case ALLOC_INODE_TABLES:
> +		for (i=0, blk=new_blk; i < count; i++, blk++) {

I guess you can drop the blk update in the for() loop above. 

> +			retval = ext2fs_get_free_blocks(fs, start_blk, last_blk,
> +							fs->inode_blocks_per_group,
> +							bmap, &new_blk);
> +			if (retval)
> +				return retval;
> +			for (j=0, blk = new_blk;
> +			     j < fs->inode_blocks_per_group; j++, blk++)
> +				ext2fs_mark_block_bitmap(bmap, blk);
> +			fs->group_desc[group+i].bg_inode_table = new_blk;
> +		}
> +		break;
> +
> +	}
> +	return 0;
> +}
> +
> +
> +
> +errcode_t ext2fs_allocate_flex_groups(ext2_filsys fs)
> +{
> +	errcode_t	retval;
> +	blk_t		start, last, j, blocks;
> +	dgrp_t		i, k;
> +	int		gpm;
> +
> +	gpm = GROUPS_PER_FLEXBG;
> +	blocks = 0;
> +
> +	for (i = 0; i < fs->group_desc_count; i=i+gpm) {
> +		if (i == 0 )
> +			start = ext2fs_group_first_block(fs,
> +							 FIRST_METADATA_GROUP);
> +		else
> +			start = ext2fs_group_first_block(fs, i);
> +
> +		if (i+gpm-1 > fs->group_desc_count) {
		

		if (i+gpm >= fs->group_desc_count) 


> +			last = ext2fs_group_last_block(fs, fs->group_desc_count);
> +			gpm = fs->group_desc_count - i;
> +		}


-aneesh
