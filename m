From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v1 07/22] debugfs: make mkdir and expanddir command
 support inline data
Date: Fri, 11 Oct 2013 17:21:02 -0700
Message-ID: <20131012002102.GS6860@birch.djwong.org>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
 <1375436989-18948-8-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20029 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab3JLAVN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Oct 2013 20:21:13 -0400
Content-Disposition: inline
In-Reply-To: <1375436989-18948-8-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 02, 2013 at 05:49:34PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> This commit tries to make mkdir and expanddir command support inline
> date feature.
> 
> In ext2fs_expand_dir() function ext2fs_inline_data_convert() will be
> called to expand a directory with inline data.  It tries to allocate
> a block and copy all directory entries into it.
> 
> In ext2fs_mkdir() it calls ext2fs_new_dir_inline_data() function to
> create a new directory with inline data.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  lib/ext2fs/expanddir.c   |   18 +--
>  lib/ext2fs/ext2fs.h      |    5 +
>  lib/ext2fs/ext2fsP.h     |   13 +++
>  lib/ext2fs/inline_data.c |  280 ++++++++++++++++++++++++++++++++++++++++++++++
>  lib/ext2fs/mkdir.c       |  102 +++++++++++++----
>  lib/ext2fs/newdir.c      |   33 ++++++
>  6 files changed, 420 insertions(+), 31 deletions(-)
> 
> diff --git a/lib/ext2fs/expanddir.c b/lib/ext2fs/expanddir.c
> index 22558d6..9696b61 100644
> --- a/lib/ext2fs/expanddir.c
> +++ b/lib/ext2fs/expanddir.c
> @@ -19,13 +19,7 @@
>  #include "ext2_fs.h"
>  #include "ext2fs.h"
>  
> -struct expand_dir_struct {
> -	int		done;
> -	int		newblocks;
> -	blk64_t		goal;
> -	errcode_t	err;
> -	ext2_ino_t	dir;
> -};
> +#include "ext2fsP.h"
>  
>  static int expand_dir_proc(ext2_filsys	fs,
>  			   blk64_t	*blocknr,
> @@ -114,6 +108,16 @@ errcode_t ext2fs_expand_dir(ext2_filsys fs, ext2_ino_t dir)
>  	es.newblocks = 0;
>  	es.dir = dir;
>  
> +	if (ext2fs_inode_has_inline_data(fs, dir)) {
> +		retval = ext2fs_inline_data_convert(fs, dir, &es);
> +		if (retval)
> +			return retval;
> +		if (!es.done)
> +			return EXT2_ET_EXPAND_DIR_ERR;
> +
> +		return 0;
> +	}
> +
>  	retval = ext2fs_block_iterate3(fs, dir, BLOCK_FLAG_APPEND,
>  				       0, expand_dir_proc, &es);
>  
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 6e3bf6e..934dbd0 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -1356,6 +1356,9 @@ extern errcode_t ext2fs_inline_data_iterate(ext2_filsys fs,
>  						  struct ext2_inode_large *inode,
>  						  void *priv_data),
>  				      void *priv_data);
> +extern errcode_t ext2fs_inline_data_create(ext2_filsys fs,
> +					   struct ext2_inode_large *inode,
> +					   unsigned int len);
>  
>  /* inode.c */
>  extern void ext2fs_free_inode_cache(struct ext2_inode_cache *icache);
> @@ -1430,6 +1433,8 @@ int ext2fs_native_flag(void);
>  /* newdir.c */
>  extern errcode_t ext2fs_new_dir_block(ext2_filsys fs, ext2_ino_t dir_ino,
>  				ext2_ino_t parent_ino, char **block);
> +extern errcode_t ext2fs_new_dir_inline_data(ext2_filsys fs, ext2_ino_t dir_ino,
> +				ext2_ino_t parent_ino, struct ext2_inode *inode);
>  
>  /* mkdir.c */
>  extern errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
> diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
> index e86d452..ed89272 100644
> --- a/lib/ext2fs/ext2fsP.h
> +++ b/lib/ext2fs/ext2fsP.h
> @@ -62,6 +62,17 @@ struct dir_context {
>  };
>  
>  /*
> + * For expanding directory
> + */
> +struct expand_dir_struct {
> +	int		done;
> +	int		newblocks;
> +	blk64_t		goal;
> +	errcode_t	err;
> +	ext2_ino_t	dir;
> +};
> +
> +/*
>   * Inode cache structure
>   */
>  struct ext2_inode_cache {
> @@ -97,6 +108,8 @@ extern int ext2fs_process_dir_inline_data(ext2_filsys	fs,
>  extern errcode_t ext2fs_inline_data_find(ext2_filsys fs,
>  					 struct ext2_inode_large *inode,
>  					 struct inline_data *data);
> +extern errcode_t ext2fs_inline_data_convert(ext2_filsys fs, ext2_ino_t ino,
> +					    void *priv_data);
>  
>  /* Generic numeric progress meter */
>  
> diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
> index 1220418..c936e28 100644
> --- a/lib/ext2fs/inline_data.c
> +++ b/lib/ext2fs/inline_data.c
> @@ -21,6 +21,14 @@
>  
>  static void *ext2fs_get_inline_xattr_pos(struct ext2_inode_large *inode,
>  					 struct inline_data *data);
> +static void ext2fs_inline_data_finish_convert(ext2_filsys fs, ext2_ino_t ino,
> +					      char *target, char *buf,
> +					      int inline_size);
> +static void ext2fs_update_final_de(ext2_filsys fs, char *de_buf,
> +				   int old_size, int new_size);
> +static errcode_t ext2fs_inline_data_destory_data(ext2_filsys fs, ext2_ino_t ino,

Do you mean "destroy" and not "destory"?

> +					   struct ext2_inode_large *inode,
> +					   struct inline_data *data);
>  
>  errcode_t ext2fs_inline_data_find(ext2_filsys fs,
>  				  struct ext2_inode_large *inode,
> @@ -68,6 +76,48 @@ static void *ext2fs_get_inline_xattr_pos(struct ext2_inode_large *inode,
>  	return (void *) (IFIRST(header) + entry->e_value_offs);
>  }
>  
> +static errcode_t ext2fs_inline_data_destory_data(ext2_filsys fs, ext2_ino_t ino,
> +						 struct ext2_inode_large *inode,
> +						 struct inline_data *data)
> +{
> +	struct ext2_ext_attr_ibody_header *header;
> +	struct ext2_ext_attr_search s = {
> +		.not_found = ENODATA,
> +	};
> +	struct ext2_ext_attr_info i = {
> +		.name_index = EXT4_EXT_ATTR_INDEX_SYSTEM,
> +		.name = EXT4_EXT_ATTR_SYSTEM_DATA,
> +		.value = "",
> +		.value_len = 0,
> +	};
> +	errcode_t retval;
> +
> +	if (!data->inline_off)
> +		return 0;
> +
> +	if (inode->i_extra_isize > (EXT2_INODE_SIZE(fs->super) -
> +				    EXT2_GOOD_OLD_INODE_SIZE))
> +		return EXT2_ET_BAD_EXTRA_SIZE;
> +
> +	header = IHDR(inode);
> +	if (header->h_magic != EXT2_EXT_ATTR_MAGIC)
> +		return EXT2_ET_BAD_EXT_ATTR_MAGIC;
> +
> +	retval = ext2fs_ext_attr_ibody_find(fs, inode, &i, &s);
> +	if (retval)
> +		return retval;
> +
> +	if (!s.not_found) {
> +		retval = ext2fs_ext_attr_set_entry(&i, &s);
> +		if (retval)
> +			return retval;
> +	}
> +
> +	memset((void *)inode->i_block, 0, EXT4_MIN_INLINE_DATA_SIZE);
> +
> +	return 0;
> +}
> +
>  int ext2fs_inode_has_inline_data(ext2_filsys fs, ext2_ino_t ino)
>  {
>  	struct ext2_inode inode;
> @@ -107,6 +157,83 @@ out:
>  	return size;
>  }
>  
> +static void ext2fs_update_final_de(ext2_filsys fs, char *de_buf,
> +				   int old_size, int new_size)

What does this update?  I think it changes the last dirent's rec_len so that it
covers the rest of the (new) block, but a comment would be helpful.

> +{
> +	struct ext2_dir_entry *de, *prev_de;
> +	char *limit;
> +	unsigned int de_len;
> +
> +	de = (struct ext2_dir_entry *)de_buf;
> +	if (old_size) {
> +		limit = de_buf + old_size;
> +		do {
> +			prev_de = de;
> +			ext2fs_get_rec_len(fs, de, &de_len);
> +			de_buf += de_len;
> +			de = (struct ext2_dir_entry *)de_buf;
> +		} while (de_buf < limit);
> +
> +		ext2fs_set_rec_len(fs, de_len + new_size - old_size,
> +				   prev_de);
> +	} else {
> +		de->inode = 0;
> +		ext2fs_set_rec_len(fs, new_size, de);
> +	}
> +}
> +
> +static void ext2fs_inline_data_finish_convert(ext2_filsys fs, ext2_ino_t ino,
> +					      char *target, char *buf,
> +					      int inline_size)
> +{
> +	struct ext2_dir_entry *de;
> +	struct ext2_dir_entry_tail *t;
> +	int header_size = 0;
> +	int csum_size = 0;
> +	int filetype = 0;
> +
> +	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
> +				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> +		csum_size = sizeof(struct ext2_dir_entry_tail);
> +
> +	/* First create '.' and '..' */
> +	if (fs->super->s_feature_incompat &
> +	    EXT2_FEATURE_INCOMPAT_FILETYPE)
> +		filetype = EXT2_FT_DIR << 8;
> +
> +	de = (struct ext2_dir_entry *)target;
> +	de->inode = ino;
> +	de->name_len = 1 | filetype;
> +	de->name[0] = '.';
> +	de->name[1] = '\0';
> +	de->rec_len = EXT2_DIR_REC_LEN(1);
> +
> +	de = (struct ext2_dir_entry *)(target + de->rec_len);
> +	de->rec_len = EXT2_DIR_REC_LEN(2);
> +	de->inode = ((struct ext2_dir_entry *)buf)->inode;
> +	de->name_len = 2 | filetype;
> +	de->name[0] = '.';
> +	de->name[1] = '.';
> +	de->name[2] = '\0';
> +
> +	de = (struct ext2_dir_entry *)(target +
> +				       EXT2_DIR_REC_LEN(1) +
> +				       EXT2_DIR_REC_LEN(2));
> +	header_size = (char *)de - (char *)target;
> +
> +	memcpy((void *)de, buf + EXT4_INLINE_DATA_DOTDOT_SIZE,
> +		inline_size - EXT4_INLINE_DATA_DOTDOT_SIZE);
> +
> +	ext2fs_update_final_de(fs, target,
> +		inline_size - EXT4_INLINE_DATA_DOTDOT_SIZE + header_size,
> +		fs->blocksize - csum_size);
> +
> +	if (csum_size) {
> +		t = EXT2_DIRENT_TAIL(target, fs->blocksize);
> +		ext2fs_initialize_dirent_tail(fs, t);
> +	}
> +}
> +
>  errcode_t ext2fs_inline_data_iterate(ext2_filsys fs,
>  			       ext2_ino_t ino,
>  			       int flags,
> @@ -188,3 +315,156 @@ out:
>  	ext2fs_free_mem(&inode);
>  	return retval & BLOCK_ERROR ? ctx->errcode : 0;
>  }
> +
> +errcode_t ext2fs_inline_data_convert(ext2_filsys fs,
> +				     ext2_ino_t  ino,
> +				     void *priv_data)
> +{
> +	struct expand_dir_struct *es;
> +	struct ext2_inode_large *inode;
> +	struct inline_data data;
> +	ext2_extent_handle_t handle;
> +	errcode_t retval;
> +	blk64_t blk;
> +	char *backup_buf;
> +	char *blk_buf;
> +	unsigned int inline_size;
> +
> +	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
> +
> +	es = (struct expand_dir_struct *)priv_data;
> +	retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
> +	if (retval)
> +		return retval;
> +
> +	retval = ext2fs_read_inode_full(fs, ino, (void *)inode,
> +					EXT2_INODE_SIZE(fs->super));
> +	if (retval)
> +		goto out;
> +
> +	retval = ext2fs_inline_data_find(fs, inode, &data);
> +	if (retval)
> +		goto out;
> +
> +	inline_size = data.inline_size;
> +	retval = ext2fs_get_mem(inline_size, &backup_buf);
> +	if (retval)
> +		goto out;
> +
> +	memcpy(backup_buf, (void *)inode->i_block, EXT4_MIN_INLINE_DATA_SIZE);
> +	if (inline_size > EXT4_MIN_INLINE_DATA_SIZE)
> +		memcpy(backup_buf + EXT4_MIN_INLINE_DATA_SIZE,
> +		       ext2fs_get_inline_xattr_pos(inode, &data),
> +		       inline_size - EXT4_MIN_INLINE_DATA_SIZE);
> +
> +	/* clear the entry and the flag in dir now */
> +	retval = ext2fs_inline_data_destory_data(fs, ino, inode, &data);
> +	if (retval)
> +		goto out1;
> +
> +	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS) {
> +		if (LINUX_S_ISDIR(inode->i_mode) ||
> +		    LINUX_S_ISREG(inode->i_mode) ||
> +		    LINUX_S_ISLNK(inode->i_mode))
> +			inode->i_flags |= EXT4_EXTENTS_FL;
> +	}
> +
> +	inode->i_flags &= ~EXT4_INLINE_DATA_FL;
> +
> +	retval = ext2fs_new_block2(fs, 0, 0, &blk);
> +	if (retval)
> +		goto out1;
> +
> +	ext2fs_iblk_set(fs, (void*)inode, 1);
> +	if (!(fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS))

This should test the iflag.  Or, maybe it should use ext2fs_bmap2()?

> +		inode->i_block[0] = blk;
> +	inode->i_size = fs->blocksize;
> +
> +	retval = ext2fs_get_mem(fs->blocksize, &blk_buf);
> +	if (retval)
> +		goto out1;
> +
> +	memset(blk_buf, 0, sizeof(fs->blocksize));
> +	if (LINUX_S_ISDIR(inode->i_mode)) {
> +		/* set the final dir entry to cover the whole block */
> +		ext2fs_inline_data_finish_convert(fs, ino, blk_buf, backup_buf,
> +						  inline_size);
> +	} else {
> +		memcpy(blk_buf, backup_buf, inline_size);
> +	}
> +
> +	retval = ext2fs_write_dir_block4(fs, blk, blk_buf, 0, ino);

This should only ever be called against directory blocks.  If this is a regular
file or a symlink, it'll probably complain about not finding the checksum
space.

> +	if (retval)
> +		goto out2;
> +	retval = ext2fs_write_inode_full(fs, ino, (void *)inode,
> +					 EXT2_INODE_SIZE(fs->super));
> +	if (retval)
> +		goto out2;
> +
> +	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS) {
> +		retval = ext2fs_extent_open2(fs, ino, (void *)inode, &handle);

ext2fs_bmap2()?

> +		if (retval)
> +			goto out2;
> +		retval = ext2fs_extent_set_bmap(handle, 0, blk, 0);
> +		ext2fs_extent_free(handle);
> +		if (retval)
> +			goto out2;
> +	}
> +
> +	ext2fs_block_alloc_stats2(fs, blk, +1);
> +
> +out2:
> +	ext2fs_free_mem(&blk_buf);
> +out1:
> +	ext2fs_free_mem(&backup_buf);
> +out:
> +	ext2fs_free_mem(&inode);
> +
> +	if (retval) {
> +		es->err = retval;
> +	} else {
> +		es->done = 1;
> +		es->newblocks++;
> +		es->goal = blk;
> +	}
> +	return retval;
> +}
> +
> +errcode_t ext2fs_inline_data_create(ext2_filsys fs,
> +				    struct ext2_inode_large *inode,
> +				    unsigned int len)
> +{
> +	struct ext2_ext_attr_ibody_header *header;
> +	struct ext2_ext_attr_search s = {
> +		.not_found = ENODATA,
> +	};
> +	struct ext2_ext_attr_info i = {
> +		.name_index = EXT4_EXT_ATTR_INDEX_SYSTEM,
> +		.name = EXT4_EXT_ATTR_SYSTEM_DATA,
> +	};
> +	void *buf;
> +	errcode_t retval;
> +
> +	if (len > EXT4_MIN_INLINE_DATA_SIZE) {
> +		i.value = EXT2_ZERO_EXT_ATTR_VALUE;
> +		i.value_len = len - EXT4_MIN_INLINE_DATA_SIZE;
> +	} else {
> +		i.value = "";
> +		i.value_len = 0;
> +	}
> +
> +	retval = ext2fs_ext_attr_ibody_find(fs, inode, &i, &s);
> +	if (retval)
> +		return retval;
> +	retval = ext2fs_ext_attr_set_entry(&i, &s);
> +	if (retval)
> +		return retval;
> +
> +	header = IHDR(inode);
> +	if (!EXT2_EXT_IS_LAST_ENTRY(s.first))
> +		header->h_magic = EXT2_EXT_ATTR_MAGIC;
> +	else
> +		header->h_magic = 0;
> +
> +	return 0;
> +}
> diff --git a/lib/ext2fs/mkdir.c b/lib/ext2fs/mkdir.c
> index 4a85439..a6aeb0d 100644
> --- a/lib/ext2fs/mkdir.c
> +++ b/lib/ext2fs/mkdir.c
> @@ -36,11 +36,13 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
>  {
>  	ext2_extent_handle_t	handle;
>  	errcode_t		retval;
> -	struct ext2_inode	parent_inode, inode;
> +	struct ext2_inode	parent_inode, *inode = NULL;
> +	struct ext2_inode_large *large_inode = NULL;
>  	ext2_ino_t		ino = inum;
>  	ext2_ino_t		scratch_ino;
>  	blk64_t			blk;
>  	char			*block = 0;
> +	int			inline_data = 0;
>  
>  	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
>  
> @@ -55,16 +57,38 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
>  	}
>  
>  	/*
> +	 * We try to create a new directory with inline data if this feature
> +	 * is enabled.  Here we don't try to do this if ino < first_ino or
> +	 * the directory name is 'lost+found'.
> +	 */
> +	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_INLINE_DATA &&
> +	    ino >= EXT2_FIRST_INO(fs->super) && strcmp("lost+found", name) != 0)
> +		inline_data = 1;

