From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC PATCH 8/8] quota: quota 64bit inode number cleanup
Date: Fri, 27 Oct 2017 17:59:35 -0600
Message-ID: <FB8C02E3-15F9-413B-97AE-2F433CA9A213@dilger.ca>
References: <20171027172254.14137-1-artem.blagodarenko@gmail.com>
 <20171027172254.14137-9-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_5B7B666A-3BAD-4481-A6B1-7BC54A7694DC";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Alexey Lyashkov <alexey.lyashkov@gmail.com>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:44779 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932484AbdJ0X7s (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Oct 2017 19:59:48 -0400
Received: by mail-io0-f195.google.com with SMTP id m16so16048607iod.1
        for <linux-ext4@vger.kernel.org>; Fri, 27 Oct 2017 16:59:47 -0700 (PDT)
In-Reply-To: <20171027172254.14137-9-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_5B7B666A-3BAD-4481-A6B1-7BC54A7694DC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 27, 2017, at 11:22 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> Quota stores inodes numbers and beed to be fixed
> to store 64bit inodes.
>=20
> This patch makes quota 64bit inode ready.
>=20
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
> ---
> debugfs/set_fields.c        |  3 +++
> e2fsck/pass1.c              |  3 ++-
> e2fsck/quota.c              |  8 ++++----
> e2fsck/unix.c               |  2 +-
> lib/e2p/ls.c                |  4 ++--
> lib/ext2fs/swapfs.c         |  3 +++
> lib/ext2fs/tst_super_size.c |  5 ++++-
> lib/support/mkquota.c       | 10 +++-------
> lib/support/quotaio.c       |  2 +-
> lib/support/quotaio.h       | 47 =
+++++++++++++++++++++++++++++++++++++--------
> misc/tune2fs.c              |  4 ++--
> 11 files changed, 64 insertions(+), 27 deletions(-)
>=20
> diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
> index 9aa8feca..521f8483 100644
> --- a/debugfs/set_fields.c
> +++ b/debugfs/set_fields.c
> @@ -153,8 +153,11 @@ static struct field_set_info super_fields[] =3D {
> 	{ "snapshot_list", &set_sb.s_snapshot_list, NULL, 4, parse_uint =
},
> 	{ "mount_opts",  &set_sb.s_mount_opts, NULL, 64, parse_string },
> 	{ "usr_quota_inum", &set_sb.s_usr_quota_inum, NULL, 4, =
parse_uint },
> +	{ "usr_quota_inum_hi", &set_sb.s_usr_quota_inum_hi, NULL, 4, =
parse_uint },
> 	{ "grp_quota_inum", &set_sb.s_grp_quota_inum, NULL, 4, =
parse_uint },
> +	{ "grp_quota_inum_hi", &set_sb.s_grp_quota_inum_hi, NULL, 4, =
parse_uint },
> 	{ "prj_quota_inum", &set_sb.s_prj_quota_inum, NULL, 4, =
parse_uint },
> +	{ "prj_quota_inum_hi", &set_sb.s_prj_quota_inum_hi, NULL, 4, =
parse_uint },

As with the other code, the "inum_hi" handling should be moved into the =
previous
line for all cases, replacing "NULL" with =
"&set_sb.s_{usr,grp,prj}_quota_inum_hi".

> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index 2eedbcfb..a70ce071 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -1130,7 +1130,8 @@ static int quota_inum_is_super(struct =
ext2_super_block *sb, ext2_ino_t ino)
> 	enum quota_type qtype;
>=20
> 	for (qtype =3D 0; qtype < MAXQUOTAS; qtype++)
> -		if (*quota_sb_inump(sb, qtype) =3D=3D ino)
> +		if (quota_sb_inump(sb, qtype) =3D=3D ino)
> +
> 			return 1;

Remove extra blank line here.

Also, this function should no longer be named "inump", since that meant
"inum pointer", which it no longer returns.

> diff --git a/lib/ext2fs/tst_super_size.c b/lib/ext2fs/tst_super_size.c
> index 2858af9f..7972d24f 100644
> --- a/lib/ext2fs/tst_super_size.c
> +++ b/lib/ext2fs/tst_super_size.c
> @@ -53,7 +53,7 @@ int main(int argc, char **argv)
>=20
> 	printf("%8s %-30s %3s\n", "offset", "field", "size");
> 	check_field(s_inodes_count, 4);
> -	check_field(s_inodes_count_hi, 4;
> +	check_field(s_inodes_count_hi, 4);
> 	check_field(s_blocks_count, 4);
> 	check_field(s_r_blocks_count, 4);
> 	check_field(s_free_blocks_count, 4);

This should be in the previous patch.

> @@ -136,13 +136,16 @@ int main(int argc, char **argv)
> 	check_field(s_last_error_func, 32);
> 	check_field(s_mount_opts, 64);
> 	check_field(s_usr_quota_inum, 4);
> +	check_field(s_usr_quota_inum_hi, 4);
> 	check_field(s_grp_quota_inum, 4);
> +	check_field(s_grp_quota_inum_hi, 4);
> 	check_field(s_overhead_blocks, 4);
> 	check_field(s_backup_bgs, 8);
> 	check_field(s_encrypt_algos, 4);
> 	check_field(s_encrypt_pw_salt, 16);
> 	check_field(s_lpf_ino, 4);
> 	check_field(s_prj_quota_inum, 4);
> +	check_field(s_prj_quota_inum_hi, 4);
> 	check_field(s_checksum_seed, 4);
> 	check_field(s_reserved, 98 * 4);
> 	check_field(s_checksum, 4);

These new fields should all be checked in struct order, rather than =
after
the non-"_hi" field of the same name.

> diff --git a/lib/support/quotaio.h b/lib/support/quotaio.h
> index f89536eb..eb667eb1 100644
> --- a/lib/support/quotaio.h
> +++ b/lib/support/quotaio.h
> @@ -245,21 +245,52 @@ int parse_quota_types(const char *in_str, =
unsigned int *qtype_bits,
>  * This allows the caller to get or set the quota inode by type =
without the
>  * need for the quota array to be contiguous in the superbock.
>  */
> -static inline ext2_ino_t *quota_sb_inump(struct ext2_super_block *sb,
> -					 enum quota_type qtype)
> +static inline ext2_ino_t quota_sb_inump(struct ext2_super_block *sb,
> +					enum quota_type qtype)
> {
> +	ext2_ino_t quota_inum =3D 0;
> +
> 	switch (qtype) {
> 	case USRQUOTA:
> -		return &sb->s_usr_quota_inum;
> +		quota_inum =3D sb->s_usr_quota_inum;
> +		if(sb->s_feature_incompat & =
EXT4_FEATURE_INCOMPAT_64INODE)
> +			quota_inum |=3D (unsigned =
long)sb->s_usr_quota_inum_hi <<
>  32;

(style) space after "if", for cases below as well
(style) use "u64" instead of unsigned long to fit within 80 columns

> +		break;
> 	case GRPQUOTA:
> -		return &sb->s_grp_quota_inum;
> +		quota_inum =3D sb->s_grp_quota_inum;
> +		if(sb->s_feature_incompat & =
EXT4_FEATURE_INCOMPAT_64INODE)
> +			quota_inum |=3D (unsigned =
long)sb->s_grp_quota_inum_hi << 32;
> +		break;
> 	case PRJQUOTA:
> -		return &sb->s_prj_quota_inum;
> -	default:
> -		return NULL;
> +		quota_inum =3D sb->s_prj_quota_inum;
> +		if(sb->s_feature_incompat & =
EXT4_FEATURE_INCOMPAT_64INODE)
> +			quota_inum |=3D (unsigned =
long)sb->s_prj_quota_inum_hi << 32;
> +		break;
>=20

Cheers, Andreas






--Apple-Mail=_5B7B666A-3BAD-4481-A6B1-7BC54A7694DC
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZ88hppIg59Q01vtYRAlLLAKCvD8E2UGtLrDmq2ccPh7g8jEGiUgCfVNl7
YuHD1v07K/SohyZRURRxErY=
=MvIc
-----END PGP SIGNATURE-----

--Apple-Mail=_5B7B666A-3BAD-4481-A6B1-7BC54A7694DC--
