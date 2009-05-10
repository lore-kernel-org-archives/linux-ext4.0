From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Sun, 10 May 2009 18:53:00 +0200
Message-ID: <20090510165259.GA31850@logfs.org>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Cc: Matthew Wilcox <willy@linux.intel.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E1M2ts6-0005jr-Cg@closure.thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 9 May 2009 17:14:14 -0400, Theodore Ts'o wrote:
>
> 3480.784009: ext4_discard_blocks: dev dm-0 blk 15461632 count 32
> 3480.784015: ext4_discard_blocks: dev dm-0 blk 17057632 count 32
> 3480.784023: ext4_discard_blocks: dev dm-0 blk 17049120 count 32
> 3480.784026: ext4_discard_blocks: dev dm-0 blk 17045408 count 32
> 3480.784031: ext4_discard_blocks: dev dm-0 blk 15448634 count 6
> 3480.784036: ext4_discard_blocks: dev dm-0 blk 17146618 count 1
> 3480.784039: ext4_discard_blocks: dev dm-0 blk 17146370 count 1
> 3480.784043: ext4_discard_blocks: dev dm-0 blk 15967947 count 6
>=20
> What I'm thinking that we might have to do is:
>=20
> *)  Batch the trim requests more than a single commit, by having a
> 	separate rbtree for trim requests
> *)  If blocks get reused, we'll need to remove them from the rbtree
> *)  In some cases, we may be able to collapse the rbtree by querying the
> 	filesystem block allocation data structures to determine that if
> 	we have an entry for blocks 1003-1008 and 1011-1050, and block
> 	1009 and 1010 are unused, we can combine this into a single
> 	trim request for 1003-1050.
> *)  Create an upcall from the block layer to the trim management layer
> 	indicating that the I/O device is idle, so this would be a good
> 	time to send down a whole bunch of trim requeusts.
> *)  Optionally have a mode to support stupid thin-provision
> 	devices that require the trim request to be aligned on some
> 	large 1 or 4 megabyte boundaries, and be multiples of 1-4
> 	megabyte ranges, or they will ignroe them.
> *)  Optionally have a mode which allows the filesystem's block allocator
> 	to query the list of blocks on the "to be trimmed" list, so they
> 	can be reused and hopefully avoid needing to send the trim
> 	request in the first place.

I'm somewhat surprised.  Imo both the current performance impact and
much of your proposal above is ludicrous.  Given the alternative, I
would much rather accept that overlapping writes and discards (and
possibly reads) are illegal and will give undefined results than deal
with an rbtree.  If necessary, the filesystem itself can generate
barriers - and hopefully not an insane number of them.

Independently of that question, though, you seem to send down a large
number of fairly small discard requests.  And I'd wager that many, if
not most, will be completely useless for the underlying device.  Unless
at least part of the discard matches the granularity, it will be
ignored.  And even on large discards, the head and tail bits will likely
be ignored.  So I would have expected that you already handle discard by
looking at the allocator and combining the current request with any free
space on either side.

Also, if the devices would actually announce their granularity, useless
discards could already get ignored at the block layer or filesystem
level.  Even better, if devices are known to ignore discards, none
should every be sent.  That may be wishful thinking, though.

J=C3=B6rn

--=20
There is no worse hell than that provided by the regrets
for wasted opportunities.
-- Andre-Louis Moreau in Scarabouche

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFKBwZrfbqVtkXfjukRAhzWAJ49+VKZHsInlLNopNht6hnq//SYKgCg1RWy
FEzbO1U9lJ5tu3hFyAmKyKk=
=UMGB
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
