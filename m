Return-Path: <SRS0=Yxos=NQ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34903 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729037AbeKEO03 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Nov 2018 09:26:29 -0500
Received: by mail-pg1-f196.google.com with SMTP id 32-v6so3659188pgu.2
        for <linux-ext4@vger.kernel.org>; Sun, 04 Nov 2018 21:08:42 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <E88DA3F6-D339-44D6-95A8-75256A8F57CC@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_DF051A48-1085-43A6-AE18-80D113602C1B";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] ext4: remove code duplication in
 update_ind/bind/tind_extent_range
Date: Sun, 4 Nov 2018 22:08:37 -0700
In-Reply-To: <1f58b6b3-de16-a08d-2952-5db70dbfc778@virtuozzo.com>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>
To: Vasily Averin <vvs@virtuozzo.com>
References: <1f58b6b3-de16-a08d-2952-5db70dbfc778@virtuozzo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_DF051A48-1085-43A6-AE18-80D113602C1B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 4, 2018, at 9:41 AM, Vasily Averin <vvs@virtuozzo.com> wrote:
>=20
> update_ind/bind/tind_extent_page() differs by one variable and can be
> replaced by unified function. These functions are called by similar =
way
> and their caller function can be simplified too.

The patch looks quite reasonable, though I'd suggest a couple of very
minor style changes (inline).  You can add to the resubmitted patch:

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> ---
> fs/ext4/migrate.c | 111 ++++++++++------------------------------------
> 1 file changed, 23 insertions(+), 88 deletions(-)
>=20
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index 61a9d1927817..02ce99ba32be 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -109,12 +109,13 @@ static int update_extent_range(handle_t *handle, =
struct inode *inode,
>=20
> static int update_ind_extent_range(handle_t *handle, struct inode =
*inode,
> 				   ext4_fsblk_t pblock,
> -				   struct migrate_struct *lb)
> +				   struct migrate_struct *lb,
> +				   ext4_lblk_t inc)
> {
> 	struct buffer_head *bh;
> 	__le32 *i_data;
> 	int i, retval =3D 0;
> -	unsigned long max_entries =3D inode->i_sb->s_blocksize >> 2;
> +	ext4_lblk_t max_entries =3D inode->i_sb->s_blocksize >> 2;
>=20
> 	bh =3D sb_bread(inode->i_sb, pblock);
> 	if (!bh)
> @@ -523,34 +464,28 @@ int ext4_ext_migrate(struct inode *inode)
>=20
> 	/* 32 bit block address 4 bytes */
> 	max_entries =3D inode->i_sb->s_blocksize >> 2;
> -	for (i =3D 0; i < EXT4_NDIR_BLOCKS; i++) {
> +
> +	inc =3D 1; mult =3D 1;
> +	for (i =3D 0; i < EXT4_N_BLOCKS; i++) {
> +		if (i =3D=3D EXT4_IND_BLOCK)
> +			mult =3D max_entries;
> +		else if (i > EXT4_IND_BLOCK)
> +			inc =3D inc * mult;

This should be "inc *=3D mult".

> 		if (i_data[i]) {
> +			if (i < EXT4_IND_BLOCK)
> +				retval =3D update_extent_range(handle, =
tmp_inode,
> 						le32_to_cpu(i_data[i]), =
&lb);
> +			else
> +				retval =3D =
update_ind_extent_range(handle,
> +						tmp_inode,
> +						le32_to_cpu(i_data[i]),
> +						&lb, inc);
> 			if (retval)
> 				goto err_out;
> +
> +		} else if (i < EXT4_TIND_BLOCK)
> +			lb.curr_block +=3D inc * mult;

There should be {} around the else-block to match the if-block.

Cheers, Andreas






--Apple-Mail=_DF051A48-1085-43A6-AE18-80D113602C1B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlvf0FUACgkQcqXauRfM
H+BpZRAAk2N6dQu6NVMuEVzfNGV33ziHKmwTa8fgtSnHgxI3K+OCStu7tVA9y7H2
dwIytTuGMFqvgtijmh2deJj8Q5sgi0odFHwSssHMyHmNu0bJY+AK4VCA3p83+FUI
Ci+3Y57yLbETRbS7uFFuXAi54LrXgNPOUtS9siPdmXJdI/WwnLSYNCScTuilM133
xzfgMG0n08RsPW+Y07WFKtHZhG36AEH5+E84bSG2oMZZBQnVI9UHiQ9fVTyVzSx6
G5WY9KxzFb2PMP2QKzNS19LDElcqXEb+hLWkgsoxKDK10rjbiRyfxVkmGmN4BPHL
Np3zcKnaeX5oDtWEgTEkT+8O/ZQ03ztQ8XcA6TrKf+vc1GvaYQ0kMG9jWaXj9gkS
QM8MBwcxJuaFMFp+Tod2bt6EQbBv4FYz7siXaLJxR8+exTOuknvKsIwwKw4V8q5o
HB7r+cmZ82EZ5Y1SUEqC87WfeunlnbO6LZ84hg+CEbqgk4d8aSM3JghAZyf25aHu
ExeC5pTiNG30NZjR6TRpGrexSes7QESTZIBkP+AvmQn0BgMgDiLWtZPcD+D6mozH
bwlovKkzIQwDMLeFoL1E8B1rrYwVfCVX9sXB+GucoPCrnTi3Dcj2ECSBaJoawMWW
lVVJtvElsjM/nSWuZSy2wyNCESDq3uHYch22rghxFfvczxZJ5RU=
=kD+9
-----END PGP SIGNATURE-----

--Apple-Mail=_DF051A48-1085-43A6-AE18-80D113602C1B--
