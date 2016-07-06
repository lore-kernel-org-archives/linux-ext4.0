From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/4] ext4: Fix deadlock during page writeback
Date: Wed, 6 Jul 2016 16:41:59 +0200
Message-ID: <20160706144159.GA4602@quack2.suse.cz>
References: <20160701165339.GB6075@thunk.org>
 <20160701174041.GA30040@quack2.suse.cz>
 <20160701212634.GA14277@thunk.org>
 <20160704141435.GA29557@thunk.org>
 <20160704155107.GB12022@quack2.suse.cz>
 <20160705033824.GD15193@thunk.org>
 <20160706075116.GB14067@quack2.suse.cz>
 <20160706123510.GP15193@thunk.org>
 <20160706125228.GK14067@quack2.suse.cz>
 <20160706142723.GQ15193@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Eryu Guan <eguan@redhat.com>, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160706142723.GQ15193@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 06-07-16 10:27:23, Ted Tso wrote:
> On Wed, Jul 06, 2016 at 02:52:28PM +0200, Jan Kara wrote:
> > > Starting another transaction while we are waiting for earlier
> > > transaction to lock down is going to be problematic, since while there
> > > are still handles active on the first transaction, they could still be
> > > modifying metadata blocks.  And while that's happening, we can't allow
> > > any new handles associated with the second transaction to start
> > > modifying metadata blocks.
> > 
> > Well, we can. We just have to make sure we snapshot the contents that
> > should be committed before we modify it from the new transaction. We
> > already do this when we are committing block and need to modify it in the
> > running transaction at the same time. Obviously allowing this logic to
> > trigger earlier will lead to higher memory overhead and allocation,
> > copying, and freeing of block snapshots isn't free either so it will need
> > careful benchmarking.
> 
> Consider the following sequence:
> 
> Start handle A attached to txn #42
> 
>             <Start Commiting transaction #42>
> 
> 	    	   	     		Start handle B attached to tnx #43
> 					Call get_write_access on block bitmap #100
> 					Modify block bitmap #100
> 					journal_dirty_metadata for #100
> 
> Call get_write_access on block bitmap #100
> Modify block bitmap #100
> journal_dirty_metadata for #100
> 
> 
> Snapshotting the block bitmap at when handle B calls
> get_write_access() won't help, because if handle B starts modifying
> the block bitmap, and *then* handle A starts trying to modify the same
> block bitmap, what do we do?
> 
> You could make handle A make the same logical modification in both the
> copy of metadata block associated with first transaction (#42) as well
> as the copy of the metadata block associated with the second
> transaction (#43), and for an allocation bitmap maybe it's even
> doable.
> 
> But consider the even more hairy case where handle A and handle B are
> both modifying an inline xattr, and handle B has to convert spill some
> of the extended attribute contents to an external xattr block.  Now
> when handle A makes some other xattr change, the change it needs to
> make for transaction #42 might be very different from the one for
> transaction #43.

Yup, good point.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
