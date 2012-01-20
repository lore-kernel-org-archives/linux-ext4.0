From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH] quota: Remove unnecessary definitions
Date: Thu, 19 Jan 2012 18:21:04 -0800
Message-ID: <CAGr1F2GUnvRPYJ=gaFYNHRJzXCtr0-C3cZVGi9WwHy0PqTzvdQ@mail.gmail.com>
References: <1327004329-6909-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57279 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753Ab2ATCVZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Jan 2012 21:21:25 -0500
Received: by dake40 with SMTP id e40so57346dak.19
        for <linux-ext4@vger.kernel.org>; Thu, 19 Jan 2012 18:21:25 -0800 (PST)
In-Reply-To: <1327004329-6909-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for the patch. It looks good.

--
Aditya



On Thu, Jan 19, 2012 at 12:18 PM, Jan Kara <jack@suse.cz> wrote:
> Quite some definitions in quota library are not necessary. Remove the=
m.
> Also fold quota.h file into quotaio.h since it didn't contain that ma=
ny
> definitions.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
> =C2=A0lib/quota/dqblk_v2.h =C2=A0 =C2=A0 | =C2=A0 22 ++-----
> =C2=A0lib/quota/mkquota.c =C2=A0 =C2=A0 =C2=A0| =C2=A0 18 +-----
> =C2=A0lib/quota/mkquota.h =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A03 +-
> =C2=A0lib/quota/quota.h =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0155 ------=
----------------------------------------
> =C2=A0lib/quota/quotaio.c =C2=A0 =C2=A0 =C2=A0| =C2=A0 12 +---
> =C2=A0lib/quota/quotaio.h =C2=A0 =C2=A0 =C2=A0| =C2=A0 50 ++++++++---=
-----
> =C2=A0lib/quota/quotaio_tree.h | =C2=A0 =C2=A03 +-
> =C2=A0lib/quota/quotaio_v2.c =C2=A0 | =C2=A0 51 ++--------------
> =C2=A0lib/quota/quotaio_v2.h =C2=A0 | =C2=A0 55 +---------------
> =C2=A09 files changed, 44 insertions(+), 325 deletions(-)
> =C2=A0delete mode 100644 lib/quota/quota.h
>
> =C2=A0Ted, after applying this patch, you'll need to run 'make depend=
' to fixup
> dependencies in makefiles. I didn't include that in the patch because=
 on my
