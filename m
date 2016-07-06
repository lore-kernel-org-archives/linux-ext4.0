From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] ext4: Fix deadlock during page writeback
Date: Wed, 6 Jul 2016 08:35:10 -0400
Message-ID: <20160706123510.GP15193@thunk.org>
References: <1466073736-30447-2-git-send-email-jack@suse.cz>
 <20160630150548.GC2028@thunk.org>
 <20160701090950.GB22922@quack2.suse.cz>
 <20160701165339.GB6075@thunk.org>
 <20160701174041.GA30040@quack2.suse.cz>
 <20160701212634.GA14277@thunk.org>
 <20160704141435.GA29557@thunk.org>
 <20160704155107.GB12022@quack2.suse.cz>
 <20160705033824.GD15193@thunk.org>
 <20160706075116.GB14067@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eryu Guan <eguan@redhat.com>,
	stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160706075116.GB14067@quack2.suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 06, 2016 at 09:51:16AM +0200, Jan Kara wrote:
> 
> Yeah, JBD2 scalability sucks. I suspect you are conflating two issues here
> though. One issue is j_list_lock and j_state_lock contention - that is
> exposed by starting handles often, doing lots of operations with buffers
> etc. This is what the above paper shows. Another issue is that while a
> transaction is preparing for commit, we have to wait for all outstanding
> handles against that transaction and while we do that, we have no running
> transaction and the whole journalling machinery is stalled. For this
> problem, the time each handle runs is essential. This is what you've likely
> seen in your testing.

You're right, I'm conflating two separate issues.  The
j_{list,state}_lock contention is the more obvious of the two, but
it's separate from the issue of the journalling machinery being
stalled on j_wait_transaction_locked.  

> 
> Reducing j_list_lock and j_state_lock contention is IMO doable, although
> the low hanging fruit is probably eaten these days ;). 

Yeah, most of the low hanging fruit has been grabbed already, which is
why I tend to focus more on the 2nd issue these days.  The main thing
which is left would be splitting j_list_lock so there are separate
locks for each of the different lists (t_buffers, t_forget,
t_shadow_list, t_reserved_list, etc.)  What makes this tricky is that
when we are moving blocks from one list to another, we need to have
both lists locked, and so this means rearchitecting a large amount of
the locking in fs/jbd2/transaction.c, and of course, worrying about
lock rank issues.


> Fixing the second problem is harder as that is inherent problem with
> block-level journalling.  I suspect we could allow starting another
> transaction while the previous one is in "preparing for commit"
> phase but that would lead to two transactions getting updates at one
> point in time which JBD2 currently does not expect.

Starting another transaction while we are waiting for earlier
transaction to lock down is going to be problematic, since while there
are still handles active on the first transaction, they could still be
modifying metadata blocks.  And while that's happening, we can't allow
any new handles associated with the second transaction to start
modifying metadata blocks.

If there was some way for all of the currently open handles to
guarantee that they won't call get_write_access() on any new blocks,
maybe.  But if you look at truncate for example, that gets messy ---
and we could get most of the benefit by simply making truncate be a
two part operation, where it identifies all of the blocks it needs to
modify and makes sure they are in memory *before* it calls
start_this_handle.  And then this falls into the general design
principle of keeping the run time of handles as short as possible.

	     	     	     	     	     - Ted
