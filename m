From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 12/12] mke2fs: allow metadata blocks to be at the beginning of the file system
Date: Mon, 20 Jan 2014 16:25:23 -0700
Message-ID: <ACF77779-7A44-4ED7-BC49-7658A8DF8514@dilger.ca>
References: <1390197254-14583-1-git-send-email-tytso@mit.edu> <1390197254-14583-13-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/signed; boundary="Apple-Mail=_F449CD88-260C-4ACC-B9E9-652DDE6C9F93"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:56663 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbaATXZ1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Jan 2014 18:25:27 -0500
Received: by mail-pb0-f42.google.com with SMTP id jt11so5531794pbb.29
        for <linux-ext4@vger.kernel.org>; Mon, 20 Jan 2014 15:25:27 -0800 (PST)
In-Reply-To: <1390197254-14583-13-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_F449CD88-260C-4ACC-B9E9-652DDE6C9F93
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 19, 2014, at 10:54 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> Add the extended options packed_meta_blocks and journal_location_front
> which causes mke2fs to place the metadata blocks at the beginning of
> the file system.

The "packed_meta_blocks" appears to be equivalent to setting flex_bg
to some large enough factor that all the block and inode bitmaps are
at the start of the filesystem?  It would probably be better to align
the inode and block bitmaps and inode table on a multiple of
s_raid_stride (will this be used to align on SMR erase blocks?) so
that rewrites are at least somewhat efficient and aligned?  That would
also allow reserving some room in the flex_bg packing to allow for
filesystem resizing.

It would also be useful to allow setting the journal goal block
directly, instead of journal_location_front only allowing to specify
goal =3D=3D 0 (i.e. add "-E journal_start_goal=3DN" instead of adding
"-E journal_location_front", which implied by packed_meta_blocks).
I've wanted to be able to do this for a long time, but the stumbling
block is that write_journal_inode() doesn't have any parameter to
specify the goal journal block without storing it in the superblock.
I suppose it would be possible to pass the journal goal block in
s_jnl_blocks[0..1] or something?

