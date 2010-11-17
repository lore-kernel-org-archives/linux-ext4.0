From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Wed, 17 Nov 2010 14:56:52 +1100
Message-ID: <20101117035652.GC3302@amd>
References: <20101116110058.GA4298@amd>
 <20101116123252.4cc66f13.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101116123252.4cc66f13.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 16, 2010 at 12:32:52PM -0800, Andrew Morton wrote:
> On Tue, 16 Nov 2010 22:00:58 +1100
> Nick Piggin <npiggin@kernel.dk> wrote:
> 
> > I saw a lock order warning on ext4 trigger. This should solve it.
> 
> Send us the trace, please.

I lost it, sorry.

 
> The code comment implies that someone is calling down_read() under
> i_lock?  That would be bad, and I'd expect it to have produced a
> might_sleep() warning, not a lockdep trace.  

Sorry not i_lock, i_mutex. writeback_inodes_sb_if_idle is called by
ext4's write_begin function which is called with i_mutex held from
generic_file_buffered_write, I believe is the trace.

 
> And I don't see how we can call writeback_inodes_sb() under i_lock
> anyway, so I don't really have a clue what's going on here!
> 
> > Raciness shouldn't matter much, because writeback can stop just
> > after we make the test and return anyway (so the API is racy anyway).

> > 
> > Signed-off-by: Nick Piggin <npiggin@kernel.dk>
> > 
> > Index: linux-2.6/fs/fs-writeback.c
> > ===================================================================
> > --- linux-2.6.orig/fs/fs-writeback.c	2010-11-16 21:44:32.000000000 +1100
> > +++ linux-2.6/fs/fs-writeback.c	2010-11-16 21:49:37.000000000 +1100
> > @@ -1125,16 +1125,20 @@ EXPORT_SYMBOL(writeback_inodes_sb);
> >   *
> >   * Invoke writeback_inodes_sb if no writeback is currently underway.
> >   * Returns 1 if writeback was started, 0 if not.
> > + *
> > + * May be called inside i_lock. May not start writeback if locks cannot
> > + * be acquired.
> >   */
> >  int writeback_inodes_sb_if_idle(struct super_block *sb)
> >  {
> >  	if (!writeback_in_progress(sb->s_bdi)) {
> > -		down_read(&sb->s_umount);
> > -		writeback_inodes_sb(sb);
> > -		up_read(&sb->s_umount);
> > -		return 1;
> > -	} else
> > -		return 0;
> > +		if (down_read_trylock(&sb->s_umount)) {
> > +			writeback_inodes_sb(sb);
> > +			up_read(&sb->s_umount);
> > +			return 1;
> > +		}
> > +	}
> > +	return 0;
> 
> And it's pretty generous to describe a s/down_read/down_read_trylock/
> as a "fix".  Terms like "bandaid" and "workaround" come to mind.

As much as the writeback_inodes_sb_if_idle API itself is a bandaid,
I suppose. (it doesn't do any rate limiting of the dirtier, it's racy,
it doesn't specify how much to writeback, it's synchronous, etc).

Anyway, I don't know, there's not much other option for 2.6.37 AFAIKS.
