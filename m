From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH updated] ext4: Handle page without buffers in
	ext4_*_writepage()
Date: Tue, 1 Jul 2008 08:52:50 +0530
Message-ID: <20080701032250.GA16596@skywalker>
References: <1214820374-5464-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1214848688.6637.24.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, sandeen@redhat.com, jack@suse.cz,
	linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:58274 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbYGADXF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Jun 2008 23:23:05 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m613MNUx004115
	for <linux-ext4@vger.kernel.org>; Tue, 1 Jul 2008 13:22:23 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m613Mb2I3735642
	for <linux-ext4@vger.kernel.org>; Tue, 1 Jul 2008 13:22:38 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m613N2OY021113
	for <linux-ext4@vger.kernel.org>; Tue, 1 Jul 2008 13:23:02 +1000
Content-Disposition: inline
In-Reply-To: <1214848688.6637.24.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 30, 2008 at 10:58:08AM -0700, Mingming Cao wrote:
> 
> On Mon, 2008-06-30 at 15:36 +0530, Aneesh Kumar K.V wrote:
> > From: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
> > 
> > It can happen that buffers are removed from the page before it gets
> > marked dirty and then is passed to writepage(). In writepage()
> > we just initialize the buffers and check whether they are mapped and non
> > delay. If they are mapped and non delay we write the page. Otherwise we
> > mark then dirty. With this change we don't do block allocation at all in
> > ext4_*_write_page.
> 
> Probably should update the mpage_da_map_blocks() in mpage.c to indicate
> that the failure of block allocation in da_writepages() are no longer
> deferred to ext4_da_writepage(), as with this change we just simply
> re-dirty the page later in ext4_da_writepage()


mpage_da_map_blocks() being the  VFS helper function  I guess we should
not update that. It is correct even now that when we fail to get blocks in
mpage_da_map_blocks we expect the writepage of the file system to handle
that. With ext4 we redirty the page. Other file system which want to use
the mpage_da_map_blocks()/delayed allocation helper can choose to
implement error handling/block allocation in writepage()


