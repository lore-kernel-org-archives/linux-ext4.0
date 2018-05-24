From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Forbid overflowing inode count when resizing
Date: Thu, 24 May 2018 10:44:15 -0600
Message-ID: <F91281C7-8803-494A-83A3-1896F2959F99@dilger.ca>
References: <20180524113646.3859-1-jack@suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_730202C4-C91E-42B6-9152-F7F9E5826D5F";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Ted Tso <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Jaco Kroon <jaco@uls.co.za>, stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180524113646.3859-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_730202C4-C91E-42B6-9152-F7F9E5826D5F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On May 24, 2018, at 5:36 AM, Jan Kara <jack@suse.cz> wrote:
>=20
> ext4_resize_fs() has an off-by-one bug when checking whether growing =
of
> a filesystem will not overflow inode count. As a result it allows a
> filesystem with 8192 inodes per group to grow to 64TB which overflows
> inode count to 0 and makes filesystem unusable. Fix it.
>=20
> CC: stable@vger.kernel.org
> Fixes: 3f8a6411fbada1fa482276591e037f3b1adcf55b
> Reported-by: Jaco Kroon <jaco@uls.co.za>
> Signed-off-by: Jan Kara <jack@suse.cz>

This should be enough to stop the filesystem from exploding.
We can look at more complex solutions in a separate patch.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext4/resize.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index b6bec270a8e4..d792b7689d92 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -1933,7 +1933,7 @@ int ext4_resize_fs(struct super_block *sb, =
ext4_fsblk_t n_blocks_count)
> 		return 0;
>=20
> 	n_group =3D ext4_get_group_number(sb, n_blocks_count - 1);
> -	if (n_group > (0xFFFFFFFFUL / EXT4_INODES_PER_GROUP(sb))) {
> +	if (n_group >=3D (0xFFFFFFFFUL / EXT4_INODES_PER_GROUP(sb))) {
> 		ext4_warning(sb, "resize would cause inodes_count =
overflow");
> 		return -EINVAL;
> 	}
> --
> 2.13.6
>=20


Cheers, Andreas






--Apple-Mail=_730202C4-C91E-42B6-9152-F7F9E5826D5F
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlsG698ACgkQcqXauRfM
H+C2xw//fPcL9JgmLBy07EkBhCa+CNtOpE41m+JNF1NHrmK86njqKH9Pkju08LYZ
hvTET/IZTwczJBQhnfsNZSf+u7nd8hiva/6o9ib/xMJKhnPmrP5ZjC8RwHiUDvJm
mtPWg9cSEilbS5o5vtFLOS8ZVEMNRYQN2m8IKDDzlNng8pWCsYeuKMZQ4VlP2KC0
2mPkplSTL/82L/uShCRrJcO8CYi9sz4wLVNXvLv51VIrs2MWSSuu3fuFnHA3soz5
4i6ErEZ3Vz6ABl+sZWuhPCDikNWVt3N4H/tOCfUxcSG20phsR1C6Fng+M6Aty2KW
BdijFSlZoIR6SvRxaaaubGHWkdF6Zetry1z5K72cHhZbJNt5ld+ZvRFzT4V0J+Fv
IzyEH9rTP5yKQKiW1HTCndV/VueDQ2KfNLgsvGN2bgoBz+E9QFuT+zmGsy2jkZjF
Cteb2fPNwnn6H42dy7NJa8SI//jfHWTjUgVwVUMeclIvjNowsI7HCSTES8Vh4uLG
9CygNZi1uxtWL3jenTCnAa/pHWnmnbuLkwUxcueI0ql4pcK1nxGgT3XGBvjmt2Rl
AoWckzZ66Ql9oXWYw087PbMxeZY7DTqS/jKUtBXXFeooKA+jDIVALjdwbtpSNsTP
CPft8XLVfAAsKSslUJKAjlzuWWpEQE8T/k1jxU5o6klhWeO14i0=
=BQFy
-----END PGP SIGNATURE-----

--Apple-Mail=_730202C4-C91E-42B6-9152-F7F9E5826D5F--
