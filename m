From: Milton Miller <miltonm@bga.com>
Subject: Re: [BUG?] [Ext4] INFO: suspicious rcu_dereference_check() usage
Date: Sun, 21 Nov 2010 21:31:14 -0600
Message-ID: <rcu-radix-tree@mdm.bga.com>
References: <20101121112611.GB4267@deepthought.bhanu.net>
	<20101121133024.GF23423@thunk.org>
	<20101121133024.GF23423@thunk.org>
	<20101121153949.GD20947@barrios-desktop>
	<20101121173726.GG23423@thunk.org>
	<AANLkTimeSWWo-TAJPPH81OO_h1zFzWAT1Gg=XSLyFftH@mail.gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
	Arun Bhanu <ab@arunbhanu.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Minchan Kim <minchan.kim@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTimeSWWo-TAJPPH81OO_h1zFzWAT1Gg=XSLyFftH@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2010-11-22 at around 0:38:49, Minchan Kim wrote:
> On Mon, Nov 22, 2010 at 2:37 AM, Ted Ts'o <tytso@mit.edu> wrote:
> > On Mon, Nov 22, 2010 at 12:39:49AM +0900, Minchan Kim wrote:
> > >
> > > I think it's no problem.
> > >
> > > That's because migration always holds lock_page on the file page.
> > > So the page couldn't remove from radix.
> >
> > It may be "ok" in that it won't cause a race, but it still leaves an
> > unsightly warning if LOCKDEP is enabled, and LOCKDEP warnings will
> > cause /proc_lock_stat to be disabled.  So I think it still needs to be
> > fixed by adding rcu_read_lock()/rcu_read_unlock() to
> > migrate_page_move_mapping().
> >
> >                                                     - Ted
> >
> 
> Yes. if it is really "ok" about race, we will add rcu_read_lock with
> below comment to prevent false positive.
> "suppress RCU lockdep false positives".
> But I am not sure it's good although rcu_read_lock is little cost.
> Whenever we find false positive, should we add rcu_read_lock to
> suppress although it's no problem in real product?
> Couldn't we provide following function? (or we might have already it
> but I missed it. )
> 
> /*
>  * Suppress RCU lockdep false positive.
>  */
> #ifdef CONFIG_PROVE_RCU
> #define rcu_read_lock_suppress rcu_read_lock
> #else
> #define rcu_read_lock_suppress
> #endif

No, you don't need anything like this, as rcu_dereference_check already
takes a test for alternate locking.

However, looking more closely at the code, it appears this is the
"the tree is write locked" case as described in radix-tree.h

Looking at rcupdate.h, perhaps we need a version of radix_tree_deref_slot
that uses rcu_dereference_protected?

Copying Paul McKenney for rcu ...

milton
