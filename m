From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] misc: copy extended attributes in populate_fs
Date: Mon, 30 Jun 2014 11:43:46 -0700
Message-ID: <20140630184346.GF9743@birch.djwong.org>
References: <1403902937-2781-1-git-send-email-ross.burton@intel.com>
 <1403902937-2781-2-git-send-email-ross.burton@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, dvhart@linux.intel.com, tytso@mit.edu,
	liezhi.yang@windriver.com
To: Ross Burton <ross.burton@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44541 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbaF3Sny (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Jun 2014 14:43:54 -0400
Content-Disposition: inline
In-Reply-To: <1403902937-2781-2-git-send-email-ross.burton@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 27, 2014 at 10:02:17PM +0100, Ross Burton wrote:
> When creating a file system using a source directory, also copy any extended
> attributes that have been set.
> 
> Signed-off-by: Ross Burton <ross.burton@intel.com>
> ---
>  misc/create_inode.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 56 insertions(+)
> 
> diff --git a/misc/create_inode.c b/misc/create_inode.c
> index c9c99b5..2795f9e 100644
> --- a/misc/create_inode.c
> +++ b/misc/create_inode.c
> @@ -103,6 +103,55 @@ static errcode_t set_inode_extra(ext2_filsys fs, ext2_ino_t cwd,
>  	return retval;
>  }
>  
> +static errcode_t set_inode_xattr(ext2_filsys fs, ext2_ino_t ino, const char *filename)
> +{
> +	errcode_t			retval;
> +	struct ext2_inode		inode;
> +	struct ext2_xattr_handle	*handle;
> +	ssize_t				size, value_size;
> +	char				*list;
> +	int				i;
> +
> +	size = llistxattr(filename, NULL, 0);
> +	if (size == -1) {
> +		com_err(__func__, errno, "listxattr failed on %s", filename);
> +		return errno;
> +	} else if (size == 0) {
> +		return 0;
> +	}
> +
> +	retval = ext2fs_xattrs_open(fs, ino, &handle);

If the FS does not have at least one of the inline_data or ext_attr features
turned on, the ext2fs_xattrs_open call returns EXT2_ET_MISSING_EA_FEATURE,
which aborts the whole operation.  Is that ok?

> +	if (retval) {
> +		com_err(__func__, errno, "while opening inode %u", ino);

retval, not errno.

> +		return errno;
> +	}
> +
> +	list = malloc(size);

What happens if malloc fails?

> +	size = llistxattr(filename, list, size);

What if this second call should fail for some reason?  Shouldn't we stop?

> +
> +	for (i = 0; i < size; i += strlen(&list[i]) + 1) {
> +		const char *name = &list[i];
> +		char *value;
> +
> +		value_size = getxattr(filename, name, NULL, 0);

What if getxattr returns -1?

> +		value = malloc(value_size);
> +		value_size = getxattr(filename, name, value, value_size);

Same complaints about not checking malloc/getxattr return values.

> +
> +		retval = ext2fs_xattr_set(handle, name, value, value_size);
> +		if (retval)
> +			com_err(__func__, retval, "while writing xattr %u", ino);
> +
> +		free (value);
> +	}
> +	free(list);
> +
> +	retval = ext2fs_xattrs_close(&handle);
> +	if (retval)
> +		com_err(__func__, errno, "while closing inode %u", ino);

retval, not errno.

--D
> +
> +	return retval;
> +}
> +
>  /* Make a special files (block and character devices), fifo's, and sockets  */
>  errcode_t do_mknod_internal(ext2_filsys fs, ext2_ino_t cwd, const char *name,
>  			    struct stat *st)
> @@ -615,6 +664,13 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
