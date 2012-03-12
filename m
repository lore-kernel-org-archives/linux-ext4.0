From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 4/5] libext2fs: Implement ext2fs_find_first_zero_generic_bmap().
Date: Mon, 12 Mar 2012 17:09:50 -0600
Message-ID: <5D9B4A3A-D5F9-4F94-ADA7-2E2CE88FAEE5@dilger.ca>
References: <20120310213321.GK6961@sli.dy.fi> <20120310213740.GO6961@sli.dy.fi> <5E845FD5-30E4-47A1-AF8E-70A288E3442D@dilger.ca> <20120312191514.GS6961@sli.dy.fi>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-3--1048211484"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Sami Liedes <sami.liedes@iki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:14098 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab2CLXJd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Mar 2012 19:09:33 -0400
In-Reply-To: <20120312191514.GS6961@sli.dy.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-3--1048211484
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=us-ascii

On 2012-03-12, at 1:15 PM, Sami Liedes wrote:
> On Sun, Mar 11, 2012 at 03:51:05AM -0600, Andreas Dilger wrote:
>> Rather than making the bitmap searching loop more efficient, I've =
always thought
>> it would be better to have an interface that iterates over the bitmap =
and returns
>> the next set bit.  It is similar to what you implemented with =
->find_first_zero(),
>> but it would be better to have (IMHO) ->find_next_zero() and =
->find_next_set().
>=20
> I've been thinking about this. Such an interface might be a good idea,
> and I could implement it and a corresponding backend implementation
> for the bit array backend, but I don't think ext2fs_new_inode() could
> properly exercise it and I'm hesitant to submit code that isn't tested
> by being actually properly used somewhere.

It is actually common practise in e2fsprogs to embed test programs in =
the
code being modified.  See tst_bitmaps.c, for example.  That can give you
better test coverage for rarely executed code, and the tests should be =
run
by anyone modifying the e2fsprogs code and for every RPM build.

The ext2fs_new_block2() function could be improved in a similar manner, =
and
in fact benefits even more than the inode allocator, because far more =
blocks
are allocated under normal usage.

> I will still do it if there's a general consensus that it's a good =
idea.

Let's hear back from Ted first.  He will probably have some good =
feedback on
the API design that he would like.

> It could be something along the lines of
>=20
> * type ext2fs_bitmap_iterator, opaque to calling code, mainly a magic
>  number and backend-specific private data. In the bitarray case it
>  could just be the number of the bit pointed to and the end of the
>  range to iterate.
>=20
> * bool bitmap_ops->deref_iterator(ext2fs_generic_bitmap, =
ext2fs_bitmap_iterator)
>=20
> * ext2fs_bitmap_iterator ops->create_iterator()
>                            ->create_ranged_iterator(__u64 start, __u64 =
end)
>                            ->free_iterator(ext2fs_bitmap_iterator)=20
>=20
> * __u64 bitmap_ops->iterator_position(...)
>=20
> * errcode_t ops->find_next_zero(..., __u64 *pos),
>               ->find_next_set(..., __u64 *pos)
>  * These would both increment the iterator and, if pos !=3D NULL, set
>    *pos to the new bit position
>=20
> * Modifying a bitmap invalidates all its iterators in such a way that
>  the only legal operation for them afterwards is ->free_iterator()

Note that there is already the rbtree bitmap implementation, which is =
needed
for huge filesystems in order to be able to run e2fsck without needing =
huge
amounts of RAM, so it should also have a backend iterator =
implementation.

> In the case of ext2fs_new_inode(), the function does not actually
> iterate through all zero bits; it really only wants to find the first
> zero in a certain range, after which it returns. So for simplicity of
> use (and efficiency) I think it still makes sense to have
> ->find_first_zero() too.
>=20
> 	Sami


Cheers, Andreas






--Apple-Mail-3--1048211484
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org

iD8DBQFPXoI+pIg59Q01vtYRAp8YAJ9gG55meh/O/f8LMGomLiJZxmx9UACfTrMy
yASOBJ6CGPMjYGSQjbR8ym8=
=BTiA
-----END PGP SIGNATURE-----

--Apple-Mail-3--1048211484--
