From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC]Ext4: journal credits reservation fixes for DIO,
	fallocate and delalloc writepages
Date: Tue, 29 Jul 2008 11:54:27 +0530
Message-ID: <20080729062427.GC4545@skywalker>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker> <1216774311.6505.4.camel@mingming-laptop> <20080723074226.GA15091@skywalker> <1217014002.6322.29.camel@mingming-laptop> <20080728161156.GB4545@skywalker> <1217272053.6379.7.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso <tytso@mit.edu>, Shehjar Tikoo <shehjart@cse.unsw.edu.au>,
	linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:47826 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbYG2GZ1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jul 2008 02:25:27 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m6T6PUOT020470
	for <linux-ext4@vger.kernel.org>; Tue, 29 Jul 2008 16:25:30 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6T6P7cM227684
	for <linux-ext4@vger.kernel.org>; Tue, 29 Jul 2008 16:25:07 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6T6P6mR021087
	for <linux-ext4@vger.kernel.org>; Tue, 29 Jul 2008 16:25:07 +1000
Content-Disposition: inline
In-Reply-To: <1217272053.6379.7.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 28, 2008 at 12:07:33PM -0700, Mingming Cao wrote:
.....

> > > > >   *
> > > > > @@ -1142,13 +1133,13 @@ int ext4_get_block(struct inode *inode, 
> > > > >  	handle_t *handle = ext4_journal_current_handle();
> > > > >  	int ret = 0, started = 0;
> > > > >  	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
> > > > > +	int dio_credits = EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
> > > > 
> > > > Again this should be
> > > > 	int dio_credits = ext4_writeblocks_trans(inode, DIO_MAX_BLOCKS);
> > > > 
> > > No. DIO case is different than writepages(). When get_block() is called
> > > from DIO path, the get_block()  is called in a loop, and the credit is
> > > reserved inside the loop. Each time get_block(),will return a single
> > > extent, so we should use   EXT4_DATA_TRANS_BLOCKS(inode->i_sb) which is
> > > calculate a single chunk of allocation credits.
> > 
> > 
> > That is true only for extent format. With noextents we need something
> > like below
> > 
> 
> Not really, even with non extent format block allocation, ext4_get_block() will only allocate/map a chunk of contiguous blocks (i.e. an extent), so it will not hit the worse case.
> 
> > if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
> > 	dio_credits = ext4_writeblocks_trans_credits_old(inode, max_blocks);
> > else {
> > 	/*
> > 	 * For extent format get_block return only one extent
> > 	 */
> > 	dio_credits = EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
> > }
> > 
> > 
> 

but dio_credits = EXT4_DATA_TRANS_BLOCKS(inode->i_sb);  doesn't account
for updating the bitmap and group descriptor related to all indirect and
dindirect and tindirect blocks allocated.

We actually need
a) 1 bitmap for the blocks allocatted
b) 1 group desc for the blocks allocatted
c) 2 indirect
d) 2 dindirect
e) 1 tindirect
f) 5 bitmap for the indirect blocks allocated (2 + 2 + 1)
g) 5 group desc for the indirect blocks allocated
h) 1 inode
i) 1 super blocks
j) 2 * EXT4_QUOTA_TRANS_BLOCKS for quota


-aneesh