> 
> > 
> > writepage() get called under many condition and with a locking order
> > of journal_start -> lock_page we shouldnot try to allocate blocks in
> > writepage() which get called after taking page lock. writepage can get
> > called via shrink_page_list even with a journal handle which was created
> > for doing inode update. For example when doing ext4_da_write_begin we
> > create a journal handle with credit 1 expecting a i_disksize update for
> > the inode. But ext4_da_write_begin can cause shrink_page_list via
> > _grab_page_cache. So having a valid handle via ext4_journal_current_handle
> > is not a guarantee that we can use the handle for block allocation in
> > writepage. We should not be using credits which are taken for other updates.
> > That would result in we running out of credits when we update inodes.
> > 
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> >  fs/ext4/inode.c |  169 ++++++++++++++++++++++++++++++++++++++++---------------
> >  1 files changed, 124 insertions(+), 45 deletions(-)
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index cd5c165..18af94a 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -1591,11 +1591,15 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
> >  	handle_t *handle = NULL;
> > 
> >  	handle = ext4_journal_current_handle();
> > -	BUG_ON(handle == NULL);
> > -	BUG_ON(create == 0);
> > -
> > -	ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
> > +	if (!handle) {
> > +		ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
> > +				   bh_result, 0, 0, 0);
> > +		BUG_ON(!ret);
> > +	} else {
> > +		ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
> >  				   bh_result, create, 0, EXT4_DELALLOC_RSVED);
> > +	}
> > +
> >  	if (ret > 0) {
> >  		bh_result->b_size = (ret << inode->i_blkbits);
> > 
> 
> With this set of changes (that ext4_da_get_block_write() no longer
> called from ext4_da_writepage()), would it still possible to calling
> ext4_da_get_block_write() without a journal handle?

ext4_da_get_block_write cannot be called without a journal handle. But I
have to double check the call path. I guess if you consider
ext4_da_get_block_write as a helper API it make sense to add code paths
for !handle also. It states that if you call this helper without a
handle better make sure all the buffer_heads are mapped.

> 
> > @@ -1633,15 +1637,37 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
> > 
> >  static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
> >  {
> > -	return !buffer_mapped(bh) || buffer_delay(bh);
> > +	/*
> > +	 * unmapped buffer is possible for holes.
> > +	 * delay buffer is possible with delayed allocation
> > +	 */
> > +	return ((!buffer_mapped(bh) || buffer_delay(bh)) && buffer_dirty(bh));
> > +}
> > +
> > +static int ext4_normal_get_block_write(struct inode *inode, sector_t iblock,
> > +				   struct buffer_head *bh_result, int create)
> > +{
> > +	int ret = 0;
> > +	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
> > +
> > +	/*
> > +	 * we don't want to do block allocation in writepage
> > +	 * so call get_block_wrap with create = 0
> > +	 */
> > +	ret = ext4_get_blocks_wrap(NULL, inode, iblock, max_blocks,
> > +				   bh_result, 0, 0, 0);
> > +	if (ret > 0) {
> > +		bh_result->b_size = (ret << inode->i_blkbits);
> > +		ret = 0;
> > +	}
> > +	return ret;
> >  }
> > 
> 
> Here we pass create = 0 to get_block all the time in ext4_**_writepage()
> all the time. Just wondering what about writeout those unwritten
> extents(preallocated extent) to disk? We need to pass create=1 to
> convert it to initialized extent and do proper split if needed.  Does
> this convertion/split get done via ext4_da_get_block_write() from
> ext4_da_writepages()? 


Yes. That get done via writepages() (pdflush) for delayed allocation and via
write_begin/write_end/page_mkwrite for non delayed allocation.



> 
> >  /*
> > - * get called vi ext4_da_writepages after taking page lock
> > - * We may end up doing block allocation here in case
> > - * mpage_da_map_blocks failed to allocate blocks.
> > - *
> > - * We also get called via journal_submit_inode_data_buffers
> > + * get called vi ext4_da_writepages after taking page lock (have journal handle)
> > + * get called via journal_submit_inode_data_buffers (no journal handle)
> > + * get called via shrink_page_list via pdflush (no journal handle)
> > + * or grab_page_cache when doing write_begin (have journal handle)
> >   */
> >  static int ext4_da_writepage(struct page *page,
> >  				struct writeback_control *wbc)
> > @@ -1649,37 +1675,61 @@ static int ext4_da_writepage(struct page *page,
> >  	int ret = 0;
> >  	loff_t size;
> >  	unsigned long len;
> > -	handle_t *handle = NULL;
> >  	struct buffer_head *page_bufs;
> >  	struct inode *inode = page->mapping->host;
> > 
> > -	handle = ext4_journal_current_handle();
> > -	if (!handle) {
> > -		/*
> > -		 * This can happen when we aren't called via
> > -		 * ext4_da_writepages() but directly (shrink_page_list).
> > -		 * We cannot easily start a transaction here so we just skip
> > -		 * writing the page in case we would have to do so.
> > -		 * We reach here also via journal_submit_inode_data_buffers
> > -		 */
> > -		size = i_size_read(inode);
> > +	size = i_size_read(inode);
> > +	if (page->index == size >> PAGE_CACHE_SHIFT)
> > +		len = size & ~PAGE_CACHE_MASK;
> > +	else
> > +		len = PAGE_CACHE_SIZE;
> > 
> > +	if (page_has_buffers(page)) {
> >  		page_bufs = page_buffers(page);
> > -		if (page->index == size >> PAGE_CACHE_SHIFT)
> > -			len = size & ~PAGE_CACHE_MASK;
> > -		else
> > -			len = PAGE_CACHE_SIZE;
> > -
> > -		if (walk_page_buffers(NULL, page_bufs, 0,
> > -				len, NULL, ext4_bh_unmapped_or_delay)) {
> > +		if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
> > +					ext4_bh_unmapped_or_delay)) {
> >  			/*
> > -			 * We can't do block allocation under
> > -			 * page lock without a handle . So redirty
> > -			 * the page and return
> > +			 * We don't want to do  block allocation
> > +			 * So redirty the page and return
> >  			 * We may reach here when we do a journal commit
> >  			 * via journal_submit_inode_data_buffers.
> >  			 * If we don't have mapping block we just ignore
> > -			 * them
> > +			 * them. We can also reach here via shrink_page_list
> > +			 */
> > +			redirty_page_for_writepage(wbc, page);
> > +			unlock_page(page);
> > +			return 0;
> > +		}
> > +	} else {
> > +		/*
> > +		 * The test for page_has_buffers() is subtle:
> > +		 * We know the page is dirty but it lost buffers. That means
> > +		 * that at some moment in time after write_begin()/write_end()
> > +		 * has been called all buffers have been clean and thus they
> > +		 * must have been written at least once. So they are all
> > +		 * mapped and we can happily proceed with mapping them
> > +		 * and writing the page.
> > +		 *
> > +		 * Try to initialize the buffer_heads and check whether
> > +		 * all are mapped and non delay. We don't want to
> > +		 * do block allocation here.
> > +		 */
> > +		ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
> > +						ext4_normal_get_block_write);
> > +		if (!ret) {
> > +			page_bufs = page_buffers(page);
> > +			/* check whether all are mapped and non delay */
> > +			if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
> > +						ext4_bh_unmapped_or_delay)) {
> > +				redirty_page_for_writepage(wbc, page);
> > +				unlock_page(page);
> > +				return 0;
> > +			}
> > +		} else {
> > +			/*
> > +			 * We can't do block allocation here
> > +			 * so just redity the page and unlock
> > +			 * and return
> >  			 */
> >  			redirty_page_for_writepage(wbc, page);
> >  			unlock_page(page);
> > @@ -1688,9 +1738,11 @@ static int ext4_da_writepage(struct page *page,
> >  	}
> > 
> >  	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
> > -		ret = nobh_writepage(page, ext4_da_get_block_write, wbc);
> > +		ret = nobh_writepage(page, ext4_normal_get_block_write, wbc);
> >  	else
> > -		ret = block_write_full_page(page, ext4_da_get_block_write, wbc);
> > +		ret = block_write_full_page(page,
> > +						ext4_normal_get_block_write,
> > +						wbc);
> > 
> >  	return ret;
> >  }
> > @@ -2031,12 +2083,14 @@ static int __ext4_normal_writepage(struct page *page,
> >  	struct inode *inode = page->mapping->host;
> > 
> >  	if (test_opt(inode->i_sb, NOBH))
> > -		return nobh_writepage(page, ext4_get_block, wbc);
> > +		return nobh_writepage(page,
> > +					ext4_normal_get_block_write, wbc);
> >  	else
> > -		return block_write_full_page(page, ext4_get_block, wbc);
> > +		return block_write_full_page(page,
> > +						ext4_normal_get_block_write,
> > +						wbc);
> >  }
> > 
> 
> I am wondering how does non-delayed ordered mode handling initialization
> the unwritten extent here, with about change that does not pass create =
> 1 to underlying ext4_get_block_wrap()? 


