From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [PATCH 01/11 RESEND] libe2p: Add new function get_fragment_score()
Date: Wed, 15 Jun 2011 21:06:21 -0600
Message-ID: <98F32E7C-67AE-4E28-837E-92282DDBEF5E@gmail.com>
References: <4DF8522F.2020304@sx.jp.nec.com>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54657 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab1FPDGJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jun 2011 23:06:09 -0400
Received: by pzk9 with SMTP id 9so772324pzk.19
        for <linux-ext4@vger.kernel.org>; Wed, 15 Jun 2011 20:06:08 -0700 (PDT)
In-Reply-To: <4DF8522F.2020304@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-15, at 12:33 AM, Kazuya Mio <k-mio@sx.jp.nec.com> wrote:
> This patch adds get_fragment_score() to libe2p. get_fragment_score() returns
> the fragmentation score. It shows the percentage of extents whose size is
> smaller than the input argument "threshold".

> However, there are some cases that cannot be merged into a next extent.
> The following extents are excepted from the calculation of fragmentation score:
> - The extent whose initialize status is different from the next extent
> - There is a hole between the extent and its next extent
> - The extent is a tail

This description of the fragmentation score should also go into a comment at the function itself. Otherwise there is no description in the code of what the "score" is or what it's used for. 

> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
> ---
> lib/e2p/Makefile.in      |    6 +
> lib/e2p/e2p.h            |    2 
> lib/e2p/fragment_score.c |  142 +++++++++++++++++++++++++++++++++++++++++++++++
> 3 files changed, 148 insertions(+), 2 deletions(-)
> diff --git a/lib/e2p/Makefile.in b/lib/e2p/Makefile.in
> index 9775a98..c62a81d 100644
> --- a/lib/e2p/Makefile.in
> +++ b/lib/e2p/Makefile.in
> @@ -19,7 +19,7 @@ all::    e2p.pc
> OBJS=        feature.o fgetflags.o fsetflags.o fgetversion.o fsetversion.o \
>        getflags.o getversion.o hashstr.o iod.o ls.o mntopts.o \
>        parse_num.o pe.o pf.o ps.o setflags.o setversion.o uuid.o \
> -        ostype.o percent.o
> +        ostype.o percent.o fragment_score.o
> 
> SRCS=        $(srcdir)/feature.c $(srcdir)/fgetflags.c \
>        $(srcdir)/fsetflags.c $(srcdir)/fgetversion.c \
> @@ -28,7 +28,7 @@ SRCS=        $(srcdir)/feature.c $(srcdir)/fgetflags.c \
>        $(srcdir)/ls.c $(srcdir)/mntopts.c $(srcdir)/parse_num.c \
>        $(srcdir)/pe.c $(srcdir)/pf.c $(srcdir)/ps.c \
>        $(srcdir)/setflags.c $(srcdir)/setversion.c $(srcdir)/uuid.c \
> -        $(srcdir)/ostype.c $(srcdir)/percent.c
> +        $(srcdir)/ostype.c $(srcdir)/percent.c $(srcdir)/fragment_score.c
> HFILES= e2p.h
> 
> LIBRARY= libe2p
> @@ -162,3 +162,5 @@ ostype.o: $(srcdir)/ostype.c $(srcdir)/e2p.h \
>  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h
> percent.o: $(srcdir)/percent.c $(srcdir)/e2p.h \
>  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h
> +fragment_score.o: $(srcdir)/fragment_score.c $(srcdir)/e2p.h \
> + $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h
> diff --git a/lib/e2p/e2p.h b/lib/e2p/e2p.h
> index 4a68dd9..52a8e51 100644
> --- a/lib/e2p/e2p.h
> +++ b/lib/e2p/e2p.h
> @@ -72,3 +72,5 @@ char *e2p_os2string(int os_type);
> int e2p_string2os(char *str);
> 
> unsigned int e2p_percent(int percent, unsigned int base);
> +
> +int get_fragment_score(int fd, size_t threshold);

This function name should be prefixed with e2p_ to avoid name clashes and make it clear that it us part of the e2p library. 

