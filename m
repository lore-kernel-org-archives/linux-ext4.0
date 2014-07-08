From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] e2fsck: reopen the file system with saved flags after a
 journal replay
Date: Tue, 8 Jul 2014 10:29:04 -0700
Message-ID: <20140708172904.GA10417@birch.djwong.org>
References: <1404616198-315-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	=?utf-8?B?0JDQvdC00YDQtdC5INCS0LDRgdC40LvQuNGI0LjQvQ==?=
	<a.vasilishin@kpi.ua>, Jon Severinsson <jon@severinsson.net>,
	744953@bugs.debian.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30953 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbaGHR3w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jul 2014 13:29:52 -0400
Content-Disposition: inline
In-Reply-To: <1404616198-315-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 05, 2014 at 11:09:57PM -0400, Theodore Ts'o wrote:
> After a journal replay, we close and reopen the file system so that
> any changes in the superblock can get reflected in the libext2fs's
> internal data structures.  We need to save the flags passed to
> ext2fs_open() that we used when we originally opened the file system.
>=20
> Otherwise we could end up triggering the following error message when
> checking a large (or bigalloc) file system after an unclean shutdown:
>=20
> fsck.ext4: Filesystem too large to use legacy bitmaps while trying to=
 re-open

I had a patch in my tree that fixed this too, so you can add:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>=20
> Addresses-Debian-Bug: 744953
> Cc: =D0=90=D0=BD=D0=B4=D1=80=D0=B5=D0=B9 =D0=92=D0=B0=D1=81=D0=B8=D0=BB=
=D0=B8=D1=88=D0=B8=D0=BD <a.vasilishin@kpi.ua>
> Cc: Jon Severinsson <jon@severinsson.net>
> Cc: 744953@bugs.debian.org
> ---
>=20
> Distributions will almost certainly want to backport this patch, sinc=
e
> it breaks running e2fsck on file system with the 64-bit or bigalloc
> feature enabled=20
>=20
>  e2fsck/e2fsck.h  | 1 +
>  e2fsck/journal.c | 2 +-
>  e2fsck/unix.c    | 1 +
>  3 files changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
> index c71a0a5..998abdc 100644
> --- a/e2fsck/e2fsck.h
> +++ b/e2fsck/e2fsck.h
> @@ -232,6 +232,7 @@ struct e2fsck_struct {
>  	blk64_t free_blocks;
>  	ino_t	free_inodes;
>  	int	mount_flags;
> +	int	openfs_flags;
>  	blkid_cache blkid;	/* blkid cache */
> =20
>  #ifdef HAVE_SETJMP_H
> diff --git a/e2fsck/journal.c b/e2fsck/journal.c
> index 905c0bf..9be52cd 100644
> --- a/e2fsck/journal.c
> +++ b/e2fsck/journal.c
> @@ -903,7 +903,7 @@ errcode_t e2fsck_run_ext3_journal(e2fsck_t ctx)
> =20
>  	ext2fs_mmp_stop(ctx->fs);
>  	ext2fs_free(ctx->fs);
> -	retval =3D ext2fs_open(ctx->filesystem_name, EXT2_FLAG_RW,
> +	retval =3D ext2fs_open(ctx->filesystem_name, ctx->openfs_flags,
>  			     ctx->superblock, blocksize, io_ptr,
>  			     &ctx->fs);
>  	if (retval) {
> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> index b265c99..03848c7 100644
> --- a/e2fsck/unix.c
> +++ b/e2fsck/unix.c
> @@ -1274,6 +1274,7 @@ restart:
>  			flags &=3D ~EXT2_FLAG_EXCLUSIVE;
>  	}
> =20
> +	ctx->openfs_flags =3D flags;
>  	retval =3D try_open_fs(ctx, flags, io_ptr, &fs);
> =20
>  	if (!ctx->superblock && !(ctx->options & E2F_OPT_PREEN) &&
> --=20
> 2.0.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
