From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2 5/7] ext2fs: add EXT4_FEATURE_INCOMPAT_64INODE support
Date: Mon, 20 Nov 2017 16:09:06 -0700
Message-ID: <5CA69BCC-16C4-4A9A-A28F-8FDA7861CC06@dilger.ca>
References: <20171114070440.79510-1-artem.blagodarenko@gmail.com>
 <20171114070440.79510-6-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_DABA68EF-9B38-4F10-8C57-84F19F82DD05";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:41592 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751159AbdKTXJL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Nov 2017 18:09:11 -0500
Received: by mail-io0-f181.google.com with SMTP id g73so17444043ioj.8
        for <linux-ext4@vger.kernel.org>; Mon, 20 Nov 2017 15:09:11 -0800 (PST)
In-Reply-To: <20171114070440.79510-6-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_DABA68EF-9B38-4F10-8C57-84F19F82DD05
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Note "Subject:" line needs to list "INODE64" instead of "64INODE"

On Nov 14, 2017, at 12:04 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> Inodes count and free inodes count should be 64 bit long.
> This patch also changes s_inodes_count* to 64 bit
>=20
> Lustre-bug: https://jira.hpdd.intel.com/browse/LU-9309
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> ---

At a high level this patch is good.

I think it would be a lot easier to review this patch if there was
one patch that just added the ext2fs_{get,set}_inodes_count() and
ext2fs_{get,set}_free_inodes_count() helper routines (that only
use the low word) and "%lu" format, and then the second patch added
the INODE64 functionality.

This would allow about 90% of this patch to be trivially reviewed,
and even landed, and then the second patch contains the important
64-bit inode related changes that needs more thorough review.

> diff --git a/debugfs/util.c b/debugfs/util.c
> index 452de749..3e4fcb5a 100644
> --- a/debugfs/util.c
> +++ b/debugfs/util.c
> @@ -119,7 +119,8 @@ ext2_ino_t string_to_inode(char *str)
> 	 */
> 	if ((len > 2) && (str[0] =3D=3D '<') && (str[len-1] =3D=3D '>')) =
{
> 		ino =3D strtoul(str+1, &end, 0);
> -		if (*end=3D=3D'>' && (ino <=3D =
current_fs->super->s_inodes_count))
> +		if (*end =3D=3D '>' &&
> +			(ino <=3D =
ext2fs_get_inodes_count(current_fs->super)))

(style) align after '(' on previous line.
(style) No need for () around <=3D comparison.

> diff --git a/e2fsck/extents.c b/e2fsck/extents.c
> index ef3146d8..d6bfcfb1 100644
> --- a/e2fsck/extents.c
> +++ b/e2fsck/extents.c
> @@ -396,9 +396,9 @@ static void rebuild_extents(e2fsck_t ctx, const =
char *pass_name, int pr_header)
> 		}
> 		if (ctx->progress && !ctx->progress_fd)
> 			e2fsck_simple_progress(ctx, "Rebuilding =
extents",
> -					100.0 * (float) ino /
> -					(float) =
ctx->fs->super->s_inodes_count,
> -					ino);
> +				100.0 * (float) ino /
> +				(float) =
ext2fs_get_inodes_count(ctx->fs->super),

(style) no space after typecast.

> diff --git a/lib/ext2fs/alloc_stats.c b/lib/ext2fs/alloc_stats.c
> index 3949f618..9a145b43 100644
> --- a/lib/ext2fs/alloc_stats.c
> +++ b/lib/ext2fs/alloc_stats.c
> @@ -48,7 +48,9 @@ void ext2fs_inode_alloc_stats2(ext2_filsys fs, =
ext2_ino_t ino,
> 		ext2fs_group_desc_csum_set(fs, group);
> 	}
>=20
> -	fs->super->s_free_inodes_count -=3D inuse;
> +	ext2fs_set_free_inodes_count(fs->super,
> +				     =
ext2fs_get_free_inodes_count(fs->super) -
> +								  =
inuse);

This looks like "inuse" is an argument to ext2_get_free_inodes_count().
It should be indented one tab from ext2fs_get_free_inodes_count() so it =
is
clear this is a continued line.

> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index 90294ed0..cb0f59d4 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -737,7 +737,10 @@ struct ext2_super_block {
> 	__le32	s_lpf_ino;		/* Location of the lost+found =
inode */
> 	__le32  s_prj_quota_inum;	/* inode for tracking project =
quota */
> 	__le32	s_checksum_seed;	/* crc32c(orig_uuid) if =
csum_seed set */
> -	__le32	s_reserved[98];		/* Padding to the end of the =
block */
> +	__le32	s_inodes_count_hi;	/* higth part of inode count */
> +	__le32	s_free_inodes_count_hi;	/* Free inodes count */
> +	__le32	s_prj_quota_inum_hi;
> +	__le32	s_reserved[93];		/* Padding to the end of the =
block */

98 - 3 =3D 95?

> 	__u32	s_checksum;		/* crc32c(superblock) */
> };

