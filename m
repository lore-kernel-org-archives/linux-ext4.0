From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/3] ext4: forbid i_extra_isize not divisible by 4
Date: Mon, 28 Nov 2016 12:30:35 -0700
Message-ID: <BC43C27B-D43E-434D-B5C7-121D8388D633@dilger.ca>
References: <1480228786-106775-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_3F75D1ED-0C04-4543-82EE-51CA57CFD173"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34938 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753352AbcK1Tam (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Nov 2016 14:30:42 -0500
Received: by mail-io0-f194.google.com with SMTP id h133so24770470ioe.2
        for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2016 11:30:42 -0800 (PST)
In-Reply-To: <1480228786-106775-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_3F75D1ED-0C04-4543-82EE-51CA57CFD173
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 26, 2016, at 11:39 PM, Eric Biggers <ebiggers@google.com> wrote:
>=20
> i_extra_isize not divisible by 4 is problematic for several reasons:
>=20
> - It causes the in-inode xattr space to be misaligned, but the xattr
>  header and entries are not declared __packed to express this
>  possibility.  This may cause poor performance or incorrect code
>  generation on some platforms.
> - When validating the xattr entries we can read past the end of the
>  inode if the size available for xattrs is not a multiple of 4.
> - It allows the nonsensical i_extra_isize=3D1, which doesn't even =
leave
>  enough room for i_extra_isize itself.
>=20
> Therefore, update ext4_iget() to consider i_extra_isize not divisible =
by
> 4 to be an error, like the case where i_extra_isize is too large.
>=20
> This also matches the rule recently added to e2fsck for determining
> whether an inode has valid i_extra_isize.
>=20
> This patch shouldn't have any noticeable effect on
> non-corrupted/non-malicious filesystems, since the size of ext4_inode
> has always been a multiple of 4.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Makes sense.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext4/inode.c | 11 +++++++----
> 1 file changed, 7 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 861f848..bc99ebe 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4564,10 +4564,12 @@ struct inode *ext4_iget(struct super_block =
*sb, unsigned long ino)
> 	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE) {
> 		ei->i_extra_isize =3D =
le16_to_cpu(raw_inode->i_extra_isize);
> 		if (EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
> -		    EXT4_INODE_SIZE(inode->i_sb)) {
> -			EXT4_ERROR_INODE(inode, "bad extra_isize (%u !=3D =
%u)",
> -				EXT4_GOOD_OLD_INODE_SIZE + =
ei->i_extra_isize,
> -				EXT4_INODE_SIZE(inode->i_sb));
> +			EXT4_INODE_SIZE(inode->i_sb) ||
> +		    (ei->i_extra_isize & 3)) {
> +			EXT4_ERROR_INODE(inode,
> +					 "bad extra_isize %u (inode size =
%u)",
> +					 ei->i_extra_isize,
> +					 EXT4_INODE_SIZE(inode->i_sb));
> 			ret =3D -EFSCORRUPTED;
> 			goto bad_inode;
> 		}
> @@ -4685,6 +4687,7 @@ struct inode *ext4_iget(struct super_block *sb, =
unsigned long ino)
> 	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE) {
> 		if (ei->i_extra_isize =3D=3D 0) {
> 			/* The extra space is currently unused. Use it. =
*/
> +			BUILD_BUG_ON(sizeof(struct ext4_inode) & 3);
> 			ei->i_extra_isize =3D sizeof(struct ext4_inode) =
-
> 					    EXT4_GOOD_OLD_INODE_SIZE;
> 		} else {
> --
> 2.8.0.rc3.226.g39d4020
>=20


Cheers, Andreas






--Apple-Mail=_3F75D1ED-0C04-4543-82EE-51CA57CFD173
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWDyF23Kl2rkXzB/gAQi9whAAhN4BqN+EfmWWy0N/wtYZHjZcJhPicNiV
AOkmL0QtXUUVNEUWxaaLDattQeapiwTsQrfJdiEX8U5cf/LzeivBCxVQP1XpdIGO
/YiQua7AD4KdOj0eBL9HdwiWaPrJe7axYrfy2JwrwzdRoU+SbWSBt0Kk3ObTz+FS
inN9YbEHKwkxgKrOlXUyZgK1Aq3GOwNWNKMeadWG1GpINoqL1GvPdSAjxqDTCEtg
X2bTPmIwCAkZoM7xT8DtvTe/sZqVIL+c7N+Y5oJsquJS8Z+vgi5WKwr9sHPeSeq6
17mq3aAj2pTbNB36+EOYLzD+ui7Mlndu4wyYV8CwzQvLa/dc+gD7K47m3BdZkUzw
gI+cXDg9T4QFRdX67xDcxHdEBVgNbaW36q5zgOdH6YU1QRfid9CnfI/A7AZ5z62b
ITKA8GYXij3qZV005DssA/i8skMXbLN/X1CH31I57FUmYX3wlrAufFGMXeL91OHP
Jv87CsJuSm+lu7N2oeHPPwnr3hlwVDmjH4p0VS0KOsT8/8bNgOiOhjDLlR+KZM75
vDsgp9D14aUUgjh+yUB1/8ekUQXwPn30yJaq0yP0aWBi5QbkdT2uw0AfZRWJ5PCW
NaqxkcY47SaLrM2vtT986K/I1gS21NcYCKdRkOQdrKuLZa0lMwMwG4tyj3EbL+f4
HOfT7l70Oxw=
=FIaM
-----END PGP SIGNATURE-----

--Apple-Mail=_3F75D1ED-0C04-4543-82EE-51CA57CFD173--
