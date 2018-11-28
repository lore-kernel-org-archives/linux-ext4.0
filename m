Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44755 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbeK2GKi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Nov 2018 01:10:38 -0500
Received: by mail-pg1-f195.google.com with SMTP id t13so9902074pgr.11
        for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2018 11:07:58 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <BF693ABD-F09B-4E88-AB99-CB0CA35AEB69@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_6C04D7BD-DB38-40D3-A978-60E5F4427DEC";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] ext2fs: don't read group descriptors during e2label
Date: Wed, 28 Nov 2018 12:07:53 -0700
In-Reply-To: <20181128164238.2286-1-artem.blagodarenko@gmail.com>
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        alexey.lyashkov@gmail.com
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
References: <20181128164238.2286-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_6C04D7BD-DB38-40D3-A978-60E5F4427DEC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 28, 2018, at 9:42 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> tune2fs is used to make e2label duties.  ext2fs_open2() reads group
> descriptors which are not used during disk label obtaining, but
> takes a lot of time on large partitions.
>=20
> This patch change ext2fs_open2(), so only initialized
> superblock is returned. without block descriptors. This save
> time dramatically.
>=20
> Cray-bug-id: LUS-5777
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> ---
> lib/ext2fs/ext2fs.h |  1 +
> lib/ext2fs/openfs.c | 22 +++++++++++++++++++---
> misc/tune2fs.c      |  7 ++++++-
> 3 files changed, 26 insertions(+), 4 deletions(-)
>=20
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 5b87d395..5318b14d 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -204,6 +204,7 @@ typedef struct ext2_file *ext2_file_t;
> #define EXT2_FLAG_IGNORE_CSUM_ERRORS	0x200000
> #define EXT2_FLAG_SHARE_DUP		0x400000
> #define EXT2_FLAG_IGNORE_SB_ERRORS	0x800000
> +#define EXT2_FLAG_LABEL			0x1000000

There are already a couple of similar flags, EXT2_FLAG_SUPER_ONLY,
but I guess that doesn't quite do the right thing either?

The only minor nit I have is that the flag name should describe what
it does, rather than what it is being used for.  For example, a better
name would be "EXT2_FLAG_JOURNAL_ONLY" or similar, so that other
users might use it, instead of thinking it is specific to the label.

Cheers, Andreas

