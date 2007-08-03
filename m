From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH 4/4][e2fsprogs] New bitmap and inode table allocation
 for FLEX_BG
Date: Fri, 3 Aug 2007 07:27:23 -0500
Message-ID: <20070803072723.3c8f2047@gara>
References: <20070803040041.29456.31454.stgit@gara>
	<20070803040105.29456.1467.stgit@gara>
	<46B2CBB8.8070007@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:57821 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758153AbXHCM3w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Aug 2007 08:29:52 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l73CTnOR012397
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 08:29:49 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l73CTnYN216994
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 06:29:49 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l73CTmfI017127
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 06:29:48 -0600
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l73CTm46017090
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 06:29:48 -0600
In-Reply-To: <46B2CBB8.8070007@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 03 Aug 2007 12:01:20 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> 
> 
> Jose R. Santos wrote:
> > From: Jose R. Santos <jrs@us.ibm.com>
> > 
> > Ne
> > +	case ALLOC_INODE_TABLES:
> > +		for (i=0, blk=new_blk; i < count; i++, blk++) {
> 
> I guess you can drop the blk update in the for() loop above. 

This was from the remains of the very first attempt at inode table
allocation.  Thanks for catching.

> 
> > +			retval = ext2fs_get_free_blocks(fs, start_blk, last_blk,
> > +							fs->inode_blocks_per_group,
> > +							bmap, &new_blk);
> > +			if (retval)
> > +				return retval;
> > +			for (j=0, blk = new_blk;
> > +			     j < fs->inode_blocks_per_group; j++, blk++)
> > +				ext2fs_mark_block_bitmap(bmap, blk);
> > +			fs->group_desc[group+i].bg_inode_table = new_blk;
> > +		}
> > +		break;
> > +
> > +	}
> > +	return 0;
> > +}
> > +
> > +
> > +
> > +errcode_t ext2fs_allocate_flex_groups(ext2_filsys fs)
> > +{
> > +	errcode_t	retval;
> > +	blk_t		start, last, j, blocks;
> > +	dgrp_t		i, k;
> > +	int		gpm;
> > +
> > +	gpm = GROUPS_PER_FLEXBG;
> > +	blocks = 0;
> > +
> > +	for (i = 0; i < fs->group_desc_count; i=i+gpm) {
> > +		if (i == 0 )
> > +			start = ext2fs_group_first_block(fs,
> > +							 FIRST_METADATA_GROUP);
> > +		else
> > +			start = ext2fs_group_first_block(fs, i);
> > +
> > +		if (i+gpm-1 > fs->group_desc_count) {
> 		
> 
> 		if (i+gpm >= fs->group_desc_count) 

Update.

> 
> > +			last = ext2fs_group_last_block(fs, fs->group_desc_count);
> > +			gpm = fs->group_desc_count - i;
> > +		}
> 
> 
> -aneesh

Thanks

-JRS