> system the dependencies are different and so diff is 1500+ lines.
>
> Also I've talked with Aditya and there's no real reason for libquota =
to be a
> separate library. So I think it would be best to just make it part of
> libext2fs. Do you agree?
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Honza
> diff --git a/lib/quota/dqblk_v2.h b/lib/quota/dqblk_v2.h
> index 18055c6..d12512a 100644
> --- a/lib/quota/dqblk_v2.h
> +++ b/lib/quota/dqblk_v2.h
> @@ -7,28 +7,16 @@
> =C2=A0#ifndef __QUOTA_DQBLK_V2_H__
> =C2=A0#define __QUOTA_DQBLK_V2_H__
>
> -#include <sys/types.h>
> =C2=A0#include "quotaio_tree.h"
>
> -#define Q_V2_GETQUOTA =C2=A00x0D00 =C2=A0/* Get limits and usage */
> -#define Q_V2_SETQUOTA =C2=A00x0E00 =C2=A0/* Set limits and usage */
> -#define Q_V2_SETUSE =C2=A0 =C2=A00x0F00 =C2=A0/* Set only usage */
> -#define Q_V2_SETQLIM =C2=A0 0x0700 =C2=A0/* Set only limits */
> -#define Q_V2_GETINFO =C2=A0 0x0900 =C2=A0/* Get information about qu=
ota */
> -#define Q_V2_SETINFO =C2=A0 0x0A00 =C2=A0/* Set information about qu=
ota */
> -#define Q_V2_SETGRACE =C2=A00x0B00 =C2=A0/* Set just grace times in =
quotafile
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* information */
> -#define Q_V2_SETFLAGS =C2=A00x0C00 =C2=A0/* Set just flags in quotaf=
ile information */
> -#define Q_V2_GETSTATS =C2=A00x1100 =C2=A0/* get collected stats (bef=
ore proc was used) */
> -
> =C2=A0/* Structure for format specific information */
> =C2=A0struct v2_mem_dqinfo {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct qtree_mem_dqinfo dqi_qtree;
> - =C2=A0 =C2=A0 =C2=A0 uint dqi_flags; =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*=
 Flags set in quotafile */
> - =C2=A0 =C2=A0 =C2=A0 uint dqi_used_entries; =C2=A0/* Number of entr=
ies in file -
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0updated by scan_dquots=
 */
> - =C2=A0 =C2=A0 =C2=A0 uint dqi_data_blocks; =C2=A0 /* Number of data=
 blocks in file -
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0updated by scan_dquots=
 */
> + =C2=A0 =C2=A0 =C2=A0 unsigned int dqi_flags; =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /* Flags set in quotafile */
> + =C2=A0 =C2=A0 =C2=A0 unsigned int dqi_used_entries; =C2=A0/* Number=
 of entries in file -
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0updated by scan_dquots */
> + =C2=A0 =C2=A0 =C2=A0 unsigned int dqi_data_blocks; =C2=A0 /* Number=
 of data blocks in file -
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0updated by scan_dquots */
> =C2=A0};
>
> =C2=A0struct v2_mem_dqblk {
> diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
> index ac7288c..9acbb10 100644
> --- a/lib/quota/mkquota.c
> +++ b/lib/quota/mkquota.c
> @@ -6,9 +6,6 @@
> =C2=A0#include "config.h"
> =C2=A0#include <sys/types.h>
> =C2=A0#include <sys/stat.h>
> -#ifdef HAVE_SYS_QUOTA_H
> -#include <sys/quota.h>
> -#endif
> =C2=A0#include <unistd.h>
> =C2=A0#include <errno.h>
> =C2=A0#include <string.h>
> @@ -18,7 +15,6 @@
> =C2=A0#include "ext2fs/ext2fs.h"
> =C2=A0#include "e2p/e2p.h"
>
> -#include "quota.h"
> =C2=A0#include "quotaio.h"
> =C2=A0#include "quotaio_v2.h"
> =C2=A0#include "quotaio_tree.h"
> @@ -49,18 +45,6 @@ static void print_inode(struct ext2_inode *inode)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
> =C2=A0}
>
> -int quota_is_on(ext2_filsys fs, int type)
> -{
> - =C2=A0 =C2=A0 =C2=A0 char tmp[1024];
> - =C2=A0 =C2=A0 =C2=A0 qid_t id =3D (type =3D=3D USRQUOTA) ? getuid()=
 : getgid();
> -
> -#ifdef HAVE_QUOTACTL
> - =C2=A0 =C2=A0 =C2=A0 if (!quotactl(QCMD(Q_V2_GETQUOTA, type), fs->d=
evice_name, id, tmp))
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;
> -#endif
> - =C2=A0 =C2=A0 =C2=A0 return 0;
> -}
> -
> =C2=A0/*
> =C2=A0* Returns 0 if not able to find the quota file, otherwise retur=
ns its
> =C2=A0* inode number.
> @@ -74,7 +58,7 @@ int quota_file_exists(ext2_filsys fs, int qtype, in=
t fmt)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (qtype >=3D MAXQUOTAS)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINVAL=
;
>
> - =C2=A0 =C2=A0 =C2=A0 quota_get_qf_name(qtype, fmt, qf_name);
> + =C2=A0 =C2=A0 =C2=A0 quota_get_qf_name(qtype, QFMT_VFS_V1, qf_name)=
;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ext2fs_lookup(fs, EXT2_ROOT_INO, q=
f_name, strlen(qf_name), 0,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0&ino);
> diff --git a/lib/quota/mkquota.h b/lib/quota/mkquota.h
> index a5fa74b..68ef435 100644
> --- a/lib/quota/mkquota.h
> +++ b/lib/quota/mkquota.h
> @@ -32,7 +32,7 @@
>
> =C2=A0#include "ext2fs/ext2_fs.h"
> =C2=A0#include "ext2fs/ext2fs.h"
> -#include "quota.h"
> +#include "quotaio.h"
> =C2=A0#include "../e2fsck/dict.h"
>
> =C2=A0typedef struct quota_ctx *quota_ctx_t;
> @@ -56,7 +56,6 @@ errcode_t quota_compute_usage(quota_ctx_t qctx);
> =C2=A0void quota_release_context(quota_ctx_t *qctx);
>
> =C2=A0errcode_t quota_remove_inode(ext2_filsys fs, int qtype);
> -int quota_is_on(ext2_filsys fs, int type);
> =C2=A0int quota_file_exists(ext2_filsys fs, int qtype, int fmt);
> =C2=A0void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtyp=
e);
>
> diff --git a/lib/quota/quota.h b/lib/quota/quota.h
> deleted file mode 100644
> index a943ec6..0000000
> --- a/lib/quota/quota.h
> +++ /dev/null
> @@ -1,155 +0,0 @@
> -/*
> - * Copyright (c) 1982, 1986 Regents of the University of California.
> - * All rights reserved.
> - *
> - * This code is derived from software contributed to Berkeley by
> - * Robert Elz at The University of Melbourne.
> - *
> - * Redistribution and use in source and binary forms, with or withou=
t
> - * modification, are permitted provided that the following condition=
s
> - * are met:
> - * 1. Redistributions of source code must retain the above copyright
> - * =C2=A0 =C2=A0notice, this list of conditions and the following di=
sclaimer.
> - * 2. Redistributions in binary form must reproduce the above copyri=
ght
> - * =C2=A0 =C2=A0notice, this list of conditions and the following di=
sclaimer in the
> - * =C2=A0 =C2=A0documentation and/or other materials provided with t=
he distribution.
> - * 3. Neither the name of the University nor the names of its contri=
butors
> - * =C2=A0 =C2=A0may be used to endorse or promote products derived f=
rom this software
> - * =C2=A0 =C2=A0without specific prior written permission.
> - *
> - * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS=
'' AND
> - * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,=
 THE
> - * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULA=
R PURPOSE
> - * ARE DISCLAIMED. =C2=A0IN NO EVENT SHALL THE REGENTS OR CONTRIBUTO=
RS BE LIABLE
> - * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONS=
EQUENTIAL
> - * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE=
 GOODS
> - * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPT=
ION)
> - * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRAC=
T, STRICT
> - * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN=
 ANY WAY
> - * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILI=
TY OF
> - * SUCH DAMAGE.
> - */
> -
> -#ifndef _LINUX_QUOTA_
> -#define _LINUX_QUOTA_
> -
> -#include <errno.h>
> -#include <sys/types.h>
> -#include <ext2fs/ext2_types.h>
> -
> -#define __DQUOT_VERSION__ =C2=A0 =C2=A0 =C2=A0"dquot_6.5.2"
> -
> -typedef u_int32_t qid_t; =C2=A0 =C2=A0 =C2=A0 /* Type in which we st=
ore ids in memory */
> -typedef int64_t qsize_t; =C2=A0 =C2=A0 =C2=A0 /* Type in which we st=
ore size limitations */
> -
> -#define MAXQUOTAS 2
> -#define USRQUOTA =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*=
 element used for user quotas */