>=20
> /*
>  * Special flag in the ext2 inode i_flag field that means that this is
> diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
> index 85d73e2a..a5e97e6d 100644
> --- a/lib/ext2fs/openfs.c
> +++ b/lib/ext2fs/openfs.c
> @@ -135,6 +135,7 @@ errcode_t ext2fs_open2(const char *name, const =
char *io_options,
> 	int		j;
> #endif
> 	char		*time_env;
> +	unsigned long	enough_desc_blocks;
>=20
> 	EXT2_CHECK_MAGIC(manager, EXT2_ET_MAGIC_IO_MANAGER);
>=20
> @@ -440,12 +441,23 @@ errcode_t ext2fs_open2(const char *name, const =
char *io_options,
> 		dest +=3D fs->blocksize*first_meta_bg;
> 	}
>=20
> -	for (i =3D first_meta_bg ; i < fs->desc_blocks; i++) {
> +	/*
> +	 * Need superblock and journal inode only. Do not read
> +	 * met_bg group blocks if journal inode group already loaded
> +	 */
> +	if (flags & EXT2_FLAG_LABEL)
> +		enough_desc_blocks =3D
> +			fs->super->s_journal_inum /
> +			EXT2_INODES_PER_GROUP(fs->super) + 1;
> +	else
> +		enough_desc_blocks =3D fs->desc_blocks;
> +
> +	for (i =3D first_meta_bg; i < enough_desc_blocks; i++) {
> 		blk =3D ext2fs_descriptor_block_loc2(fs, group_block, =
i);
> 		io_channel_cache_readahead(fs->io, blk, 1);
> 	}
>=20
> -	for (i=3Dfirst_meta_bg ; i < fs->desc_blocks; i++) {
> +	for (i =3D first_meta_bg; i < enough_desc_blocks; i++) {
> 		blk =3D ext2fs_descriptor_block_loc2(fs, group_block, =
i);
> 		retval =3D io_channel_read_blk64(fs->io, blk, 1, dest);
> 		if (retval)
> @@ -468,8 +480,12 @@ errcode_t ext2fs_open2(const char *name, const =
char *io_options,
> 	 */
> 	if (superblock > 1 && ext2fs_has_group_desc_csum(fs)) {
> 		dgrp_t group;
> +		dgrp_t enough_desc_count;
> +
> +		enough_desc_count =3D enough_desc_blocks *
> +				    EXT2_DESC_PER_BLOCK(fs->super);
>=20
> -		for (group =3D 0; group < fs->group_desc_count; group++) =
{
> +		for (group =3D 0; group < enough_desc_count; group++) {
> 			ext2fs_bg_flags_clear(fs, group, =
EXT2_BG_BLOCK_UNINIT);
> 			ext2fs_bg_flags_clear(fs, group, =
EXT2_BG_INODE_UNINIT);
> 			ext2fs_bg_itable_unused_set(fs, group, 0);
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index cd4057c3..3d0c7d51 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -2882,6 +2882,12 @@ retry_open:
> 	/* keep the filesystem struct around to dump MMP data */
> 	open_flag |=3D EXT2_FLAG_NOFREE_ON_ERROR;
>=20
> +	if (print_label || L_flag) {
> +		open_flag |=3D EXT2_FLAG_LABEL;
> +		/* don't want metadata to be flushed at close */
> +		//open_flag &=3D ~EXT2_FLAG_RW;
> +	}
> +
> 	retval =3D ext2fs_open2(device_name, io_options, open_flag,
> 			      0, 0, io_ptr, &fs);
> 	if (retval) {
> @@ -2999,7 +3005,6 @@ _("Warning: The journal is dirty. You may wish =
to replay the journal like:\n\n"
> 	if ((open_flag & EXT2_FLAG_RW) && !(mount_flags & (EXT2_MF_BUSY =
| EXT2_MF_MOUNTED)) &&
> 	    ext2fs_has_feature_journal_needs_recovery(fs->super)) {
> 		errcode_t err;
> -
> 		printf(_("Recovering journal.\n"));
> 		err =3D ext2fs_run_ext3_journal(&fs);
> 		if (err) {
> --
> 2.14.3
>=20


Cheers, Andreas






--Apple-Mail=_6C04D7BD-DB38-40D3-A978-60E5F4427DEC
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlv+54kACgkQcqXauRfM
H+BWLhAAjjxDEIn6TNr3EXBI6QL77ew3UqvUD1ZiyI7xAi7g4ExfwRJ5x71+CnVW
G41X7RLc5mLSBLIDtGKzLT74gJ6HsZn97B1xsjEvY6pQACSMn1ZwrNzics89888J
oZorhWZke+ROXV/A9feMn7EzVL4cX7iCuECKZ90NPJcs3mj0Cs1RUco4IGm6Igc0
pal2B72dxLv1POiAlBmN9BPDu7AJoFaV1CmGKGXLL/i85X/JcY3BEWn6NLBlfbLI
NsP420U5RZ2hz1IYg8buzmoT4HTJWmg/QsTpWNvRInDp5Q201KeL06CBGqOHaj9w
t9NZ7DfYrqK4IOxx6TCJ75Vc0LWu2yA9B2YoVypBDkrmkRphwpPP/utrq1fwbm0h
IfANjrU/WT8r0rWdChnPoMHOv3axEWwqjC+SkUbMH+97vv5STrpCm1CgYoxhKLnu
cvxGLZYwHOoqmwvp4BN3ItPT3sIARtTiUfyE9UhqqnHBODS8XOHgQcFM82DVqJKY
mkfa59V5YHvgQFSse7HkDgVcJbNGCbyWqJICBNk9lBlkR8ftFk8zAxrdGok5Y8Eh
MLPvvdGIcAA4H0KuepWXh8Ap6NWz9YRZqZJwMEgpHkt8jpVSoR9ghYHx8TTbaiAS
t1x9sjtCrMFzuG6YbWkPF5yS3zw3v3nZz8aQpCpLrld/pDn7rkU=
=HEXq
-----END PGP SIGNATURE-----

--Apple-Mail=_6C04D7BD-DB38-40D3-A978-60E5F4427DEC--
