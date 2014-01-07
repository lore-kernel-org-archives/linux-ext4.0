From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH] fs: xattr-based FS_IOC_[GS]ETFLAGS interface
Date: Tue, 7 Jan 2014 13:48:31 +0100
Message-ID: <20140107124831.GD16640@quack.suse.cz>
References: <20140107025855.GA9229@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Aurelien Jarno <aurelien@aurel32.net>,
	Theodore Ts'o <tytso@mit.edu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Rob Browning <rlb@defaultvalue.org>,
	Dave Chinner <david@fromorbit.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140107025855.GA9229@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 06-01-14 18:58:55, Darrick J. Wong wrote:
> This is a proof of concept interface for replacing the contentious
> FS_IOC_[GS]ETFLAGS interface with one that presents itself as the
> xattr 'system.iflags'.  Instead of using integer inode flags, this
> interface uses a comma-separated string of words, such as
> "extents,immutable" to describe the inode flags.  This ought to enable
> all filesystems to introduce arbitrary flags, with any sort of backend
> they want, while also taking advantage of generic fs flags.
> 
> The initial conversion is for ext4, though given the similarities of
> most filesystems' implementations, converting the rest shouldn't be
> difficult.  How we get everyone to agree on common flag names is
> anyone's guess.
> 
> Includes some helper methods to handle the string<->int conversion,
> and a tweak to the generic xattr code to allow setting iflags on an
> immutable file.
  I have to say I'm not thrilled by the idea of juggling strings in
userspace and in kernel to set a flag for an inode...

								Honza