What if I mkdir -p /mnt/sub/dir/lost+found ?

> +
> +	/*
>  	 * Allocate a data block for the directory
>  	 */
> -	retval = ext2fs_new_block2(fs, 0, 0, &blk);
> +	if (!inline_data) {
> +		retval = ext2fs_new_block2(fs, 0, 0, &blk);
> +		if (retval)
> +			goto cleanup;
> +	}
> +
> +	/*
> +	 * Allocate a new inode structuure
> +	 */
> +	retval = ext2fs_get_memzero(EXT2_INODE_SIZE(fs->super), &large_inode);
>  	if (retval)
>  		goto cleanup;
> +	inode = (struct ext2_inode *) large_inode;
>  
>  	/*
>  	 * Create a scratch template for the directory
>  	 */
> -	retval = ext2fs_new_dir_block(fs, ino, parent, &block);
> +	if (inline_data)
> +		retval = ext2fs_new_dir_inline_data(fs, ino, parent, inode);
> +	else
> +		retval = ext2fs_new_dir_block(fs, ino, parent, &block);
>  	if (retval)
>  		goto cleanup;
>  
> @@ -81,37 +105,61 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
>  	/*
>  	 * Create the inode structure....
>  	 */
> -	memset(&inode, 0, sizeof(struct ext2_inode));
> -	inode.i_mode = LINUX_S_IFDIR | (0777 & ~fs->umask);
> -	inode.i_uid = inode.i_gid = 0;
> -	ext2fs_iblk_set(fs, &inode, 1);
> -	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS)
> -		inode.i_flags |= EXT4_EXTENTS_FL;
> +	inode->i_mode = LINUX_S_IFDIR | (0777 & ~fs->umask);
> +	inode->i_uid = inode->i_gid = 0;
> +	ext2fs_iblk_set(fs, inode, 1);

