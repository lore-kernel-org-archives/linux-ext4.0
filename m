From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC PATCH 5/8] debugfs: 64bit inode support
Date: Fri, 27 Oct 2017 17:19:59 -0600
Message-ID: <EFAF64C6-9989-4622-9441-5B23C81B45AE@dilger.ca>
References: <20171027172254.14137-1-artem.blagodarenko@gmail.com>
 <20171027172254.14137-6-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_3BC76B15-BAE4-49B9-8E85-0B6068EDA63E";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        alexey.lyashkov@gmail.com
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:49098 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751482AbdJ0XUF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Oct 2017 19:20:05 -0400
Received: by mail-io0-f194.google.com with SMTP id j17so15909655iod.5
        for <linux-ext4@vger.kernel.org>; Fri, 27 Oct 2017 16:20:05 -0700 (PDT)
In-Reply-To: <20171027172254.14137-6-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_3BC76B15-BAE4-49B9-8E85-0B6068EDA63E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 27, 2017, at 11:22 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> New dirdata type EXT2_DIRENT_INODE is added.
>=20
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> ---
> debugfs/ls.c         | 5 ++++-
> lib/ext2fs/ext2_fs.h | 1 +
> 2 files changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/debugfs/ls.c b/debugfs/ls.c
> index 2216d456..0c575328 100644
> --- a/debugfs/ls.c
> +++ b/debugfs/ls.c
> @@ -64,9 +64,12 @@ static void list_dirdata(struct list_dir_struct =
*ls,
>=20
> 		dlen =3D data[0];
>=20
> -		if (dirdata_mask =3D=3D EXT2_DIRENT_LUFID) {
> +		if (dirdata_mask =3D=3D EXT2_DIRENT_INODE)
> +			fprintf(ls->f, "Inode high =
part:%04\n",*(__u32*)(data +1));

This should be brief, or the "ls" output will be very wide, and having =
multiple
words makes parsing this output for testing complex.  Something like:

        fprintf(ls->f, "ino64:%04"

but it might just be better to include the high 32 bits into the inode =
number
that is already printed?

> +		else if (dirdata_mask =3D=3D EXT2_DIRENT_LUFID) {
> 			struct lu_fid *fid =3D (struct lu_fid *)(data + =
1);
>=20
> +			fprintf(ls->f, "lufind dirdata\n");

(typo) s/lufind/lufid/

Similarly, this should be shorter, like "FID:"DFID,

> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index 6a882789..b9773814 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -1041,6 +1041,7 @@ struct ext2_dir_entry_tail {
> /* lu_fid size and NUL char */
> #define EXT2_DIRENT_LUFID_SIZE		(17 + 1)
> #define EXT2_DIRENT_LUFID		0x10
> +#define EXT2_DIRENT_INODE		0x20
>=20
> /*
>  * Constants for ext4's extended time encoding
> --
> 2.13.5 (Apple Git-94)
>=20


Cheers, Andreas






--Apple-Mail=_3BC76B15-BAE4-49B9-8E85-0B6068EDA63E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZ878gpIg59Q01vtYRAjT0AKDhUFAnu4LY0aaJJJaJYeTIjmJFvwCg4VCd
DWWE9H7V2CuMOT7VdluldKY=
=jHAl
-----END PGP SIGNATURE-----

--Apple-Mail=_3BC76B15-BAE4-49B9-8E85-0B6068EDA63E--
