From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH 1/5] e2fsprogs: add quota library to e2fsprogs
Date: Fri, 9 Sep 2011 20:31:16 -0700
Message-ID: <CAGr1F2GTi8zn_k+3QiTv7DAFuGCLtg+4Lw4XPeud9oJvKtPvnA@mail.gmail.com>
References: <1311187206-30553-1-git-send-email-adityakali@google.com>
 <1311187206-30553-2-git-send-email-adityakali@google.com> <41DB1BDB-3EC2-4DA2-BF48-3E024F0C1981@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:12880 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736Ab1IJDbl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Sep 2011 23:31:41 -0400
Received: from hpaq7.eem.corp.google.com (hpaq7.eem.corp.google.com [172.25.149.7])
	by smtp-out.google.com with ESMTP id p8A3VdmT012655
	for <linux-ext4@vger.kernel.org>; Fri, 9 Sep 2011 20:31:40 -0700
Received: from pzk32 (pzk32.prod.google.com [10.243.19.160])
	by hpaq7.eem.corp.google.com with ESMTP id p8A3VbdX021213
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Fri, 9 Sep 2011 20:31:38 -0700
Received: by pzk32 with SMTP id 32so3772211pzk.5
        for <linux-ext4@vger.kernel.org>; Fri, 09 Sep 2011 20:31:37 -0700 (PDT)
In-Reply-To: <41DB1BDB-3EC2-4DA2-BF48-3E024F0C1981@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for the feedback. I will fix all the issues pointed out here.

On Fri, Sep 9, 2011 at 3:53 PM, Andreas Dilger <adilger@dilger.ca> wrot=
e:
> On 2011-07-20, at 12:40 PM, Aditya Kali wrote:
>> This patch adds the quota library (ported form Jan Kara's quota-tool=
s) in
>> e2fsprogs in order to make quotas as a first class supported feature=
 in Ext4.
>> This patch also provides interface in lib/quota/mkquota.h that will =
be used by
>> mke2fs, tune2fs, e2fsck, etc. to initialize and update quota files.
>> This first version of the quota library does not support reading exi=
sting quota
>> files. This support will be added in the near future.
>> Thanks to Jan Kara for his work on quota-tools. Most of the files in=
 this patch
>> are taken as-is from quota tools and were simply modified to work wi=
th
>> libext2fs in e2fsprogs.
>
> Some minor notes on this patch.
>
>>
>> +void *smalloc(size_t size)
>> +{
>> + =C2=A0 =C2=A0 void *ret =3D malloc(size);
>> +
>> + =C2=A0 =C2=A0 if (!ret) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fputs("Not enough memory=
=2E\n", stderr);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(3);
>
> Libraries that call exit() instead of handling/returning an error are=
 evil.
> This should return NULL and handle the error, probably just passing i=
t up
> the chain to the caller.

Will fix.

>
>> + =C2=A0 =C2=A0 }
>> + =C2=A0 =C2=A0 return ret;
>> +}
>> +
>> +void *srealloc(void *ptr, size_t size)
>> +{
>> + =C2=A0 =C2=A0 void *ret =3D realloc(ptr, size);
>> +
>> + =C2=A0 =C2=A0 if (!ret) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fputs("Not enough memory=
=2E\n", stderr);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(3);
>> + =C2=A0 =C2=A0 }
>> + =C2=A0 =C2=A0 return ret;
>> +}
>
> These would be better if they used the ext2fs_get_mem() and ext2fs_fr=
ee_mem()
> wrappers.
>
Will do. I will also remove the exit() calls.

