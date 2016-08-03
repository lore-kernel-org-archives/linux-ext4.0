From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 01/11] ext4: Fix xattr shifting when expanding inodes
Date: Wed, 3 Aug 2016 17:25:58 -0600
Message-ID: <4FEAD03B-D92D-4DB6-8144-9202DE1A9DA9@dilger.ca>
References: <1470220795-17045-1-git-send-email-jack@suse.cz> <1470220795-17045-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_593C3ACE-E041-402B-A1A9-CAB142A8BC7E"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Ted Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:33381 "EHLO
	mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933200AbcHCXlf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Aug 2016 19:41:35 -0400
Received: by mail-it0-f68.google.com with SMTP id d65so17354708ith.0
        for <linux-ext4@vger.kernel.org>; Wed, 03 Aug 2016 16:41:21 -0700 (PDT)
In-Reply-To: <1470220795-17045-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_593C3ACE-E041-402B-A1A9-CAB142A8BC7E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Aug 3, 2016, at 4:39 AM, Jan Kara <jack@suse.cz> wrote:
>=20
> The code in ext4_expand_extra_isize_ea() treated new_extra_isize
> argument sometimes as the desired target i_extra_isize and sometimes =
as
> the amount by which we need to grow current i_extra_isize. These =
happen
> to coincide when i_extra_isize is 0 which used to be the common case =
and
> so nobody noticed this until recently when we added i_projid to the
> inode and so i_extra_isize now needs to grow from 28 to 32 bytes.
>=20
> The result of these bugs was that we sometimes unnecessarily decided =
to
> move xattrs out of inode even if there was enough space and we often
> ended up corrupting in-inode xattrs because arguments to
> ext4_xattr_shift_entries() were just wrong. This could demonstrate
> itself as BUG_ON in ext4_xattr_shift_entries() triggering.
>=20
> Fix the problem by introducing new isize_diff variable and use it =
where
> appropriate.
>=20
> CC: <stable@vger.kernel.org> # 4.4.x-
> Reported-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
> fs/ext4/xattr.c | 27 ++++++++++++++-------------
> 1 file changed, 14 insertions(+), 13 deletions(-)
>=20
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 39e9cfb1b371..cb1d7b4482de 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -1353,11 +1353,13 @@ int ext4_expand_extra_isize_ea(struct inode =
*inode, int new_extra_isize,
> 	size_t min_offs, free;
> 	int total_ino;
> 	void *base, *start, *end;
> -	int extra_isize =3D 0, error =3D 0, tried_min_extra_isize =3D 0;
> +	int error =3D 0, tried_min_extra_isize =3D 0;
> 	int s_min_extra_isize =3D =
le16_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_min_extra_isize);
> +	int isize_diff;	/* How much do we need to grow i_extra_isize */
>=20
> 	down_write(&EXT4_I(inode)->xattr_sem);
> retry:
> +	isize_diff =3D new_extra_isize - EXT4_I(inode)->i_extra_isize;
> 	if (EXT4_I(inode)->i_extra_isize >=3D new_extra_isize) {

Not a big deal, but either the isize_diff calculation could be moved
after the "if () {}" block, or the condition could be changed to:

	if (isize_diff <=3D 0) {

since isize_diff is otherwise unused if this condition is true.

You can add my

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Cheers, Andreas

> 		up_write(&EXT4_I(inode)->xattr_sem);
> 		return 0;
> @@ -1382,7 +1384,7 @@ retry:
> 		goto cleanup;
>=20
> 	free =3D ext4_xattr_free_space(last, &min_offs, base, =
&total_ino);
> -	if (free >=3D new_extra_isize) {
> +	if (free >=3D isize_diff) {
> 		entry =3D IFIRST(header);
> 		ext4_xattr_shift_entries(entry,	=
EXT4_I(inode)->i_extra_isize
> 				- new_extra_isize, (void *)raw_inode +
> @@ -1414,7 +1416,7 @@ retry:
> 		end =3D bh->b_data + bh->b_size;
> 		min_offs =3D end - base;
> 		free =3D ext4_xattr_free_space(first, &min_offs, base, =
NULL);
> -		if (free < new_extra_isize) {
> +		if (free < isize_diff) {
> 			if (!tried_min_extra_isize && s_min_extra_isize) =
{
> 				tried_min_extra_isize++;
> 				new_extra_isize =3D s_min_extra_isize;
> @@ -1428,7 +1430,7 @@ retry:
> 		free =3D inode->i_sb->s_blocksize;
> 	}
>=20
> -	while (new_extra_isize > 0) {
> +	while (isize_diff > 0) {
> 		size_t offs, size, entry_size;
> 		struct ext4_xattr_entry *small_entry =3D NULL;
> 		struct ext4_xattr_info i =3D {
> @@ -1459,7 +1461,7 @@ retry:
> 			EXT4_XATTR_SIZE(le32_to_cpu(last->e_value_size)) =
+
> 					=
EXT4_XATTR_LEN(last->e_name_len);
> 			if (total_size <=3D free && total_size < =
min_total_size) {
> -				if (total_size < new_extra_isize) {
> +				if (total_size < isize_diff) {
> 					small_entry =3D last;
> 				} else {
> 					entry =3D last;
> @@ -1516,20 +1518,19 @@ retry:
> 			goto cleanup;
>=20
> 		entry =3D IFIRST(header);
> -		if (entry_size + EXT4_XATTR_SIZE(size) >=3D =
new_extra_isize)
> -			shift_bytes =3D new_extra_isize;
> +		if (entry_size + EXT4_XATTR_SIZE(size) >=3D isize_diff)
> +			shift_bytes =3D isize_diff;
> 		else
> 			shift_bytes =3D entry_size + size;
> 		/* Adjust the offsets and shift the remaining entries =
ahead */
> -		ext4_xattr_shift_entries(entry, =
EXT4_I(inode)->i_extra_isize -
> -			shift_bytes, (void *)raw_inode +
> -			EXT4_GOOD_OLD_INODE_SIZE + extra_isize + =
shift_bytes,
> +		ext4_xattr_shift_entries(entry, -shift_bytes,
> +			(void *)raw_inode + EXT4_GOOD_OLD_INODE_SIZE +
> +			EXT4_I(inode)->i_extra_isize + shift_bytes,
> 			(void *)header, total_ino - entry_size,
> 			inode->i_sb->s_blocksize);
>=20
> -		extra_isize +=3D shift_bytes;
> -		new_extra_isize -=3D shift_bytes;
> -		EXT4_I(inode)->i_extra_isize =3D extra_isize;
> +		isize_diff -=3D shift_bytes;
> +		EXT4_I(inode)->i_extra_isize +=3D shift_bytes;
>=20
> 		i.name =3D b_entry_name;
> 		i.value =3D buffer;
> --
> 2.6.6
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_593C3ACE-E041-402B-A1A9-CAB142A8BC7E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBV6J9h3Kl2rkXzB/gAQgDJg/+K34oBotCjsI3ihMKE0NEsL6klpRsruvg
TIXllotLWiyIQWgcTN6b3VF9GcogpmF/68Y+UA37puzdl0nuN3cROVnQrjf7/w6z
eR1yev/spA4Ie3yzEdMylYGjtiAgwJ5O+Jf2xPlDWgfmD/GnpxdGRxvRHufwMTGX
CHpR7uzKEhaJ1inKFkFzxUjYB/FbLfBiPyS3gzgtbOSqNM/5JVT/qFCthct7X1TW
tlbFOMr2uYZjLqWgSE5cVdB6pNE22jAuQiyE89Kk6SET95nLXlDIuPx4qVdsLGgY
5GxIPK1KE4BOEfLy+kX4vvEQEsSGl0HhwgdDkZ99UvF5YVKvpqQMIZUQg8fOH5A+
M+Zxz0T0h5hkqD2ZtXHaCnM07Q9tCxWfkJY697+q/bgTCvNEL31QuV81eYt796AL
o+Hbe6sshYZOyfHiyUYM8Rn75Z7jWhUDJjJCFbhDNhwwAX+lLjH987S2FJLnRhzq
LKsaLlOpeRXkXkTD96RI6rZQ+lhCtVSAvOq4kqlSqd6nUddem/gALsivmFKmLLG6
1KspY5ZMzF8jS58SiGHAe09fXhhidA4hfu9xMbVQix7v9zwrW3cuxRQJFFi1dfGi
7nSGYbHqOtot1m+UK7Ad5U510tDPTZui0x6TIFWUakieTl1ZbyFtlcj9Umi2umYn
jU0iE2lNlqo=
=aYAG
-----END PGP SIGNATURE-----

--Apple-Mail=_593C3ACE-E041-402B-A1A9-CAB142A8BC7E--
