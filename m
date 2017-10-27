From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC PATCH 6/8] ext2fs: add EXT4_FEATURE_INCOMPAT_64INODE suport
Date: Fri, 27 Oct 2017 17:48:59 -0600
Message-ID: <C3AD9665-42D1-4290-B514-076990E569EB@dilger.ca>
References: <20171027172254.14137-1-artem.blagodarenko@gmail.com>
 <20171027172254.14137-7-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_44E8AAAF-49AC-4384-BEF2-8E90F085CDA5";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Alexey Lyashkov <alexey.lyashkov@gmail.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:55992 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932385AbdJ0XtE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Oct 2017 19:49:04 -0400
Received: by mail-io0-f195.google.com with SMTP id p186so15979241ioe.12
        for <linux-ext4@vger.kernel.org>; Fri, 27 Oct 2017 16:49:04 -0700 (PDT)
In-Reply-To: <20171027172254.14137-7-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_44E8AAAF-49AC-4384-BEF2-8E90F085CDA5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 27, 2017, at 11:22 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> Inodes count and free inodes count should be 64 bit long.
> This patch also changes s_inodes_count* to 64 bit
>=20
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
>=20
> diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
> index ca688622..9aa8feca 100644
> --- a/debugfs/set_fields.c
> +++ b/debugfs/set_fields.c
> @@ -80,6 +80,7 @@ static errcode_t parse_mmp_clear(struct =
field_set_info *info, char *field,
>=20
> static struct field_set_info super_fields[] =3D {
> 	{ "inodes_count", &set_sb.s_inodes_count, NULL, 4, parse_uint },
> +	{ "inodes_count_hi", &set_sb.s_inodes_count_hi, NULL, 4, =
parse_uint },

Instead of adding a separate "inodes_count_hi" field, replace "NULL" in =
the
"inodes_count" with "&set_sb.s_inodes_count_hi" so that this will accept =
a
64-bit value directly.

> diff --git a/e2fsck/super.c b/e2fsck/super.c
> index 47c89c56..2a5dbbbc 100644
> --- a/e2fsck/super.c
> +++ b/e2fsck/super.c
> @@ -560,7 +560,7 @@ void check_super_block(e2fsck_t ctx)
> 	if (sb->s_rev_level > EXT2_GOOD_OLD_REV)
> 		check_super_value(ctx, "first_ino", sb->s_first_ino,
> 				  MIN_CHECK | MAX_CHECK,
> -				  EXT2_GOOD_OLD_FIRST_INO, =
sb->s_inodes_count);
> +				  EXT2_GOOD_OLD_FIRST_INO, =
ext2fs_get_inodes_count(sb));

Wrap at 80 columns?

>=20
> diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
> index b7f6c1d2..37d05f6e 100644
> --- a/lib/e2p/feature.c
> +++ b/lib/e2p/feature.c
> @@ -105,6 +105,8 @@ static struct feature feature_list[] =3D {
> 			"inline_data"},
> 	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_ENCRYPT,
> 			"encrypt"},
> +	{	E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_64INODE,
> +			"64inode"},

I'd prefer "inode64" for the feature name.

