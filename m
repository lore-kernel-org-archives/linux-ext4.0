From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2] ext4: check inline directory before converting
Date: Fri, 25 Jul 2014 23:57:03 -0600
Message-ID: <1A1C51F5-7756-48FA-ABE0-F7D7B7F4AE0B@dilger.ca>
References: <20140725222356.GK8628@birch.djwong.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:58377 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaGZF5H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jul 2014 01:57:07 -0400
Received: by mail-pa0-f54.google.com with SMTP id fa1so7131357pad.41
        for <linux-ext4@vger.kernel.org>; Fri, 25 Jul 2014 22:57:06 -0700 (PDT)
In-Reply-To: <20140725222356.GK8628@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks. 

I'll see if i can share this with the directory checking code in dir.c,
but for now you can add my:

Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Cheers, Andreas

> On Jul 25, 2014, at 16:23, "Darrick J. Wong" <darrick.wong@oracle.com> wrote:
> 
> Before converting an inline directory to a regular directory, check
> the directory entries to make sure they're not obviously broken.
> This helps us to avoid a BUG_ON if one of the dirents is trashed.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> fs/ext4/dir.c    |   25 +++++++++++++++++++++++++
> fs/ext4/ext4.h   |    2 ++
> fs/ext4/inline.c |   12 ++++++++++++
> 3 files changed, 39 insertions(+)
> 
> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index ef1bed6..0bb3f9e 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -571,6 +571,31 @@ static int ext4_release_dir(struct inode *inode, struct file *filp)
>    return 0;
> }
> 
> +int ext4_check_all_de(struct inode *dir, struct buffer_head *bh, void *buf,
> +              int buf_size)
> +{
> +    struct ext4_dir_entry_2 *de;
> +    int nlen, rlen;
> +    unsigned int offset = 0;
> +    char *top;
> +
> +    de = (struct ext4_dir_entry_2 *)buf;
> +    top = buf + buf_size;
> +    while ((char *) de < top) {
> +        if (ext4_check_dir_entry(dir, NULL, de, bh,
> +                     buf, buf_size, offset))
> +            return -EIO;
> +        nlen = EXT4_DIR_REC_LEN(de->name_len);
> +        rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
> +        de = (struct ext4_dir_entry_2 *)((char *)de + rlen);
> +        offset += rlen;
> +    }
> +    if ((char *) de > top)
> +        return -EIO;
> +
> +    return 0;
> +}
> +
> const struct file_operations ext4_dir_operations = {
>    .llseek        = ext4_dir_llseek,
>    .read        = generic_read_dir,
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 22b790e..4726d5f 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2064,6 +2064,8 @@ static inline  unsigned char get_dtype(struct super_block *sb, int filetype)
> 
>    return ext4_filetype_table[filetype];
> }
> +extern int ext4_check_all_de(struct inode *dir, struct buffer_head *bh,
> +                 void *buf, int buf_size);
> 
> /* fsync.c */
> extern int ext4_sync_file(struct file *, loff_t, loff_t, int);
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 645205d..fc54169 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -1178,6 +1178,18 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
>    if (error < 0)
>        goto out;
> 
> +    /*
> +     * Make sure the inline directory entries pass checks before we try to
> +     * convert them, so that we avoid touching stuff that needs fsck.
> +     */
> +    if (S_ISDIR(inode->i_mode)) {
> +        error = ext4_check_all_de(inode, iloc->bh,
> +                    buf + EXT4_INLINE_DOTDOT_SIZE,
> +                    inline_size - EXT4_INLINE_DOTDOT_SIZE);
> +        if (error)
> +            goto out;
> +    }
> +
>    error = ext4_destroy_inline_data_nolock(handle, inode);
>    if (error)
>        goto out;
