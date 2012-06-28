From: Tony Breeds <tony@bakeyournoodle.com>
Subject: Re: Minimal configuration for e2fsprogs
Date: Thu, 28 Jun 2012 12:43:56 +1000
Message-ID: <20120628024356.GB17989@thor.bakeyournoodle.com>
References: <20120615042421.GA7021@thor.bakeyournoodle.com>
 <20120627112117.GA15231@thor.bakeyournoodle.com>
 <20120627125443.GA32356@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:40020 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab2F1CoA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jun 2012 22:44:00 -0400
Content-Disposition: inline
In-Reply-To: <20120627125443.GA32356@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 27, 2012 at 08:54:43AM -0400, Theodore Ts'o wrote:
=20
> Well, rb_insert_extent() isn't returning an error; it's returning
> whether or not it needed to insert an extent or not.  And the bigger
> problem is there's no way to return an error all the way up the
> callchain, since it ultimately gets called by functions like
> ext2fs_mark_block_bitmap() which never contemplated that the function
> might fail.

Okay.  I shoudl have read more carefully.
=20
> So there really is no way to return an error at this point, and if you
> fail allocating memory, we're kind of doomed anyway.  We could replace
> this with an abort(), but there's really not much else we can do here.
>=20
> I suppose, more generally, we could add a new callback which gets
> called on memory allocation failures; although in practice, the place
> where we are most likely to run into trouble is e2fsck, and we already
> have sufficient debugging code there thanks to e2fsck/sigcatcher.c.
> So maybe just using an abort() is the best approach for now.

Okay so I think you want somethign like:
---
diff --git a/e2fsck/sigcatcher.c b/e2fsck/sigcatcher.c
index 10b9328..bd56c3f 100644
--- a/e2fsck/sigcatcher.c
+++ b/e2fsck/sigcatcher.c
@@ -387,6 +387,7 @@ void sigcatcher_setup(void)
 	sigaction(SIGILL, &sa, 0);
 	sigaction(SIGBUS, &sa, 0);
 	sigaction(SIGSEGV, &sa, 0);
+	sigaction(SIGABRT, &sa, 0);
 }=09
=20
=20
diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
index e6b7e04..74140ec 100644
--- a/lib/ext2fs/blkmap64_rb.c
+++ b/lib/ext2fs/blkmap64_rb.c
@@ -134,10 +134,8 @@ static void rb_get_new_extent(struct bmap_rb_extent **=
ext, __u64 start,
=20
 	retval =3D ext2fs_get_mem(sizeof (struct bmap_rb_extent),
 				&new_ext);
-	if (retval) {
-		perror("ext2fs_get_mem");
-		exit(1);
-	}
+	if (retval)
+		abort();
=20
 	new_ext->start =3D start;
 	new_ext->count =3D count;
---

Adding something that calls itself abort() wont be hard in yaboot.

> So I believe the only place where the dblist.o file is getting dragged
> in is due to the call to ext2fs_free_dblist() in freefs.c.  Can you
> confirm this?

What I did was remove dblist.o from my libext2fs.a and I now get:
/home/tony/src/e2fsprogs/../e2fsprogs-root/lib/libext2fs.a(gen_bitmap64.o):=
 In function `ext2fs_alloc_generic_bmap':
/home/tony/src/e2fsprogs-build/lib/ext2fs/../../../e2fsprogs/lib/ext2fs/gen=
_bitmap64.c:112: undefined reference to `ext2fs_get_num_dirs'

So it looks like dblist.o is being pulled in for ext2fs_get_num_dirs()
in that case a EXT2FS_BMAP64_AUTODIR bmap type has been asked for.

How would you feel about moving ext2fs_get_num_dirs from dblist.c to
blknum.c?

> If so, probably the way to solve this is the via the same trick we do
> with fs->write_bitmaps() --- see how we only call fs->write_bitmaps()
> if it is defined in ext2fs_close2(); this was done precisely to avoid
> dragging in the write_bitmaps code if it's not needed for programs
> which are opening the file system read/only.

I didn't really look at this because of what I discovered above.

Yours Tony

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP68TrAAoJEEsCiJRY75GKiZEQAKJ0zfDy8zFlFawvL2n2wAgp
N6UCS3aV97gOMD3lc2aw3k0iTukUFvU5OYNORmkcAUgW5zNvzjTCoy93sRnDyLzW
SOEipNr3DVqHoIUiDmuNsdW5oRrVF+dQFYHVQIxQiYMjYJFkuOyLORsySamdm7Ho
/qf1IZMl9ehZBK/crxuRfdUq1sVjaMLPbMHOTIZUOOA0h2j3KSL5hMVofqfIs1wx
3bsAsc9CpXq+cZvVLrnYA/7+LAscyyT3xi7tOn/L7DG5AcMoSV8Rfb5HvmM9sZ3T
VFXvCqxzk3hSDVa2CT2IyFp2UChRZtibRvIGeXwgq765Wzugp1kojtQkZT9+KR6R
euVyM6oACPzBZnyo/ZYyB6qyM86cbQWbL7iVcI9kAJjgP/adIebSBgekdNKc3zik
Pz+mAD0ATsJPHp3RXDzMe+Wbkfoz1As6EBbKqLUdL4B0haCBQ+VgBu+DE1LBl3bh
SvPIsLZXSrkcSBMlbPGgglORAXTeqV/HPctzX9E4raiyOdm79HZr/KLBOtIBZu06
MNdoIntk5BDmh8uqgxIv07zRGTKFk2ooH8Nc3Thh/UYujG0yXtf10D+C5057CG0P
mvM5EWSIO4baQpPxIQljDl+Ln2XliuX5iPAOx88URWncwgRqLaKWP8d/rkrXut9D
gD9k/eBxj7K3K2cq5afL
=Xs7V
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
