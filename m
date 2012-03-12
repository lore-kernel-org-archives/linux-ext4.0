From: Sami Liedes <sami.liedes@iki.fi>
Subject: Re: [PATCH 4/5] libext2fs: Implement
 ext2fs_find_first_zero_generic_bmap().
Date: Mon, 12 Mar 2012 21:15:14 +0200
Message-ID: <20120312191514.GS6961@sli.dy.fi>
References: <20120310213321.GK6961@sli.dy.fi>
 <20120310213740.GO6961@sli.dy.fi>
 <5E845FD5-30E4-47A1-AF8E-70A288E3442D@dilger.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+d/sD+4Memv8CeGA"
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-2.hut.fi ([130.233.228.92]:51379 "EHLO smtp-2.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279Ab2CLTPW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Mar 2012 15:15:22 -0400
Content-Disposition: inline
In-Reply-To: <5E845FD5-30E4-47A1-AF8E-70A288E3442D@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--+d/sD+4Memv8CeGA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 11, 2012 at 03:51:05AM -0600, Andreas Dilger wrote:
> Rather than making the bitmap searching loop more efficient, I've always =
thought
> it would be better to have an interface that iterates over the bitmap and=
 returns
> the next set bit.  It is similar to what you implemented with ->find_firs=
t_zero(),
> but it would be better to have (IMHO) ->find_next_zero() and ->find_next_=
set().

I've been thinking about this. Such an interface might be a good idea,
and I could implement it and a corresponding backend implementation
for the bit array backend, but I don't think ext2fs_new_inode() could
properly exercise it and I'm hesitant to submit code that isn't tested
by being actually properly used somewhere. I will still do it if
there's a general consensus that it's a good idea.

It could be something along the lines of

* type ext2fs_bitmap_iterator, opaque to calling code, mainly a magic
  number and backend-specific private data. In the bitarray case it
  could just be the number of the bit pointed to and the end of the
  range to iterate.

* bool bitmap_ops->deref_iterator(ext2fs_generic_bitmap, ext2fs_bitmap_iter=
ator)

* ext2fs_bitmap_iterator ops->create_iterator()
                            ->create_ranged_iterator(__u64 start, __u64 end)
                            ->free_iterator(ext2fs_bitmap_iterator)=20

* __u64 bitmap_ops->iterator_position(...)

* errcode_t ops->find_next_zero(..., __u64 *pos),
               ->find_next_set(..., __u64 *pos)
  * These would both increment the iterator and, if pos !=3D NULL, set
    *pos to the new bit position

* Modifying a bitmap invalidates all its iterators in such a way that
  the only legal operation for them afterwards is ->free_iterator()

In the case of ext2fs_new_inode(), the function does not actually
iterate through all zero bits; it really only wants to find the first
zero in a certain range, after which it returns. So for simplicity of
use (and efficiency) I think it still makes sense to have
->find_first_zero() too.

	Sami

--+d/sD+4Memv8CeGA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJPXktCAAoJEKLT589SE0a08HEQAMjMFYI2+9bzLM+RTrm7E7m2
FIeeMUU+TeC9v1ZOTh4OWle78YxfuKP8HAet69R5IHuW+rtI4adNMaERmRVY1kR3
DKjvQywbYI/yyxwnwW2Olcfy/TYpqwL9+9EO/kE7IvVC/xvFupDSDBx2Sd0xhxKh
670ZlwIB1b/TKJwCXGnawrr9S8o2DoJ7gZmYiuDtHzTWM5Qj3SEkokk4ulWwDLx9
nlSZHW941cxY0ZrckV18R7Qqzprtln6TyiFB4+AIlVJC4iyvyZ4icm6S4965xL8C
zQyi7ue1ay0dBc9vMRsFBFwiSmqGMvFx4k+2/aIY0gX8VixlHDFHkIbIL+mEvMp6
bkhivXhNb2nKv1lQjTplo1RttB9bYjL+jx7z104wF7xKjAA/V+9zbXwwHslnHD2d
zBwUIBSO5AfsgpWUTM3UPVGrlUr7IHpKmd48qPaFo5ksoASKwFSfcTLvcRCgZ0ty
LLCZ8u8j2N7FTn36Pr+2ZPOu1myL+uhtYJHIUXO7NWBv9p6GJ8BsHHSz+3yMyLzV
RCSJvIS1eP/s8ypwQmCAZOIqlwdF4hFJpuX4W/lgLCtbg6Uidoqnai6IKBjGO945
pdwYf6PVjnHrcxGhHDbiioDp/9w3lk54KXnkNcqHPULC78msx3gWUxnElGVxfdPe
mF5OAMmxBcHDicMNPKHd
=8yAE
-----END PGP SIGNATURE-----

--+d/sD+4Memv8CeGA--