> diff --git a/lib/e2p/fragment_score.c b/lib/e2p/fragment_score.c
> new file mode 100644
> index 0000000..3ad21b9
> --- /dev/null
> +++ b/lib/e2p/fragment_score.c
> @@ -0,0 +1,142 @@
> +/*
> + * fragment_score.c --- Get file fragmentation score on ext4 filesystem.
> + *
> + * Copyright (C) 2011    Kazuya Mio <k-mio@sx.jp.nec.com>
> + *            NEC Software Tohoku, Ltd.
> + *
> + * %Begin-Header%
> + * This file may be redistributed under the terms of the GNU Library
> + * General Public License, version 2.
> + * %End-Header%
> + */
> +
> +#define _LARGEFILE64_SOURCE
> +
> +#if HAVE_ERRNO_H
> +#include <errno.h>
> +#endif
> +#include <unistd.h>
> +#include <string.h>
> +#include <sys/ioctl.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <sys/vfs.h>
> +
> +#include <ext2fs/ext2_types.h>
> +#include <ext2fs/fiemap.h>
> +
> +#include "e2p.h"
> +
> +#define    EXT3_IOC_GETFLAGS        _IOR('f', 1, long)
> +
> +#ifdef HAVE_FSTAT64
> +#define FSTAT        fstat64
> +#define STRUCT_STAT    struct stat64
> +#else
> +#define FSTAT        fstat
> +#define STRUCT_STAT    struct stat
> +#endif
> +
> +static int is_target_extent(struct fiemap_extent *cur_fm_ext,
> +                 struct fiemap_extent *next_fm_ext)
> +{
> +    /* Check a hole between the extent */
> +    if ((cur_fm_ext->fe_logical + cur_fm_ext->fe_length)
> +        < next_fm_ext->fe_logical)
> +        return 0;
> +    /* Check a defference of unwritten flag */
> +    if ((cur_fm_ext->fe_flags & FIEMAP_EXTENT_UNWRITTEN)
> +        != (next_fm_ext->fe_flags & FIEMAP_EXTENT_UNWRITTEN))
> +        return 0;
> +
> +    /* target extent */
> +    return 1;
> +}
> +
> +int get_fragment_score(int fd, size_t threshold)
> +{
> +    unsigned int    flags = 0;
> +    STRUCT_STAT    fileinfo;
> +    struct statfs    fsinfo;
> +    char buf[4096] = "";
> +    struct fiemap *fiemap = (struct fiemap *)buf;
> +    struct fiemap_extent *fm_ext = &fiemap->fm_extents[0];
> +    struct fiemap_extent prev_fm_ext;
> +    int count = (sizeof(buf) - sizeof(*fiemap)) /
> +            sizeof(struct fiemap_extent);
> +    int tot_extents = 0;
> +    int frag_extents = 0;
> +    unsigned int i;
> +    int first = 1, last = 0;
> +
> +    if (FSTAT(fd, &fileinfo) < 0 ||
> +        fstatfs(fd, &fsinfo) < 0)
> +        return -1;
> +    if (ioctl(fd, EXT3_IOC_GETFLAGS, &flags) < 0)
> +        flags = 0;
> +
> +    /*
> +     * Return an error if the target file is not the following cases.
> +     * - regular file
> +     * - extent format file on ext4 filesystem
> +     */
> +    if (!S_ISREG(fileinfo.st_mode) ||
> +        fsinfo.f_type != EXT2_SUPER_MAGIC ||
> +        !(flags & EXT4_EXTENTS_FL)) {
> +        errno = EOPNOTSUPP;
> +        return -1;
> +    }

I don't think there is a particular reason why this function shouldn't be usable for any filesytem that can return FIEMAP data. 

The fragmentation score should be independent of the underlying implementation, and it is the job of the caller to decide what to do with this information.  In the case of e4defrag it couldn't defrag a directory (ioctl should fail) and it will likely fail on other filesystem types but that is fine also. If other filesystems begin to support this ioctl they may want to begin using the same defrag tool. 

> +    memset(fiemap, 0, sizeof(struct fiemap));
> +    fiemap->fm_start = 0;
> +    fiemap->fm_length = ~0ULL;
> +    fiemap->fm_extent_count = count;
> +
> +    do {
> +        fiemap->fm_flags = 0;
> +        if (ioctl(fd, FS_IOC_FIEMAP, (unsigned long) fiemap) < 0)
> +            return -1;
> +
> +        /* If 0 extents are returned, then more ioctls are not needed */
> +        if (fiemap->fm_mapped_extents == 0)
> +            break;
> +
> +        if (first != 0)
> +            first = 0;
> +        else {
> +            /* Check the last extent gotten by previous FIEMAP */
> +            if (is_target_extent(&prev_fm_ext, &fm_ext[0])) {
> +                tot_extents++;
> +                if (prev_fm_ext.fe_length < threshold)
> +                    frag_extents++;
> +            }
> +        }
> +
> +        for (i = 0; i < fiemap->fm_mapped_extents; i++) {
> +            if (fm_ext[i].fe_flags & FIEMAP_EXTENT_LAST) {
> +                last = 1;
> +                continue;
> +            }
> +
> +            if (fiemap->fm_mapped_extents - 1 == i) {
> +                memcpy(&prev_fm_ext, &fm_ext[i],
> +                    sizeof(struct fiemap_extent));
> +                continue;
> +            }
> +
> +            /* Check target extent */
> +            if (!is_target_extent(&fm_ext[i], &fm_ext[i+1]))
> +                continue;
> +
> +            tot_extents++;
> +
> +            if (fm_ext[i].fe_length < threshold)
> +                frag_extents++;
> +        }
> +
> +        fiemap->fm_start = (fm_ext[i-1].fe_logical +
> +                    fm_ext[i-1].fe_length);
> +    } while (last == 0);
> +
> +    return tot_extents == 0 ? 0 : (100 * frag_extents) / tot_extents;
> +}

Cheers, Andreas