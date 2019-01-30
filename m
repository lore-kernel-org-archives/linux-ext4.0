Return-Path: <SRS0=D/JD=QG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E09C169C4
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jan 2019 03:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29B7A20989
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jan 2019 03:10:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="wD02E+Ah"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729736AbfA3DKG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 29 Jan 2019 22:10:06 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43421 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728356AbfA3DKG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jan 2019 22:10:06 -0500
Received: by mail-pg1-f196.google.com with SMTP id v28so9692482pgk.10
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2019 19:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=7gbwO8aQgEiUpLj8gv/DgEO4anwOAytUOlIdqQWTAQo=;
        b=wD02E+Ah1mOsRVYwzyQzsAzDlRIAJwYv7SXxVrwg2paVso4ZZ9oJL4ST+xPBV4oBye
         QNuP/a0Wb5jTGdPuMti9eut17rPtZvfy0AH3+U5/7NbFc09rBA2MYnQqBtHA//9ezdso
         e0d2LM+q46APeAlfwrhm8ewHwovashvtRwe+w+Z+nGAzKc5IIvHoYXdiLVoes96aCa3P
         Agzr1Q2+jmYEXWBS1X5cffi+U0iqXF+dcpotIXWAp44Q9qtItVw3iqfyGH+Kg61qPc8f
         7og7uYVgEw0I96VZOSFPUxhPxj9TzjRVXseBSk4dKN1xsg9+BaCL+YEKRxGqthP1RuVI
         YVBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=7gbwO8aQgEiUpLj8gv/DgEO4anwOAytUOlIdqQWTAQo=;
        b=baUHz0A0S31U+vGyMjZcG38PQdD+dBtFW0PcLMwV4Ro8FcjAc2J4o+ANsuL5k7MiwM
         0icJ0HMp3t0tWAAWx7sIXTp9LVBGg23w94qD2s0N03qaz+PaAO0LcC61KyBjxLY2bkY3
         i1UAQz0StliQQl4b3F+2zZ5BmzhPi1ofqXW64a6FW97939LQRidExcVJQejV6QmqvIqq
         vBYo9GZLINwi4PCcbFsg0Q3DOYtdCk6FyUSzQd8SVoRwhSUKiXED02zPU0LSPWeewsFw
         4OQ5Xf2g9wtek610gAKF0exJTT7t+unhEqpxu2QbhfWMxsT72VF/H6hENKBM2LKmaArE
         3eRQ==
X-Gm-Message-State: AJcUukdN+MKRRwdqQEzIns9HpykYlU5Kl/bUb67R/2EjdcCq0hQ1Imrf
        NkdmC7T2tnaf8CUftp3DdxCsjg==
X-Google-Smtp-Source: ALg8bN6PEUVBQdIcjdatvDE7PwXMUjH0ZFsjMzeJ9MOTUeFydC30YWlv1S4ssgcyY0uGlS24QMVtrA==
X-Received: by 2002:a62:2702:: with SMTP id n2mr29451157pfn.29.1548817805570;
        Tue, 29 Jan 2019 19:10:05 -0800 (PST)
Received: from ?IPv6:2605:8d80:4a0:7c8a:14fc:648d:efbb:9e54? ([2605:8d80:4a0:7c8a:14fc:648d:efbb:9e54])
        by smtp.gmail.com with ESMTPSA id u186sm252394pfu.51.2019.01.29.19.10.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 19:10:05 -0800 (PST)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <3C909FA3-5EA8-46E8-BFD5-63374269A1D2@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_85F1FE8F-291A-4259-83B3-8A39BAABBD37";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v7 4/4] ext2fs: automaticlly open backup superblocks
Date:   Tue, 29 Jan 2019 20:10:02 -0700
In-Reply-To: <20190129175134.26652-5-c17828@cray.com>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>
To:     Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>
References: <20190129175134.26652-1-c17828@cray.com>
 <20190129175134.26652-5-c17828@cray.com>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_85F1FE8F-291A-4259-83B3-8A39BAABBD37
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 29, 2019, at 10:51 AM, Artem Blagodarenko =
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






--Apple-Mail=_85F1FE8F-291A-4259-83B3-8A39BAABBD37
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlxRFYsACgkQcqXauRfM
H+BKcA/+L7Aa7nVs66pb/0hKg5mW/j4FfGLD0y80Jm8DNkQtMaPcgnFQl6VjclyN
TLdS0zxKHlSFNFYJRM0CQ3Q3lNr8m1al1/nEFXKjc2XPOK1qqf4a5aoo1oJaRRCO
IPbQV6MSTC5ikR7fUH3+BBrQkftd5YE9ghvQwG5mkp3qvN6c6ETy0mb8Ji3u7A2p
kllxaIsPoZ05E73V1zHGXTlKGx2TyAf2k4sCP7NbpIQRaQ+ko4SEFrdABcu/ahAn
cqvCBldG/+e5SEF8eDZek1WfTIrPZuUyEiCYzqCbm5KWkVh2I9VD+76+JZU2Z0D2
rX5g7MtRxxldTFcst75Zsvga7SHZSHCjPMn2uKvgIZFXvzK1zoCt4GLmrqjfSG4C
MMxx6P1xJaIzweT6iuJxVOxzN21yofDB2GHE2mzAEsY0Z4sfC6l6PIoG2ZSp+sX5
YACGCDKIAmDvm6JOu130HRFANZuKQq4CNknbN5iib02Pl2FrynaPE/tg8N+YiD8x
Eb3HMf2QWO4IsVkEZ2fJGzMGzQ7Kx/OMW4z61BNDWeGHH7PPwmvSTWbsFHwt1xnz
LN+7djbsryguytXqZyGdT2VBAA9T+Z20P3qZDNm6sMvpnZhKyTpyfeew+N80xtLY
6/yfBSUcD2VBiBjEBg4shy6Uz6av+U3RJ6GssRoOpCWYtnz+H9U=
=g6SO
-----END PGP SIGNATURE-----

--Apple-Mail=_85F1FE8F-291A-4259-83B3-8A39BAABBD37--
