From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: BUG with delayed allocation
Date: Thu, 20 Mar 2008 10:29:50 -0700
Message-ID: <1206034190.3637.25.camel@localhost.localdomain>
References: <20080319085235.GA6752@skywalker>
	 <1205974018.3637.9.camel@localhost.localdomain>
	 <20080320053902.GD6967@skywalker>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50291 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758087AbYCTR36 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Mar 2008 13:29:58 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m2KHVvxF024421
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 13:31:57 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2KHTtfj277400
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 13:29:55 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2KHTs2L024494
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 13:29:55 -0400
In-Reply-To: <20080320053902.GD6967@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-03-20 at 11:09 +0530, Aneesh Kumar K.V wrote:

> > Could you try the following patch? It updates the i_disksize at the
> > write_end time.
> > 
> 
> I will test the patch and update you. BTW shouldn't we update
> i_disksize only after actual block got allocated ?
> 
> 
Hmm...I am not  100% sure but I think we should not to change the
behavior that the on-disk inode size should be updated when write()
returns to user. Right now the in-memory inode size is updated, user
would expecting the same when they run e2fsck, but e2fsck reads inode
size from disk. Pushing the inode i_disksize update at the writeout
(allocation) time will cause the window that i_size is different than
the i_disksize being enlarged quite big.

Mingming
> > 
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > ---
> >  fs/ext4/inode.c |   39 ++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 38 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6.25-rc5/fs/ext4/inode.c
> > ===================================================================
> > --- linux-2.6.25-rc5.orig/fs/ext4/inode.c	2008-03-19 17:32:44.000000000 -0700
> > +++ linux-2.6.25-rc5/fs/ext4/inode.c	2008-03-19 17:43:19.000000000 -0700
> > @@ -1355,6 +1355,43 @@ static int ext4_writeback_write_end(stru
> >  	return ret ? ret : copied;
> >  }
> > 
> > +static int ext4_da_write_end(struct file *file,
> > +				struct address_space *mapping,
> > +				loff_t pos, unsigned len, unsigned copied,
> > +				struct page *page, void *fsdata)
> > +{
> > +	handle_t *handle;
> > +	struct inode *inode = file->f_mapping->host;
> > +	int needed_blocks = ext4_writepage_trans_blocks(inode);
> > +	int ret = 0, ret2;
> > +	loff_t new_i_size;
> > +
> > +	handle = ext4_journal_start(inode, needed_blocks);
> > +	if (IS_ERR(handle)) {
> > +		unlock_page(page);
> > +		page_cache_release(page);
> > +		ret = PTR_ERR(handle);
> > +		return ret;
> > +	}
> > +
> > +	new_i_size = pos + copied;
> > +	if (new_i_size > EXT4_I(inode)->i_disksize)
> > +		EXT4_I(inode)->i_disksize = new_i_size;
> > +
> > +	copied = ext4_generic_write_end(file, mapping, pos, len, copied,
> > +							page, fsdata);
> > +	if (copied < 0)
> > +		ret = copied;
> > +
> > +	ret2 = ext4_journal_stop(handle);
> > +	if (!ret)
> > +		ret = ret2;
> > +	unlock_page(page);
> > +	page_cache_release(page);
> > +
> > +	return ret ? ret : copied;
> > +}
> > +
> >  static int ext4_journalled_write_end(struct file *file,
> >  				struct address_space *mapping,
> >  				loff_t pos, unsigned len, unsigned copied,
> > @@ -2020,7 +2057,7 @@ static const struct address_space_operat
> >  	.writepages	= ext4_da_writepages,
> >  	.sync_page	= block_sync_page,
> >  	.write_begin	= ext4_da_write_begin,
> > -	.write_end	= generic_write_end,
> > +	.write_end	= ext4_da_write_end,
> >  	.bmap		= ext4_bmap,
> >  	.invalidatepage	= ext4_da_invalidatepage,
> >  	.releasepage	= ext4_releasepage,
> > 
> > 
> 
> -aneesh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

