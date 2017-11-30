From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v3 1/3] ext4: Removes static definition of dx_root struct
Date: Thu, 30 Nov 2017 15:17:00 -0700
Message-ID: <6FFCEA37-004E-4675-AB03-171DAB91C80F@dilger.ca>
References: <20171130151753.24986-1-artem.blagodarenko@gmail.com>
 <20171130151753.24986-2-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_34FBEE7E-6D5E-4DC3-BF45-B68C52E94ED6";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Yang Sheng <yang.sheng@intel.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:44460 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750932AbdK3WRH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Nov 2017 17:17:07 -0500
Received: by mail-it0-f67.google.com with SMTP id b5so302802itc.3
        for <linux-ext4@vger.kernel.org>; Thu, 30 Nov 2017 14:17:07 -0800 (PST)
In-Reply-To: <20171130151753.24986-2-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_34FBEE7E-6D5E-4DC3-BF45-B68C52E94ED6
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 30, 2017, at 8:17 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> From: Yang Sheng <yang.sheng@intel.com>
>=20
> Removes static definition of dx_root struct. so that "." and ".." =
dirent
> can have extra data. This patch does not change any functionality but =
is
> required for ext4_data_in_dirent patch.
>=20
> Signed-off-by: Yang Sheng <yang.sheng@intel.com>
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> ---
> fs/ext4/namei.c | 130 =
+++++++++++++++++++++++++++++++-------------------------
> 1 file changed, 71 insertions(+), 59 deletions(-)
>=20
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index c1cf020d1889..7c649cf2b630 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -193,23 +193,13 @@ struct dx_entry
>  * dirent the two low bits of the hash version will be zero.  =
Therefore, the
>  * hash version mod 4 should never be 0.  Sincerely, the paranoia =
department.
>  */
> -
> -struct dx_root
> +struct dx_root_info
> {
> -	struct fake_dirent dot;
> -	char dot_name[4];
> -	struct fake_dirent dotdot;
> -	char dotdot_name[4];
> -	struct dx_root_info
> -	{
> -		__le32 reserved_zero;
> -		u8 hash_version;
> -		u8 info_length; /* 8 */
> -		u8 indirect_levels;
> -		u8 unused_flags;
> -	}
> -	info;
> -	struct dx_entry	entries[0];
> +	__le32 reserved_zero;
> +	u8 hash_version;
> +	u8 info_length; /* 8 */
> +	u8 indirect_levels;
> +	u8 unused_flags;
> };
>=20
> struct dx_node
> @@ -521,6 +511,17 @@ static inline void dx_set_block(struct dx_entry =
*entry, ext4_lblk_t value)
> 	entry->block =3D cpu_to_le32(value);
> }
>=20
> +struct dx_root_info *dx_get_dx_info(struct ext4_dir_entry_2 *de)
> +{
> +	/* get dotdot first */
> +	de =3D (struct ext4_dir_entry_2 *)((char *)de + =
EXT4_DIR_NAME_LEN(1));
> +
> +	/* dx root info is after dotdot entry */
> +	de =3D (struct ext4_dir_entry_2 *)((char *)de + =
EXT4_DIR_NAME_LEN(2));
> +
> +	return (struct dx_root_info *)de;
> +}
> +
> static inline unsigned dx_get_hash(struct dx_entry *entry)
> {
> 	return le32_to_cpu(entry->hash);
> @@ -744,17 +745,17 @@ dx_probe(struct ext4_filename *fname, struct =
inode *dir,
> 	if (IS_ERR(frame->bh))
> 		return (struct dx_frame *) frame->bh;
>=20
> -	root =3D (struct dx_root *) frame->bh->b_data;
> -	if (root->info.hash_version !=3D DX_HASH_TEA &&
> -	    root->info.hash_version !=3D DX_HASH_HALF_MD4 &&
> -	    root->info.hash_version !=3D DX_HASH_LEGACY) {
> -		ext4_warning_inode(dir, "Unrecognised inode hash code =
%u",
> -				   root->info.hash_version);
> +	info =3D dx_get_dx_info((struct ext4_dir_entry_2 =
*)frame->bh->b_data);
> +	if (info->hash_version !=3D DX_HASH_TEA &&
> +	    info->hash_version !=3D DX_HASH_HALF_MD4 &&
> +	    info->hash_version !=3D DX_HASH_LEGACY) {
> +		ext4_warning(dir->i_sb, "inode #%lu: unrecognised hash =
code %u",
> +			     dir->i_ino, info->hash_version);

This is probably a conflict from the older version of the dx_root patch =
with
newer error messages.  The new ext4_warning_inode() message should be =
kept,
and just the "root->info." usage replaced by "info->".

> @@ -762,18 +763,18 @@ dx_probe(struct ext4_filename *fname, struct =
inode *dir,
>=20
> -	if (root->info.unused_flags & 1) {
> -		ext4_warning_inode(dir, "Unimplemented hash flags: =
%#06x",
> -				   root->info.unused_flags);
> +	if (info->unused_flags & 1) {
> +		ext4_warning_inode(dir,
> +				"inode #%lu: Unimplemented hash flags: =
%#06x",
> +				dir->i_ino, info->unused_flags);

Similarly, the ext4_warning_inode() message already prints "inode #%lu: =
" at
the start, so the old message should be kept and just replace =
"root->info.".

> 	if (indirect >=3D ext4_dir_htree_level(dir->i_sb)) {
> 		ext4_warning(dir->i_sb,
> -			     "Directory (ino: %lu) htree depth %#06x =
exceed"
> -			     "supported value", dir->i_ino,
> -			     ext4_dir_htree_level(dir->i_sb));
> +			     "inode #%lu unimplemented hash depth =
%#06x",
> +			     dir->i_ino, =
ext4_dir_htree_level(dir->i_sb));

This should also be using ext4_warning_inode() and drop the "inode #%lu"
at the start, leaving "directory htree depth %u exceeds supported value =
%u",
and also print ext4_dir_htree_level(dir->i_sb) at the end.  It isn't =
clear
why the depth was printed in hex previously, that doesn't make sense.

> @@ -781,14 +782,17 @@ dx_probe(struct ext4_filename *fname, struct =
inode *dir,
>=20
> 	if (dx_get_limit(entries) !=3D dx_root_limit(dir,

It would make sense to move "dx_root_limit(dir," to the next line, =
aligned
after 'if (', so that it is not wrapping so close to the end.

> -						   =
root->info.info_length)) {
> -		ext4_warning_inode(dir, "dx entry: limit %u !=3D root =
limit %u",
> -				   dx_get_limit(entries),
> -				   dx_root_limit(dir, =
root->info.info_length));
> +				(struct ext4_dir_entry_2 *) =
frame->bh->b_data,
> +				info->info_length)) {
> +		ext4_warning(dir->i_sb, "dx entry: limit !=3D root limit =
"
> +			     "inode #%lu: dx entry: limit %u !=3D root =
limit %u",
> +			     dir->i_ino, dx_get_limit(entries),
> +			     dx_root_limit(dir, (struct ext4_dir_entry_2 =
*)
> +					   frame->bh->b_data,
> +					   info->info_length));

Use the old message with ext4_warning_inode(), which doesn't have the
duplicate "dx entry:" part, and doesn't need the "inode #%lu: " anymore.

Cheers, Andreas






--Apple-Mail=_34FBEE7E-6D5E-4DC3-BF45-B68C52E94ED6
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFaIINepIg59Q01vtYRAj5pAJ9a3/2GKTTPpQ0XNwfdmyy7gEdLkgCffhFQ
yLTUR8EUhRlzRekGwMUcQwo=
=wrbu
-----END PGP SIGNATURE-----

--Apple-Mail=_34FBEE7E-6D5E-4DC3-BF45-B68C52E94ED6--