> Usage:
> # setfattr -n system.iflags -v 'extents,append' /path/file
> # getfattr -n system.iflags /path/file
> system.iflags="secrm,unrm,sync,immutable,nodump,noatime,journal_data,extents"
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/ext4/Makefile           |    2 
>  fs/ext4/ext4.h             |    3 +
>  fs/ext4/ioctl.c            |  198 ++++++++++++++++++++++++--------------------
>  fs/ext4/xattr.c            |    1 
>  fs/ext4/xattr.h            |    1 
>  fs/ext4/xattr_iflags.c     |   90 ++++++++++++++++++++
>  fs/xattr.c                 |    9 ++
>  include/linux/strflags.h   |   27 ++++++
>  include/uapi/linux/xattr.h |    2 
>  lib/Makefile               |    2 
>  lib/strflags.c             |  117 ++++++++++++++++++++++++++
>  11 files changed, 358 insertions(+), 94 deletions(-)
>  create mode 100644 fs/ext4/xattr_iflags.c
>  create mode 100644 include/linux/strflags.h
>  create mode 100644 lib/strflags.c
> 
> diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
> index 0310fec..7126958 100644
> --- a/fs/ext4/Makefile
> +++ b/fs/ext4/Makefile
> @@ -8,7 +8,7 @@ ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o page-io.o \
>  		ioctl.o namei.o super.o symlink.o hash.o resize.o extents.o \
>  		ext4_jbd2.o migrate.o mballoc.o block_validity.o move_extent.o \
>  		mmp.o indirect.o extents_status.o xattr.o xattr_user.o \
> -		xattr_trusted.o inline.o
> +		xattr_trusted.o inline.o xattr_iflags.o
>  
>  ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
>  ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index bf6c5cd..24837ab 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2660,6 +2660,9 @@ extern void ext4_inline_data_truncate(struct inode *inode, int *has_inline);
>  
>  extern int ext4_convert_inline_data(struct inode *inode);
>  
> +/* ioctl.c */
> +extern int ext4_set_iflags(struct inode *inode, int flags);
> +
>  /* namei.c */
>  extern const struct inode_operations ext4_dir_inode_operations;
>  extern const struct inode_operations ext4_special_inode_operations;
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 60589b6..c6f21c9 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -213,12 +213,115 @@ swap_boot_out:
>  	return err;
>  }
>  
> +/*
> + * Set inode flags.  Assume we already have mnt_want_write_file and i_mutex.
> + */
> +int ext4_set_iflags(struct inode *inode, int flags)
> +{
> +	handle_t *handle = NULL;
> +	int err, migrate = 0;
> +	struct ext4_iloc iloc;
> +	unsigned int oldflags, mask, i;
> +	unsigned int jflag;
> +	struct ext4_inode_info *ei = EXT4_I(inode);
> +
> +	if (!inode_owner_or_capable(inode))
> +		return -EACCES;
> +
> +	flags = ext4_mask_flags(inode->i_mode, flags);
> +
> +	err = -EPERM;
> +	/* Is it quota file? Do not allow user to mess with it */
> +	if (IS_NOQUOTA(inode))
> +		goto flags_out;
> +
> +	oldflags = ei->i_flags;
> +
> +	/* The JOURNAL_DATA flag is modifiable only by root */
> +	jflag = flags & EXT4_JOURNAL_DATA_FL;
> +
> +	/*
> +	 * The IMMUTABLE and APPEND_ONLY flags can only be changed by
> +	 * the relevant capability.
> +	 *
> +	 * This test looks nicer. Thanks to Pauline Middelink
> +	 */
> +	if ((flags ^ oldflags) & (EXT4_APPEND_FL | EXT4_IMMUTABLE_FL)) {
> +		if (!capable(CAP_LINUX_IMMUTABLE))
> +			goto flags_out;
> +	}
> +
> +	/*
> +	 * The JOURNAL_DATA flag can only be changed by
> +	 * the relevant capability.
> +	 */
> +	if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL)) {
> +		if (!capable(CAP_SYS_RESOURCE))
> +			goto flags_out;
> +	}
> +	if ((flags ^ oldflags) & EXT4_EXTENTS_FL)
> +		migrate = 1;
> +
> +	if (flags & EXT4_EOFBLOCKS_FL) {
> +		/* we don't support adding EOFBLOCKS flag */
> +		if (!(oldflags & EXT4_EOFBLOCKS_FL)) {
> +			err = -EOPNOTSUPP;
> +			goto flags_out;
> +		}
> +	} else if (oldflags & EXT4_EOFBLOCKS_FL)
> +		ext4_truncate(inode);
> +
> +	handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
> +	if (IS_ERR(handle)) {
> +		err = PTR_ERR(handle);
> +		goto flags_out;
> +	}
> +	if (IS_SYNC(inode))
> +		ext4_handle_sync(handle);
> +	err = ext4_reserve_inode_write(handle, inode, &iloc);
> +	if (err)
> +		goto flags_err;
> +
> +	for (i = 0, mask = 1; i < 32; i++, mask <<= 1) {
> +		if (!(mask & EXT4_FL_USER_MODIFIABLE))
> +			continue;
> +		if (mask & flags)
> +			ext4_set_inode_flag(inode, i);
> +		else
> +			ext4_clear_inode_flag(inode, i);
> +	}
> +
> +	ext4_set_inode_flags(inode);
> +	inode->i_ctime = ext4_current_time(inode);
> +
> +	err = ext4_mark_iloc_dirty(handle, inode, &iloc);
> +flags_err:
> +	ext4_journal_stop(handle);
> +	if (err)
> +		goto flags_out;
> +
> +	if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL))
> +		err = ext4_change_inode_journal_flag(inode, jflag);
> +	if (err)
> +		goto flags_out;
> +	if (migrate) {
> +		if (flags & EXT4_EXTENTS_FL)
> +			err = ext4_ext_migrate(inode);
> +		else
> +			err = ext4_ind_migrate(inode);
> +	}
> +
> +flags_out:
> +	return err;
> +}
> +
>  long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  {
>  	struct inode *inode = file_inode(filp);
>  	struct super_block *sb = inode->i_sb;
>  	struct ext4_inode_info *ei = EXT4_I(inode);
>  	unsigned int flags;
> +	int err;
>  
>  	ext4_debug("cmd = %u, arg = %lu\n", cmd, arg);
>  
> @@ -227,13 +330,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		ext4_get_inode_flags(ei);
>  		flags = ei->i_flags & EXT4_FL_USER_VISIBLE;
>  		return put_user(flags, (int __user *) arg);
> -	case EXT4_IOC_SETFLAGS: {
> -		handle_t *handle = NULL;
> -		int err, migrate = 0;
> -		struct ext4_iloc iloc;
> -		unsigned int oldflags, mask, i;
> -		unsigned int jflag;
> -
> +	case EXT4_IOC_SETFLAGS:
>  		if (!inode_owner_or_capable(inode))
>  			return -EACCES;
>  
> @@ -244,95 +341,12 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		if (err)
>  			return err;
>  
> -		flags = ext4_mask_flags(inode->i_mode, flags);
> -
> -		err = -EPERM;
>  		mutex_lock(&inode->i_mutex);
> -		/* Is it quota file? Do not allow user to mess with it */
> -		if (IS_NOQUOTA(inode))
> -			goto flags_out;
> -
> -		oldflags = ei->i_flags;
> -
> -		/* The JOURNAL_DATA flag is modifiable only by root */
> -		jflag = flags & EXT4_JOURNAL_DATA_FL;
> -
> -		/*
> -		 * The IMMUTABLE and APPEND_ONLY flags can only be changed by
> -		 * the relevant capability.
> -		 *
> -		 * This test looks nicer. Thanks to Pauline Middelink
> -		 */
> -		if ((flags ^ oldflags) & (EXT4_APPEND_FL | EXT4_IMMUTABLE_FL)) {
> -			if (!capable(CAP_LINUX_IMMUTABLE))
> -				goto flags_out;
> -		}
> -
> -		/*
> -		 * The JOURNAL_DATA flag can only be changed by
> -		 * the relevant capability.
> -		 */
> -		if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL)) {
> -			if (!capable(CAP_SYS_RESOURCE))
> -				goto flags_out;
> -		}
> -		if ((flags ^ oldflags) & EXT4_EXTENTS_FL)
> -			migrate = 1;
> -
> -		if (flags & EXT4_EOFBLOCKS_FL) {
> -			/* we don't support adding EOFBLOCKS flag */
> -			if (!(oldflags & EXT4_EOFBLOCKS_FL)) {
> -				err = -EOPNOTSUPP;
> -				goto flags_out;
> -			}
> -		} else if (oldflags & EXT4_EOFBLOCKS_FL)
> -			ext4_truncate(inode);
> -
> -		handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
> -		if (IS_ERR(handle)) {
> -			err = PTR_ERR(handle);
> -			goto flags_out;
> -		}
> -		if (IS_SYNC(inode))
> -			ext4_handle_sync(handle);
> -		err = ext4_reserve_inode_write(handle, inode, &iloc);
> -		if (err)
> -			goto flags_err;
> -
> -		for (i = 0, mask = 1; i < 32; i++, mask <<= 1) {
> -			if (!(mask & EXT4_FL_USER_MODIFIABLE))
> -				continue;
> -			if (mask & flags)
> -				ext4_set_inode_flag(inode, i);
> -			else
> -				ext4_clear_inode_flag(inode, i);
> -		}
> -
> -		ext4_set_inode_flags(inode);
> -		inode->i_ctime = ext4_current_time(inode);
> -
> -		err = ext4_mark_iloc_dirty(handle, inode, &iloc);
> -flags_err:
> -		ext4_journal_stop(handle);
> -		if (err)
> -			goto flags_out;
> -
> -		if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL))
> -			err = ext4_change_inode_journal_flag(inode, jflag);
> -		if (err)
> -			goto flags_out;
> -		if (migrate) {
> -			if (flags & EXT4_EXTENTS_FL)
> -				err = ext4_ext_migrate(inode);
> -			else
> -				err = ext4_ind_migrate(inode);
> -		}
> -
> -flags_out:
> +		err = ext4_set_iflags(inode, flags);
>  		mutex_unlock(&inode->i_mutex);
> +
>  		mnt_drop_write_file(filp);
>  		return err;
> -	}
>  	case EXT4_IOC_GETVERSION:
>  	case EXT4_IOC_GETVERSION_OLD:
>  		return put_user(inode->i_generation, (int __user *) arg);
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 1423c48..64963e4 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -105,6 +105,7 @@ static const struct xattr_handler *ext4_xattr_handler_map[] = {
>  };
>  
>  const struct xattr_handler *ext4_xattr_handlers[] = {
> +	&ext4_xattr_iflags_handler,
>  	&ext4_xattr_user_handler,
>  	&ext4_xattr_trusted_handler,
>  #ifdef CONFIG_EXT4_FS_POSIX_ACL
> diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
> index c767dbd..2559583 100644
> --- a/fs/ext4/xattr.h
> +++ b/fs/ext4/xattr.h
> @@ -99,6 +99,7 @@ extern const struct xattr_handler ext4_xattr_trusted_handler;
>  extern const struct xattr_handler ext4_xattr_acl_access_handler;
>  extern const struct xattr_handler ext4_xattr_acl_default_handler;
>  extern const struct xattr_handler ext4_xattr_security_handler;
> +extern const struct xattr_handler ext4_xattr_iflags_handler;
>  
>  extern ssize_t ext4_listxattr(struct dentry *, char *, size_t);
>  
> diff --git a/fs/ext4/xattr_iflags.c b/fs/ext4/xattr_iflags.c
> new file mode 100644
> index 0000000..e3c5472
> --- /dev/null
> +++ b/fs/ext4/xattr_iflags.c
> @@ -0,0 +1,90 @@
> +/*
> + * linux/fs/ext4/xattr_iflags.c
> + * Handler for using the extended attribute interface to store inode flags.
> + *
> + * Copyright (C) 2014 Oracle, Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#include <linux/string.h>
> +#include <linux/fs.h>
> +#include <linux/security.h>
> +#include <linux/slab.h>
> +#include <linux/strflags.h>
> +#include "ext4_jbd2.h"
> +#include "ext4.h"
> +#include "xattr.h"
> +
> +static struct flag_db ext4_iflags = {
> +	.flag_sz = sizeof(int),
> +	.maps = {
> +		{"secrm", EXT4_SECRM_FL},
> +		{"unrm", EXT4_UNRM_FL},
> +		{"compr", EXT4_COMPR_FL},
> +		{"sync", EXT4_SYNC_FL},
> +		{"immutable", EXT4_IMMUTABLE_FL},
> +		{"append", EXT4_APPEND_FL},
> +		{"nodump", EXT4_NODUMP_FL},
> +		{"noatime", EXT4_NOATIME_FL},
> +		{"htree_dir", EXT4_INDEX_FL},
> +		{"journal_data", EXT4_JOURNAL_DATA_FL},
> +		{"notail", EXT4_NOTAIL_FL},
> +		{"dirsync", EXT4_DIRSYNC_FL},
> +		{"topdir", EXT4_TOPDIR_FL},
> +		{"extents", EXT4_EXTENTS_FL},
> +		{NULL, 0},
> +	}
> +};
> +
> +static size_t
> +ext4_xattr_iflags_list(struct dentry *dentry, char *list, size_t list_size,
> +		       const char *name, size_t name_len, int type)
> +{
> +	const size_t prefix_len = sizeof(XATTR_NAME_IFLAGS)-1;
> +	const size_t total_len = prefix_len + name_len + 1;
> +
> +	if (list && total_len <= list_size) {
> +		memcpy(list, XATTR_NAME_IFLAGS, prefix_len);
> +		memcpy(list+prefix_len, name, name_len);
> +		list[prefix_len + name_len] = '\0';
> +	}
> +	return total_len;
> +}
> +
> +static int
> +ext4_xattr_iflags_get(struct dentry *dentry, const char *name,
> +		       void *buffer, size_t size, int type)
> +{
> +	struct ext4_inode_info *ei;
> +
> +	ei = EXT4_I(dentry->d_inode);
> +	return flags_to_string(&ext4_iflags, &ei->i_flags, buffer, size);
> +}
> +
> +static int
> +ext4_xattr_iflags_set(struct dentry *dentry, const char *name,
> +		const void *value, size_t size, int flags, int type)
> +{
> +	char *string = (char *)value;
> +	int ret, moo;
> +
> +	string = kmalloc(size + 1, GFP_KERNEL);
> +	if (!string)
> +		return -ENOMEM;
> +	memcpy(string, value, size);
> +	string[size] = 0;
> +
> +	ret = string_to_flags(&ext4_iflags, string, size, &moo);
> +	if (ret)
> +		goto out;
> +
> +	ret = ext4_set_iflags(dentry->d_inode, moo);
> +out:
> +	kfree(string);
> +	return ret;
> +}
> +
> +const struct xattr_handler ext4_xattr_iflags_handler = {
> +	.prefix	= XATTR_NAME_IFLAGS,
> +	.list	= ext4_xattr_iflags_list,
> +	.get	= ext4_xattr_iflags_get,
> +	.set	= ext4_xattr_iflags_set,
> +};
> diff --git a/fs/xattr.c b/fs/xattr.c
> index 3377dff..bf0fe89 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -32,6 +32,15 @@ static int
>  xattr_permission(struct inode *inode, const char *name, int mask)
>  {
>  	/*
> +	 * Always allow read/write of inode flag attribute.
> +	 */
> +	if (!strcmp(name, XATTR_NAME_IFLAGS)) {
> +		if (mask & MAY_WRITE)
> +			return inode_owner_or_capable(inode) ? 0 : -EACCES;
> +		return 0;
> +	}
> +
> +	/*
>  	 * We can never set or remove an extended attribute on a read-only
>  	 * filesystem  or on an immutable / append-only inode.
>  	 */
> diff --git a/include/linux/strflags.h b/include/linux/strflags.h
> new file mode 100644
> index 0000000..6c8067c
> --- /dev/null
> +++ b/include/linux/strflags.h
> @@ -0,0 +1,27 @@
> +/*
> + * File: linux/strflags.h
> + * Convert flags to pretty strings.
> + *
> + * Copyright (C) 2014 Oracle, Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#ifndef _LINUX_STRFLAGS_H_
> +#define _LINUX_STRFLAGS_H_
> +
> +#include <linux/types.h>
> +
> +struct flag_map {
> +	const char *string;
> +	unsigned long flag;
> +};
> +
> +struct flag_db {
> +	size_t flag_sz;
> +	struct flag_map maps[];
> +};
> +
> +int flags_to_string(struct flag_db *flagdb, void *flags, char *buf,
> +		    size_t buf_len);
> +int string_to_flags(struct flag_db *flagdb, char *buf, size_t buf_len,
> +		    void *flags);
> +
> +#endif /* _LINUX_STRFLAGS_H_ */
> diff --git a/include/uapi/linux/xattr.h b/include/uapi/linux/xattr.h
> index e4629b9..8cd78ae 100644
> --- a/include/uapi/linux/xattr.h
> +++ b/include/uapi/linux/xattr.h
> @@ -63,5 +63,7 @@
>  #define XATTR_POSIX_ACL_DEFAULT  "posix_acl_default"
>  #define XATTR_NAME_POSIX_ACL_DEFAULT XATTR_SYSTEM_PREFIX XATTR_POSIX_ACL_DEFAULT
>  
> +#define XATTR_IFLAGS "iflags"
> +#define XATTR_NAME_IFLAGS XATTR_SYSTEM_PREFIX XATTR_IFLAGS
>  
>  #endif /* _UAPI_LINUX_XATTR_H */
> diff --git a/lib/Makefile b/lib/Makefile
> index a459c31..f3a517d 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -26,7 +26,7 @@ obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
>  	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
>  	 gcd.o lcm.o list_sort.o uuid.o flex_array.o iovec.o clz_ctz.o \
>  	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o \
> -	 percpu-refcount.o percpu_ida.o
> +	 percpu-refcount.o percpu_ida.o strflags.o
>  obj-y += string_helpers.o
>  obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
>  obj-y += kstrtox.o
> diff --git a/lib/strflags.c b/lib/strflags.c
> new file mode 100644
> index 0000000..d1a34e7
> --- /dev/null
> +++ b/lib/strflags.c
> @@ -0,0 +1,117 @@
> +/*
> + * File: lib/strflags.c
> + * Convert flags to pretty strings.
> + *
> + * Copyright (C) 2014 Oracle, Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#include <linux/kernel.h>
> +#include <linux/string.h>
> +#include <linux/strflags.h>
> +#include <linux/errno.h>
> +
> +int flags_to_string(struct flag_db *flagdb, void *flags, char *buf,
> +		    size_t buf_len)
> +{
> +	struct flag_map *mapping;
> +	char *b;
> +	unsigned long fl;
> +	int used, first;
> +	size_t sz;
> +
> +	switch (flagdb->flag_sz) {
> +	case 1:
> +		fl = *(u8 *)flags;
> +		break;
> +	case 2:
> +		fl = *(u16 *)flags;
> +		break;
> +	case 4:
> +		fl = *(u32 *)flags;
> +		break;
> +	case 8:
> +		fl = *(u64 *)flags;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	/* Calculating buffer size */
> +	sz = 0;
> +	for (mapping = flagdb->maps; mapping->string; mapping++) {
> +		if (mapping->flag & fl) {
> +			sz += strlen(mapping->string);
> +			sz++;
> +		}
> +	}
> +
> +	if (buf == NULL)
> +		return sz;
> +	if (buf_len < sz)
> +		return -ERANGE;
> +
> +	/* Stringify the flags */
> +	b = buf;
> +	first = 1;
> +	for (mapping = flagdb->maps; mapping->string; mapping++) {
> +		if (mapping->flag & fl) {
> +			used = snprintf(b, buf_len, "%s%s",
> +					(first ? "" : ","),
> +					mapping->string);
> +			first = 0;
> +			buf_len -= used;
> +			b += used;
> +		}
> +	}
> +
> +	return b - buf;
> +}
> +EXPORT_SYMBOL_GPL(flags_to_string);
> +
> +int string_to_flags(struct flag_db *flagdb, char *buf, size_t buflen,
> +		    void *flags)
> +{
> +	struct flag_map *mapping;
> +	unsigned long fl = 0;
> +	char *p, *q;
> +	char c;
> +	int found;
> +
> +	for (p = buf; p < buf + buflen; p = q + 1) {
> +		for (q = p; *q != 0 && *q != ','; q++)
> +			; /* empty */
> +		if (p == q)
> +			continue;
> +
> +		c = *q; *q = 0;
> +		found = 0;
> +		for (mapping = flagdb->maps; mapping->string; mapping++)
> +			if (strcmp(p, mapping->string) == 0) {
> +				fl |= mapping->flag;
> +				found = 1;
> +			}
> +		if (!found)
> +			return -EINVAL;
> +		*q = c;
> +		p = q + 1;
> +	}
> +
> +	switch (flagdb->flag_sz) {
> +	case 1:
> +		*(u8 *)flags = fl;
> +		break;
> +	case 2:
> +		*(u16 *)flags = fl;
> +		break;
> +	case 4:
> +		*(u32 *)flags = fl;
> +		break;
> +	case 8:
> +		*(u64 *)flags = fl;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(string_to_flags);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
