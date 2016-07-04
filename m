From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/4] ext4: Fix deadlock during page writeback
Date: Mon, 4 Jul 2016 16:00:12 +0200
Message-ID: <20160704140012.GG5200@quack2.suse.cz>
References: <1466073736-30447-1-git-send-email-jack@suse.cz>
 <1466073736-30447-2-git-send-email-jack@suse.cz>
 <20160630150548.GC2028@thunk.org>
 <20160701090950.GB22922@quack2.suse.cz>
 <20160701165339.GB6075@thunk.org>
 <20160701174041.GA30040@quack2.suse.cz>
 <20160701212634.GA14277@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Eryu Guan <eguan@redhat.com>, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160701212634.GA14277@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 01-07-16 17:26:34, Ted Tso wrote:
> On Fri, Jul 01, 2016 at 07:40:41PM +0200, Jan Kara wrote:
> > 
> > So we are waiting for transaction commit to finish with unsubmitted pages
> > that already have PageWriteback set (and also potentially other pages that
> > are locked and we didn't prepare them for writing because the block mapping
> > we got was too short). Now JBD2 goes on trying to do the transaction
> > commit:
> 
> Ah, I see, so this is only an issue in those cases where the handle is
> synchronous.  Is this the only case where there is a concern?  (e.g.,
> could we test handle->h_sync and stop the handle early if h_sync
> is not set?)  This would put the uninit->init conversion into
> potentially a separate transaction, but that should be OK.

So checking handle->h_sync is possible and it would handle the problem as
well AFAICS. However I find it rather hacky to rely on the fact that
ext4_journal_stop() can block only when handle->h_sync is set.

With uninit->init conversion changes you likely mean
ext4_put_io_end_defer() is run while the handle is still running - that is
true but any real work is done from a workqueue so my patch doesn't really
change in which transaction uninit->init conversion happens.

> The reason why I'm pushing so hard here is that long running handles
> is a major contributor to ext4 haveing poor CPU scalability numbers,
> since we can end up having lots of threads waiting on the last
> transaction to complete.  So keeping transactions small and fast is a
> big deal.

OK, but we do all the block mappings, page locking etc. while the handle is
started so it is not exactly a really short lived handle. The patch adds
there a submission of a bio (we have the IO plugged so it will just add the
bio to the list of submitted bios), unlock locked pages, drop refcount to
ioend (unless IO is already completed, only refcount update is done, if IO
is completed we defer any real work to workqueue anyway). So although we
add some work which is done while the handle is still running, it is not
that much.

If you have some tests which show how the transaction wait time increased,
I could be convinced the hack is worth it. But so far I don't think that
messing with handle->h_sync is warranted.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
