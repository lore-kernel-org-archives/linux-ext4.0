From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v1 04/22] libext2fs: handle inline data in dir iterator
 function
Date: Fri, 11 Oct 2013 16:33:42 -0700
Message-ID: <20131011233342.GB20432@birch.djwong.org>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
 <1375436989-18948-5-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47629 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab3JKXdx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Oct 2013 19:33:53 -0400
Content-Disposition: inline
In-Reply-To: <1375436989-18948-5-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 02, 2013 at 05:49:31PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Inline_data is handled in dir iterator because a lot of commands use
> this function to traverse directory entries in debugfs.  We need to
> handle inline_data individually because inline_data is saved in two
> places.  One is in i_block, and another is in ibody extended attribute.
> 
> After applied this commit, the following commands in debugfs can
> support the inline_data feature:
> 	- ncheck
> 	- chroot
> 	- cd
> 	- ls
> 	- pwd
> 	- link*
> 	- unlink
> 
> * If inline_data doesn't expand to ibody extended attribute, link
>   command will allocate a new block for this inode instead of using
>   extend attribute when we exhaust all space of i_block.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  lib/ext2fs/dir_iterate.c  |  102 ++++++++++++++++++++++++++++++++++-
>  lib/ext2fs/ext2_err.et.in |    6 +++
>  lib/ext2fs/ext2_fs.h      |    8 +++
>  lib/ext2fs/ext2fs.h       |   11 ++++
>  lib/ext2fs/ext2fsP.h      |   11 ++++
>  lib/ext2fs/inline_data.c  |  132 +++++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 268 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/ext2fs/dir_iterate.c b/lib/ext2fs/dir_iterate.c
> index 1a4bf5c..7d5b1da 100644
> --- a/lib/ext2fs/dir_iterate.c
> +++ b/lib/ext2fs/dir_iterate.c
> @@ -123,8 +123,14 @@ errcode_t ext2fs_dir_iterate2(ext2_filsys fs,
>  	ctx.func = func;
>  	ctx.priv_data = priv_data;
>  	ctx.errcode = 0;
> -	retval = ext2fs_block_iterate3(fs, dir, BLOCK_FLAG_READ_ONLY, 0,
> -				       ext2fs_process_dir_block, &ctx);
> +	if (ext2fs_inode_has_inline_data(fs, dir))
> +		retval = ext2fs_inline_data_iterate(fs, dir,
> +						BLOCK_FLAG_READ_ONLY, 0,
> +						ext2fs_process_dir_inline_data,
> +						&ctx);
> +	else
> +		retval = ext2fs_block_iterate3(fs, dir, BLOCK_FLAG_READ_ONLY, 0,
> +					       ext2fs_process_dir_block, &ctx);
>  	if (!block_buf)
>  		ext2fs_free_mem(&ctx.buf);
>  	if (retval)
> @@ -282,3 +288,95 @@ next:
>  	return 0;
>  }
>  
> +int ext2fs_process_dir_inline_data(ext2_filsys	fs,
> +				   char		*buf,
> +				   unsigned int	buf_len,
> +				   e2_blkcnt_t	blockcnt,
> +				   struct ext2_inode_large *inode,
> +				   void		*priv_data)
> +{
> +	struct dir_context *ctx = (struct dir_context *) priv_data;
> +	unsigned int	offset = 0;
> +	unsigned int	next_real_entry = 0;
> +	int		ret = 0;
> +	int		changed = 0;
> +	int		do_abort = 0;
> +	unsigned int	rec_len, size;
> +	int		entry;
> +	struct ext2_dir_entry *dirent;
> +
> +	if (blockcnt < 0)
> +		return 0;
> +
> +	entry = blockcnt ? DIRENT_OTHER_FILE : DIRENT_DOT_FILE;
> +
> +	while (offset < buf_len) {
> +		dirent = (struct ext2_dir_entry *) (buf + offset);
> +		if (ext2fs_get_rec_len(fs, dirent, &rec_len))
> +			return BLOCK_ABORT;
> +		if (((offset + rec_len) > buf_len) ||
> +		    (rec_len < 8) ||
> +		    ((rec_len % 4) != 0) ||
> +		    ((((unsigned) dirent->name_len & 0xFF)+8) > rec_len)) {
> +			ctx->errcode = EXT2_ET_DIR_CORRUPTED;
> +			return BLOCK_ABORT;
> +		}
> +		if (!dirent->inode &&
> +		    !(ctx->flags & DIRENT_FLAG_INCLUDE_EMPTY))
> +			goto next;
> +
> +		ret = (ctx->func)(ctx->dir,
> +				  (next_real_entry > offset) ?
> +				  DIRENT_DELETED_FILE : entry,
> +				  dirent, offset,
> +				  buf_len, buf,
> +				  ctx->priv_data);
> +		if (entry < DIRENT_OTHER_FILE)
> +			entry++;
> +
> +		if (ret & DIRENT_CHANGED) {
> +			if (ext2fs_get_rec_len(fs, dirent, &rec_len))
> +				return BLOCK_ABORT;
> +			changed++;
> +		}
> +		if (ret & DIRENT_ABORT) {
> +			do_abort++;
> +			break;
> +		}
> +next:
> +		if (next_real_entry == offset)
> +			next_real_entry += rec_len;
> +
> +		if (ctx->flags & DIRENT_FLAG_INCLUDE_REMOVED) {
> +			size = ((dirent->name_len & 0xFF) + 11) & ~3;
> +
> +			if (rec_len != size)  {
> +				unsigned int final_offset;
> +
> +				final_offset = offset + rec_len;
> +				offset += size;
> +				while (offset < final_offset &&
> +				       !ext2fs_validate_entry(fs, buf,
> +							      offset,
> +							      final_offset))
> +					offset += 4;
> +				continue;
> +			}
> +		}
> +		offset += rec_len;
> +	}
> +
> +	if (changed) {
> +		/* change parent ino */
> +		if (buf_len == EXT2_DIR_REC_LEN(2))
> +			((struct ext2_dir_entry *)inode->i_block)->inode =
> +								 dirent->inode;
> +		ctx->errcode = ext2fs_write_inode_full(fs, ctx->dir, (void *)inode,
> +						       EXT2_INODE_SIZE(fs->super));
> +		if (ctx->errcode)
> +			return BLOCK_ABORT;
> +	}
> +	if (do_abort)
> +		return BLOCK_ABORT;
> +	return 0;
> +}
> diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
> index 7e6d6e5..8a19cab 100644
> --- a/lib/ext2fs/ext2_err.et.in
> +++ b/lib/ext2fs/ext2_err.et.in
> @@ -68,6 +68,9 @@ ec	EXT2_ET_MAGIC_EXTENT_HANDLE,
>  ec	EXT2_ET_BAD_MAGIC,
>  	"Bad magic number in super-block"
>  
> +ec	EXT2_ET_BAD_EXT_ATTR_MAGIC,
> +	"Bad magic number in extend attribute"

