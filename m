From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] e2fsck: reopen the file system with saved flags after
 a journal replay
Date: Tue, 8 Jul 2014 11:03:53 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1407080947580.2180@localhost.localdomain>
References: <1404616198-315-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-532138648-1404808353=:2180"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	=?KOI8-R?B?4c7E0sXKIPfB08nMydvJzg==?= <a.vasilishin@kpi.ua>,
	Jon Severinsson <jon@severinsson.net>, 744953@bugs.debian.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbaGHJGf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jul 2014 05:06:35 -0400
In-Reply-To: <1404616198-315-1-git-send-email-tytso@mit.edu>
Content-ID: <alpine.LFD.2.00.1407081033530.2180@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-532138648-1404808353=:2180
Content-Type: TEXT/PLAIN; CHARSET=KOI8-R
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.2.00.1407081033531.2180@localhost.localdomain>

On Sat, 5 Jul 2014, Theodore Ts'o wrote:

> Date: Sat,  5 Jul 2014 23:09:57 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>, Андрей Василишин <a.vasilishin@kpi.ua>,
>     Jon Severinsson <jon@severinsson.net>, 744953@bugs.debian.org
> Subject: [PATCH] e2fsck: reopen the file system with saved flags after a
>     journal replay
> 
> After a journal replay, we close and reopen the file system so that
> any changes in the superblock can get reflected in the libext2fs's
> internal data structures.  We need to save the flags passed to
> ext2fs_open() that we used when we originally opened the file system.
> 
> Otherwise we could end up triggering the following error message when
> checking a large (or bigalloc) file system after an unclean shutdown:
> 
> fsck.ext4: Filesystem too large to use legacy bitmaps while trying to re-open

Hi Ted,

couple of comments below.

> 
> Addresses-Debian-Bug: 744953
> Cc: Андрей Василишин <a.vasilishin@kpi.ua>
> Cc: Jon Severinsson <jon@severinsson.net>
> Cc: 744953@bugs.debian.org
> ---
> 
> Distributions will almost certainly want to backport this patch, since
> it breaks running e2fsck on file system with the 64-bit or bigalloc
> feature enabled 
> 
>  e2fsck/e2fsck.h  | 1 +
>  e2fsck/journal.c | 2 +-
>  e2fsck/unix.c    | 1 +
>  3 files changed, 3 insertions(+), 1 deletion(-)
> 
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
>  
>  #ifdef HAVE_SETJMP_H
> diff --git a/e2fsck/journal.c b/e2fsck/journal.c
> index 905c0bf..9be52cd 100644
> --- a/e2fsck/journal.c
> +++ b/e2fsck/journal.c
> @@ -903,7 +903,7 @@ errcode_t e2fsck_run_ext3_journal(e2fsck_t ctx)
>  
>  	ext2fs_mmp_stop(ctx->fs);
>  	ext2fs_free(ctx->fs);
> -	retval = ext2fs_open(ctx->filesystem_name, EXT2_FLAG_RW,
> +	retval = ext2fs_open(ctx->filesystem_name, ctx->openfs_flags,
>  			     ctx->superblock, blocksize, io_ptr,
>  			     &ctx->fs);
>  	if (retval) {
> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> index b265c99..03848c7 100644
> --- a/e2fsck/unix.c
> +++ b/e2fsck/unix.c
> @@ -1274,6 +1274,7 @@ restart:
>  			flags &= ~EXT2_FLAG_EXCLUSIVE;
>  	}
>  
> +	ctx->openfs_flags = flags;
>  	retval = try_open_fs(ctx, flags, io_ptr, &fs);

Maybe we can get rid of 'flags' argument since it's not needed
anymore ?

>  
>  	if (!ctx->superblock && !(ctx->options & E2F_OPT_PREEN) &&
> 

Otherwise the patch looks good, however for some reason I can not
reproduce the problem in the big file system (without bigalloc) even
though looking at bitmap.c it looks like we really should get that
error.

The reason is that after the journal recovery we're going to set the
flags again properly and rerun the fsck so everything should be
fine. But I wonder whether we're actually going to need that flag,
but looking at e2fsck_check_ext3_journal() it looks like we might if
something is going bad ?

Thanks!
-Lukas
--8323328-532138648-1404808353=:2180--
