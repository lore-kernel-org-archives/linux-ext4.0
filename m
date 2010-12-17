From: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [BUG?] memory hotplug: include/linux/radix-tree.h:145 invoked
	rcu_dereference_check() without protection!
Date: Fri, 17 Dec 2010 08:39:12 +0000
Message-ID: <20101217083912.GM13914@csn.ul.ie>
References: <20101121133024.GF23423@thunk.org> <20101121153949.GD20947@barrios-desktop> <20101121173726.GG23423@thunk.org> <AANLkTimeSWWo-TAJPPH81OO_h1zFzWAT1Gg=XSLyFftH@mail.gmail.com> <rcu-radix-tree@mdm.bga.com> <20101122061619.GA2764@linux.vnet.ibm.com> <1291748509.19276.62.camel@thinkpad> <20101208101947.b0646226.kamezawa.hiroyu@jp.fujitsu.com> <1292507421.4885.19.camel@thinkpad> <AANLkTinfTCpdKo-A8gF+xbss24PNQXvQV6Odh51mXxiH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: gerald.schaefer@de.ibm.com,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	paulmck@linux.vnet.ibm.com, Milton Miller <miltonm@bga.com>,
	linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
	linux-ext4@vger.kernel.org, Ted Ts'o <tytso@mit.edu>,
	Arun Bhanu <ab@arunbhanu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Minchan Kim <minchan.kim@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gir.skynet.ie ([193.1.99.77]:57899 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab0LQIjc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Dec 2010 03:39:32 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTinfTCpdKo-A8gF+xbss24PNQXvQV6Odh51mXxiH@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 17, 2010 at 09:04:13AM +0900, Minchan Kim wrote:
> On Thu, Dec 16, 2010 at 10:50 PM, Gerald Schaefer
> <gerald.schaefer@de.ibm.com> wrote:
> > I got the same warning now after increasing /proc/sys/vm/nr_hugepag=
es, see
> > below. Both cases are easily reproducible: memory unplug with big p=
age cache,
> > or adding large pages during run-time.
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> > [ INFO: suspicious rcu_dereference_check() usage. ]
> > ---------------------------------------------------
> > include/linux/radix-tree.h:145 invoked rcu_dereference_check() with=
out protection!
> >
> > other info that might help us debug this:
> >
> >
> > rcu_scheduler_active =3D 1, debug_locks =3D 0
> > 1 lock held by bash/761:
> > =A0#0: =A0(&(&inode->i_data.tree_lock)->rlock){..-.-.}, at: [<00000=
000002263ae>] migrate_page_move_mapping+0x4a/0x2d8
> >
> > stack backtrace:
> > CPU: 1 Not tainted 2.6.37-rc6 #4
> > Process bash (pid: 761, task: 00000000181b5540, ksp: 00000000181bb7=
f8)
> > 00000000181bb818 00000000181bb798 0000000000000002 0000000000000000
> > =A0 =A0 =A0 00000000181bb838 00000000181bb7b0 00000000181bb7b0 0000=
00000056bafa
> > =A0 =A0 =A0 0000000000000000 000000003f42bdf0 0000000000000002 0000=
00001c43be30
> > =A0 =A0 =A0 000003e00000000d 000003e00000000c 00000000181bb800 0000=
000000000000
> > =A0 =A0 =A0 0000000000000000 0000000000100bfa 00000000181bb798 0000=
0000181bb7d8
> > Call Trace:
> > ([<0000000000100b02>] show_trace+0xee/0x144)
> > =A0[<000000000022654e>] migrate_page_move_mapping+0x1ea/0x2d8
> > =A0[<0000000000226c80>] migrate_page+0x38/0x68
> > =A0[<0000000000226d9a>] move_to_new_page+0xea/0x2bc
> > =A0[<000000000022785a>] migrate_pages+0x496/0x568
> > =A0[<000000000021e24e>] compact_zone+0x432/0x7d8
> > =A0[<000000000021e772>] compact_zone_order+0x9e/0xbc
> > =A0[<000000000021ed52>] try_to_compact_pages+0x1ba/0x24c
> > =A0[<00000000001e1afa>] __alloc_pages_nodemask+0x86a/0xa64
> > =A0[<000000000021c80c>] alloc_fresh_huge_page.clone.2+0x68/0x18c
> > =A0[<000000000021cc4c>] set_max_huge_pages.clone.0+0xa4/0x1ac
> > =A0[<000000000021ce06>] hugetlb_sysctl_handler+0xb2/0xcc
> > =A0[<00000000002a6572>] proc_sys_call_handler+0xe6/0x10c
> > =A0[<00000000002a65be>] proc_sys_write+0x26/0x34
> > =A0[<00000000002336e0>] vfs_write+0xac/0x18c
> > =A0[<00000000002338bc>] SyS_write+0x58/0xa8
> > =A0[<0000000000113976>] sysc_noemu+0x16/0x1c
> > =A0[<0000020000162edc>] 0x20000162edc
> > INFO: lockdep is turned off.
> >
> > I honestly do not understand 100% why this is a false positive, see=
ing that
> > e.g. find_get_page() will also use radix_tree_deref_slot(), holding=
 only the
