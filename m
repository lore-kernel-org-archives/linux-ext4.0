From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/4] ext4: Fix deadlock during page writeback
Date: Wed, 6 Jul 2016 14:52:28 +0200
Message-ID: <20160706125228.GK14067@quack2.suse.cz>
References: <20160630150548.GC2028@thunk.org>
 <20160701090950.GB22922@quack2.suse.cz>
 <20160701165339.GB6075@thunk.org>
 <20160701174041.GA30040@quack2.suse.cz>
 <20160701212634.GA14277@thunk.org>
 <20160704141435.GA29557@thunk.org>
 <20160704155107.GB12022@quack2.suse.cz>
 <20160705033824.GD15193@thunk.org>
 <20160706075116.GB14067@quack2.suse.cz>
 <20160706123510.GP15193@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Eryu Guan <eguan@redhat.com>, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160706123510.GP15193@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 06-07-16 08:35:10, Ted Tso wrote:
> On Wed, Jul 06, 2016 at 09:51:16AM +0200, Jan Kara wrote:
> > Fixing the second problem is harder as that is inherent problem with
> > block-level journalling.  I suspect we could allow starting another
> > transaction while the previous one is in "preparing for commit"
> > phase but that would lead to two transactions getting updates at one
> > point in time which JBD2 currently does not expect.
> 
> Starting another transaction while we are waiting for earlier
> transaction to lock down is going to be problematic, since while there
> are still handles active on the first transaction, they could still be
> modifying metadata blocks.  And while that's happening, we can't allow
> any new handles associated with the second transaction to start
> modifying metadata blocks.

Well, we can. We just have to make sure we snapshot the contents that
should be committed before we modify it from the new transaction. We
already do this when we are committing block and need to modify it in the
running transaction at the same time. Obviously allowing this logic to
trigger earlier will lead to higher memory overhead and allocation,
copying, and freeing of block snapshots isn't free either so it will need
careful benchmarking.

> If there was some way for all of the currently open handles to
> guarantee that they won't call get_write_access() on any new blocks,
> maybe.  But if you look at truncate for example, that gets messy ---
> and we could get most of the benefit by simply making truncate be a
> two part operation, where it identifies all of the blocks it needs to
> modify and makes sure they are in memory *before* it calls
> start_this_handle.  And then this falls into the general design
> principle of keeping the run time of handles as short as possible.

Yeah, I'm afraid the complexity of this will be rather high...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