>> +void sstrncpy(char *d, const char *s, size_t len)
>> +{
>> + =C2=A0 =C2=A0 strncpy(d, s, len);
>> + =C2=A0 =C2=A0 d[len - 1] =3D 0;
>> +}
>> +
>> +void sstrncat(char *d, const char *s, size_t len)
>> +{
>> + =C2=A0 =C2=A0 strncat(d, s, len);
>> + =C2=A0 =C2=A0 d[len - 1] =3D 0;
>> +}
>> +
>> +char *sstrdup(const char *s)
>> +{
>> + =C2=A0 =C2=A0 char *r =3D strdup(s);
>> +
>> + =C2=A0 =C2=A0 if (!r) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 puts("Not enough memory.=
");
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(3);
>
> Evil!
>
>> + =C2=A0 =C2=A0 }
>> + =C2=A0 =C2=A0 return r;
>> +}
>> +
>> diff --git a/lib/quota/common.h b/lib/quota/common.h
>> new file mode 100644
>> index 0000000..48f191f
>> --- /dev/null
>> +++ b/lib/quota/common.h
>> @@ -0,0 +1,78 @@
>> +/*
>> + *
>> + * =C2=A0 Various things common for all utilities
>> + *
>> + */
>> +
>> +#ifndef __QUOTA_COMMON_H__
>> +#define __QUOTA_COMMON_H__
>> +
>> +#ifndef __attribute__
>> +# if !defined __GNUC__ || __GNUC__ < 2 || (__GNUC__ =3D=3D 2 && __G=
NUC_MINOR__ < 8) || __STRICT_ANSI__
>> +# =C2=A0define __attribute__(x)
>> +# endif
>> +#endif
>> +
>> +#ifdef ENABLE_NLS
>> +#include <libintl.h>
>> +#include <locale.h>
>> +#define _(a) (gettext (a))
>> +#ifdef gettext_noop
>> +#define N_(a) gettext_noop (a)
>> +#else
>> +#define N_(a) (a)
>> +#endif
>> +#define P_(singular, plural, n) (ngettext (singular, plural, n))
>> +#ifndef NLS_CAT_NAME
>> +#define NLS_CAT_NAME "e2fsprogs"
>> +#endif
>> +#ifndef LOCALEDIR
>> +#define LOCALEDIR "/usr/share/locale"
>> +#endif
>> +#else
>> +#define _(a) (a)
>> +#define N_(a) a
>> +#define P_(singular, plural, n) ((n) =3D=3D 1 ? (singular) : (plura=
l))
>> +#endif
>> +
>> +#define log_fatal(exit_code, format, ...) =C2=A0 =C2=A0do { \
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(stderr, _("[FATA=
L] %s:%d:%s:: " format "\n"), \
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 __FILE__, __LINE__, __func__, __VA_ARGS__); \
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(exit_code); \
>> + =C2=A0 =C2=A0 } while (0)
>> +
>> +#define log_err(format, ...) fprintf(stderr, \
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 _("[ERROR] %s:%d:%s:: " format "\n"), \
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __FILE__, __LINE__, __func__, __VA_ARGS=
__)
>> +
>> +#ifdef DEBUG_QUOTA
>> +# define log_debug(format, ...) =C2=A0 =C2=A0 =C2=A0fprintf(stderr,=
 \
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 _("[DEBUG] %s:%d:%s:: " format "\n"), \
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __FILE__, __LINE__, __func__, __VA_ARGS=
__)
>> +#else
>> +# define log_debug(format, ...)
>> +#endif
>> +
>> +#define BUG_ON(x) =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0do { if =
((x)) { \
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(std=
err, \
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 _("BUG_ON: %s:%d:: ##x"), \
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 __FILE__, __LINE__); \
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(2); \
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } } while (0)
>> +
>> +/* malloc() with error check */
>> +void *smalloc(size_t);
>> +
>> +/* realloc() with error check */
>> +void *srealloc(void *, size_t);
>> +
>> +/* Safe strncpy - always finishes string */
>> +void sstrncpy(char *, const char *, size_t);
>> +
>> +/* Safe strncat - always finishes string */
>> +void sstrncat(char *, const char *, size_t);
>> +
>> +/* Safe version of strdup() */
>> +char *sstrdup(const char *s);
>> +
>> +#endif /* __QUOTA_COMMON_H__ */
>> diff --git a/lib/quota/dqblk_v2.h b/lib/quota/dqblk_v2.h
>> new file mode 100644
>> index 0000000..ca07902
>> --- /dev/null
>> +++ b/lib/quota/dqblk_v2.h
>> @@ -0,0 +1,43 @@
>> +/*
>> + * Header file for disk format of new quotafile format
>> + *
>> + * Jan Kara <jack@suse.cz> - sponsored by SuSE CR
>> + */
>> +
>> +#ifndef __QUOTA_DQBLK_V2_H__
>> +#define __QUOTA_DQBLK_V2_H__
>> +
>> +#include <sys/types.h>
>> +#include "quotaio_tree.h"
>> +
>> +#define Q_V2_GETQUOTA =C2=A0 =C2=A0 =C2=A0 =C2=A00x0D00 =C2=A0/* Ge=
t limits and usage */
>> +#define Q_V2_SETQUOTA =C2=A0 =C2=A0 =C2=A0 =C2=A00x0E00 =C2=A0/* Se=
t limits and usage */
>> +#define Q_V2_SETUSE =C2=A00x0F00 =C2=A0/* Set only usage */
>> +#define Q_V2_SETQLIM 0x0700 =C2=A0/* Set only limits */
>> +#define Q_V2_GETINFO 0x0900 =C2=A0/* Get information about quota */
>> +#define Q_V2_SETINFO 0x0A00 =C2=A0/* Set information about quota */
>> +#define Q_V2_SETGRACE =C2=A0 =C2=A0 =C2=A0 =C2=A00x0B00 =C2=A0/* Se=
t just grace times in quotafile
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* information */
>> +#define Q_V2_SETFLAGS =C2=A0 =C2=A0 =C2=A0 =C2=A00x0C00 =C2=A0/* Se=
t just flags in quotafile information */
>> +#define Q_V2_GETSTATS =C2=A0 =C2=A0 =C2=A0 =C2=A00x1100 =C2=A0/* ge=
t collected stats (before proc was used) */
>> +
>> +/* Structure for format specific information */
>> +struct v2_mem_dqinfo {
>> + =C2=A0 =C2=A0 struct qtree_mem_dqinfo dqi_qtree;
>> + =C2=A0 =C2=A0 uint dqi_flags; =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Flags=
 set in quotafile */
>> + =C2=A0 =C2=A0 uint dqi_used_entries; =C2=A0/* Number of entries in=
 file -
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0updated by scan_dquots */
>> + =C2=A0 =C2=A0 uint dqi_data_blocks; =C2=A0 /* Number of data block=
s in file -
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0updated by scan_dquots */
>> +};
>> +
>> +struct v2_mem_dqblk {
>> + =C2=A0 =C2=A0 loff_t dqb_off; =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Offse=
t of dquot in file */
>> +};
>> +
>> +struct quotafile_ops; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0/* Will be defined later in quotaio.h */
>> +
>> +/* Operations above this format */
>> +extern struct quotafile_ops quotafile_ops_2;
>> +
>> +#endif =C2=A0/* __QUOTA_DQBLK_V2_H__ */
>> diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
>> new file mode 100644
>> index 0000000..cbc76f7
>> --- /dev/null
>> +++ b/lib/quota/mkquota.c
>> @@ -0,0 +1,400 @@
>> +/*
>> + * mkquota.c --- create quota files for a filesystem
>> + *
>> + * Aditya Kali <adityakali@google.com>
>
> Did you write this code, or is it a port from Jan's tools? =C2=A0I'm =
not being
> critical, just trying to ensure that credit is given where it is due.
>
Yes. All the quota* files in this patch are taken from Jan's
quota-tools. But I wrote the mkquota.c and mkquota.h files to provide
an interface that e2fsprogs tools can use. Some of the design here was
inspired from Ted Ts'o initial unpublished prototype. I will
appropriately add comments and attribution for credit.

>> +static void print_inode(struct ext2_inode *inode)
>> +{
>> + =C2=A0 =C2=A0 if (!inode)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>> +
>> + =C2=A0 =C2=A0 fprintf(stderr, " =C2=A0i_mode =3D %d\n", inode->i_m=
ode);
>> + =C2=A0 =C2=A0 fprintf(stderr, " =C2=A0i_uid =3D %d\n", inode->i_ui=
d);
>> + =C2=A0 =C2=A0 fprintf(stderr, " =C2=A0i_size =3D %d\n", inode->i_s=
ize);
>> + =C2=A0 =C2=A0 fprintf(stderr, " =C2=A0i_atime =3D %d\n", inode->i_=
atime);
>> + =C2=A0 =C2=A0 fprintf(stderr, " =C2=A0i_ctime =3D %d\n", inode->i_=
ctime);
>> + =C2=A0 =C2=A0 fprintf(stderr, " =C2=A0i_mtime =3D %d\n", inode->i_=
mtime);
>> + =C2=A0 =C2=A0 fprintf(stderr, " =C2=A0i_dtime =3D %d\n", inode->i_=
dtime);
>> + =C2=A0 =C2=A0 fprintf(stderr, " =C2=A0i_gid =3D %d\n", inode->i_gi=
d);
>> + =C2=A0 =C2=A0 fprintf(stderr, " =C2=A0i_links_count =3D %d\n", ino=
de->i_links_count);
>> + =C2=A0 =C2=A0 fprintf(stderr, " =C2=A0i_blocks =3D %d\n", inode->i=
_blocks);
>> + =C2=A0 =C2=A0 fprintf(stderr, " =C2=A0i_flags =3D %d\n", inode->i_=
flags);
>> +
>> + =C2=A0 =C2=A0 return;
>> +}
>> +
>> +int is_quota_on(ext2_filsys fs, int type)
>
> It would be better if all of these function names all started with qu=
ota_
> for consistency and to avoid namespace pollution, like quota_is_on().
> That is critical for functions and macros that are exported from this
> library, but also useful for internal functions because it makes it c=
lear
> that the function is part of the library.
>
Will do.

>> @@ -0,0 +1,66 @@
>> +/** mkquota.h
>> + *
>> + * Interface to the quota library.
>> + *
>> + * This initial version does not support reading the quota files. T=
his support
>> + * will be added in near future.
>> + *
>> + * Aditya Kali <adityakali@google.com>
>
> Likewise, if this is based on Jan's library it needs proper attributi=
on.
>
This is not from Jan's library.

>> +/*
>> + * Detect quota format and initialize quota IO
>> + */
>> +struct quota_handle *init_io(ext2_filsys fs, const char *mntpt, int=
 type,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0int fmt, int flags)
>> +{
>> + =C2=A0 =C2=A0 log_err("Not Implemented.", "");
>> + =C2=A0 =C2=A0 BUG_ON(1);
>> + =C2=A0 =C2=A0 return NULL;
>> +}
>
> This is confusing, and as mentioned earlier it is evil to exit instea=
d
> of returning an error to the caller.
>
>> +/*
>> + * Create new quotafile of specified format on given filesystem
>> + */
>> +int new_io(struct quota_handle *h, ext2_filsys fs, int type, int fm=
t)
>> +{
>
> This is a bad function name, since it doesn't at all describe what th=
e
> function is doing. =C2=A0Something like quota_file_create() would be =
much
> better.
>
Will fix.

>> +/*
>> + * Close quotafile and release handle
>> + */
>> +int end_io(struct quota_handle *h)
>> +{
>
> Similarly, quota_file_close() would be a much better name for this.
>
Will do.

>
> Cheers, Andreas
>
>
>
>
>
>

--
Aditya
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
