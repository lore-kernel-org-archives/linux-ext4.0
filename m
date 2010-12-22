From: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] mm: migration: Use rcu_dereference_protected when
 dereferencing the radix tree slot during file page migration
Date: Wed, 22 Dec 2010 11:10:47 +0900
Message-ID: <AANLkTimu1frzVJ3_5NV-iX0TFYTX5zjKQhaN+zn7=VdU@mail.gmail.com>
References: <AANLkTiniXU9B5YpQ+hknOSF-mPig2z9UqqBWz-JwQjDL@mail.gmail.com>
	<20101220152335.GR13914@csn.ul.ie>
	<20101220170146.GS13914@csn.ul.ie>
	<rcu-mm-protected-misuse@mdm.bga.com>
	<20101221122652.GU13914@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Milton Miller <miltonm@bga.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	gerald.schaefer@de.ibm.com,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-ext4@vger.kernel.org, "Ted Ts'o" <tytso@mit.edu>,
	Arun Bhanu <ab@arunbhanu.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Dipankar Sarma <dipankar@in.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35668 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab0LVCKs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Dec 2010 21:10:48 -0500
In-Reply-To: <20101221122652.GU13914@csn.ul.ie>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 21, 2010 at 9:26 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Tue, Dec 21, 2010 at 01:16:23AM -0600, Milton Miller wrote:
>>
>> [ Add Paul back to the CC list, and also Dipankar.
>> =A0Hopefully I killed the mime encodings correctly ]
>>
>> On Tue, 21 Dec 2010 at 08:48:50 +0900, Minchan Kim wrote:
>> > On Tue, Dec 21, 2010 at 2:01 AM, Mel Gorman <mel@csn.ul.ie> wrote:
>> > > On Mon, Dec 20, 2010 at 03:23:36PM +0000, Mel Gorman wrote:
>> > > > migrate_pages() -> unmap_and_move() only calls rcu_read_lock()=
 for anonymous
>> > > > pages, as introduced by git commit 989f89c57e6361e7d16fbd9572b=
5da7d313b073d.
>> > > > The point of the RCU protection there is part of getting a sta=
ble reference
>> > > > to anon_vma and is only held for anon pages as file pages are =
locked
>> > > > which is sufficient protection against freeing.
>> > > >
>> > > > However, while a file page's mapping is being migrated, the ra=
dix
>> > > > tree is double checked to ensure it is the expected page. This=
 uses
