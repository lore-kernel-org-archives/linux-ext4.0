From: Tony Breeds <tony@bakeyournoodle.com>
Subject: Re: Minimal configuration for e2fsprogs
Date: Wed, 27 Jun 2012 21:21:17 +1000
Message-ID: <20120627112117.GA15231@thor.bakeyournoodle.com>
References: <20120615042421.GA7021@thor.bakeyournoodle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:55058 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432Ab2F0LVV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jun 2012 07:21:21 -0400
Content-Disposition: inline
In-Reply-To: <20120615042421.GA7021@thor.bakeyournoodle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 15, 2012 at 02:24:21PM +1000, Tony Breeds wrote:
> Hi All,
> 	I appologise if this is not the correct place to discuss this,
> or if it's been discussed before.  In either event please point me in
> the right direction and I'll move along.
>=20
> I'm the maintainer for yaboot a bootloader for powerpc systems.  We link
> against libext2fs.a, but as we're a bootloader we do NOT link against
> libc as such we need to implement a number of "stub" functions to keep
> up with the newer features being added here.

Okay working with an e2fsprogs that has the various patches I've posted
to this list in the last few days I'm down to:
---
/home/tony/src/e2fsprogs/../e2fsprogs-root/lib/libext2fs.a(inline.o): In fu=
nction `ext2fs_get_arrayzero':
/home/tony/src/e2fsprogs-build/lib/ext2fs/../../../e2fsprogs/lib/ext2fs/ext=
2fs.h:1521: undefined reference to `calloc'
/home/tony/src/e2fsprogs/../e2fsprogs-root/lib/libext2fs.a(blkmap64_rb.o): =
In function `rb_get_new_extent':
/home/tony/src/e2fsprogs-build/lib/ext2fs/../../../e2fsprogs/lib/ext2fs/blk=
map64_rb.c:138: undefined reference to `perror'
/home/tony/src/e2fsprogs-build/lib/ext2fs/../../../e2fsprogs/lib/ext2fs/blk=
map64_rb.c:139: undefined reference to `exit'
/home/tony/src/e2fsprogs/../e2fsprogs-root/lib/libext2fs.a(dblist.o): In fu=
nction `ext2fs_dblist_sort2':
/home/tony/src/e2fsprogs-build/lib/ext2fs/../../../e2fsprogs/lib/ext2fs/dbl=
ist.c:217: undefined reference to `qsort'
/home/tony/src/e2fsprogs-build/lib/ext2fs/../../../e2fsprogs/lib/ext2fs/dbl=
ist.c:217: undefined reference to `qsort'
/home/tony/src/e2fsprogs/../e2fsprogs-root/lib/libext2fs.a(dblist.o): In fu=
nction `ext2fs_dblist_sort':
/home/tony/src/e2fsprogs-build/lib/ext2fs/../../../e2fsprogs/lib/ext2fs/dbl=
ist.c:322: undefined reference to `qsort'
/home/tony/src/e2fsprogs-build/lib/ext2fs/../../../e2fsprogs/lib/ext2fs/dbl=
ist.c:322: undefined reference to `qsort'
---
As I've said adding calloc to yaboot is quite reasonable so we can
ignore this one.

Calling perror/exit from this deep in a library doesn't seem right to me I
think a better option would be to change rb_get_new_extent()
to return an errcode_t and pass that up the call chain.  I'm happy to do
that.  If I read rb_insert_extent() correctly I can simply return if
rb_get_new_extent() failed, as nothing as been changed at this point
you've only traversed the rb tree.  The problem is that very few of the
callers of rb_insert_extent() actually check the return value :( so this
patch will be a little bigger than I'd like.

The qsort calls scare me a little.  I expect that bad things would
happen if the directory block wasn't sorted.  So just providing a
qsort() in yaboot that does nothing would be a bad thing.  I'm
kind of hoping you'll just say "as long as you're opening the
file-system read-only the directory block will be sorted so don't sweat
it"  Am I dreaming?

As always happy to do what I can if pointed in the right direction.

Yours Tony

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP6uysAAoJEEsCiJRY75GKdbMP/37yi08heC3jbsOYVUPE9LuP
SdxlxVOuTn33293xx3Xg5b2nkJT1YhVF5QZcwgpCxKrBwHXpwWBUHangVqgktzHi
P3e6dZM7dzBoqVFmgot1cvJ8rX5eKSD7Nu+yHnWvIig7EAO576Htcrgn5AfTsBPi
lQbUWQ/AKeiBjfEYyXeV24A/cFHLDpcC+magho3wejNIQRyJUSVHLHuxwn3VE1Jp
OLCx5E9q0PulDcDQsVuhWjZX4BQTG1Rk4XjSoZpgWihSCHOqAzm8x3Prplo71R0z
iJxr4E3kLXJiDjZ0GqPLZQivicrKt3WLT2BQR/MefZEriS9jyT1DjuBspy55PwJW
9yD8f8F0LB7aomST0R8jKrgAUANstGyTPWwVvml4VSisk3DUs8HQBWPTJgQSC6mY
UU9WhoBHV2UncR8mwOJDSWvRwHXzo5yp+tRo8jUbqmV5TD87AGGrC6WNorVf5h1W
hH78B7Btz3E/c4FLkorS014wtkOC7piLVFOtGBPy0gLv4LxxicJFICSDe2pZxVO4
11Ii30vCRebr59Qu5ieHt2yVfOvIxM4UXfVxrDrPc4pj5yDWD9iBskiwB0aXwFq5
jfNUpKmnuz6la/TdONAceGgcQJFuwormGgmtJH60+CWYvOzdZ2BT+GokyWhfKWMe
fpGf1PRW12+wsxglR88/
=uVoh
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
