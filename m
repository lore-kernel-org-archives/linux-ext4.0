Return-Path: <SRS0=jZge=PK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46178 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbfABS2x (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jan 2019 13:28:53 -0500
Received: by mail-pl1-f193.google.com with SMTP id t13so14808261ply.13
        for <linux-ext4@vger.kernel.org>; Wed, 02 Jan 2019 10:28:52 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <EB192C32-65C7-4D4E-8399-570F1DC354E5@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_7CC095CE-C2DE-400E-BE02-EAEB2EF4442A";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v6 4/4] ext2fs: automaticlly open backup superblocks
Date: Wed, 2 Jan 2019 11:28:49 -0700
In-Reply-To: <20190101210737.87248-5-c17828@cray.com>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
References: <20190101210737.87248-1-c17828@cray.com>
 <20190101210737.87248-5-c17828@cray.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_7CC095CE-C2DE-400E-BE02-EAEB2EF4442A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 1, 2019, at 2:07 PM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> e2image and e2fsck automatically try to open some backup superblocks,
> if only blocksize is set or passed superblock can't be opened.
> Try few backup superblocks (e.g. {1, 3, 5, 7, 9} * blocksize * 8).
>=20
> This code is moved to lib/support/.
>=20
> Signed-off-by: Artem Blagodarenko <c17828@cray.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> e2fsck/e2fsck.h         |   2 -
> e2fsck/message.c        |   3 +-
> e2fsck/unix.c           |  14 +++--
> e2fsck/util.c           |  73 -------------------------
> lib/support/Makefile.in |   8 ++-
> lib/support/sb_backup.c | 140 =
++++++++++++++++++++++++++++++++++++++++++++++++
> lib/support/sb_backup.h |  20 +++++++
> misc/e2image.c          |   7 +++
> 8 files changed, 185 insertions(+), 82 deletions(-)
>=20
> diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
> index 1c7a67cb..8576ef24 100644
> --- a/e2fsck/e2fsck.h
> +++ b/e2fsck/e2fsck.h
> @@ -633,8 +633,6 @@ extern void e2fsck_write_inode_full(e2fsck_t ctx, =
unsigned long ino,
> #ifdef MTRACE
> extern void mtrace_print(char *mesg);
> #endif
> -extern blk64_t get_backup_sb(e2fsck_t ctx, ext2_filsys fs,
> -			   const char *name, io_manager manager);
> extern int ext2_file_type(unsigned int mode);
> extern int write_all(int fd, char *buf, size_t count);
> void dump_mmp_msg(struct mmp_struct *mmp, const char *fmt, ...)
> diff --git a/e2fsck/message.c b/e2fsck/message.c
> index 727f71d5..ffb40730 100644
> --- a/e2fsck/message.c
> +++ b/e2fsck/message.c
> @@ -465,7 +465,8 @@ static _INLINE_ void =
expand_percent_expression(FILE *f, ext2_filsys fs,
> 		fprintf(f, "%*lld", width, (long long) ctx->blkcount);
> 		break;
> 	case 'S':
> -		fprintf(f, "%llu", get_backup_sb(NULL, fs, NULL, NULL));
> +		fprintf(f, "%llu", get_first_backup_sb(NULL, NULL, fs,
> +						       NULL, NULL));
> 		break;
> 	case 's':
> 		fprintf(f, "%*s", width, ctx->str ? ctx->str : "NULL");
> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> index ddcf52a4..4ffc039e 100644
> --- a/e2fsck/unix.c
> +++ b/e2fsck/unix.c
> @@ -1489,11 +1489,17 @@ restart:
> 				retval ? _("Superblock invalid,") :
> 				_("Group descriptors look bad..."));
> 			orig_superblock =3D ctx->superblock;
> -			get_backup_sb(ctx, fs, ctx->filesystem_name, =
io_ptr);
> -			if (fs)
> -				ext2fs_close_free(&fs);
> 			orig_retval =3D retval;
> -			retval =3D try_open_fs(ctx, flags, io_ptr, &fs);
> +			retval =3D try_backups(ctx->filesystem_name,
> +					     ctx->io_options,
> +					     flags, &ctx->superblock,
> +					     &ctx->blocksize, io_ptr, =
&fs);
> +			if (retval =3D=3D 0) {
> +				fs->priv_data =3D ctx;
> +				e2fsck_set_bitmap_type(fs,
> +						       =
EXT2FS_BMAP64_RBTREE,
> +						       "default", NULL);
> +			}
> 			if ((orig_retval =3D=3D 0) && retval !=3D 0) {
> 				if (fs)
> 					ext2fs_close_free(&fs);
> diff --git a/e2fsck/util.c b/e2fsck/util.c
> index db6a1cc1..e2caf3a2 100644
> --- a/e2fsck/util.c
> +++ b/e2fsck/util.c
> @@ -549,79 +549,6 @@ void mtrace_print(char *mesg)
> }
> #endif
>=20
> -blk64_t get_backup_sb(e2fsck_t ctx, ext2_filsys fs, const char *name,
> -		      io_manager manager)
> -{
> -	struct ext2_super_block *sb;
> -	io_channel		io =3D NULL;
> -	void			*buf =3D NULL;
> -	int			blocksize;
> -	blk64_t			superblock, ret_sb =3D 8193;
> -
> -	if (fs && fs->super) {
> -		ret_sb =3D (fs->super->s_blocks_per_group +
> -			  fs->super->s_first_data_block);
> -		if (ctx) {
> -			ctx->superblock =3D ret_sb;
> -			ctx->blocksize =3D fs->blocksize;
> -		}
> -		return ret_sb;
> -	}
> -
> -	if (ctx) {
> -		if (ctx->blocksize) {
> -			ret_sb =3D ctx->blocksize * 8;
> -			if (ctx->blocksize =3D=3D 1024)
> -				ret_sb++;
> -			ctx->superblock =3D ret_sb;
> -			return ret_sb;
> -		}
> -		ctx->superblock =3D ret_sb;
> -		ctx->blocksize =3D 1024;
> -	}
> -
> -	if (!name || !manager)
> -		goto cleanup;
> -
> -	if (manager->open(name, 0, &io) !=3D 0)
> -		goto cleanup;
> -
> -	if (ext2fs_get_mem(SUPERBLOCK_SIZE, &buf))
> -		goto cleanup;
> -	sb =3D (struct ext2_super_block *) buf;
> -
> -	for (blocksize =3D EXT2_MIN_BLOCK_SIZE;
> -	     blocksize <=3D EXT2_MAX_BLOCK_SIZE ; blocksize *=3D 2) {
> -		superblock =3D blocksize*8;
> -		if (blocksize =3D=3D 1024)
> -			superblock++;
> -		io_channel_set_blksize(io, blocksize);
> -		if (io_channel_read_blk64(io, superblock,
> -					-SUPERBLOCK_SIZE, buf))
> -			continue;
> -#ifdef WORDS_BIGENDIAN
> -		if (sb->s_magic =3D=3D ext2fs_swab16(EXT2_SUPER_MAGIC))
> -			ext2fs_swap_super(sb);
> -#endif
> -		if ((sb->s_magic =3D=3D EXT2_SUPER_MAGIC) &&
> -		    (EXT2_BLOCK_SIZE(sb) =3D=3D blocksize)) {
> -			ret_sb =3D superblock;
> -			if (ctx) {
> -				ctx->superblock =3D superblock;
> -				ctx->blocksize =3D blocksize;
> -			}
> -			break;
> -		}
> -	}
> -
> -cleanup:
> -	if (io)
> -		io_channel_close(io);
> -	if (buf)
> -		ext2fs_free_mem(&buf);
> -	return (ret_sb);
> -}
> -
> /*
>  * Given a mode, return the ext2 file type
>  */
> diff --git a/lib/support/Makefile.in b/lib/support/Makefile.in
> index 1d278642..03fdf555 100644
> --- a/lib/support/Makefile.in
> +++ b/lib/support/Makefile.in
> @@ -22,7 +22,8 @@ OBJS=3D		cstring.o \
> 		quotaio.o \
> 		quotaio_v2.o \
> 		quotaio_tree.o \
> -		dict.o
> +		dict.o \
> +		sb_backup.o
>=20
> SRCS=3D		$(srcdir)/argv_parse.c \
> 		$(srcdir)/cstring.c \
> @@ -35,7 +36,8 @@ SRCS=3D		$(srcdir)/argv_parse.c \
> 		$(srcdir)/quotaio.c \
> 		$(srcdir)/quotaio_tree.c \
> 		$(srcdir)/quotaio_v2.c \
> -		$(srcdir)/dict.c
> +		$(srcdir)/dict.c \
> +		$(srcdir)/sb_backup.c
>=20
> LIBRARY=3D libsupport
> LIBDIR=3D support
> @@ -168,3 +170,5 @@ quotaio_v2.o: $(srcdir)/quotaio_v2.c =
$(top_builddir)/lib/config.h \
>  $(srcdir)/quotaio_tree.h
> dict.o: $(srcdir)/dict.c $(top_builddir)/lib/config.h \
>  $(top_builddir)/lib/dirpaths.h $(srcdir)/dict.h
> +sb_backup.o: $(srcdir)/sb_backup.c $(top_builddir)/lib/config.h \
> + $(srcdir)/sb_backup.h
> diff --git a/lib/support/sb_backup.c b/lib/support/sb_backup.c
> new file mode 100644
> index 00000000..cfa671e5
> --- /dev/null
> +++ b/lib/support/sb_backup.c
> @@ -0,0 +1,140 @@
> +/*
> + * sb_backup.c -- helper functions for getting backup superblocks
> + *
> + * %Begin-Header%
> + * This file may be redistributed under the terms of the GNU Library
> + * General Public License, version 2.
> + * %End-Header%
> + */
> +
> +
> +#include "config.h"
> +#include <stdio.h>
> +#include <string.h>
> +
> +#include "ext2fs/ext2_fs.h"
> +#include "ext2fs/ext2fs.h"
> +
> +blk64_t get_first_backup_sb(blk64_t *superblock, unsigned int =
*block_size,
> +			    ext2_filsys fs, const char *name,
> +			    io_manager manager)
> +{
> +	struct ext2_super_block *sb;
> +	io_channel		io =3D NULL;
> +	void			*buf =3D NULL;
> +	int			try_blocksize;
> +	blk64_t			try_superblock, ret_sb =3D 8193;
> +
> +	/* superblock and block_size can be NULL if fs->super is passed =
*/
> +	if (fs && fs->super) {
> +		ret_sb =3D fs->super->s_blocks_per_group +
> +			  fs->super->s_first_data_block;
> +		if (superblock)
> +			*superblock =3D ret_sb;
> +		if (block_size)
> +			*block_size =3D fs->blocksize;
> +		return ret_sb;
> +	}
> +
> +	if (*block_size) {
> +		ret_sb =3D *block_size * 8;
> +		if (*block_size =3D=3D 1024)
> +			ret_sb++;
> +		*superblock =3D ret_sb;
> +		return ret_sb;
> +	}
> +
> +	*superblock =3D ret_sb;
> +	*block_size =3D 1024;
> +
> +	if (!name || !manager)
> +		goto cleanup;
> +
> +	if (manager->open(name, 0, &io) !=3D 0)
> +		goto cleanup;
> +
> +	if (ext2fs_get_mem(SUPERBLOCK_SIZE, &buf))
> +		goto cleanup;
> +	sb =3D (struct ext2_super_block *) buf;
> +
> +	for (try_blocksize =3D EXT2_MIN_BLOCK_SIZE;
> +	     try_blocksize <=3D EXT2_MAX_BLOCK_SIZE ; try_blocksize *=3D =
2) {
> +		try_superblock =3D try_blocksize*8;
> +		if (try_blocksize =3D=3D 1024)
> +			try_superblock++;
> +		io_channel_set_blksize(io, try_blocksize);
> +		if (io_channel_read_blk64(io, try_superblock,
> +					-SUPERBLOCK_SIZE, buf))
> +			continue;
> +#ifdef WORDS_BIGENDIAN
> +		if (sb->s_magic =3D=3D ext2fs_swab16(EXT2_SUPER_MAGIC))
> +			ext2fs_swap_super(sb);
> +#endif
> +		if ((sb->s_magic =3D=3D EXT2_SUPER_MAGIC) &&
> +		    (EXT2_BLOCK_SIZE(sb) =3D=3D try_blocksize)) {
> +			ret_sb =3D try_superblock;
> +			*superblock =3D try_superblock;
> +			*block_size =3D try_blocksize;
> +			break;
> +		}
> +	}
> +
> +cleanup:
> +	if (io)
> +		io_channel_close(io);
> +	if (buf)
> +		ext2fs_free_mem(&buf);
> +	return ret_sb;
> +}
> +
> +errcode_t try_backups(const char *name, const char *io_options,
> +		      int flags, blk64_t *superblock,
> +		      unsigned int *block_size, io_manager manager,
> +		      ext2_filsys *ret_fs)
> +{
> +	errcode_t retval, retval2;
> +	blk64_t try_block_number;
> +	unsigned int i;
> +
> +	/*
> +	 * Get first superblock location based on heuristic.
> +	 * Blocksize is also returned and used to find next
> +	 * superblock copy location.
> +	 */
> +	try_block_number =3D get_first_backup_sb(superblock, block_size,
> +					       *ret_fs, name, manager);
> +	retval =3D ext2fs_open2(name, io_options, flags, =
try_block_number,
> +			      *block_size, manager, ret_fs);
> +	if (!retval)
> +		return 0;
> +
> +	/*
> +	 * Try 3d, 5th, 7th, 9th superblock copy
> +	 */
> +	for (i =3D 3; i <=3D 9; i +=3D 2) {
> +		try_block_number =3D (i * (*block_size) * 8);
> +		if (*block_size =3D=3D 1024)
> +			try_block_number++;
> +		if (*ret_fs) {
> +			ext2fs_free(*ret_fs);
> +			*ret_fs =3D NULL;
> +		}
> +		retval2 =3D ext2fs_open2(name, io_options, flags,
> +				      try_block_number, *block_size, =
manager,
> +				      ret_fs);
> +		/*
> +		 * Partition is too small to have this superblock copy.
> +		 * Return previous reading return code
> +		 */
> +		if (retval2 =3D=3D EXT2_ET_SHORT_READ)
> +			break;
> +
> +		retval =3D retval2;
> +		if (!retval) {
> +			*superblock =3D try_block_number;
> +			break;
> +		}
> +	}
> +
> +	return retval;
> +}
> diff --git a/lib/support/sb_backup.h b/lib/support/sb_backup.h
> new file mode 100644
> index 00000000..1e18e37c
> --- /dev/null
> +++ b/lib/support/sb_backup.h
> @@ -0,0 +1,20 @@
> +/*
> + * sb_backup.h -- helper functions for getting backup superblocks
> + *
> + * %Begin-Header%
> + * This file may be redistributed under the terms of the GNU Library
> + * General Public License, version 2.
> + * %End-Header%
> + */
> +
> +#include "ext2fs/ext2_fs.h"
> +#include "ext2fs/ext2fs.h"
> +
> +blk64_t get_first_backup_sb(blk64_t *superblock, unsigned int =
*block_size,
> +			    ext2_filsys fs, const char *name,
> +			    io_manager manager);
> +
> +errcode_t try_backups(const char *name, const char *io_options,
> +		      int flags, blk64_t *superblock,
> +		      unsigned int *block_size, io_manager manager,
> +		      ext2_filsys *ret_fs);
> diff --git a/misc/e2image.c b/misc/e2image.c
> index 3c881fee..786282ec 100644
> --- a/misc/e2image.c
> +++ b/misc/e2image.c
> @@ -1623,6 +1623,13 @@ int main (int argc, char ** argv)
> 	sprintf(offset_opt, "offset=3D%llu", source_offset);
> 	retval =3D ext2fs_open2(device_name, offset_opt, open_flag,
> 			      superblock, blocksize, unix_io_manager, =
&fs);
> +	if (retval & (superblock | blocksize)) {
> +		printf(_("Try backups in other location.\n"));
> +		retval =3D try_backups(device_name, offset_opt, =
open_flag,
> +				     &superblock, &blocksize,
> +				     unix_io_manager, &fs);
> +		printf(_("Use superblock %i.\n"), superblock);
> +	}
>         if (retval) {
> 		com_err (program_name, retval, _("while trying to open =
%s"),
> 			 device_name);
> --
> 2.14.3
>=20


Cheers, Andreas






--Apple-Mail=_7CC095CE-C2DE-400E-BE02-EAEB2EF4442A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlwtAuEACgkQcqXauRfM
H+B1LA//W9UcxPP8NRFqdk6pJvi1jzzKoVPGGaTINGBwjUJeq9+56+TFULhFUKzC
ZOq0GlYupiw54B9dtuU1AkdkuH+OdN+jPemw76kt8zSbsnP9mfh4HAZZlkMKBm2z
l5zIYtaqNM2mKnaNIhdK5+DjzOcqjVYCxbXOHbtcQYEcLyB9HUMsIyBbz8NAPuWh
e4T+u+jGKRjQZT5cl1BlnZiXx6+lA4Vo1vYKU+mrjnsLVAOMM84bBtqdA+y/eLBv
h07gD/wXyeGHOwLc0+7GiMYxOC/nfuZLEQZgPe3Yijl3xnPtzq49bQNpSs6qAdHV
mWprZxl6OvtwFz/3/80y324jGDH3N0/DjuoBz/hHMtMbgrDRmwjYSH3S8S2vdEFg
xDg0mp2kEkP2i+lbmCbJzd2cx+QQLijc4cmXcMe0zguHnVqjcA4SU4uI3ls+vBiE
xC/sdCtnPCZS4tmpf5kwpRTNmqiWnn2bIkwuhdG5OlI8/GHEMMj3DzZgd/cEK0Di
uUtQ90Pz6p1wU7QndYq7cjm36X6wFO+LROodQn/YDI05ekSYL7ofK8MGZ9qmOwS3
LoKWJEOgwaZXcwSFfxartN+Ojc/lhu3Ln79PQU/2X1fckDVnQY1u+kaPpK4ugwFS
mlJLQPVRgvNMrpDX0PtSR8qXKhUga137hAhWeDFvkYF1enx6UfM=
=UC75
-----END PGP SIGNATURE-----

--Apple-Mail=_7CC095CE-C2DE-400E-BE02-EAEB2EF4442A--