>> > > > radix_tree_deref_slot() -> rcu_dereference() without the RCU l=
ock held
>> > > > triggering the following warning under CONFIG_PROVE_RCU.
>> > > >
>> > > > [ 173.674290] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> > > > [ 173.676016] [ INFO: suspicious rcu_dereference_check() usage=
=2E ]
>> > > > [ 173.676016] ------------------------------------------------=
---
>> > > > [ 173.676016] include/linux/radix-tree.h:145 invoked rcu_deref=
erence_check() without protection!
>> > > > [ 173.676016]
>> > > > [ 173.676016] other info that might help us debug this:
>> > > > [ 173.676016]
>> > > > [ 173.676016]
>> > > > [ 173.676016] rcu_scheduler_active =3D 1, debug_locks =3D 0
>> > > > [ 173.676016] 1 lock held by hugeadm/2899:
>> > > > [ 173.676016] #0: (&(&inode->i_data.tree_lock)->rlock){..-.-.}=
,at: [<c10e3d2b>] migrate_page_move_mapping+0x40/0x1ab
>> > > > [ 173.676016]
>> > > > [ 173.676016] stack backtrace:
>> > > > [ 173.676016] Pid: 2899, comm: hugeadm Not tainted 2.6.37-rc5-=
autobuild
>> > > > [ 173.676016] Call Trace:
>> > > > [ 173.676016] [<c128cc01>] ? printk+0x14/0x1b
>> > > > [ 173.676016] [<c1063502>] lockdep_rcu_dereference+0x7d/0x86
>> > > > [ 173.676016] [<c10e3db5>] migrate_page_move_mapping+0xca/0x1a=
b
>> > > > [ 173.676016] [<c10e41ad>] migrate_page+0x23/0x39
>> > > > [ 173.676016] [<c10e491b>] buffer_migrate_page+0x22/0x107
>> > > > [ 173.676016] [<c10e48f9>] ? buffer_migrate_page+0x0/0x107
>> > > > [ 173.676016] [<c10e425d>] move_to_new_page+0x9a/0x1ae
>> > > > [ 173.676016] [<c10e47e6>] migrate_pages+0x1e7/0x2fa
>> > > >
>> > > > This patch introduces radix_tree_deref_slot_protected() which =
calls
>> > > > rcu_dereference_protected(). Users of it must pass in the mapp=
ing->tree_lock
>> > > > that is protecting this dereference. Holding the tree lock pro=
tects against
>> > > > parallel updaters of the radix tree meaning that rcu_dereferen=
ce_protected
>> > > > is allowable.
>> > > >
>> > > > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
>> > > > ---
>> > > > include/linux/radix-tree.h | =A017 +++++++++++++++++
>> > > > mm/migrate.c =A0 =A0 =A0 =A0| =A04 ++--
>> > > > 2 files changed, 19 insertions(+), 2 deletions(-)
>> > > >
>> > > > diff --git a/include/linux/radix-tree.h b/include/linux/radix-=
tree.h
>> > > > index ab2baa5..a1f1672 100644
>> > > > --- a/include/linux/radix-tree.h
>> > > > +++ b/include/linux/radix-tree.h
>> > > > @@ -146,6 +146,23 @@ static inline void *radix_tree_deref_slot=
(void **pslot)
>> > > > }
>> > > >
>> > > > /**
>> > > > + * radix_tree_deref_slot_protected =A0- dereference a slot wi=
thout RCUlock but with tree lock held
>> > > > + * @pslot: =A0pointer to slot, returned by radix_tree_lookup_=
slot
>> > > > + * Returns: item that was stored in that slot with any direct=
 pointer flag
>> > > > + * =A0 =A0 =A0removed.
>> > > > + *
>> > > > + * Similar to radix_tree_deref_slot but only used during migr=
ation when a pages
>> > > > + * mapping is being moved. The caller does not hold the RCU r=
ead lock but it
>> > > > + * must hold the tree lock to prevent parallel updates.
>> > > > + */
>> > > > +static inline void *radix_tree_deref_slot_protected(void **ps=
lot,
>> > > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spinlock=
_t *treelock)
>> > > > +{
>> > > > + =A0 BUG_ON(rcu_read_lock_held());
>> >
>> > Hmm.. Why did you add the check?
>> > If rcu_read_lock were already held, we wouldn't need this new API.
>>
>> I'm not Paul but I can read the code in include/linux/rcuupdate.h.
>>
>> Holding rcu_read_lock_held isn't a problem, but using protected with
>> just the read lock is.
>>
>
> Bah, this was extremely careless of me as it's even written in teh
> documentation. In this specific case, it's simply allowed to ignore w=
hether
> the RCU read lock is held or not and the BUG_ON check was unnecessary=
=2E The
> tree lock protects against parallel updaters which is what we really =
care
> about for using _protected.
>
> In a later cycle, I should look at reducing the RCU read lock hold ti=
me
> in migration. The main thing it's protecting is getting a stable
> reference to anon_vma and it's held longer than is necessary for that=
=2E

Yes.
I think if we want to reduce RCU read lock hold time, we should look
unmap_and_move in case of anon page.
After we hold a reference of anon_vma->external_refcount, anon_vma
would be stable so we can release rcu_read_unlock.
It can save many time.

> In the meantime, can anyone spot a problem with this patch?
>
> =3D=3D=3D=3D CUT HERE =3D=3D=3D=3D
> mm: migration: Use rcu_dereference_protected when dereferencing the r=
adix tree slot during file page migration
>
> migrate_pages() -> unmap_and_move() only calls rcu_read_lock() for an=
onymous
> pages, as introduced by git commit 989f89c57e6361e7d16fbd9572b5da7d31=
3b073d.
> The point of the RCU protection there is part of getting a stable ref=
erence
> to anon_vma and is only held for anon pages as file pages are locked
> which is sufficient protection against freeing.
>
> However, while a file page's mapping is being migrated, the radix tre=
e
> is double checked to ensure it is the expected page. This uses
> radix_tree_deref_slot() -> rcu_dereference() without the RCU lock hel=
d
> triggering the following warning.
>
> [ =A0173.674290] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ =A0173.676016] [ INFO: suspicious rcu_dereference_check() usage. ]
> [ =A0173.676016] ---------------------------------------------------
> [ =A0173.676016] include/linux/radix-tree.h:145 invoked rcu_dereferen=
ce_check() without protection!
> [ =A0173.676016]
> [ =A0173.676016] other info that might help us debug this:
> [ =A0173.676016]
> [ =A0173.676016]
> [ =A0173.676016] rcu_scheduler_active =3D 1, debug_locks =3D 0
> [ =A0173.676016] 1 lock held by hugeadm/2899:
> [ =A0173.676016] =A0#0: =A0(&(&inode->i_data.tree_lock)->rlock){..-.-=
=2E}, at: [<c10e3d2b>] migrate_page_move_mapping+0x40/0x1ab
> [ =A0173.676016]
> [ =A0173.676016] stack backtrace:
> [ =A0173.676016] Pid: 2899, comm: hugeadm Not tainted 2.6.37-rc5-auto=
build
> [ =A0173.676016] Call Trace:
> [ =A0173.676016] =A0[<c128cc01>] ? printk+0x14/0x1b
> [ =A0173.676016] =A0[<c1063502>] lockdep_rcu_dereference+0x7d/0x86
> [ =A0173.676016] =A0[<c10e3db5>] migrate_page_move_mapping+0xca/0x1ab
> [ =A0173.676016] =A0[<c10e41ad>] migrate_page+0x23/0x39
> [ =A0173.676016] =A0[<c10e491b>] buffer_migrate_page+0x22/0x107
> [ =A0173.676016] =A0[<c10e48f9>] ? buffer_migrate_page+0x0/0x107
> [ =A0173.676016] =A0[<c10e425d>] move_to_new_page+0x9a/0x1ae
> [ =A0173.676016] =A0[<c10e47e6>] migrate_pages+0x1e7/0x2fa
>
> This patch introduces radix_tree_deref_slot_protected() which calls
> rcu_dereference_protected(). Users of it must pass in the mapping->tr=
ee_lock
> that is protecting this dereference. Holding the tree lock protects
> against parallel updaters of the radix tree meaning that
> rcu_dereference_protected is allowable.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

This is what I want.
Thanks.

--=20
Kind regards,
Minchan Kim
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
