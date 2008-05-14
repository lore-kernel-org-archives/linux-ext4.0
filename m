From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] jbd_commit_transaction() races with
	journal_try_to_drop_buffers() causing DIO failures
Date: Wed, 14 May 2008 10:41:12 -0700
Message-ID: <1210786872.3657.48.camel@localhost.localdomain>
References: <20080428180932.GI17054@duck.suse.cz>
	 <1209409764.11872.6.camel@localhost.localdomain>
	 <20080429124321.GD1987@duck.suse.cz>
	 <1209654981.27240.19.camel@badari-desktop>
	 <20080505170636.GK25722@duck.suse.cz>
	 <1210372072.3639.52.camel@localhost.localdomain>
	 <20080512155419.GD15856@duck.suse.cz>
	 <1210639184.3661.43.camel@localhost.localdomain>
	 <20080513145449.GC20806@duck.suse.cz>
	 <1210717389.3638.24.camel@localhost.localdomain>
	 <20080514170856.GH24363@duck.suse.cz>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Badari Pulavarty <pbadari@us.ibm.com>, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37910 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbYENRlV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 May 2008 13:41:21 -0400
In-Reply-To: <20080514170856.GH24363@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2008-05-14 at 19:08 +0200, Jan Kara wrote:
> On Tue 13-05-08 15:23:09, Mingming Cao wrote:
> > On Tue, 2008-05-13 at 16:54 +0200, Jan Kara wrote:
> > > On Mon 12-05-08 17:39:43, Mingming Cao wrote:
> > > > On Mon, 2008-05-12 at 17:54 +0200, Jan Kara wrote:
> > > > Does this match what you are thinking? It certainly slow down the DIO
> > > > path, but the positive side is it doesn't disturb the other code path...
> > > > thanks for your feedback!
> > > > 
> > > > --------------------------------------------
> > > > 
> > > > An unexpected EIO error gets returned when writing to a file
> > > > using buffered writes and DIO writes at the same time.
> > > > 
> > > > We found there are a number of places where journal_try_to_free_buffers()
> > > > could race with journal_commit_transaction(), the later still
> > > > helds the reference to the buffers on the t_syncdata_list or t_locked_list
> > > > , while journal_try_to_free_buffers() tries to free them, which resulting an EIO
> > > > error returns back to the dio caller. 
> > > > 
> > > > The logic fix is to retry freeing if journal_try_to_free_buffers() to failed
> > > > to free those data buffers while journal_commit_transaction() is still
> > > > reference those buffers.
> > > > This is done via implement ext3 launder_page() callback, instead of inside
> > > > journal_try_to_free_buffers() itself, so that it doesn't affecting other code
> > > > path calling journal_try_to_free_buffers and only dio path get affected.
> > > > 
> > > > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > > > Index: linux-2.6.26-rc1/fs/ext3/inode.c
> > > > ===================================================================
> > > > --- linux-2.6.26-rc1.orig/fs/ext3/inode.c	2008-05-03 11:59:44.000000000 -0700
> > > > +++ linux-2.6.26-rc1/fs/ext3/inode.c	2008-05-12 12:41:27.000000000 -0700
> > > > @@ -1766,6 +1766,23 @@ static int ext3_journalled_set_page_dirt
> > > >  	return __set_page_dirty_nobuffers(page);
> > > >  }
> > > >  
> > > > +static int ext3_launder_page(struct page *page)
> > > > +{
> > > > +        int ret;
> > > > +	int retry = 5;
> > > > +
> > > > +	while (retry --) {
> > > > +		ret = ext3_releasepage(page, GFP_KERNEL);
> > > > +		if (ret == 1)
> > > > +			break;
> > > > +		else
> > > > +			schedule();
> > > > +	}
> > > > +
> > > > +        return ret;
> > > > +}
> > > > +
> > > > +
> > >   Yes, I meant something like this. We could be more clever and do:
> > > 
> > > 	head = bh = page_buffers(page);
> > > 	do {
> > > 		wait_on_buffer(bh);
> > > 		bh = bh->b_this_page;
> > > 	} while (bh != head);
> > > 	/*
> > > 	 * Now commit code should have been able to proceed and release
> > >          * those buffers
> > > 	 */
> > >         schedule();
> > > 
> > 
> > Bummer, we can't free buffers in ext3_launder_page() before calling
> > try_to_free_page, as later
> > invalidate_complete_page2()->try_to_free_page() expecting the page
> > buffers are still here, and will return EIO if it launder_page() has
> > already freed those buffers.:(
>   Are you sure? Because if bufferes are released in ext3_launder_page(),
> PagePrivate() has been set to 0 and we should directly fall through to
> releasing the page without ever calling try_to_release_page()... So I'd
> want to find out why PagePrivate is still set in
> invalidate_complete_page2().
> 

You are right. PagePrivate() is being set to 0 in drop_buffers(). 

The problem is do_launder_page() returns successfully if the page is not
dirty (our case), so ext3_launder_page() is not even get called. This
also explains why the log_wait_commit() approach doesn't work for me:(

Have to think other ways...could we pass some flag to
journal_try_to_free_buffers(), and ask journal_try_to_free_buffers()
wait for jbd commit to finish flushing the data, if the request is from
directo IO?


Mingming

