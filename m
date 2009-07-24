From: Mingming <cmm@us.ibm.com>
Subject: Re: Fallocate and DirectIO
Date: Thu, 23 Jul 2009 17:56:12 -0700
Message-ID: <1248396972.1354.47.camel@mingming-laptop>
References: <20090612123112.GB25239@skywalker>
	 <20090612173301.GC6417@mit.edu>
	 <6601abe90907211827l57a04f8asba906e508535f1b9@mail.gmail.com>
	 <6601abe90907230856q3ee5abe5jc1f7a71d10c5f695@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:36554 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZGXA6n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jul 2009 20:58:43 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n6O0uv7r024928
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2009 18:56:57 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n6O0whZj223770
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2009 18:58:43 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n6O0wfhG028191
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2009 18:58:42 -0600
In-Reply-To: <6601abe90907230856q3ee5abe5jc1f7a71d10c5f695@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2009-07-23 at 08:56 -0700, Curt Wohlgemuth wrote:
> On Tue, Jul 21, 2009 at 6:27 PM, Curt Wohlgemuth<curtw@google.com> wrote:
> > I spent a bit of time looking at this today.
> >
> > On Fri, Jun 12, 2009 at 10:33 AM, Theodore Tso<tytso@mit.edu> wrote:
> >> On Fri, Jun 12, 2009 at 06:01:12PM +0530, Aneesh Kumar K.V wrote:
> >>> Hi,
> >>>
> >>> I noticed yesterday that a write to fallocate
> >>> space via directIO results in fallback to buffer_IO. ie the userspace
> >>> pages get copied to the page cache and then call a sync.
> >>>
> >>> I guess this defeat the purpose of using directIO. May be we should
> >>> consider this a high priority bug.
> >
> > My simple experiment -- without a journal -- shows that you're
> > observation is correct.  *Except* if FALLOC_FL_KEEP_SIZE is used in
> > the fallocate() call, in which case the page cache is *not* used.
> >
> > Pseudo-code example:
> >
> >  open(O_DIRECT)
> >  fallocate(mode, 512MB)
> >  while (! written 100MB)
> >     write(64K)
> >  close()
> >
> > If mode == FALLOC_FL_KEEP_SIZE, then no page cache is used.
> > Otherwise, we *do* go through the page cache.
> >
> > It comes down to the fact that, since the i_size is not updated with
> > KEEP_SIZE, then ext4_get_block() is called with create = 1, since the
> > block that's needed is "beyond" the file end.
> 
I think so.
In the case of KEEP_SIZE, get_block() is called with create=1 before dio
submit the real data IO, thus dio get a chance to convert the
uninitalized extents to initialized before returns back to the caller. 

But in the case of non KEEP_SIZE, i.e. updating i_size after fallocate()
case, we now have to fall back to buffered IO to ensure the extents
conversion is happened in an ordering. Because if we convert the extents
before submit the IO, and this conversion reached to disk, if system
crash before the real data IO finished, then it could expose the stale
data out, as the extent has already marked "initialized".


> Ted, given your concerns over the performance impact of updating the
> extents during direct I/O writes, it would seem that the fact that
> when KEEP_SIZE is specified we do the DMA (and don't go through the
> page cache) would be a problem/bug.  At least, it seems that the
> performance issue is the same regardless of whether KEEP_SIZE is used
> on the fallocate or not: in both we're dealing with an uninitialized
> extent.  Do you agree?

Here is what I thought...

I think updating the extents itself is not a big performance concern, In
the non KEEP_SIZE case, if we don't want to fall back to buffered IO,
ext4 DIO has to wait for the journal to commit the transaction which
converts extents to complete, before DIO could return back apps, this
could be a big latency. That seems what xfs does.

For KEEP_SIZE case, The conversion actually could happen before the
related IO reach to disk, I guess the oraph inode list protects stale
data get exposed in this case.


> I'm exploring (a) what this performance penalty is for the journal
> commit; and (b) can we at least avoid the page cache if your
> conditions above (no journal commit; no new extent blocks) are met.

In fact, in the case of no journal, as long as the extents conversion
happens after the data IO reach to disk, it should be safe, am I right?
If system crash before the extent conversion finish, we only lost
recently updated IO, but won't expose the stale data out, as the extents
is still marked as uninitialized.


Regards,
Mingming
> >
> >>
> >> I agree that many of users of fallocate() feature (i.e. databases) are
> >> going to consider this to be a major misfeature.
> >
> >>
> >> There's going to be a major performance hit though --- O_DIRECT is
> >> supposed to be synchronous if all of the alignment requirements are
> >> met, which means that by the time the write(2) system call returns,
> >> the data is guaranteed to be on disk.  But if we need to manipulate
> >> the extent tree to indicate that the block is now in use (so the data
> >> is actually accessible), do we force a synchronous journal commit or
> >> not?  If we don't, then a crash right after an O_DIRECT right into an
> >> uninitialized region will cause the data to be "lost" (or at least,
> >> unavailable via the read/write system call).  If we do, then the first
> >> write into uninitialized block will cause a synchronous journal commit
> >> that will be Slow And Painful, and it might destroy most of the
> >> performance benefits that might tempt an enterprise database client to
> >> use fallocate() in the first place.
> >>
> >> I wonder how XFS deals with this case?  It's a problem that is going
> >> to hit any journalled filesystem that wants to support fallocate() and
> >> direct I/O.
> >>
> >> One thing I can think of potentially doing is to check to see if the
> >> extent tree block has already been journalled, and if it is not
> >> currently involved the current transaction or the previous committing
> >> transaction, *and* if there is space in the extent tree to mark the
> >> current unitialized block as initialized (i.e., if the extent needs to
> >> be split, there is sufficient space so we don't have to allocate a new
> >> leaf block for the extent tree), we could update the leaf block in
> >> place and then synchronously write it out, and thus avoid needing to
> >> do a synchronous journal commit.
> >
> > In my example above, when KEEP_SIZE is used, it appears that
> > converting the uninit extent to initialized never failed.  I haven't
> > waded through ext4_ext_convert_to_initialized() to see how it might
> > fail, and tried to get it to do so.
> >
> > It would be interesting to see if making this work -- having the
> > blocks allocated and the buffer mapped -- for O_DIRECT writes in the
> > absence of a journal, at least, would be feasible.  It would certainly
> > be useful, to us at least.
> >
> > Thanks,
> > Curt
> >
> >>
> >> In any case, adding this support is going to be non-trivial.  If
> >> someone has time to work on it in the next 2-3 weeks or so, I can push
> >> it to Linus as a bug fix --- but I'm concerned the fixing this may be
> >> tricky enough (and the patch invasive enough) that it might be
> >> challenging to get this fixed in time for 2.6.31.
> >>
> >>                                                - Ted
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


