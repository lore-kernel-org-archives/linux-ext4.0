From: Sami Liedes <sami.liedes@iki.fi>
Subject: Re: Commit c1a1e7fc24d6 causes segfault in ext2fs_new_inode
Date: Fri, 6 Apr 2012 22:14:01 +0300
Message-ID: <20120406191401.GA8816@sli.dy.fi>
References: <20120330125726.GA26221@amd.home.annexia.org>
 <20120330131936.GB26221@amd.home.annexia.org>
 <4F760BC2.4070401@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Cc: "Richard W.M. Jones" <rjones@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-3.hut.fi ([130.233.228.93]:34155 "EHLO smtp-3.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495Ab2DFTOR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Apr 2012 15:14:17 -0400
Content-Disposition: inline
In-Reply-To: <4F760BC2.4070401@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 30, 2012 at 02:38:42PM -0500, Eric Sandeen wrote:
> On 3/30/12 8:19 AM, Richard W.M. Jones wrote:
> > It seems like a non-64-bit-compatible bitmap was being created, and
> > that doesn't have the bitmap->bitmap_ops field initialized because
> > gen_bitmap.c doesn't use this field.  Somehow, though, we end up
> > calling a function in gen_bitmap64.c which requires that this field be
> > defined.

Argh, indeed. I thought the 32-bit bitfields also have the bitmap_ops
field (and in the same offset), but they don't.

> Well here's what's busted:
>=20
>         if (bitmap->bitmap_ops->find_first_zero)
>                 return bitmap->bitmap_ops->find_first_zero(bitmap, start,=
 end, out);
>=20
>         if (!bitmap || !EXT2FS_IS_64_BITMAP(bitmap) || bitmap->cluster_bi=
ts)
>                 return EINVAL;
>=20
> bitmap->bitmap_ops->find_first_zero only exists for a 64-bit bitmap, which
> gets tested after we try to deref it :(

Right, that's quite bogus. The !bitmap test should obviously be first,
not after we first dereference it. Then we should test for 64-bitness,
and only ever touch the bitmap_ops field if we have a 64-bit bitmap.

> I am a little confused by the existence of two different
> struct ext2fs_struct_generic_bitmap's in the code.  But treating one as t=
he
> other looks doomed to failure ;)

In addition to that, there are actually three different versions of
many operations; they are named ext2_foo_bmap(), ext2_foo_bitmap() and
ext2_foo_bitmap2(). I'm quite confused too.

While I suggest passing EXT2_FLAG_64BITS to ext2fs_open() - it should
never break anything and only makes things faster - the code obviously
shouldn't break when that is not passed.

(I wonder if it would make sense to have something like
EXT2_BASE_FLAGS that could include any flags which never hurt,
currently apparently only EXT2_FLAG_64BITS. From the name of the flag
EXT2_FLAG_64BITS it's not obvious that you should always use it. As
far as I understand correctly, it's there only for ABI compatibility
with code compiled before the flag was introduced and it never makes
sense to not pass it in any new code.)

The patch below unbreaks the code (well, at least resize2fs
modified to not pass EXT2_FLAG_64BITS) for me.

	Sami Liedes

------------------------------------------------------------

commit bb8fe012a3b1705809f6129cd9c78d2cd855b1f8
Author: Sami Liedes <sami.liedes@iki.fi>
Date:   Fri Apr 6 22:06:30 2012 +0300

    Fix ext2fs_find_first_zero_generic_bmap() for 32-bit bitmaps.
   =20
    ext2fs_find_first_zero_generic_bmap() tries to handle old-style 32-bit
    bitmaps, but fails in several different ways.
   =20
    Fix the order of the (in)validity tests and the fallback code to never
    dereference the bitmap, as we don't know at that point if it's a
    32-bit bitmap or a 64-bitmap bitmap whose backend implementation does
    not support find_first_zero(). Use the generic bitop functions for
    everything instead.
   =20
    Addresses-Red-Hat-Bugzilla: #808421
   =20
    Signed-off-by: Sami Liedes <sami.liedes@iki.fi>
    Reported-by: Richard W.M. Jones <rjones@redhat.com>

diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index e765d2c..7e9b8a0 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -770,19 +770,25 @@ errcode_t ext2fs_find_first_zero_generic_bmap(ext2fs_=
generic_bitmap bitmap,
 {
 	int b;
=20
-	if (bitmap->bitmap_ops->find_first_zero)
+	if (!bitmap)
+		return EINVAL;
+
+	if (EXT2FS_IS_64_BITMAP(bitmap) && bitmap->bitmap_ops->find_first_zero)
 		return bitmap->bitmap_ops->find_first_zero(bitmap, start, end, out);
=20
-	if (!bitmap || !EXT2FS_IS_64_BITMAP(bitmap) || bitmap->cluster_bits)
+	if (!EXT2FS_IS_32_BITMAP(bitmap) || bitmap->cluster_bits)
 		return EINVAL;
=20
-	if (start < bitmap->start || end > bitmap->end || start > end) {
+	// We must be careful to not use any of bitmap's fields here,
+	// as it may actually be the different 32-bit version of the structure
+	if (start < ext2fs_get_block_bitmap_start(bitmap) ||
+	    end > ext2fs_get_block_bitmap_end(bitmap) || start > end) {
 		warn_bitmap(bitmap, EXT2FS_TEST_ERROR, start);
 		return EINVAL;
 	}
=20
 	while (start <=3D end) {
-		b =3D bitmap->bitmap_ops->test_bmap(bitmap, start);
+		b =3D ext2fs_test_generic_bitmap(bitmap, start);
 		if (!b) {
 			*out =3D start;
 			return 0;

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJPf0B4AAoJEKLT589SE0a0wN0QAJs4rDBoAT5NSKECH5O6dGHG
VmlsvyFK4yitVOiZGhJ6PbeYGlGWRjADFVCIwg5A6DTg7xvQHW3ERxENLclWwCU0
hUVyreoYU59XWnFtCM1g1H0e1HGDjNrK9Zsrl3YXtItG7u5SDRrL/VtM2OUEj3mJ
/xneuKR6+ZO9KTE4LK5ak7br0UF/k6lNmWF2JHwB8zAlY0cr/MiEU0ZEKw9Kz/YH
IOy6upVDinwJa5GZYReUM5ux5zDkvnIQRln55Au0nFlS36QbABrbwkWfWzTrFt1b
DoJaHJReRQ+rUEFWrgYK471P/yl7n7x8aYL/mm7DEFQvowePcK7IW2MjFG4nzAed
kASYNjrrSSDuao8Tv5cSJKA01i3tZiiN41cBxsNB5QrkxPcqNX160EUo+9zuyndt
iyls6Pc1m48k6d/HMu7OJ9+yGuXeQYDghjiIu4CcuDFnO3DdS3osTnluZoiApm/d
Ni4bqWXrZFPSvHM0jOVoBO4qk60ZJhTyoUoGY8JBSNFFe0g12zI6Wc/0QBLwAttA
3vwoA3F9e71r+Es1dSeSl5WxodS8dm4XE+/UiIJV6AI5bgJniuy8TIFjQN/DyGVd
EAQr2mU8xqIVkkipA6+GMa1vj8ld36ETgFSIYYNVke1ctxi2HR271u2LswuGkF/i
2YbocduHrmzVdpuZwApY
=ZOUG
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
