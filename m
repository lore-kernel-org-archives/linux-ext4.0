From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH V4 17/22] ext4: let empty_dir handle inline dir.
Date: Fri, 6 Apr 2012 18:21:56 -0600
Message-ID: <B656C5E6-2795-4355-ABE4-6D9334CB7AFB@dilger.ca>
References: <4F41EF95.2000909@tao.ma> <1329721316-4955-1-git-send-email-tm@tao.ma> <1329721316-4955-17-git-send-email-tm@tao.ma>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:19829 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758431Ab2DGATh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Apr 2012 20:19:37 -0400
In-Reply-To: <1329721316-4955-17-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-02-20, at 12:01 AM, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> empty_dir is used when deleting a dir. So it should handle
> inline dir properly.
> 
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
> fs/ext4/inline.c |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> fs/ext4/namei.c  |    8 ++++++
> fs/ext4/xattr.h  |    6 ++++
> 3 files changed, 83 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 3126ac3..6612ce1 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -1436,6 +1436,75 @@ out:
> 	return err;
> }
> 
> +int empty_inline_dir(struct inode *dir, int *has_inline_data)
> +{
> +	int err, inline_size;
> +	struct ext4_iloc iloc;
> +	void *inline_pos;
> +	unsigned int offset;
> +	struct ext4_dir_entry_2 *de, *de1;
> +	int ret = 1;
> +
> +	err = ext4_get_inode_loc(dir, &iloc);
> +	if (err) {
> +		EXT4_ERROR_INODE(dir, "error %d getting inode %lu block",
> +				 err, dir->i_ino);
> +		return 1;
> +	}
> +
> +	down_read(&EXT4_I(dir)->xattr_sem);
> +	if (!ext4_has_inline_data(dir)) {
> +		*has_inline_data = 0;
> +		goto out;
> +	}
> +
> +	de = ext4_get_inline_entry(dir, &iloc, 0,
> +				   &inline_pos, &inline_size);
> +	de1 = ext4_get_inline_entry(dir, &iloc,
> +			ext4_rec_len_from_disk(de->rec_len, inline_size),
> +			&inline_pos, &inline_size);
> +	if (le32_to_cpu(de->inode) != dir->i_ino ||
> +			!le32_to_cpu(de1->inode) ||
> +			strcmp(".", de->name) ||
> +			strcmp("..", de1->name)) {
> +		ext4_warning(dir->i_sb,
> +			     "bad directory (dir #%lu) - no `.' or `..'",
> +			     dir->i_ino);
> +		ret = 1;
> +		goto out;
> +	}
> +
> +	offset = ext4_rec_len_from_disk(de->rec_len, inline_size) +
> +		 ext4_rec_len_from_disk(de1->rec_len, inline_size);
> +	while (offset < dir->i_size) {
> +		de = ext4_get_inline_entry(dir, &iloc, offset,
> +					   &inline_pos, &inline_size);
> +		if (ext4_check_dir_entry(dir, NULL, de,
> +					 iloc.bh, inline_pos,
> +					 inline_size, offset)) {
> +			ext4_warning(dir->i_sb,
> +				     "bad inline directory (dir #%lu) - "
> +				     "inode %u, rec_len %u, name_len %d"
> +				     "inline size %d\n",
> +				     dir->i_ino, le32_to_cpu(de->inode),
> +				     le16_to_cpu(de->rec_len), de->name_len,
> +				     inline_size);
> +			ret = 1;
> +			goto out;
> +		}

Most of the code in this function is duplicated with empty_dir().  Instead of
duplicating everything here, it seems that it is possible to just use the code
in empty_dir() with a few small changes:

- a helper function which reads the first directory block instead of ext4_bread() 
> +		if (le32_to_cpu(de->inode)) {
> +			ret = 0;
> +			goto out;
> +		}
> +		offset += ext4_rec_len_from_disk(de->rec_len, inline_size);
> +	}
> +
> +out:
> +	up_read(&EXT4_I(dir)->xattr_sem);
> +	brelse(iloc.bh);
> +	return ret;
> +}
> +
> int ext4_destroy_inline_data(handle_t *handle, struct inode *inode)
> {
> 	int ret;
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 9f7002c..b6b718e 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2015,6 +2015,14 @@ static int empty_dir(struct inode *inode)
> 	struct super_block *sb;
> 	int err = 0;
> 
> +	if (ext4_has_inline_data(inode)) {
> +		int has_inline_data = 1;
> +
> +		err = empty_inline_dir(inode, &has_inline_data);
> +		if (has_inline_data)
> +			return err;
> +	}
> +
> 	sb = inode->i_sb;
> 	if (inode->i_size < EXT4_DIR_REC_LEN(1) + EXT4_DIR_REC_LEN(2) ||
> 	    !(bh = ext4_bread(NULL, inode, 0, 0, &err))) {
> diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
> index 9991143..6ccfa8d 100644
> --- a/fs/ext4/xattr.h
> +++ b/fs/ext4/xattr.h
> @@ -176,6 +176,7 @@ extern int ext4_delete_inline_entry(handle_t *handle,
> 				    struct inode *dir,
> 				    struct ext4_dir_entry_2 *de_del,
> 				    struct buffer_head *bh);
> +extern int empty_inline_dir(struct inode *dir, int *has_inline_data);
> # else  /* CONFIG_EXT4_FS_XATTR */
> 
> static inline int
> @@ -373,6 +374,11 @@ static inline int ext4_delete_inline_entry(handle_t *handle,
> {
> 	return 0;
> }
> +
> +static inline int empty_inline_dir(struct inode *dir, int *has_inline_data)
> +{
> +	return 0;
> +}
> # endif  /* CONFIG_EXT4_FS_XATTR */
> 
> #ifdef CONFIG_EXT4_FS_SECURITY
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





