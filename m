From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH][V2] misc: copy extended attributes in populate_fs
Date: Wed, 9 Jul 2014 11:51:32 -0700
Message-ID: <20140709185132.GB10417@birch.djwong.org>
References: <1404156137-31473-1-git-send-email-ross.burton@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, dvhart@linux.intel.com,
	liezhi.yang@windriver.com, tytso@mit.edu
To: Ross Burton <ross.burton@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38857 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbaGISvl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jul 2014 14:51:41 -0400
Content-Disposition: inline
In-Reply-To: <1404156137-31473-1-git-send-email-ross.burton@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 30, 2014 at 08:22:17PM +0100, Ross Burton wrote:
> When creating a file system using a source directory, also copy any extended
> attributes that have been set.

Minor quibble:
ext2fs_get_mem(value_len, &value) instead of malloc, and
ext2fs_free_mem(&value) instead of free().

Otherwise, you can add:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Signed-off-by: Ross Burton <ross.burton@intel.com>
> ---
>  misc/create_inode.c |   92 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 92 insertions(+)
> 
> diff --git a/misc/create_inode.c b/misc/create_inode.c
> index c9c99b5..31f2d3c 100644
> --- a/misc/create_inode.c
> +++ b/misc/create_inode.c
> @@ -103,6 +103,91 @@ static errcode_t set_inode_extra(ext2_filsys fs, ext2_ino_t cwd,
>  	return retval;
>  }
>  
> +static errcode_t set_inode_xattr(ext2_filsys fs, ext2_ino_t ino, const char *filename)
> +{
> +	errcode_t			retval, close_retval;
> +	struct ext2_inode		inode;
> +	struct ext2_xattr_handle	*handle;
> +	ssize_t				size, value_size;
> +	char				*list;
> +	int				i;
> +
> +	size = llistxattr(filename, NULL, 0);
> +	if (size == -1) {
> +		com_err(__func__, errno, "llistxattr failed on %s", filename);
> +		return errno;
> +	} else if (size == 0) {
> +		return 0;
> +	}
> +
> +	retval = ext2fs_xattrs_open(fs, ino, &handle);
> +	if (retval) {
> +		if (retval == EXT2_ET_MISSING_EA_FEATURE)
> +			return 0;
> +		com_err(__func__, retval, "while opening inode %u", ino);
> +		return retval;
> +	}
> +
> +	list = malloc(size);
> +	if (!list) {
> +		com_err(__func__, errno, "whilst allocating memory");
> +		retval = errno;
> +		goto out;
> +	}
> +
> +	size = llistxattr(filename, list, size);
> +	if (size == -1) {
> +		com_err(__func__, errno, "llistxattr failed on %s", filename);
> +		retval = errno;
> +		goto out;
> +        }
> +
> +	for (i = 0; i < size; i += strlen(&list[i]) + 1) {
> +		const char *name = &list[i];
> +		char *value;
> +
> +		value_size = getxattr(filename, name, NULL, 0);
> +		if (value_size == -1) {
> +			com_err(__func__, errno, "getxattr failed on %s", filename);
> +			retval = errno;
> +			break;
> +		}
> +
> +		value = malloc(value_size);
> +		if (!value) {
> +			com_err(__func__, errno, "whilst allocating memory");
> +			retval = errno;
> +			break;
> +		}
> +
> +		value_size = getxattr(filename, name, value, value_size);
> +		if (value_size == -1) {
> +			free(value);
> +			com_err(__func__, errno, "getxattr failed on %s", filename);
> +			retval = errno;
> +			break;
> +		}
> +
> +		retval = ext2fs_xattr_set(handle, name, value, value_size);
> +		free (value);
> +		if (retval) {
> +			com_err(__func__, retval, "while writing xattr %u", ino);
> +			break;
> +		}
> +
> +	}
> + out:
> +	free(list);
> +
> +	close_retval = ext2fs_xattrs_close(&handle);
> +	if (close_retval) {
> +		com_err(__func__, retval, "while closing inode %u", ino);
> +		retval = retval ? close_retval;
> +	}
> +
> +	return retval;
> +}
> +
>  /* Make a special files (block and character devices), fifo's, and sockets  */
>  errcode_t do_mknod_internal(ext2_filsys fs, ext2_ino_t cwd, const char *name,
>  			    struct stat *st)
> @@ -615,6 +700,13 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
>  			goto out;
>  		}
>  
> +		retval = set_inode_xattr(fs, ino, name);
> +		if (retval) {
> +			com_err(__func__, retval,
> +				_("while setting xattrs for \"%s\""), name);
> +			goto out;
> +		}
> +
>  		/* Save the hardlink ino */
>  		if (save_inode) {
>  			/*
> -- 
> 1.7.10.4
> 
