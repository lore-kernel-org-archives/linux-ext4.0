From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v1 06/22] debugfs: make stat command support inline data
Date: Fri, 11 Oct 2013 16:43:53 -0700
Message-ID: <20131011234353.GR6860@birch.djwong.org>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
 <1375436989-18948-7-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49330 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab3JKXoF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Oct 2013 19:44:05 -0400
Content-Disposition: inline
In-Reply-To: <1375436989-18948-7-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 02, 2013 at 05:49:33PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> If there is an inode with inline data, we just print the size of inline
> data in stat command.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  debugfs/debugfs.c        |   11 +++++++++++
>  lib/ext2fs/ext2fs.h      |    1 +
>  lib/ext2fs/inline_data.c |   27 +++++++++++++++++++++++++++
>  3 files changed, 39 insertions(+)
> 
> diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
> index 969dbe0..2837ee6 100644
> --- a/debugfs/debugfs.c
> +++ b/debugfs/debugfs.c
> @@ -704,6 +704,15 @@ static void dump_extents(FILE *f, const char *prefix, ext2_ino_t ino,
>  		fprintf(f, "\n");
>  }
>  
> +static void dump_inline_data(FILE *out, const char *prefix, ext2_ino_t inode_num)
> +{
> +	int size;
> +
> +	fprintf(out, "%sINLINE DATA:\n %s", prefix, prefix);
> +	size = ext2fs_inline_data_get_size(current_fs, inode_num);
> +	fprintf(out, "  The size of inline data: %d", size);
> +}
> +
>  void internal_dump_inode(FILE *out, const char *prefix,
>  			 ext2_ino_t inode_num, struct ext2_inode *inode,
>  			 int do_dump_blocks)
> @@ -837,6 +846,8 @@ void internal_dump_inode(FILE *out, const char *prefix,
>  		if (inode->i_flags & EXT4_EXTENTS_FL)
>  			dump_extents(out, prefix, inode_num,
>  				     DUMP_LEAF_EXTENTS|DUMP_NODE_EXTENTS, 0, 0);
> +		else if (inode->i_flags & EXT4_INLINE_DATA_FL)
> +			dump_inline_data(out, prefix, inode_num);
>  		else
>  			dump_blocks(out, prefix, inode_num);
>  	}
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 7b05b48..6e3bf6e 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -1344,6 +1344,7 @@ extern errcode_t ext2fs_get_memalign(unsigned long size,
>  
>  /* inline_data.c */
>  extern int ext2fs_inode_has_inline_data(ext2_filsys fs, ext2_ino_t ino);
> +extern int ext2fs_inline_data_get_size(ext2_filsys fs, ext2_ino_t ino);
>  extern errcode_t ext2fs_inline_data_iterate(ext2_filsys fs,
>  				      ext2_ino_t ino,
>  				      int flags,
> diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
> index 922c959..1220418 100644
> --- a/lib/ext2fs/inline_data.c
> +++ b/lib/ext2fs/inline_data.c
> @@ -80,6 +80,33 @@ int ext2fs_inode_has_inline_data(ext2_filsys fs, ext2_ino_t ino)
>  	return (inode.i_flags & EXT4_INLINE_DATA_FL);
>  }
>  
> +int ext2fs_inline_data_get_size(ext2_filsys fs, ext2_ino_t ino)
> +{
> +	struct ext2_inode_large *inode;
> +	struct inline_data data;
> +	errcode_t retval = 0;
> +	int size = 0;
> +
> +	retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
> +	if (retval)
> +		return 0;
> +	retval = ext2fs_read_inode_full(fs, ino, (void *)inode,
> +					EXT2_INODE_SIZE(fs->super));
> +	if (retval)
> +		goto out;
> +
> +	if (inode->i_flags & EXT4_INLINE_DATA_FL) {
> +		retval = ext2fs_inline_data_find(fs, inode, &data);
> +		if (retval)
> +			goto out;
> +		size = data.inline_size;

Doesn't this miss the inline data in i_block?  Afaict ext2fs_inline_data_find
only picks up EA inline data.

--D

> +	}
> +
> +out:
> +	ext2fs_free_mem(&inode);
> +	return size;
> +}
> +
>  errcode_t ext2fs_inline_data_iterate(ext2_filsys fs,
>  			       ext2_ino_t ino,
>  			       int flags,
> -- 
> 1.7.9.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
