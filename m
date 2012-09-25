From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH] ext4: ext4_bread usage audit
Date: Tue, 25 Sep 2012 08:38:00 +0200
Message-ID: <40876F63-B2FD-4C58-B39E-5409EE4BAFA8@whamcloud.com>
References: <1348512100-23323-1-git-send-email-cmaiolino@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60002 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab2IYGiD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2012 02:38:03 -0400
Received: by wibhr7 with SMTP id hr7so132797wib.1
        for <linux-ext4@vger.kernel.org>; Mon, 24 Sep 2012 23:38:01 -0700 (PDT)
In-Reply-To: <1348512100-23323-1-git-send-email-cmaiolino@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-09-24, at 20:41, Carlos Maiolino <cmaiolino@redhat.com> wrote:

> Audit the usage of ext4_bread() due a possible misinterpretion of its return
> value.
> Focused on directory blocks, a NULL value returned from ext4_bread() means a
> hole, which cannot exist into a directory inode. It can pass undetected after a
> fix in an uninitialized error variable.
> 
> The (now) initialized variable into ext4_getblk() may lead to a zero'ed return
> value of ext4_bread() to its callers, which can make the caller do not detect
> the hole in the directory inode.
> 
> This checks for directory holes when buffer_head and error value are both
> zero'ed returning -EIO to their callers
> 
> Some ext4_bread callers do not needed any changes either because they already
> had its own hole detector paths or because these are deprecaded (like
> dx_show_entries)

Note that in the "errors=continue" case, it is desirable to allow the Filesystem to continue even if a hole is found in the directory, at least for non-htree directories, since it is possible the the entry being looked up is in a different block. 

> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> fs/ext4/namei.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++++--------
> 1 file changed, 69 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 2a42cc0..1d5619b 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -67,6 +67,11 @@ static struct buffer_head *ext4_append(handle_t *handle,
>            bh = NULL;
>        }
>    }
> +    if (!bh && !(*err)) {
> +        *err = -EIO;
> +        ext4_error(inode->i_sb, "Directory hole detected on inode %lu\n",
> +               inode->i_ino);
> +    }
>    return bh;
> }
> 
> @@ -696,8 +701,11 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
>        frame->entries = entries;
>        frame->at = at;
>        if (!indirect--) return frame;
> -        if (!(bh = ext4_bread (NULL,dir, dx_get_block(at), 0, err)))
> +        if (!(bh = ext4_bread (NULL,dir, dx_get_block(at), 0, err))) {

Please keep the original code style, do not Di the assignment inside the if() check.  That is incorrect in several places in this patch. 

> +            if (!(*err))
> +                *err = ERR_BAD_DX_DIR;
>            goto fail2;
> +        }
>        at = entries = ((struct dx_node *) bh->b_data)->entries;
> 
>        if (!buffer_verified(bh) &&
> @@ -807,8 +815,15 @@ static int ext4_htree_next_block(struct inode *dir, __u32 hash,
>     */
>    while (num_frames--) {
>        if (!(bh = ext4_bread(NULL, dir, dx_get_block(p->at),
> -                      0, &err)))
> +                      0, &err))) {
> +            if (!err) {
> +                ext4_error(dir->i_sb,
> +                       "Directory hole detected on inode %lu\n",
> +                       dir->i_ino);
> +                return -EIO;
> +            }
>            return err; /* Failure */
> +        }
> 
>        if (!buffer_verified(bh) &&
>            !ext4_dx_csum_verify(dir,
> @@ -843,8 +858,14 @@ static int htree_dirblock_to_tree(struct file *dir_file,
> 
>    dxtrace(printk(KERN_INFO "In htree dirblock_to_tree: block %lu\n",
>                            (unsigned long)block));
> -    if (!(bh = ext4_bread (NULL, dir, block, 0, &err)))
> +    if (!(bh = ext4_bread (NULL, dir, block, 0, &err))) {
> +        if (!err) {
> +            err = -EIO;
> +            ext4_error(dir->i_sb, "Directory hole detected on inode %lu\n",
> +                                   dir->i_ino);
> +        }
>        return err;
> +    }
> 
>    if (!buffer_verified(bh) &&
>        !ext4_dirent_csum_verify(dir, (struct ext4_dir_entry *)bh->b_data))
> @@ -1267,8 +1288,15 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir, const struct q
>        return NULL;
>    do {
>        block = dx_get_block(frame->at);
> -        if (!(bh = ext4_bread(NULL, dir, block, 0, err)))
> +        if (!(bh = ext4_bread(NULL, dir, block, 0, err))) {
> +            if (!(*err)) {
> +                *err = -EIO;
> +                ext4_error(dir->i_sb,
> +                       "Directory hole detected on inode %lu\n",
> +                       dir->i_ino);
> +            }
>            goto errout;
> +        }
> 
>        if (!buffer_verified(bh) &&
>            !ext4_dirent_csum_verify(dir,
> @@ -1801,9 +1829,15 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
>    }
>    blocks = dir->i_size >> sb->s_blocksize_bits;
>    for (block = 0; block < blocks; block++) {
> -        bh = ext4_bread(handle, dir, block, 0, &retval);
> -        if(!bh)
> +        if (!(bh = ext4_bread(handle, dir, block, 0, &retval))) {
> +            if (!retval) {
> +                retval = -EIO;
> +                ext4_error(inode->i_sb,
> +                       "Directory hole detected on inode %lu\n",
> +                       inode->i_ino);
> +            }
>            return retval;
> +        }
>        if (!buffer_verified(bh) &&
>            !ext4_dirent_csum_verify(dir,
>                (struct ext4_dir_entry *)bh->b_data))
> @@ -1860,8 +1894,15 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
>    entries = frame->entries;
>    at = frame->at;
> 
> -    if (!(bh = ext4_bread(handle,dir, dx_get_block(frame->at), 0, &err)))
> +    if (!(bh = ext4_bread(handle,dir, dx_get_block(frame->at), 0, &err))) {
> +        if (!err) {
> +            err = -EIO;
> +            ext4_error(dir->i_sb,
> +                   "Directory hole detected on inode %lu\n",
> +                   dir->i_ino);
> +        }
>        goto cleanup;
> +    }
> 
>    if (!buffer_verified(bh) &&
>        !ext4_dirent_csum_verify(dir, (struct ext4_dir_entry *)bh->b_data))
> @@ -2199,9 +2240,15 @@ retry:
>    inode->i_op = &ext4_dir_inode_operations;
>    inode->i_fop = &ext4_dir_operations;
>    inode->i_size = EXT4_I(inode)->i_disksize = inode->i_sb->s_blocksize;
> -    dir_block = ext4_bread(handle, inode, 0, 1, &err);
> -    if (!dir_block)
> +    if (!(dir_block = ext4_bread(handle, inode, 0, 1, &err))) {
> +        if (!err) {
> +            err = -EIO;
> +            ext4_error(inode->i_sb,
> +                   "Directory hole detected on inode %lu\n",
> +                   inode->i_ino);
> +        }
>        goto out_clear_inode;
> +    }
>    BUFFER_TRACE(dir_block, "get_write_access");
>    err = ext4_journal_get_write_access(handle, dir_block);
>    if (err)
> @@ -2318,6 +2365,11 @@ static int empty_dir(struct inode *inode)
>                    EXT4_ERROR_INODE(inode,
>                        "error %d reading directory "
>                        "lblock %u", err, lblock);
> +                else
> +                                ext4_warning(inode->i_sb,
> +                        "bad directory (dir #%lu) - no data block",
> +                        inode->i_ino);
> +
>                offset += sb->s_blocksize;
>                continue;
>            }
> @@ -2826,9 +2878,15 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
>                goto end_rename;
>        }
>        retval = -EIO;
> -        dir_bh = ext4_bread(handle, old_inode, 0, 0, &retval);
> -        if (!dir_bh)
> +        if(!(dir_bh = ext4_bread(handle, old_inode, 0, 0, &retval))) {
> +            if (!retval) {
> +                retval = -EIO;
> +                ext4_error(old_inode->i_sb,
> +                       "Directory hole detected on inode %lu\n",
> +                       old_inode->i_ino);
> +            }
>            goto end_rename;
> +        }
>        if (!buffer_verified(dir_bh) &&
>            !ext4_dirent_csum_verify(old_inode,
>                (struct ext4_dir_entry *)dir_bh->b_data))
> -- 
> 1.7.11.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
