From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 3/3] ext4: correctly detect when an xattr value has an invalid size
Date: Mon, 28 Nov 2016 12:50:02 -0700
Message-ID: <ED9B2B5D-25DD-4D4A-9F1C-86656B154AA8@dilger.ca>
References: <1480228786-106775-1-git-send-email-ebiggers@google.com> <1480228786-106775-3-git-send-email-ebiggers@google.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_2714FD84-D937-4A14-A836-4D51A207CEB9"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:32959 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754245AbcK1TuH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Nov 2016 14:50:07 -0500
Received: by mail-io0-f196.google.com with SMTP id j92so24917799ioi.0
        for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2016 11:50:07 -0800 (PST)
In-Reply-To: <1480228786-106775-3-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_2714FD84-D937-4A14-A836-4D51A207CEB9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 26, 2016, at 11:39 PM, Eric Biggers <ebiggers@google.com> wrote:
>=20
> It was possible for an xattr value to have a very large size, which
> would then pass validation on 32-bit architectures due to a pointer
> wraparound.  Fix this by validating the size in a way which avoids
> pointer wraparound.

It isn't actually possible for a valid xattr value to be very large.
At most 65536 bytes even with large blocks, so it might be easier to
directly check that e_value_size is not too large rather than trying
to deal with values of 0xfffffffe bytes or similar?

Cheers, Andreas

> It was also possible that a value's size would fit in the available
> space but its padded size would not.  This would cause an =
out-of-bounds
> memory write in ext4_xattr_set_entry when replacing the xattr value.
> For example, if an xattr value of unpadded size 253 bytes went until =
the
> very end of the inode or block, then using setxattr(2) to replace this
> xattr's value with 256 bytes would cause a write to the 3 bytes past =
the
> end of the inode or buffer, and the new xattr value would be =
incorrectly
> truncated.  Fix this by requiring that the padded size fit in the
> available space rather than the unpadded size.
>=20
> This patch shouldn't have any noticeable effect on
> non-corrupted/non-malicious filesystems.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> fs/ext4/xattr.c | 27 +++++++++++++++++++++------
> 1 file changed, 21 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 59c9ec7..5a94fa52 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -185,6 +185,7 @@ ext4_xattr_check_names(struct ext4_xattr_entry =
*entry, void *end,
> {
> 	struct ext4_xattr_entry *e =3D entry;
>=20
> +	/* Find the end of the names list */
> 	while (!IS_LAST_ENTRY(e)) {
> 		struct ext4_xattr_entry *next =3D EXT4_XATTR_NEXT(e);
> 		if ((void *)next >=3D end)
> @@ -192,15 +193,29 @@ ext4_xattr_check_names(struct ext4_xattr_entry =
*entry, void *end,
> 		e =3D next;
> 	}
>=20
> +	/* Check the values */
> 	while (!IS_LAST_ENTRY(entry)) {
> 		if (entry->e_value_block !=3D 0)
> 			return -EFSCORRUPTED;
> -		if (entry->e_value_size !=3D 0 &&
> -		    (value_start + le16_to_cpu(entry->e_value_offs) <
> -		     (void *)e + sizeof(__u32) ||
> -		     value_start + le16_to_cpu(entry->e_value_offs) +
> -		    le32_to_cpu(entry->e_value_size) > end))
> -			return -EFSCORRUPTED;
> +		if (entry->e_value_size !=3D 0) {
> +			u16 offs =3D le16_to_cpu(entry->e_value_offs);
> +			u32 size =3D le32_to_cpu(entry->e_value_size);
> +			void *value;
> +
> +			/*
> +			 * The value cannot overlap the names, and the =
value
> +			 * with padding cannot extend beyond 'end'.  =
Check both
> +			 * the padded and unpadded sizes, since the size =
may
> +			 * overflow to 0 when adding padding.
> +			 */
> +			if (offs > end - value_start)
> +				return -EFSCORRUPTED;
> +			value =3D value_start + offs;
> +			if (value < (void *)e + sizeof(u32) ||
> +			    size > end - value ||
> +			    EXT4_XATTR_SIZE(size) > end - value)
> +				return -EFSCORRUPTED;
> +		}
> 		entry =3D EXT4_XATTR_NEXT(entry);
> 	}
>=20
> --
> 2.8.0.rc3.226.g39d4020
>=20


Cheers, Andreas






--Apple-Mail=_2714FD84-D937-4A14-A836-4D51A207CEB9
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWDyKa3Kl2rkXzB/gAQiefhAAu0lZo6tch/gcLWHV38/ArfIYVNI1cXxM
LUlvX2HcfusMVC0MXu+kWrXswgJzIFPQbNBPCSkqFg2ZEeyMtRZwaCpVw2KIL/XK
tbSZ8eE2CnrikG96AjQumu5jXjk9y/aB6BValE/VYr1JrmzBAA4P4TD9mjzC1hqO
SViyyqaH/RNajSlYhdUZ3w6xXen0DZW95HkUJHNIAl52h2Hi62f6hELK6ufFgig9
y7DZ+1vOLrlNgbAU/VO15B+zpNuuPKHXCoe0hEY7nmmlOcCQj6fXaOlHVXMGKslT
DPIEUP255orHM1IEb89K7daGAtElglyjMrkWV1oIxS4Ipp0ko4m71y8y+kpWgJ8t
xkTIlmNcPvRaMOpO8oM8VmTXOcZXGk2ODOOaXzb8uJ/m7lQt4suGjgvyUSLZM/b2
5xZJqcGpAWqRsPryFCn84KGi3cpq8wsrjO+WFTp0kCgB4bTGO28fBc5UNMNzpRC4
JQSFq6a3Ehkv1C2JrAZ8n2NpDqyTdXYwgCjciI+FFLr3YyBQWLK2YLHKlJV0Uhpi
uTshLCz1PvV9RcsRD1Hniax1eslv8Z8ScO5fzyWXgEPi4oMVThLbVQVnC40FU6cP
w15yXUD2yiOXXdY+rRIhltIF09geoPhC1NuWd7jT1lQYMbknrQOAD5Xmbd0+Jffg
vEJ6/OmHm9U=
=+ojD
-----END PGP SIGNATURE-----

--Apple-Mail=_2714FD84-D937-4A14-A836-4D51A207CEB9--
