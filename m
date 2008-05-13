From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] jbd_commit_transaction() races with
	journal_try_to_drop_buffers() causing DIO failures
Date: Tue, 13 May 2008 09:37:37 -0700
Message-ID: <1210696657.3638.7.camel@localhost.localdomain>
References: <20080428122626.GC17054@duck.suse.cz>
	 <1209402694.23575.5.camel@badari-desktop>
	 <20080428180932.GI17054@duck.suse.cz>
	 <1209409764.11872.6.camel@localhost.localdomain>
	 <20080429124321.GD1987@duck.suse.cz>
	 <1209654981.27240.19.camel@badari-desktop>
	 <20080505170636.GK25722@duck.suse.cz>
	 <1210372072.3639.52.camel@localhost.localdomain>
	 <20080512155419.GD15856@duck.suse.cz>
	 <1210639184.3661.43.camel@localhost.localdomain>
	 <20080513145449.GC20806@duck.suse.cz>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Badari Pulavarty <pbadari@us.ibm.com>, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760101AbYEMQiA@vger.kernel.org>
In-Reply-To: <20080513145449.GC20806@duck.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2008-05-13 at 16:54 +0200, Jan Kara wrote:
> On Mon 12-05-08 17:39:43, Mingming Cao wrote:
> > Index: linux-2.6.26-rc1/fs/ext3/inode.c
> > ===================================================================
> > --- linux-2.6.26-rc1.orig/fs/ext3/inode.c	2008-05-03 11:59:44.000000000 -0700
> > +++ linux-2.6.26-rc1/fs/ext3/inode.c	2008-05-12 12:41:27.000000000 -0700
> > @@ -1766,6 +1766,23 @@ static int ext3_journalled_set_page_dirt
> >  	return __set_page_dirty_nobuffers(page);
> >  }
> >  
> > +static int ext3_launder_page(struct page *page)
> > +{
> > +        int ret;
> > +	int retry = 5;
> > +
> > +	while (retry --) {
> > +		ret = ext3_releasepage(page, GFP_KERNEL);
> > +		if (ret == 1)
> > +			break;
> > +		else
> > +			schedule();
> > +	}
> > +
> > +        return ret;
> > +}
> > +
> > +
>   Yes, I meant something like this. We could be more clever and do:
> 
> 	head = bh = page_buffers(page);
> 	do {
> 		wait_on_buffer(bh);
> 		bh = bh->b_this_page;
> 	} while (bh != head);
> 	/*
> 	 * Now commit code should have been able to proceed and release
>          * those buffers
> 	 */
>         schedule();
> 
Thanks.
We could recheck if buffer_busy() before calling wait_on_buffer(bh) to
wait for buffer unlocked. This will handles the mapped IO re-dirty race
case, but still need the schedule() and retry to handle the buffered IO
race.

> 
> or we could do simple:
> 	log_wait_commit(...);
> 
> That would impose larger perf. penalty but on the other hand you shouldn't
> hit this path too often.

My concern with doing log_wait_commit() here is the perf penalty. In the
case the buffers is at the end of the queue to commit, we have to wait
for all other previous transactions to finish committing before we could
continue...

>  But maybe the code above would be fine and would
> handle most cases. Also please add a big comment to that function to explain
> why this magic is needed.
> 
Will do.
> >  static const struct address_space_operations ext3_ordered_aops = {
> >  	.readpage	= ext3_readpage,
> >  	.readpages	= ext3_readpages,
> > @@ -1778,6 +1795,7 @@ static const struct address_space_operat
> >  	.releasepage	= ext3_releasepage,
> >  	.direct_IO	= ext3_direct_IO,
> >  	.migratepage	= buffer_migrate_page,
> > +	.launder_page	= ext3_launder_page,
> >  };
> >  
> >  static const struct address_space_operations ext3_writeback_aops = {
> > @@ -1792,6 +1810,7 @@ static const struct address_space_operat
> >  	.releasepage	= ext3_releasepage,
> >  	.direct_IO	= ext3_direct_IO,
> >  	.migratepage	= buffer_migrate_page,
> > +	.launder_page	= ext3_launder_page,
> >  };
> >  
> >  static const struct address_space_operations ext3_journalled_aops = {
> > @@ -1805,6 +1824,7 @@ static const struct address_space_operat
> >  	.bmap		= ext3_bmap,
> >  	.invalidatepage	= ext3_invalidatepage,
> >  	.releasepage	= ext3_releasepage,
> > +	.launder_page	= ext3_launder_page,
> >  };
> >  
> >  void ext3_set_aops(struct inode *inode)
>   Actually, we need .launder_page callback only in data=order mode.
> data=writeback mode doesn't need it at all (journal code doesn't touch data
> buffers there) and for data=journal mode DIO could have never worked
> reasonably when mixed with buffered IO and it would have to do a different
> and much more expensive trickery (like flushing the journal, or at least
> forcing current transaction to commit).
> 

You are right, thanks for pointing this out.
Will post an updated patch.

Mingming
