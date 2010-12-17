From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [BUG?] memory hotplug: include/linux/radix-tree.h:145 invoked
 rcu_dereference_check() without protection!
Date: Fri, 17 Dec 2010 08:03:29 -0800
Message-ID: <20101217160329.GD2181@linux.vnet.ibm.com>
References: <20101121173726.GG23423@thunk.org>
 <AANLkTimeSWWo-TAJPPH81OO_h1zFzWAT1Gg=XSLyFftH@mail.gmail.com>
 <rcu-radix-tree@mdm.bga.com>
 <20101122061619.GA2764@linux.vnet.ibm.com>
 <1291748509.19276.62.camel@thinkpad>
 <20101208101947.b0646226.kamezawa.hiroyu@jp.fujitsu.com>
 <1292507421.4885.19.camel@thinkpad>
 <AANLkTinfTCpdKo-A8gF+xbss24PNQXvQV6Odh51mXxiH@mail.gmail.com>
 <20101217054722.GG2253@linux.vnet.ibm.com>
 <20101217150827.GA1609@barrios-desktop>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: gerald.schaefer@de.ibm.com,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
	linux-mm@vger.kernel.org, linux-ext4@vger.kernel.org,
	"Ted Ts'o" <tytso@mit.edu>, Arun Bhanu <ab@arunbhanu.com>,
	Mel Gorman <mel@csn.ul.ie>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Minchan Kim <minchan.kim@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60436 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755339Ab0LQQEC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Dec 2010 11:04:02 -0500
Content-Disposition: inline
In-Reply-To: <20101217150827.GA1609@barrios-desktop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 18, 2010 at 12:08:27AM +0900, Minchan Kim wrote:
> On Thu, Dec 16, 2010 at 09:47:22PM -0800, Paul E. McKenney wrote:
> > On Fri, Dec 17, 2010 at 09:04:13AM +0900, Minchan Kim wrote:
> > > On Thu, Dec 16, 2010 at 10:50 PM, Gerald Schaefer
> > > <gerald.schaefer@de.ibm.com> wrote:
> > > > I got the same warning now after increasing /proc/sys/vm/nr_hug=
epages, see
> > > > below. Both cases are easily reproducible: memory unplug with b=
ig page cache,
> > > > or adding large pages during run-time.
> > > >
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> > > > [ INFO: suspicious rcu_dereference_check() usage. ]
> > > > ---------------------------------------------------
> > > > include/linux/radix-tree.h:145 invoked rcu_dereference_check() =
without protection!
> > > >
> > > > other info that might help us debug this:
> > > >
> > > >
> > > > rcu_scheduler_active =3D 1, debug_locks =3D 0
> > > > 1 lock held by bash/761:
> > > > =A0#0: =A0(&(&inode->i_data.tree_lock)->rlock){..-.-.}, at: [<0=
0000000002263ae>] migrate_page_move_mapping+0x4a/0x2d8
> > > >
> > > > stack backtrace:
> > > > CPU: 1 Not tainted 2.6.37-rc6 #4
> > > > Process bash (pid: 761, task: 00000000181b5540, ksp: 0000000018=
1bb7f8)
> > > > 00000000181bb818 00000000181bb798 0000000000000002 000000000000=
0000
> > > > =A0 =A0 =A0 00000000181bb838 00000000181bb7b0 00000000181bb7b0 =
000000000056bafa
> > > > =A0 =A0 =A0 0000000000000000 000000003f42bdf0 0000000000000002 =
000000001c43be30
> > > > =A0 =A0 =A0 000003e00000000d 000003e00000000c 00000000181bb800 =
0000000000000000
> > > > =A0 =A0 =A0 0000000000000000 0000000000100bfa 00000000181bb798 =
00000000181bb7d8
> > > > Call Trace:
> > > > ([<0000000000100b02>] show_trace+0xee/0x144)
> > > > =A0[<000000000022654e>] migrate_page_move_mapping+0x1ea/0x2d8
> > > > =A0[<0000000000226c80>] migrate_page+0x38/0x68
> > > > =A0[<0000000000226d9a>] move_to_new_page+0xea/0x2bc
> > > > =A0[<000000000022785a>] migrate_pages+0x496/0x568
> > > > =A0[<000000000021e24e>] compact_zone+0x432/0x7d8
> > > > =A0[<000000000021e772>] compact_zone_order+0x9e/0xbc
> > > > =A0[<000000000021ed52>] try_to_compact_pages+0x1ba/0x24c
> > > > =A0[<00000000001e1afa>] __alloc_pages_nodemask+0x86a/0xa64
> > > > =A0[<000000000021c80c>] alloc_fresh_huge_page.clone.2+0x68/0x18=
c
> > > > =A0[<000000000021cc4c>] set_max_huge_pages.clone.0+0xa4/0x1ac
> > > > =A0[<000000000021ce06>] hugetlb_sysctl_handler+0xb2/0xcc
> > > > =A0[<00000000002a6572>] proc_sys_call_handler+0xe6/0x10c
> > > > =A0[<00000000002a65be>] proc_sys_write+0x26/0x34
> > > > =A0[<00000000002336e0>] vfs_write+0xac/0x18c
> > > > =A0[<00000000002338bc>] SyS_write+0x58/0xa8
> > > > =A0[<0000000000113976>] sysc_noemu+0x16/0x1c
> > > > =A0[<0000020000162edc>] 0x20000162edc
> > > > INFO: lockdep is turned off.
> > > >
> > > > I honestly do not understand 100% why this is a false positive,=
 seeing that