> > rcu_read_lock, while migrate_page_move_mapping() has no rcu_read_lo=
ck() but
> > the &mapping->tree_lock instead. So I'm not quite sure how to fix t=
his
> > properly, but simply adding rcu_read_lock/unlock() to the affected =
code paths,
> > even if it is not necessary for synchronization, would get rid of t=
he warning,
> > like in the following patch. Any ideas?
>=20
> In case of anon page, we hold rcu_read_lock in unmap_and_move.
> The problem is file-backed page. In case of that, we hold lock_page
> and mapping->tree_lock as update-side lock.
> So we don't need rcu_read_lock.
>=20
> >
> > ---
> > =A0fs/hugetlbfs/inode.c | =A0 =A02 ++
> > =A0mm/migrate.c =A0 =A0 =A0 =A0 | =A0 =A04 ++++
> > =A02 files changed, 6 insertions(+)
> >
> > --- a/fs/hugetlbfs/inode.c
> > +++ b/fs/hugetlbfs/inode.c
> > @@ -580,7 +580,9 @@ static int hugetlbfs_migrate_page(struct
> > =A0{
> > =A0 =A0 =A0 =A0int rc;
> >
> > + =A0 =A0 =A0 rcu_read_lock();
> > =A0 =A0 =A0 =A0rc =3D migrate_huge_page_move_mapping(mapping, newpa=
ge, page);
> > + =A0 =A0 =A0 rcu_read_unlock();
> > =A0 =A0 =A0 =A0if (rc)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> > =A0 =A0 =A0 =A0migrate_page_copy(newpage, page);
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -417,7 +417,9 @@ int migrate_page(struct address_space *m
> >
> > =A0 =A0 =A0 =A0BUG_ON(PageWriteback(page)); =A0 =A0/* Writeback mus=
t be complete */
> >
> > + =A0 =A0 =A0 rcu_read_lock();
> > =A0 =A0 =A0 =A0rc =3D migrate_page_move_mapping(mapping, newpage, p=
age);
> > + =A0 =A0 =A0 rcu_read_unlock();
> >
> > =A0 =A0 =A0 =A0if (rc)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> > @@ -444,7 +446,9 @@ int buffer_migrate_page(struct address_s
> >
> > =A0 =A0 =A0 =A0head =3D page_buffers(page);
> >
> > + =A0 =A0 =A0 rcu_read_lock();
> > =A0 =A0 =A0 =A0rc =3D migrate_page_move_mapping(mapping, newpage, p=
age);
> > + =A0 =A0 =A0 rcu_read_unlock();
> >
> > =A0 =A0 =A0 =A0if (rc)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> >
> >
> >
>=20
>=20
> How about this?
> Maybe Paul have better idea.
> (It's apparently be word-wrapped.)
>=20

heh, I wrote a patch almost identical to this and ran it overnight for =
testing
(test was a memory consumer running while a parallel process grew and s=
hrunk
the hugepage pool). It passes but that is hardly a surprise. We differe=
d
slightly in a number of respects though.

> diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
> index ab2baa5..135af1e 100644
> --- a/include/linux/radix-tree.h
> +++ b/include/linux/radix-tree.h
> @@ -146,6 +146,20 @@ static inline void *radix_tree_deref_slot(void *=
*pslot)
>  }
>=20
>  /**
> + * radix_tree_deref_slot_nocheck       - dereference a slot without =
RCU check
> + * @pslot:     pointer to slot, returned by radix_tree_lookup_slot
> + * Returns:    item that was stored in that slot with any direct poi=
nter flag
> + *             removed.
> + *
> + * This functions works like radix_tree_deref_slot except it doesn't=
 check
> + * RCU rule. Normally this funcion is used with update-side lock.
> + * You should use this function very carefully.
> + */
> +static inline void *radix_tree_deref_slot_nocheck(void **pslot)
> +{
> +       return rcu_dereference_protected(*pslot, 1);
> +}

=46or this, I had

diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index ab2baa5..252d21c 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -146,6 +146,25 @@ static inline void *radix_tree_deref_slot(void **p=
slot)
 }
=20
 /**
+ * radix_tree_deref_slot_protected	- dereference a slot without RCU lo=
ck but with tree lock held
+ * @pslot:	pointer to slot, returned by radix_tree_lookup_slot
+ * Returns:	item that was stored in that slot with any direct pointer =
flag
+ *		removed.
+ *
+ * For use with radix_tree_lookup_slot().  Caller must hold tree read
+ * locked across slot lookup and dereference. Not required if write lo=
ck is
+ * held (ie. items cannot be concurrently inserted).
+ *
+ * radix_tree_deref_retry must be used to confirm validity of the poin=
ter if
+ * only the read lock is held.
+ */
+static inline void *radix_tree_deref_slot_protected(void **pslot,
+							spinlock_t *treelock)
+{
+	return rcu_dereference_protected(*pslot, lockdep_is_held(treelock));
+}
+
+/**
  * radix_tree_deref_retry	- check radix_tree_deref_slot
  * @arg:	pointer returned by radix_tree_deref_slot
  * Returns:	0 if retry is not required, otherwise retry is required

In the documentation, I noted that the check might be without RCU but w=
ith
the knowledge that it's protected by the tree lock. I'm not a RCU exper=
t
but this is only safe when you know there isn't a parallel updater and =
the
treelock should be preventing that, right?

Even so, other users of rcu_dereference_protected() check a lock condit=
ion
which I used tree lock for. I intended to read through the rest of
documentation properly this morning to determine if this was indeed the
right approach.

I used the name _protected instead of _nocheck because the dereference
is still protected (by the tree lock) just not by RCU. Again, have to
check the documentation to ensure this is correct.

> +/**
>   * radix_tree_deref_retry      - check radix_tree_deref_slot
>   * @arg:       pointer returned by radix_tree_deref_slot
>   * Returns:    0 if retry is not required, otherwise retry is requir=
ed
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 2eb2243..5be2841 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -244,7 +244,8 @@ static int migrate_page_move_mapping(struct
> address_space *mappin
>=20
>         expected_count =3D 2 + page_has_private(page);
>         if (page_count(page) !=3D expected_count ||
> -                       (struct page *)radix_tree_deref_slot(pslot) !=
=3D page) {
> +                       (struct page *)radix_tree_deref_slot_nocheck(=
pslot)
> +                               !=3D page) {
>                 spin_unlock_irq(&mapping->tree_lock);
>                 return -EAGAIN;
>         }

We only differed here by my passing in the &mapping->tree_lock



> @@ -316,7 +317,8 @@ int migrate_huge_page_move_mapping(struct
> address_space *mapping,
>=20
>         expected_count =3D 2 + page_has_private(page);
>         if (page_count(page) !=3D expected_count ||
> -           (struct page *)radix_tree_deref_slot(pslot) !=3D page) {
> +           (struct page *)radix_tree_deref_slot_nocheck(pslot)
> +                               !=3D page) {
>                 spin_unlock_irq(&mapping->tree_lock);
>                 return -EAGAIN;
>         }

--=20
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
