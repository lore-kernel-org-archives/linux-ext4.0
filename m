From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: check s_chksum_driver when looking for bg csum presence
Date: Tue, 14 Oct 2014 01:23:21 +0400
Message-ID: <87y4sjpsty.fsf@openvz.org>
References: <20141013211845.GH12009@birch.djwong.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:47694 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaJMVXb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Oct 2014 17:23:31 -0400
Received: by mail-wi0-f177.google.com with SMTP id fb4so8528663wid.16
        for <linux-ext4@vger.kernel.org>; Mon, 13 Oct 2014 14:23:30 -0700 (PDT)
In-Reply-To: <20141013211845.GH12009@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

"Darrick J. Wong" <darrick.wong@oracle.com> writes:

> Convert the ext4_has_group_desc_csum predicate to look for a checksum
> driver instead of the metadata_csum flag and change the bg checksum
> calculation function to look for GDT_CSUM before taking the crc16
> path.
>
> Without this patch, if we mount with ^uninit_bg,^metadata_csum and
> later metadata_csum gets turned on by accident, the block group
> checksum functions will incorrectly assume that checksumming is
> enabled (metadata_csum) but that crc16 should be used
> (!s_chksum_driver).  This is totally wrong, so fix the predicate
> and the checksum formula selection.
>
> (Granted, if the metadata_csum feature bit gets enabled on a live FS
> then something underhanded is going on, but we could at least avoid
> writing garbage into the on-disk fields.)
>
Agree. feel free to add=20
Ack-by: Dmitry Monakhov <dmonakhov@openvz.org>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Cc: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/ext4.h  |    4 ++--
>  fs/ext4/super.c |    4 ++++
>  2 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index fb6aadf..db38ca0f 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2367,8 +2367,8 @@ extern int ext4_register_li_request(struct super_bl=
ock *sb,
>  static inline int ext4_has_group_desc_csum(struct super_block *sb)
>  {
>  	return EXT4_HAS_RO_COMPAT_FEATURE(sb,
> -					  EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
> -					  EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
> +					  EXT4_FEATURE_RO_COMPAT_GDT_CSUM) ||
> +	       (EXT4_SB(sb)->s_chksum_driver !=3D NULL);
>  }
>=20=20
>  static inline int ext4_has_metadata_csum(struct super_block *sb)
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 6ae47d4..de38a96 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2032,6 +2032,10 @@ static __le16 ext4_group_desc_csum(struct ext4_sb_=
info *sbi, __u32 block_group,
>  	}
>=20=20
>  	/* old crc16 code */
> +	if (!(sbi->s_es->s_feature_ro_compat &
> +	      cpu_to_le32(EXT4_FEATURE_RO_COMPAT_GDT_CSUM)))
> +		return 0;
> +
>  	offset =3D offsetof(struct ext4_group_desc, bg_checksum);
>=20=20
>  	crc =3D crc16(~0, sbi->s_es->s_uuid, sizeof(sbi->s_es->s_uuid));

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUPELJAAoJEFzOBSYIXfveKzUP/1LYD1jvSaVg33KM+EM6WnPM
7hpOEfab6oF7vMbc1e+9ImbJvtr2jijZe2UH/L3u1U2qjj39emj4qmS80IcrS8e9
s4FXVizsLLLYa4NGth6RBGnZc+NFlVuf/NFTMtbFZWW33yiz+NO5kLS3zcyrNdB7
ZF9jHmFURGBVRFlNA7QKIydOebKTlUF1Yie8ARv37fK5ZEZ4ssjznhZ4K8CJeZNh
xl1mFSKqzAF6jVnbVvIivm4klYAMT2xNwCipS1hbCUT5k/ZHyM+Q+IovIxwFz47X
r9PSU59Ajxy3+hWmwSdslIlaXsSrm6kS1enK4cZl3jQvcyCFA/S4T3ECJ/hq5hv+
ixntgj8+9sKWzUJ9ImrVYhDu6mcbpII0BF00K47MWhee15iDq6bKk88I3d+NsYp+
FT7HHYZtc3RSaZSKHFiGEPWwUL3Ud5O2GeYThBiviHZSnaBdj/jk3SmbjtkTRC1j
Y4kPnkLTJIdLEIvUXUV474YTii5jXuGOObd4DKsPPpKwBrXuz7/0YB3JS3ZUDQj7
P9QsAqweBMxeEqL66jvLA5Lmyxxs64DMs2WGT5AnmOQd3UOAL7uCfIJ8jqU45e7G
r6/LiQga2C0jOHdm9MZTMk7loltFH5YGYk4fyOt2GtOPOBccfwLDQaZPf3PFPahh
CS+Fd1db5G6YLVzjn9Pi
=ufI7
-----END PGP SIGNATURE-----
--=-=-=--