> -#define GRPQUOTA =C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*=
 element used for group quotas */
> -
> -/*
> - * Definitions for the default names of the quotas files.
> - */
> -#define INITQFNAMES { \
> - =C2=A0 =C2=A0 =C2=A0 "user", =C2=A0 =C2=A0/* USRQUOTA */ \
> - =C2=A0 =C2=A0 =C2=A0 "group", =C2=A0 /* GRPQUOTA */ \
> - =C2=A0 =C2=A0 =C2=A0 "undefined", \
> -};
> -
> -/*
> - * Definitions of magics and versions of current quota files
> - */
> -#define INITQMAGICS {\
> - =C2=A0 =C2=A0 =C2=A0 0xd9c01f11, =C2=A0 =C2=A0 /* USRQUOTA */\
> - =C2=A0 =C2=A0 =C2=A0 0xd9c01927 =C2=A0 =C2=A0 =C2=A0/* GRPQUOTA */\
> -}
> -
> -/* Size of blocks in which are counted size limits in generic utilit=
y parts */
> -#define QUOTABLOCK_BITS 10
> -#define QUOTABLOCK_SIZE (1 << QUOTABLOCK_BITS)
> -
> -/* Conversion routines from and to quota blocks */
> -#define qb2kb(x) ((x) << (QUOTABLOCK_BITS-10))
> -#define kb2qb(x) ((x) >> (QUOTABLOCK_BITS-10))
> -#define toqb(x) (((x) + QUOTABLOCK_SIZE - 1) >> QUOTABLOCK_BITS)
> -
> -/*
> - * Command definitions for the 'quotactl' system call.
> - * The commands are broken into a main command defined below
> - * and a subcommand that is used to convey the type of
> - * quota that is being manipulated (see above).
> - */
> -#define SUBCMDMASK =C2=A00x00ff
> -#define SUBCMDSHIFT 8
> -#define QCMD(cmd, type) =C2=A0(((cmd) << SUBCMDSHIFT) | ((type) & SU=
BCMDMASK))
> -
> -#define Q_SYNC =C2=A0 =C2=A0 0x800001 =C2=A0 =C2=A0/* sync disk copy=
 of a filesystems quotas */
> -#define Q_QUOTAON =C2=A00x800002 =C2=A0 =C2=A0/* turn quotas on */
> -#define Q_QUOTAOFF 0x800003 =C2=A0 =C2=A0/* turn quotas off */
> -#define Q_GETFMT =C2=A0 0x800004 =C2=A0 =C2=A0/* get quota format us=
ed on given filesystem */
> -#define Q_GETINFO =C2=A00x800005 =C2=A0 =C2=A0/* get information abo=
ut quota files */
> -#define Q_SETINFO =C2=A00x800006 =C2=A0 =C2=A0/* set information abo=
ut quota files */
> -#define Q_GETQUOTA 0x800007 =C2=A0 =C2=A0/* get user quota structure=
 */
> -#define Q_SETQUOTA 0x800008 =C2=A0 =C2=A0/* set user quota structure=
 */
