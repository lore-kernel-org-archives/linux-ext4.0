From: Jan Kara <jack@suse.cz>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Mon, 22 Nov 2010 19:16:55 +0100
Message-ID: <20101122181655.GF5012@quack.suse.cz>
References: <4CE35A6D.2040906@redhat.com>
 <20101117043845.GA3586@amd>
 <4CE362B0.6040607@redhat.com>
 <20101117061057.GA3989@amd>
 <20101118030613.GQ3290@thunk.org>
 <20101117192900.da859ac7.akpm@linux-foundation.org>
 <20101118060000.GA3509@amd>
 <20101117222834.2bb36ee1.akpm@linux-foundation.org>
 <20101119004552.GF5004@quack.suse.cz>
 <20101119051619.GE3284@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Ted Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Nick Piggin <npiggin@kernel.dk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101119051619.GE3284@amd>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 19-11-10 16:16:19, Nick Piggin wrote:
> On Fri, Nov 19, 2010 at 01:45:52AM +0100, Jan Kara wrote:
> > On Wed 17-11-10 22:28:34, Andrew Morton wrote:
> > > The fact that a call to ->write_begin can randomly return with s_umount
> > > held, to be randomly released at some random time in the future is a
> > > bit ugly, isn't it?  write_begin is a pretty low-level, per-inode
> > > thing.
> >   I guess you missed that writeback_inodes_sb_nr() (called from _if_idle
> > variants) does:
> >         bdi_queue_work(sb->s_bdi, &work);
> >         wait_for_completion(&done);
> >   So we return only after all the IO has been submitted and unlock s_umount
> > in writeback_inodes_sb_if_idle(). And we cannot really submit the IO ourselves
> > because we are holding i_mutex and we need to get and put references
> > to other inodes while doing writeback (those would be really horrible lock
> > dependencies - writeback thread can put the last reference to an unlinked
> > inode...).
> 
> But if we're waiting for it, with the lock held, then surely it can
> deadlock just the same as if we submit it ourself?
  Yes, that's what I realized as well and what needs fixing. It was an
unintentional consequence of locking changes Christoph did to the writeback
code to fix other races.

> BTW. are you taking i_mutex inside writeback? I mutex can be held
> while entering page reclaim, and thus writepage... so it could be a
> bug too.
  No, writeback does not need i_mutex.

> > In fact, as I'm speaking about it, pushing things to writeback thread and
> > waiting on the work does not help a bit with the locking issues (we didn't
> > wait for the work previously but that had other issues). Bug, sigh.
> > 
> > What might be better interface for usecases like above is to allow
> > filesystem to kick flusher thread to start doing background writeback
> > (regardless of dirty limits). Then the caller can wait for some delayed
> > allocation reservations to get freed (easy enough to check in
> > ->writepage() and wake the waiters) - possibly with a reasonable timeout
> > so that we don't stall forever.
> 
> We really need to throttle the producer without any locks held, no?
> So the filesystem would like to to hook into dirtying path somewhere
> without i_mutex held (and without implementing your own .write). Eg.
> around the dirty throttling calls somewhere I suppose.
  Well, the particular case where we need to do delayed allocation but the
filesystem has already all blocks reserved is hard to detect without any
locks. At least we need some locks to find out how many blocks do we need
to reserve for that write(). So for filesystems it would solve the locking
issues if we could bail out of write() path up to the point where we hold
no locks, wait there / do necessary writeback and then restart the write...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
