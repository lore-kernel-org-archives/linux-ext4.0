From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] e2fsck: remove #ifdef EXT2_NO_64_TYPE blocks
Date: Wed, 28 Jun 2017 10:38:20 -0600
Message-ID: <C15DD822-2183-477D-8F3F-E58E0027124F@dilger.ca>
References: <20170628012240.9141-1-tahsin@google.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_728082C6-8DB4-41C0-B121-72F79156132E";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:36428 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdF1Qi3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Jun 2017 12:38:29 -0400
Received: by mail-it0-f65.google.com with SMTP id 185so5833023itv.3
        for <linux-ext4@vger.kernel.org>; Wed, 28 Jun 2017 09:38:29 -0700 (PDT)
In-Reply-To: <20170628012240.9141-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_728082C6-8DB4-41C0-B121-72F79156132E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 27, 2017, at 7:22 PM, Tahsin Erdogan <tahsin@google.com> wrote:
>=20
> EXT2_NO_64_TYPE is not defined anywhere. It appears to be a
> historical artifact.
>=20
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> e2fsck/message.c | 42 ++----------------------------------------
> 1 file changed, 2 insertions(+), 40 deletions(-)
>=20
> diff --git a/e2fsck/message.c b/e2fsck/message.c
> index 525f4a1e7628..46522d10fbb1 100644
> --- a/e2fsck/message.c
> +++ b/e2fsck/message.c
> @@ -280,17 +280,8 @@ static _INLINE_ void expand_inode_expression(FILE =
*f, ext2_filsys fs, char ch,
> 	case 's':
> 		if (LINUX_S_ISDIR(inode->i_mode))
> 			fprintf(f, "%u", inode->i_size);
> -		else {
> -#ifdef EXT2_NO_64_TYPE
> -			if (inode->i_size_high)
> -				fprintf(f, "0x%x%08x", =
inode->i_size_high,
> -					inode->i_size);
> -			else
> -				fprintf(f, "%u", inode->i_size);
> -#else
> +		else
> 			fprintf(f, "%llu", EXT2_I_SIZE(inode));
> -#endif
> -		}
> 		break;
> 	case 'S':
> 		fprintf(f, "%u", large_inode->i_extra_isize);
> @@ -411,11 +402,7 @@ static _INLINE_ void =
expand_percent_expression(FILE *f, ext2_filsys fs,
> 		fputc('%', f);
> 		break;
> 	case 'b':
> -#ifdef EXT2_NO_64_TYPE
> -		fprintf(f, "%*u", width, (unsigned long) ctx->blk);
> -#else
> 		fprintf(f, "%*llu", width, (unsigned long long) =
ctx->blk);
> -#endif
> 		break;
> 	case 'B':
> 		if (ctx->blkcount =3D=3D BLOCK_COUNT_IND)
> @@ -431,20 +418,11 @@ static _INLINE_ void =
expand_percent_expression(FILE *f, ext2_filsys fs,
> 		if (*first && islower(m[0]))
> 			fputc(toupper(*m++), f);
> 		fputs(m, f);
> -		if (ctx->blkcount >=3D 0) {
> -#ifdef EXT2_NO_64_TYPE
> -			fprintf(f, "%d", ctx->blkcount);
> -#else
> +		if (ctx->blkcount >=3D 0)
> 			fprintf(f, "%lld", (long long) ctx->blkcount);
> -#endif
> -		}
> 		break;
> 	case 'c':
> -#ifdef EXT2_NO_64_TYPE
> -		fprintf(f, "%*u", width, (unsigned long) ctx->blk2);
> -#else
> 		fprintf(f, "%*llu", width, (unsigned long long) =
ctx->blk2);
> -#endif
> 		break;
> 	case 'd':
> 		fprintf(f, "%*u", width, ctx->dir);
> @@ -462,18 +440,10 @@ static _INLINE_ void =
expand_percent_expression(FILE *f, ext2_filsys fs,
> 		fprintf(f, "%*s", width, error_message(ctx->errcode));
> 		break;
> 	case 'N':
> -#ifdef EXT2_NO_64_TYPE
> -		fprintf(f, "%*u", width, ctx->num);
> -#else
> 		fprintf(f, "%*llu", width, (long long)ctx->num);
> -#endif
> 		break;
> 	case 'n':
> -#ifdef EXT2_NO_64_TYPE
> -		fprintf(f, "%*u", width, ctx->num2);
> -#else
> 		fprintf(f, "%*llu", width, (long long)ctx->num2);
> -#endif
> 		break;
> 	case 'p':
> 		print_pathname(f, fs, ctx->ino, 0);
> @@ -489,11 +459,7 @@ static _INLINE_ void =
expand_percent_expression(FILE *f, ext2_filsys fs,
> 		print_pathname(f, fs, ctx->dir, ctx->ino);
> 		break;
> 	case 'r':
> -#ifdef EXT2_NO_64_TYPE
> -		fprintf(f, "%*d", width, ctx->blkcount);
> -#else
> 		fprintf(f, "%*lld", width, (long long) ctx->blkcount);
> -#endif
> 		break;
> 	case 'S':
> 		fprintf(f, "%llu", get_backup_sb(NULL, fs, NULL, NULL));
> @@ -511,11 +477,7 @@ static _INLINE_ void =
expand_percent_expression(FILE *f, ext2_filsys fs,
> 		fprintf(f, "0x%0*x", width, ctx->csum1);
> 		break;
> 	case 'X':
> -#ifdef EXT2_NO_64_TYPE
> -		fprintf(f, "0x%0*x", width, ctx->num);
> -#else
> 		fprintf(f, "0x%0*llx", width, (long long)ctx->num);
> -#endif
> 		break;
> 	case 'y':
> 		fprintf(f, "0x%0*x", width, ctx->csum2);
> --
> 2.13.2.725.g09c95d1e9-goog
>=20


Cheers, Andreas






--Apple-Mail=_728082C6-8DB4-41C0-B121-72F79156132E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZU9t+pIg59Q01vtYRAgpDAJ9xwz7EWU71Q4Zuu1W8b75XefCrRQCfZuod
gTuc/zB5UK0ogTcV7wj5ZCE=
=f3Qz
-----END PGP SIGNATURE-----

--Apple-Mail=_728082C6-8DB4-41C0-B121-72F79156132E--
