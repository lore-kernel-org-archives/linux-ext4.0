From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 1/2] mksparse: build sparse file from compressed e2image file.
Date: Mon, 28 Feb 2011 11:09:43 +0800
Message-ID: <AANLkTi=EVcdCzvvQrwfrr16q0fD4mTy4--3rVJiovWos@mail.gmail.com>
References: <1298860514-615-1-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63265 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab1B1DJp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Feb 2011 22:09:45 -0500
Received: by ewy6 with SMTP id 6so1159182ewy.19
        for <linux-ext4@vger.kernel.org>; Sun, 27 Feb 2011 19:09:44 -0800 (PST)
In-Reply-To: <1298860514-615-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Robin,

Are there many zero-blocks in /dev/sda1 usually?  If so, is there a
ratio of  zero-blocks?


On Mon, Feb 28, 2011 at 10:35 AM, Robin Dong <hao.bigrat@gmail.com> wro=
te:
> From: Robin Dong <sanbai@taobao.com>
>
> [Purpose]
> After we make a image-file by e2image like:
> #e2image -r /dev/hda1 - | bzip2 > hda1.bz2
> we copy the bz2 file to remote host and extract it:
> #bunzip2 hda1.bz2
> the unzipped hda1 file will not be a sparse file and the space occupi=
ed
> by it is as large as the real /dev/hda1 filesystem.
>
> Therefore a tool to transform a raw-file to a sparse-file is necessar=
y.
> This Patch is a first attempt to provide such a tool which is called
> 'mksparse' so far.
>
> [Example]
> Extract hda1.bz2 by:
> #bunzip2 -c hda1.bz2 | mksparse hda1
> the hda1 file will be a sparse file.
>
> Reviewed-by: Coly Li <bosong.ly@taobao.com>
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> ---
> =A0misc/Makefile.in | =A0 21 ++++-
> =A0misc/mksparse.c =A0| =A0268 ++++++++++++++++++++++++++++++++++++++=
++++++++++++++++
> =A02 files changed, 285 insertions(+), 4 deletions(-)
> =A0create mode 100644 misc/mksparse.c
>
> diff --git a/misc/Makefile.in b/misc/Makefile.in
> index 86ee53f..fcd316e 100644
> --- a/misc/Makefile.in
> +++ b/misc/Makefile.in
> @@ -17,6 +17,8 @@ INSTALL =3D @INSTALL@
> =A0@IMAGER_CMT@E2IMAGE_PROG=3D e2image
> =A0@IMAGER_CMT@E2IMAGE_MAN=3D e2image.8
>
> +@IMAGER_CMT@MKSPARSE_PROG=3D mksparse
> +
> =A0@UUIDD_CMT@UUIDD_PROG=3D uuidd
> =A0@UUIDD_CMT@UUIDD_MAN=3D uuidd.8
>
> @@ -27,7 +29,7 @@ INSTALL =3D @INSTALL@
> =A0@BLKID_CMT@FINDFS_MAN=3D findfs.8
>
> =A0SPROGS=3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mke2fs badblocks tune2fs =
dumpe2fs $(BLKID_PROG) logsave \
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 $(E2IMAGE_PROG) @FSCK_P=
ROG@ e2undo
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 $(E2IMAGE_PROG) $(MKSPA=
RSE_PROG) @FSCK_PROG@ e2undo
> =A0USPROGS=3D =A0 =A0 =A0 mklost+found filefrag e2freefrag $(UUIDD_PR=
OG) $(E4DEFRAG_PROG)
> =A0SMANPAGES=3D =A0 =A0 tune2fs.8 mklost+found.8 mke2fs.8 dumpe2fs.8 =
badblocks.8 \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0e2label.8 $(FINDFS_MAN=
) $(BLKID_MAN) $(E2IMAGE_MAN) \
> @@ -50,6 +52,7 @@ UUIDD_OBJS=3D =A0 uuidd.o
> =A0DUMPE2FS_OBJS=3D dumpe2fs.o
> =A0BADBLOCKS_OBJS=3D =A0 =A0 =A0 =A0badblocks.o
> =A0E2IMAGE_OBJS=3D =A0e2image.o
> +MKSPARSE_OBJS=3D mksparse.o
> =A0FSCK_OBJS=3D =A0 =A0 fsck.o base_device.o ismounted.o
> =A0BLKID_OBJS=3D =A0 =A0blkid.o
> =A0FILEFRAG_OBJS=3D filefrag.o
> @@ -68,6 +71,7 @@ PROFILED_UUIDD_OBJS=3D =A0profiled/uuidd.o
> =A0PROFILED_DUMPE2FS_OBJS=3D =A0 =A0 =A0 =A0profiled/dumpe2fs.o
> =A0PROFILED_BADBLOCKS_OBJS=3D =A0 =A0 =A0 profiled/badblocks.o
> =A0PROFILED_E2IMAGE_OBJS=3D profiled/e2image.o
> +PROFILED_MKSPARSE_OBJS=3D =A0 =A0 =A0 =A0profiled/mksparse.o
> =A0PROFILED_FSCK_OBJS=3D =A0 =A0profiled/fsck.o profiled/base_device.=
o \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0profiled/ismounted.o
> =A0PROFILED_BLKID_OBJS=3D =A0 profiled/blkid.o
> @@ -109,7 +113,7 @@ all:: profiled $(SPROGS) $(UPROGS) $(USPROGS) $(S=
MANPAGES) $(UMANPAGES) \
> =A0@PROFILE_CMT@all:: tune2fs.profiled blkid.profiled e2image.profile=
d \
> =A0 =A0 =A0 =A0e2undo.profiled mke2fs.profiled dumpe2fs.profiled fsck=
=2Eprofiled \
> =A0 =A0 =A0 =A0logsave.profiled filefrag.profiled uuidgen.profiled uu=
idd.profiled \
> - =A0 =A0 =A0 e2image.profiled e4defrag.profiled
> + =A0 =A0 =A0 e2image.profiled mksparse.profiled e4defrag.profiled
>
> =A0profiled:
> =A0@PROFILE_CMT@ =A0$(E) " =A0MKDIR $@"
> @@ -187,6 +191,15 @@ e2image.profiled: $(PROFILED_E2IMAGE_OBJS) $(PRO=
=46ILED_DEPLIBS)
> =A0 =A0 =A0 =A0$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o e2image.profiled \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0$(PROFILED_E2IMAGE_OBJS) $(PROFILED_LI=
BS) $(LIBINTL)
>
> +mksparse: $(MKSPARSE_OBJS) $(DEPLIBS)
> + =A0 =A0 =A0 $(E) " =A0LD $@"
> + =A0 =A0 =A0 $(Q) $(CC) $(ALL_LDFLAGS) -o mksparse $(MKSPARSE_OBJS) =
$(LIBS) $(LIBINTL)
> +
> +mksparse.profiled: $(PROFILED_MKSPARSE_OBJS) $(PROFILED_DEPLIBS)
> + =A0 =A0 =A0 $(E) " =A0LD $@"
> + =A0 =A0 =A0 $(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o mksparse.profiled \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 $(PROFILED_MKSPARSE_OBJS) $(PROFILED_LI=
BS) $(LIBINTL)
> +
> =A0e2undo: $(E2UNDO_OBJS) $(DEPLIBS)
> =A0 =A0 =A0 =A0$(E) " =A0LD $@"
> =A0 =A0 =A0 =A0$(Q) $(CC) $(ALL_LDFLAGS) -o e2undo $(E2UNDO_OBJS) $(L=
IBS) $(LIBINTL)
> @@ -550,8 +563,8 @@ clean:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0$(FMANPAGES) \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0base_device base_device.out mke2fs.sta=
tic filefrag e2freefrag \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0e2initrd_helper partinfo prof_err.[ch]=
 default_profile.c \
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 uuidd e2image tune2fs.static tst_ismoun=
ted fsck.profiled \
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 blkid.profiled tune2fs.profiled e2image=
=2Eprofiled \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 uuidd e2image mksparse tune2fs.static t=
st_ismounted fsck.profiled \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 blkid.profiled tune2fs.profiled e2image=
=2Eprofiled mksparse.profiled\
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0e2undo.profiled mke2fs.profiled dumpe2=
fs.profiled \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0logsave.profiled filefrag.profiled uui=
dgen.profiled \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0uuidd.profiled e2image.profiled \
> diff --git a/misc/mksparse.c b/misc/mksparse.c
> new file mode 100644
> index 0000000..9e62fcf
> --- /dev/null
> +++ b/misc/mksparse.c
> @@ -0,0 +1,268 @@
> +/*
> + * mksparse.c --- Program which transform stdin (or file) to
> + * be a new sparse file.
> + *
> + * Copyright 2011 by Taobao, all rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License, version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
> + * General Public License for more details.
> + *
> + * Authors: Robin Dong <sanbai@taobao.com>
> + */
> +
> +#define _LARGEFILE_SOURCE
> +#define _LARGEFILE64_SOURCE
> +
> +#include <fcntl.h>
> +#include <grp.h>
> +#ifdef HAVE_GETOPT_H
> +#include <getopt.h>
> +#else
> +extern char *optarg;
> +extern int optind;
> +#endif
> +#include <stdio.h>
> +#ifdef HAVE_STDLIB_H
> +#include <stdlib.h>
> +#endif
> +#include <string.h>
> +#include <unistd.h>
> +#include <fcntl.h>
> +#include <errno.h>
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +#include <limits.h>
> +
> +#include "ext2fs/ext2fs.h"
> +
> +#include "../version.h"
> +#include "nls-enable.h"
> +
> +#define KB_SIZE 1024
> +#define MB_SIZE (1024*1024)
> +#define MIN_BUFFER_SIZE 1024
> +#define MAX_BUFFER_SIZE (64*1024*1024)
> +#define DEFAULT_BUFFER_SIZE (4*1024)
> +
> +#define OPEN_SRC_FAIL =A0 =A0 =A0 =A0 =A0-1
> +#define OPEN_TARGET_FAIL =A0 =A0 =A0 -2
> +#define MALLOC_FAIL =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0-3
> +#define SEEK_FAIL =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0-4
> +#define WRITE_FAIL =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 -5
> +
> +const char *program_name =3D "mksparse";
> +
> +static void usage(void)
> +{
> + =A0 =A0 =A0 fprintf(stderr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 _("Usage: %s [-s buffer_size] [-i input=
_file] sparse_file\n"),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 program_name);
> + =A0 =A0 =A0 exit (1);
> +}
> +
> +static int get_buffer_size(const char *optarg)
> +{
> + =A0 =A0 =A0 char *pos =3D NULL;
> + =A0 =A0 =A0 long val =3D strtol(optarg, &pos, 0);
> + =A0 =A0 =A0 if (pos =3D=3D optarg || val =3D=3D LONG_MAX)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return DEFAULT_BUFFER_SIZE;
> +
> + =A0 =A0 =A0 switch (*pos) {
> + =A0 =A0 =A0 case 'k':
> + =A0 =A0 =A0 case 'K':
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 val *=3D KB_SIZE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case 'm':
> + =A0 =A0 =A0 case 'M':
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 val *=3D MB_SIZE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case 'b':
> + =A0 =A0 =A0 case 'B':
> + =A0 =A0 =A0 case '\0':
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, _("Wrong buffer_size %s=
\n"), optarg);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 val =3D -1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* never touch here
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* the buffer_size must in thec range [1KB, 64MB]
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (val > MAX_BUFFER_SIZE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 _("Buff=
er_size is too large, "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "ch=
ange it to %d bytes\n"),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MAX_BUF=
=46ER_SIZE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 val =3D MAX_BUFFER_SIZE;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (val < MIN_BUFFER_SIZE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 _("Buff=
er_size is too small, "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "ch=
ange it to %d bytes\n"),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MIN_BUF=
=46ER_SIZE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 val =3D MIN_BUFFER_SIZE;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* up-align to MIN_BUFFER_SIZE
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 val &=3D ~(MIN_BUFFER_SIZE - 1);
> +
> +out:
> + =A0 =A0 =A0 return val;
> +}
> +
> +static int check_zero(const char *buffer, int buffer_size)
> +{
> + =A0 =A0 =A0 long *wp =3D (long *)buffer;
> +
> + =A0 =A0 =A0 while (*(wp++) =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((const char *)wp >=3D buffer + buff=
er_size)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return (const char *)wp >=3D buffer + buffer_size;
> +}
> +
> +int main (int argc, char **argv)
> +{
> + =A0 =A0 =A0 int c;
> + =A0 =A0 =A0 char *buffer =3D NULL;
> + =A0 =A0 =A0 char *if_name =3D NULL;
> + =A0 =A0 =A0 char *of_name =3D NULL;
> + =A0 =A0 =A0 int buffer_size =3D DEFAULT_BUFFER_SIZE;
> + =A0 =A0 =A0 int source_fd =3D 0;
> + =A0 =A0 =A0 int target_fd =3D 0;
> + =A0 =A0 =A0 ssize_t ret =3D 0;
> + =A0 =A0 =A0 int need =3D 0;
> + =A0 =A0 =A0 int loop;
> + =A0 =A0 =A0 int err_num =3D 0;
> +
> +#ifdef ENABLE_NLS
> + =A0 =A0 =A0 setlocale(LC_MESSAGES, "");
> + =A0 =A0 =A0 setlocale(LC_CTYPE, "");
> + =A0 =A0 =A0 bindtextdomain(NLS_CAT_NAME, LOCALEDIR);
> + =A0 =A0 =A0 textdomain(NLS_CAT_NAME);
> +#endif
> + =A0 =A0 =A0 fprintf (stderr, "mksparse %s (%s)\n", E2FSPROGS_VERSIO=
N,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0E2FSPROGS_DATE);
> + =A0 =A0 =A0 if (argc && *argv)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 program_name =3D *argv;
> + =A0 =A0 =A0 while ((c =3D getopt (argc, argv, "s:i:")) !=3D EOF)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (c) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 's':
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 buffer_size =3D get_buf=
fer_size(optarg);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (buffer_size < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
-1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 'i':
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if_name =3D optarg;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 usage();
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (optind !=3D argc - 1)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 usage();
> +
> + =A0 =A0 =A0 add_error_table(&et_ext2_error_table);
> +
> + =A0 =A0 =A0 of_name =3D argv[optind];
> +
> + =A0 =A0 =A0 if (!if_name) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 source_fd =3D 0;
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 source_fd =3D open(if_name, O_RDONLY);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (source_fd < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 com_err (program_name, =
errno,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 _("while trying to open %s"), if_name);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err_num =3D OPEN_SRC_FA=
IL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 target_fd =3D open(of_name, O_CREAT|O_TRUNC|O_WRONLY, 0=
600);
> + =A0 =A0 =A0 if (target_fd < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 com_err (program_name, errno,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 _("whil=
e trying to open %s"), of_name);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err_num =3D OPEN_TARGET_FAIL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 buffer =3D malloc(buffer_size);
> + =A0 =A0 =A0 if (!buffer) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 com_err (program_name, ENOMEM, _("while=
 allocating buffer"));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err_num =3D MALLOC_FAIL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 loop =3D 1;
> + =A0 =A0 =A0 do {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 need =3D buffer_size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (need > 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D read (source_fd=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 buffer + (buffer_size - need),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 need);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (loo=
p =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 loop =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 continue;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (ret =3D=3D 0=
) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 loop =3D=
 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (loo=
p =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 loop =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 need -=3D=
 ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (need =3D=3D 0 && check_zero(buffer,=
 buffer_size)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D lseek(target_fd=
, buffer_size, SEEK_CUR);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret =3D=3D (off_t)(=
-1)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 com_err=
 (program_name, errno,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 _("while lseeking %d"), ret);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err_num=
 =3D SEEK_FAIL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ou=
t;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (need < buffer_size) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D write(target_fd=
, buffer, buffer_size - need);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 com_err=
 (program_name,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0errno, _("while writeing"));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err_num=
 =3D WRITE_FAIL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ou=
t;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 } while (loop);
> +
> +out:
> + =A0 =A0 =A0 if (buffer)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 free(buffer);
> +
> + =A0 =A0 =A0 if (target_fd > 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fsync(target_fd);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 close(target_fd);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (source_fd > 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 close(source_fd);
> +
> + =A0 =A0 =A0 remove_error_table(&et_ext2_error_table);
> + =A0 =A0 =A0 return (!err_num) ? 0 : -1;
> +}
> --
> 1.7.3.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
