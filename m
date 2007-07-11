From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [EXT4 set 7][PATCH 1/1]Remove 32000 subdirs limit.
Date: Tue, 10 Jul 2007 22:40:11 -0700
Message-ID: <20070710224011.e60b9864.akpm@linux-foundation.org>
References: <1183275498.4010.135.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56507 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753186AbXGKFkV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jul 2007 01:40:21 -0400
In-Reply-To: <1183275498.4010.135.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 01 Jul 2007 03:38:18 -0400 Mingming Cao <cmm@us.ibm.com> wrote:

> >From kalpak@clusterfs.com Thu May 17 17:21:08 2007
> Hi,
> 
> I have rebased this patch to 2.6.22-rc1 so that it can be added to the
> ext4 patch queue. It has been tested by creating more than 65000 subdirs
> and then deleting them and checking the nlinks. The e2fsprogs part of
> this patch was sent earlier by me to linux-ext4 and doesn't need any
> changes, so not submitting it again.
> 
> ----------------------------------------------------------------------
> This patch adds support to ext4 for allowing more than 65000
> subdirectories. Currently the maximum number of subdirectories is capped
> at 32000.
> 
> If we exceed 65000 subdirectories in an htree directory it sets the
> inode link count to 1 and no longer counts subdirectories.  The
> directory link count is not actually used when determining if a
> directory is empty, as that only counts subdirectories and not regular
> files that might be in there. 
> 
> A EXT4_FEATURE_RO_COMPAT_DIR_NLINK flag has been added and it is set if
> the subdir count for any directory crosses 65000.
> 

Would I be correct in assuming that a later fsck will clear
EXT4_FEATURE_RO_COMPAT_DIR_NLINK if there are no longer any >65000 subdir
directories?

If so, that is worth a mention in the changelog, perhaps?

Please remind us what is the behaviour of an RO_COMPAT flag?  It means that
old ext4, ext3 and ext2 can only mount this fs read-only, yes?

> 
> Index: linux-2.6.22-rc4/fs/ext4/namei.c
> ===================================================================
> --- linux-2.6.22-rc4.orig/fs/ext4/namei.c	2007-06-14 17:30:47.000000000 -0700
> +++ linux-2.6.22-rc4/fs/ext4/namei.c	2007-06-14 17:32:55.000000000 -0700
> @@ -1619,6 +1619,27 @@ static int ext4_delete_entry (handle_t *
>  	return -ENOENT;
>  }
>  
> +static inline void ext4_inc_count(handle_t *handle, struct inode *inode)
> +{
> +	inc_nlink(inode);
> +	if (is_dx(inode) && inode->i_nlink > 1) {
> +		/* limit is 16-bit i_links_count */
> +		if (inode->i_nlink >= EXT4_LINK_MAX || inode->i_nlink == 2) {
> +			inode->i_nlink = 1;
> +			EXT4_SET_RO_COMPAT_FEATURE(inode->i_sb,
> +					      EXT4_FEATURE_RO_COMPAT_DIR_NLINK);
> +		}
> +	}
> +}

Looks too big to be inlined.

Why do we set EXT4_FEATURE_RO_COMPAT_DIR_NLINK if i_nlink==2?

> +static inline void ext4_dec_count(handle_t *handle, struct inode *inode)
> +{
> +	drop_nlink(inode);
> +	if (S_ISDIR(inode->i_mode) && inode->i_nlink == 0)
> +		inc_nlink(inode);
> +}

Probably too big to inline.