Cheers, Andreas

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> lib/ext2fs/ext2fs.h    |  1 +
> lib/ext2fs/mkjournal.c |  5 +++-
> misc/mke2fs.8.in       | 14 +++++++++++
> misc/mke2fs.c          | 65 =
+++++++++++++++++++++++++++++++++++++++++++++++++-
> misc/mke2fs.conf.5.in  |  4 ++++
> 5 files changed, 87 insertions(+), 2 deletions(-)
>=20
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index efe0964..fed6410 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -204,6 +204,7 @@ typedef struct ext2_file *ext2_file_t;
> #define EXT2_MKJOURNAL_V1_SUPER	0x0000001 /* create V1 =
superblock (deprecated) */
> #define EXT2_MKJOURNAL_LAZYINIT	0x0000002 /* don't zero journal =
inode before use*/
> #define EXT2_MKJOURNAL_NO_MNT_CHECK 0x0000004 /* don't check mount =
status */
> +#define EXT2_MKJOURNAL_LOCATION_FRONT 0x0000004 /* journal at the =
beginning */
>=20
> struct opaque_ext2_group_desc;
>=20
> diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
> index d09c458..aa6d9af 100644
> --- a/lib/ext2fs/mkjournal.c
> +++ b/lib/ext2fs/mkjournal.c
> @@ -360,7 +360,10 @@ static errcode_t write_journal_inode(ext2_filsys =
fs, ext2_ino_t journal_ino,
> 		    ext2fs_bg_free_blocks_count(fs, group))
> 			group =3D i;
>=20
> -	es.goal =3D ext2fs_group_first_block2(fs, group);
> +	if (flags & EXT2_MKJOURNAL_LOCATION_FRONT)
> +		es.goal =3D 0;
> +	else
> +		es.goal =3D ext2fs_group_first_block2(fs, group);
> 	retval =3D ext2fs_block_iterate3(fs, journal_ino, =
BLOCK_FLAG_APPEND,
> 				       0, mkjournal_proc, &es);
> 	if (es.err) {
> diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
> index 483fb1c..9f8c9f6 100644
> --- a/misc/mke2fs.8.in
> +++ b/misc/mke2fs.8.in
> @@ -280,6 +280,20 @@ If the
> file system feature is enabled this option controls whether there will
> be 0, 1, or 2 backup superblocks created in the file system.
> .TP
> +.B packed_meta_blocks\fR[\fB=3D \fI<0 to disable, 1 to enable>\fR]
> +Place the allocation bitmaps and the inode table at the beginning of =
the
> +disk.  This option requires that the flex_bg file system feature to =
be
> +enabled in order for it to have effect, and also implies the
> +extended option
> +.IR journal_location_front .
> +This option is useful for flash devices that use SLC flash at the =
beginning of
> +the disk.   It also maximizes the range of contiguous data blocks, =
which
> +can be useful for certain specialized use cases, such as supported
> +Shingled Drives.
> +.TP
> +.B journal_location_front\fR[\fB=3D \fI<0 to disable, 1 to =
enable>\fR]
> +Place the journal at the beginning of the file system.
> +.TP
> .BI root_owner [=3Duid:gid]
> Specify the numeric user and group ID of the root directory.  If no =
UID:GID
> is specified, use the user and group ID of the user running =
\fBmke2fs\fR.
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index efb068a..363e96b 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -94,6 +94,7 @@ static gid_t	root_gid;
> int	journal_size;
> int	journal_flags;
> static int	lazy_itable_init;
> +static int	packed_meta_blocks;
> static char	*bad_blocks_filename =3D NULL;
> static __u32	fs_stride;
> static int	quotatype =3D -1;  /* Initialize both user and group =
quotas by default */
> @@ -310,6 +311,40 @@ _("Warning: the backup superblock/group =
descriptors at block %u contain\n"
> 	ext2fs_badblocks_list_iterate_end(bb_iter);
> }
>=20
> +static errcode_t packed_allocate_tables(ext2_filsys fs)
> +{
> +	errcode_t	retval;
> +	dgrp_t		i;
> +	blk64_t		goal =3D 0;
> +
> +	for (i =3D 0; i < fs->group_desc_count; i++) {
> +		retval =3D ext2fs_new_block2(fs, goal, NULL, &goal);
> +		if (retval)
> +			return retval;
> +		ext2fs_block_alloc_stats2(fs, goal, +1);
> +		ext2fs_block_bitmap_loc_set(fs, i, goal);
> +	}
> +	for (i =3D 0; i < fs->group_desc_count; i++) {
> +		retval =3D ext2fs_new_block2(fs, goal, NULL, &goal);
> +		if (retval)
> +			return retval;
> +		ext2fs_block_alloc_stats2(fs, goal, +1);
> +		ext2fs_inode_bitmap_loc_set(fs, i, goal);
> +	}
> +	for (i =3D 0; i < fs->group_desc_count; i++) {
> +		blk64_t end =3D ext2fs_blocks_count(fs->super) - 1;
> +		retval =3D ext2fs_get_free_blocks2(fs, goal, end,
> +						 =
fs->inode_blocks_per_group,
> +						 fs->block_map, &goal);
> +		if (retval)
> +			return retval;
> +		ext2fs_block_alloc_stats_range(fs, goal,
> +					       =
fs->inode_blocks_per_group, +1);
> +		ext2fs_inode_table_loc_set(fs, i, goal);
> +	}
> +	return 0;
> +}
> +
> static void write_inode_tables(ext2_filsys fs, int lazy_flag, int =
itable_zeroed)
> {
> 	errcode_t	retval;
> @@ -712,6 +747,14 @@ static void parse_extended_opts(struct =
ext2_super_block *param,
> 				continue;
> 			}
> 			param->s_desc_size =3D desc_size;
> +		} else if (strcmp(token, "journal_location_front") =3D=3D =
0) {
> +			unsigned long front =3D 1;
> +			if (arg)
> +				front =3D strtoul(arg, &p, 0);
> +			if (front)
> +				journal_flags |=3D =
EXT2_MKJOURNAL_LOCATION_FRONT;
> +			else
> +				journal_flags &=3D =
~EXT2_MKJOURNAL_LOCATION_FRONT;
> 		} else if (strcmp(token, "offset") =3D=3D 0) {
> 			if (!arg) {
> 				r_usage++;
> @@ -754,6 +797,15 @@ static void parse_extended_opts(struct =
ext2_super_block *param,
> 				r_usage++;
> 				continue;
> 			}
> +		} else if (strcmp(token, "packed_meta_blocks") =3D=3D 0) =
{
> +			if (arg)
> +				packed_meta_blocks =3D strtoul(arg, &p, =
0);
> +			else
> +				packed_meta_blocks =3D 1;
> +			if (packed_meta_blocks)
> +				journal_flags |=3D =
EXT2_MKJOURNAL_LOCATION_FRONT;
> +			else
> +				journal_flags &=3D =
~EXT2_MKJOURNAL_LOCATION_FRONT;
> 		} else if (strcmp(token, "stride") =3D=3D 0) {
> 			if (!arg) {
> 				r_usage++;
> @@ -915,8 +967,10 @@ static void parse_extended_opts(struct =
ext2_super_block *param,
> 			"\tstripe-width=3D<RAID stride * data disks in =
blocks>\n"
> 			"\toffset=3D<offset to create the file =
system>\n"
> 			"\tresize=3D<resize maximum size in blocks>\n"
> +			"\tpacked_meta_blocks=3D<0 to disable, 1 to =
enable>\n"
> 			"\tlazy_itable_init=3D<0 to disable, 1 to =
enable>\n"
> 			"\tlazy_journal_init=3D<0 to disable, 1 to =
enable>\n"
> +			"\tjournal_location_front=3D<0 to disable, 1 to =
enable>\n"
> 			"\troot_uid=3D<uid of root directory>\n"
> 			"\troot_gid=3D<gid of root directory>\n"
> 			"\ttest_fs\n"
> @@ -2030,6 +2084,11 @@ profile_error:
> 					       EXT2_MKJOURNAL_LAZYINIT : =
0;
> 	journal_flags |=3D EXT2_MKJOURNAL_NO_MNT_CHECK;
>=20
> +	packed_meta_blocks =3D get_bool_from_profile(fs_types,
> +						   "packed_meta_blocks", =
0);
> +	if (packed_meta_blocks)
> +		journal_flags |=3D EXT2_MKJOURNAL_LOCATION_FRONT;
> +
> 	/* Get options from profile */
> 	for (cpp =3D fs_types; *cpp; cpp++) {
> 		tmp =3D NULL;
> @@ -2624,7 +2683,11 @@ int main (int argc, char *argv[])
> 	fs->stride =3D fs_stride =3D fs->super->s_raid_stride;
> 	if (!quiet)
> 		printf("%s", _("Allocating group tables: "));
> -	retval =3D ext2fs_allocate_tables(fs);
> +	if ((fs->super->s_feature_incompat & =
EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
> +	    packed_meta_blocks)
> +		retval =3D packed_allocate_tables(fs);
> +	else
> +		retval =3D ext2fs_allocate_tables(fs);
> 	if (retval) {
> 		com_err(program_name, retval, "%s",
> 			_("while trying to allocate filesystem =
tables"));
> diff --git a/misc/mke2fs.conf.5.in b/misc/mke2fs.conf.5.in
> index 43bb91e..1aba87b 100644
> --- a/misc/mke2fs.conf.5.in
> +++ b/misc/mke2fs.conf.5.in
> @@ -362,6 +362,10 @@ This relation indicates whether file systems with =
the
> .B sparse_super2
> feature enabled should be created with 0, 1, or 2 backup superblocks.
> .TP
> +.I packed_meta_blocks
> +This boolean relation specifes whether the allocation bitmaps, inode
> +table, and journal should be located at the beginning of the file =
system.
> +.TP
> .I inode_ratio
> This relation specifies the default inode ratio if the user does not
> specify one on the command line.
> --=20
> 1.8.5.rc3.362.gdf10213
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_F449CD88-260C-4ACC-B9E9-652DDE6C9F93
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUt2wY3Kl2rkXzB/gAQJF0BAAr92zvK4t2QCGu9LXXmbU7WsUEFRmrKNb
M/0vtWE/+/U3v55nie55yL70VC916QWJcrvoIFr3lfmvJZZQBxzfi8f7W5n/kDJS
SiilqsDbhdRpsIFfblfS0IahlFr97UDxcqAtsdHU+4kLGwCn3McLAcoMvLnkKiuY
4wzmVB/Jzr0b+ufsmKYY9p80WH7CKxMLWbOZxuSxapvXmW+nmZK9xdvcy9hP84Yh
8iw9RxqXKaeoP4YNkclTvlxOOPggU3pyHk5eVkaS4lJul8D6g0tA1UVunHrciYIJ
KCnFDrcTO7+/Hppopjw1ACDNjQ9ZaGSIjNT21LwNSg0DTQOEbugArPdyuuzyiJyj
5GLWyiANnOrvWASHTqMJOYcWdWRs4SY2VV7/sa+yqYVGD7FXl88TjU16jbcBPyAV
qAG/WpajNVaHj+ofBTKJLy/3CFuMTfIobNuOXnaj/RjefI9/Ab/OsA1tijp60Ggw
6eZx7IDDf9aDAuLS1AFJk0afMDMlhcJ9SHeaW54xLks3QSmcYk5Zc/2MflX3bIRG
JVeD3yImI7RL3/rd0Hc2OkEJnZTysfo/p+i/chdDwx5ynLHRBPwg6cSIG9teTILQ
x9/s8RsR9EUG0231BvkJj8MG5GmexURe6f6VNnExl68MY0JeaVY/SQDHNsDe+1CS
VVaGxFgbAQ0=
=/vlR
-----END PGP SIGNATURE-----

--Apple-Mail=_F449CD88-260C-4ACC-B9E9-652DDE6C9F93--
