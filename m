Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FD23E63BA;
	Mon, 11 May 2026 13:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778506054; cv=none; b=K4+McriWmtM9FjonAVNdft1pkEOqLKjs5Oxhh3TokOAnJyWf7QioNBp2pueUXCE1glZLsILNREg8LiJak6FXjMrBxS6WuGTnf8G6azbwdxEtyXHsgIWFcP3dPoZYa+P9M9gIct6NNUZOXC2fUiWTiUf8LzOKc+21iV4Z25Xu0W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778506054; c=relaxed/simple;
	bh=i8WNCUdJQW2hyM4tLIaFyiasEFPYq3SJAENo/R8jExE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cnvokvZd/QhK5zsBn4Hj4JfpyRXh8rLw4YZMm5RbGq7W9EyeLvnu8vmELUFjVQSxZJ51I7nI7dxXN2PegaL/TBzE9mlvCA/f1Anjq7ZfGcNoUkeV9lhI7o17fXugF9bvl7EZE2+d/xBtt5hXDjJWss1N7vT1WDybzMuSz6VBSv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ksnhIwZM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ksnhIwZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D508DC2BCB0;
	Mon, 11 May 2026 13:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778506054;
	bh=i8WNCUdJQW2hyM4tLIaFyiasEFPYq3SJAENo/R8jExE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ksnhIwZMvHyGeo7ZWBiAwHtheHxVOb7qxM91OkBbbozFU0OIK3hfOTv5fpQZCGLKH
	 FUL0M4bg1nsn+DJLxZ6aI4IRmGc7yoy1Pgyibbez3miWWpfLZS/oE8ofxLFfFjLQ6m
	 OMbP2qMfJiV+R90AoqmuXckeTCYrr7i54zulm58JeQoQ8faua2oYQdfO1FWcVEi4ux
	 qc8cxDaKq+5N3XDl0chWNIGlGe2AmT3/lfgWkH76ZOygCSv8fWbducUMuCXwd6OzSh
	 lroW9M6KeolPc+cVguLhFvaBdVJ0E/gAKwDF9CzpHuLsjmGse/2ZmeA3ngqhyXEU2L
	 V7UGB0v1MNG3g==
Date: Mon, 11 May 2026 15:27:30 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, aivazian.tigran@gmail.com, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 3/9] fs: Writeout inode buffer from mmb_sync()
Message-ID: <20260511-marder-showprogramm-9c7a3198ef15@brauner>
References: <20260511115725.28441-1-jack@suse.cz>
 <20260511121356.241821-12-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260511121356.241821-12-jack@suse.cz>

On Mon, May 11, 2026 at 02:13:53PM +0200, Jan Kara wrote:
> Currently metadata bh tracking does not track inode buffers because they
> are usually shared by several inodes and so our linked list tracking
> cannot be used. On fsync we call sync_inode_metadata() to write inode
> instead where filesystems' .write_inode methods detect data integrity
> writeback and take care to submit inode buffer to disk and wait for it
> in that case. This is however racy as for example flush worker can
> submit normal (WB_SYNC_NONE) inode writeback first, which makes the
> inode clean and copies the inode to the buffer but doesn't submit the
> buffer for IO. Thus sync_inode_metadata() call does nothing and we fail
> to persist inode buffer to disk on fsync(2).
> 
> Fix the problem by allowing filesystem to set the number of block backing
> the inode in mmb structure and mmb_sync() then takes care to writeout
> corresponding buffer and wait for it.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/buffer.c        | 34 +++++++++++++++++++++++-----------
>  include/linux/fs.h |  1 +
>  2 files changed, 24 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index b0b3792b1496..dba29a45346b 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -477,12 +477,14 @@ EXPORT_SYMBOL(mark_buffer_async_write);
>   * using RCU, grab the lock, verify we didn't race with somebody detaching the
>   * bh / moving it to different inode and only then proceeding.
>   */
> +#define INVALID_BLK (~0ULL)
>  
>  void mmb_init(struct mapping_metadata_bhs *mmb, struct address_space *mapping)
>  {
>  	spin_lock_init(&mmb->lock);
>  	INIT_LIST_HEAD(&mmb->list);
>  	mmb->mapping = mapping;
> +	mmb->inode_blk = INVALID_BLK;
>  }
>  EXPORT_SYMBOL(mmb_init);
>  
> @@ -593,8 +595,18 @@ int mmb_sync(struct mapping_metadata_bhs *mmb)
>  			}
>  		}
>  	}
> -
>  	spin_unlock(&mmb->lock);
> +
> +	/* Writeout inode buffer head */
> +	if (mmb->inode_blk != INVALID_BLK) {
> +		bh = sb_find_get_block(mmb->mapping->host->i_sb, mmb->inode_blk);
> +		write_dirty_buffer(bh, REQ_SYNC);
> +		wait_on_buffer(bh);
> +		if (!buffer_uptodate(bh))
> +			err = -EIO;
> +		brelse(bh);
> +	}
> +
>  	blk_finish_plug(&plug);
>  	spin_lock(&mmb->lock);
>  
> @@ -646,18 +658,18 @@ int mmb_fsync_noflush(struct file *file, struct mapping_metadata_bhs *mmb,
>  	if (err)
>  		return err;
>  
> -	if (mmb)
> -		ret = mmb_sync(mmb);
>  	if (!(inode_state_read_once(inode) & I_DIRTY_ALL))
> -		goto out;
> +		goto sync_buffers;
>  	if (datasync && !(inode_state_read_once(inode) & I_DIRTY_DATASYNC))
> -		goto out;
> -
> -	err = sync_inode_metadata(inode, 1);
> -	if (ret == 0)
> -		ret = err;
> -
> -out:
> +		goto sync_buffers;
> +
> +	ret = sync_inode_metadata(inode, 1);
> +sync_buffers:
> +	if (mmb) {
> +		err = mmb_sync(mmb);
> +		if (ret == 0)
> +			ret = err;
> +	}
>  	/* check and advance again to catch errors after syncing out buffers */
>  	err = file_check_and_advance_wb_err(file);
>  	if (ret == 0)
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 11559c513dfb..435a41e4c90f 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -446,6 +446,7 @@ extern const struct address_space_operations empty_aops;
>  /* Structure for tracking metadata buffer heads associated with the mapping */
>  struct mapping_metadata_bhs {
>  	struct address_space *mapping;	/* Mapping bhs are associated with */
> +	sector_t inode_blk;	/* Number of block containing the inode */

This is great, thanks!
