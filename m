From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Fri, 8 Apr 2011 23:33:05 +0200
Message-ID: <20110408213305.GF16729@quack.suse.cz>
References: <4D5C9B1B.2050304@jp.fujitsu.com>
 <20110217104552.GD4947@quack.suse.cz>
 <20110328170628.ffe314fb.toshi.okajima@jp.fujitsu.com>
 <20110331234050.GD2904@dastard>
 <20110401140856.GA5311@quack.suse.cz>
 <20110406054005.GD31057@dastard>
 <20110406061856.GC23285@quack.suse.cz>
 <20110406112135.GE31057@dastard>
 <20110406174001.GB28689@quack.suse.cz>
 <20110406225401.GH31057@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:60374 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401Ab1DHVdP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Apr 2011 17:33:15 -0400
Content-Disposition: inline
In-Reply-To: <20110406225401.GH31057@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 07-04-11 08:54:01, Dave Chinner wrote:
> On Wed, Apr 06, 2011 at 07:40:01PM +0200, Jan Kara wrote:
> > On Wed 06-04-11 21:21:35, Dave Chinner wrote:
> > > On Wed, Apr 06, 2011 at 08:18:56AM +0200, Jan Kara wrote:
> > > > On Wed 06-04-11 15:40:05, Dave Chinner wrote:
> > > > > On Fri, Apr 01, 2011 at 04:08:56PM +0200, Jan Kara wrote:
> > > > > > On Fri 01-04-11 10:40:50, Dave Chinner wrote:
> > > > > > > If you don't allow the page to be dirtied in the fist place, then
> > > > > > > nothing needs to be done to the writeback path because there is
> > > > > > > nothing dirty for it to write back.
> > > > > >   Sure but that's only the problem he was able to hit. But generally,
> > > > > > there's a problem with needing s_umount for unfreezing because it isn't
> > > > > > clear there aren't other code paths which can block with s_umount held
> > > > > > waiting for fs to get unfrozen. And these code paths would cause the same
> > > > > > deadlock. That's why I chose to get rid of s_umount during thawing.
> > > > > 
> > > > > Holding the s_umount lock while checking if frozen and sleeping
> > > > > is essentially an ABBA lock inversion bug that can bite in many more
> > > > > places that just thawing the filesystem.  Any where this is done should
> > > > > be fixed, so I don't think just removing the s_umount lock from the thaw
> > > > > path is sufficient to avoid problems.
> > > >   That's easily said but hard to do - any transaction start in ext3/4 may
> > > > block on filesystem being frozen (this seems to be similar for XFS as I'm
> > > > looking into the code) and transaction start traditionally nests inside
> > > > s_umount (and basically there's no way around that since sync() calls your
> > > > fs code with s_umount held).
> > > 
> > > Sure, but the question must be asked - why is ext3/4 even starting a
> > > transaction on a clean filesystem during sync? A frozen filesystem,
> > > by definition, is a clean filesytem, and therefore sync calls of any
> > > kind should not be trying to write to the FS or start transactions.
> > > XFS does this just fine, so I'd consider such behaviour on a frozen
> > > filesystem a bug in ext3/4...
> >   But by this you are essentially agreeing that the lock inversion is there
> > in principle. We just hide it by relying on the fact that no code path
> > trying to change anything with s_umount held (which is the right lock
> > ordering) gets called while the fs is frozen.  And that is fragile.
> 
> It's just another lock ordering rule. i.e. don't sleep on a frozen
> filesystem with s_umount held.  It's no more fragile than the many
> other lock ordering rules we have.
  Except that for all the filesystems transaction start => sleep on a
frozen filesystem and in some code paths we have s_umount held while doing
a transaction start. So I don't buy the argument that it's just another
normal locking rule because normally we require that all the code paths
follow correct lock ordering. Now we have some paths (like sync) which do
not follow the correct lock ordering and we just make sure they are not
called if they could cause deadlocks by other means...

> > Actually, I've looked for a while and if you call quotactl(), it will get
> > s_umount and then tell filesystem to update quota information which blocks
> > inside the fs waiting for filesystem being unfrozen => deadlock.
> 
> Which is a bug according to the above locking rule.
  Yes, I was just trying to demonstrate that the locking rule changes
"block until the fs is unfrozen" into "kernel is deadlocked" in an
unexpected places... fsync_bdev() is another case which deadlocks
currently.

> > We can
> > change this code path to wait for frozen filesystem before taking s_umount
> > that essentially it just reinstates my point - it't fragile and IMHO we
> > need some more consistent way to handle this...
> > 
> > > > So I'm afraid we are not going to get rid of
> > > > this ABBA dependency unless we declare that s_umount ranks above filesystem
> > > > being frozen - but surely I'm open to suggestions.
> > > 
> > > Not sure I understand what you are saying there - this is already
> > > the case, isn't it? i.e. it has to be held exclusive to freeze a
> > > filesystem...
> >   Not really. We freeze the fs under s_umount but freezing essentially
> > implements trylock semantics while setting s_frozen so that does not really
> > establish any lock dependency. What establishes lock dependency is the
> > thawing path which blocks on s_umount while the filesystem is still frozen.
> > And this dependency is the other way around - i.e., freezing above
> > s_umount. This is why I was messing with thawing code to fix this...
> 
> It's just the tip of the iceberg. If we allow s_umount to be held
> while waiting on a frozen filesystem, we open ouselves up to all
> manner of problems. Such as umount hanging on a frozen fs,
> (which means a shutdown with a frozen filesystem will hang), it can
> hang sync, it can hang memory reclaim, it can hang in any path that
> takes s_umount and hence do all sorts of bad things.
  I see. The umount hang (especially in the shutdown case) is not nice.
Direct reclaim won't be blocked AFAICS if we stop dirtying pages while the
fs is frozen (which, as I already wrote, I agree is not a good thing to do
after some thought). Since you can block while accessing the frozen
filesystem anyway (because of atime updates or just because of writing
process waiting with i_mutex held for fs to be unfrozen) I'm not sure how
much worse it would be if s_umount lock would be another lock with which
we can wait for fs to get unfrozen...

> Yes, unthawing the filesystem will get things moving again with your
> patch, but my point is that it simply does not address the problems
> caused by the bad behaviour that has already occurred while the FS
> is frozen. Fixing the thaw code in this way is like shooting the
> messenger - it doesn't fix the problems being reported.
  I don't there has been any too bad behavior - you tried to access frozen
filesystem and you got blocked. But OK, I'll invest some more thought into
how to not block with s_umount held without sprinkling frozen checks over
the tree...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
