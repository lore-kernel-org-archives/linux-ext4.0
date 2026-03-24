Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FF53A5E8A;
	Tue, 24 Mar 2026 05:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774331487; cv=none; b=osyqFQmteTsK47cO/TPW4rb4lxh1Wjjy/ETmpnQjhOquicA7SiSyu1nuzVmgq7nK94x7e8iZPkaZ1uCVj/gF1sLnqgl+O1dWxCVepLs4US1RGnUgEvLUWktIZqkPD2UD1V7WZsqlyyW+Hwnz0EPq5MZCbLXVN5aQVlD+prPZQ3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774331487; c=relaxed/simple;
	bh=xgm8yDtsP2oOPpWnjr7uikaXyzrYeDANS3MKapyNkCk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fCoenj5qwVYZ+HR6IjLGvu7o5+QXOnf9MIea8UG6XuFD3vmHvPjzqzrcvgf0zjBhXX3Urzn3NWf6/0bYZOvLxDd1SvZM8657MQ4SM7c0oB4mp2kuf1DeRhAMCeoj30jZzyglCJBfUznvP6MryQ0tNTdmo75SIvi7Ikams4O1Kxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CurszMOX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CurszMOX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8Qhcwd5bLWmbX4iOORTI1ctkG6Y56agSySiJ3Dl8qJw=; b=CurszMOXNg4J0vooSV/GEEJb0H
	t0clDvt0GRpK6YgFOCkmeiOpbZ+KLmgsfcldobKYgygUKeIj1elktK0oh1OG9bMsaB/BuLlgQR00L
	swmC6PtZbsUUkqqbYdliD2a3B9ZULcveD5z7+rdx6Bv06HD5BiIcPiB0XcWIKx7xgLAzSaEzHEBYR
	dkk5q3CSK+k1klVE+0rrD+qGTLfTBIjX5yoxwVL/lmh6HS/98tuEJ3vQUynTYPXYtcn9VV9jmFQYN
	vmDERM7EEBL6dZXgm16Q3bsCZApUah+fdc0GheVqN+t0G8+09PkgT31FpfHQTPEzdirxctCbXpvva
	ne3uHj1w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4ufk-00000000cbP-0HAz;
	Tue, 24 Mar 2026 05:51:24 +0000
Date: Mon, 23 Mar 2026 22:51:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 31/41] fs: Provide functions for handling
 mapping_metadata_bhs directly
