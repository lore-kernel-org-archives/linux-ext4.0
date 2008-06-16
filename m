From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: fix ext4_init_block_bitmap() for metablock block
	group
Date: Mon, 16 Jun 2008 16:57:01 -0700
Message-ID: <1213660621.27507.50.camel@BVR-FS.beaverton.ibm.com>
References: <20080615142455.GA3502@localhost.localdomain>
	 <20080616051859.GK3726@webber.adilger.int>
	 <20080616141016.GA19080@localhost.localdomain>
	 <20080616191902.GU3726@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Stephen Tweedie <sct@redhat.com>, adilger@clusterfs.com,
	Theodore Tso <tytso@MIT.EDU>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:47995 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383AbYFPX4e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jun 2008 19:56:34 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5GNq5mo010382
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2008 19:52:05 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5GNuWQQ161746
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2008 17:56:32 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5GNuVFB015094
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2008 17:56:32 -0600
In-Reply-To: <20080616191902.GU3726@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Mon, 2008-06-16 at 13:19 -0600, Andreas Dilger wrote:
> On Jun 16, 2008  23:10 +0900, Akinobu Mita wrote:
> > Looks good to me. But I'd like to divide into the change into simple
> > bugfix and cleanup patch in order to clarify the each change.
> > 
> > Here is a bugfix only patch.
> > 
> > From: Akinobu Mita <akinobu.mita@gmail.com>
> > Subject: ext4: fix ext4_init_block_bitmap() for metablock block group
> > 
> > When meta_bg feature is enabled and s_first_meta_bg != 0, 
> > ext4_init_block_bitmap() miscalculates the number of block used by
> > the group descriptor table (0 or 1 for metablock block group)
> > 
> > group_rel in the original code should be calculated by:
> > 
> >         group_rel = block_group % EXT4_DESC_PER_BLOCK(sb);
> > 
> > No need to subtract s_first_meta_bg from brock_group.
> > It will be equivalent what ext4_bg_num_gdb_meta() does
> > 
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Stephen Tweedie <sct@redhat.com>
> > Cc: adilger@clusterfs.com
> > Cc: Mingming Cao <cmm@us.ibm.com>
> > Cc: Theodore Tso <tytso@MIT.EDU>
> 
> Acked-by: Andreas Dilger <adilger@sun.com>
> 

FYI, I have added this patch to patch queue

Mingming
> > ---
> >  fs/ext4/balloc.c |    5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > Index: 2.6-git/fs/ext4/balloc.c
> > ===================================================================
> > --- 2.6-git.orig/fs/ext4/balloc.c
> > +++ 2.6-git/fs/ext4/balloc.c
> > @@ -121,9 +121,8 @@ unsigned ext4_init_block_bitmap(struct s
> >  				le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks);
> >  		}
> >  	} else { /* For META_BG_BLOCK_GROUPS */
> > -		int group_rel = (block_group -
> > -				 le32_to_cpu(sbi->s_es->s_first_meta_bg)) %
> > -				EXT4_DESC_PER_BLOCK(sb);
> > +		int group_rel = block_group % EXT4_DESC_PER_BLOCK(sb);
> > +
> >  		if (group_rel == 0 || group_rel == 1 ||
> >  		    (group_rel == EXT4_DESC_PER_BLOCK(sb) - 1))
> >  			bit_max += 1;
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 