> -
> -/* Quota format type IDs */
> -#define =C2=A0 =C2=A0 =C2=A0 =C2=A0QFMT_VFS_OLD 1
> -#define =C2=A0 =C2=A0 =C2=A0 =C2=A0QFMT_VFS_V0 2
> -#define QFMT_OCFS2 3
> -#define =C2=A0 =C2=A0 =C2=A0 =C2=A0QFMT_VFS_V1 4
> -
> -/* Size of block in which space limits are passed through the quota
> - * interface */
> -#define QIF_DQBLKSIZE_BITS 10
> -#define QIF_DQBLKSIZE (1 << QIF_DQBLKSIZE_BITS)
> -
> -/*
> - * Structure used for setting quota information about file via quota=
ctl
> - * Following flags are used to specify which fields are valid
> - */
> -#define IIF_BGRACE =C2=A0 =C2=A0 1
> -#define IIF_IGRACE =C2=A0 =C2=A0 2
> -#define IIF_FLAGS =C2=A0 =C2=A0 =C2=A04
> -#define IIF_ALL =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0(IIF_BGRACE | IIF_IGRACE | IIF_FLAGS)
> -
> -struct if_dqinfo {
> - =C2=A0 =C2=A0 =C2=A0 __u64 dqi_bgrace;
> - =C2=A0 =C2=A0 =C2=A0 __u64 dqi_igrace;
> - =C2=A0 =C2=A0 =C2=A0 __u32 dqi_flags;
> - =C2=A0 =C2=A0 =C2=A0 __u32 dqi_valid;
> -};
> -
> -/*
> - * Definitions for quota netlink interface
> - */
> -#define QUOTA_NL_NOWARN 0
> -#define QUOTA_NL_IHARDWARN 1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* I=
node hardlimit reached */
> -#define QUOTA_NL_ISOFTLONGWARN 2 =C2=A0 =C2=A0 =C2=A0 /* Inode grace=
 time expired */
> -#define QUOTA_NL_ISOFTWARN 3 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* I=
node softlimit reached */
> -#define QUOTA_NL_BHARDWARN 4 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* B=
lock hardlimit reached */
> -#define QUOTA_NL_BSOFTLONGWARN 5 =C2=A0 =C2=A0 =C2=A0 /* Block grace=
 time expired */
