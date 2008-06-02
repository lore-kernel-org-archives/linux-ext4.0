From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 3/6] delalloc ENOSPC: reserve blocks
Date: Mon, 2 Jun 2008 12:25:14 +0530
Message-ID: <20080602065514.GD26379@skywalker>
References: <1212363355.4368.66.camel@localhost.localdomain> <20080602064433.GB26379@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:33717 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbYFBGzX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 02:55:23 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m526tv9X009130
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 16:55:57 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m526t5Np4727030
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 16:55:05 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m526tLYg008653
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 16:55:21 +1000
Content-Disposition: inline
In-Reply-To: <20080602064433.GB26379@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 02, 2008 at 12:14:33PM +0530, Aneesh Kumar K.V wrote:
> On Sun, Jun 01, 2008 at 04:35:55PM -0700, Mingming Cao wrote:
> > ext4: delalloc ENOSPC handling core
> > 
> > From: Mingming cao <cmm@us.ibm.com>
> > 
> > Core part of delaloc ENOSPC (block reservation.) 
> > data/meta blocks are reserved on write_begin(), and per-inode reserved counters
> > are updated  after block allocation.
> > 
> > Signed-off-by: Mingming cao <cmm@us.ibm.com>
> > 
> > ---
> >  fs/ext4/inode.c |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 66 insertions(+), 3 deletions(-)
> > 
> > Index: linux-2.6.26-rc4/fs/ext4/inode.c
> > ===================================================================
> > --- linux-2.6.26-rc4.orig/fs/ext4/inode.c	2008-06-01 14:26:13.000000000 -0700
> > +++ linux-2.6.26-rc4/fs/ext4/inode.c	2008-06-01 15:04:06.000000000 -0700
> > @@ -38,6 +38,7 @@
> >  #include "ext4_jbd2.h"
> >  #include "xattr.h"
> >  #include "acl.h"
> > +#include "ext4_extents.h"
> > 
> >  static void ext4_invalidatepage(struct page *page, unsigned long offset);
> > 
> > @@ -1410,6 +1411,61 @@ static int ext4_journalled_write_end(str
> >  	return ret ? ret : copied;
> >  }
> > 
> > +static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
> > +{
> > +       struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> > +       unsigned long md_needed, mdblocks, total = 0;
> > +
> > +       /*
> > +        * calculate the amount of metadata blocks to reserve
> 
> 	 recalculate the amount of metadata blocks to reserve.
> 
> 
> 
> 
> > +	* in order to allocate nrblocks
> > +	* worse case is one extent per block
> > +	*/
> > +	total = EXT4_I(inode)->i_reserved_data_blocks + nrblocks;
> > +	mdblocks = ext4_ext_calc_metadata_amount(inode, total);
> > +	BUG_ON(mdblocks < EXT4_I(inode)->i_reserved_meta_blocks);
> > +
> > +	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
> > +	total = md_needed + nrblocks;
> > +
> > +	if (ext4_has_free_blocks(sbi, total) < total)
> > +		return -ENOSPC;
> > +
> > +	/* reduce fs free blocks counter */
> > +	percpu_counter_sub(&sbi->s_freeblocks_counter, total);
> > +
> > +	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
> > +	EXT4_I(inode)->i_reserved_meta_blocks += md_needed;
> 
> Better written as
> 	EXT4_I(inode)->i_reserved_meta_blocks += mdblocks;
> 
> 
	EXT4_I(inode)->i_reserved_meta_blocks = mdblocks;

-aneesh
