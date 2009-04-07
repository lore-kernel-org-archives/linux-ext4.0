From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/3] block_write_full_page: Use synchronous writes for
	WBC_SYNC_ALL writebacks
Date: Tue, 7 Apr 2009 09:57:32 +0200
Message-ID: <20090407075732.GO5178@kernel.dk>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu> <1238185471-31152-2-git-send-email-tytso@mit.edu> <20090406232141.ebdb426a.akpm@linux-foundation.org> <20090406235052.1ea47513.akpm@linux-foundation.org> <20090407070835.GM5178@kernel.dk> <20090407002313.fcdd1da0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jack@suse.cz
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754812AbZDGH5v@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090407002313.fcdd1da0.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 07 2009, Andrew Morton wrote:
> On Tue, 7 Apr 2009 09:08:36 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Mon, Apr 06 2009, Andrew Morton wrote:
> > > On Mon, 6 Apr 2009 23:21:41 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > I mean, let's graph it:
> > > > 
> > > > WRITE_SYNC -> WRITE_SYNC_PLUG -> BIO_RW_SYNCIO -> bio_sync() -> REQ_RW_SYNC -> rw_is_sync() -> does something mysterious in get_request()
> > > >                                                                             -> rq_is_sync() -> does something mysterious in IO schedulers
> > > >                               -> BIO_RW_NOIDLE -> bio_noidle() -> REQ_NOIDLE -> rq_noidle() -> does something mysterious in cfq-iosched only
> > > >            -> BIO_RW_UNPLUG   -> bio_unplug() -> REQ_UNPLUG -> OK, the cognoscenti know what this is supposed to do, but it is unused!
> 
> I think the number of different greps which was needed to find all the
> above was excessive.  Too many levels of wrappers and helpers.
> 
> If there was documentation at the intermediate levels then that would
> terminate the search early.  But working out the _actual_ semantics of
> (say) BIO_RW_SYNCIO is quite hard!

I'll add some proper documentation to the list of WRITE* definitions.

> > > whoop, I found a use of bio_unplug() in __make_request().
> > > 
> > > So it appears that the intent of your patch is to cause an unplug after
> > > submission of each WB_SYNC_ALL block?
> > > 
> > > But what about all the other stuff which WRITE_SYNC might or might not
> > > do?  What does WRITE_SYNC _actually_ do, and what are the actual
> > > effects of this change??
> > > 
> > > And what effect will this large stream of unplugs have upon merging?
> > 
> > It looks like a good candidate for WRITE_SYNC_PLUG instead,
> 
> Perhaps that mean that Ted didn't know what his own patch did.  I
> certainly couldn't work it out.  That's a problem, IMO!

I think Ted knew, we did talk about the fact that it would unplug. But
note that it only really changes the number of unplugs for the cases
where you do multiple bh submissions before doing a
wait_on/lock_buffer() since that'll do the unplug anyway. For those
cases we do want to use WRITE_SYNC_PLUG to defer unplugging to the first
wait/lock of the bh.

> > since it
> > does more than one buffer submission before waiting. It likely wont mean
> > a whole lot since we'll usually only have a single buffer on that page,
> > but for < PAGE_CACHE_SIZE block sizes it could easily make a big
> > difference (4 ios instead of 1!).
> 
> OK.
> 
> But what is the advantage in doing this stream of unplugs?  For your
> average fsync(), we're probably doing tens of thousands per second.
> Does it actually help?
> 
> I assume that the actual code path for such a buffer becomes a lot
> longer because we need to go beyond the the queueing layer and perhaps
> as far down as the device driver for each block, so the CPU cost will
> go up?

If you are just doing a single IO submission, whether you do that unplug
in sync_buffer() or explicitly at the IO submission call doesn't make
any difference. In fact, the stack will be shorter from the submission
path by a function call or two.

> > So on the write side, basically we have:
> 
> Could we get this in patch form, pretty please?

Certainly, I'll improve it a bit and add it as well.

> > WRITE                   Normal async write.
> > WRITE_SYNC_PLUG         Sync write, someone will wait on this so don't
> >                         treat it as background activity. This is a hint
> >                         to the io schedulers. This one does NOT unplug
> >                         the queue, either the caller should do it after
> >                         submission, or he should make sure that the
> >                         wait_on_* callbacks do it for him.
> 
> The description isn't terribly useful unless the reader is told what
> actions the schedulers are expected to take in response to the hint.

Well, the caller doesn't really need to know. Basically it boils down to
whether you are going to be waiting on this IO or not. If you are, it's
a sync write. I don't want to add a lot of IO scheduler specifics about
how we treat a sync write differently from an async one.

I'll rewrite the text.

-- 
Jens Axboe
