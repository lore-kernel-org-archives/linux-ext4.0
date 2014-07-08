From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/3] journal: use consts instead of 1024 and add helper for journal with 1k blocksize
Date: Tue, 8 Jul 2014 17:30:10 -0600
Message-ID: <D7E9803B-18EC-4E23-BD3A-4A3B7802C735@dilger.ca>
References: <1404852082-1550-1-git-send-email-a3at.mail@gmail.com> <1404852082-1550-2-git-send-email-a3at.mail@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_E68E22E4-8611-4A6B-854D-C8594563A4F3"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:64594 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbaGHXaP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jul 2014 19:30:15 -0400
Received: by mail-pa0-f53.google.com with SMTP id ey11so8011849pad.26
        for <linux-ext4@vger.kernel.org>; Tue, 08 Jul 2014 16:30:14 -0700 (PDT)
In-Reply-To: <1404852082-1550-2-git-send-email-a3at.mail@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_E68E22E4-8611-4A6B-854D-C8594563A4F3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jul 8, 2014, at 2:41 PM, Azat Khuzhin <a3at.mail@gmail.com> wrote:
> Use EXT2_MIN_BLOCK_SIZE/JFS_MIN_JOURNAL_BLOCKS instead of hardcoded =
1024
> when it is okay, and also add a helper ext2fs_journal_sb_start() that
> will return start of journal sb with special case for fs with 1k block
> size.

Seems like a good idea, but an issue below.

> diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
> index 884d9c0..068eed7 100644
> --- a/lib/ext2fs/mkjournal.c
> +++ b/lib/ext2fs/mkjournal.c
> @@ -75,10 +75,7 @@ errcode_t =
ext2fs_create_journal_superblock(ext2_filsys fs,
> 	if (fs->super->s_feature_incompat &
> 	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) {
> 		jsb->s_nr_users =3D 0;
> -		if (fs->blocksize =3D=3D 1024)
> -			jsb->s_first =3D htonl(3);
> -		else
> -			jsb->s_first =3D htonl(2);
> +		jsb->s_first =3D ext2fs_journal_sb_start(fs->blocksize) =
+ 1;

This looks like it is missing the htonl() conversion, and will break the =
on-disk format?

The JBD code stores all data on-disk in big-endian to ensure that it is =
converted properly
on the most common little-endian systems, and will therefore also work =
on big-endian systems.

Cheers, Andreas






--Apple-Mail=_E68E22E4-8611-4A6B-854D-C8594563A4F3
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU7x/AnKl2rkXzB/gAQJL1A/8CDxOpPnEKGeNEIzXBeeHfXxy4IDW5hQ6
0PpG4G02u5T3QJrJQeWgZIG18Eu1PmU6WEWlh63ZtSIS35DFKzJfxptc6QwuLabh
9ucO2QxE1HrVggeeHpLbpuK5FmHscUjpbRK7Sk3vgVIdGBmHI9fZN2hjsMhnzIR0
SIXmoGbPjIGHVMW+Kb7o3jhEfkHbjKU/TxSiV1cWrqcRM8iWouL9Qw2jf2iEQUZ/
HhQc6ccP0INUugbS0wIfnjTglpVxLyUUzBO/u501FddNgbZSrXAD8pM0ikGYRPz6
HZWMv8tT9SUFOQOGXKHatPun4BYHPuQaAkXZbuqWM4E68xaEl2sZnsgfQEC4ihle
0hpmm0/JfKHDmNcHs2UGlsKDC0nF9qh76Sl9gxw95wMF8ZicZn2QOmR0dd2LaN/6
kXtFQ6blxL6vlrn7SQ4m+yz03hTjTtNBl6YhV/Q7jPdtSji6VlwYFs3leBT3O4Au
BWw6L6SIa6hICfKOy4y/c2BkhDAyoDQpNUhdn2nwHyE91detReETRqqqAyE+jS+K
URed6GJXJ5lhLnHT2PVRNY/JtBNaA5lUMJ7Ja2R793Xl9vfhb1Iv+eL/AGaW2w4/
+2sA7BxNMnInXDiAdHJRjGkkzRiQRl8rcbkHI+uixVx50dvz6yVSi3vcbO9We5Ef
OmKhXmB4VNM=
=bWg6
-----END PGP SIGNATURE-----

--Apple-Mail=_E68E22E4-8611-4A6B-854D-C8594563A4F3--
