From: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] mm: migration: Use rcu_dereference_protected when
	dereferencing the radix tree slot during file page migration
Date: Tue, 21 Dec 2010 10:49:08 +0000
Message-ID: <20101221104907.GT13914@csn.ul.ie>
References: <20101220152335.GR13914@csn.ul.ie> <20101220170146.GS13914@csn.ul.ie> <AANLkTiniXU9B5YpQ+hknOSF-mPig2z9UqqBWz-JwQjDL@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>,
	gerald.schaefer@de.ibm.com,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-ext4@vger.kernel.org,
	Ted Ts'o <tytso@mit.edu>, Arun Bhanu <ab@arunbhanu.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Minchan Kim <minchan.kim@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gir.skynet.ie ([193.1.99.77]:42294 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab0LUKt2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Dec 2010 05:49:28 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTiniXU9B5YpQ+hknOSF-mPig2z9UqqBWz-JwQjDL@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 21, 2010 at 08:48:50AM +0900, Minchan Kim wrote:
> On Tue, Dec 21, 2010 at 2:01 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> > On Mon, Dec 20, 2010 at 03:23:36PM +0000, Mel Gorman wrote:
> >> migrate_pages() -> unmap_and_move() only calls rcu_read_lock() for=
 anonymous
> >> pages, as introduced by git commit 989f89c57e6361e7d16fbd9572b5da7=
d313b073d.
> >> The point of the RCU protection there is part of getting a stable =
reference
> >> to anon_vma and is only held for anon pages as file pages are lock=
ed
> >> which is sufficient protection against freeing.
> >>
> >> However, while a file page's mapping is being migrated, the radix
> >> tree is double checked to ensure it is the expected page. This use=
s
> >> radix_tree_deref_slot() -> rcu_dereference() without the RCU lock =
held
> >> triggering the following warning under CONFIG_PROVE_RCU.
> >>
> >> [ =A0173.674290] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> [ =A0173.676016] [ INFO: suspicious rcu_dereference_check() usage.=
 ]
> >> [ =A0173.676016] -------------------------------------------------=
--
> >> [ =A0173.676016] include/linux/radix-tree.h:145 invoked rcu_derefe=
rence_check() without protection!
> >> [ =A0173.676016]
> >> [ =A0173.676016] other info that might help us debug this:
> >> [ =A0173.676016]
> >> [ =A0173.676016]
> >> [ =A0173.676016] rcu_scheduler_active =3D 1, debug_locks =3D 0
> >> [ =A0173.676016] 1 lock held by hugeadm/2899:
> >> [ =A0173.676016] =A0#0: =A0(&(&inode->i_data.tree_lock)->rlock){..=
-.-.}, at: [<c10e3d2b>] migrate_page_move_mapping+0x40/0x1ab
> >> [ =A0173.676016]
> >> [ =A0173.676016] stack backtrace:
> >> [ =A0173.676016] Pid: 2899, comm: hugeadm Not tainted 2.6.37-rc5-a=
utobuild
> >> [ =A0173.676016] Call Trace:
> >> [ =A0173.676016] =A0[<c128cc01>] ? printk+0x14/0x1b
> >> [ =A0173.676016] =A0[<c1063502>] lockdep_rcu_dereference+0x7d/0x86
> >> [ =A0173.676016] =A0[<c10e3db5>] migrate_page_move_mapping+0xca/0x=
1ab
> >> [ =A0173.676016] =A0[<c10e41ad>] migrate_page+0x23/0x39
> >> [ =A0173.676016] =A0[<c10e491b>] buffer_migrate_page+0x22/0x107
> >> [ =A0173.676016] =A0[<c10e48f9>] ? buffer_migrate_page+0x0/0x107
> >> [ =A0173.676016] =A0[<c10e425d>] move_to_new_page+0x9a/0x1ae
> >> [ =A0173.676016] =A0[<c10e47e6>] migrate_pages+0x1e7/0x2fa
> >>
> >> This patch introduces radix_tree_deref_slot_protected() which call=
s
> >> rcu_dereference_protected(). Users of it must pass in the mapping-=
>tree_lock
> >> that is protecting this dereference. Holding the tree lock protect=
s against
> >> parallel updaters of the radix tree meaning that rcu_dereference_p=
rotected
> >> is allowable.
> >>
> >> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> >> ---
> >> =A0include/linux/radix-tree.h | =A0 17 +++++++++++++++++
> >> =A0mm/migrate.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A04 ++--
> >> =A02 files changed, 19 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree=
=2Eh
> >> index ab2baa5..a1f1672 100644
> >> --- a/include/linux/radix-tree.h
> >> +++ b/include/linux/radix-tree.h
> >> @@ -146,6 +146,23 @@ static inline void *radix_tree_deref_slot(voi=
d **pslot)
> >> =A0}
> >>
> >> =A0/**
> >> + * radix_tree_deref_slot_protected =A0 - dereference a slot witho=
ut RCU lock but with tree lock held
> >> + * @pslot: =A0 pointer to slot, returned by radix_tree_lookup_slo=
t
> >> + * Returns: =A0item that was stored in that slot with any direct =
pointer flag
> >> + * =A0 =A0 =A0 =A0 =A0 removed.
> >> + *
> >> + * Similar to radix_tree_deref_slot but only used during migratio=
n when a pages
> >> + * mapping is being moved. The caller does not hold the RCU read =
lock but it
> >> + * must hold the tree lock to prevent parallel updates.
> >> + */
> >> +static inline void *radix_tree_deref_slot_protected(void **pslot,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spinlock_t *treelock)
> >> +{
> >> + =A0 =A0 BUG_ON(rcu_read_lock_held());
>=20
> Hmm.. Why did you add the check?
> If rcu_read_lock were already held, we wouldn't need this new API.
>=20

Because our earlier discussions assumed that RCU read lock was not held
in this path. The check was added to ensure that assumption was correct=
,
it wasn't.

> >
> > This was a bad idea. After some extended testing, it was obvious th=
at
> > this function can be called for swapcache pages with the RCU lock h=
eld.
> > Paul, is it still permissible to use rcu_dereference_protected() or=
 must
>=20
> I guess has no problem.
>=20
> > the RCU read lock not be held?
> >
>=20
>=20
>=20
> --=20
> Kind regards,
> Minchan Kim
>=20

--=20
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
