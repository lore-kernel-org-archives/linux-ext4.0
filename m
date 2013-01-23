From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fs: allow for fs-specific objects to be pruned as part
 of pruning inodes
Date: Wed, 23 Jan 2013 11:34:21 -0500
Message-ID: <20130123163421.GB12058@thunk.org>
References: <20130121170937.GB15473@gmail.com>
 <1358921168-30921-1-git-send-email-tytso@mit.edu>
 <20130123133231.GS2498@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	gnehzuil.liu@gmail.com, linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130123133231.GS2498@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 24, 2013 at 12:32:31AM +1100, Dave Chinner wrote:
> Doesn't work. Shrinkers run concurrently on the same context, so a
> shrinker can be running on multiple CPUs and hence "interfere" with
> each other. i.e. A shrinker call on CPU 2 could see a reduction in
> a cache as a result of the same shrinker running on CPU 1 in the
> same context, and that would mean the shrinker on CPU 2 doesn't do
> the work it was asked (and needs) to do to reclaim memory.

Hmm, I had assumed that a fs would only have a single prune_super()
running at a time.  So you're telling me that was a bad assumption....

> It also seems somewhat incompatible with the proposed memcg/NUMA
> aware shrinker infrastructure, where the shrinker has much more
> fine-grained context for operation than the current infrastructure.
> This seems to assume that there is global context relationship
> between inode cache and the fs specific cache.

Can you point me at a mail archive with this proposed memcg-aware
shrinker?  I was noticing that that at time moment we're not doing any
shrinking at all on a per-memcg basis, and was reflecting on what a
mess that could cause....  I agree that's a problem that needs fixing,
although it seems fundamentally, hard, especially given that we
currently account for memcg memory usage on a per-page basis, and a
single object owned by a different memcg could prevent a page which
was originally allocated (and hence charged) to the first memcg....

> In your proposed use case, the ext4 extent cache size has no direct
> relationship to the size of the VFS inode cache - the can both
> change size independently and not impact the balance of the system
> as long as the hot objects are kept in their respective caches when
> under memory pressure.
> 
> i.e. the superblock fscache shrinker callout is the wrong thing to
> use here asit doesn't model the relationship between objects at all
> well. A separate shrinker instance for the extent cache is a much
> better match....

Yeah, that was Zheng's original implementation.  My concern was that
could cause the extent cache to get charged twice.  It would get hit
one time when we shrank the number of inodes, since the extent cache
currently does not have a lifetime independent of inodes (rather they
are linked to the inode via a tree structure), and then if we had a
separate extent cache shrinker, they would get reduced a second time.

The reason why we need the second shrinker, of course, is because of
the issue you raised; we could have some files which are heavily
fragmented, and hence would have many more extent cache objects, and
so we can't just rely on shrinking the inode cache to keep the growth
of the extent caches in check in a high memory pressure situation.

Hmm....  this is going to require more thought.  Do you have any
sugestions about what might be a better strategy?

Thanks,

						- Ted
