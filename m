From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] ext3: Add journal error check into ext3_rename()
Date: Tue, 23 Nov 2010 13:57:16 +0100
Message-ID: <20101123125716.GE6113@quack.suse.cz>
References: <1290486633-4534-1-git-send-email-namhyung@gmail.com>
 <AANLkTi=Ve03g026yb_x1VMDcuq4nrppuRcovPvDwHEc8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Namhyung Kim <namhyung@gmail.com>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab0KWM5V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Nov 2010 07:57:21 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTi=Ve03g026yb_x1VMDcuq4nrppuRcovPvDwHEc8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Amir,

On Tue 23-11-10 09:58:58, Amir Goldstein wrote:
> A better way to handle this situation is to get_write_access much sooner,
> when things can still be rolled back properly.
> Please find below a patch I am using in next3 to fix some un-handled
> journal errors
> and see if you can/want to use any of it as reference for your patches.
  While generally it is certainly desirable to detect errors early and bail
out without doing harm, in this particular case I don't see a big point
in complicating the code since the only realistic failure case is that the
journal is aborted, we have to run fsck anyway, and we are not causing any
unfixable damage... So I'll take the patch as is.

									Honza

> Some places in Ext3 original code don't check for return value of
> JBD functions.  Check for snapshot/journal errors in those places.
> 
> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
> 
> --------------------------------------------------------------------------------
> diff -Nuarp a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> --- a/fs/ext3/balloc.c  2010-11-23 09:38:13.395922811 +0200
> +++ b/fs/ext3/balloc.c  2010-11-23 09:38:13.185923236 +0200
> @@ -674,7 +674,9 @@ do_more:
> 
>     /* We dirtied the bitmap block */
>     BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
> -   err = ext3_journal_dirty_metadata(handle, bitmap_bh);
> +   ret = ext3_journal_dirty_metadata(handle, bitmap_bh);
> +   if (!err)
> +       err = ret;
> 
>     /* And the group descriptor block */
>     BUFFER_TRACE(gd_bh, "dirtied group descriptor block");
> 
> diff -Nuarp a/fs/ext3/inode.c b/fs/ext3/inode.c
> --- a/fs/ext3/inode.c   2010-11-23 09:38:13.405923214 +0200
> +++ b/fs/ext3/inode.c   2010-11-23 09:38:13.195922747 +0200
> @@ -2362,6 +2362,9 @@ static void ext3_clear_blocks(handle_t
>         if (bh) {
>             BUFFER_TRACE(bh, "retaking write access");
>             ext3_journal_get_write_access_inode(handle, inode, bh);
> +           /* we may have lost write_access on bh */
> +           if (is_handle_aborted(handle))
> +               return;
>         }
>     }
> 
> @@ -2444,6 +2447,9 @@ static void ext3_free_data(handle_t *ha
>                 ext3_clear_blocks(handle, inode, this_bh,
>                           block_to_free,
>                           count, block_to_free_p, p);
> +               /* we may have lost write_access on this_bh */
> +               if (is_handle_aborted(handle))
> +                   return;
>                 block_to_free = nr;
>                 block_to_free_p = p;
>                 count = 1;
> @@ -2454,6 +2460,9 @@ static void ext3_free_data(handle_t *ha
>     if (count > 0)
>         ext3_clear_blocks(handle, inode, this_bh, block_to_free,
>                   count, block_to_free_p, p);
> +   /* we may have lost write_access on this_bh */
> +   if (is_handle_aborted(handle))
> +       return;
> 
>     if (this_bh) {
>         BUFFER_TRACE(this_bh, "call ext3_journal_dirty_metadata");
> 
> diff -Nuarp a/fs/ext3/namei.c b/fs/ext3/namei.c
> --- a/fs/ext3/namei.c   2010-11-23 09:38:13.415922664 +0200
> +++ b/fs/ext3/namei.c   2010-11-23 09:38:13.205923227 +0200
> @@ -1649,8 +1649,12 @@ static int ext3_delete_entry (handle_t
>         if (!ext3_check_dir_entry("ext3_delete_entry", dir, de, bh, i))
>             return -EIO;
>         if (de == de_del)  {
> +           int err;
> +
>             BUFFER_TRACE(bh, "get_write_access");
> -           ext3_journal_get_write_access(handle, bh);
> +           err = ext3_journal_get_write_access(handle, bh);
> +           if (err)
> +               return err;
>             if (pde)
>                 pde->rec_len = ext3_rec_len_to_disk(
>                     ext3_rec_len_from_disk(pde->rec_len) +
> @@ -1797,7 +1801,16 @@ retry:
>         goto out_stop;
>     }
>     BUFFER_TRACE(dir_block, "get_write_access");
> -   ext3_journal_get_write_access(handle, dir_block);
> +   err = ext3_journal_get_write_access(handle, dir_block);
> +   if (err) {
> +       drop_nlink(inode); /* is this nlink == 0? */
> +       unlock_new_inode(inode);
> +       /* no need to check for errors - we failed anyway */
> +       (void) ext3_mark_inode_dirty(handle, inode);
> +       iput(inode);
> +       brelse(dir_block);
> +       goto out_stop;
> +   }
>     de = (struct ext3_dir_entry_2 *) dir_block->b_data;
>     de->inode = cpu_to_le32(inode->i_ino);
>     de->name_len = 1;
> 
> @@ -2337,6 +2350,10 @@ static int ext3_rename (struct inode *
>         if (!new_inode && new_dir!=old_dir &&
>                 new_dir->i_nlink >= EXT3_LINK_MAX)
>             goto end_rename;
> +       BUFFER_TRACE(dir_bh, "get_write_access");
> +       retval = ext3_journal_get_write_access(handle, dir_bh);
> +       if (retval)
> +           goto end_rename;
>     }
>     if (!new_bh) {
>         retval = ext3_add_entry (handle, new_dentry, old_inode);
> @@ -2344,7 +2361,9 @@ static int ext3_rename (struct inode *
>             goto end_rename;
>     } else {
>         BUFFER_TRACE(new_bh, "get write access");
> -       ext3_journal_get_write_access(handle, new_bh);
> +       retval = ext3_journal_get_write_access(handle, new_bh);
> +       if (retval)
> +           goto end_rename;
>         new_de->inode = cpu_to_le32(old_inode->i_ino);
>         if (EXT3_HAS_INCOMPAT_FEATURE(new_dir->i_sb,
>                           EXT3_FEATURE_INCOMPAT_FILETYPE))
> @@ -2401,8 +2420,6 @@ static int ext3_rename (struct inode *
>     old_dir->i_ctime = old_dir->i_mtime = CURRENT_TIME_SEC;
>     ext3_update_dx_flag(old_dir);
>     if (dir_bh) {
> -       BUFFER_TRACE(dir_bh, "get_write_access");
> -       ext3_journal_get_write_access(handle, dir_bh);
>         PARENT_INO(dir_bh->b_data) = cpu_to_le32(new_dir->i_ino);
>         BUFFER_TRACE(dir_bh, "call ext3_journal_dirty_metadata");
>         ext3_journal_dirty_metadata(handle, dir_bh);
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
