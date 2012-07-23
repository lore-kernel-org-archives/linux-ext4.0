From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [RFC][PATCH 09/10 v1][RESEND] ext4: don't need to writeout all
 dirty pages in punch hole
Date: Mon, 23 Jul 2012 14:20:57 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1207231354220.20857@localhost>
References: <1342943986-12413-1-git-send-email-wenqing.lz@taobao.com> <1342943986-12413-10-git-send-email-wenqing.lz@taobao.com> <alpine.LFD.2.00.1207231249020.20857@localhost> <20120723115722.GA3363@gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1613626456-1343046061=:20857"
Cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xiaoqiangnk@gmail.com, achender@linux.vnet.ibm.com,
	wenqing.lz@taobao.com
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120723115722.GA3363@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1613626456-1343046061=:20857
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 23 Jul 2012, Zheng Liu wrote:

> Date: Mon, 23 Jul 2012 19:57:22 +0800
> From: Zheng Liu <gnehzuil.liu@gmail.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
>     xiaoqiangnk@gmail.com, achender@linux.vnet.ibm.com, wenqing.lz@taobao.com
> Subject: Re: [RFC][PATCH 09/10 v1][RESEND] ext4: don't need to writeout all
>     dirty pages in punch hole
> 
> Hi Lukas,
> 
> On Mon, Jul 23, 2012 at 01:01:53PM +0200, Lukáš Czerner wrote:
> > On Sun, 22 Jul 2012, Zheng Liu wrote:
> > 
> > > Date: Sun, 22 Jul 2012 15:59:45 +0800
> > > From: Zheng Liu <gnehzuil.liu@gmail.com>
> > > To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
> > > Cc: xiaoqiangnk@gmail.com, achender@linux.vnet.ibm.com, wenqing.lz@taobao.com
> > > Subject: [RFC][PATCH 09/10 v1][RESEND] ext4: don't need to writeout all dirty
> > >     pages in punch hole
> > > 
> > > From: Zheng Liu <wenqing.lz@taobao.com>
> > > 
> > > Now we don't need to writeout all dirty pages when punching a hole.  The i_mutex
> > > locking is taken to avoid concurrent writes.  In truncate_pagecache_range, all
> > > pages in this hole is released, and ext4_es_remove_space is called to update
> > > extent status tree. 
> > 
> > Hi Zheng,
> > 
> > I am currently in the middle of reworking punch hole for ext4 so
> > there will be some changes in this area. See the patch set
> > 
> > http://www.spinics.net/lists/linux-ext4/msg33014.html
> 
> Thank you for your reminding.  I have seen your patch set and it is
> pretty cool.  IMHO your patch set shall be merged into upstream kernel
> before applying io tree because io tree still has a lot of things that
> needs to be done.  So I will change it according to your patches. :-)

Great, thanks!

> 
> > Moreover I think that we should avoid taking i_mutex if we can and I
> > believe that we can in this case, because we only need to prevent
> > allocation. So I just want to let you know that this part is
> > probably going to change anyway.
> 
> It seems that we need to take i_mutex locking to prevent from buffered
> writes after page cache has been truncated by truncate_pagecache_range.
> If a buffered write without delalloc occurs after truncating page cache
> and before taking i_data_sem, that means that the allocated block for
> this buffered write will be removed in ext4_ext_remove_space when the
> offset is within the range of the hole.  Am I missing something?

You're absolutely right, currently this is possible. But I think that we
can take i_data_sem before truncating the pagecache hence preventing anyone
from mapping new blocks. However this is not yet implemented in my
patch set.

...
hmm, looking at the ext4_write_begin() it seems like it might not be
such good idea after all. It seems to take page lock before
i_data_sem so we might get deadlock, moreover if the punch hole
happened in the middle of the ext4_write_begin() we might have only
part of the data written, moreover this does not have to be hole
aligned, which is bad. I need to revise that.

Thanks!
-Lukas


> 
> Regards,
> Zheng
> 
> > > 
> > > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > > ---
> > >  fs/ext4/extents.c |   28 ++++++++++++----------------
> > >  1 files changed, 12 insertions(+), 16 deletions(-)
> > > 
> > > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > > index f2c5294..2a526b4 100644
> > > --- a/fs/ext4/extents.c
> > > +++ b/fs/ext4/extents.c
> > > @@ -4529,9 +4529,11 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
> > >  	loff_t first_page_offset, last_page_offset;
> > >  	int credits, err = 0;
> > >  
> > > +	mutex_lock(&inode->i_mutex);
> > > +
> > >  	/* No need to punch hole beyond i_size */
> > >  	if (offset >= inode->i_size)
> > > -		return 0;
> > > +		goto error;
> > >  
> > >  	/*
> > >  	 * If the hole extends beyond i_size, set the hole
> > > @@ -4549,18 +4551,6 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
> > >  	first_page_offset = first_page << PAGE_CACHE_SHIFT;
> > >  	last_page_offset = last_page << PAGE_CACHE_SHIFT;
> > >  
> > > -	/*
> > > -	 * Write out all dirty pages to avoid race conditions
> > > -	 * Then release them.
> > > -	 */
> > > -	if (mapping->nrpages && mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
> > > -		err = filemap_write_and_wait_range(mapping,
> > > -			offset, offset + length - 1);
> > > -
> > > -		if (err)
> > > -			return err;
> > > -	}
> > > -
> > >  	/* Now release the pages */
> > >  	if (last_page_offset > first_page_offset) {
> > >  		truncate_pagecache_range(inode, first_page_offset,
> > > @@ -4572,12 +4562,14 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
> > >  
> > >  	credits = ext4_writepage_trans_blocks(inode);
> > >  	handle = ext4_journal_start(inode, credits);
> > > -	if (IS_ERR(handle))
> > > -		return PTR_ERR(handle);
> > > +	if (IS_ERR(handle)) {
> > > +		err = PTR_ERR(handle);
> > > +		goto error;
> > > +	}
> > >  
> > >  	err = ext4_orphan_add(handle, inode);
> > >  	if (err)
> > > -		goto out;
> > > +		goto error;
> > >  
> > >  	/*
> > >  	 * Now we need to zero out the non-page-aligned data in the
> > > @@ -4652,6 +4644,8 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
> > >  	ext4_ext_invalidate_cache(inode);
> > >  	ext4_discard_preallocations(inode);
> > >  
> > > +	err = ext4_es_remove_space(inode, first_block,
> > > +				   stop_block - first_block);
> > >  	err = ext4_ext_remove_space(inode, first_block, stop_block - 1);
> > >  
> > >  	ext4_ext_invalidate_cache(inode);
> > > @@ -4667,6 +4661,8 @@ out:
> > >  	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
> > >  	ext4_mark_inode_dirty(handle, inode);
> > >  	ext4_journal_stop(handle);
> > > +error:
> > > +	mutex_unlock(&inode->i_mutex);
> > >  	return err;
> > >  }
> > >  int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> > > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-1613626456-1343046061=:20857--