> +
>  static int ext4_add_nondir(handle_t *handle,
>  		struct dentry *dentry, struct inode *inode)
>  {
> @@ -1715,7 +1736,7 @@ static int ext4_mkdir(struct inode * dir
>  	struct ext4_dir_entry_2 * de;
>  	int err, retries = 0;
>  
> -	if (dir->i_nlink >= EXT4_LINK_MAX)
> +	if (EXT4_DIR_LINK_MAX(dir))
>  		return -EMLINK;
>  
>  retry:
> @@ -1738,7 +1759,7 @@ retry:
>  	inode->i_size = EXT4_I(inode)->i_disksize = inode->i_sb->s_blocksize;
>  	dir_block = ext4_bread (handle, inode, 0, 1, &err);
>  	if (!dir_block) {
> -		drop_nlink(inode); /* is this nlink == 0? */
> +		ext4_dec_count(handle, inode); /* is this nlink == 0? */
>  		ext4_mark_inode_dirty(handle, inode);
>  		iput (inode);
>  		goto out_stop;
> @@ -1770,7 +1791,7 @@ retry:
>  		iput (inode);
>  		goto out_stop;
>  	}
> -	inc_nlink(dir);
> +	ext4_inc_count(handle, dir);
>  	ext4_update_dx_flag(dir);
>  	ext4_mark_inode_dirty(handle, dir);
>  	d_instantiate(dentry, inode);
> @@ -2035,10 +2056,10 @@ static int ext4_rmdir (struct inode * di
>  	retval = ext4_delete_entry(handle, dir, de, bh);
>  	if (retval)
>  		goto end_rmdir;
> -	if (inode->i_nlink != 2)
> -		ext4_warning (inode->i_sb, "ext4_rmdir",
> -			      "empty directory has nlink!=2 (%d)",
> -			      inode->i_nlink);
> +	if (!EXT4_DIR_LINK_EMPTY(inode))
> +		ext4_warning(inode->i_sb, "ext4_rmdir",
> +			     "empty directory has too many links (%d)",
> +			     inode->i_nlink);
>  	inode->i_version++;
>  	clear_nlink(inode);
>  	/* There's no need to set i_disksize: the fact that i_nlink is
> @@ -2048,7 +2069,7 @@ static int ext4_rmdir (struct inode * di
>  	ext4_orphan_add(handle, inode);
>  	inode->i_ctime = dir->i_ctime = dir->i_mtime = ext4_current_time(inode);
>  	ext4_mark_inode_dirty(handle, inode);
> -	drop_nlink(dir);
> +	ext4_dec_count(handle, dir);
>  	ext4_update_dx_flag(dir);
>  	ext4_mark_inode_dirty(handle, dir);
>  
> @@ -2099,7 +2120,7 @@ static int ext4_unlink(struct inode * di
>  	dir->i_ctime = dir->i_mtime = ext4_current_time(dir);
>  	ext4_update_dx_flag(dir);
>  	ext4_mark_inode_dirty(handle, dir);
> -	drop_nlink(inode);
> +	ext4_dec_count(handle, inode);
>  	if (!inode->i_nlink)
>  		ext4_orphan_add(handle, inode);
>  	inode->i_ctime = ext4_current_time(inode);
> @@ -2149,7 +2170,7 @@ retry:
>  		err = __page_symlink(inode, symname, l,
>  				mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS);
>  		if (err) {
> -			drop_nlink(inode);
> +			ext4_dec_count(handle, inode);
>  			ext4_mark_inode_dirty(handle, inode);
>  			iput (inode);
>  			goto out_stop;
> @@ -2175,8 +2196,9 @@ static int ext4_link (struct dentry * ol
>  	struct inode *inode = old_dentry->d_inode;
>  	int err, retries = 0;
>  
> -	if (inode->i_nlink >= EXT4_LINK_MAX)
> +	if (EXT4_DIR_LINK_MAX(inode))
>  		return -EMLINK;

argh.  WHY_IS_EXT4_FULL_OF_UPPER_CASE_MACROS_WHICH_COULD_BE_IMPLEMENTED
as_lower_case_inlines?  Sigh.  It's all the old-timers, I guess.

EXT4_DIR_LINK_MAX() is buggy: it evaluates its arg twice.

>  	/*
>  	 * Return -ENOENT if we've raced with unlink and i_nlink is 0.  Doing
>  	 * otherwise has the potential to corrupt the orphan inode list.
> @@ -2194,7 +2216,7 @@ retry:
>  		handle->h_sync = 1;
>  
>  	inode->i_ctime = ext4_current_time(inode);
> -	inc_nlink(inode);
> +	ext4_inc_count(handle, inode);
>  	atomic_inc(&inode->i_count);
>  
>  	err = ext4_add_nondir(handle, dentry, inode);
> @@ -2327,7 +2349,7 @@ static int ext4_rename (struct inode * o
>  	}
>  
>  	if (new_inode) {
> -		drop_nlink(new_inode);
> +		ext4_dec_count(handle, new_inode);
>  		new_inode->i_ctime = ext4_current_time(new_inode);
>  	}
>  	old_dir->i_ctime = old_dir->i_mtime = ext4_current_time(old_dir);
> @@ -2338,11 +2360,13 @@ static int ext4_rename (struct inode * o
>  		PARENT_INO(dir_bh->b_data) = cpu_to_le32(new_dir->i_ino);
>  		BUFFER_TRACE(dir_bh, "call ext4_journal_dirty_metadata");
>  		ext4_journal_dirty_metadata(handle, dir_bh);
> -		drop_nlink(old_dir);
> +		ext4_dec_count(handle, old_dir);
>  		if (new_inode) {
> -			drop_nlink(new_inode);
> +			/* checked empty_dir above, can't have another parent,
> +			 * ext3_dec_count() won't work for many-linked dirs */
> +			new_inode->i_nlink = 0;
>  		} else {
> -			inc_nlink(new_dir);
> +			ext4_inc_count(handle, new_dir);
>  			ext4_update_dx_flag(new_dir);
>  			ext4_mark_inode_dirty(handle, new_dir);
>  		}