Just to confirm, i_blocks should be nonzero for inline data?

> +	if (inline_data)
> +		inode->i_flags |= EXT4_INLINE_DATA_FL;
> +	else if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS)
> +		inode->i_flags |= EXT4_EXTENTS_FL;
>  	else
> -		inode.i_block[0] = blk;
> -	inode.i_links_count = 2;
> -	inode.i_size = fs->blocksize;
> +		inode->i_block[0] = blk;
> +	inode->i_links_count = 2;
>  
>  	/*
>  	 * Write out the inode and inode data block.  The inode generation
>  	 * number is assigned by write_new_inode, which means that the call
>  	 * to write_dir_block must come after that.
> +	 *
> +	 * If we try to create an new inode with inline data, we should call
> +	 * ext2fs_write_inode_full to avoid to initialize extra part.
>  	 */
> -	retval = ext2fs_write_new_inode(fs, ino, &inode);
> -	if (retval)
> -		goto cleanup;
> -	retval = ext2fs_write_dir_block4(fs, blk, block, 0, ino);
> -	if (retval)
> -		goto cleanup;
> +	if (inline_data) {
> +		__u32 t = fs->now ? fs->now : time(NULL);
> +
> +		inode->i_size = EXT4_MIN_INLINE_DATA_SIZE;
> +		inode->i_blocks = 0;
> +		if (!inode->i_ctime)
> +			inode->i_ctime = t;
> +		if (!inode->i_mtime)
> +			inode->i_mtime = t;
> +		if (!inode->i_atime)
> +			inode->i_atime = t;
> +		if (!large_inode->i_crtime)
> +			large_inode->i_crtime = t;
> +		retval = ext2fs_write_inode_full(fs, ino, inode,
> +						 EXT2_INODE_SIZE(fs->super));
> +		if (retval)
> +			goto cleanup;
> +	} else {
> +		inode->i_size = fs->blocksize;
>  
> -	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS) {
> -		retval = ext2fs_extent_open2(fs, ino, &inode, &handle);
> +		retval = ext2fs_write_new_inode(fs, ino, inode);
>  		if (retval)
>  			goto cleanup;
> -		retval = ext2fs_extent_set_bmap(handle, 0, blk, 0);
> -		ext2fs_extent_free(handle);
> +		retval = ext2fs_write_dir_block4(fs, blk, block, 0, ino);
>  		if (retval)
>  			goto cleanup;
> +
> +		if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS) {

ext2fs_bmap()? Or, test the iflag.

> +			retval = ext2fs_extent_open2(fs, ino, inode, &handle);
> +			if (retval)
> +				goto cleanup;
> +			retval = ext2fs_extent_set_bmap(handle, 0, blk, 0);
> +			ext2fs_extent_free(handle);
> +			if (retval)
> +				goto cleanup;
> +		}
>  	}
>  
>  	/*
> @@ -136,6 +184,10 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
>  	 * Update parent inode's counts
>  	 */
>  	if (parent != ino) {
> +		/* Reload parent inode due to inline data */
> +		retval = ext2fs_read_inode(fs, parent, &parent_inode);
> +		if (retval)
> +			goto cleanup;
>  		parent_inode.i_links_count++;
>  		retval = ext2fs_write_inode(fs, parent, &parent_inode);
>  		if (retval)
> @@ -145,14 +197,16 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
>  	/*
>  	 * Update accounting....
>  	 */
> -	ext2fs_block_alloc_stats2(fs, blk, +1);
> +	if (!inline_data)
> +		ext2fs_block_alloc_stats2(fs, blk, +1);
>  	ext2fs_inode_alloc_stats2(fs, ino, +1, 1);
>  
>  cleanup:
> +	if (large_inode)
> +		ext2fs_free_mem(&large_inode);
>  	if (block)
>  		ext2fs_free_mem(&block);
>  	return retval;
> -
>  }
>  
>  
> diff --git a/lib/ext2fs/newdir.c b/lib/ext2fs/newdir.c
> index 2cd541d..cec99e9 100644
> --- a/lib/ext2fs/newdir.c
> +++ b/lib/ext2fs/newdir.c
> @@ -87,3 +87,36 @@ errcode_t ext2fs_new_dir_block(ext2_filsys fs, ext2_ino_t dir_ino,
>  	*block = buf;
>  	return 0;
>  }
> +
> +/*
> + * Create new directory in inode
> + */
> +errcode_t ext2fs_new_dir_inline_data(ext2_filsys fs,
> +				     ext2_ino_t dir_ino,
> +				     ext2_ino_t parent_ino,
> +				     struct ext2_inode *inode)
> +{
> +	struct ext2_inode_large *large_inode;
> +	struct ext2_dir_entry *dir = NULL;
> +	int inline_size = EXT4_MIN_INLINE_DATA_SIZE;
> +	errcode_t retval;
> +
> +	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
> +
> +	large_inode = (struct ext2_inode_large *) inode;
> +	large_inode->i_extra_isize = sizeof(struct ext2_inode_large) -
> +		EXT2_GOOD_OLD_INODE_SIZE;
> +	retval = ext2fs_inline_data_create(fs, large_inode, inline_size);
> +	if (retval)
> +		return retval;
> +
> +	dir = (struct ext2_dir_entry *) inode->i_block;
> +	dir->inode = parent_ino;
> +
> +	dir = (struct ext2_dir_entry *) ((char *) dir +
> +					 EXT4_INLINE_DATA_DOTDOT_SIZE);
> +	dir->inode = 0;
> +	dir->rec_len = inline_size - EXT4_INLINE_DATA_DOTDOT_SIZE;
> +
> +	return retval;
> +}
> -- 
> 1.7.9.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
