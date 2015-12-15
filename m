From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/6] mbcache2: Reimplement mbcache
Date: Tue, 15 Dec 2015 12:08:09 +0100
Message-ID: <20151215110809.GA1899@quack.suse.cz>
References: <1449683858-28936-1-git-send-email-jack@suse.cz>
 <1449683858-28936-2-git-send-email-jack@suse.cz>
 <CAHpGcMJ_gWOTt89E9RnxSY4-yhdU_OQ14Jb5gJvETzQ_NXvXmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Laurent GUERBY <laurent@guerby.net>,
	Andreas Dilger <adilger@dilger.ca>
To: Andreas =?iso-8859-1?Q?Gr=FCnbacher?=
	<andreas.gruenbacher@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53039 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964803AbbLOLIL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Dec 2015 06:08:11 -0500
Content-Disposition: inline
In-Reply-To: <CAHpGcMJ_gWOTt89E9RnxSY4-yhdU_OQ14Jb5gJvETzQ_NXvXmA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Sat 12-12-15 00:58:30, Andreas Gr=FCnbacher wrote:
> > +/*
> > + * Mbcache is a simple key-value store.
> > + Keys need not be unique, however
> > + * key-value pairs are expected to be unique (we use this in
> > + * mb2_cache_entry_delete_block()).
>=20
> This comment is very confusing. Could you say what the keys and value=
s
> are and what that kind of cache is used for so that people will have =
a
> chance of understanding what's going on?

I've added some more explanations to the comment.

> > + * We provide functions for creation and removal of entries, searc=
h by key,
> > + * and a special "delete entry with given key-value pair" operatio=
n. Fixed
> > + * size hash table is used for fast key lookups.
> > + */
>=20
> Have you had a look at rhashtables? They would give us lockless
> lookups and they would automatically grow, at somewhat more
> complexity.

No, I didn't have a look at them. As I said I'm not sure the complexity=
 is
worth it. We can have a look into it in future. Lockless lookups could
provide interesting speedups for the case with limited number of unique
xattr blocks. Case with lots of unique xattr blocks will not benefit at
all since that is write-mostly workload...

> > +/*
> > + * mb2_cache_entry_delete - delete entry from cache
> > + * @cache - cache where the entry is
> > + * @entry - entry to delete
> > + *
> > + * Delete entry from cache. The entry is unhashed and deleted from=
 the lru list
> > + * so it cannot be found. We also drop the reference to @entry cal=
ler gave us.
> > + * However entry need not be freed if there's someone else still h=
olding a
> > + * reference to it. Freeing happens when the last reference is dro=
pped.
> > + */
> > +void mb2_cache_entry_delete(struct mb2_cache *cache,
> > +                           struct mb2_cache_entry *entry)
>=20
> This function should become static; there are no external users.

It's actually completely unused. But if we end up removing entries for
blocks where refcount hit maximum, then it will be used by the fs. Thin=
king
about removal of entries with max refcount, the slight complication is =
that
when refcount decreases again, we won't insert the entry in cache unles=
s
someone calls listattr or getattr for inode with that block. So we'll
probably need some more complex logic to avoid this.

I'll first gather some statistics on the lengths of hash chains and has=
h
chain scanning when there are few unique xattrs to see whether the
complexity is worth it.

> > +/* Shrink number of entries in cache */
> > +static unsigned long mb2_cache_scan(struct shrinker *shrink,
> > +                                   struct shrink_control *sc)
> > +{
> > +       int nr_to_scan =3D sc->nr_to_scan;
> > +       struct mb2_cache *cache =3D container_of(shrink, struct mb2=
_cache,
> > +                                             c_shrink);
> > +       struct mb2_cache_entry *entry;
> > +       struct hlist_bl_head *head;
> > +       unsigned int shrunk =3D 0;
> > +
> > +       spin_lock(&cache->c_lru_list_lock);
> > +       while (nr_to_scan-- && !list_empty(&cache->c_lru_list)) {
> > +               entry =3D list_first_entry(&cache->c_lru_list,
> > +                                        struct mb2_cache_entry, e_=
lru_list);
> > +               list_del_init(&entry->e_lru_list);
> > +               cache->c_entry_count--;
> > +               /*
> > +                * We keep LRU list reference so that entry doesn't=
 go away
> > +                * from under us.
> > +                */
> > +               spin_unlock(&cache->c_lru_list_lock);
> > +               head =3D entry->e_hash_list_head;
> > +               hlist_bl_lock(head);
>=20
> Instead of taking and dropping c_lru_list_lock in the loop, could we
> get away with a simple-to-implement hlist_bl_trylock() and
> cond_resched_lock()?

=46or now I'd keep things simple. Since we limit number of entries in c=
ache
ourselves, shrinker doesn't get used that often and so the lock traffic=
 on
lru_list_lock from it is minimal...

								Honza
--=20
Jan Kara <jack@suse.com>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