This misalignment of the s_checksum field should cause test failures in =
the
checksum patches, and hopefully also some other checks to fail.  We =
should
definitely have a "sizeof(ext2_super_block) =3D=3D 1024" check =
somewhere.
Did you run "make check" on these patches?

> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index b653012f..785042df 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> +static inline void ext2fs_set_inodes_count(struct ext2_super_block =
*sb,
> +					   ext2_ino64_t val)
> +{
> +	if (ext2fs_has_feature_inode64(sb))
> +		sb->s_inodes_count_hi =3D  val >> 32;

(style) two spaces before "val" here

> +static inline void ext2fs_set_free_inodes_count(struct =
ext2_super_block *sb,
> +						ext2_ino64_t val)
> +{
> +	if (ext2fs_has_feature_inode64(sb))
> +		sb->s_free_inodes_count_hi =3D  (__u32)(val >> 32);

(style) two spaces before "(__u32)" here

> diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
> index 32f43210..2554b2dd 100644
> --- a/lib/ext2fs/initialize.c
> +++ b/lib/ext2fs/initialize.c
> @@ -285,16 +285,18 @@ retry:
>=20
> 	if (ext2fs_has_feature_64bit(super) &&
> 	    (ext2fs_blocks_count(super) / i) > (1ULL << 32))
> -		set_field(s_inodes_count, ~0U);
> +		ext2fs_set_inodes_count(super, ~0U);
> 	else
> -		set_field(s_inodes_count, ext2fs_blocks_count(super) / =
i);
> +		ext2fs_set_inodes_count(super, =
ext2fs_get_inodes_count(param) ?
> +					ext2fs_get_inodes_count(param) :
> +					ext2fs_blocks_count(super) / i);
>=20
> 	/*
> 	 * Make sure we have at least EXT2_FIRST_INO + 1 inodes, so
> 	 * that we have enough inodes for the filesystem(!)
> 	 */
> -	if (super->s_inodes_count < EXT2_FIRST_INODE(super)+1)
> -		super->s_inodes_count =3D EXT2_FIRST_INODE(super)+1;
> +	if (ext2fs_get_inodes_count(super) < EXT2_FIRST_INODE(super)+1)
> +		ext2fs_set_inodes_count(super, =
EXT2_FIRST_INODE(super)+1);

(style) space around those '+'

> @@ -355,9 +358,9 @@ ipg_retry:
> 		ipg--;
> 		goto ipg_retry;
> 	}
> -	super->s_inodes_count =3D super->s_inodes_per_group *
> -		fs->group_desc_count;
> -	super->s_free_inodes_count =3D super->s_inodes_count;
> +	ext2fs_set_inodes_count(super, =
(ext2_ino64_t)super->s_inodes_per_group *
> +		fs->group_desc_count);

(style) align continued line after '(' on previous line

> diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
> index b9d8f557..b7c01005 100644
> --- a/lib/ext2fs/swapfs.c
> +++ b/lib/ext2fs/swapfs.c
> @@ -26,10 +26,12 @@ void ext2fs_swap_super(struct ext2_super_block * =
sb)
> {
>   	int i;
> 	sb->s_inodes_count =3D ext2fs_swab32(sb->s_inodes_count);
> +	sb->s_inodes_count_hi =3D ext2fs_swab32(sb->s_inodes_count_hi);
> 	sb->s_blocks_count =3D ext2fs_swab32(sb->s_blocks_count);
> 	sb->s_r_blocks_count =3D ext2fs_swab32(sb->s_r_blocks_count);
> 	sb->s_free_blocks_count =3D =
ext2fs_swab32(sb->s_free_blocks_count);
> 	sb->s_free_inodes_count =3D =
ext2fs_swab32(sb->s_free_inodes_count);
> +	sb->s_free_inodes_count_hi =3D =
ext2fs_swab32(sb->s_free_inodes_count_hi);
> 	sb->s_first_data_block =3D =
ext2fs_swab32(sb->s_first_data_block);
> 	sb->s_log_block_size =3D ext2fs_swab32(sb->s_log_block_size);
> 	sb->s_log_cluster_size =3D =
ext2fs_swab32(sb->s_log_cluster_size);

(style) this should be consistent with the rest of the function, and =
swab
these new fields in ext2_super_block offset order (i.e. at the end)

> diff --git a/lib/ext2fs/tst_super_size.c b/lib/ext2fs/tst_super_size.c
> index 0adac411..e3dc608a 100644
> --- a/lib/ext2fs/tst_super_size.c
> +++ b/lib/ext2fs/tst_super_size.c
> @@ -142,7 +142,10 @@ int main(int argc, char **argv)
> 	check_field(s_lpf_ino, 4);
> 	check_field(s_prj_quota_inum, 4);
> 	check_field(s_checksum_seed, 4);
> -	check_field(s_reserved, 98 * 4);
> +	check_field(s_inodes_count_hi, 4);
> +	check_field(s_free_inodes_count_hi, 4);
> +	check_field(s_prj_quota_inum_hi, 4);
> +	check_field(s_reserved, 93 * 4);

> 	check_field(s_checksum, 4);
> 	do_field("Superblock end", 0, 0, cur_offset, 1024);

This test should have failed, since 98 - 3 =3D 95, and the superblock
size was no longer 1024 bytes.  You should run "make check" after
every patch in your series to catch problems like this.

> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 1edc0cd1..64102b79 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -2476,10 +2479,14 @@ profile_error:
> 	/*
> 	 * Calculate number of inodes based on the inode ratio
> 	 */
> -	fs_param.s_inodes_count =3D num_inodes ? num_inodes :
> -		(ext2fs_blocks_count(&fs_param) * blocksize) / =
inode_ratio;
> +	if (num_inodes =3D=3D 0)
> +		num_inodes =3D (ext2fs_blocks_count(&fs_param) * =
blocksize) /
> +			inode_ratio;
>=20
> -	if ((((unsigned long long)fs_param.s_inodes_count) *
> +	ext2fs_set_inodes_count(&fs_param, num_inodes);
> +
> +

(style) two empty lines here

Should this set FEATURE_INCOMPAT_INODE64 if num_inodes >=3D 2^32, or is
that handled internally if more than 2^32 inodes are created?  Same
for setting the DIRDATA feature.


I know for block count that we rounded the block count down to 2^32-1
if it was only a little bit higher (e.g. less than 1M inodes over), so
that we didn't introduce an incompatible feature if it wasn't needed.

> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index 44dd41a5..3538ab9c 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -2614,21 +2615,22 @@ static errcode_t =
ext2fs_calculate_summary_stats(ext2_filsys fs)
> 	group =3D 0;
>=20
> 	/* Protect loop from wrap-around if s_inodes_count maxed */
> -	for (ino =3D 1; ino <=3D fs->super->s_inodes_count && ino > 0; =
ino++) {
> +	for (ino =3D 1;
> +	     ino <=3D ext2fs_get_inodes_count(fs->super) && ino > 0; =
ino++) {
> 		if (!ext2fs_fast_test_inode_bitmap2(fs->inode_map, ino)) =
{
> 			group_free++;
> 			total_free++;
> 		}
> 		count++;
> 		if ((count =3D=3D fs->super->s_inodes_per_group) ||
> -		    (ino =3D=3D fs->super->s_inodes_count)) {
> +		    (ino =3D=3D ext2fs_get_inodes_count(fs->super))) {
> 			ext2fs_bg_free_inodes_count_set(fs, group++,
> 							group_free);
> 			count =3D 0;
> 			group_free =3D 0;
> 		}
> 	}
> -	fs->super->s_free_inodes_count =3D total_free;
> +	ext2fs_set_free_inodes_count(fs->super, total_free);
> 	ext2fs_mark_super_dirty(fs);
> 	return 0;
> }

The tune2fs code should check and prevent the INODE64 and DIRDATA =
features
from being cleared if the filesystem has more than 2^32 inodes.


This patch adds support for tools to accept the INODE64 feature, but I =
don't
see anywhere in this patch that adds the 64-bit inode numbers to the =
dirent
using EXT2_DIRENT_INODE64.  That means if these patches landed without =
the
dirent support then e2fsck would probably corrupt the filesystem.  That
means that EXT2_FEATURE_INCOMPAT_INODE64 shouldn't be added to the list =
of
supported features until the rest of the functionality is complete.

Cheers, Andreas






--Apple-Mail=_DABA68EF-9B38-4F10-8C57-84F19F82DD05
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFaE2CSpIg59Q01vtYRAsT4AKCVYzhdTEFQCrOY8UYWYqQAgPjUsgCgxSEn
XBS4PlcRd2QpEpzOjLUG2eI=
=xfar
-----END PGP SIGNATURE-----

--Apple-Mail=_DABA68EF-9B38-4F10-8C57-84F19F82DD05--
