From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/6] mbcache2: Reimplement mbcache
Date: Tue, 22 Dec 2015 14:07:52 +0100
Message-ID: <20151222130752.GB7266@quack.suse.cz>
References: <1449683858-28936-1-git-send-email-jack@suse.cz>
 <1449683858-28936-2-git-send-email-jack@suse.cz>
 <CAHpGcMJ_gWOTt89E9RnxSY4-yhdU_OQ14Jb5gJvETzQ_NXvXmA@mail.gmail.com>
 <20151215110809.GA1899@quack.suse.cz>
 <20151216155209.GD16918@quack.suse.cz>
 <CAHpGcMLWgiJ9-9onrYPowoMMgDHbsyLSyZ2wXp4RSRtmUeTgEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Laurent GUERBY <laurent@guerby.net>,
	Andreas Dilger <adilger@dilger.ca>
To: Andreas =?iso-8859-1?Q?Gr=FCnbacher?=
	<andreas.gruenbacher@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60675 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbbLVNHz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Dec 2015 08:07:55 -0500
Content-Disposition: inline
In-Reply-To: <CAHpGcMLWgiJ9-9onrYPowoMMgDHbsyLSyZ2wXp4RSRtmUeTgEw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 22-12-15 13:20:58, Andreas Gr=FCnbacher wrote:
> 2015-12-16 16:52 GMT+01:00 Jan Kara <jack@suse.cz>:
> > On Tue 15-12-15 12:08:09, Jan Kara wrote:
> >> > > +/*
> >> > > + * mb2_cache_entry_delete - delete entry from cache
> >> > > + * @cache - cache where the entry is
> >> > > + * @entry - entry to delete
> >> > > + *
> >> > > + * Delete entry from cache. The entry is unhashed and deleted=
 from the lru list
> >> > > + * so it cannot be found. We also drop the reference to @entr=
y caller gave us.
> >> > > + * However entry need not be freed if there's someone else st=
ill holding a
> >> > > + * reference to it. Freeing happens when the last reference i=
s dropped.
> >> > > + */
> >> > > +void mb2_cache_entry_delete(struct mb2_cache *cache,
> >> > > +                           struct mb2_cache_entry *entry)
> >> >
> >> > This function should become static; there are no external users.
> >>
> >> It's actually completely unused. But if we end up removing entries=
 for
> >> blocks where refcount hit maximum, then it will be used by the fs.=
 Thinking
> >> about removal of entries with max refcount, the slight complicatio=
n is that
> >> when refcount decreases again, we won't insert the entry in cache =
unless
> >> someone calls listattr or getattr for inode with that block. So we=
'll
> >> probably need some more complex logic to avoid this.
> >>
> >> I'll first gather some statistics on the lengths of hash chains an=
d hash
> >> chain scanning when there are few unique xattrs to see whether the
> >> complexity is worth it.
> >
> > So I did some experiments with observing length of hash chains with=
 lots of
> > same xattr blocks. Indeed hash chains get rather long in such case =
as you
> > expected - for F files having V different xattr blocks hash chain l=
enght is
> > around F/V/1024 as expected.
> >
> > I've also implemented logic that removes entry from cache when the =
refcount
> > of xattr block reaches maximum and adds it back when refcount drops=
=2E But
> > this doesn't make hash chains significantly shorter because most of=
 xattr
> > blocks end up close to max refcount but not quite at the maximum (a=
s the
> > benchmark ends up adding & removing references to blocks mostly
> > randomly).
> >
> > That made me realize that any strategy based solely on xattr block =
refcount
> > isn't going to significantly improve the situation.
>=20
> That test scenario probably isn't very realistic: xattrs are mostly
> initialized at or immediately after file create time; they rarely
> removed. Hash chains should shrink significantly for that scenario.

Well, the refcount gets dropped when the file itself is deleted. And th=
at
isn't that rare. So I agree my benchmark isn't completely realistic in
changing the xattr but dropping xattr block refcount due to deleted fil=
e
will be relatively frequent so I don't thing refcount distribution obta=
ined
by my benchmark is completely out.

> In addition, if the hash table is sized reasonably, long hash chains
> won't hurt that much because we can stop searching them as soon as we
> find the first reusable block. This won't help when there are hash
> conflicts, but those should be unlikely.

Well, this is what happens currently as well...
=20
> We are currently using a predictable hash algorithm so attacks on the
> hash table are possible; it's probably not worth protecting against
> that though.

Agreed.

> > What we'd have to do is something like making sure that we cache on=
ly
> > one xattr block with given contents.
>=20
> No, when that one cached block reaches its maximum refcount, we would
> have to allocate another block because we didn't cache the other
> identical, reusable blocks; this would hurt significantly.
>=20
> > However that would make insertions more costly as we'd have to
> > compare full xattr blocks for duplicates instead of just hashes.
>=20
> I don't understand, why would we turn to comparing blocks?

If we wanted to avoid duplicit blocks in the hash table, we'd have to f=
irst
find out whether two blocks are really the same (or whether just 32-bit
hash collided). But as I said (and you seem to agree) this isn't the ri=
ght
way to go anyway.

								Honza
--=20
Jan Kara <jack@suse.com>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
