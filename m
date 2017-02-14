From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] debugfs: with ls -l, include space between size and date
Date: Tue, 14 Feb 2017 13:06:50 -0700
Message-ID: <1C84E23C-552E-4E62-8EE9-97B812046DA1@dilger.ca>
References: <20170213000140.14250-1-ebiggers3@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_2F5693DB-64E7-41A9-A3DF-4198C244D350";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33375 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753106AbdBNUGx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Feb 2017 15:06:53 -0500
Received: by mail-oi0-f68.google.com with SMTP id j15so2147770oih.0
        for <linux-ext4@vger.kernel.org>; Tue, 14 Feb 2017 12:06:53 -0800 (PST)
In-Reply-To: <20170213000140.14250-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_2F5693DB-64E7-41A9-A3DF-4198C244D350
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Feb 12, 2017, at 5:01 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
>=20
> From: Eric Biggers <ebiggers@google.com>
>=20
> Before:
>     11   40700 (2)      0      0   1228812-Feb-2017 12:51 lost+found
>=20
> After:
>     11   40700 (2)      0      0   12288 12-Feb-2017 12:51 lost+found
>=20
> Fixes: 68a1de3df340 ("debugfs: pretty print encrypted filenames in the =
ls command")
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> debugfs/ls.c | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/debugfs/ls.c b/debugfs/ls.c
> index 057e3f6f..c990a93d 100644
> --- a/debugfs/ls.c
> +++ b/debugfs/ls.c
> @@ -156,8 +156,7 @@ static int list_dir_proc(ext2_ino_t dir =
EXT2FS_ATTR((unused)),
> 			fprintf(ls->f, "%5d", inode.i_size);
> 		else
> 			fprintf(ls->f, "%5llu", EXT2_I_SIZE(&inode));
> -		fputs(datestr, ls->f);
> -		fputc(' ', ls->f);
> +		fprintf(ls->f, " %s ", datestr);
> 		print_filename(ls->f, dirent, options);
> 		fputc('\n', ls->f);
> 	} else {
> --
> 2.11.1
>=20


Cheers, Andreas






--Apple-Mail=_2F5693DB-64E7-41A9-A3DF-4198C244D350
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFYo2NapIg59Q01vtYRAkOcAKC2wjlrkyqvc/+O2IrtPVodID8UXgCgxNfX
/YuSEElSy34/SHJqSOIIgaE=
=zgz5
-----END PGP SIGNATURE-----

--Apple-Mail=_2F5693DB-64E7-41A9-A3DF-4198C244D350--