> diff --git a/lib/ext2fs/badblocks.c b/lib/ext2fs/badblocks.c
> index 0f23983b..787c31ac 100644
> --- a/lib/ext2fs/badblocks.c
> +++ b/lib/ext2fs/badblocks.c
> @@ -30,39 +30,39 @@
> /*
>  * Helper function for making a badblocks list
>  */
> -static errcode_t make_u32_list(int size, int num, __u32 *list,
> -			       ext2_u32_list *ret)
> +static errcode_t make_u64_list(int size, int num, __u64 *list,
> +			       ext2_u64_list *ret)
> {

This seems to be changing the on-disk format of the badblocks inode?
In any case, this patch is large enough with just the change to add
accessor functions for the inode numbers, which could just start with
32-bit inode handling.  This should be split into a separate patch, and
probably a separate feature flag to add a 64-bit badblocks file since
it isn't really related to 64-bit inodes, only 64-bit blocks.

> /*
> - * This procedure creates an empty u32 list.
> + * This procedure creates an empty u64 list.
>  */
> -errcode_t ext2fs_u32_list_create(ext2_u32_list *ret, int size)
> +errcode_t ext2fs_u64_list_create(ext2_u64_list *ret, int size)
> {
> -	return make_u32_list(size, 0, 0, ret);
> +	return make_u64_list(size, 0, 0, ret);
> }

This is changing the visible API of the library, as well as the on-disk
badblocks format, so needs to be done in a compatible way (i.e. keeping
the ext2fs_u32_list_* functions and adding new ext2fs_u64_list_* =
functions.

> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index b9773814..f9ba07e6 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -737,7 +737,12 @@ struct ext2_super_block {
> 	__le32	s_lpf_ino;		/* Location of the lost+found =
inode */
> 	__le32  s_prj_quota_inum;	/* inode for tracking project =
quota */
> 	__le32	s_checksum_seed;	/* crc32c(orig_uuid) if =
csum_seed set */
> -	__le32	s_reserved[98];		/* Padding to the end of the =
block */
> +	__u32	s_inodes_count_hi;	/* higth part of inode count */
> +	__u32	s_free_inodes_count_hi;	/* Free inodes count */
> +	__u32	s_usr_quota_inum_hi;
> +	__u32	s_grp_quota_inum_hi;
> +	__u32	s_prj_quota_inum_hi;
> +	__u32	s_reserved[93];		/* Padding to the end of the =
block */
> 	__u32	s_checksum;		/* crc32c(superblock) */

These new fields should use __le32.

> @@ -827,6 +832,8 @@ struct ext2_super_block {
> #define EXT4_FEATURE_INCOMPAT_LARGEDIR		0x4000 /* >2GB =
or 3-lvl htree */
> #define EXT4_FEATURE_INCOMPAT_INLINE_DATA	0x8000 /* data in inode =
*/
> #define EXT4_FEATURE_INCOMPAT_ENCRYPT		0x10000
> +#define EXT4_FEATURE_INCOMPAT_64INODE		0x20000
>=20

Please use EXT4_FEATURE_INCOMPAT_INODE64

> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 8a755a45..9104c63a 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -73,7 +73,7 @@ extern "C" {
> #include <ext2fs/ext3_extents.h>
> #endif /* EXT2_FLAT_INCLUDES */
>=20
> -typedef __u32 __bitwise		ext2_ino_t;
> +typedef __u64 __bitwise		ext2_ino_t;

This changes the library ABI significantly, and I don't think it
can be accepted like this.  Instead, a new ext2_ino64_t needs to
be added, and any ext2fs_* functions or structures that are using
the 32-bit ext2_ino_t field should just be wrappers for the 64-bit
version of the function/struct.

>=20
> @@ -2048,6 +2049,47 @@ ext2fs_const_inode(const struct =
ext2_inode_large *
>=20
> +_INLINE_ unsigned long ext2fs_get_inodes_count(struct =
ext2_super_block *sb)
> +{
> +	unsigned long inodes_count =3D sb->s_inodes_count;
> +
> +	if (sb->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64INODE)
> +		inodes_count |=3D (unsigned long)sb->s_inodes_count_hi =
<< 32;
> +	return inodes_count;
> +}

Regardless of what the kernel is doing, this code should use =
ext2_ino64_t
for dealing with inode numbers instead of "unsigned long".  We want to =
be
able to use/fix filesystems with 64-bit inodes on 32-bit CPUs.

> diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
> index 9d001d5d..506582c7 100644
> --- a/lib/ext2fs/ext2fsP.h
> +++ b/lib/ext2fs/ext2fsP.h
> @@ -29,17 +29,17 @@ static inline int ext2fsP_is_disk_device(mode_t =
mode)
> /*
>  * Badblocks list
>  */
> -struct ext2_struct_u32_list {
> +struct ext2_struct_u64_list {
> 	int	magic;
> 	int	num;
> 	int	size;
> -	__u32	*list;
> +	__u64	*list;
> 	int	badblocks_flags;
> };
>=20
> -struct ext2_struct_u32_iterate {
> +struct ext2_struct_u64_iterate {
> 	int			magic;
> -	ext2_u32_list		bb;
> +	ext2_u64_list		bb;
> 	int			ptr;
> };
>=20

> diff --git a/lib/ext2fs/freefs.c b/lib/ext2fs/freefs.c
> index ea9742ef..e61c7f1f 100644
> --- a/lib/ext2fs/freefs.c
> +++ b/lib/ext2fs/freefs.c
> @@ -68,7 +68,7 @@ void ext2fs_free(ext2_filsys fs)
> /*
>  * This procedure frees a badblocks list.
>  */
> -void ext2fs_u32_list_free(ext2_u32_list bb)
> +void ext2fs_u64_list_free(ext2_u64_list bb)
> {
> 	if (bb->magic !=3D EXT2_ET_MAGIC_BADBLOCKS_LIST)
> 		return;
> @@ -81,7 +81,7 @@ void ext2fs_u32_list_free(ext2_u32_list bb)
>=20
> void ext2fs_badblocks_list_free(ext2_badblocks_list bb)
> {
> -	ext2fs_u32_list_free((ext2_u32_list) bb);
> +	ext2fs_u64_list_free((ext2_u64_list) bb);
> }


This should all go into the separate 64-bit badblocks feature patch,
and there should be a separate patch that is just adding the use of
ext2fs_{get,set}_inodes_count() everywhere that doesn't change any
other functionality.

> diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
> index 32f43210..e1b572e0 100644
> --- a/lib/ext2fs/initialize.c
> +++ b/lib/ext2fs/initialize.c
> @@ -355,9 +356,9 @@ ipg_retry:
> 		ipg--;
> 		goto ipg_retry;
> 	}
> -	super->s_inodes_count =3D super->s_inodes_per_group *
> -		fs->group_desc_count;
> -	super->s_free_inodes_count =3D super->s_inodes_count;
> +	ext2fs_set_inodes_count(super, (unsigned =
long)super->s_inodes_per_group *
> +		fs->group_desc_count);

Need to use an explicit 64-bit type here.

> diff --git a/lib/ext2fs/tst_super_size.c b/lib/ext2fs/tst_super_size.c
> index 0adac411..2858af9f 100644
> --- a/lib/ext2fs/tst_super_size.c
> +++ b/lib/ext2fs/tst_super_size.c
> @@ -53,10 +53,12 @@ int main(int argc, char **argv)
>=20
> 	printf("%8s %-30s %3s\n", "offset", "field", "size");
> 	check_field(s_inodes_count, 4);
> +	check_field(s_inodes_count_hi, 4;

(defect) this is missing the closing parenthesis.

It also needs to be checked in field order.

> 	check_field(s_blocks_count, 4);
> 	check_field(s_r_blocks_count, 4);
> 	check_field(s_free_blocks_count, 4);
> 	check_field(s_free_inodes_count, 4);
> +	check_field(s_free_inodes_count_hi, 4);
> 	check_field(s_first_data_block, 4);
> 	check_field(s_log_block_size, 4);
> 	check_field(s_log_cluster_size, 4);
> diff --git a/lib/ext2fs/write_bb_file.c b/lib/ext2fs/write_bb_file.c
> index 58343408..501b6020 100644
> --- a/lib/ext2fs/write_bb_file.c
> +++ b/lib/ext2fs/write_bb_file.c
> @@ -20,7 +20,7 @@ errcode_t ext2fs_write_bb_FILE(ext2_badblocks_list =
bb_list,
> 			       FILE *f)
> {
> 	badblocks_iterate	bb_iter;
> -	blk_t			blk;
> +	blk64_t			blk;
> 	errcode_t		retval;
>=20
> 	retval =3D ext2fs_badblocks_list_iterate_begin(bb_list, =
&bb_iter);
> diff --git a/misc/badblocks.c b/misc/badblocks.c
> index e4593918..0a4b10b9 100644
> --- a/misc/badblocks.c
> +++ b/misc/badblocks.c
> @@ -114,13 +114,13 @@ static void exclusive_usage(void)
> }
>=20
> static blk_t currently_testing =3D 0;
> -static blk_t num_blocks =3D 0;

All this goes into the badblocks patch.

> diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
> index 395ea9ee..06f11e8e 100644
> --- a/misc/dumpe2fs.c
> +++ b/misc/dumpe2fs.c
> @@ -325,7 +325,7 @@ static void list_bad_blocks(ext2_filsys fs, int =
dump)
> {
> 	badblocks_list		bb_list =3D 0;
> 	badblocks_iterate	bb_iter;
> -	blk_t			blk;
> +	blk64_t			blk;
> 	errcode_t		retval;
> 	const char		*header, *fmt;

Badblocks patch.

> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index e46885b3..7e81c9e9 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -276,7 +276,7 @@ static void handle_bad_blocks(ext2_filsys fs, =
badblocks_list bb_list)
> 	dgrp_t			i;
> 	blk_t			j;
> 	unsigned 		must_be_good;
> -	blk_t			blk;
> +	blk64_t			blk;
> 	badblocks_iterate	bb_iter;
> 	errcode_t		retval;
> 	blk_t			group_block;

Badblocks patch.

> @@ -2476,10 +2479,10 @@ profile_error:
> 	/*
> 	 * Calculate number of inodes based on the inode ratio
> 	 */
> -	fs_param.s_inodes_count =3D num_inodes ? num_inodes :
> -		(ext2fs_blocks_count(&fs_param) * blocksize) / =
inode_ratio;
> +	ext2fs_set_inodes_count(&fs_param, num_inodes);

This looks like it is dropping the whole "inode_ratio" calculation?

> -	if ((((unsigned long long)fs_param.s_inodes_count) *
> +
> +	if (( ext2fs_get_inodes_count(&fs_param) *
> 	     (inode_size ? inode_size : EXT2_GOOD_OLD_INODE_SIZE)) >=3D
> 	    ((ext2fs_blocks_count(&fs_param)) *
> 	     EXT2_BLOCK_SIZE(&fs_param))) {

Cheers, Andreas






--Apple-Mail=_44E8AAAF-49AC-4384-BEF2-8E90F085CDA5
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZ88XrpIg59Q01vtYRAt/dAKCUi/dO8TEKRBa+uM7XuprEQ/5VugCgzLw/
PvfxCp5Pnq33WeXz5RXlEQE=
=kpmv
-----END PGP SIGNATURE-----

--Apple-Mail=_44E8AAAF-49AC-4384-BEF2-8E90F085CDA5--