> -#define QUOTA_NL_BSOFTWARN 6 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* B=
lock softlimit reached */
> -#define QUOTA_NL_IHARDBELOW 7 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* U=
sage got below inode hardlimit */
> -#define QUOTA_NL_ISOFTBELOW 8 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* U=
sage got below inode softlimit */
> -#define QUOTA_NL_BHARDBELOW 9 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* U=
sage got below block hardlimit */
> -#define QUOTA_NL_BSOFTBELOW 10 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Usage =
got below block softlimit */
> -
> -enum {
> - =C2=A0 =C2=A0 =C2=A0 QUOTA_NL_C_UNSPEC,
> - =C2=A0 =C2=A0 =C2=A0 QUOTA_NL_C_WARNING,
> - =C2=A0 =C2=A0 =C2=A0 __QUOTA_NL_C_MAX,
> -};
> -#define QUOTA_NL_C_MAX (__QUOTA_NL_C_MAX - 1)
> -
> -enum {
> - =C2=A0 =C2=A0 =C2=A0 QUOTA_NL_A_UNSPEC,
> - =C2=A0 =C2=A0 =C2=A0 QUOTA_NL_A_QTYPE,
> - =C2=A0 =C2=A0 =C2=A0 QUOTA_NL_A_EXCESS_ID,
> - =C2=A0 =C2=A0 =C2=A0 QUOTA_NL_A_WARNING,
> - =C2=A0 =C2=A0 =C2=A0 QUOTA_NL_A_DEV_MAJOR,
> - =C2=A0 =C2=A0 =C2=A0 QUOTA_NL_A_DEV_MINOR,
> - =C2=A0 =C2=A0 =C2=A0 QUOTA_NL_A_CAUSED_ID,
> - =C2=A0 =C2=A0 =C2=A0 __QUOTA_NL_A_MAX,
> -};
> -#define QUOTA_NL_A_MAX (__QUOTA_NL_A_MAX - 1)
> -
> -#endif /* _QUOTA_ */
> diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
> index 3f434ca..d46cf28 100644
> --- a/lib/quota/quotaio.c
> +++ b/lib/quota/quotaio.c
> @@ -14,11 +14,12 @@
> =C2=A0#include <sys/types.h>
> =C2=A0#include <sys/stat.h>
> =C2=A0#include <sys/file.h>
> +#include <sys/quota.h>
>
> =C2=A0#include "common.h"
> =C2=A0#include "quotaio.h"
>
> -static const char extensions[MAXQUOTAS + 2][20] =3D INITQFNAMES;
> +static const char * const extensions[MAXQUOTAS] =3D {"user", "group"=
};
> =C2=A0static const char * const basenames[] =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0"", =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /* undefined */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0"quota", =C2=A0 =C2=A0 =C2=A0 =C2=A0/* QFM=
T_VFS_OLD */
> @@ -27,14 +28,6 @@ static const char * const basenames[] =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0"aquota" =C2=A0 =C2=A0 =C2=A0 =C2=A0/* QFM=
T_VFS_V1 */
> =C2=A0};
>
> -static const char * const fmtnames[] =3D {
> - =C2=A0 =C2=A0 =C2=A0 "vfsold",
> - =C2=A0 =C2=A0 =C2=A0 "vfsv0",
> - =C2=A0 =C2=A0 =C2=A0 "vfsv1",
> - =C2=A0 =C2=A0 =C2=A0 "rpc",
> - =C2=A0 =C2=A0 =C2=A0 "xfs"
> -};
> -
> =C2=A0/* Header in all newer quotafiles */
> =C2=A0struct disk_dqheader {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0u_int32_t dqh_magic;
> @@ -65,7 +58,6 @@ const char *quota_get_qf_name(int type, int fmt, ch=
ar *buf)
> =C2=A0const char *quota_get_qf_path(const char *mntpt, int qtype, int=
 fmt,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0char *path_buf, size_t path_buf_size=
)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 struct stat =C2=A0 =C2=A0 qf_stat;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0char qf_name[QUOTA_NAME_LEN];
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!mntpt || !path_buf || !path_buf_size)
> diff --git a/lib/quota/quotaio.h b/lib/quota/quotaio.h
> index 91a1ff2..5a7db7b 100644
> --- a/lib/quota/quotaio.h
> +++ b/lib/quota/quotaio.h
> @@ -12,13 +12,33 @@
> =C2=A0#include <sys/stat.h>
>
> =C2=A0#include "ext2fs/ext2fs.h"
> -#include "quota.h"
> =C2=A0#include "dqblk_v2.h"
>
> +typedef int64_t qsize_t; =C2=A0 =C2=A0 =C2=A0 /* Type in which we st=
ore size limitations */
> +
> +#define MAXQUOTAS 2
> +#define USRQUOTA 0
> +#define GRPQUOTA 1
> +
> +/*
> + * Definitions of magics and versions of current quota files
> + */
> +#define INITQMAGICS {\
> + =C2=A0 =C2=A0 =C2=A0 0xd9c01f11, =C2=A0 =C2=A0 /* USRQUOTA */\
> + =C2=A0 =C2=A0 =C2=A0 0xd9c01927 =C2=A0 =C2=A0 =C2=A0/* GRPQUOTA */\
> +}
> +
> +/* Size of blocks in which are counted size limits in generic utilit=
y parts */
> +#define QUOTABLOCK_BITS 10
> +#define QUOTABLOCK_SIZE (1 << QUOTABLOCK_BITS)
> +#define toqb(x) (((x) + QUOTABLOCK_SIZE - 1) >> QUOTABLOCK_BITS)
> +
> +/* Quota format type IDs */
> +#define =C2=A0 =C2=A0 =C2=A0 =C2=A0QFMT_VFS_OLD 1
> +#define =C2=A0 =C2=A0 =C2=A0 =C2=A0QFMT_VFS_V0 2
> +#define =C2=A0 =C2=A0 =C2=A0 =C2=A0QFMT_VFS_V1 4
> +
> =C2=A0/*
> - * Definitions for disk quotas imposed on the average user
> - * (big brother finally hits Linux).
> - *
> =C2=A0* The following constants define the default amount of time giv=
en a user
> =C2=A0* before the soft limits are treated as hard limits (usually re=
sulting
> =C2=A0* in an allocation failure). The timer is started when the user=
 crosses
> @@ -27,11 +47,7 @@
> =C2=A0#define MAX_IQ_TIME =C2=A0604800 =C2=A0 =C2=A0/* (7*24*60*60) 1=
 week */
> =C2=A0#define MAX_DQ_TIME =C2=A0604800 =C2=A0 =C2=A0/* (7*24*60*60) 1=
 week */
>
> -#define IOFL_QUOTAON =C2=A0 0x01 =C2=A0 =C2=A0/* Is quota enabled in=
 kernel? */
