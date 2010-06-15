From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: remove vestiges of nobh support
Date: Tue, 15 Jun 2010 16:12:34 +0200
Message-ID: <20100615141234.GD18513@atrey.karlin.mff.cuni.cz>
References: <20100607082039.GA29155@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:46601 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757846Ab0FOOMf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jun 2010 10:12:35 -0400
Content-Disposition: inline
In-Reply-To: <20100607082039.GA29155@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> The nobh option was only supported for writeback mode, but given that all
> write paths (except mmapped writed) actually create buffer heads, it
> effectively was a no-op already.
  Thanks. Merged into my tree.

								Honza
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/fs/ext3/inode.c
> ===================================================================
> --- linux-2.6.orig/fs/ext3/inode.c	2010-06-07 09:56:07.519275527 +0200
> +++ linux-2.6/fs/ext3/inode.c	2010-06-07 09:56:35.267022978 +0200
> @@ -1625,10 +1625,7 @@ static int ext3_writeback_writepage(stru
>  		goto out_fail;
>  	}
>  
> -	if (test_opt(inode->i_sb, NOBH) && ext3_should_writeback_data(inode))
> -		ret = nobh_writepage(page, ext3_get_block, wbc);
> -	else
> -		ret = block_write_full_page(page, ext3_get_block, wbc);
> +	ret = block_write_full_page(page, ext3_get_block, wbc);
>  
>  	err = ext3_journal_stop(handle);
>  	if (!ret)
> @@ -1922,17 +1919,6 @@ static int ext3_block_truncate_page(hand
>  	length = blocksize - (offset & (blocksize - 1));
>  	iblock = index << (PAGE_CACHE_SHIFT - inode->i_sb->s_blocksize_bits);
>  
> -	/*
> -	 * For "nobh" option,  we can only work if we don't need to
> -	 * read-in the page - otherwise we create buffers to do the IO.
> -	 */
> -	if (!page_has_buffers(page) && test_opt(inode->i_sb, NOBH) &&
> -	     ext3_should_writeback_data(inode) && PageUptodate(page)) {
> -		zero_user(page, offset, length);
> -		set_page_dirty(page);
> -		goto unlock;
> -	}
> -
>  	if (!page_has_buffers(page))
>  		create_empty_buffers(page, blocksize, 0);
>  
> Index: linux-2.6/fs/ext3/super.c
> ===================================================================
> --- linux-2.6.orig/fs/ext3/super.c	2010-06-07 09:56:07.529254714 +0200
> +++ linux-2.6/fs/ext3/super.c	2010-06-07 09:56:35.268023746 +0200
> @@ -661,9 +661,6 @@ static int ext3_show_options(struct seq_
>  	 */
>  	seq_puts(seq, ",barrier=");
>  	seq_puts(seq, test_opt(sb, BARRIER) ? "1" : "0");
> -	if (test_opt(sb, NOBH))
> -		seq_puts(seq, ",nobh");
> -
>  	seq_printf(seq, ",data=%s", data_mode_string(test_opt(sb, DATA_FLAGS)));
>  	if (test_opt(sb, DATA_ERR_ABORT))
>  		seq_puts(seq, ",data_err=abort");
> @@ -1255,10 +1252,12 @@ set_qf_format:
>  			*n_blocks_count = option;
>  			break;
>  		case Opt_nobh:
> -			set_opt(sbi->s_mount_opt, NOBH);
> +			ext3_msg(sb, KERN_WARNING,
> +				"warning: ignoring deprecated nobh option");
>  			break;
>  		case Opt_bh:
> -			clear_opt(sbi->s_mount_opt, NOBH);
> +			ext3_msg(sb, KERN_WARNING,
> +				"warning: ignoring deprecated bh option");
>  			break;
>  		default:
>  			ext3_msg(sb, KERN_ERR,
> @@ -2001,14 +2000,6 @@ static int ext3_fill_super (struct super
>  		break;
>  	}
>  
> -	if (test_opt(sb, NOBH)) {
> -		if (!(test_opt(sb, DATA_FLAGS) == EXT3_MOUNT_WRITEBACK_DATA)) {
> -			ext3_msg(sb, KERN_WARNING,
> -				"warning: ignoring nobh option - "
> -				"it is supported only with writeback mode");
> -			clear_opt(sbi->s_mount_opt, NOBH);
> -		}
> -	}
>  	/*
>  	 * The journal_load will have done any necessary log recovery,
>  	 * so we can safely mount the rest of the filesystem now.
> Index: linux-2.6/include/linux/ext3_fs.h
> ===================================================================
> --- linux-2.6.orig/include/linux/ext3_fs.h	2010-06-07 09:56:07.540254365 +0200
> +++ linux-2.6/include/linux/ext3_fs.h	2010-06-07 09:56:35.270022978 +0200
> @@ -400,7 +400,6 @@ struct ext3_inode {
>  #define EXT3_MOUNT_POSIX_ACL		0x08000	/* POSIX Access Control Lists */
>  #define EXT3_MOUNT_RESERVATION		0x10000	/* Preallocation */
>  #define EXT3_MOUNT_BARRIER		0x20000 /* Use block barriers */
> -#define EXT3_MOUNT_NOBH			0x40000 /* No bufferheads */
>  #define EXT3_MOUNT_QUOTA		0x80000 /* Some quota option set */
>  #define EXT3_MOUNT_USRQUOTA		0x100000 /* "old" user quota */
>  #define EXT3_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
