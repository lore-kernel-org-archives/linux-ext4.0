From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [BUG?] [Ext4] INFO: suspicious rcu_dereference_check() usage
Date: Sun, 21 Nov 2010 22:16:19 -0800
Message-ID: <20101122061619.GA2764@linux.vnet.ibm.com>
References: <20101121112611.GB4267@deepthought.bhanu.net>
 <20101121133024.GF23423@thunk.org>
 <20101121133024.GF23423@thunk.org>
 <20101121153949.GD20947@barrios-desktop>
 <20101121173726.GG23423@thunk.org>
 <AANLkTimeSWWo-TAJPPH81OO_h1zFzWAT1Gg=XSLyFftH@mail.gmail.com>
 <rcu-radix-tree@mdm.bga.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@vger.kernel.org, linux-ext4@vger.kernel.org,
	"Ted Ts'o" <tytso@mit.edu>, Arun Bhanu <ab@arunbhanu.com>
To: Milton Miller <miltonm@bga.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51157 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab0KVGQX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Nov 2010 01:16:23 -0500
Content-Disposition: inline
In-Reply-To: <rcu-radix-tree@mdm.bga.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 21, 2010 at 09:31:14PM -0600, Milton Miller wrote:
> On 2010-11-22 at around 0:38:49, Minchan Kim wrote:
> > On Mon, Nov 22, 2010 at 2:37 AM, Ted Ts'o <tytso@mit.edu> wrote:
> > > On Mon, Nov 22, 2010 at 12:39:49AM +0900, Minchan Kim wrote:
> > > >
> > > > I think it's no problem.
> > > >
> > > > That's because migration always holds lock_page on the file page.
> > > > So the page couldn't remove from radix.
> > >
> > > It may be "ok" in that it won't cause a race, but it still leaves an
> > > unsightly warning if LOCKDEP is enabled, and LOCKDEP warnings will
> > > cause /proc_lock_stat to be disabled.  So I think it still needs to be
> > > fixed by adding rcu_read_lock()/rcu_read_unlock() to
> > > migrate_page_move_mapping().
> > >
> > >                                                     - Ted
> > >
> > 
> > Yes. if it is really "ok" about race, we will add rcu_read_lock with
> > below comment to prevent false positive.
> > "suppress RCU lockdep false positives".
> > But I am not sure it's good although rcu_read_lock is little cost.
> > Whenever we find false positive, should we add rcu_read_lock to
> > suppress although it's no problem in real product?
> > Couldn't we provide following function? (or we might have already it
> > but I missed it. )
> > 
> > /*
> >  * Suppress RCU lockdep false positive.
> >  */
> > #ifdef CONFIG_PROVE_RCU
> > #define rcu_read_lock_suppress rcu_read_lock
> > #else
> > #define rcu_read_lock_suppress
> > #endif
> 
> No, you don't need anything like this, as rcu_dereference_check already
> takes a test for alternate locking.
> 
> However, looking more closely at the code, it appears this is the
> "the tree is write locked" case as described in radix-tree.h
> 
> Looking at rcupdate.h, perhaps we need a version of radix_tree_deref_slot
> that uses rcu_dereference_protected?
> 
> Copying Paul McKenney for rcu ...

This approach could work.  One way of doing it would be to add a second
argument:

static inline void *radix_tree_deref_slot_check(void **pslot, int ldc)
{
	void *ret = rcu_dereference_check(*pslot, ldc);
	if (unlikely(radix_tree_is_indirect_ptr(ret)))
		ret = RADIX_TREE_RETRY;
	return ret;
}

static inline void *radix_tree_deref_slot(void **pslot)
{
	return radix_tree_deref_slot_check(pslot, rcu_read_lock_held());
}

Another alternative would have radix_tree_deref_slot() pass "1" into
the "ldc" argument, which reduces splats but at the expense of failing
to detect problems.  ;-)

							Thanx, Paul