"extended attribute"

> +
>  ec	EXT2_ET_REV_TOO_HIGH,
>  	"Filesystem revision too high"
>  
> @@ -479,4 +482,7 @@ ec	EXT2_ET_FILE_EXISTS,
>  ec	EXT2_ET_EXT_ATTR_CURRUPTED,
>  	"Extended attribute currupted"
>  
> +ec	EXT2_ET_BAD_EXTRA_SIZE,
> +	"Bad inode extra isizevalue"

"i_extra_isize value"

> +
>  	end
> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index 0c0bbcb..d49b95c 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -906,4 +906,12 @@ struct mmp_struct {
>   */
>  #define EXT4_MMP_MIN_CHECK_INTERVAL     5
>  
> +struct inline_data {
> +	__u16	inline_off;
> +	__u16	inline_size;
> +};
> +
> +#define EXT4_MIN_INLINE_DATA_SIZE	((sizeof(__u32) * EXT2_N_BLOCKS))
> +#define EXT4_INLINE_DATA_DOTDOT_SIZE	(4)
> +
>  #endif	/* _LINUX_EXT2_FS_H */
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 8c30197..7b05b48 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -1344,6 +1344,17 @@ extern errcode_t ext2fs_get_memalign(unsigned long size,
>  
>  /* inline_data.c */
>  extern int ext2fs_inode_has_inline_data(ext2_filsys fs, ext2_ino_t ino);
> +extern errcode_t ext2fs_inline_data_iterate(ext2_filsys fs,
> +				      ext2_ino_t ino,
> +				      int flags,
> +				      char *block_buf,
> +				      int (*func)(ext2_filsys fs,
> +						  char *buf,
> +						  unsigned int buf_len,
> +						  e2_blkcnt_t blockcnt,
> +						  struct ext2_inode_large *inode,
> +						  void *priv_data),
> +				      void *priv_data);
>  
>  /* inode.c */
>  extern void ext2fs_free_inode_cache(struct ext2_inode_cache *icache);
> diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
> index 3de9278..e86d452 100644
> --- a/lib/ext2fs/ext2fsP.h
> +++ b/lib/ext2fs/ext2fsP.h
> @@ -87,6 +87,17 @@ extern int ext2fs_process_dir_block(ext2_filsys  	fs,
>  				    int			ref_offset,
>  				    void		*priv_data);
>  
> +extern int ext2fs_process_dir_inline_data(ext2_filsys	fs,
> +					  char		*buf,
> +					  unsigned int	buf_len,
> +					  e2_blkcnt_t	blockcnt,
> +					  struct ext2_inode_large *inode,
> +					  void		*priv_data);
> +
> +extern errcode_t ext2fs_inline_data_find(ext2_filsys fs,
> +					 struct ext2_inode_large *inode,
> +					 struct inline_data *data);
> +
>  /* Generic numeric progress meter */
>  
>  struct ext2fs_numeric_progress_struct {
> diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
> index fcf82b5..922c959 100644
> --- a/lib/ext2fs/inline_data.c
> +++ b/lib/ext2fs/inline_data.c
> @@ -14,10 +14,60 @@
>  #include <time.h>
>  
>  #include "ext2_fs.h"
> +#include "ext2_ext_attr.h"
>  
>  #include "ext2fs.h"
>  #include "ext2fsP.h"
>  
> +static void *ext2fs_get_inline_xattr_pos(struct ext2_inode_large *inode,
> +					 struct inline_data *data);
> +
> +errcode_t ext2fs_inline_data_find(ext2_filsys fs,
> +				  struct ext2_inode_large *inode,
> +				  struct inline_data *data)
> +{
> +	errcode_t retval;
> +
> +	struct ext2_ext_attr_search s = {
> +		.not_found = ENODATA,
> +	};
> +	struct ext2_ext_attr_info i = {
> +		.name_index = EXT4_EXT_ATTR_INDEX_SYSTEM,
> +		.name = EXT4_EXT_ATTR_SYSTEM_DATA,
> +	};
> +
> +	data->inline_off = 0;
> +	if (inode->i_extra_isize > (EXT2_INODE_SIZE(fs->super) -
> +				   EXT2_GOOD_OLD_INODE_SIZE))
> +		return EXT2_ET_BAD_EXTRA_SIZE;
> +
> +	retval = ext2fs_ext_attr_ibody_find(fs, inode, &i, &s);
> +	if (retval)
> +		return retval;
> +
> +	if (!s.not_found) {
> +		data->inline_off = (__u16)((char *)s.here - (char *)inode);
> +		data->inline_size = EXT4_MIN_INLINE_DATA_SIZE +
> +				    s.here->e_value_size;
> +		return 0;
> +	}
> +
> +	return EXT2_ET_BAD_EXT_ATTR_MAGIC;
> +}
> +
> +static void *ext2fs_get_inline_xattr_pos(struct ext2_inode_large *inode,
> +					 struct inline_data *data)
> +{
> +	struct ext2_ext_attr_entry *entry;
> +	struct ext2_ext_attr_ibody_header *header;
> +
> +	header = IHDR(inode);
> +	entry = (struct ext2_ext_attr_entry *)
> +			((char *)inode + data->inline_off);
> +
> +	return (void *) (IFIRST(header) + entry->e_value_offs);
> +}
> +
>  int ext2fs_inode_has_inline_data(ext2_filsys fs, ext2_ino_t ino)
>  {
>  	struct ext2_inode inode;
> @@ -29,3 +79,85 @@ int ext2fs_inode_has_inline_data(ext2_filsys fs, ext2_ino_t ino)
>  
>  	return (inode.i_flags & EXT4_INLINE_DATA_FL);
>  }
> +
> +errcode_t ext2fs_inline_data_iterate(ext2_filsys fs,
> +			       ext2_ino_t ino,
> +			       int flags,
> +			       char *block_buf,
> +			       int (*func)(ext2_filsys fs,
> +					   char *buf,
> +					   unsigned int buf_len,
> +					   e2_blkcnt_t blockcnt,
> +					   struct ext2_inode_large *inode,
> +					   void *priv_data),
> +			       void *priv_data)
> +{
> +	struct dir_context *ctx;
> +	struct ext2_inode_large *inode;
> +	struct ext2_dir_entry dirent;
> +	struct inline_data data;
> +	errcode_t retval = 0;
> +	e2_blkcnt_t blockcnt = 0;
> +	void *inline_start;
> +	int inline_size;
> +
> +	ctx = (struct dir_context *)priv_data;
> +
> +	retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
> +	if (retval)
> +		return retval;
> +
> +	retval = ext2fs_read_inode_full(fs, ino, (void *)inode,
> +					EXT2_INODE_SIZE(fs->super));
> +	if (retval)
> +		goto out;
> +
> +	if (inode->i_size == 0)
> +		goto out;
> +
> +	/* we first check '.' and '..' dir */
> +	dirent.inode = ino;
> +	dirent.name_len = 1;
> +	ext2fs_set_rec_len(fs, EXT2_DIR_REC_LEN(2), &dirent);
> +	dirent.name[0] = '.';
> +	dirent.name[1] = '\0';
> +	retval |= (*func)(fs, (void *)&dirent, dirent.rec_len, blockcnt++,
> +			 inode, priv_data);
> +	if (retval & BLOCK_ABORT)
> +		goto out;
> +
> +	dirent.inode = (__u32)*inode->i_block;
> +	dirent.name_len = 2;
> +	ext2fs_set_rec_len(fs, EXT2_DIR_REC_LEN(3), &dirent);
> +	dirent.name[0] = '.';
> +	dirent.name[1] = '.';
> +	dirent.name[2] = '\0';
> +	retval |= (*func)(fs, (void *)&dirent, dirent.rec_len, blockcnt++,
> +			 inode, priv_data);
> +	if (retval & BLOCK_ABORT)
> +		goto out;

Perhaps this function should be called ext2fs_inline_dirblock_iterate()?
The name alone makes me think this function could work for regular inline_data
files, if such things ever exist.

--D

> +
> +	inline_start = (char *)inode->i_block + EXT4_INLINE_DATA_DOTDOT_SIZE;
> +	inline_size = EXT4_MIN_INLINE_DATA_SIZE - EXT4_INLINE_DATA_DOTDOT_SIZE;
> +	retval |= (*func)(fs, inline_start, inline_size, blockcnt++,
> +			 inode, priv_data);
> +	if (retval & BLOCK_ABORT)
> +		goto out;
> +
> +	retval = ext2fs_inline_data_find(fs, inode, &data);
> +	if (retval)
> +		goto out;
> +	if (data.inline_size > EXT4_MIN_INLINE_DATA_SIZE) {
> +		inline_start = ext2fs_get_inline_xattr_pos(inode, &data);
> +		inline_size = data.inline_size - EXT4_MIN_INLINE_DATA_SIZE;
> +		retval |= (*func)(fs, inline_start, inline_size, blockcnt++,
> +			 inode, priv_data);
> +		if (retval & BLOCK_ABORT)
> +			goto out;
> +	}
> +
> +out:
> +	retval |= BLOCK_ERROR;
> +	ext2fs_free_mem(&inode);
> +	return retval & BLOCK_ERROR ? ctx->errcode : 0;
> +}
> -- 
> 1.7.9.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
