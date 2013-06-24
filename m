From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/3] ext4: Add EXT4_IOC_TRUNCATE_BLOCK_RANGE ioctl
Date: Sun, 23 Jun 2013 19:55:09 -0600
Message-ID: <6952E758-B52D-4A78-AAD4-53FA0B09291B@dilger.ca>
References: <1371967656-3150-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"a.sangwan@samsung.com" <a.sangwan@samsung.com>,
	Namjae Jeon <linkinjeon@gmail.com>,
	Namjae Jeon <namjae.jeon@samsung.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:54506 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab3FXBzO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Jun 2013 21:55:14 -0400
Received: by mail-ie0-f181.google.com with SMTP id x12so23729718ief.12
        for <linux-ext4@vger.kernel.org>; Sun, 23 Jun 2013 18:55:13 -0700 (PDT)
In-Reply-To: <1371967656-3150-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-06-23, at 0:07, Namjae Jeon <linkinjeon@gmail.com> wrote:

> From: Namjae Jeon <namjae.jeon@samsung.com>
> The EXT4_IOC_TRUNCATE_BLOCK_RANGE removes the data blocks lying
> between [start, "start + length") and updates the logical block numbers
> of data blocks starting from "start + length" block to last block of file.
> This will maintain contiguous nature of logical block numbers
> after block removal.
> Both the inode's disksize and logical size are updated after block
> removal

I don't think "truncate" describes this operation very well. It is more like "punch hole and shrink size". 

The real question I have for both this operation is what practical use it has. I don't think that "editing a movie clip" is a real example, because the stream will not align on block boundaries, and will just result in copying most of the file data if it is a byte-aligned operation.

Cheers, Andreas

> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> ---
> fs/ext4/ext4.h         |    8 ++
> fs/ext4/ext4_extents.h |    3 +
> fs/ext4/extents.c      |  245 ++++++++++++++++++++++++++++++++++++++++++++++++
> fs/ext4/ioctl.c        |   62 ++++++++++++
> 4 files changed, 318 insertions(+)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 6ed348d..df2c411 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -590,6 +590,7 @@ enum {
> #define EXT4_IOC_MOVE_EXT        _IOWR('f', 15, struct move_extent)
> #define EXT4_IOC_RESIZE_FS        _IOW('f', 16, __u64)
> #define EXT4_IOC_SWAP_BOOT        _IO('f', 17)
> +#define EXT4_IOC_TRUNCATE_BLOCK_RANGE    _IOW('f', 18, struct truncate_range)
> 
> #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
> /*
> @@ -682,6 +683,11 @@ struct move_extent {
>    __u64 moved_len;    /* moved block length */
> };
> 
> +struct truncate_range {
> +    __u32 start_block;
> +    __u32 length;
> +};
> +
> #define EXT4_EPOCH_BITS 2
> #define EXT4_EPOCH_MASK ((1 << EXT4_EPOCH_BITS) - 1)
> #define EXT4_NSEC_MASK  (~0UL << EXT4_EPOCH_BITS)
> @@ -2692,6 +2698,8 @@ extern int ext4_find_delalloc_range(struct inode *inode,
> extern int ext4_find_delalloc_cluster(struct inode *inode, ext4_lblk_t lblk);
> extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>            __u64 start, __u64 len);
> +extern int ext4_ext_truncate_range(struct inode *inode, ext4_lblk_t start,
> +                   ext4_lblk_t end, ext4_lblk_t last_block);
> 
> 
> /* move_extent.c */
> diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
> index 51bc821..cc113cc 100644
> --- a/fs/ext4/ext4_extents.h
> +++ b/fs/ext4/ext4_extents.h
> @@ -178,6 +178,9 @@ struct ext4_ext_path {
> #define EXT_MAX_INDEX(__hdr__) \
>    (EXT_FIRST_INDEX((__hdr__)) + le16_to_cpu((__hdr__)->eh_max) - 1)
> 
> +#define EXTENT_START_FLAG    0x1
> +#define INDEX_START_FLAG    0x2
> +
> static inline struct ext4_extent_header *ext_inode_hdr(struct inode *inode)
> {
>    return (struct ext4_extent_header *) EXT4_I(inode)->i_data;
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 937593e..ed85e34 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4757,3 +4757,248 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> 
>    return error;
> }
> +
> +/*
> + * ext4_trange_dirty_path: Function to mark the path buffer dirty.
> + * It also checks if there are sufficient credits left in the
> + * journal to update metadata. If the number of credits are less
> + * restart the handle with additional credits.
> + *
> + * @handle: journal handle
> + * @inode: file inode
> + * @path: pointer to path
> + * @num: number of inodes to be updated
> + *
> + * Returns: 0 on success or negative value on error
> + */
> +int ext4_trange_dirty_path(handle_t *handle, struct inode *inode,
> +               struct ext4_ext_path *path,
> +               int num, ...)
> +{
> +    int credits, err, i;
> +    struct inode *iptr;
> +    va_list args;
> +
> +    /*
> +     * Check if need to extend journal credits
> +     * 3 for leaf, sb, and inode plus 2 (bmap and group
> +     * descriptor) for each block group; assume two block
> +     * groups
> +     */
> +    if (handle->h_buffer_credits < 7*(num + 1)) {
> +        credits = ext4_writepage_trans_blocks(inode);
> +        va_start(args, num);
> +        for (i = 1; i <= num; i++) {
> +            iptr = va_arg(args, struct inode *);
> +            credits += ext4_writepage_trans_blocks(iptr);
> +        }
> +        va_end(args);
> +        err = ext4_ext_truncate_extend_restart(handle, inode, credits);
> +        /* EAGAIN is success */
> +        if (err && err != -EAGAIN)
> +            return err;
> +    }
> +    err = ext4_ext_get_access(handle, inode, path);
> +    return err;
> +}
> +
> +/*
> + * ext4_ext_update_path: update the extents of a path structure
> + * lying between path[depth].p_ext and EXT_LAST_EXTENT(path[depth].p_hdr)
> + * subtracting shift from starting block for each extent.
> + *
> + * @path: path for which extents are updated
> + * @shift: Number of blocks to be subtracted from first logical block
> + * that extent covers for each extent.
> + * @inode: file inode
> + * @handle: journal handle
> + * @start_block: Points to the starting block of next extent which is
> + * to be updated.
> + *
> + * Returns: 0 on success or negative on error.
> + */
> +int ext4_ext_update_path(struct ext4_ext_path *path, ext4_lblk_t shift,
> +             struct inode *inode, handle_t *handle,
> +             ext4_lblk_t *start_block)
> +{
> +    int depth, err = 0, flag = 0;
> +    struct ext4_extent *ex_start, *ex_last;
> +
> +    depth = path->p_depth;
> +    while (depth >= 0) {
> +        if (depth == path->p_depth) {
> +            ex_start = path[depth].p_ext;
> +            if (!ex_start)
> +                return -EIO;
> +
> +            err = ext4_trange_dirty_path(handle, inode,
> +                             path + depth, 0);
> +            if (err)
> +                goto out;
> +
> +            if (path[depth].p_ext ==
> +                EXT_FIRST_EXTENT(path[depth].p_hdr))
> +                flag |= EXTENT_START_FLAG;
> +
> +            ex_last = EXT_LAST_EXTENT(path[depth].p_hdr);
> +            while (ex_start <= ex_last) {
> +                *start_block = ex_start->ee_block +
> +                    ext4_ext_get_actual_len(ex_start);
> +                ex_start->ee_block -= shift;
> +                ex_start++;
> +            }
> +            err = ext4_ext_dirty(handle, inode, path + depth);
> +            if (err)
> +                goto out;
> +        } else {
> +            /* If encountered starting extent, update index too */
> +            if (path->p_depth - depth == 1) {
> +                if (flag & EXTENT_START_FLAG) {
> +                    /* Update index too */
> +                    err = ext4_trange_dirty_path(handle,
> +                            inode, path + depth, 0);
> +                    if (err)
> +                        goto out;
> +                    path[depth].p_idx->ei_block -= shift;
> +                    err = ext4_ext_dirty(handle, inode,
> +                                 path + depth);
> +                    if (err)
> +                        goto out;
> +                    flag &= ~EXTENT_START_FLAG;
> +                } else
> +                    /* No need to update any extent index */
> +                    break;
> +            }
> +            /* Check, if earlier encountered starting index */
> +            if (flag & INDEX_START_FLAG) {
> +                err = ext4_trange_dirty_path(handle, inode,
> +                            path + (depth), 0);
> +                if (err)
> +                    goto out;
> +                path[depth].p_idx->ei_block -= shift;
> +                err = ext4_ext_dirty(handle, inode,
> +                             path + depth);
> +                if (err)
> +                    goto out;
> +                flag &= ~INDEX_START_FLAG;
> +            }
> +            /* Check if this is a starting index */
> +            if (path[depth].p_idx ==
> +                EXT_FIRST_INDEX(path[depth].p_hdr)) {
> +                /* starting of a block */
> +                flag |= INDEX_START_FLAG;
> +            } else
> +                break;
> +        }
> +        depth--;
> +    }
> +out:
> +    return err;
> +}
> +
> +/*
> + * ext4_ext_update_logical: update logical blocks ranging from start
> + * to the end block for inode by moving them shift blocks to the left
> + *
> + * @inode: file inode
> + * @handle: journal handle
> + * @start_block : starting block for block updation
> + * @shift: number of blocks to be shifted
> + * @end_block: last block to be updated
> + *
> + * Returns: 0 on success or negative on failure
> + */
> +static int ext4_ext_update_logical(struct inode *inode, handle_t *handle,
> +                   ext4_lblk_t start_block, ext4_lblk_t shift,
> +                   ext4_lblk_t end_block)
> +{
> +    struct ext4_ext_path *path;
> +    int err = 0;
> +
> +    while (start_block < end_block) {
> +        path = ext4_ext_find_extent(inode, start_block, NULL);
> +        if (IS_ERR(path)) {
> +            err = PTR_ERR(path);
> +            break;
> +        }
> +        err = ext4_ext_update_path(path, shift, inode,
> +                       handle, &start_block);
> +        ext4_ext_drop_refs(path);
> +        kfree(path);
> +        if (err)
> +            break;
> +    }
> +    return err;
> +}
> +
> +/*
> + * ext4_ext_truncate_range: truncate the block range from start
> + * block to end block including the end block from inode.
> + *
> + * @inode: file inode
> + * @start: start block
> + * @end: end block
> + * last_block: last_block number of the inode
> + *
> + * Returns: 0 on success or negative on error
> + */
> +int ext4_ext_truncate_range(struct inode *inode, ext4_lblk_t start,
> +                ext4_lblk_t end, ext4_lblk_t last_block)
> +{
> +    int ret, credits;
> +    ext4_lblk_t shift = end - start + 1;
> +    handle_t *handle;
> +    loff_t isize_reduced;
> +    int blkbits = inode->i_blkbits;
> +    struct address_space *mapping = inode->i_mapping;
> +
> +    /* sync dirty pages for transfer */
> +    if (mapping->nrpages && mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
> +        ret = filemap_write_and_wait_range(mapping,
> +                (loff_t)start << blkbits,
> +                ((loff_t)(last_block + 1) << blkbits) - 1);
> +        if (ret)
> +            return ret;
> +    }
> +    truncate_inode_pages_range(inode->i_mapping,
> +                   start << inode->i_blkbits, -1);
> +    ext4_inode_block_unlocked_dio(inode);
> +    inode_dio_wait(inode);
> +    down_write(&EXT4_I(inode)->i_data_sem);
> +    ext4_discard_preallocations(inode);
> +    ret = ext4_es_remove_extent(inode, start, end - start + 1);
> +    if (ret)
> +        goto out;
> +
> +    credits = ext4_writepage_trans_blocks(inode);
> +    handle = ext4_journal_start(inode, EXT4_HT_TRUNCATE, credits);
> +    if (IS_ERR(handle)) {
> +        ret = PTR_ERR(handle);
> +        goto out;
> +    }
> +
> +    ret = ext4_ext_remove_space(inode, start, end);
> +    if (ret)
> +        goto journal_stop;
> +
> +    ext4_discard_preallocations(inode);
> +
> +    if (end < last_block) {
> +        ret = ext4_ext_update_logical(inode, handle, end + 1,
> +                          shift, last_block + 1);
> +        if (ret)
> +            goto journal_stop;
> +    }
> +    isize_reduced = (loff_t)shift << blkbits;
> +    i_size_write(inode, inode->i_size - isize_reduced);
> +    EXT4_I(inode)->i_disksize -= isize_reduced;
> +    inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
> +    ext4_mark_inode_dirty(handle, inode);
> +journal_stop:
> +    ext4_journal_stop(handle);
> +out:
> +    ext4_inode_resume_unlocked_dio(inode);
> +    up_write(&EXT4_I(inode)->i_data_sem);
> +    return ret;
> +}
> +
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 9491ac0..0530daf 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -622,6 +622,68 @@ resizefs_out:
> 
>        return 0;
>    }
> +    case EXT4_IOC_TRUNCATE_BLOCK_RANGE:
> +    {
> +        struct truncate_range tr;
> +        ext4_lblk_t last_block, end_block;
> +        int error;
> +        loff_t i_size = i_size_read(inode);
> +
> +        if (!i_size)
> +            return 0;
> +
> +        if (!(filp->f_mode & FMODE_WRITE))
> +            return -EBADF;
> +
> +        if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
> +            return -EPERM;
> +
> +        if (!S_ISREG(inode->i_mode))
> +            return -EOPNOTSUPP;
> +
> +        if (IS_SWAPFILE(inode))
> +            return -EOPNOTSUPP;
> +
> +        if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
> +            return -EOPNOTSUPP;
> +
> +        if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
> +            EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
> +            ext4_msg(sb, KERN_ERR,
> +             "Truncate block range not supported with bigalloc");
> +            return -EOPNOTSUPP;
> +        }
> +
> +        if (copy_from_user(&tr, (const void *) arg,
> +                sizeof(struct truncate_range)))
> +            return -EFAULT;
> +
> +        if (!tr.length)
> +            return -EINVAL;
> +
> +        end_block = tr.start_block + tr.length - 1;
> +
> +        last_block = ((round_up(i_size,
> +                    EXT4_BLOCK_SIZE(inode->i_sb)))
> +                  >> inode->i_blkbits) - 1;
> +        if (tr.start_block > end_block ||
> +            tr.start_block > last_block)
> +            return -EINVAL;
> +
> +        if (end_block > last_block)
> +            end_block = last_block;
> +
> +        error = mnt_want_write_file(filp);
> +        if (error)
> +            return error;
> +
> +        mutex_lock(&inode->i_mutex);
> +        error = ext4_ext_truncate_range(inode, tr.start_block,
> +                        end_block, last_block);
> +        mutex_unlock(&inode->i_mutex);
> +        mnt_drop_write_file(filp);
> +        return error;
> +    }
> 
>    default:
>        return -ENOTTY;
> -- 
> 1.7.9.5
> 
