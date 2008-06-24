From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Performance of ext4
Date: Tue, 24 Jun 2008 08:37:21 +0530
Message-ID: <20080624030721.GB10469@skywalker>
References: <20080616181353.GA20686@skywalker> <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de> <20080619155645.GA8582@mit.edu> <485A8C2D.1090806@redhat.com> <20080619174211.GB9119@mit.edu> <Pine.LNX.4.64.0806200812340.3383@diagnostix.dwd.de> <20080620085922.GH9119@mit.edu> <Pine.LNX.4.64.0806200905070.3383@diagnostix.dwd.de> <20080623174508.GA7216@skywalker> <1214267492.27507.285.camel@BVR-FS.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Holger Kiehl <Holger.Kiehl@dwd.de>, Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	Solofo.Ramangalahy@bull.net, Nick Dokos <nicholas.dokos@hp.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:39878 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbYFXDHt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jun 2008 23:07:49 -0400
Content-Disposition: inline
In-Reply-To: <1214267492.27507.285.camel@BVR-FS.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 23, 2008 at 05:31:32PM -0700, Mingming wrote:
> 
> On Mon, 2008-06-23 at 23:15 +0530, Aneesh Kumar K.V wrote:
> 
> > I found one place where we fail to update i_disksize. Can you try this
> > patch ?
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 33f940b..9fa737f 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -1620,7 +1620,10 @@ static int ext4_da_writepage(struct page *page,
> >  	loff_t size;
> >  	unsigned long len;
> >  	handle_t *handle = NULL;
> > +	ext4_lblk_t block;
> > +	loff_t disksize;
> >  	struct buffer_head *page_bufs;
> > +	struct buffer_head *bh, *head;
> >  	struct inode *inode = page->mapping->host;
> > 
> >  	handle = ext4_journal_current_handle();
> > @@ -1662,6 +1665,38 @@ static int ext4_da_writepage(struct page *page,
> >  	else
> >  		ret = block_write_full_page(page, ext4_da_get_block_write, wbc);
> > 
> > +	 if (ret)
> > +		 return ret;
> > +	/*
> > +	 * When called via shrink_page_list and if we don't have any unmapped
> > +	 * buffer_head we still could have written some new content in an
> > +	 * already mapped buffer. That means we need to extent i_disksize here
> > +	 */
> 
> In this case(when extend the file without need block allocation),
> wouldn't make sense to update the i_disksize at write_end() time? So
> that the window of i_size different from i_disksize could be much
> smaller in this case.
> 
> 
> Something like below? (untested)

In this case you will have to start a transaction in write_begin . With
the below code transaction is started inside page_lock. Also I don't
think we need needed_blocks credit just 1 should be enough because we
are not doing any block allocation here. We just need to update the
inode block.


-aneesh

> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> ---
>  fs/ext4/inode.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 60 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6.26-rc6/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.26-rc6.orig/fs/ext4/inode.c	2008-06-23 17:28:01.000000000 -0700
> +++ linux-2.6.26-rc6/fs/ext4/inode.c	2008-06-23 17:28:10.000000000 -0700
> @@ -1573,6 +1573,65 @@ static int ext4_da_write_begin(struct fi
>  	return ret;
>  }
> 
> +static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
> +{
> +	return !buffer_mapped(bh) || buffer_delay(bh);
> +}
> +
> +static int ext4_da_write_end(struct file *file,
> +				struct address_space *mapping,
> +				loff_t pos, unsigned len, unsigned copied,
> +				struct page *page, void *fsdata)
> +{
> +	handle_t *handle = NULL;
> +	struct inode *inode = mapping->host;
> +	int needed_blocks = ext4_writepage_trans_blocks(inode);
> +	unsigned from, to;
> +	int ret = 0, ret2;
> +
> +	from = pos & (PAGE_CACHE_SIZE - 1);
> +	to = from + len;
> +
> +	if (ret == 0) {
> +		/*
> +		 * generic_write_end() will run mark_inode_dirty() if i_size
> +		 * changes.  So let's piggyback the i_disksize mark_inode_dirty
> +		 * into that.
> +		 */
> +		loff_t new_i_size;
> +
> +		new_i_size = pos + copied;
> +		if (new_i_size > EXT4_I(inode)->i_disksize)
> +			if (!walk_page_buffers(NULL, page_buffers(page),
> +					       0, len, NULL, ext4_bh_unmapped_or_delay)){
> +				/*
> +				 * Updating i_disksize when extending file without
> +				 * need block allocation
> +				 */
> +        			handle = ext4_journal_start(inode, needed_blocks);
> +				if (IS_ERR(handle)) {
> +			                ret = PTR_ERR(handle);
> +			                return ret;
> +				}
> +				if (ext4_should_order_data(inode))
> +					ret = ext4_jbd2_file_inode(handle, inode);
> +
> +				EXT4_I(inode)->i_disksize = new_i_size;
> +			}
> +		ret2 = generic_write_end(file, mapping, pos, len, copied,
> +							page, fsdata);
> +		copied = ret2;
> +		if (ret2 < 0)
> +			ret = ret2;
> +	}
> +	if (handle)
> +		ret2 = ext4_journal_stop(handle);
> +	if (!ret)
> +		ret = ret2;
> +
> +	return ret ? ret : copied;
> +}
> +
>  static void ext4_da_invalidatepage(struct page *page, unsigned long offset)
>  {
>  	struct buffer_head *head, *bh;
> @@ -1682,11 +1741,6 @@ static int bput_one(handle_t *handle, st
>  	return 0;
>  }
> 
> -static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
> -{
> -	return !buffer_mapped(bh) || buffer_delay(bh);
> -}
> -
>  /*
>   * Note that we don't need to start a transaction unless we're journaling data
>   * because we should have holes filled from ext4_page_mkwrite(). We even don't
> @@ -2050,7 +2104,7 @@ static const struct address_space_operat
>  	.writepages	= ext4_da_writepages,
>  	.sync_page	= block_sync_page,
>  	.write_begin	= ext4_da_write_begin,
> -	.write_end	= generic_write_end,
> +	.write_end	= ext4_da_write_end,
>  	.bmap		= ext4_bmap,
>  	.invalidatepage	= ext4_da_invalidatepage,
>  	.releasepage	= ext4_releasepage,
> 
> 
