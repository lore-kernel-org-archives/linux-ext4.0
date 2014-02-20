From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RHEL5.11 PATCH 2/3] ext3: validate directory entry data before use
Date: Wed, 19 Feb 2014 18:21:47 -0800
Message-ID: <B4EAA210-D61F-4E94-A90A-DD5A8626D684@dilger.ca>
References: <1392800216-7828-1-git-send-email-lczerner@redhat.com> <1392800216-7828-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/signed; boundary="Apple-Mail=_870877E9-8EC0-4931-82E9-301BDB81B0B7"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: rhkernel-list@redhat.com, Duane Griffin <duaneg@dghda.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34827 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaBTCVu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Feb 2014 21:21:50 -0500
Received: by mail-pa0-f44.google.com with SMTP id kq14so1239412pab.17
        for <linux-ext4@vger.kernel.org>; Wed, 19 Feb 2014 18:21:49 -0800 (PST)
In-Reply-To: <1392800216-7828-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_870877E9-8EC0-4931-82E9-301BDB81B0B7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Feb 19, 2014, at 12:56 AM, Lukas Czerner <lczerner@redhat.com> wrote:
> ext3_dx_find_entry uses ext3_next_entry without verifying that the =
entry
> is valid.  If its rec_len =3D=3D 0 this causes an infinite loop.  =
Refactor the
> loop to check the validity of entries before checking whether they =
match
> and moving onto the next one.
>=20
> There are other uses of ext3_next_entry in this file which also look
> problematic.  They should be reviewed and fixed if/when we have a
> test-case that triggers them.

Checking the validity on every access can be CPU expensive.  In ext2
(and I thought ext3/ext4?) this was checked once when the block was
first read from disk and then the buffer was marked verified and not
checked again.  That ensures the contents are valid, but avoids the
potential O(n^2) CPU overhead of validating the same data for each call.

Taking a quick look at the ext4_dx_find_entry->__ext4_read_dirblock()
it is marking the buffer verified if the checksum is validated, but
I can't immediately see where it is verifying the contents?  Maybe that
was lost during the patch to add checksum support, or maybe I'm just
mis-remembering which ext2/3/4 variants this was done for.

Cheers, Andreas

> Signed-off-by: Duane Griffin <duaneg@dghda.com>
> Cc: <linux-ext4@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
> fs/ext3/namei.c | 22 ++++++++++++----------
> 1 file changed, 12 insertions(+), 10 deletions(-)
>=20
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index 8bc0198..69c0540 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -994,19 +994,21 @@ static struct buffer_head * =
ext3_dx_find_entry(struct dentry *dentry,
> 		de =3D (struct ext3_dir_entry_2 *) bh->b_data;
> 		top =3D (struct ext3_dir_entry_2 *) ((char *) de + =
sb->s_blocksize -
> 				       EXT3_DIR_REC_LEN(0));
> -		for (; de < top; de =3D ext3_next_entry(de))
> -		if (ext3_match (namelen, name, de)) {
> -			if (!ext3_check_dir_entry("ext3_find_entry",
> -						  dir, de, bh,
> -				  (block<<EXT3_BLOCK_SIZE_BITS(sb))
> -					  +((char *)de - bh->b_data))) {
> -				brelse (bh);
> +		for (; de < top; de =3D ext3_next_entry(de)) {
> +			int off =3D (block << EXT3_BLOCK_SIZE_BITS(sb))
> +				  + ((char *) de - bh->b_data);
> +
> +			if (!ext3_check_dir_entry(__func__, dir, de, bh, =
off)) {
> +				brelse(bh);
> 				*err =3D ERR_BAD_DX_DIR;
> 				goto errout;
> 			}
> -			*res_dir =3D de;
> -			dx_release (frames);
> -			return bh;
> +
> +			if (ext3_match(namelen, name, de)) {
> +				*res_dir =3D de;
> +				dx_release(frames);
> +				return bh;
> +			}
> 		}
> 		brelse (bh);
> 		/* Check to see if we should continue to search */
> --=20
> 1.8.3.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_870877E9-8EC0-4931-82E9-301BDB81B0B7
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUwVmu3Kl2rkXzB/gAQLJdA/+KL/mffI9UZntKJs4IJ2eE9p+hcSBnvyG
g9ALbdNLiGrThAJ/JxU+a0EVPIrxl33IUTlIMxELo9mNeDFlRmJvyPRcF1ASjab6
YKtqxs8iwIXWQrgdk3yWMCOd6t6YkjbchX/CarC9iYpql7mV0JKzO/F2Z8WqsyZx
ELziyie3wmEyzHdAQgvz0VULmY31j3H0A+g4CqYXm+LXKQaRNiijLCvpkCJiLf+Z
+zGQX3iHMh+loTZhL9bqeNRQcSEVqv+AJ9xdAsBPi3yjt6li9JL5w5A7d62xHS2q
5UNBLIaqf7GuatWZ+UcDWT7WbPvLJI78tZw59+JtYMx2eoiXDzNlYcSP+xGM1iOH
poU70PqRyQgu6GASRPClV5/kfoyCfqJP0FNkM0YO6f3xEYuf76/pFLJuDsB+3UbG
+DX6hfUkSAmE4F63BkjxME1982FXfr6IbOxkYS/q7uRWOBazra38DQkcq8iBRG8g
p+QJi4MduJSfEB9DQY/vZfUVeaytGMA/bl44qbNf9DSXj8fDjUlBBL30gaSH2X4I
eDSdrWf5LTEJW+VlCZZlng0XyGdbCse1eGo7FZyUOwo4CkVftaDMlQGM2La8gVZH
kK/PgSJFChyBRgGHJkIZavwlUdX2vxkX0uE+ePLhYw3kj56/3ePI4MgUYf+lcg2h
EDtBrkq8uG0=
=iwX2
-----END PGP SIGNATURE-----

--Apple-Mail=_870877E9-8EC0-4931-82E9-301BDB81B0B7--
