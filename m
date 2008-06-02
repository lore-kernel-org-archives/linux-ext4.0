From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Need clear buffer_delay after page writeout for
	delayed allocation
Date: Mon, 2 Jun 2008 13:35:27 +0530
Message-ID: <20080602080527.GE26379@skywalker>
References: <1212154769-16486-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212354602.4368.12.camel@localhost.localdomain> <20080602031433.GA17678@skywalker> <1212378632.4368.79.camel@localhost.localdomain> <20080602040934.GB17678@skywalker> <1212385116.4368.90.camel@localhost.localdomain> <20080602063519.GA26379@skywalker> <1212390247.4368.107.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:52886 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757742AbYFBIFt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 04:05:49 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m5285Upr003525
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 13:35:30 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m5285DSK860406
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 13:35:16 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id m5285R05007546
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 13:35:27 +0530
Content-Disposition: inline
In-Reply-To: <1212390247.4368.107.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 02, 2008 at 12:04:07AM -0700, Mingming Cao wrote:
> On Mon, 2008-06-02 at 12:05 +0530, Aneesh Kumar K.V wrote:
> > On Sun, Jun 01, 2008 at 10:38:35PM -0700, Mingming Cao wrote:
> > > On Mon, 2008-06-02 at 09:39 +0530, Aneesh Kumar K.V wrote:
> > > > On Sun, Jun 01, 2008 at 08:50:32PM -0700, Mingming Cao wrote:
> > > > > On Mon, 2008-06-02 at 08:44 +0530, Aneesh Kumar K.V wrote:
> > > > > > On Sun, Jun 01, 2008 at 02:10:02PM -0700, Mingming Cao wrote:
> > > > > > > ext4:  Need clear buffer_delay after page writeout for delayed allocation
> > > > > > > 
> > > > > > > From: Mingming Cao <cmm@us.ibm.com>
> > > > > > > 
> > > > > > > Need clear buffer_delay in ext4_da_writepage() after page has been writeout
> > > > > > > 
> > > > > > > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > > > > > > 
> > > > > > > ---
> > > > > > 
> > > > > > We do that in mpage_put_bnr_to_bhs.
> > > > > > 
> > > > > Normally delayed buffer could be cleared in that case, but if allocation
> > > > > failed in __mapge_da_writepages(), it will keep buffer_delay marked and
> > > > > deferring to later ext4_da_writepage() to do block allocation. This
> > > > > patch handles clear bh delay bit in this case.
> > > > > 
> > > > 
> > > > Why not do it in ext4_da_get_block_write then.
> > > 
> > > The buffer head passed to ext4_da_get_block_write() calling from
> > > mpage_da_map_blocks is a dummy one, to store the allocated extent, not
> > > the bh that need map.
> > 
> > 
> > ie true when ext4_da_get_block_write is called via writepages. In
> > that case mpage_put_bnr_to_bhs clears the delay bit properly. How about
> > the changes below.
> > 
> I see your patch below is trying to address how to detect and assign
> blocks with your suggestion(i.e clear delayed bit in get_block). But I
> don;t think it's needed. 
> 
> My last email I mean the buffer head new in mpage_da_map_blocks() is a
> dummy bh, the real buffer head lbh is not passed to get_block. We could
> clear the delayed bit on successful return of get_block,
> mpage_put_bnr_to_bhs() ignore that dummy bh anyway. But that seems
> twisted, unccessary.
> 
> I still think clear the bit in the ext4_da_write_page() is more clean
> way. the original patch clears the delayed bit on success case. 
> 
> For the error case I think we could handle properly by only clear the
> delayed bit if buffer is mapped.


Buffer marked as delay is also mapped
fs/ext4/inode.c

1437                 map_bh(bh_result, inode->i_sb, 0);
1438                 set_buffer_new(bh_result);
1439                 set_buffer_delay(bh_result);



> 
> Mingming
> > 
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 26f3626..9d25255 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -2873,6 +2873,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
> >  		allocated = max_blocks;
> >  	ext4_ext_show_leaf(inode, path);
> >  	__set_bit(BH_Mapped, &bh_result->b_state);
> > +	__clear_bit(BH_Delay, &bh_result->b_state);
> >  	bh_result->b_bdev = inode->i_sb->s_bdev;
> >  	bh_result->b_blocknr = newblock;
> >  out2:
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 2194aa7..2a2f832 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -917,6 +917,7 @@ int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
> >  		goto cleanup;
> > 
> >  	set_buffer_new(bh_result);
> > +	clear_buffer_delay(bh_result);
> >  got_it:
> >  	map_bh(bh_result, inode->i_sb, le32_to_cpu(chain[depth-1].key));
> >  	if (count > blocks_to_boundary)


I think we need only the above chage. since we are using buffer_head new
for block request in writepages. The below change can be dropped. It
handles all the error case.



> > diff --git a/fs/mpage.c b/fs/mpage.c
> > index c107728..0d05d7a 100644
> > --- a/fs/mpage.c
> > +++ b/fs/mpage.c
> > @@ -897,6 +897,14 @@ static void mpage_da_map_blocks(struct mpage_da_data *mpd)
> >  	int err = 0, remain = lbh->b_size;
> >  	sector_t next = lbh->b_blocknr;
> >  	struct buffer_head new;
> > +	int delay_buf = 0;
> > +
> > +	/*
> > +	 * We clear the delay bit in get_block so remember
> > +	 * whether we are doing a delay allocation
> > +	 */
> > +	if (buffer_delay(lbh))
> > +		delay_buf = 1;
> > 
> >  	/*
> >  	 * We consider only non-mapped and non-allocated blocks
> > @@ -926,7 +934,7 @@ static void mpage_da_map_blocks(struct mpage_da_data *mpd)
> >  		 * If blocks are delayed marked, we need to
> >  		 * put actual blocknr and drop delayed bit
> >  		 */
> > -		if (buffer_delay(lbh))
> > +		if (delay_buf)
> >  			mpage_put_bnr_to_bhs(mpd, next, &new);
> > 
> >  		/* go for the remaining blocks */
> > 
> 

-aneesh
