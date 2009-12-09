From: Jan Kara <jack@suse.cz>
Subject: Re: [patch 4/5] ext2: convert to use the new truncate convention
Date: Wed, 9 Dec 2009 15:57:13 +0100
Message-ID: <20091209145713.GD7044@quack.suse.cz>
References: <20091208083832.GA19823@wotan.suse.de>
 <20091208084209.GD19823@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:59030 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756171AbZLIQKz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Dec 2009 11:10:55 -0500
Content-Disposition: inline
In-Reply-To: <20091208084209.GD19823@wotan.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 08-12-09 09:42:09, Nick Piggin wrote:
> I also have commented a possible bug in existing ext2 code, marked with XXX.
> 
> Cc: linux-ext4@vger.kernel.org
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Nick Piggin <npiggin@suse.de>
...
> @@ -752,8 +764,8 @@ int __ext2_write_begin(struct file *file
>  		loff_t pos, unsigned len, unsigned flags,
>  		struct page **pagep, void **fsdata)
>  {
> -	return block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
> -							ext2_get_block);
> +	return block_write_begin_newtrunc(file, mapping, pos, len, flags,
> +					pagep, fsdata, ext2_get_block);
>  }
  OK, but you should update the code in dir.c using __ext2_write_begin,
shouldn't you?

> +static int ext2_write_end(struct file *file, struct address_space *mapping,
> +			loff_t pos, unsigned len, unsigned copied,
> +			struct page *page, void *fsdata)
> +{
> +	int ret;
> +
> +	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
> +	if (ret < len)
> +		ext2_write_failed(mapping, pos + len);
> +	return ret;
>  }
  OK, when doing this, please also update ext2_commit_chunk in dir.c...

> +static void ext2_truncate_blocks(struct inode *inode, loff_t offset)
> +{
> +	/*
> +	 * XXX: it seems like a bug here that we don't allow
> +	 * IS_APPEND inode to have blocks-past-i_size trimmed off.
> +	 * review and fix this.
> +	 *
> +	 * Also would be nice to be able to handle IO errors and such,
> +	 * but that's probably too much to ask.
> +	 */
> +	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
> +	    S_ISLNK(inode->i_mode)))
> +		return;
> +	if (ext2_inode_is_fast_symlink(inode))
> +		return;
> +	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
> +		return;
  Yes, I'd remove IS_APPEND check from here.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
