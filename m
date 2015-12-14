From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/6] ext[24]: MBCache rewrite
Date: Mon, 14 Dec 2015 22:14:10 +0100
Message-ID: <20151214211410.GP8474@quack.suse.cz>
References: <1449683858-28936-1-git-send-email-jack@suse.cz>
 <CAHpGcMKvyBqouqaq7zhCrxDCjW3vq_GE_wfoDyK00=ppPeYWzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Laurent GUERBY <laurent@guerby.net>,
	Andreas Dilger <adilger@dilger.ca>
To: Andreas =?iso-8859-1?Q?Gr=FCnbacher?=
	<andreas.gruenbacher@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290AbbLNVOM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Dec 2015 16:14:12 -0500
Content-Disposition: inline
In-Reply-To: <CAHpGcMKvyBqouqaq7zhCrxDCjW3vq_GE_wfoDyK00=ppPeYWzQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Sat 12-12-15 00:57:01, Andreas Gr=FCnbacher wrote:
> 2015-12-09 18:57 GMT+01:00 Jan Kara <jack@suse.cz>:
> > Hello,
> >
> > inspired by recent reports [1] of problems with mbcache I had a loo=
k into what
> > we could to improve it. I found the current code rather overenginee=
red
> > (counting with single entry being in several indices, having homegr=
own
> > implementation of rw semaphore, ...).
> >
> > After some thinking I've decided to just reimplement mbcache instea=
d of
> > improving the original code in small steps since the fundamental ch=
anges in
> > locking and layout would be actually harder to review in small step=
s than in
> > one big chunk and overall the new mbcache is actually pretty simple=
 piece of
> > code (~450 lines).
> >
> > The result of rewrite is smaller code (almost half the original siz=
e), smaller
> > cache entries (7 longs instead of 13), and better performance (see =
below
> > for details).
>=20
> I agree that mbcache has scalability problems worth fixing; you may
> also be right about replacing instead of fixing it.
>=20
> I would prefer an actual replacement over adding mbcache2 though: the
> two existing users will be converted immediately; there is no point i=
n
> keeping the old version around. For that, can the current mbcache be
> converted to the API of the new one in a separate patch first (alloc =
+
> insert vs. create, get + release/free vs. delete_block)?

Well, conversion into the new API isn't that trivial because of the
lifetime / locking differences. If people prefer it, I can add a patch =
that
just renames everything from mb2 to mb after the old code is removed.
Opinions?

> The corner cases that mbcache has problems with are:
>=20
> (1) Many files with the same xattrs: Right now, an xattr block can be
> shared among at most EXT[24]_XATTR_REFCOUNT_MAX =3D 2^10 inodes. If 2=
^20

Do you know why there's this limit BTW? The on-disk format can support =
upto
2^32 references...

> inodes are cached, they will have at least 2^10 xattr blocks, all of
> which will end up in the same hash chain. An xattr block should be
> removed from the mbcache once it has reached its maximum refcount, bu=
t
> if I haven't overlooked something, this doesn't happen right now.
> Fixing that should be relatively easy.

Yeah, that sounds like a good optimization. I'll try that.

> (2) Very many files with unique xattrs. We might be able to come up
> with a reasonable heuristic or tweaking knob for detecting this case;
> if not, we could at least use a resizable hash table to keep the hash
> chains reasonably short.

So far we limit number of entries in the cache which keeps hash chains
short as well. Using resizable hash table and letting the system balanc=
e
number of cached entries just by shrinker is certainly possible however=
 I'm
not sure whether the complexity is really worth it.

Regarding detection of unique xattrs: We could certainly detect trashin=
g
of mbcache relatively easily. The difficult part if how to detect when =
to
enable it again because the workload can change. I'm thinking about som=
e
backoff mechanism like caching only each k-th entry asked to be inserte=
d
(starting with k =3D 1) and doubling k if we don't reach some low-water=
mark
cache hit ratio in some number of cache lookups, reducing k to half if
we reach high-watermark cache hit ratio. However again I'm not yet
convinced complex schemes like this are worth it for mbcache (although =
it
might be interesting research topic as such) and so I didn't try anythi=
ng
like this for the initial posting.

								Honza
--=20
Jan Kara <jack@suse.com>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
