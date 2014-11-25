From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/4] vfs: add support for a lazytime mount option
Date: Tue, 25 Nov 2014 21:18:10 +0100
Message-ID: <20141125201810.GA18592@quack.suse.cz>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
 <1416599964-21892-3-git-send-email-tytso@mit.edu>
 <20141125015239.GD27262@dastard>
 <20141125043335.GF31339@thunk.org>
 <20141125171927.GC3228@quack.suse.cz>
 <20141125175716.GC11648@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
	linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141125175716.GC11648@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 25-11-14 12:57:16, Ted Tso wrote:
> On Tue, Nov 25, 2014 at 06:19:27PM +0100, Jan Kara wrote:
> >   Actually, I'd also prefer to do the writing from iput_final(). My main
> > reason is that shrinker starts behaving very differently when you put
> > inodes with I_DIRTY_TIME to the LRU. See inode_lru_isolate() and in
> > particular:
> >         /*
> >          * Referenced or dirty inodes are still in use. Give them another
> >          * pass
> >          * through the LRU as we canot reclaim them now.
> >          */
> >         if (atomic_read(&inode->i_count) ||
> >             (inode->i_state & ~I_REFERENCED)) {
> >                 list_del_init(&inode->i_lru);
> >                 spin_unlock(&inode->i_lock);
> >                 this_cpu_dec(nr_unused);
> >                 return LRU_REMOVED;
> >         }
> 
> I must be missing something; how would the shirnker behave
> differently?  I_DIRTY_TIME shouldn't have any effect on the shrinker;
> note that I_DIRTY_TIME is *not* part of I_DIRTY, and this was quite
> deliberate, because I didn't want I_DIRTY_TIME to have any affect on
> any of the other parts of the writeback or inode management parts.
  Sure, but the test tests whether the inode has *any other* bit than
I_REFERENCED set. So I_DIRTY_TIME will trigger the test and we just remove
the inode from lru list. You could exclude I_DIRTY_TIME from this test to
avoid this problem but then the shrinker latency would get much larger
because it will suddently do IO in evict(). So I still think doing the
write in iput_final() is the best solution.

> > Regarding your concern that we'd write the inode when file is closed -
> > that's not true. We'll write the inode only after corresponding dentry is
> > evicted and thus drops inode reference. That doesn't seem too bad to me.
> 
> True, fair enough.  It's not quite so lazy, but it should be close
> enough.
> 
> I'm still not seeing the benefit in waiting until the last possible
> minute to write out the timestamps; evict() can block as it is if
> there are any writeback that needs to be completed, and if the
> writeback happens to pages subject to delalloc, the timestamp update
> could happen for free at that point.
  Yeah, doing IO from evict is OK in princible but the change in shrinker
success rate / latency worries me... It would certainly need careful
testing under memory pressure & IO load with lots of outstanding timestamp
updates and see how shrinker behaves (change in CPU consumption, numbers of
evicted inodes, etc.).

							Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
