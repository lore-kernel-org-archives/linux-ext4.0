From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 09/12] libext2: optimize ext2fs_new_block2()
Date: Mon, 20 Jan 2014 14:52:43 -0700
Message-ID: <85FC5E41-56C5-43A4-8514-CEADC36FE5C3@dilger.ca>
References: <1390197254-14583-1-git-send-email-tytso@mit.edu> <1390197254-14583-10-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/signed; boundary="Apple-Mail=_FF5CB66E-152B-46E0-AAC3-26CDA3ADE1B8"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:49715 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaATVws (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Jan 2014 16:52:48 -0500
Received: by mail-pd0-f180.google.com with SMTP id x10so6046333pdj.39
        for <linux-ext4@vger.kernel.org>; Mon, 20 Jan 2014 13:52:47 -0800 (PST)
In-Reply-To: <1390197254-14583-10-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_FF5CB66E-152B-46E0-AAC3-26CDA3ADE1B8
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 19, 2014, at 10:54 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> If there are hundreds of thousands of blocks which are in use before
> the first free block, it is much, MUCH faster to use
> ext2fs_find_first_zero_block_bitmap2() instead of searching the
> allocation bitmap bit by bit.

Excellent.  The libext2fs block allocator has typically been unusable
for filesystems with allocated blocks, so it is good to see this.

This could be further improved by skipping full groups entirely, but
that doesn't detract from the benefits of this patch.

Cheers, Andreas

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> lib/ext2fs/alloc.c | 34 +++++++++++++++++-----------------
> 1 file changed, 17 insertions(+), 17 deletions(-)
>=20
> diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
> index 91637dd..7dcfd3c 100644
> --- a/lib/ext2fs/alloc.c
> +++ b/lib/ext2fs/alloc.c
> @@ -137,8 +137,8 @@ errcode_t ext2fs_new_inode(ext2_filsys fs, =
ext2_ino_t dir,
> errcode_t ext2fs_new_block2(ext2_filsys fs, blk64_t goal,
> 			   ext2fs_block_bitmap map, blk64_t *ret)
> {
> -	blk64_t	i;
> -	int	c_ratio;
> +	errcode_t retval;
> +	blk64_t	b;
>=20
> 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
>=20
> @@ -148,21 +148,21 @@ errcode_t ext2fs_new_block2(ext2_filsys fs, =
blk64_t goal,
> 		return EXT2_ET_NO_BLOCK_BITMAP;
> 	if (!goal || (goal >=3D ext2fs_blocks_count(fs->super)))
> 		goal =3D fs->super->s_first_data_block;
> -	i =3D goal;
> -	c_ratio =3D 1 << ext2fs_get_bitmap_granularity(map);
> -	if (c_ratio > 1)
> -		goal &=3D ~EXT2FS_CLUSTER_MASK(fs);
> -	do {
> -		if (!ext2fs_fast_test_block_bitmap2(map, i)) {
> -			clear_block_uninit(fs, ext2fs_group_of_blk2(fs, =
i));
> -			*ret =3D i;
> -			return 0;
> -		}
> -		i =3D (i + c_ratio) & ~(c_ratio - 1);
> -		if (i >=3D ext2fs_blocks_count(fs->super))
> -			i =3D fs->super->s_first_data_block;
> -	} while (i !=3D goal);
> -	return EXT2_ET_BLOCK_ALLOC_FAIL;
> +	goal &=3D ~EXT2FS_CLUSTER_MASK(fs);
> +
> +	retval =3D ext2fs_find_first_zero_block_bitmap2(map,
> +			goal, ext2fs_blocks_count(fs->super) - 1, &b);
> +	if ((retval =3D=3D ENOENT) && (goal !=3D =
fs->super->s_first_data_block))
> +		retval =3D ext2fs_find_first_zero_block_bitmap2(map,
> +			fs->super->s_first_data_block, goal - 1, &b);
> +	if (retval =3D=3D ENOENT)
> +		return EXT2_ET_BLOCK_ALLOC_FAIL;
> +	if (retval)
> +		return retval;
> +
> +	clear_block_uninit(fs, ext2fs_group_of_blk2(fs, b));
> +	*ret =3D b;
> +	return 0;
> }
>=20
> errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
> --=20
> 1.8.5.rc3.362.gdf10213
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_FF5CB66E-152B-46E0-AAC3-26CDA3ADE1B8
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUt2arHKl2rkXzB/gAQISIg//WY+rUN8QN861sN6n+h9VFD2hVJNvklcf
I6XnBieaXMZQ7W0Muzf1JBOWJz8whffR0OZA1atvuYsmODYyo3/QOKNglDHNh3/+
Zdco1/xB3g4YieN7G+2LacK8rDL+FOFPWgkYJaWd38bUG100XJf/2151pq15h7NT
HyCyOuvIHYBo+zOHZvKw2Obly/GTHe086mCtlQfyZppLPjkXK4GlOb3cDUeDdSl/
MmrCiIMqP3lRNCNgS9qsPdIbmDVgj+/ClhmvRKib6vvYRvTvciEevh7gjSkk80Cu
GUkLuQZaXwsCG72HkZxRFA43vx/bYbB9COHi6x69+qFpgcYf3cHwz04ATwmeGFu8
cKc7ZdtqloWN/WzuxMxek3Gc5VAj96jqjJ7JLRJY/Je+275N6uiDiTLWAeN/TDK0
QtxDpRBfry7+REO82JiWfJhQ65CXXDJhTIfINKo1nK3sDN3/1n7NiUx6xIFCwtQ+
hGScbdmEKGPt1GzEQL5vukRMvjSzNx0qXQL+JSrxfoNGpOhBsKBRUDobpcfnJ35P
pbMmAyoEorwo88KcpQprXdOwSrdfKO125KthRnwMYF50+K5vOycL0n74nVLiMN6i
DMIlTv0pSovHfgAmlkPEpCWbFRWCSCzkbvy6Johr8RbI/VeElEKLfqaXVgvNh3+y
4IR7li/k2P8=
=4Q5h
-----END PGP SIGNATURE-----

--Apple-Mail=_FF5CB66E-152B-46E0-AAC3-26CDA3ADE1B8--