> > > > e.g. find_get_page() will also use radix_tree_deref_slot(), hol=
ding only the
> > > > rcu_read_lock, while migrate_page_move_mapping() has no rcu_rea=
d_lock() but
> > > > the &mapping->tree_lock instead. So I'm not quite sure how to f=
ix this
> > > > properly, but simply adding rcu_read_lock/unlock() to the affec=
ted code paths,
> > > > even if it is not necessary for synchronization, would get rid =
of the warning,
> > > > like in the following patch. Any ideas?
> > >=20
> > > In case of anon page, we hold rcu_read_lock in unmap_and_move.
> > > The problem is file-backed page. In case of that, we hold lock_pa=
ge
> > > and mapping->tree_lock as update-side lock.
> > > So we don't need rcu_read_lock.
> > >=20
> > > >
> > > > ---
> > > > =A0fs/hugetlbfs/inode.c | =A0 =A02 ++
> > > > =A0mm/migrate.c =A0 =A0 =A0 =A0 | =A0 =A04 ++++
> > > > =A02 files changed, 6 insertions(+)
> > > >
> > > > --- a/fs/hugetlbfs/inode.c
> > > > +++ b/fs/hugetlbfs/inode.c
> > > > @@ -580,7 +580,9 @@ static int hugetlbfs_migrate_page(struct
> > > > =A0{
> > > > =A0 =A0 =A0 =A0int rc;
> > > >
> > > > + =A0 =A0 =A0 rcu_read_lock();
> > > > =A0 =A0 =A0 =A0rc =3D migrate_huge_page_move_mapping(mapping, n=
ewpage, page);
> > > > + =A0 =A0 =A0 rcu_read_unlock();
> > > > =A0 =A0 =A0 =A0if (rc)
> > > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> > > > =A0 =A0 =A0 =A0migrate_page_copy(newpage, page);
> > > > --- a/mm/migrate.c
> > > > +++ b/mm/migrate.c
> > > > @@ -417,7 +417,9 @@ int migrate_page(struct address_space *m
> > > >
> > > > =A0 =A0 =A0 =A0BUG_ON(PageWriteback(page)); =A0 =A0/* Writeback=
 must be complete */
> > > >
> > > > + =A0 =A0 =A0 rcu_read_lock();
> > > > =A0 =A0 =A0 =A0rc =3D migrate_page_move_mapping(mapping, newpag=
e, page);
> > > > + =A0 =A0 =A0 rcu_read_unlock();
> > > >
> > > > =A0 =A0 =A0 =A0if (rc)
> > > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> > > > @@ -444,7 +446,9 @@ int buffer_migrate_page(struct address_s
> > > >
> > > > =A0 =A0 =A0 =A0head =3D page_buffers(page);
> > > >
> > > > + =A0 =A0 =A0 rcu_read_lock();
> > > > =A0 =A0 =A0 =A0rc =3D migrate_page_move_mapping(mapping, newpag=
e, page);
> > > > + =A0 =A0 =A0 rcu_read_unlock();
> > > >
> > > > =A0 =A0 =A0 =A0if (rc)
> > > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> > > >
> > > >
> > > >
> > >=20
> > >=20
> > > How about this?
> > > Maybe Paul have better idea.
> > > (It's apparently be word-wrapped.)
> > >=20
> > > diff --git a/include/linux/radix-tree.h b/include/linux/radix-tre=
e.h
> > > index ab2baa5..135af1e 100644
> > > --- a/include/linux/radix-tree.h
> > > +++ b/include/linux/radix-tree.h
> > > @@ -146,6 +146,20 @@ static inline void *radix_tree_deref_slot(vo=
id **pslot)
> > >  }
> > >=20
> > >  /**
> > > + * radix_tree_deref_slot_nocheck       - dereference a slot with=
out RCU check
> > > + * @pslot:     pointer to slot, returned by radix_tree_lookup_sl=
ot
> > > + * Returns:    item that was stored in that slot with any direct=
 pointer flag
> > > + *             removed.
> > > + *
> > > + * This functions works like radix_tree_deref_slot except it doe=
sn't check
> > > + * RCU rule. Normally this funcion is used with update-side lock=
=2E
> > > + * You should use this function very carefully.
> > > + */
> > > +static inline void *radix_tree_deref_slot_nocheck(void **pslot)
> > > +{
> > > +       return rcu_dereference_protected(*pslot, 1);
> >=20
> > I suggest replacing the "1" with lockdep expressions for the locks
> > that you say might be held:
>=20
> It's not hard.
>=20
> >=20
> > 	return rcu_dereference_check(*pslot,
> > 				     lockdep_is_held(&mapping->tree_lock));
>=20
> rcu_dereference_check still pass rcu_read_lock_held check we don't wa=
nt.
> I think rcu_dereference_protected is proper.

You are exactly right.  The only reason that I used rcu_dereference_che=
ck()
instead of rcu_dereference_protected() is because I didn't realize that
RCU readers never called this function.

> Why I don't add lockdep expressions is radix_tree_deref_slot is gener=
al API.
> It might be used anywhere where it doesn't related to mapping->tree_l=
ock.
> If we add argument 'mapping', it has a very strong dependency with ad=
dress_space.
> so I decided making the function general and then caller must use it =
very carefully.
> But I am not strong in this point.

I believe that this would be a good thing.

> > This assumes that when you said "and" you meant both lock_page() an=
d
> > mapping->tree_lock.  Also you need to pass in the mapping, which
> > should not be a problem given likely inlining.
> >=20
> > If you meant that either mapping->tree_lock or page_lock() might be
> > held, I suppose that the page_lock() state could be passed in, but
> > perhaps better to take a general lockdep expression.
> >=20
> > So, either or both?  ;-)
> >=20
> > 						Thanx, Paul
>=20
> I think either is okay. That's because remove_from_page_cache/__remov=
e_from_page_cache
> needs both locks so we can't prevent update if we get a either lock.
> In code context, I think mapping->tree_lock is more readable since it=
 is used near by.

Good!!!  So we only really need to check for one or the other.

> Thanks for the comment, Paul.

No problem!

							Thanx, Paul
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