> -#define IOFL_INFODIRTY 0x02 =C2=A0 =C2=A0/* Did info change? */
> -#define IOFL_RO =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00x04 =C2=A0 =C2=A0/* Just RO access? */
> -#define IOFL_NFS_MIXED_PATHS =C2=A0 0x08 =C2=A0 =C2=A0/* Should we t=
rim leading slashes
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0from NFSv4 mountpoints? */
> +#define IOFL_INFODIRTY 0x01 =C2=A0 =C2=A0/* Did info change? */
>
> =C2=A0struct quotafile_ops;
>
> @@ -64,19 +80,6 @@ struct quota_handle {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct util_dqinfo qh_info; =C2=A0 =C2=A0 =
/* Generic quotafile info */
> =C2=A0};
>
> -/* Statistics gathered from kernel */
> -struct util_dqstats {
> - =C2=A0 =C2=A0 =C2=A0 u_int32_t lookups;
> - =C2=A0 =C2=A0 =C2=A0 u_int32_t drops;
> - =C2=A0 =C2=A0 =C2=A0 u_int32_t reads;
> - =C2=A0 =C2=A0 =C2=A0 u_int32_t writes;
> - =C2=A0 =C2=A0 =C2=A0 u_int32_t cache_hits;
> - =C2=A0 =C2=A0 =C2=A0 u_int32_t allocated_dquots;
> - =C2=A0 =C2=A0 =C2=A0 u_int32_t free_dquots;
> - =C2=A0 =C2=A0 =C2=A0 u_int32_t syncs;
> - =C2=A0 =C2=A0 =C2=A0 u_int32_t version;
> -};
> -
> =C2=A0/* Utility quota block */
> =C2=A0struct util_dqblk {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0qsize_t dqb_ihardlimit;
> @@ -134,9 +137,6 @@ static inline void mark_quotafile_info_dirty(stru=
ct quota_handle *h)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0h->qh_io_flags |=3D IOFL_INFODIRTY;
> =C2=A0}
>
> -#define QIO_ENABLED(h) ((h)->qh_io_flags & IOFL_QUOTAON)
> -#define QIO_RO(h) =C2=A0 =C2=A0 =C2=A0((h)->qh_io_flags & IOFL_RO)
> -
> =C2=A0/* Open existing quotafile of given type (and verify its format=
) on given
> =C2=A0* filesystem. */
> =C2=A0errcode_t quota_file_open(struct quota_handle *h, ext2_filsys f=
s,
> diff --git a/lib/quota/quotaio_tree.h b/lib/quota/quotaio_tree.h
> index 37c15ce..6ee54c9 100644
> --- a/lib/quota/quotaio_tree.h
> +++ b/lib/quota/quotaio_tree.h
> @@ -6,7 +6,8 @@
> =C2=A0#define _LINUX_QUOTA_TREE_H
>
> =C2=A0#include <sys/types.h>
> -#include "quota.h"
> +
> +typedef u_int32_t qid_t; =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Type in which=
 we store ids in memory */
>
> =C2=A0#define QT_TREEOFF =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 /* Offs=
et of tree in file in blocks */
> =C2=A0#define QT_TREEDEPTH =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 /* Depth of =
quota tree */
> diff --git a/lib/quota/quotaio_v2.c b/lib/quota/quotaio_v2.c
> index e658706..f8d553b 100644
> --- a/lib/quota/quotaio_v2.c
> +++ b/lib/quota/quotaio_v2.c
> @@ -18,8 +18,6 @@
> =C2=A0#include "quotaio.h"
> =C2=A0#include "quotaio_tree.h"
>
> -typedef char *dqbuf_t;
> -
> =C2=A0static int v2_check_file(struct quota_handle *h, int type, int =
fmt);
> =C2=A0static int v2_init_io(struct quota_handle *h);
> =C2=A0static int v2_new_io(struct quota_handle *h);
> @@ -43,9 +41,6 @@ struct quotafile_ops quotafile_ops_2 =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.report =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D v2=
_report,
> =C2=A0};
>
> -#define getdqbuf() smalloc(V2_DQBLKSIZE)
> -#define freedqbuf(buf) free(buf)
> -
> =C2=A0/*
> =C2=A0* Copy dquot from disk to memory
> =C2=A0*/
> @@ -140,34 +135,6 @@ static inline void v2_mem2diskdqinfo(struct v2_d=
isk_dqinfo *d,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext2fs_cpu_to_=
le32(m->u.v2_mdqi.dqi_qtree.dqi_free_entry);
> =C2=A0}
>
> -/* Convert kernel quotablock format to utility one */
> -static inline void v2_kern2utildqblk(struct util_dqblk *u,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct v2_kern_=
dqblk *k)
> -{
> - =C2=A0 =C2=A0 =C2=A0 u->dqb_ihardlimit =3D k->dqb_ihardlimit;
> - =C2=A0 =C2=A0 =C2=A0 u->dqb_isoftlimit =3D k->dqb_isoftlimit;
> - =C2=A0 =C2=A0 =C2=A0 u->dqb_bhardlimit =3D k->dqb_bhardlimit;
> - =C2=A0 =C2=A0 =C2=A0 u->dqb_bsoftlimit =3D k->dqb_bsoftlimit;
> - =C2=A0 =C2=A0 =C2=A0 u->dqb_curinodes =3D k->dqb_curinodes;
> - =C2=A0 =C2=A0 =C2=A0 u->dqb_curspace =3D k->dqb_curspace;
> - =C2=A0 =C2=A0 =C2=A0 u->dqb_itime =3D k->dqb_itime;
> - =C2=A0 =C2=A0 =C2=A0 u->dqb_btime =3D k->dqb_btime;
> -}
> -
> -/* Convert utility quotablock format to kernel one */
> -static inline void v2_util2kerndqblk(struct v2_kern_dqblk *k,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct util_dqb=
lk *u)
> -{
> - =C2=A0 =C2=A0 =C2=A0 k->dqb_ihardlimit =3D u->dqb_ihardlimit;
> - =C2=A0 =C2=A0 =C2=A0 k->dqb_isoftlimit =3D u->dqb_isoftlimit;
> - =C2=A0 =C2=A0 =C2=A0 k->dqb_bhardlimit =3D u->dqb_bhardlimit;
> - =C2=A0 =C2=A0 =C2=A0 k->dqb_bsoftlimit =3D u->dqb_bsoftlimit;
> - =C2=A0 =C2=A0 =C2=A0 k->dqb_curinodes =3D u->dqb_curinodes;
> - =C2=A0 =C2=A0 =C2=A0 k->dqb_curspace =3D u->dqb_curspace;
> - =C2=A0 =C2=A0 =C2=A0 k->dqb_itime =3D u->dqb_itime;
> - =C2=A0 =C2=A0 =C2=A0 k->dqb_btime =3D u->dqb_btime;
> -}
> -
> =C2=A0static int v2_read_header(struct quota_handle *h, struct v2_dis=
k_dqheader *dqh)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (h->e2fs_read(&h->qh_qf, 0, dqh, sizeof=
(struct v2_disk_dqheader)) !=3D
> @@ -184,16 +151,11 @@ static int v2_check_file(struct quota_handle *h=
, int type, int fmt)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct v2_disk_dqheader dqh;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int file_magics[] =3D INITQMAGICS;
> - =C2=A0 =C2=A0 =C2=A0 int known_versions[] =3D INIT_V2_VERSIONS;
> - =C2=A0 =C2=A0 =C2=A0 int version;
>
> - =C2=A0 =C2=A0 =C2=A0 if (!v2_read_header(h, &dqh))
> + =C2=A0 =C2=A0 =C2=A0 if (fmt !=3D QFMT_VFS_V1)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> - =C2=A0 =C2=A0 =C2=A0 if (fmt =3D=3D QFMT_VFS_V0)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 version =3D 0;
> - =C2=A0 =C2=A0 =C2=A0 else if (fmt =3D=3D QFMT_VFS_V1)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 version =3D 1;
> - =C2=A0 =C2=A0 =C2=A0 else
> +
> + =C2=A0 =C2=A0 =C2=A0 if (!v2_read_header(h, &dqh))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ext2fs_le32_to_cpu(dqh.dqh_magic) !=3D=
 file_magics[type]) {
> @@ -202,9 +164,7 @@ static int v2_check_file(struct quota_handle *h, =
int type, int fmt)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"endianity.", "");
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> - =C2=A0 =C2=A0 =C2=A0 if (ext2fs_le32_to_cpu(dqh.dqh_version) > know=
n_versions[type])
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> - =C2=A0 =C2=A0 =C2=A0 if (version !=3D ext2fs_le32_to_cpu(dqh.dqh_ve=
rsion))
> + =C2=A0 =C2=A0 =C2=A0 if (V2_VERSION !=3D ext2fs_le32_to_cpu(dqh.dqh=
_version))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;
> =C2=A0}
> @@ -236,14 +196,13 @@ static int v2_new_io(struct quota_handle *h)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int file_magics[] =3D INITQMAGICS;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct v2_disk_dqheader ddqheader;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct v2_disk_dqinfo ddqinfo;
> - =C2=A0 =C2=A0 =C2=A0 int version =3D 1;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (h->qh_fmt !=3D QFMT_VFS_V1)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -1;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Write basic quota header */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ddqheader.dqh_magic =3D ext2fs_cpu_to_le32=
(file_magics[h->qh_type]);
> - =C2=A0 =C2=A0 =C2=A0 ddqheader.dqh_version =3D ext2fs_cpu_to_le32(v=
ersion);
> + =C2=A0 =C2=A0 =C2=A0 ddqheader.dqh_version =3D ext2fs_cpu_to_le32(V=
2_VERSION);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (h->e2fs_write(&h->qh_qf, 0, &ddqheader=
, sizeof(ddqheader)) !=3D
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0sizeof(ddqheader))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -1;
> diff --git a/lib/quota/quotaio_v2.h b/lib/quota/quotaio_v2.h
> index 072e36f..0bb4363 100644
> --- a/lib/quota/quotaio_v2.h
> +++ b/lib/quota/quotaio_v2.h
> @@ -8,11 +8,12 @@
> =C2=A0#define GUARD_QUOTAIO_V2_H
>
> =C2=A0#include <sys/types.h>
> -#include "quota.h"
> +#include "quotaio.h"
>
> =C2=A0/* Offset of info header in file */
> =C2=A0#define V2_DQINFOOFF =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sizeof(=
struct v2_disk_dqheader)
> -#define INIT_V2_VERSIONS =C2=A0 =C2=A0 =C2=A0 { 1, 1}
> +/* Supported version of quota-tree format */
> +#define V2_VERSION 1
>
> =C2=A0struct v2_disk_dqheader {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0u_int32_t dqh_magic; =C2=A0 =C2=A0/* Magic=
 number identifying file */
> @@ -35,21 +36,6 @@ struct v2_disk_dqinfo {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
* free entry */
> =C2=A0} __attribute__ ((packed));
>
> -/* Structure of quota for one user on disk */
> -struct v2r0_disk_dqblk {
> - =C2=A0 =C2=A0 =C2=A0 u_int32_t dqb_id; =C2=A0 =C2=A0 =C2=A0 /* id t=
his quota applies to */
> - =C2=A0 =C2=A0 =C2=A0 u_int32_t dqb_ihardlimit; =C2=A0 =C2=A0 =C2=A0=
 /* absolute limit on allocated inodes */
> - =C2=A0 =C2=A0 =C2=A0 u_int32_t dqb_isoftlimit; =C2=A0 =C2=A0 =C2=A0=
 /* preferred inode limit */
> - =C2=A0 =C2=A0 =C2=A0 u_int32_t dqb_curinodes; =C2=A0 =C2=A0 =C2=A0 =
=C2=A0/* current # allocated inodes */
> - =C2=A0 =C2=A0 =C2=A0 u_int32_t dqb_bhardlimit; =C2=A0 =C2=A0 =C2=A0=
 /* absolute limit on disk space
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*=
 (in QUOTABLOCK_SIZE) */
> - =C2=A0 =C2=A0 =C2=A0 u_int32_t dqb_bsoftlimit; =C2=A0 =C2=A0 =C2=A0=
 /* preferred limit on disk space
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*=
 (in QUOTABLOCK_SIZE) */
> - =C2=A0 =C2=A0 =C2=A0 u_int64_t dqb_curspace; /* current space occup=
ied (in bytes) */
> - =C2=A0 =C2=A0 =C2=A0 u_int64_t dqb_btime; =C2=A0 =C2=A0/* time limi=
t for excessive disk use */
> - =C2=A0 =C2=A0 =C2=A0 u_int64_t dqb_itime; =C2=A0 =C2=A0/* time limi=
t for excessive inode use */
> -} __attribute__ ((packed));
> -
> =C2=A0struct v2r1_disk_dqblk {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0u_int32_t dqb_id; =C2=A0 =C2=A0 =C2=A0 /* =
id this quota applies to */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0u_int32_t dqb_pad;
> @@ -65,39 +51,4 @@ struct v2r1_disk_dqblk {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0u_int64_t dqb_itime; =C2=A0 =C2=A0/* time =
limit for excessive inode use */
> =C2=A0} __attribute__ ((packed));
>
> -/* Structure of quota for communication with kernel */
> -struct v2_kern_dqblk {
> - =C2=A0 =C2=A0 =C2=A0 unsigned int dqb_ihardlimit;
> - =C2=A0 =C2=A0 =C2=A0 unsigned int dqb_isoftlimit;
> - =C2=A0 =C2=A0 =C2=A0 unsigned int dqb_curinodes;
> - =C2=A0 =C2=A0 =C2=A0 unsigned int dqb_bhardlimit;
> - =C2=A0 =C2=A0 =C2=A0 unsigned int dqb_bsoftlimit;
> - =C2=A0 =C2=A0 =C2=A0 qsize_t dqb_curspace;
> - =C2=A0 =C2=A0 =C2=A0 time_t dqb_btime;
> - =C2=A0 =C2=A0 =C2=A0 time_t dqb_itime;
> -};
> -
> -/* Structure of quotafile info for communication with kernel (obsole=
te) */
> -struct v2_kern_dqinfo {
> - =C2=A0 =C2=A0 =C2=A0 unsigned int dqi_bgrace;
> - =C2=A0 =C2=A0 =C2=A0 unsigned int dqi_igrace;
> - =C2=A0 =C2=A0 =C2=A0 unsigned int dqi_flags;
> - =C2=A0 =C2=A0 =C2=A0 unsigned int dqi_blocks;
> - =C2=A0 =C2=A0 =C2=A0 unsigned int dqi_free_blk;
> - =C2=A0 =C2=A0 =C2=A0 unsigned int dqi_free_entry;
> -};
> -
> -/* Structure with gathered statistics from kernel */
> -struct v2_dqstats {
> - =C2=A0 =C2=A0 =C2=A0 u_int32_t lookups;
> - =C2=A0 =C2=A0 =C2=A0 u_int32_t drops;
> - =C2=A0 =C2=A0 =C2=A0 u_int32_t reads;
> - =C2=A0 =C2=A0 =C2=A0 u_int32_t writes;
> - =C2=A0 =C2=A0 =C2=A0 u_int32_t cache_hits;
> - =C2=A0 =C2=A0 =C2=A0 u_int32_t allocated_dquots;
> - =C2=A0 =C2=A0 =C2=A0 u_int32_t free_dquots;
> - =C2=A0 =C2=A0 =C2=A0 u_int32_t syncs;
> - =C2=A0 =C2=A0 =C2=A0 u_int32_t version;
> -};
> -
> =C2=A0#endif
> --
> 1.7.1
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
