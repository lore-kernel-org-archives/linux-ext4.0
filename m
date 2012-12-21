From: Jan Kara <jack@suse.cz>
Subject: Re: Uninitialized extent races
Date: Fri, 21 Dec 2012 17:19:29 +0100
Message-ID: <20121221161929.GF17357@quack.suse.cz>
References: <20121221012526.GD13474@quack.suse.cz>
 <20121221031151.GA5014@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33219 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab2LUQTe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Dec 2012 11:19:34 -0500
Content-Disposition: inline
In-Reply-To: <20121221031151.GA5014@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 20-12-12 22:11:51, Ted Tso wrote:
> On Fri, Dec 21, 2012 at 02:25:26AM +0100, Jan Kara wrote:
> > Am I missing something Dmitry? Also I was wondering about one thing: Does
> > anybody see a problem with disabling merging of uninitialized extents
> > completely? It would simplify the code (end_io conversion doesn't need to
> > potentially split extents) and the case when we really want to merge
> > extents - i.e., when someone calls fallocate() on small chunks - doesn't
> > seem like the case we need to optimize for? 
> 
> Which case specifically are you talking about here?
> 
> Are you talking about the merging of _formerly_ uninitialized extents?
> i.e., what keeps the extent tree from exploding if you fallocate one
> megabyte region, and then write to all 256 blocks of that one megabyte
> region, except in a random order?
> 
> Or something else?
  No, I'm speaking about merging currently uninitialized extents. I.e.
suppose someone does the following on a filesystem with dioread_nolock so
that writeback happens via unwritten extents:
  fd = open("file", O_RDWR);
  pwrite(fd, buf, 4096, 0);
					flusher thread starts writing
					we create uninitialized extent for
					  range 0-4096
  fallocate(fd, 0, 4096, 4096);
    - we merge extents and now have just 1 uninitialized extent for range
      0-8192
					ext4_convert_unwritten_extents() now
					  has to split the extent to finish
					  the IO.

Now splitting the extent requires number of credits proportional to the
tree depth, maybe even allocation... And strictly speaking number of
credits is impossible to reliably estimate until you hold i_data_sem (tree
can grow until we hold that semaphore) which is too late - we need to start
a transaction before we take that semaphore.

So if we disabled merging of extents that are currently uninitialized,
above problem couldn't happen. We would know we only convert that one
extent and possibly merge it in the leaf to other extents.

> > Also it would bound the amount of transaction credits we need for
> > conversion to 1 block which would make it easier for me to change
> > ext4 to clear PageWriteback only after extent conversion is done
> > (again code simplification, more uniform handling of page
> > writeback).
> 
> So I'm confused.  If it's the case that we're thinking about, we only
> need a single transaction credit, because we're not currently merging
> across adjacent interior extent tree blocks.
> 
> Can you be a bit more explicit about which case you're thinking about?
> I do agree that the extent tree code is too complicated, but we also
> have the problem that we probably been more merging, not less, since
> we can already end up with a case where you start with a single extent
> tree block after fallocating a gigabyte or two.  Then after writing
> randomly into that gigabyte file using AIO, we can end up with a very
> deep, spindly extent tree containing multiple interior extent tree
> blocks, because we're not doing sufficient merging --- and in
> particular, we currently have no way at all of decreasing the depth of
> the extent tree.
  Yeah, so I agree that's a problem in some cases but my suggestion
shouldn't really make this any worse. We *will* still be merging normal
extents after they are converted in end_io handler... Just we won't merge
them while they are still uninitialized.

And I regarding more merging, that could be done (obviously), just we might
need to postpone that after writeback is finished (PageWriteback is
cleared) because there extent estimates are not clear. And I need to know
necessary number of extents well in advance to be able to reserve credits
in the journal. OTOH maybe we could use jbd2_journal_extend() to get more
credits if we need them for merging. And when that fails, bad luck but we
can cope... Anyway, this is a different problem.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