writepages() will call get_block_wrap with create = 1


> 
> Also a little puzzled why we need to fix here for non-delayed allocation
> writepage(): blocks are all allocated at prepare_write() time, with
> page_mkwrite this is also true for mmaped IO. So we shouldn't get into
> the case that we need to do block allocation in ext4_normal_writepage()
> called from non-delayed path?


Just to make in clear in code that we don't do block allocation at all in
writepage. If you consider ext4_normal_writepage as a helper API it kind
of makes it clear that  irrespective of journal_handle we are not going
to make any block allocation in ext4_normal_Writepage.


> > 
> > -
> >  static int ext4_normal_writepage(struct page *page,
> >  				struct writeback_control *wbc)
> >  {
> > @@ -2045,13 +2099,24 @@ static int ext4_normal_writepage(struct page *page,
> >  	loff_t len;
> > 
> >  	J_ASSERT(PageLocked(page));
> > -	J_ASSERT(page_has_buffers(page));
> >  	if (page->index == size >> PAGE_CACHE_SHIFT)
> >  		len = size & ~PAGE_CACHE_MASK;
> >  	else
> >  		len = PAGE_CACHE_SIZE;
> > -	BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
> > -				 ext4_bh_unmapped_or_delay));
> > +
> > +	if (page_has_buffers(page)) {
> > +		/* if page has buffers it should all be mapped
> > +		 * and allocated. If there are not buffers attached
> > +		 * to the page we know the page is dirty but it lost
> > +		 * buffers. That means that at some moment in time
> > +		 * after write_begin() / write_end() has been called
> > +		 * all buffers have been clean and thus they must have been
> > +		 * written at least once. So they are all mapped and we can
> > +		 * happily proceed with mapping them and writing the page.
> > +		 */
> > +		BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
> > +					ext4_bh_unmapped_or_delay));
> > +	}
> > 
> >  	if (!ext4_journal_current_handle())
> >  		return __ext4_normal_writepage(page, wbc);
> > @@ -2071,7 +2136,8 @@ static int __ext4_journalled_writepage(struct page *page,
> >  	int ret = 0;
> >  	int err;
> > 
> > -	ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE, ext4_get_block);
> > +	ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
> > +					ext4_normal_get_block_write);
> >  	if (ret != 0)
> >  		goto out_unlock;
> > 
> > @@ -2118,13 +2184,24 @@ static int ext4_journalled_writepage(struct page *page,
> >  	loff_t len;
> > 
> >  	J_ASSERT(PageLocked(page));
> > -	J_ASSERT(page_has_buffers(page));
> >  	if (page->index == size >> PAGE_CACHE_SHIFT)
> >  		len = size & ~PAGE_CACHE_MASK;
> >  	else
> >  		len = PAGE_CACHE_SIZE;
> > -	BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
> > -				 ext4_bh_unmapped_or_delay));
> > +
> > +	if (page_has_buffers(page)) {
> > +		/* if page has buffers it should all be mapped
> > +		 * and allocated. If there are not buffers attached
> > +		 * to the page we know the page is dirty but it lost
> > +		 * buffers. That means that at some moment in time
> > +		 * after write_begin() / write_end() has been called
> > +		 * all buffers have been clean and thus they must have been
> > +		 * written at least once. So they are all mapped and we can
> > +		 * happily proceed with mapping them and writing the page.
> > +		 */
> > +		BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
> > +					ext4_bh_unmapped_or_delay));
> > +	}
> > 
> >  	if (ext4_journal_current_handle())
> >  		goto no_write;
> > @@ -2142,7 +2219,9 @@ static int ext4_journalled_writepage(struct page *page,
> >  		 * really know unless we go poke around in the buffer_heads.
> >  		 * But block_write_full_page will do the right thing.
> >  		 */
> > -		return block_write_full_page(page, ext4_get_block, wbc);
> > +		return block_write_full_page(page,
> > +						ext4_normal_get_block_write,
> > +						wbc);
> >  	}
> >  no_write:
> >  	redirty_page_for_writepage(wbc, page);
> 
