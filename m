From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/5] e2fsprogs: add quota library to e2fsprogs
Date: Fri, 9 Sep 2011 16:53:38 -0600
Message-ID: <41DB1BDB-3EC2-4DA2-BF48-3E024F0C1981@dilger.ca>
References: <1311187206-30553-1-git-send-email-adityakali@google.com> <1311187206-30553-2-git-send-email-adityakali@google.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:42886 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759098Ab1IIWxl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Sep 2011 18:53:41 -0400
In-Reply-To: <1311187206-30553-2-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-07-20, at 12:40 PM, Aditya Kali wrote:
> This patch adds the quota library (ported form Jan Kara's quota-tools) in
> e2fsprogs in order to make quotas as a first class supported feature in Ext4.
> This patch also provides interface in lib/quota/mkquota.h that will be used by
> mke2fs, tune2fs, e2fsck, etc. to initialize and update quota files.
> This first version of the quota library does not support reading existing quota
> files. This support will be added in the near future.
> Thanks to Jan Kara for his work on quota-tools. Most of the files in this patch
> are taken as-is from quota tools and were simply modified to work with
> libext2fs in e2fsprogs.

Some minor notes on this patch.

> 
> +void *smalloc(size_t size)
> +{
> +	void *ret = malloc(size);
> +
> +	if (!ret) {
> +		fputs("Not enough memory.\n", stderr);
> +		exit(3);

Libraries that call exit() instead of handling/returning an error are evil.
This should return NULL and handle the error, probably just passing it up
the chain to the caller.

> +	}
> +	return ret;
> +}
> +
> +void *srealloc(void *ptr, size_t size)
> +{
> +	void *ret = realloc(ptr, size);
> +
> +	if (!ret) {
> +		fputs("Not enough memory.\n", stderr);
> +		exit(3);
> +	}
> +	return ret;
> +}

These would be better if they used the ext2fs_get_mem() and ext2fs_free_mem()
wrappers.

> +void sstrncpy(char *d, const char *s, size_t len)
> +{
> +	strncpy(d, s, len);
> +	d[len - 1] = 0;
> +}
> +
> +void sstrncat(char *d, const char *s, size_t len)
> +{
> +	strncat(d, s, len);
> +	d[len - 1] = 0;
> +}
> +
> +char *sstrdup(const char *s)
> +{
> +	char *r = strdup(s);
> +
> +	if (!r) {
> +		puts("Not enough memory.");
> +		exit(3);

Evil!

> +	}
> +	return r;
> +}
> +
> diff --git a/lib/quota/common.h b/lib/quota/common.h
> new file mode 100644
> index 0000000..48f191f
> --- /dev/null
> +++ b/lib/quota/common.h
> @@ -0,0 +1,78 @@
> +/*
> + *
> + *	Various things common for all utilities
> + *
> + */
> +
> +#ifndef __QUOTA_COMMON_H__
> +#define __QUOTA_COMMON_H__
> +
> +#ifndef __attribute__
> +# if !defined __GNUC__ || __GNUC__ < 2 || (__GNUC__ == 2 && __GNUC_MINOR__ < 8) || __STRICT_ANSI__
> +#  define __attribute__(x)
> +# endif
> +#endif
> +
> +#ifdef ENABLE_NLS
> +#include <libintl.h>
> +#include <locale.h>
> +#define _(a) (gettext (a))
> +#ifdef gettext_noop
> +#define N_(a) gettext_noop (a)
> +#else
> +#define N_(a) (a)
> +#endif
> +#define P_(singular, plural, n) (ngettext (singular, plural, n))
> +#ifndef NLS_CAT_NAME
> +#define NLS_CAT_NAME "e2fsprogs"
> +#endif
> +#ifndef LOCALEDIR
> +#define LOCALEDIR "/usr/share/locale"
> +#endif
> +#else
> +#define _(a) (a)
> +#define N_(a) a
> +#define P_(singular, plural, n) ((n) == 1 ? (singular) : (plural))
> +#endif
> +
> +#define log_fatal(exit_code, format, ...)	do { \
> +		fprintf(stderr, _("[FATAL] %s:%d:%s:: " format "\n"), \
> +			__FILE__, __LINE__, __func__, __VA_ARGS__); \
> +		exit(exit_code); \
> +	} while (0)
> +
> +#define log_err(format, ...)	fprintf(stderr, \
> +				_("[ERROR] %s:%d:%s:: " format "\n"), \
> +				__FILE__, __LINE__, __func__, __VA_ARGS__)
> +
> +#ifdef DEBUG_QUOTA
> +# define log_debug(format, ...)	fprintf(stderr, \
> +				_("[DEBUG] %s:%d:%s:: " format "\n"), \
> +				__FILE__, __LINE__, __func__, __VA_ARGS__)
> +#else
> +# define log_debug(format, ...)
> +#endif
> +
> +#define BUG_ON(x)		do { if ((x)) { \
> +					fprintf(stderr, \
> +						_("BUG_ON: %s:%d:: ##x"), \
> +						__FILE__, __LINE__); \
> +					exit(2); \
> +				} } while (0)
> +
> +/* malloc() with error check */
> +void *smalloc(size_t);
> +
> +/* realloc() with error check */
> +void *srealloc(void *, size_t);
> +
> +/* Safe strncpy - always finishes string */
> +void sstrncpy(char *, const char *, size_t);
> +
> +/* Safe strncat - always finishes string */
> +void sstrncat(char *, const char *, size_t);
> +
> +/* Safe version of strdup() */
> +char *sstrdup(const char *s);
> +
> +#endif /* __QUOTA_COMMON_H__ */
> diff --git a/lib/quota/dqblk_v2.h b/lib/quota/dqblk_v2.h
> new file mode 100644
> index 0000000..ca07902
> --- /dev/null
> +++ b/lib/quota/dqblk_v2.h
> @@ -0,0 +1,43 @@
> +/*
> + * Header file for disk format of new quotafile format
> + *
> + * Jan Kara <jack@suse.cz> - sponsored by SuSE CR
> + */
> +
> +#ifndef __QUOTA_DQBLK_V2_H__
> +#define __QUOTA_DQBLK_V2_H__
> +
> +#include <sys/types.h>
> +#include "quotaio_tree.h"
> +
> +#define Q_V2_GETQUOTA	0x0D00	/* Get limits and usage */
> +#define Q_V2_SETQUOTA	0x0E00	/* Set limits and usage */
> +#define Q_V2_SETUSE	0x0F00	/* Set only usage */
> +#define Q_V2_SETQLIM	0x0700	/* Set only limits */
> +#define Q_V2_GETINFO	0x0900	/* Get information about quota */
> +#define Q_V2_SETINFO	0x0A00	/* Set information about quota */
> +#define Q_V2_SETGRACE	0x0B00	/* Set just grace times in quotafile
> +				 * information */
> +#define Q_V2_SETFLAGS	0x0C00	/* Set just flags in quotafile information */
> +#define Q_V2_GETSTATS	0x1100	/* get collected stats (before proc was used) */
> +
> +/* Structure for format specific information */
> +struct v2_mem_dqinfo {
> +	struct qtree_mem_dqinfo dqi_qtree;
> +	uint dqi_flags;		/* Flags set in quotafile */
> +	uint dqi_used_entries;	/* Number of entries in file -
> +				   updated by scan_dquots */
> +	uint dqi_data_blocks;	/* Number of data blocks in file -
> +				   updated by scan_dquots */
> +};
> +
> +struct v2_mem_dqblk {
> +	loff_t dqb_off;		/* Offset of dquot in file */
> +};
> +
> +struct quotafile_ops;		/* Will be defined later in quotaio.h */
> +
> +/* Operations above this format */
> +extern struct quotafile_ops quotafile_ops_2;
> +
> +#endif  /* __QUOTA_DQBLK_V2_H__ */
> diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
> new file mode 100644
> index 0000000..cbc76f7
> --- /dev/null
> +++ b/lib/quota/mkquota.c
> @@ -0,0 +1,400 @@
> +/*
> + * mkquota.c --- create quota files for a filesystem
> + *
> + * Aditya Kali <adityakali@google.com>

Did you write this code, or is it a port from Jan's tools?  I'm not being
critical, just trying to ensure that credit is given where it is due.

> +static void print_inode(struct ext2_inode *inode)
> +{
> +	if (!inode)
> +		return;
> +
> +	fprintf(stderr, "  i_mode = %d\n", inode->i_mode);
> +	fprintf(stderr, "  i_uid = %d\n", inode->i_uid);
> +	fprintf(stderr, "  i_size = %d\n", inode->i_size);
> +	fprintf(stderr, "  i_atime = %d\n", inode->i_atime);
> +	fprintf(stderr, "  i_ctime = %d\n", inode->i_ctime);
> +	fprintf(stderr, "  i_mtime = %d\n", inode->i_mtime);
> +	fprintf(stderr, "  i_dtime = %d\n", inode->i_dtime);
> +	fprintf(stderr, "  i_gid = %d\n", inode->i_gid);
> +	fprintf(stderr, "  i_links_count = %d\n", inode->i_links_count);
> +	fprintf(stderr, "  i_blocks = %d\n", inode->i_blocks);
> +	fprintf(stderr, "  i_flags = %d\n", inode->i_flags);
> +
> +	return;
> +}
> +
> +int is_quota_on(ext2_filsys fs, int type)

It would be better if all of these function names all started with quota_
for consistency and to avoid namespace pollution, like quota_is_on().
That is critical for functions and macros that are exported from this
library, but also useful for internal functions because it makes it clear
that the function is part of the library.

> @@ -0,0 +1,66 @@
> +/** mkquota.h
> + *
> + * Interface to the quota library.
> + *
> + * This initial version does not support reading the quota files. This support
> + * will be added in near future.
> + *
> + * Aditya Kali <adityakali@google.com>

Likewise, if this is based on Jan's library it needs proper attribution.

> +/*
> + * Detect quota format and initialize quota IO
> + */
> +struct quota_handle *init_io(ext2_filsys fs, const char *mntpt, int type,
> +			     int fmt, int flags)
> +{
> +	log_err("Not Implemented.", "");
> +	BUG_ON(1);
> +	return NULL;
> +}

This is confusing, and as mentioned earlier it is evil to exit instead
of returning an error to the caller.

> +/*
> + * Create new quotafile of specified format on given filesystem
> + */
> +int new_io(struct quota_handle *h, ext2_filsys fs, int type, int fmt)
> +{

This is a bad function name, since it doesn't at all describe what the
function is doing.  Something like quota_file_create() would be much
better.

> +/*
> + * Close quotafile and release handle
> + */
> +int end_io(struct quota_handle *h)
> +{

Similarly, quota_file_close() would be a much better name for this.


Cheers, Andreas





