From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH, RFC] libext2fs: preload block group on request
Date: Fri, 3 Mar 2017 17:45:28 -0700
Message-ID: <85527CC4-DBCB-404E-8267-F87D33E6CCBC@dilger.ca>
References: <34190257-2334-4DA5-90BD-AA0F7167E4C2@dilger.ca>
 <1488532548-17731-1-git-send-email-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_0E363B85-AE29-46AC-9125-F52EA929C0CD";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Alexey Lyashkov <alexey.lyashkov@gmail.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:35609 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdCDApf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Mar 2017 19:45:35 -0500
Received: by mail-it0-f66.google.com with SMTP id 203so4055363ith.2
        for <linux-ext4@vger.kernel.org>; Fri, 03 Mar 2017 16:45:34 -0800 (PST)
In-Reply-To: <1488532548-17731-1-git-send-email-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_0E363B85-AE29-46AC-9125-F52EA929C0CD
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 3, 2017, at 2:15 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> From: Artem Blagodarenko <artem.blagodarenko@seagate.com>
>=20
> I send this for descussion. Requested by Andreas Dilger and Alexey =
Lyashkov.
>=20
>> But again - I may ask an Artem submit a patch to read GD by demand as =
=3D
>> it ready again, but it don=3DE2=3D80=3D99t like it due a complexity.
>=20
>> Sure, it would be good to send it to the list, just to see where =3D
>> complexity is and discuss how it might be fixed.

Artem,
thanks for the patch.  This looks roughly like I expected. Comments =
inline:

> diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
> index ac80849..b171bac 100644
> --- a/lib/ext2fs/blknum.c
> +++ b/lib/ext2fs/blknum.c
> @@ -186,8 +186,51 @@ struct ext2_group_desc =
*ext2fs_group_desc(ext2_filsys fs,
>                                           struct =
opaque_ext2_group_desc *gdp,

It might be a good idea to rename this variable to "gdt" so that it is =
more
clear that this is the pointer to the whole group descriptor table, =
rather
than just a single entry for the group.

> 					  dgrp_t group)
> {
> 	int desc_size =3D EXT2_DESC_SIZE(fs->super) & ~7;
> -
> -	return (struct ext2_group_desc *)((char *)gdp + group * =
desc_size);
> +	struct ext2_group_desc *ret_gdp;
> +	struct ext2_group_desc *tmp_gdp;

> +	char *dest;

> +	dgrp_t block;
> +	blk64_t blk;

(style) these should be declared locally inside "if" block

> +	int retval;
> +	unsigned int i;
> +	unsigned int groups_per_block =3D =
EXT2_DESC_PER_BLOCK(fs->super);
> +

> +	ret_gdp =3D (struct ext2_group_desc *)((char *)gdp + group * =
desc_size);
> +
> +	if ((ret_gdp->bg_flags & EXT2_BG_READ) =3D=3D 0) {

The main problem I see with storing EXT2_BG_READ in the group descriptor
itself it will be written to disk.  It would be equivalent to check the
non-zero status of some or all of the fields, using something like:

	if (memcmp(zero_gdt, ret_gdp, sizeof(*ret_gdp)) !=3D 0) {

> +		block =3D group / groups_per_block;
> +		blk =3D ext2fs_descriptor_block_loc2(fs, =
fs->group_block, block);
> +		dest =3D (char *) gdp + fs->blocksize * block;

(style) no space after typecast

> +		retval =3D io_channel_read_blk64(fs->io, blk, 1, dest);
> +		if (retval)
> +			return NULL;
> +
> +		tmp_gdp =3D (struct ext2_group_desc *)dest;

(style) we could get rid of "dest" and have only "tmp_gdp", and just =
use:

                tmp_gdp =3D (char *)gdp + fs->blocksize * block;
		retval =3D io_channel_read_blk64(fs->io, blk, 1, =
tmp_gdp);

since the argument is "void *data" so no need to cast it.

> +		for (i=3D0; i < groups_per_block; i++) {

(style) spaces around that '=3D'

> +			/*
> +			 * TDB: If recovery is from backup superblock, =
Clear
> +			 * _UNININT flags & reset bg_itable_unused to =
zero

Not sure what "TDB" means, since this is being done below?

> +			 */
> +#ifdef WORDS_BIGENDIAN
> +			ext2fs_swap_group_desc2(fs, tmp_gdp);
> +#endif
> +			tmp_gdp->bg_flags |=3D EXT2_BG_READ;



> +			if (fs->orig_super =3D=3D 0 &&
> +			    EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
> +			    EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {

			     ext2fs_has_group_desc_csum(fs)

> +				ext2fs_bg_flags_clear(fs, block * =
groups_per_block + i, EXT2_BG_BLOCK_UNINIT);

Would be cleaner to calculate "start_group =3D block * blocks_per_group" =
once
at the start.

> +				ext2fs_bg_flags_clear(fs,  block * =
groups_per_block + i, EXT2_BG_INODE_UNINIT);
> +				ext2fs_bg_itable_unused_set(fs,  block * =
groups_per_block + i, 0);

This is nasty, since these are calling ext2fs_group_desc() recursively.
Better to just do this directly in this function:

                                 tmp_gdp->bg_flags &=3D =
~EXT2_BG_BLOCK_UNINIT;
                                 tmp_gdp->bg_flags &=3D =
~EXT2_BG_INODE_UNINIT;

or have some static inline helper functions in blknum.c that take a =
single
gdp pointer argument instead of doing the lookup internally each time:

                                 set_bg_itable_unused(tmp_gdp, =
start_group + i);

> +				// The checksum will be reset later, but =
fix it here
> +				// anyway to avoid printing a lot of =
spurious errors.

No C99 comments.

> +				ext2fs_group_desc_csum_set(fs,  block * =
groups_per_block + i);

When recovering from the backup superblocks this needs the call to:

				if (fs->flags & EXT2_FLAG_RW)
					ext2fs_mark_super_dirty(fs);

> +			}
> +			tmp_gdp =3D (struct ext2_group_desc *)((char =
*)tmp_gdp + EXT2_DESC_SIZE(fs->super));

(style) wrap at 80 columns

> +		}
> +	}
> +	return ret_gdp;
> }
>=20
> /* Do the same but as an ext4 group desc for internal use here */
> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index 27a7d3a..4858684 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -202,6 +202,7 @@ struct ext4_group_desc
> #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not =
initialized */
> #define EXT2_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not initialized =
*/
> #define EXT2_BG_INODE_ZEROED	0x0004 /* On-disk itable initialized to =
zero */
> +#define EXT2_BG_READ		0x0008 /* Block group was read from disk =
*/
>=20
> /*
>  * Data structures used by the directory indexing feature
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 8ff49ca..0ae5cbe 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -221,6 +221,7 @@ struct struct_ext2_filsys {
> 	int				fragsize;
> 	dgrp_t				group_desc_count;
> 	unsigned long			desc_blocks;
> +	blk64_t				group_block;
> 	struct opaque_ext2_group_desc *	group_desc;
> 	unsigned int			inode_blocks_per_group;
> 	ext2fs_inode_bitmap		inode_map;
> diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
> index ba39e01..5f6cda5 100644
> --- a/lib/ext2fs/openfs.c
> +++ b/lib/ext2fs/openfs.c
> @@ -121,11 +121,9 @@ errcode_t ext2fs_open2(const char *name, const =
char *io_options,
> 	blk64_t		group_block, blk;
> 	char		*dest, *cp;
> 	int		group_zero_adjust =3D 0;
> -#ifdef WORDS_BIGENDIAN
> 	unsigned int	groups_per_block;
> 	struct ext2_group_desc *gdp;
> 	int		j;
> -#endif
>=20
> 	EXT2_CHECK_MAGIC(manager, EXT2_ET_MAGIC_IO_MANAGER);
>=20
> @@ -412,40 +410,27 @@ errcode_t ext2fs_open2(const char *name, const =
char *io_options,
> 					     first_meta_bg, dest);
> 		if (retval)
> 			goto cleanup;
> -#ifdef WORDS_BIGENDIAN
> -		gdp =3D (struct ext2_group_desc *) dest;
> 		for (j=3D0; j < groups_per_block*first_meta_bg; j++) {
> 			gdp =3D ext2fs_group_desc(fs, fs->group_desc, =
j);

Isn't this just loading the group descriptor blocks to be read in here?
This should just start the prefetch and nothing else.  We might even try
moving the prefetch to the first call to ext2fs_group_desc() when GDT =
block
#1 is accessed for the first time so that the prefetch isn't started if
the GDT is never accessed.  The drawback is that it could lose time when
the blocks could be prefetched from disk, but I suspect that interval =
would
be very small if the GDT is actually needed so it is probably a net win.
Otherwise, this will read up to 128MB for filesystems without meta_bg.

Possibly always reading in the first GDT block would be good, so that =
the
special reserved inodes are loaded always.

> -			ext2fs_swap_group_desc2(fs, gdp);
> -		}
> -#endif
> -		dest +=3D fs->blocksize*first_meta_bg;
> -	}
> -	for (i=3Dfirst_meta_bg ; i < fs->desc_blocks; i++) {
> -		blk =3D ext2fs_descriptor_block_loc2(fs, group_block, =
i);
> -		retval =3D io_channel_read_blk64(fs->io, blk, 1, dest);
> -		if (retval)
> -			goto cleanup;
> #ifdef WORDS_BIGENDIAN
> -		for (j=3D0; j < groups_per_block; j++) {
> -			gdp =3D ext2fs_group_desc(fs, fs->group_desc,
> -						i * groups_per_block + =
j);
> 			ext2fs_swap_group_desc2(fs, gdp);
> -		}
> #endif
> -		dest +=3D fs->blocksize;
> +			gdp->bg_flags |=3D EXT2_BG_READ;
> +		}
> +		dest +=3D fs->blocksize*first_meta_bg;
> 	}
>=20
> +	fs->group_block =3D group_block;
> 	fs->stride =3D fs->super->s_raid_stride;
>=20
> 	/*
> 	 * If recovery is from backup superblock, Clear _UNININT flags &
> 	 * reset bg_itable_unused to zero
> 	 */
> -	if (superblock > 1 && ext2fs_has_group_desc_csum(fs)) {
> +	if (first_meta_bg && superblock > 1 && =
ext2fs_has_group_desc_csum(fs)) {
> 		dgrp_t group;
>=20
> -		for (group =3D 0; group < fs->group_desc_count; group++) =
{
> +		for (group =3D 0; group < =
groups_per_block*first_meta_bg; group++) {
> 			ext2fs_bg_flags_clear(fs, group, =
EXT2_BG_BLOCK_UNINIT);
> 			ext2fs_bg_flags_clear(fs, group, =
EXT2_BG_INODE_UNINIT);
> 			ext2fs_bg_itable_unused_set(fs, group, 0);

This is already implemented in the ext2fs_group_desc() access, so could =
be
removed here?

Cheers, Andreas






--Apple-Mail=_0E363B85-AE29-46AC-9125-F52EA929C0CD
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFYug4qpIg59Q01vtYRAhTqAJ0VqEaNlU8dgbTQW8p+MyYie23KxQCfcZEM
FYdQ81wn46P1gxtQTavvszI=
=K5E2
-----END PGP SIGNATURE-----

--Apple-Mail=_0E363B85-AE29-46AC-9125-F52EA929C0CD--
