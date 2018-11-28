Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34384 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbeK2ITb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Nov 2018 03:19:31 -0500
Received: by mail-pg1-f194.google.com with SMTP id 17so10061432pgg.1
        for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2018 13:16:32 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <41473332-C973-4E58-8DF5-577E3C937846@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_806B8971-88DA-49C6-B864-DE278895B235";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v2] ext2fs: don't read group descriptors during e2label
Date: Wed, 28 Nov 2018 14:16:30 -0700
In-Reply-To: <20181128204840.4544-1-artem.blagodarenko@gmail.com>
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        alexey.lyashkov@gmail.com
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
References: <20181128204840.4544-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_806B8971-88DA-49C6-B864-DE278895B235
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Nov 28, 2018, at 1:48 PM, Artem Blagodarenko =
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

One minor nit at the end, but looks fine otherwise:

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

>=20
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 5b87d395..2abb6f76 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -204,6 +204,7 @@ typedef struct ext2_file *ext2_file_t;
> #define EXT2_FLAG_IGNORE_CSUM_ERRORS	0x200000
> #define EXT2_FLAG_SHARE_DUP		0x400000
> #define EXT2_FLAG_IGNORE_SB_ERRORS	0x800000
> +#define EXT2_FLAG_JOURNAL_ONLY		0x1000000
>=20
> /*
>  * Special flag in the ext2 inode i_flag field that means that this is
> diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
> index 85d73e2a..af671070 100644
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
> +	if (flags & EXT2_FLAG_JOURNAL_ONLY)
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
> index cd4057c3..b226fdbf 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -2882,6 +2882,12 @@ retry_open:
> 	/* keep the filesystem struct around to dump MMP data */
> 	open_flag |=3D EXT2_FLAG_NOFREE_ON_ERROR;
>=20
> +	if (print_label || L_flag) {
> +		open_flag |=3D EXT2_FLAG_JOURNAL_ONLY;
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

Not sure why this hunk is here?  There should normally be a blank line =
after
local variable declarations.

Cheers, Andreas






--Apple-Mail=_806B8971-88DA-49C6-B864-DE278895B235
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlv/Ba4ACgkQcqXauRfM
H+A5Pw/5AWJtDHivpfMwYrV1jpSmFxNMFTRnxnpVYM72s+rFg4LIm10EI7QYWMfj
W8WtFLPWYKRDh6msHgsMeAro0olReTrjKhk6UJmpkZ3dvDXmdR0pBSrmEqSMaO1B
rSLpQVhvi3Fq7JfzaiBWirt0It3XhI3U+T9alQrXV6hpM2Ec/P2zAexNSqnKqyUM
ipGOhPv8PdFyv2TYpem5cz/k1oSGWbPhLjQEQ15RYp+qK7nXpiwIyXCELGtIP4f+
cTtny8951kPkoEorvXYXHJqRkG1jFtm8JF21L3tF3MJ78BS9SMTHIastKHF5hNM7
9Lrbzn6Q8KhAKgiKS58y1x9zucLNgw/kbBv6pf92zdBW40wCX5loDlTjOQJqXH3q
666cuksJMTPHD8rg/cpuQNpfZktmw9tQPhOelan9++X32QT8+QZT35NVvzS1xvvd
BplwS72p9rqIXxUKgMHkWH2KWerIlqcrxrJm2omopTXP2dwcqLxvQTdBwVKyKS3b
XVKUFQ3eHU4l+NQvAIv1183gNjROjIEbgjnac3Y7AjN0YqTh6+jDLLJ53QXeVdWK
v92yL5zKIqn3tbdFlvQDcLTC79rqLMZRXtlWMrelpOddw0ozxlUpODi86Pk95a0H
198WfhInbRg/7M/ur1QI1VeoujdfK065KzSISTE2W1FmNhjnmYA=
=pnqB
-----END PGP SIGNATURE-----

--Apple-Mail=_806B8971-88DA-49C6-B864-DE278895B235--
