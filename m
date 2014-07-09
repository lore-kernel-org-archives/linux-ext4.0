From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 4/4 v2] lib: add EXT2_ prefix for SUPERBLOCK_{OFFSET,SIZE}
Date: Wed, 9 Jul 2014 14:32:54 -0600
Message-ID: <952214F8-A0E2-4F2C-A749-60C3B5E1109B@dilger.ca>
References: <20140709195844.GD10417@birch.djwong.org> <1404936525-11914-1-git-send-email-a3at.mail@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_A120E454-2580-4004-83EC-8076DBB1FADC"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: darrick.wong@oracle.com, linux-ext4@vger.kernel.org, tytso@mit.edu
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:34308 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaGIUdA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jul 2014 16:33:00 -0400
Received: by mail-pd0-f175.google.com with SMTP id v10so9526539pde.20
        for <linux-ext4@vger.kernel.org>; Wed, 09 Jul 2014 13:32:58 -0700 (PDT)
In-Reply-To: <1404936525-11914-1-git-send-email-a3at.mail@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_A120E454-2580-4004-83EC-8076DBB1FADC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On Jul 9, 2014, at 2:08 PM, Azat Khuzhin <a3at.mail@gmail.com> wrote:

> Since mostly all macros have this prefix, and to avoid potential name
> clashes.
>=20
> Proposed-by: Andreas Dilger <adilger@dilger.ca>
> Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>

You can add:

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

If you are refreshing the whole series, it might make sense to move this
first, instead of adding a bunch of SUPERBLOCK_{SIZE,OFFSET} uses, and
then changing them to EXT2_SUPERBLOCK_{SIZE,OFFSET} in the next patch.
Not a huge deal either way, just a suggestion.

