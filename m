From: Jan Kara <jack@suse.cz>
Subject: Re: [patch] fs: fix deadlocks in writeback_if_idle
Date: Wed, 24 Nov 2010 14:10:28 +0100
Message-ID: <20101124131028.GQ6113@quack.suse.cz>
References: <20101123100239.GA4232@amd>
 <1290515274-sup-3895@think>
 <20101123125223.GA4946@amd>
 <1290538347-sup-7669@think>
 <20101124010343.GD3168@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Nick Piggin <npiggin@kernel.dk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101124010343.GD3168@amd>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 24-11-10 12:03:43, Nick Piggin wrote:
> > For the _nr variant that btrfs uses, it's worse for the filesystems
> > that don't have a 1:1 bdi<->sb mapping.  It might not actually write any
> > of the pages from the SB that is out of space.
> 
> That's true, but it might not write anything anyway (and after we
> check whether writeout is in progress, the writeout thread could go
> to sleep and not do anything anyway).
> 
> So it's a pretty hacky interface anyway. If you want to do anything
> deterministic, you obviously need real coupling between producer and
> consumer. This should only be a performance tweak (or a workaround
> hack in worst case).
  Yes, the current interface is a band aid for the problem and better
interface is welcome. But it's not trivial to do better...

> > > It makes no further guarantees, and anyway
> > > the sb has to compete for normal writeback within this bdi.
> > 
> > > 
> > > I think Christoph is right because filesystems should not really
> > > know about how bdi writeback queueing works. But I don't know if it's
> > > worth doing anything more complex for this functionality?
> > 
> > I think we should make a writeback_inodes_sb_unlocked() that doesn't
> > warn when the semaphore isn't held.  That should be enough given where
> > btrfs and ext4 are calling it from.
> 
> It doesn't solve the bugs -- calling and waiting for writeback is
> still broken because completion requires i_mutex and it is called
> from under i_mutex.
  Well, as I wrote in my previous email, only ext4 has the problem with
i_mutex and I personally view it as a bug. But ultimately it's Ted's call
to decide.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
