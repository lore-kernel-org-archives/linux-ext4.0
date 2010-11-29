From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] fs: fix deadlocks in writeback_if_idle
Date: Mon, 29 Nov 2010 14:26:03 -0800
Message-ID: <20101129142603.ebbcbc7e.akpm@linux-foundation.org>
References: <20101123100239.GA4232@amd>
	<1290515274-sup-3895@think>
	<20101123125223.GA4946@amd>
	<1290538347-sup-7669@think>
	<20101124010343.GD3168@amd>
	<20101124131028.GQ6113@quack.suse.cz>
	<20101125035356.GC3359@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Nick Piggin <npiggin@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110Ab0K2W0Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Nov 2010 17:26:25 -0500
In-Reply-To: <20101125035356.GC3359@amd>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

	On Thu, 25 Nov 2010 14:53:56 +1100
Nick Piggin <npiggin@kernel.dk> wrote:

> On Wed, Nov 24, 2010 at 02:10:28PM +0100, Jan Kara wrote:
> > On Wed 24-11-10 12:03:43, Nick Piggin wrote:
> > > > For the _nr variant that btrfs uses, it's worse for the filesystems
> > > > that don't have a 1:1 bdi<->sb mapping.  It might not actually write any
> > > > of the pages from the SB that is out of space.
> > > 
> > > That's true, but it might not write anything anyway (and after we
> > > check whether writeout is in progress, the writeout thread could go
> > > to sleep and not do anything anyway).
> > > 
> > > So it's a pretty hacky interface anyway. If you want to do anything
> > > deterministic, you obviously need real coupling between producer and
> > > consumer. This should only be a performance tweak (or a workaround
> > > hack in worst case).
> >   Yes, the current interface is a band aid for the problem and better
> > interface is welcome. But it's not trivial to do better...
> > 
> > > > > It makes no further guarantees, and anyway
> > > > > the sb has to compete for normal writeback within this bdi.
> > > > 
> > > > > 
> > > > > I think Christoph is right because filesystems should not really
> > > > > know about how bdi writeback queueing works. But I don't know if it's
> > > > > worth doing anything more complex for this functionality?
> > > > 
> > > > I think we should make a writeback_inodes_sb_unlocked() that doesn't
> > > > warn when the semaphore isn't held.  That should be enough given where
> > > > btrfs and ext4 are calling it from.
> > > 
> > > It doesn't solve the bugs -- calling and waiting for writeback is
> > > still broken because completion requires i_mutex and it is called
> > > from under i_mutex.
> >   Well, as I wrote in my previous email, only ext4 has the problem with
> > i_mutex and I personally view it as a bug. But ultimately it's Ted's call
> > to decide.
> 
> Well, for now, the easiest and simplest fix is my patch, I think. The
> objection is that we may not write out anything for the specified sb,
> but the current implementation provides no such guarantees at all
> anyway, so I don't think it's a big issue.

Well yes.  We take something which will fail occasionally and with your
patch replace it with something which will fail a bit more often.  Why
don't we go all the way and do something which will fail *even more
often*.  Namely, just delete the damn function in the hope that the
resulting failures will provoke the ext4 crew into doing something sane
this time?

Guys, this delalloc thing *sucks*.  And here we are just sticking new
bandaids on top of the old bandaids.  And the btrfs approach isn't
exactly a thing of glory, either.

So...  nope.  I won't be applying Nick's patch.  Please fix this thing
properly - you have a whole month!