Message-ID: <acImXDl7MTsmVK_U@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-72-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-72-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 20, 2026 at 02:41:26PM +0100, Jan Kara wrote:
> As part of transition toward moving mapping_metadata_bhs to fs-private
> part of the inode, provide functions for operations on this list
> directly instead of going through the inode / mapping.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/buffer.c                 | 93 +++++++++++++++++--------------------
>  include/linux/buffer_head.h | 45 ++++++++++++++----
>  2 files changed, 80 insertions(+), 58 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index c70f8027bdd1..43aca5b7969f 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -467,31 +467,25 @@ EXPORT_SYMBOL(mark_buffer_async_write);
>   * a successful fsync().  For example, ext2 indirect blocks need to be
>   * written back and waited upon before fsync() returns.
>   *
> - * The functions mark_buffer_dirty_inode(), fsync_inode_buffers(),
> - * mmb_has_buffers() and invalidate_inode_buffers() are provided for the
> - * management of a list of dependent buffers in mapping_metadata_bhs struct.
> + * The functions mmb_mark_buffer_dirty(), mmb_sync_buffers(), mmb_has_buffers()
> + * and mmb_invalidate_buffers() are provided for the management of a list of
> + * dependent buffers in mapping_metadata_bhs struct.
>   *
>   * The locking is a little subtle: The list of buffer heads is protected by
>   * the lock in mapping_metadata_bhs so functions coming from bdev mapping
>   * (such as try_to_free_buffers()) need to safely get to mapping_metadata_bhs
>   * using RCU, grab the lock, verify we didn't race with somebody detaching the
>   * bh / moving it to different inode and only then proceeding.
> - *
> - * FIXME: mark_buffer_dirty_inode() is a data-plane operation.  It should
> - * take an address_space, not an inode.  And it should be called
> - * mark_buffer_dirty_fsync() to clearly define why those buffers are being
> - * queued up.
> - *
> - * FIXME: mark_buffer_dirty_inode() doesn't need to add the buffer to the
> - * list if it is already on a list.  Because if the buffer is on a list,
> - * it *must* already be on the right one.  If not, the filesystem is being
> - * silly.  This will save a ton of locking.  But first we have to ensure
> - * that buffers are taken *off* the old inode's list when they are freed
> - * (presumably in truncate).  That requires careful auditing of all
> - * filesystems (do it inside bforget()).  It could also be done by bringing
> - * b_inode back.
>   */
>  
> +void mmb_init(struct mapping_metadata_bhs *mmb, struct address_space *mapping)
> +{
> +	spin_lock_init(&mmb->lock);
> +	INIT_LIST_HEAD(&mmb->list);
> +	mmb->mapping = mapping;
> +}
> +EXPORT_SYMBOL(mmb_init);
> +
>  static void __remove_assoc_queue(struct mapping_metadata_bhs *mmb,
>  			         struct buffer_head *bh)
>  {
> @@ -533,12 +527,12 @@ bool mmb_has_buffers(struct mapping_metadata_bhs *mmb)
>  EXPORT_SYMBOL_GPL(mmb_has_buffers);
>  
>  /**
> - * sync_mapping_buffers - write out & wait upon a mapping's "associated" buffers
> - * @mapping: the mapping which wants those buffers written
> + * mmb_sync_buffers - write out & wait upon all buffers in a list
> + * @mmb: the list of buffers to write
>   *
> - * Starts I/O against the buffers at mapping->i_metadata_bhs and waits upon
> - * that I/O. Basically, this is a convenience function for fsync().  @mapping
> - * is a file or directory which needs those buffers to be written for a
> + * Starts I/O against the buffers in the given list and waits upon
> + * that I/O. Basically, this is a convenience function for fsync().  @mmb is
> + * for a file or directory which needs those buffers to be written for a
>   * successful fsync().
>   *
>   * We have conflicting pressures: we want to make sure that all
> @@ -553,9 +547,8 @@ EXPORT_SYMBOL_GPL(mmb_has_buffers);
>   * buffer stays on our list until IO completes (at which point it can be
>   * reaped).
>   */
> -int sync_mapping_buffers(struct address_space *mapping)
> +int mmb_sync_buffers(struct mapping_metadata_bhs *mmb)

mmb and buffers in the same name feels a bit redundant.

mmc_sync_all?  mapping_sync_buffers?

> +int generic_mmb_fsync_noflush(struct file *file,
> +			      struct mapping_metadata_bhs *mmb,
> +			      loff_t start, loff_t end, bool datasync)

mmb_fsync?  mapping_buffers_fsync?

> +int generic_mmb_fsync(struct file *file, struct mapping_metadata_bhs *mmb,
> +		      loff_t start, loff_t end, bool datasync)
>  {
>  	struct inode *inode = file->f_mapping->host;
>  	int ret;
>  
> -	ret = generic_buffers_fsync_noflush(file, start, end, datasync);
> +	ret = generic_mmb_fsync_noflush(file, mmb, start, end, datasync);
>  	if (!ret)
>  		ret = blkdev_issue_flush(inode->i_sb->s_bdev);
>  	return ret;
>  }
> -EXPORT_SYMBOL(generic_buffers_fsync);
> +EXPORT_SYMBOL(generic_mmb_fsync);

Same naming, but do we even need this function?  One the
mapping_metadata_bhs has to be passed in, the file system needs a
wrapper anyway, at which point open coding the flush is not really
much of a burden.

