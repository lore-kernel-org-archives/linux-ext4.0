From: Dmitry Monakhov <dmonlist@gmail.com>
Subject: Re: [PATCH] ext4: Remove redundant check under lock scope
Date: Tue, 07 Apr 2015 13:13:32 +0300
Message-ID: <87mw2ki6ur.fsf@openvz.org>
References: <1428384901-2304-1-git-send-email-dccitaliano@gmail.com> <1428384901-2304-2-git-send-email-dccitaliano@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: Davide Italiano <dccitaliano@gmail.com>
To: Davide Italiano <dccitaliano@gmail.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:34272 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbbDGKPX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Apr 2015 06:15:23 -0400
Received: by laat2 with SMTP id t2so31294671laa.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Apr 2015 03:15:22 -0700 (PDT)
In-Reply-To: <1428384901-2304-2-git-send-email-dccitaliano@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Davide Italiano <dccitaliano@gmail.com> writes:

> ext4_zero_range() and ext4_collapse_range() duplicate
> the check in ext4_fallocate(). The checks are made with
> inode lock held when there's no need for that. Remove them,
> reducing the scope of the lock.
NAK. Other task can convert indirect<=3D>extent via
ioctl(, EXT4_IOC_SETFLAGS, flags)
  ->ext4_ext_migrate()
  ->ext4_int_migrate()
So we _must_ recheck EXT4_INODE_EXTENTS after we grab i_mutex.
>
> Signed-off-by: Davide Italiano <dccitaliano@gmail.com>
> ---
>  fs/ext4/extents.c | 16 ----------------
>  1 file changed, 16 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index bed4308..9e6fa09 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4810,15 +4810,6 @@ static long ext4_zero_range(struct file *file, lof=
f_t offset,
>  		flags |=3D EXT4_GET_BLOCKS_KEEP_SIZE;
>=20=20
>  	mutex_lock(&inode->i_mutex);
> -
> -	/*
> -	 * Indirect files do not support unwritten extnets
> -	 */
> -	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
> -		ret =3D -EOPNOTSUPP;
> -		goto out_mutex;
> -	}
> -
>  	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
>  	     offset + len > i_size_read(inode)) {
>  		new_size =3D offset + len;
> @@ -5445,13 +5436,6 @@ int ext4_collapse_range(struct inode *inode, loff_=
t offset, loff_t len)
>  		ret =3D -EINVAL;
>  		goto out_mutex;
>  	}
> -
> -	/* Currently just for extent based files */
> -	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
> -		ret =3D -EOPNOTSUPP;
> -		goto out_mutex;
> -	}
> -
>  	truncate_pagecache(inode, ioffset);
>=20=20
>  	/* Wait for existing dio to complete */
> --=20
> 2.3.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJVI63MAAoJELhyPTmIL6kB1+UH/jRZW0v35+1qVmmvJyRK8FF3
2Fl02Zbgl0BPMRs57T5fUXCvMHe5V2OgH306oboMVliMCWhpy4eZd/4mj1EcZCrW
Hh3lNEqNwDsatabMjKrny2bP5YttFktRfrKqyxBdECkBhb6HcHejaAv/5H+tCWaT
zt24QI6uPEHRYlrDwlWdLdjHxFbpTACpiMVFrqsQJHsCf8m5dsujf1zzhSTWAIS0
ysLx92FV0AXlyQDpJ0Wzj6RiiBS8P9rlHrGENvaT7IqAAhC122lw/uWOTXFuzGMI
6y3tssVq90W8Ump2iI7BLmd19+YDe1edxmnwDRcjV6Tk+DcnX1x0HBNJKM9R2GE=
=o906
-----END PGP SIGNATURE-----
--=-=-=--
