From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: check inline directory before converting
Date: Thu, 24 Jul 2014 16:41:04 -0600
Message-ID: <253FEEC3-F619-4D9B-8358-A8FC8A832740@dilger.ca>
References: <20140724212222.GG8628@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_C6F136A6-1F2A-47E5-9DBC-7E3B614F4E57"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:40641 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaGXWlJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jul 2014 18:41:09 -0400
Received: by mail-pd0-f181.google.com with SMTP id g10so4487421pdj.40
        for <linux-ext4@vger.kernel.org>; Thu, 24 Jul 2014 15:41:09 -0700 (PDT)
In-Reply-To: <20140724212222.GG8628@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_C6F136A6-1F2A-47E5-9DBC-7E3B614F4E57
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jul 24, 2014, at 3:22 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
> Before converting an inline directory to a regular directory, check
> the directory entries to make sure they're not obviously broken.
> This helps us to avoid a BUG_ON if one of the dirents is trashed.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> fs/ext4/inline.c |   37 +++++++++++++++++++++++++++++++++++++
> 1 file changed, 37 insertions(+)
>=20
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 645205d..c79d8e7 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -1157,6 +1157,31 @@ out:
> 	return err;
> }
>=20
> +static int ext4_check_all_de(struct inode *dir, struct buffer_head =
*bh,
> +			     void *buf, int buf_size)

It would seem that this function would be useful in ext4_readdir(), =
which
open-codes something very similar?  It might be better to locate this
function in ext4/dir.c since it doesn't appear to have anything specific
to do with inline directories.

Cheers, Andreas

> +{
> +	struct ext4_dir_entry_2 *de;
> +	int nlen, rlen;
> +	unsigned int offset =3D 0;
> +	char *top;
> +
> +	de =3D (struct ext4_dir_entry_2 *)buf;
> +	top =3D buf + buf_size;
> +	while ((char *) de < top) {
> +		if (ext4_check_dir_entry(dir, NULL, de, bh,
> +					 buf, buf_size, offset))
> +			return -EIO;
> +		nlen =3D EXT4_DIR_REC_LEN(de->name_len);
> +		rlen =3D ext4_rec_len_from_disk(de->rec_len, buf_size);
> +		de =3D (struct ext4_dir_entry_2 *)((char *)de + rlen);
> +		offset +=3D rlen;
> +	}
> +	if ((char *) de > top)
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> static int ext4_convert_inline_data_nolock(handle_t *handle,
> 					   struct inode *inode,
> 					   struct ext4_iloc *iloc)
> @@ -1178,6 +1203,18 @@ static int =
ext4_convert_inline_data_nolock(handle_t *handle,
> 	if (error < 0)
> 		goto out;
>=20
> +	/*
> +	 * Make sure the inline directory entries pass checks before we =
try to
> +	 * convert them, so that we avoid touching stuff that needs =
fsck.
> +	 */
> +	if (S_ISDIR(inode->i_mode)) {
> +		error =3D ext4_check_all_de(inode, iloc->bh,
> +					buf + EXT4_INLINE_DOTDOT_SIZE,
> +					inline_size - =
EXT4_INLINE_DOTDOT_SIZE);
> +		if (error)
> +			goto out;
> +	}
> +
> 	error =3D ext4_destroy_inline_data_nolock(handle, inode);
> 	if (error)
> 		goto out;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_C6F136A6-1F2A-47E5-9DBC-7E3B614F4E57
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU9GLgHKl2rkXzB/gAQJjOA//XHS4P/sx23IFrxk6z7X99/eSIgfKSGiP
mJay8e+LZKT2nvywzLkNcR+jm3UjnLSJXAAbUwbSgBQXh2PTFoDZKvj7KVGEntDk
FoQx5iVaoEtF3Mt9j3U7F7Hb46pZq3Popc1BRyQLviXzTw7P616J0UaAM06J6Qx4
RNAwfAdrzqzjoF6JLsCsWXDP5Hp33BJBBTUfbyA7x6nQsrAcwOV5E+sWQ0bsKzs2
/n6v0jFY6/ShnIAaJrN+7CEcsfLPXeZ9EuSTZzsnYOngqnRmbkX4oD20BO43COwN
z1Sby7rYL0ruh0V7Uw2itN1GDNDfYD21cOV3FrqIAebApQQ6bQkrpjBHiM1lVlwa
eqHz8BPqGafzzbZJZ4RQuK/miKaY2QGAJjSWNXAezKLLGT0PiO+7kcuyKX4zl0cx
gaM5P5PkGI4jNGTIpsoIxDMYajWz/BAGsUyyPe9B2rbs4QZarxBmOO61o7rKNLNT
WCshYhPdT/B9tsUnPC/Op+slF/Z6m7vmYAFvJcdHGm+pbq0TX/DMQ4QRB3CkSh7d
fEeS93zVEi0SuDOWJpFQ4wS63ur+C1A+pFfS864AqmR5K9LrOWNQY4mgtvHyu0x8
ZX4iHKm9ZVhT10xpKaOS7X1GFgCB6FmVir9H6cha/DAoQyhOpDzFp71LvVP3zfjS
e0d92tA5MFQ=
=7avY
-----END PGP SIGNATURE-----

--Apple-Mail=_C6F136A6-1F2A-47E5-9DBC-7E3B614F4E57--
