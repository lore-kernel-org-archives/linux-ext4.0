From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/6 ]Ext4 journal credits reservation fixes
Date: Thu, 14 Aug 2008 14:10:11 +0530
Message-ID: <20080814084011.GB6422@skywalker>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker> <1216774311.6505.4.camel@mingming-laptop> <20080723074226.GA15091@skywalker> <1217032947.6394.2.camel@mingming-laptop> <1218558190.6766.37.camel@mingming-laptop> <1218558938.6766.55.camel@mingming-laptop> <20080813094637.GD6439@skywalker> <1218675670.6387.22.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:45780 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbYHNIl5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Aug 2008 04:41:57 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7E8eXjm010036
	for <linux-ext4@vger.kernel.org>; Thu, 14 Aug 2008 18:40:33 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7E8eM5n193228
	for <linux-ext4@vger.kernel.org>; Thu, 14 Aug 2008 18:40:22 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7E8eMOD008070
	for <linux-ext4@vger.kernel.org>; Thu, 14 Aug 2008 18:40:22 +1000
Content-Disposition: inline
In-Reply-To: <1218675670.6387.22.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 13, 2008 at 06:01:10PM -0700, Mingming Cao wrote:
....
....
> > > +static int ext4_writepages_trans_blocks(struct inode *inode)
> > > +{
> > > +	int bpp = ext4_journal_blocks_per_page(inode);
> > > +	int max_blocks = EXT4_MAX_WRITEPAGES_SIZE * bpp;
> > > +
> > > +	if (max_blocks > EXT4_I(inode)->i_reserved_data_blocks)
> > > +		max_blocks =  EXT4_I(inode)->i_reserved_data_blocks;
> > 
> > 
> > 
> > Why are we limiting max_blocks to i_reserved_data_blocks ?
> > 
> 
> i_reserved_data_blocks is the total number of "delayed" blocks that need
> block allocation. That's  a counter being adds up at each write_begin()
> when the block allocation is defered. That's a accurate counter to
> indicate the max number of allocation we need to flush all dirty pages
> to disk for this inode,  fits well when we need to calculate the credits
> for da_writepages.
> 
> Now that we don't have PAGEVEC limit,  we could use this to limit the
> total number of blocks to allocate  when estimate the credit.   But if
> this i_reserved_data_blocks gets too large, that can't fit into one
> single transaction, later get_block() will overflow the journal, we need
> someway to limit the number of pages to flush still:(


We should be requesting for credits needed for
EXT4_I(inode)->i_reserved_data_blocks with chunk = 1. If we don't have
that many credits we can limit max_blocks with  EXT4_BLOCKS_PER_GROUP

	if (EXT4_I(inode)->i_reserved_data_blocks > EXT4_BLOCKS_PER_GROUP)
		max_blocks = EXT4_BLOCKS_PER_GROUP;
	else
		max_blocks = EXT4_I(inode)->i_reserved_data_blocks;

> 
> > 
> > > +

-aneesh