> ---
> v2: don't replcae gfs consts (pattern error, thanks to Darrick J. =
Wong)
>=20
> e2fsck/journal.c           |  2 +-
> e2fsck/super.c             |  4 ++--
> e2fsck/util.c              |  4 ++--
> lib/ext2fs/closefs.c       | 18 +++++++++---------
> lib/ext2fs/dupfs.c         |  8 ++++----
> lib/ext2fs/ext2fs.h        | 10 ++++++++--
> lib/ext2fs/imager.c        |  4 ++--
> lib/ext2fs/initialize.c    |  4 ++--
> lib/ext2fs/mkjournal.c     |  6 +++---
> lib/ext2fs/openfs.c        | 12 ++++++------
> lib/ext2fs/tst_badblocks.c |  4 ++--
> lib/ext2fs/undo_io.c       |  4 ++--
> misc/e2undo.c              |  4 ++--
> misc/mke2fs.c              |  4 ++--
> misc/tune2fs.c             | 12 ++++++------
> 15 files changed, 53 insertions(+), 47 deletions(-)
>=20
> diff --git a/e2fsck/journal.c b/e2fsck/journal.c
> index 6df0165..785d283 100644
> --- a/e2fsck/journal.c
> +++ b/e2fsck/journal.c
> @@ -454,7 +454,7 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, =
journal_t **ret_journal)
> 			brelse(bh);
> 			goto errout;
> 		}
> -		memcpy(&jsuper, start ? bh->b_data :  bh->b_data + =
SUPERBLOCK_OFFSET,
> +		memcpy(&jsuper, start ? bh->b_data :  bh->b_data + =
EXT2_SUPERBLOCK_OFFSET,
> 		       sizeof(jsuper));
> 		brelse(bh);
> #ifdef WORDS_BIGENDIAN
> diff --git a/e2fsck/super.c b/e2fsck/super.c
> index c8669f8..d58a789 100644
> --- a/e2fsck/super.c
> +++ b/e2fsck/super.c
> @@ -921,7 +921,7 @@ int check_backup_super_block(e2fsck_t ctx)
> 	dgrp_t		g;
> 	blk64_t		sb;
> 	int		ret =3D 0;
> -	char		buf[SUPERBLOCK_SIZE];
> +	char		buf[EXT2_SUPERBLOCK_SIZE];
> 	struct ext2_super_block	*backup_sb;
>=20
> 	/*
> @@ -944,7 +944,7 @@ int check_backup_super_block(e2fsck_t ctx)
>=20
> 		sb =3D ext2fs_group_first_block2(fs, g);
>=20
> -		retval =3D io_channel_read_blk(fs->io, sb, =
-SUPERBLOCK_SIZE,
> +		retval =3D io_channel_read_blk(fs->io, sb, =
-EXT2_SUPERBLOCK_SIZE,
> 					     buf);
> 		if (retval)
> 			continue;
> diff --git a/e2fsck/util.c b/e2fsck/util.c
> index fec6179..75e11de 100644
> --- a/e2fsck/util.c
> +++ b/e2fsck/util.c
> @@ -540,7 +540,7 @@ blk64_t get_backup_sb(e2fsck_t ctx, ext2_filsys =
fs, const char *name,
> 	if (manager->open(name, 0, &io) !=3D 0)
> 		goto cleanup;
>=20
> -	if (ext2fs_get_mem(SUPERBLOCK_SIZE, &buf))
> +	if (ext2fs_get_mem(EXT2_SUPERBLOCK_SIZE, &buf))
> 		goto cleanup;
> 	sb =3D (struct ext2_super_block *) buf;
>=20
> @@ -551,7 +551,7 @@ blk64_t get_backup_sb(e2fsck_t ctx, ext2_filsys =
fs, const char *name,
> 			superblock++;
> 		io_channel_set_blksize(io, blocksize);
> 		if (io_channel_read_blk64(io, superblock,
> -					-SUPERBLOCK_SIZE, buf))
> +					-EXT2_SUPERBLOCK_SIZE, buf))
> 			continue;
> #ifdef WORDS_BIGENDIAN
> 		if (sb->s_magic =3D=3D ext2fs_swab16(EXT2_SUPER_MAGIC))
> diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
> index c2eaec1..5223400 100644
> --- a/lib/ext2fs/closefs.c
> +++ b/lib/ext2fs/closefs.c
> @@ -199,8 +199,8 @@ static errcode_t =
write_primary_superblock(ext2_filsys fs,
>=20
> 	if (!fs->io->manager->write_byte || !fs->orig_super) {
> 	fallback:
> -		io_channel_set_blksize(fs->io, SUPERBLOCK_OFFSET);
> -		retval =3D io_channel_write_blk64(fs->io, 1, =
-SUPERBLOCK_SIZE,
> +		io_channel_set_blksize(fs->io, EXT2_SUPERBLOCK_OFFSET);
> +		retval =3D io_channel_write_blk64(fs->io, 1, =
-EXT2_SUPERBLOCK_SIZE,
> 					      super);
> 		io_channel_set_blksize(fs->io, fs->blocksize);
> 		return retval;
> @@ -209,11 +209,11 @@ static errcode_t =
write_primary_superblock(ext2_filsys fs,
> 	old_super =3D (__u16 *) fs->orig_super;
> 	new_super =3D (__u16 *) super;
>=20
> -	for (check_idx =3D 0; check_idx < SUPERBLOCK_SIZE/2; =
check_idx++) {
> +	for (check_idx =3D 0; check_idx < EXT2_SUPERBLOCK_SIZE/2; =
check_idx++) {
> 		if (old_super[check_idx] =3D=3D new_super[check_idx])
> 			continue;
> 		write_idx =3D check_idx;
> -		for (check_idx++; check_idx < SUPERBLOCK_SIZE/2; =
check_idx++)
> +		for (check_idx++; check_idx < EXT2_SUPERBLOCK_SIZE/2; =
check_idx++)
> 			if (old_super[check_idx] =3D=3D =
new_super[check_idx])
> 				break;
> 		size =3D 2 * (check_idx - write_idx);
> @@ -222,14 +222,14 @@ static errcode_t =
write_primary_superblock(ext2_filsys fs,
> 		       size, write_idx*2);
> #endif
> 		retval =3D io_channel_write_byte(fs->io,
> -			       SUPERBLOCK_OFFSET + (2 * write_idx), =
size,
> +			       EXT2_SUPERBLOCK_OFFSET + (2 * write_idx), =
size,
> 					       new_super + write_idx);
> 		if (retval =3D=3D EXT2_ET_UNIMPLEMENTED)
> 			goto fallback;
> 		if (retval)
> 			return retval;
> 	}
> -	memcpy(fs->orig_super, super, SUPERBLOCK_SIZE);
> +	memcpy(fs->orig_super, super, EXT2_SUPERBLOCK_SIZE);
> 	return 0;
> }
>=20
> @@ -269,7 +269,7 @@ static errcode_t write_backup_super(ext2_filsys =
fs, dgrp_t group,
> 	if (retval)
> 		return retval;
>=20
> -	return io_channel_write_blk64(fs->io, group_block, =
-SUPERBLOCK_SIZE,
> +	return io_channel_write_blk64(fs->io, group_block, =
-EXT2_SUPERBLOCK_SIZE,
> 				    super_shadow);
> }
>=20
> @@ -320,7 +320,7 @@ errcode_t ext2fs_flush2(ext2_filsys fs, int flags)
> 	/* Prepare the group descriptors for writing */
> #ifdef WORDS_BIGENDIAN
> 	retval =3D EXT2_ET_NO_MEMORY;
> -	retval =3D ext2fs_get_mem(SUPERBLOCK_SIZE, &super_shadow);
> +	retval =3D ext2fs_get_mem(EXT2_SUPERBLOCK_SIZE, &super_shadow);
> 	if (retval)
> 		goto errout;
> 	retval =3D ext2fs_get_array(fs->desc_blocks, fs->blocksize,
> @@ -412,7 +412,7 @@ write_primary_superblock_only:
> 	/*
> 	 * Write out master superblock.  This has to be done
> 	 * separately, since it is located at a fixed location
> -	 * (SUPERBLOCK_OFFSET).  We flush all other pending changes
> +	 * (EXT2_SUPERBLOCK_OFFSET).  We flush all other pending changes
> 	 * out to disk first, just to avoid a race condition with an
> 	 * insy-tinsy window....
> 	 */
> diff --git a/lib/ext2fs/dupfs.c b/lib/ext2fs/dupfs.c
> index 02721e1..6840b12 100644
> --- a/lib/ext2fs/dupfs.c
> +++ b/lib/ext2fs/dupfs.c
> @@ -53,15 +53,15 @@ errcode_t ext2fs_dup_handle(ext2_filsys src, =
ext2_filsys *dest)
> 		goto errout;
> 	strcpy(fs->device_name, src->device_name);
>=20
> -	retval =3D ext2fs_get_mem(SUPERBLOCK_SIZE, &fs->super);
> +	retval =3D ext2fs_get_mem(EXT2_SUPERBLOCK_SIZE, &fs->super);
> 	if (retval)
> 		goto errout;
> -	memcpy(fs->super, src->super, SUPERBLOCK_SIZE);
> +	memcpy(fs->super, src->super, EXT2_SUPERBLOCK_SIZE);
>=20
> -	retval =3D ext2fs_get_mem(SUPERBLOCK_SIZE, &fs->orig_super);
> +	retval =3D ext2fs_get_mem(EXT2_SUPERBLOCK_SIZE, =
&fs->orig_super);
> 	if (retval)
> 		goto errout;
> -	memcpy(fs->orig_super, src->orig_super, SUPERBLOCK_SIZE);
> +	memcpy(fs->orig_super, src->orig_super, EXT2_SUPERBLOCK_SIZE);
>=20
> 	retval =3D ext2fs_get_array(fs->desc_blocks, fs->blocksize,
> 				&fs->group_desc);
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index a759741..1a96f24 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -36,8 +36,14 @@ extern "C" {
>  * (some versions have the padding set up so that the superblock is
>  * 1032 bytes long).
>  */
> -#define SUPERBLOCK_OFFSET	1024
> -#define SUPERBLOCK_SIZE		1024
> +#define EXT2_SUPERBLOCK_OFFSET	1024
> +#define EXT2_SUPERBLOCK_SIZE		1024
> +/**
> + * Deprecated, will be removed in the next release
> + * Instead use EXT2_* with the same names.
> + */
> +#define SUPERBLOCK_OFFSET EXT2_SUPERBLOCK_OFFSET
> +#define SUPERBLOCK_SIZE EXT2_SUPERBLOCK_SIZE
>=20
> /*
>  * The last ext2fs revision level that this version of the library is
> diff --git a/lib/ext2fs/imager.c b/lib/ext2fs/imager.c
> index 378a3c8..92f6db9 100644
> --- a/lib/ext2fs/imager.c
> +++ b/lib/ext2fs/imager.c
> @@ -203,7 +203,7 @@ errcode_t ext2fs_image_super_write(ext2_filsys fs, =
int fd,
> 	 * Write out the superblock
> 	 */
> 	memset(buf, 0, fs->blocksize);
> -	memcpy(buf, fs->super, SUPERBLOCK_SIZE);
> +	memcpy(buf, fs->super, EXT2_SUPERBLOCK_SIZE);
> 	actual =3D write(fd, buf, fs->blocksize);
> 	if (actual =3D=3D -1) {
> 		retval =3D errno;
> @@ -266,7 +266,7 @@ errcode_t ext2fs_image_super_read(ext2_filsys fs, =
int fd,
> 	/*
> 	 * Now copy in the superblock and group descriptors
> 	 */
> -	memcpy(fs->super, buf, SUPERBLOCK_SIZE);
> +	memcpy(fs->super, buf, EXT2_SUPERBLOCK_SIZE);
>=20
> 	memcpy(fs->group_desc, buf + fs->blocksize,
> 	       fs->blocksize * fs->group_desc_count);
> diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
> index 75fbf8e..f1a6f55 100644
> --- a/lib/ext2fs/initialize.c
> +++ b/lib/ext2fs/initialize.c
> @@ -133,12 +133,12 @@ errcode_t ext2fs_initialize(const char *name, =
int flags,
> 		goto cleanup;
>=20
> 	strcpy(fs->device_name, name);
> -	retval =3D ext2fs_get_mem(SUPERBLOCK_SIZE, &super);
> +	retval =3D ext2fs_get_mem(EXT2_SUPERBLOCK_SIZE, &super);
> 	if (retval)
> 		goto cleanup;
> 	fs->super =3D super;
>=20
> -	memset(super, 0, SUPERBLOCK_SIZE);
> +	memset(super, 0, EXT2_SUPERBLOCK_SIZE);
>=20
> #define set_field(field, default) (super->field =3D param->field ? \
> 				   param->field : (default))
> diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
> index 0ad674d..ae5cd56 100644
> --- a/lib/ext2fs/mkjournal.c
> +++ b/lib/ext2fs/mkjournal.c
> @@ -441,7 +441,7 @@ errcode_t ext2fs_add_journal_device(ext2_filsys =
fs, ext2_filsys journal_dev)
> {
> 	struct stat	st;
> 	errcode_t	retval;
> -	char		buf[SUPERBLOCK_SIZE];
> +	char		buf[EXT2_SUPERBLOCK_SIZE];
> 	journal_superblock_t	*jsb;
> 	int		start;
> 	__u32		i, nr_users;
> @@ -456,7 +456,7 @@ errcode_t ext2fs_add_journal_device(ext2_filsys =
fs, ext2_filsys journal_dev)
> 	/* Get the journal superblock */
> 	start =3D ext2fs_journal_sb_start(journal_dev->blocksize);
> 	if ((retval =3D io_channel_read_blk64(journal_dev->io, start,
> -					    -SUPERBLOCK_SIZE,
> +					    -EXT2_SUPERBLOCK_SIZE,
> 					    buf)))
> 		return retval;
>=20
> @@ -483,7 +483,7 @@ errcode_t ext2fs_add_journal_device(ext2_filsys =
fs, ext2_filsys journal_dev)
>=20
> 	/* Writeback the journal superblock */
> 	if ((retval =3D io_channel_write_blk64(journal_dev->io, start,
> -					    -SUPERBLOCK_SIZE, buf)))
> +					    -EXT2_SUPERBLOCK_SIZE, =
buf)))
> 		return retval;
>=20
> 	fs->super->s_journal_inum =3D 0;
> diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
> index b4122de..6055a86 100644
> --- a/lib/ext2fs/openfs.c
> +++ b/lib/ext2fs/openfs.c
> @@ -164,7 +164,7 @@ errcode_t ext2fs_open2(const char *name, const =
char *io_options,
> 		goto cleanup;
> 	fs->image_io =3D fs->io;
> 	fs->io->app_data =3D fs;
> -	retval =3D io_channel_alloc_buf(fs->io, -SUPERBLOCK_SIZE, =
&fs->super);
> +	retval =3D io_channel_alloc_buf(fs->io, -EXT2_SUPERBLOCK_SIZE, =
&fs->super);
> 	if (retval)
> 		goto cleanup;
> 	if (flags & EXT2_FLAG_IMAGE_FILE) {
> @@ -187,7 +187,7 @@ errcode_t ext2fs_open2(const char *name, const =
char *io_options,
> 	 * If the user specifies a specific block # for the
> 	 * superblock, then he/she must also specify the block size!
> 	 * Otherwise, read the master superblock located at offset
> -	 * SUPERBLOCK_OFFSET from the start of the partition.
> +	 * EXT2_SUPERBLOCK_OFFSET from the start of the partition.
> 	 *
> 	 * Note: we only save a backup copy of the superblock if we
> 	 * are reading the superblock from the primary superblock =
location.
> @@ -201,19 +201,19 @@ errcode_t ext2fs_open2(const char *name, const =
char *io_options,
> 		group_block =3D superblock;
> 		fs->orig_super =3D 0;
> 	} else {
> -		io_channel_set_blksize(fs->io, SUPERBLOCK_OFFSET);
> +		io_channel_set_blksize(fs->io, EXT2_SUPERBLOCK_OFFSET);
> 		superblock =3D 1;
> 		group_block =3D 0;
> -		retval =3D ext2fs_get_mem(SUPERBLOCK_SIZE, =
&fs->orig_super);
> +		retval =3D ext2fs_get_mem(EXT2_SUPERBLOCK_SIZE, =
&fs->orig_super);
> 		if (retval)
> 			goto cleanup;
> 	}
> -	retval =3D io_channel_read_blk(fs->io, superblock, =
-SUPERBLOCK_SIZE,
> +	retval =3D io_channel_read_blk(fs->io, superblock, =
-EXT2_SUPERBLOCK_SIZE,
> 				     fs->super);
> 	if (retval)
> 		goto cleanup;
> 	if (fs->orig_super)
> -		memcpy(fs->orig_super, fs->super, SUPERBLOCK_SIZE);
> +		memcpy(fs->orig_super, fs->super, EXT2_SUPERBLOCK_SIZE);
>=20
> 	if (!(fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS)) {
> 		retval =3D 0;
> diff --git a/lib/ext2fs/tst_badblocks.c b/lib/ext2fs/tst_badblocks.c
> index 3b39ef1..85d63fb 100644
> --- a/lib/ext2fs/tst_badblocks.c
> +++ b/lib/ext2fs/tst_badblocks.c
> @@ -225,8 +225,8 @@ int file_test_invalid(badblocks_list bb)
> 	fs =3D malloc(sizeof(struct struct_ext2_filsys));
> 	memset(fs, 0, sizeof(struct struct_ext2_filsys));
> 	fs->magic =3D EXT2_ET_MAGIC_EXT2FS_FILSYS;
> -	fs->super =3D malloc(SUPERBLOCK_SIZE);
> -	memset(fs->super, 0, SUPERBLOCK_SIZE);
> +	fs->super =3D malloc(EXT2_SUPERBLOCK_SIZE);
> +	memset(fs->super, 0, EXT2_SUPERBLOCK_SIZE);
> 	fs->super->s_first_data_block =3D 1;
> 	ext2fs_blocks_count_set(fs->super, 100);
>=20
> diff --git a/lib/ext2fs/undo_io.c b/lib/ext2fs/undo_io.c
> index 0e05c93..c498b2a 100644
> --- a/lib/ext2fs/undo_io.c
> +++ b/lib/ext2fs/undo_io.c
> @@ -113,8 +113,8 @@ static errcode_t =
write_file_system_identity(io_channel undo_channel,
> 	channel =3D data->real;
> 	block_size =3D channel->block_size;
>=20
> -	io_channel_set_blksize(channel, SUPERBLOCK_OFFSET);
> -	retval =3D io_channel_read_blk64(channel, 1, -SUPERBLOCK_SIZE, =
&super);
> +	io_channel_set_blksize(channel, EXT2_SUPERBLOCK_OFFSET);
> +	retval =3D io_channel_read_blk64(channel, 1, =
-EXT2_SUPERBLOCK_SIZE, &super);
> 	if (retval)
> 		goto err_out;
>=20
> diff --git a/misc/e2undo.c b/misc/e2undo.c
> index a43c26f..cc8fa77 100644
> --- a/misc/e2undo.c
> +++ b/misc/e2undo.c
> @@ -45,8 +45,8 @@ static int check_filesystem(TDB_CONTEXT *tdb, =
io_channel channel)
> 	TDB_DATA tdb_key, tdb_data;
> 	struct ext2_super_block super;
>=20
> -	io_channel_set_blksize(channel, SUPERBLOCK_OFFSET);
> -	retval =3D io_channel_read_blk64(channel, 1, -SUPERBLOCK_SIZE, =
&super);
> +	io_channel_set_blksize(channel, EXT2_SUPERBLOCK_OFFSET);
> +	retval =3D io_channel_read_blk64(channel, 1, =
-EXT2_SUPERBLOCK_SIZE, &super);
> 	if (retval) {
> 		com_err(prg_name, retval,
> 			"%s", _("Failed to read the file system data =
\n"));
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index b451cc3..df5b9d8 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -2398,8 +2398,8 @@ static int should_do_undo(const char *name)
> 		goto open_err_out;
> 	}
>=20
> -	io_channel_set_blksize(channel, SUPERBLOCK_OFFSET);
> -	retval =3D io_channel_read_blk64(channel, 1, -SUPERBLOCK_SIZE, =
&super);
> +	io_channel_set_blksize(channel, EXT2_SUPERBLOCK_OFFSET);
> +	retval =3D io_channel_read_blk64(channel, 1, =
-EXT2_SUPERBLOCK_SIZE, &super);
> 	if (retval) {
> 		retval =3D 0;
> 		goto err_out;
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index 898a1b3..d1fa6ba 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -183,7 +183,7 @@ static __u32 clear_ok_features[3] =3D {
> /**
>  * Try to get journal super block if any
>  */
> -static int get_journal_sb(ext2_filsys jfs, char buf[SUPERBLOCK_SIZE])
> +static int get_journal_sb(ext2_filsys jfs, char =
buf[EXT2_SUPERBLOCK_SIZE])
> {
> 	int retval;
> 	int start;
> @@ -196,7 +196,7 @@ static int get_journal_sb(ext2_filsys jfs, char =
buf[SUPERBLOCK_SIZE])
>=20
> 	/* Get the journal superblock */
> 	if ((retval =3D io_channel_read_blk64(jfs->io,
> -	    ext2fs_journal_sb_start(jfs->blocksize), -SUPERBLOCK_SIZE, =
buf))) {
> +	    ext2fs_journal_sb_start(jfs->blocksize), =
-EXT2_SUPERBLOCK_SIZE, buf))) {
> 		com_err(program_name, retval, "%s",
> 		_("while reading journal superblock"));
> 		return retval;
> @@ -219,7 +219,7 @@ static int remove_journal_device(ext2_filsys fs)
> {
> 	char		*journal_path;
> 	ext2_filsys	jfs;
> -	char		buf[SUPERBLOCK_SIZE];
> +	char		buf[EXT2_SUPERBLOCK_SIZE];
> 	journal_superblock_t	*jsb;
> 	int		i, nr_users;
> 	errcode_t	retval;
> @@ -283,7 +283,7 @@ static int remove_journal_device(ext2_filsys fs)
>=20
> 	/* Write back the journal superblock */
> 	if ((retval =3D io_channel_write_blk64(jfs->io, start,
> -	    -SUPERBLOCK_SIZE, buf))) {
> +	    -EXT2_SUPERBLOCK_SIZE, buf))) {
> 		com_err(program_name, retval,
> 			"while writing journal superblock.");
> 		goto no_valid_journal;
> @@ -2713,7 +2713,7 @@ retry_open:
> 	if (U_flag) {
> 		int set_csum =3D 0;
> 		dgrp_t i;
> -		char buf[SUPERBLOCK_SIZE];
> +		char buf[EXT2_SUPERBLOCK_SIZE];
>=20
> 		if (ext2fs_has_group_desc_csum(fs)) {
> 			/*
> @@ -2771,7 +2771,7 @@ retry_open:
> 			/* Writeback the journal superblock */
> 			if ((rc =3D io_channel_write_blk64(fs->io,
> 				ext2fs_journal_sb_start(fs->blocksize),
> -					-SUPERBLOCK_SIZE, buf)))
> +					-EXT2_SUPERBLOCK_SIZE, buf)))
> 				goto closefs;
> 		} else if (rc !=3D EXT2_ET_UNSUPP_FEATURE)
> 			goto closefs;
> --=20
> 2.0.0
>=20


Cheers, Andreas






--Apple-Mail=_A120E454-2580-4004-83EC-8076DBB1FADC
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU72m9nKl2rkXzB/gAQIBGQ/+Os63edAncYzhs3g111cqIXhmD+H6/xTD
C+ijumNT8o28g8XXduowVLllIc1VOQzi6LwzQUxcq6MKOTxOI2sAKubKuVhQE9gH
jt6D+LtBDZ7uWc+LriscMDge4eYBX7YOtTJPDi2nJ/md60PuoV5XKH9zS5GKbtP4
YRZ0QC5Iy4DS/PHnWh9aD2XhkyPPc2c10naI5yIhv+nPknyqyp0T+JvJLr5ehaKY
6Bdg0Bvo6rCpHdb7iAzNBGeepWtC9XPStsw0SDjmp9RBCzrrh4aw+lK7daqNVc8Q
Ap144HGgxhTPYbS80OOtZMIuMpujr7KDsQMgGql4UFswuQ9hNn9GPfnLgsdQVHGX
DlWWF0ZftkGbLO3YJH+Nhg5mOujmoXE7PeHys3Oa/HCqS3fogXGWjRWNK21SS41p
UHpm8urPhOUB/argTHREvnoVYcts+lxuseEU/LuxVyPBYGYh0qmECG8GfT+jbL0A
FeHyEcyrLrx6dT6kW5B+UHJCL1LeWZX4LxCqA5j/1AqvEYQk+B5eNG4EPN+ty/Um
wkjzMvz/rGZrbi12I2JDabW7mVRCmp7xmGZlp5gaI0GFutS0Jv+3iMBHE23q881K
SlG/65hnh46tvJnaEP0xRyP+7uiOcQujYolWATyGVntrC4TfIyoFYcVQFd5xJrHB
Arz5D9BdjGE=
=ff8H
-----END PGP SIGNATURE-----

--Apple-Mail=_A120E454-2580-4004-83EC-8076DBB1FADC--
